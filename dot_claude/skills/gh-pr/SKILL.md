---
name: gh-pr
description: Create a GitHub pull request for the current branch
disable-model-invocation: true
argument-hint: "[title] (optional — auto-generates if omitted)"
---

Create a GitHub pull request from the current branch.

## Steps

1. Run `git branch --show-current` to get the source branch
2. Run `git log main..HEAD --oneline` to see all commits being PR'd
3. Run `git diff main...HEAD --stat` to see changed files summary
4. If there are unpushed commits, push the branch with `git push -u origin HEAD`
5. If $ARGUMENTS is provided, use it as the PR title
6. Otherwise, draft a title from the commits (keep under 70 chars)
7. Generate a PR body with:
   - `## Summary` — 1-3 bullet points
   - `## Test plan` — checklist of testing steps
   - Footer: `🤖 Generated with [Claude Code](https://claude.com/claude-code)`
8. Create the PR: `gh pr create --title "..." --body "..."`
9. Output the PR URL

## Rules

- Default base branch: `main`
- NEVER force push
- If the branch has no commits ahead of main, abort and explain
