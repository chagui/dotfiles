#!/usr/bin/env bash
# Refuses to proceed unless we're inside a sandbox.
# Sourced by e2e drivers BEFORE any `chezmoi apply`.
#
# A "sandbox" is one of:
#   - A Docker container (presence of /.dockerenv)
#   - A GitHub Actions runner ($CI=true)
#   - The author's manual override ($BOOTSTRAP_TEST_FORCE=1) — escape hatch only
#
# In all cases, BOOTSTRAP_TEST_SANDBOX=1 must also be set by the caller. The
# two-key system is intentional: the env var is the explicit declaration, the
# marker is the structural proof. Either alone is insufficient.

set -euo pipefail

if [ "${BOOTSTRAP_TEST_SANDBOX:-0}" != "1" ]; then
    cat >&2 <<'EOF'
ERROR: bootstrap test guard refused to proceed.

  BOOTSTRAP_TEST_SANDBOX must be set to "1". This script invokes
  `chezmoi apply` and would mutate $HOME if run on the host machine.

  Use tests/bootstrap/e2e-linux.sh (Docker) or tests/bootstrap/e2e-macos.sh
  (CI only) instead of running this directly.
EOF
    exit 1
fi

if [ -f /.dockerenv ]; then
    : # Docker container — OK
elif [ "${CI:-}" = "true" ]; then
    : # GitHub Actions — OK
elif [ "${BOOTSTRAP_TEST_FORCE:-0}" = "1" ]; then
    echo "WARNING: BOOTSTRAP_TEST_FORCE=1 — bypassing sandbox check." >&2
    echo "         This will mutate \$HOME=$HOME. You have 5 seconds to abort." >&2
    sleep 5
else
    cat >&2 <<'EOF'
ERROR: BOOTSTRAP_TEST_SANDBOX=1 but no sandbox marker present.

  Expected one of:
    - /.dockerenv      (Docker container)
    - CI=true          (GitHub Actions)
    - BOOTSTRAP_TEST_FORCE=1   (manual override; nuclear)
EOF
    exit 1
fi
