#!/usr/bin/env bash
# verify.sh — runs inside the sandbox AFTER `chezmoi apply` has completed.
# Asserts each expected binary is on PATH and each generated artifact exists.
# Exits non-zero on any failed check.
#
# Pre-extends PATH with the common install dirs the bootstrap writes to,
# because verify may be invoked from a non-login shell where the user's
# rc files haven't been sourced.

set -uo pipefail

export PATH="$HOME/.nix-profile/bin:$HOME/.cargo/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

OS=$(uname -s)
fail=0

check_cmd() {
    local cmd=$1
    if command -v "$cmd" &>/dev/null; then
        printf '  PASS  %-20s -> %s\n' "$cmd" "$(command -v "$cmd")"
    else
        printf '  FAIL  %-20s not on PATH\n' "$cmd"
        fail=$((fail + 1))
    fi
}

# check_runs catches binaries that are on PATH but cannot execute, e.g. an
# x86_64 tarball extracted on an arm64 host.
check_runs() {
    local cmd=$1
    if "$cmd" --version &>/dev/null; then
        printf '  PASS  %-20s runs\n' "$cmd"
    else
        printf '  FAIL  %-20s does not run\n' "$cmd"
        fail=$((fail + 1))
    fi
}

# Asserts the command resolves into the Nix store, i.e. it came from the
# Home Manager profile rather than a leftover tarball or cargo install.
check_nix_cmd() {
    local cmd=$1 resolved
    resolved=$(readlink -f "$(command -v "$cmd" 2>/dev/null)" 2>/dev/null)
    if [[ $resolved == /nix/store/* ]]; then
        printf '  PASS  %-20s -> %s\n' "$cmd" "$resolved"
    else
        printf '  FAIL  %-20s not from /nix/store (%s)\n' "$cmd" "${resolved:-missing}"
        fail=$((fail + 1))
    fi
}

check_file() {
    local f=$1
    if [ -f "$f" ]; then
        printf '  PASS  %s\n' "$f"
    else
        printf '  FAIL  %s missing\n' "$f"
        fail=$((fail + 1))
    fi
}

echo "== Rust toolchain =="
for c in cargo rustc cargo-binstall; do check_cmd "$c"; done

echo "== Rust CLIs (cargo-binstall'd) =="
for c in bat eza rg fd delta starship zoxide dust broot doge tldr; do
    check_cmd "$c"
done

echo "== Bootstrap-installed binaries =="
check_cmd fzf
check_runs fzf

if [ "$OS" = "Linux" ]; then
    echo "== Linux: Home Manager packages (nix/home.nix) =="
    for c in gt nvim topgrade claude codex; do
        check_nix_cmd "$c"
        check_runs "$c"
    done
else
    check_cmd nvim
    check_runs nvim
    check_cmd topgrade
fi

if [ "$OS" = "Linux" ]; then
    echo "== Linux: tarball + apt =="
    check_cmd rsync
    check_cmd unzip
elif [ "$OS" = "Darwin" ]; then
    echo "== macOS: brew tools =="
    for c in brew gh tmux jq; do check_cmd "$c"; done
    check_cmd tart
    check_runs tart
fi

echo "== Python =="
check_cmd uv
check_cmd uvx

echo "== Generated artifacts =="
ZDOTDIR_RESOLVED="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"
XDG_DATA_HOME_RESOLVED="${XDG_DATA_HOME:-$HOME/.local/share}"
check_file "$ZDOTDIR_RESOLVED/fzf-completion.zsh"
check_file "$XDG_DATA_HOME_RESOLVED/zsh/completions/_uv"

if [ $fail -gt 0 ]; then
    echo
    echo "FAIL: $fail check(s) failed"
    exit 1
fi

echo
echo "PASS: all verify checks passed"
