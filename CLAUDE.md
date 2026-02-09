# Chezmoi Dotfiles Repository

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository managing system configuration.

## Repository Structure

```
dot_config/          → ~/.config/ (main config directory)
  alacritty/         → terminal emulator
  bat/               → cat replacement
  chezmoi/           → chezmoi's own config
  git/               → git config & aliases
  nvim/              → Neovim (lazy.nvim plugin manager)
  ripgrep/           → rg config
  terraform/         → Terraform CLI config
  tmux/              → tmux config
  topgrade/          → system updater
  zed/               → Zed editor
  zsh/               → Zsh config fragments
dot_zshenv           → ~/.zshenv
dot_bashrc           → ~/.bashrc
dot_aliases         → shell aliases
dot_functions        → shell functions
dot_kube/            → Kubernetes config
dot_cargo/           → Cargo (Rust) config
dot_cache/           → cached files
dot_local/           → local binaries/share
Library/             → macOS Library preferences
gui/                 → GUI app configs (not managed by chezmoi)
```

## Chezmoi Conventions

- **`dot_` prefix** → becomes `.` in the target (e.g., `dot_config` → `.config`)
- **`private_` prefix** → file is chmod 600
- **`executable_` prefix** → file is chmod 755
- **`.tmpl` suffix** → file is a Go template, rendered with chezmoi data
- **`run_` prefix** → script is executed on `chezmoi apply`
- Edit source files here, then run `chezmoi apply` to deploy (but Claude should **never** run `chezmoi apply`)

## Commit Style

This repo uses **conventional commits**:

```
type(scope): short description
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`
Scopes: config name (e.g., `nvim`, `zsh`, `git`, `tmux`)

Examples from history:
- `feat(nvim): add LSP keymaps for common operations`
- `fix(nvim): use HTTPS URL for lazy.nvim bootstrap`
- `refactor(nvim): replace vim-smoothie with native smoothscroll`
- `chore(nvim): remove non-functional Caps_Lock mapping`

## Pre-commit Hooks

Pre-commit is configured with:
- **StyLua** — Lua formatter (for Neovim config)
- Standard hooks: large file check, YAML/TOML validation, trailing whitespace, EOF fixer

Always run `pre-commit run --all-files` or let it run on `git commit`.

## Neovim Config

- Plugin manager: **lazy.nvim**
- Config structure: `dot_config/nvim/lua/` with plugin specs in `plugins/`
- LSP, Treesitter, and formatter configs are separate files
- Format-on-save enabled for Go files

## Key Rules

- **Never run `chezmoi apply`** — that deploys to the live system
- **Never run `rm`** — ask the user to remove files manually
- **Never push** — always let the user review and push
- Prefer editing existing files over creating new ones
- When modifying Lua files, ensure StyLua formatting compliance
