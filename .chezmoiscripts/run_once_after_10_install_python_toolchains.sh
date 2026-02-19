#!/bin/bash

echo "🐍 Installing Python"
if ! command -v uv &>/dev/null; then
	UV_NO_MODIFY_PATH=1 curl -LsSf https://astral.sh/uv/install.sh | sh
fi
# install the latest Python version
uv python install

: "${XDG_DATA_HOME:=$HOME/.local/share}"
uv generate-shell-completion zsh >"${XDG_DATA_HOME}/zsh/completions/_uv"
uvx --generate-shell-completion zsh >"$XDG_DATA_HOME/zsh/completions/_uvx"

uv tool install argcomplete
