# shellcheck shell=bash
# SC2046: __fzf_git_color outputs a single token; word splitting is safe.
# SC2154: $__fzf_git is set by fzf-git.sh, which must be sourced before this file.
# shellcheck disable=SC2046,SC2154

# Local overrides for junegunn/fzf-git.sh. Source this AFTER fzf-git.sh.
#
# fzf-git.sh exposes only five env vars and one redefinable hook
# (_fzf_git_fzf, for fzf options) — none of which let us tune the input
# pipeline. The function below is therefore a near-verbatim copy of upstream's
# `_fzf_git_files`, with one substantive change.

# Why the copy: upstream hard-codes `git status --untracked-files=all` (PR #93,
# deliberate) so the picker can surface untracked files inside untracked
# directories. On a 300k-file monorepo that walk is ~2s warm / ~4s cold even
# with core.fsmonitor + core.untrackedCache enabled, because git still has to
# materialise every untracked path. Switching to `--untracked-files=no` drops
# the call to ~40ms.
#
# Trade-off: untracked files no longer appear in the picker. To pull a brand
# new file in, run `git add -N <path>` first — that registers an
# intent-to-add so it shows up in `git ls-files`.
#
# Drop this override if upstream ever exposes a knob (track:
# https://github.com/junegunn/fzf-git.sh).
_fzf_git_files() {
    _fzf_git_check || return
    local root query extract_file_name
    root=$(git rev-parse --show-toplevel)
    [[ -n "$(git rev-parse --show-prefix)" ]] && query='!../ '

    read -r -d "" extract_file_name <<'EOF'
"$(cut -c4- <<< {} | sed 's/.* -> //;s/^"//;s/"$//;s/\\"/"/g')"
EOF

    (
        git -c core.quotePath=false -c color.status=$(__fzf_git_color) status --short --no-branch --untracked-files=no
        git -c core.quotePath=false ls-files "$root" | grep -vxFf <(
            git -c core.quotePath=false status --short --untracked-files=no |
                cut -c4- | sed -e 's/.* -> //' -e '/^"[^"\\]*"$/ { s/^"//;s/"$//; }'
            echo :
        ) | sed 's/^/   /'
    ) |
        _fzf_git_fzf -m --ansi --nth 2..,.. \
            --border-label '📁 Files ' \
            --header 'CTRL-O (open in browser) ╱ ALT-E (open in editor)' \
            --bind "ctrl-o:execute-silent:bash \"$__fzf_git\" --list file $extract_file_name" \
            --bind "alt-e:execute:${EDITOR:-vim} $extract_file_name" \
            --query "$query" \
            --preview "git -c core.quotePath=false diff --no-ext-diff --color=$(__fzf_git_color .) -- $extract_file_name | $(__fzf_git_pager); $(__fzf_git_cat) $extract_file_name" "$@" |
        cut -c4- | sed 's/.* -> //'
}
