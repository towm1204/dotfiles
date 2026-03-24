---
name: commit-dotfiles
description: Commit and push dotfile changes with a semantic commit message
model: haiku
---
Commit and push all changes in `~/dotfiles`. **ONLY operates on `~/dotfiles` — never commit or push in any other repo.**

## Steps

1. `cd ~/dotfiles` — all commands MUST run from this directory. If `~/dotfiles` doesn't exist, report error and stop.
2. `git status` — if clean, report "no changes" and stop.
3. `git diff` and `git diff --cached` to understand changes.
4. `git add -A` to stage everything.
5. `git diff --cached --stat` and `git diff --cached --name-only` to see what's staged.
6. Write a short semantic commit message (e.g. `update claude skills`, `add zsh aliases`). Single line, no body, no trailers.
7. `git commit -m "msg"` then `git push`.
8. Report result.
