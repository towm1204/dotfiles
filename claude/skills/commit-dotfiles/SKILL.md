---
name: commit-dotfiles
description: Commit and push dotfile changes with a semantic commit message
model: haiku
---
Commit and push all changes in `~/dotfiles`.

## Steps

1. `cd ~/dotfiles && git status` — if clean, report "no changes" and stop.
2. `git diff` and `git diff --cached` to understand changes.
3. `git add -A` to stage everything.
4. `git diff --cached --stat` and `git diff --cached --name-only` to see what's staged.
5. Write a short semantic commit message (e.g. `update claude skills`, `add zsh aliases`). Single line, no body, no trailers.
6. `git commit -m "msg"` then `git push`.
7. Report result.
