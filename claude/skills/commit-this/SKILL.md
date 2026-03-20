---
name: commit-this
description: Commit staged/unstaged changes with pre-commit hook handling
---
Commit all uncommitted changes in the current branch. If $ARGUMENTS is provided, use it as commit message context. Otherwise, write a brief commit message.

## Steps

1. `git status` (no -uall) and `git diff` to see changes.
2. Stage relevant files by name (not `git add -A`). Ask user which files if ambiguous.
3. Write a concise commit message. Do NOT add Co-Authored-By trailers.
4. Run `git commit` (never --no-verify).
5. After successful commit, `git push` to remote (set upstream with `-u` if needed).

## Pre-commit hook handling

### Black
If black fails and reformats files: re-stage the reformatted files and commit again. No user interaction needed.

### Mypy
If mypy fails:
1. Review each error. Fix errors that are trivially fixable with **zero behavior change** (e.g. missing type annotation, import order).
2. Present user a recap: what was fixed, what's unfixable.
3. If user suggests fixes for "unfixable" items: re-evaluate, fix what's now fixable, present updated list.
4. Repeat until no unfixables remain or user says skip.
5. If skipping: commit with `SKIP=mypy git commit -m "msg"`.

### Other hooks
If other hooks fail: report to user and ask how to proceed.
