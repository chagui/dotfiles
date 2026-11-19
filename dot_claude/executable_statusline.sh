#!/usr/bin/env bash
# Claude Code status line — two lines:
#   Model: X 1M·effort | vVER | Style: S | Context: [bar] 654k/1.0M (65%) | cwd: …/a/b/c
#   Cost: $N | Session: 1h 2m (API 3m) | branch +S ~M          Session ID: <id>
# Docs: https://code.claude.com/docs/en/statusline
set -u

input=$(cat)

# Single jq call, one field per line. Bash 3.2's read collapses empty
# whitespace-IFS fields, so newline-delimited reads are the safe option here.
{
    read -r MODEL
    read -r MODEL_ID
    read -r EFFORT
    read -r PCT
    read -r SESSION_ID
    read -r VERSION
    read -r STYLE
    read -r USED_TOKENS
    read -r WINDOW_SIZE
    read -r CWD
    read -r COST
    read -r DURATION_MS
    read -r API_DURATION_MS
} < <(jq -r '
  .model.display_name,
  .model.id,
  (.effort.level // ""),
  (.context_window.used_percentage // 0 | floor),
  .session_id,
  (.version // ""),
  (.output_style.name // "default"),
  (.context_window.total_input_tokens // 0),
  (.context_window.context_window_size // 0),
  (.workspace.current_dir // .cwd // ""),
  (.cost.total_cost_usd // 0),
  (.cost.total_duration_ms // 0 | floor),
  (.cost.total_api_duration_ms // 0 | floor)
' <<<"$input")

# 1M context variant is encoded in the model id (e.g. claude-opus-4-7[1m])
case "$MODEL_ID" in *1m*) MODEL="${MODEL} 1M" ;; esac
[ -n "$EFFORT" ] && MODEL="${MODEL}·${EFFORT}"

# Git state cached for 5s, keyed on session_id so concurrent sessions don't collide.
# stat -f %m is macOS; fall back to -c %Y on Linux.
CACHE_DIR="/tmp/claude-statusline"
CACHE="$CACHE_DIR/git-$SESSION_ID"
mtime=$(/usr/bin/stat -f %m "$CACHE" 2>/dev/null || stat -c %Y "$CACHE" 2>/dev/null || echo 0)
if [ ! -f "$CACHE" ] || [ $(($(date +%s) - mtime)) -gt 5 ]; then
    mkdir -p "$CACHE_DIR"
    if git rev-parse --git-dir >/dev/null 2>&1; then
        BRANCH=$(git branch --show-current 2>/dev/null)
        STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
        MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
        printf '%s|%s|%s' "$BRANCH" "$STAGED" "$MODIFIED" >"$CACHE"
    else
        printf '||' >"$CACHE"
    fi
fi
IFS='|' read -r BRANCH STAGED MODIFIED <"$CACHE"

# 654000 -> 654k, 1000000 -> 1.0M
human_tokens() {
    local n=$1
    if [ "$n" -ge 1000000 ]; then
        printf '%d.%dM' $((n / 1000000)) $((n % 1000000 / 100000))
    elif [ "$n" -ge 1000 ]; then
        printf '%dk' $((n / 1000))
    else
        printf '%d' "$n"
    fi
}

# 81300000 -> 22h 35m, 125000 -> 2m
human_duration() {
    local mins=$(($1 / 60000))
    if [ "$mins" -ge 60 ]; then
        printf '%dh %dm' $((mins / 60)) $((mins % 60))
    else
        printf '%dm' "$mins"
    fi
}

# Keep the last N path segments; the deepest ones are what distinguish sessions.
CWD_SEGMENTS=3
short_path() {
    # ~ via a variable: a bare ~ in the replacement is tilde-expanded back to
    # $HOME, and bash 3.2 keeps a quoted "~" literally, quotes included.
    local tilde='~'
    local p="${1/#"$HOME"/$tilde}" parts
    IFS='/' read -ra parts <<<"$p"
    if [ "${#parts[@]}" -le "$CWD_SEGMENTS" ]; then
        printf '%s' "$p"
        return
    fi
    local out="…" i
    for ((i = ${#parts[@]} - CWD_SEGMENTS; i < ${#parts[@]}; i++)); do
        out="${out}/${parts[i]}"
    done
    printf '%s' "$out"
}

RESET='\033[0m'
DIM='\033[2m'
CYAN='\033[36m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
SEP=" ${DIM}|${RESET} "

# Color-graded bar: green <70, yellow 70-89, red >=90
if [ "$PCT" -ge 90 ]; then
    BAR_COLOR=$RED
elif [ "$PCT" -ge 70 ]; then
    BAR_COLOR=$YELLOW
else
    BAR_COLOR=$GREEN
fi

FILLED=$((PCT / 10))
[ "$FILLED" -gt 10 ] && FILLED=10
EMPTY=$((10 - FILLED))
FILL=""
PAD=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s"
BAR="${FILL// /▓}${PAD// /░}"

GIT_PART=""
if [ -n "$BRANCH" ]; then
    GIT_PART="${CYAN}${BRANCH}${RESET}"
    [ "${STAGED:-0}" -gt 0 ] && GIT_PART="${GIT_PART} ${GREEN}+${STAGED}${RESET}"
    [ "${MODIFIED:-0}" -gt 0 ] && GIT_PART="${GIT_PART} ${YELLOW}~${MODIFIED}${RESET}"
fi

# Line 1
LINE1="${CYAN}Model: ${MODEL}${RESET}"
[ -n "$VERSION" ] && LINE1="${LINE1}${SEP}${DIM}v${VERSION}${RESET}"
LINE1="${LINE1}${SEP}Style: ${STYLE}"
CONTEXT="${BLUE}Context:${RESET} [${BAR_COLOR}${BAR}${RESET}]"
[ "$WINDOW_SIZE" -gt 0 ] && CONTEXT="${CONTEXT} $(human_tokens "$USED_TOKENS")/$(human_tokens "$WINDOW_SIZE")"
LINE1="${LINE1}${SEP}${CONTEXT} (${PCT}%)"
[ -n "$CWD" ] && LINE1="${LINE1}${SEP}${BLUE}cwd:${RESET} $(short_path "$CWD")"

# Line 2
printf -v COST_FMT '$%.2f' "$COST"
LINE2="${GREEN}Cost: ${COST_FMT}${RESET}"
LINE2="${LINE2}${SEP}${YELLOW}Session: $(human_duration "$DURATION_MS")${RESET}"
LINE2="${LINE2} ${DIM}(API $(human_duration "$API_DURATION_MS"))${RESET}"
[ -n "$GIT_PART" ] && LINE2="${LINE2}${SEP}${GIT_PART}"

# Right-align the session ID. Claude Code sets COLUMNS (tput cannot see the
# terminal from here). Visible width = line with ANSI escapes stripped.
ID_PART="${CYAN}Session ID: ${SESSION_ID}${RESET}"
plain() { printf '%b' "$1" | sed $'s/\033\\[[0-9;]*m//g'; }
LEFT_PLAIN=$(plain "$LINE2")
ID_PLAIN=$(plain "$ID_PART")
GAP=$((${COLUMNS:-0} - ${#LEFT_PLAIN} - ${#ID_PLAIN} - 2))
[ "$GAP" -lt 2 ] && GAP=2
printf -v SPACES "%${GAP}s"

printf '%b\n' "$LINE1"
printf '%b\n' "${LINE2}${SPACES}${ID_PART}"
