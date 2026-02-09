---
name: gt-sync
description: Sync the Graphite stack with trunk and resolve any rebase conflicts
disable-model-invocation: true
argument-hint: ""
---

Sync the current Graphite stack with trunk (fetch + rebase) and resolve any merge conflicts that arise.

## Steps

### Phase 1: Pre-flight

1. Run `gt ls` to show the current stack state
2. Run `git status` to ensure the working tree is clean
   - If dirty, warn the user and suggest stashing or committing first
   - Do NOT proceed with a dirty working tree

### Phase 2: Sync

3. Run `gt sync`
4. Check the exit code and output for conflicts

### Phase 3: Resolve conflicts (if any)

5. If `gt sync` reports conflicts:
   - Run `git status` to identify conflicted files
   - For each conflicted file:
     - Read the file to understand both sides of the conflict
     - Resolve the conflict by choosing the correct resolution
     - Stage the resolved file with `git add <file>`
   - Run `gt continue` to resume the rebase
   - If new conflicts appear, repeat this step
6. Run `gt ls` to confirm the stack is clean after sync

### Phase 4: Summary

7. Show `gt log short` for the final stack state
8. Report which branches were updated and any conflicts that were resolved

## Rules

- NEVER proceed with a dirty working tree — warn and stop
- NEVER discard changes during conflict resolution without asking the user
- ALWAYS show the conflicted hunks to the user before resolving
- ALWAYS prefer the intent of the local (stack) changes unless the user says otherwise
- If a conflict is ambiguous or involves logic changes on both sides, ask the user how to resolve it
- If `gt` is not installed, suggest: `brew install withgraphite/tap/graphite`
