---
name: commit-dotfiles
description: Commit and push dotfile changes with a semantic commit message
---
**Invoke the general-purpose agent with model: haiku to execute this skill.**

Commit and push all changes in `~/dotfiles`. **ONLY operates on `~/dotfiles` — never commit or push in any other repo.**

## Steps

**IMPORTANT**: Never use `cd ~/dotfiles && git ...` — compound commands trigger sandbox security prompts. Always use `git -C ~/dotfiles` to avoid this.

1. `ls ~/dotfiles/.git` — verify repo exists. If not, report error and stop.
2. `git -C ~/dotfiles status` — if clean, report "no changes" and stop.
3. `git -C ~/dotfiles diff` and `git -C ~/dotfiles diff --cached` to understand changes.
4. `git -C ~/dotfiles add -A` to stage everything.
5. `git -C ~/dotfiles diff --cached --stat` and `git -C ~/dotfiles diff --cached --name-only` to see what's staged.
6. Write a short semantic commit message (e.g. `update claude skills`, `add zsh aliases`). Single line, no body, no trailers.
7. `git -C ~/dotfiles commit -m "msg"` then `git -C ~/dotfiles push`.
8. Report result.
