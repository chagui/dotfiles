#!/usr/bin/env bash
# Claude Code status line — single line: [Model 1M·effort] branch +S ~M  bar PCT%
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
} < <(jq -r '
  .model.display_name,
  .model.id,
  (.effort.level // ""),
  (.context_window.used_percentage // 0 | floor),
  .session_id
' <<<"$input")

# 1M context variant is encoded in the model id (e.g. claude-opus-4-7[1m])
case "$MODEL_ID" in *1m*) MODEL="${MODEL} 1M" ;; esac
[ -n "$EFFORT" ] && MODEL="${MODEL}·${EFFORT}"

# Git state cached for 5s, keyed on session_id so concurrent sessions don't collide.
# stat -f %m is macOS; fall back to -c %Y on Linux.
CACHE="/tmp/claude-statusline-git-$SESSION_ID"
mtime=$(stat -f %m "$CACHE" 2>/dev/null || stat -c %Y "$CACHE" 2>/dev/null || echo 0)
if [ ! -f "$CACHE" ] || [ $(($(date +%s) - mtime)) -gt 5 ]; then
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

# Color-graded bar: green <70, yellow 70-89, red >=90
RESET='\033[0m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
if [ "$PCT" -ge 90 ]; then
    BAR_COLOR=$RED
elif [ "$PCT" -ge 70 ]; then
    BAR_COLOR=$YELLOW
else
    BAR_COLOR=$GREEN
fi

FILLED=$((PCT / 10))
EMPTY=$((10 - FILLED))
FILL=""
PAD=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s"
BAR="${FILL// /▓}${PAD// /░}"

GIT_PART=""
if [ -n "$BRANCH" ]; then
    GIT_PART=" ${CYAN}${BRANCH}${RESET}"
    [ "${STAGED:-0}" -gt 0 ] && GIT_PART="${GIT_PART} ${GREEN}+${STAGED}${RESET}"
    [ "${MODIFIED:-0}" -gt 0 ] && GIT_PART="${GIT_PART} ${YELLOW}~${MODIFIED}${RESET}"
fi

printf '%b\n' "[${MODEL}]${GIT_PART}  ${BAR_COLOR}${BAR}${RESET} ${PCT}%"
