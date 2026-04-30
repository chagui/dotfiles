#!/usr/bin/env bash
# harness.sh — drive a Neovim TUI inside a detached tmux session over RPC.
# See SKILL.md (alongside this file) for usage and recipes.

set -euo pipefail

NAME="${CLAUDE_NVIM_NAME:-default}"
STATE_DIR="${TMPDIR:-/tmp}"
STATE_DIR="${STATE_DIR%/}"
STATE_FILE=""

# Destructive key sequences that would kill or destabilise the harness if
# blindly forwarded. Match the *prefix* of the keys arg.
DESTRUCTIVE_KEYS=(
    '<Space>re' # bound to :restart in keymaps.lua
    ':restart'
    ':qa'
    ':quitall'
    ':wqa'
    'ZZ'
    'ZQ'
    ':q!'
)

usage() {
    cat <<'EOF'
Usage: harness.sh <subcommand> [args]

Subcommands:
  start [--cwd DIR]                 Spawn a detached tmux session running nvim --listen.
  ready [--timeout SEC]             Block until VimEnter and lazy.nvim are ready (default 15s).
  send '<keys>'                     Send keystrokes via nvim --remote-send (denylist enforced).
  eval '<lua>'                      Evaluate Lua and print JSON-encoded result on stdout.
                                    Single-line input without a leading keyword auto-gets
                                    `return ` prepended.
  capture [--lines N] [--ansi]      Print rendered pane content via tmux capture-pane.
  logs                              Print the nvim startup log file.
  stop                              Kill the session iff no clients are attached; clean up.
  status                            List active harnesses (alive vs dead state).
  attach                            Print the tmux attach command for the current session.

Environment:
  CLAUDE_NVIM_NAME                  Name of the harness instance (default: "default").
                                    Use distinct names to run multiple harnesses concurrently.
EOF
}

resolve_state() {
    STATE_FILE="$STATE_DIR/claude-nvim-$NAME.state"
}

load_state() {
    resolve_state
    if [[ ! -e "$STATE_FILE" ]]; then
        echo "no harness '$NAME' running (state file $STATE_FILE missing)" >&2
        echo "hint: run 'harness.sh start' first" >&2
        exit 1
    fi
    # shellcheck disable=SC1090
    source "$STATE_FILE"
    if ! tmux has-session -t "$SESSION" 2>/dev/null; then
        echo "harness '$NAME' state exists but tmux session '$SESSION' is gone" >&2
        echo "hint: 'harness.sh logs' may show why; 'harness.sh stop' will clean up" >&2
        exit 1
    fi
}

cmd_start() {
    local cwd=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --cwd)
            cwd="$2"
            shift 2
            ;;
        *)
            echo "start: unknown arg: $1" >&2
            exit 2
            ;;
        esac
    done
    resolve_state

    if [[ -e "$STATE_FILE" ]]; then
        # shellcheck disable=SC1090
        source "$STATE_FILE"
        if tmux has-session -t "$SESSION" 2>/dev/null; then
            echo "harness '$NAME' already running (session=$SESSION)" >&2
            return 1
        fi
        rm -f "$STATE_FILE" "${SOCK:-}" "${LOG:-}" 2>/dev/null || true
    fi

    local SESSION="claude-nvim-$NAME-$$"
    local SOCK="$STATE_DIR/claude-nvim-$NAME-$$.sock"
    local LOG="$STATE_DIR/claude-nvim-$NAME-$$.log"
    if [[ -z "$cwd" ]]; then
        cwd="$STATE_DIR/claude-nvim-fixtures-$NAME-$$"
        mkdir -p "$cwd"
    fi

    : >"$LOG"
    # Spawn nvim inside a detached tmux session with a forced size, TERM and
    # locale — without these, capture-pane truncates lines, treesitter listchars
    # render as '?', and some terminfo lookups fail. The trailing sleep keeps
    # the pane alive after nvim exits so a postmortem capture is possible.
    tmux new-session -d -s "$SESSION" -x 200 -y 50 \
        -e "TERM=xterm-256color" -e "LANG=en_US.UTF-8" -e "LC_ALL=en_US.UTF-8" \
        -c "$cwd" \
        "nvim --listen '$SOCK' 2>>'$LOG'; printf '\\n[nvim exited code %s]\\n' \"\$?\"; sleep 86400"

    cat >"$STATE_FILE" <<EOF
