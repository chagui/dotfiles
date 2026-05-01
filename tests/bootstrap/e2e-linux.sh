#!/usr/bin/env bash
# Tier-2 driver (Linux): builds the Docker image, runs the Linux branch of
# the bootstrap inside it, runs verify.sh, then runs apply a second time and
# asserts no run_once script re-executes.
#
# Refuses to run if Docker isn't available locally. Build context is the
# repo root so the image can COPY the chezmoi source.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DOCKERFILE="$REPO_ROOT/tests/bootstrap/Dockerfile"
IMAGE_TAG="${BOOTSTRAP_TEST_IMAGE:-chezmoi-bootstrap-test:latest}"

if ! docker info &>/dev/null; then
    cat >&2 <<'EOF'
ERROR: docker not available.

  Install Docker Desktop or colima before running this tier:
    macOS Desktop:    brew install --cask docker
    macOS lightweight: brew install colima && colima start
EOF
    exit 1
fi

echo "==> Building $IMAGE_TAG (slow on Apple Silicon — runs amd64 under Rosetta)"
docker build \
    --platform=linux/amd64 \
    -t "$IMAGE_TAG" \
    -f "$DOCKERFILE" \
    "$REPO_ROOT"

echo "==> Running bootstrap inside container"

# cargo-binstall queries api.github.com for every Rust CLI release. Without
# auth, the quota is 60/hr; repeated test iterations exhaust it and binstall
# falls back to source compile, which has no `cc` in the container. With a
# token the quota is 5000/hr. Try $GITHUB_TOKEN first, then `gh auth token`,
# then warn-and-proceed.
GH_TOKEN="${GITHUB_TOKEN:-}"
if [ -z "$GH_TOKEN" ] && command -v gh &>/dev/null; then
    GH_TOKEN=$(gh auth token 2>/dev/null || true)
fi

DOCKER_ENV_FLAGS=(
    -e BOOTSTRAP_TEST_SANDBOX=1
    -e CHEZMOI_SKIP_CLAUDE_INSTALL=1
    # The deployed user gitconfig (dot_config/git/config.tmpl:113-115)
    # rewrites https://github.com/ → git@github.com:. That's correct for the
    # author's machine but breaks chezmoi's external git-repo clones inside
    # the container (no ssh, no keys). /dev/null disables the global config
    # for the apply step, so git uses the URL as-given.
    -e GIT_CONFIG_GLOBAL=/dev/null
)
if [ -n "$GH_TOKEN" ]; then
    DOCKER_ENV_FLAGS+=(-e "GITHUB_TOKEN=$GH_TOKEN")
else
    echo "WARNING: no GITHUB_TOKEN available — cargo-binstall may hit GitHub API rate limits" >&2
fi

docker run --rm \
    --platform=linux/amd64 \
    "${DOCKER_ENV_FLAGS[@]}" \
    "$IMAGE_TAG" \
    bash -lc '
        set -euo pipefail
        SOURCE="$HOME/.local/share/chezmoi"

        # shellcheck disable=SC1091
        source "$SOURCE/tests/bootstrap/helpers/guard.sh"

        echo "==> First apply (real install)"
        # `chezmoi init --apply` is the canonical first-run: it renders
        # .chezmoi.toml.tmpl into ~/.config/chezmoi/chezmoi.toml, then
        # applies. Using plain `apply` triggers a "config file template
        # has changed" warning on first run.
        chezmoi init --apply --source "$SOURCE"

        echo "==> Verify expected artifacts"
        bash "$SOURCE/tests/bootstrap/verify.sh"

        echo "==> Second apply (idempotency)"
        second=$(chezmoi apply --source "$SOURCE" 2>&1)
        echo "$second"
        if echo "$second" | grep -qE "(Installing Python|Installing Claude|Installing packages from|Installing Homebrew|🐍 Installing|🍺)"; then
            echo "FAIL: run_once_* scripts re-executed on second apply"
            exit 1
        fi
        echo "PASS: idempotency"
    '

echo "OK: e2e-linux passed"
