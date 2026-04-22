#!/bin/bash

mkdir -p "${XDG_STATE_HOME:-$HOME/.state}/zsh/"
bat cache --build
tldr --update

# Generate fzf zsh integration — the zshrc sources $ZDOTDIR/fzf-completion.zsh
# conditionally, so this file defines the keybindings and completion.
ZDOTDIR="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"
mkdir -p "$ZDOTDIR"
fzf --zsh >"$ZDOTDIR/fzf-completion.zsh"
