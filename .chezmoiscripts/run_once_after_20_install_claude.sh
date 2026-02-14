#!/bin/bash

if ! command -v claude &>/dev/null; then
	echo "Installing Claude Code..."
	curl -fsSL https://claude.ai/install.sh | bash
fi
