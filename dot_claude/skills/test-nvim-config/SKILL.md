---
name: test-nvim-config
description: Verify Neovim config changes by driving a tmux+nvim --listen harness over RPC, capturing both rendered output and structured state.
disable-model-invocation: true
argument-hint: "[behavior to verify, free-form]"
---

Verify a Neovim config change by spawning a real `nvim --listen` instance inside a detached tmux session, then driving it via RPC. Two channels: `tmux capture-pane` for rendered output, `nvim --remote-expr` for structured state (diagnostics, mappings, messages, plugin load state).

The harness lives at `~/.claude/skills/test-nvim-config/harness.sh`. All examples below assume that path; alias it as `H` in the shell if useful.

## When to use

After any non-trivial change under `dot_config/nvim/`:

- keymap added / removed / changed
- plugin spec added / removed / `opts` reconfigured
- LSP config touched (`lsp/*.lua` or `lua/user/lsp.lua`)
- autocmd or augroup added
- option changed in `lua/user/options.lua`

Skip for pure formatting (StyLua-only), comment edits, or README updates.

## Hazards in this repo

These are properties of the user's actual config, not hypotheticals. The harness respects them; you should too.

1. **`<leader>re` is bound to `:restart`** (`dot_config/nvim/lua/user/keymaps.lua:42`). Sending `<Space>re` would kill the harness. The `send` subcommand denylists this and other destructive sequences (`:restart`, `:qa`, `:wqa`, `ZZ`, `ZQ`, `:q!`).
2. **`vim.o.ch = 0`** (`dot_config/nvim/init.lua:33`). The cmdline is hidden. **`tmux capture-pane` will not show error messages, `:echo` output, or `:messages`.** To inspect those, use `eval` with `vim.api.nvim_exec2("messages", {output=true}).output`.
3. **`chezmoi apply` autocmd** (`dot_config/nvim/init.lua:38-57`) fires on `BufWritePost` for any file under `~/.local/share/chezmoi/*` (excluding `.git/` and `.claude/`). Never write fixture files inside the repo. The harness defaults to `${TMPDIR}/claude-nvim-fixtures-default-$$/` which is safe.
4. **lazy.nvim defers most plugins** (`dot_config/nvim/lua/user/plugin_manager.lua`). Plugins gated on `event=`, `ft=`, or `cmd=` are not loaded at startup. To exercise a plugin's keymap, first put nvim into the right state (open a buffer of the matching filetype, etc.).
5. **LSP attach is async.** `vim.lsp.get_clients({bufnr=0})` is empty until `LspAttach` fires. Wrap polls in `vim.wait(...)` server-side.

## Workflow

```sh
H=~/.claude/skills/test-nvim-config/harness.sh

$H start            # spawn detached tmux session running nvim --listen
$H ready            # block until VimEnter + lazy.nvim are ready (15s default)
# … set up state, run assertions …
$H capture          # rendered pane content (note hazard #2)
$H stop             # kill session iff no clients attached, then clean up
```

`ready` failing is itself the first useful signal — it means your edit broke startup. Run `$H logs` to see the stderr.

## Subcommand contract

- `start [--cwd DIR]` — spawn. State file at `${TMPDIR}/claude-nvim-default.state`.
- `ready [--timeout SEC]` — exits 0 on success, 1 on timeout (with logs).
- `send '<keys>'` — `nvim --remote-send` after denylist check. Use `<Space>` not `<Leader>`; angle-notation works (`<CR>`, `<Esc>`, `<C-w>`, etc.).
- `eval '<lua>'` — runs Lua in the server, prints **JSON** on stdout. Single-line input without a leading keyword (`return`, `local`, `if`, `for`, `while`, `do`) auto-gets `return ` prepended. Multi-line input is left as-is — write `return …` explicitly where you want a value.
- `capture [--lines N] [--ansi]` — `tmux capture-pane -p -J -S -N`. Default 200 lines.
- `logs` — `cat` the nvim stderr log.
- `stop` — refuses if `tmux list-clients` shows the user attached.
- `status` — list active and dead harnesses.
- `attach` — print the `tmux attach` command (does not attach for you).

Multiple concurrent harnesses: set `CLAUDE_NVIM_NAME=foo` in the env.

## Recipes

### Did nvim start cleanly?

```sh
$H start && $H ready
$H eval 'vim.v.errmsg'                                       # expect ""
$H eval 'vim.api.nvim_exec2("messages", {output=true}).output'  # expect no errors
```

### Verify a normal-mode keymap (registration + behavior)

Both layers matter — registration alone proves the spec parsed; behavior alone could mask an errmsg.

```sh
# Registration: maparg key strings use raw <leader> resolution — Space leader
# means the lookup key is " gd" (literal leading space).
$H eval 'vim.fn.maparg(" gd", "n", false, true)'
# expect a dict with .desc and .rhs / .callback set

# Behavior: open a fixture file, send the keys, read the side effect.
$H send ':e fixture.go<CR>'
$H send '<Space>gd'
$H eval 'return { ft = vim.bo.filetype, name = vim.api.nvim_buf_get_name(0), errmsg = vim.v.errmsg }'
```

### Verify LSP attaches for a filetype

```sh
$H send ':e fixture.go<CR>'
$H eval '
return vim.wait(5000, function()
  return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end, 50) and vim.lsp.get_clients({ bufnr = 0 })[1].name or "TIMEOUT"
'
```

`gopls` may need a `go.mod`-rooted file to attach in workspace mode. Without one, attach can be no-op or single-file mode depending on the gopls version.

### Verify a plugin loaded (lazy)

```sh
$H eval 'require("lazy.core.config").plugins["gitsigns.nvim"].loaded ~= nil'
```

### Read errors from a plugin's `setup()` call

```sh
$H eval 'vim.api.nvim_exec2("messages", {output=true}).output'
```

### Test a buffer-local autocmd fires

```sh
$H send ':e fixture.lua<CR>'
$H eval 'vim.api.nvim_get_autocmds({ buffer = 0, event = "BufWritePre" })'
```

## Failure modes

- **`ready` times out** → run `$H logs`. Common causes: Lua syntax error in your edit (look for `E5108`/`E5113`), missing required module, treesitter parser compile failure offline.
- **`send` rejected by denylist** → you tried to forward a destructive sequence. Test registration via `eval` with `maparg` instead of triggering it.
- **`send` succeeds but the side effect doesn't appear** → plugin probably hasn't lazy-loaded. Open a buffer of the right filetype first (precondition step).
- **`eval` returns `null`** → input was a single expression but auto-prepend was suppressed (e.g. you started with a leading keyword that consumed the heuristic). Add an explicit `return`.
- **`stop` refuses with "clients attached"** → user is watching the session. Ask them to detach (the user's tmux prefix is `C-w`, so `C-w d`) then re-run `stop`.
- **`capture` is blank or shows only the spawn shell** → nvim crashed before the UI rendered. `$H logs` will show why; the pane stays alive on the post-mortem `[nvim exited code N]` line for 24h or until `stop`.

## Teardown rule

Always end with `$H stop`. If you abandon a harness, `$H status` will list it and you can clean up with `CLAUDE_NVIM_NAME=<name> $H stop`. Stale state files don't auto-expire.

## Watching the test

The harness runs in a **detached** tmux session — invisible by default. To watch the test in real time:

```sh
$H attach    # prints: tmux attach -t claude-nvim-default-<pid>
```

Run that command in a separate terminal. Detach with `C-w d`. Then run `$H stop` to clean up — `stop` will refuse while you're attached.