SESSION='$SESSION'
SOCK='$SOCK'
LOG='$LOG'
CWD='$cwd'
EOF

    echo "started: name=$NAME session=$SESSION socket=$SOCK cwd=$cwd"
    echo "next: harness.sh ready"
}

cmd_ready() {
    local timeout=15
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --timeout)
            timeout="$2"
            shift 2
            ;;
        *)
            echo "ready: unknown arg: $1" >&2
            exit 2
            ;;
        esac
    done
    load_state

    # Step 1: wait for the listen socket to appear. nvim creates it before
    # init.lua runs, so this is fast — but if nvim crashes during arg parsing
    # it never appears.
    local deadline=$(($(date +%s) + timeout))
    while [[ ! -S "$SOCK" ]]; do
        if [[ $(date +%s) -ge $deadline ]]; then
            echo "ready: socket $SOCK never appeared (nvim crashed before listen?)" >&2
            [[ -s "$LOG" ]] && {
                echo "--- nvim stderr: ---" >&2
                cat "$LOG" >&2
            }
            exit 1
        fi
        sleep 0.1
    done

    # Step 2: ask nvim itself to wait for VimEnter + lazy.nvim. The shell-side
    # poll on `v:true` from the brief is a weaker signal — the RPC server is
    # up before init.lua finishes, so we'd race plugin loading. Lua long
    # brackets [[lazy]] avoid quote-nesting against the shell/vim layers.
    local timeout_ms=$((timeout * 1000))
    local out
    out=$(nvim --server "$SOCK" --remote-expr \
        "luaeval(\"vim.wait(${timeout_ms}, function() return vim.v.vim_did_enter == 1 and (package.loaded.lazy ~= nil) and require([[lazy]]).stats().startuptime > 0 end, 50) and 1 or 0\")" \
        2>&1) || {
        echo "ready: nvim --remote-expr failed: $out" >&2
        exit 1
    }
    if [[ "$out" != "1" ]]; then
        echo "ready: nvim did not finish startup within ${timeout}s" >&2
        [[ -s "$LOG" ]] && {
            echo "--- nvim stderr: ---" >&2
            cat "$LOG" >&2
        }
        exit 1
    fi
    echo "ready"
}

cmd_send() {
    [[ $# -eq 1 ]] || {
        echo "send: expected 1 arg (keys)" >&2
        exit 2
    }
    local keys="$1"
    for d in "${DESTRUCTIVE_KEYS[@]}"; do
        case "$keys" in
        "$d" | "$d"*)
            echo "send: refusing destructive keys '$keys' (matches denylist '$d')" >&2
            echo "hint: to test registration only, use 'eval' with vim.fn.maparg(...)" >&2
            exit 1
            ;;
        esac
    done
    load_state
    nvim --server "$SOCK" --remote-send "$keys"
}

cmd_eval() {
    [[ $# -eq 1 ]] || {
        echo "eval: expected 1 arg (lua expression or block)" >&2
        exit 2
    }
    local lua="$1"
    # Auto-prepend `return ` for single-line expressions without a leading
    # statement keyword. Multi-line input is left alone — caller writes
    # explicit `return` where they want a value.
    if [[ "$lua" != *$'\n'* ]]; then
        case "$lua" in
        return\ * | local\ * | "if "* | "for "* | "while "* | "do "*) ;;
        *) lua="return $lua" ;;
        esac
    fi
    load_state

    # Round-trip via a tempfile so user Lua isn't subjected to shell + vim +
    # luaeval quoting. loadfile() returns the file's chunk; we wrap it in an
    # IIFE and json-encode the result so callers always parse JSON.
    local tmpf
    tmpf=$(mktemp "$STATE_DIR/claude-nvim-eval-XXXXXX.lua")
    trap 'rm -f "$tmpf"' EXIT
    {
        printf '%s\n' 'return vim.json.encode((function()'
        printf '%s\n' "$lua"
        printf '%s\n' 'end)())'
    } >"$tmpf"

    local out
    out=$(nvim --server "$SOCK" --remote-expr \
        "luaeval('loadfile([[$tmpf]])()')" 2>&1) || {
        echo "eval: nvim --remote-expr failed: $out" >&2
        echo "--- script: ---" >&2
        cat "$tmpf" >&2
        exit 1
    }
    printf '%s\n' "$out"
}

