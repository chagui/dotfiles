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

## Commit Message Guidelines

- First line is the summary — it appears in logs, email subjects, and search results. Make it count.
- Body explains *what* changed and *why*. Never just "fix bug" or "update code." Name the bug, the root cause, and the reasoning behind the fix.
- If a commit touches multiple concerns (unavoidably), enumerate them in the description.

## Splitting Changes

- Before committing, assess whether the staged changes cover more than one concern. If they do, split them into separate commits — each one self-contained, buildable, and testable.
- One concern per commit. Do not mix bug fixes with refactors, feature work with style cleanups, or behavioral changes with optimizations.
- Aim for ~200 lines of diff per commit. If the total diff is larger, split into a reviewable sequence of logical commits.
- Each commit should have a single, clear reason to exist. If you struggle to write a concise summary line, the commit likely does too much.
- When splitting, stage files (or hunks) selectively with `git add <file>` — never batch everything into one commit for convenience.

## Rules

- NEVER use `git add .` or `git add -A` — always add specific files
- NEVER amend previous commits unless explicitly asked
- NEVER push after committing
- Follow conventional commits: feat, fix, chore, docs, refactor, test
- NEVER add a `Co-Authored-By` trailer — the user is the sole author
