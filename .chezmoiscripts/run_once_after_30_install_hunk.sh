#!/bin/bash
set -eufo pipefail

if [ "${CHEZMOI_SKIP_HUNK_INSTALL:-0}" = "1" ]; then
    exit 0
fi

# Volta is user-installed (see dot_zshenv); skip cleanly when absent so a
# fresh host that hasn't bootstrapped Volta yet doesn't fail apply.
if [ ! -x "$HOME/.volta/bin/volta" ]; then
    echo "⏭   Skipping hunk install: Volta not found at \$HOME/.volta"
    exit 0
fi

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

if command -v hunk &>/dev/null; then
    exit 0
fi

echo "📦  Installing hunkdiff via Volta"
volta install hunkdiff
