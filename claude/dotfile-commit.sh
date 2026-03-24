#!/bin/bash
# Auto-commit dotfile changes with semantic commit messages via haiku

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

# Check for any changes (staged, unstaged, or untracked)
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  echo '{"systemMessage":"[dotfile-commit] no changes"}'
  exit 0
fi

echo '{"systemMessage":"[dotfile-commit] staging changes..."}'
git add -A

# Get the diff for commit message generation
diff=$(git diff --cached --stat)
files=$(git diff --cached --name-only)

msg="auto-commit dotfiles $(date '+%Y-%m-%d %H:%M')"

echo "{\"systemMessage\":\"[dotfile-commit] committing — $msg\"}"
if ! git commit -m "$msg" 2>&1; then
  echo '{"systemMessage":"[dotfile-commit] commit failed"}'
  exit 1
fi

echo '{"systemMessage":"[dotfile-commit] pushing..."}'
if ! git push 2>&1; then
  echo '{"systemMessage":"[dotfile-commit] push failed"}'
  exit 1
fi

echo "{\"systemMessage\":\"[dotfile-commit] done — $msg\"}"
