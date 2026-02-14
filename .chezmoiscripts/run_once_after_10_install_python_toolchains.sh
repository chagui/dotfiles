#!/bin/bash

echo "🐍 Installing Python"
curl -LsSf https://astral.sh/uv/install.sh | sh
# install the latest Python version
uv python install

: "${XDG_DATA_HOME:=$HOME/.local/state}"
uv generate-shell-completion zsh >"${XDG_DATA_HOME}/zsh/completions/_uv"
uvx --generate-shell-completion zsh >"$XDG_DATA_HOME/zsh/completions/_uvx"

pip install argcomplete
activate-global-python-argcomplete
