#!/bin/bash

if [ "${CHEZMOI_SKIP_CLAUDE_INSTALL:-0}" = "1" ]; then
    exit 0
fi

if ! command -v claude &>/dev/null; then
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
fi
