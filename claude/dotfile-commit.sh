#!/bin/bash
# Auto-commit dotfile changes with semantic commit messages via haiku
set -e

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

# Check for any changes (staged, unstaged, or untracked)
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  exit 0
fi

# Stage all changes
git add -A

# Get the diff for commit message generation
diff=$(git diff --cached --stat)
files=$(git diff --cached --name-only)

# Generate semantic commit message via haiku
msg=$(echo "$diff" | claude -p --model haiku "Write a single-line git commit message for these dotfile changes. Files changed: $files. Be concise and semantic (e.g. 'add post-tool-use hook', 'adjust zsh aliases', 'remove old config'). No quotes, no period, lowercase. Just the message, nothing else.")

# Fallback if claude fails
if [ -z "$msg" ]; then
  msg="update $(echo "$files" | head -1)"
fi

git commit -m "$msg"
git push

echo "{\"systemMessage\":\"dotfiles: $msg\"}"
