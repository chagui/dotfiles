#!/bin/bash

# Binaries installed by run_once_before_00_init: bat/tldr land in
# ~/.cargo/bin (cargo-binstall), fzf in ~/.local/bin (curl tarball).
# chezmoi spawns each run_once script as a fresh process, so the parent
# shell's PATH may not include those dirs on a fresh machine.
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# zsh won't create HISTFILE's parent directory, and history is silently lost
# without it. Use the XDG default: chezmoi scripts run without XDG_STATE_HOME,
# while .zshrc sets it to ~/.local/state.
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh/"
bat cache --build
tldr --update

# Generate fzf zsh integration — the zshrc sources $ZDOTDIR/fzf-completion.zsh
# conditionally, so this file defines the keybindings and completion.
ZDOTDIR="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"
mkdir -p "$ZDOTDIR"
fzf --zsh >"$ZDOTDIR/fzf-completion.zsh"
