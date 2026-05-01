#!/usr/bin/env bash
# Smoke tier — fast, host-safe checks against the chezmoi source.
#
# Steps:
#   1. Render run_once_before_00_init.sh.tmpl + .chezmoi.toml.tmpl via
#      `chezmoi execute-template` against the current OS data set.
#   2. shellcheck on the rendered init script. Closes the gap left by the
#      live pre-commit hooks, which exclude *.tmpl because raw Go-template
#      syntax breaks shellcheck. (shfmt is intentionally not run — see step
#      3's comment in the script body for why.)
#   3. `chezmoi apply --dry-run --destination $tmp` against a throwaway dir.
#      Per chezmoi semantics, --dry-run does NOT execute run_once_* scripts;
#      it only validates the source state can be planned end-to-end.
#
# Exit 0 only if every step passes. Safe to run on the host — touches no
# files outside /tmp.
#
# Coverage caveat: `chezmoi.os` is a built-in template var derived from the
# host OS and cannot be overridden via flags. So one invocation covers one
# OS branch. Both branches get exercised across local-dev (macOS) and CI
# (Linux). The Linux branch is more thoroughly validated by e2e-linux.sh.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCE_DIR="$REPO_ROOT"
INIT_TMPL="$SOURCE_DIR/.chezmoiscripts/run_once_before_00_init.sh.tmpl"
TOML_TMPL="$SOURCE_DIR/.chezmoi.toml.tmpl"

require() {
    if ! command -v "$1" &>/dev/null; then
        echo "ERROR: smoke tier requires '$1' on PATH" >&2
        exit 1
    fi
}

require chezmoi
require shellcheck

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
darwin | linux) ;;
*)
    echo "ERROR: unsupported host OS '$OS'" >&2
    exit 1
    ;;
esac

echo "==> [1/4] render init template (chezmoi.os=$OS)"
chezmoi execute-template <"$INIT_TMPL" >"$work/init.sh"
if [ ! -s "$work/init.sh" ]; then
    echo "ERROR: rendered init script is empty" >&2
    exit 1
fi

echo "==> [2/4] render .chezmoi.toml.tmpl"
chezmoi execute-template --init <"$TOML_TMPL" >"$work/chezmoi.toml"
if [ ! -s "$work/chezmoi.toml" ]; then
    echo "ERROR: rendered chezmoi.toml is empty" >&2
    exit 1
fi

echo "==> [3/4] shellcheck rendered init script"
# SC1054/SC1083 are the codes the source template already disables (raw
# Go-template braces); they're irrelevant to the rendered output but the
# disable directive can land at EOF when one OS branch is elided, which
# trips SC1072. Exclude all three so smoke fails only on real shell bugs.
# shfmt is intentionally not run here — the source template uses style
# choices (`&> /dev/null`, backslash-then-pipe) that shfmt would reformat,
# producing noisy diffs on every render. The pre-commit shfmt hook is the
# right place for shell-style enforcement; smoke catches real bugs.
shellcheck -s bash --exclude=SC1054,SC1072,SC1083 "$work/init.sh"

echo "==> [4/4] chezmoi apply --dry-run (no scripts will execute)"
dest=$(mktemp -d)
chezmoi apply --dry-run --source "$SOURCE_DIR" --destination "$dest" >/dev/null
rm -rf "$dest"

echo "OK: smoke tier passed"
