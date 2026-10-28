---
name: ship-in-worktree
description: Implement an approved plan in throwaway git worktrees off fresh master, commit, open PRs, then clean up, without touching the local checkout. Use when the user invokes /ship-in-worktree or asks to "do it in a worktree" after planning.
---

# Ship in worktree

Git writes still need a yes each time, per CLAUDE.md. Confirm before each commit, push, and PR.

## PR split
- Default: one PR per repo touched.
- If the user gave a split, use it.
- If the change has natural seams, propose a split before starting and wait for an answer. Name what goes in each PR and which ones stack. Typical seams:
  - migration + models first, logic stacked on it
  - BE and FE as separate PRs
  - a refactor the feature depends on, as its own PR

## Setup
- Per repo: `git fetch origin <default>`, then `git worktree add -b tow/<slug> /Users/tow-cfp/cfp/.worktrees/<repo>-<slug> origin/<default>`
- Never checkout, stash, reset or commit in the main checkout. Its branch and uncommitted changes stay exactly as they were.
- Stacked PRs: branch B off branch A in the same worktree, PR base = A. Link A in B's description.

## Running commands
- Nothing runs in the worktree: no pytest, yarn, tsc or app.
- If something needs the app or DB (e.g. a migration), run it in the main checkout and only take the output:
  - `make im-check-heads`, and confirm the head matches the latest migration on origin/<default>
  - `make im-db-revision m='...'`, then `mv` the generated file into the worktree. Leave nothing behind in the main checkout.
- Every subagent prompt starts with `cd <worktree path>` and says it can't run anything.
- Tests get written by test-writer but not run. Say so in the PR.

## Commits
- BE pre-commit runs fine. If mypy fails only on errors that were already there, use `SKIP=mypy` and name those files in the PR.
- FE husky fails without node_modules, so use `--no-verify`, format by hand to prettier style, and note it in the PR.
- Re-stage after black rewrites files.

## Cleanup (after every PR exists)
- Leave the worktree first, then run `git worktree remove <path>` from the main repo dir.
- Delete the empty `.worktrees` folder from a cwd outside it.
- Confirm `git worktree list` and the main checkout's `git status` are unchanged.