cmd_capture() {
    local lines=200
    local ansi=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --lines)
            lines="$2"
            shift 2
            ;;
        --ansi)
            ansi="-e"
            shift
            ;;
        *)
            echo "capture: unknown arg: $1" >&2
            exit 2
            ;;
        esac
    done
    load_state
    # -J joins wrapped lines, -S -N includes N lines of scrollback.
    # shellcheck disable=SC2086
    tmux capture-pane -t "$SESSION" -p -J $ansi -S "-$lines"
}

cmd_logs() {
    load_state
    if [[ -e "$LOG" ]]; then
        cat "$LOG"
    else
        echo "no log file at $LOG" >&2
        exit 1
    fi
}

cmd_stop() {
    resolve_state
    if [[ ! -e "$STATE_FILE" ]]; then
        echo "no harness '$NAME' to stop"
        return 0
    fi
    # shellcheck disable=SC1090
    source "$STATE_FILE"
    if tmux has-session -t "$SESSION" 2>/dev/null; then
        local clients
        clients=$(tmux list-clients -t "$SESSION" 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$clients" -gt 0 ]]; then
            echo "stop: refusing to kill '$SESSION' — $clients client(s) attached" >&2
            local prefix
            prefix=$(tmux show-option -gv prefix 2>/dev/null || echo C-b)
            echo "hint: detach ($prefix d) then re-run 'harness.sh stop'" >&2
            exit 1
        fi
        tmux kill-session -t "$SESSION"
    fi
    rm -f "$SOCK" "$LOG" "$STATE_FILE"
    if [[ -n "${CWD:-}" && -d "$CWD" && "$CWD" == *claude-nvim-fixtures-* ]]; then
        rm -rf "$CWD"
    fi
    echo "stopped: $SESSION"
}

cmd_status() {
    local found=0
    shopt -s nullglob
    for sf in "$STATE_DIR"/claude-nvim-*.state; do
        local n="${sf##*/claude-nvim-}"
        n="${n%.state}"
        (
            # shellcheck disable=SC1090
            source "$sf"
            if tmux has-session -t "$SESSION" 2>/dev/null; then
                printf '%-20s alive   session=%s socket=%s\n' "$n" "$SESSION" "$SOCK"
            else
                printf '%-20s dead    session=%s (run: CLAUDE_NVIM_NAME=%s harness.sh stop)\n' "$n" "$SESSION" "$n"
            fi
        )
        found=1
    done
    [[ $found -eq 0 ]] && echo "no harnesses running"
}

cmd_attach() {
    load_state
    local prefix
    prefix=$(tmux show-option -gv prefix 2>/dev/null || echo C-b)
    echo "tmux attach -t $SESSION"
    echo "(detach with $prefix d)"
}

cmd="${1:-}"
[[ $# -gt 0 ]] && shift
case "$cmd" in
start) cmd_start "$@" ;;
ready) cmd_ready "$@" ;;
send) cmd_send "$@" ;;
eval) cmd_eval "$@" ;;
capture) cmd_capture "$@" ;;
logs) cmd_logs ;;
stop) cmd_stop ;;
status) cmd_status ;;
attach) cmd_attach ;;
-h | --help | help | "") usage ;;
*)
    echo "unknown subcommand: $cmd" >&2
    usage >&2
    exit 2
    ;;
esac
