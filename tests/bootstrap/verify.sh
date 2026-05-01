#!/usr/bin/env bash
# verify.sh — runs inside the sandbox AFTER `chezmoi apply` has completed.
# Asserts each expected binary is on PATH and each generated artifact exists.
# Exits non-zero on any failed check.
#
# Pre-extends PATH with the common install dirs the bootstrap writes to,
# because verify may be invoked from a non-login shell where the user's
# rc files haven't been sourced.

set -uo pipefail

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

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
for c in bat eza rg fd delta starship zoxide dust broot tldr topgrade; do
    check_cmd "$c"
done

echo "== Bootstrap-installed binaries =="
check_cmd nvim
check_cmd fzf

if [ "$OS" = "Linux" ]; then
    echo "== Linux: tarball + apt =="
    check_cmd dog
    check_cmd rsync
    check_cmd unzip
elif [ "$OS" = "Darwin" ]; then
    echo "== macOS: brew tools =="
    for c in brew gh tmux jq; do check_cmd "$c"; done
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
