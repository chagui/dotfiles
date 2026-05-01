#!/usr/bin/env bash
# Tier-2 driver (macOS): runs `chezmoi apply` against a fakehome under
# $RUNNER_TEMP. Refuses to run unless $CI=true (or $BOOTSTRAP_TEST_FORCE=1).
#
# GitHub Actions macos-latest runners are ephemeral, but applying against a
# fakehome bounds the blast radius regardless of runner-reuse policy changes.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Default-set the sandbox marker so the workflow file doesn't have to.
export BOOTSTRAP_TEST_SANDBOX="${BOOTSTRAP_TEST_SANDBOX:-1}"
export CHEZMOI_SKIP_CLAUDE_INSTALL="${CHEZMOI_SKIP_CLAUDE_INSTALL:-1}"

# shellcheck disable=SC1091
source "$REPO_ROOT/tests/bootstrap/helpers/guard.sh"

# Bound the blast radius to a tmpdir even on an ephemeral runner.
FAKE_HOME="${RUNNER_TEMP:-$(mktemp -d)}/fakehome"
mkdir -p "$FAKE_HOME"
export HOME="$FAKE_HOME"

echo "==> Using HOME=$HOME"

if ! command -v chezmoi &>/dev/null; then
    echo "ERROR: chezmoi not on PATH; install it first (brew install chezmoi)" >&2
    exit 1
fi

echo "==> First apply (real install — this can take 30+ minutes on macos-latest)"
chezmoi apply --source "$REPO_ROOT"

echo "==> Verify expected artifacts"
bash "$REPO_ROOT/tests/bootstrap/verify.sh"

echo "==> Second apply (idempotency)"
second=$(chezmoi apply --source "$REPO_ROOT" 2>&1)
echo "$second"
if echo "$second" | grep -qE "(Installing Python|Installing Claude|Installing packages from|Installing Homebrew|🐍 Installing|🍺)"; then
    echo "FAIL: run_once_* scripts re-executed on second apply"
    exit 1
fi
echo "PASS: idempotency"
echo "OK: e2e-macos passed"
