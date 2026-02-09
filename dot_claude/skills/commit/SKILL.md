---
name: commit
description: Stage and commit changes with a conventional commit message
disable-model-invocation: true
argument-hint: "[message] (optional — auto-generates if omitted)"
---

Create a git commit for the current changes.

## Steps

1. Run `git status` to see all changes (staged and unstaged)
2. Run `git diff` and `git diff --staged` to understand the changes
3. Run `git log --oneline -5` to see recent commit style
4. If there are unstaged changes, ask which files to stage (prefer specific `git add <file>` over `git add .`)
5. If $ARGUMENTS is provided, use it as the commit message. Otherwise, draft a message following the repo's conventional commit style: `type(scope): description`
6. Create the commit
7. Show the result with `git log --oneline -1`

## Rules

- NEVER use `git add .` or `git add -A` — always add specific files
- NEVER amend previous commits unless explicitly asked
- NEVER push after committing
- Follow conventional commits: feat, fix, chore, docs, refactor, test
- End the commit message with: `Co-Authored-By: Claude <noreply@anthropic.com>`
