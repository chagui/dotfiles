# test-nvim-config

A Claude Code skill that drives a real `nvim --listen` instance inside a detached tmux session, so changes to the Neovim config can be verified end-to-end (mappings actually fire, plugins actually load, LSPs actually attach) instead of just type-checking that the Lua parses.

## Files

- `SKILL.md` — what Claude reads when the skill is invoked. Contains the workflow, hazards specific to this repo's nvim config, and copy-paste recipes.
- `executable_harness.sh` — the runtime. Chezmoi strips `executable_` and chmods 0755 on apply, so the deployed path is `~/.claude/skills/test-nvim-config/harness.sh`.

## Deploy

```sh
chezmoi apply ~/.claude/skills/test-nvim-config
```

## Invoke from Claude

The skill is gated by `disable-model-invocation: true` in its frontmatter, so Claude only runs it when explicitly asked:

```
/test-nvim-config "the new <leader>gd mapping"
```

After deploying changes under `dot_config/nvim/`, run the slash command and Claude will spawn the harness, exercise the change, and report.

## Use the harness directly

The harness is a normal shell script and works without Claude — useful when you want to poke at your config in a controlled environment:

```sh
H=~/.claude/skills/test-nvim-config/harness.sh

$H start
$H ready
$H eval 'vim.v.errmsg'                                            # any startup error
$H eval 'vim.fn.maparg(" gd", "n", false, true)'                  # mapping registration
$H send ':e fixture.go<CR>'
$H send '<Space>gd'
$H eval 'return { ft = vim.bo.filetype, errmsg = vim.v.errmsg }'  # behavior + errmsg
$H attach    # prints `tmux attach -t …` so you can watch in another terminal
$H stop
```

`$H help` lists every subcommand.

## Why not headless nvim?

Headless was considered. Three properties of this repo's nvim config make a real TUI necessary:

1. `vim.o.ch = 0` (`dot_config/nvim/init.lua:33`) — cmdline messages don't render in the visible pane, so behavioral assertions need RPC anyway. Headless wouldn't lose anything on the assertion side, but…
2. `vim._core.ui2` is enabled unconditionally in `init.lua:1-11` — its behavior under `--headless` is not relied upon by the user, so testing under it would diverge from the real config.
3. The user explicitly wanted to *watch* tests run.

The harness is therefore TUI-first with optional `attach`, not headless-first with optional viewer. The trade-off is that we have to force `TERM`, `LANG`, and pane size to keep `tmux capture-pane` deterministic.

## Hazards baked in

These four properties of this repo's nvim config are load-bearing for harness correctness:

| Hazard | File | Mitigation |
| --- | --- | --- |
| `<leader>re` → `:restart` would kill the harness | `dot_config/nvim/lua/user/keymaps.lua:42` | `send` denylist |
| `vim.o.ch = 0` hides messages from `capture-pane` | `dot_config/nvim/init.lua:33` | SKILL.md says use `eval` for messages |
| `BufWritePost` → `chezmoi apply` on writes inside the repo | `dot_config/nvim/init.lua:38-57` | Fixtures sandboxed to `${TMPDIR}/claude-nvim-fixtures-*` |
| User attached to test session — killing it would yank their pane | n/a | `stop` checks `tmux list-clients` and refuses |

## Adding to it

If you bind a new destructive keymap, add the prefix to `DESTRUCTIVE_KEYS` in `executable_harness.sh`. If you add a new precondition that plugins or LSPs need (a `go.mod`-rooted file, a particular env var), document it as a recipe in `SKILL.md` so Claude knows to set it up.
