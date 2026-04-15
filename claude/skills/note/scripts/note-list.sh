#!/usr/bin/env bash
# Usage: note-list.sh [org/repo]
# Lists all notes, optionally filtered to a specific org/repo
# Outputs tab-separated: slug  org/repo  path  title

set -euo pipefail

NOTES_DIR="${HOME}/.claude/notes"
FILTER="${1:-}"

if [[ ! -d "$NOTES_DIR" ]]; then
  exit 0
fi

find "$NOTES_DIR" -name "*.md" | sort | while read -r filepath; do
  # Extract org/repo/slug from path
  relative="${filepath#${NOTES_DIR}/}"   # org/repo/slug.md
  slug=$(basename "$relative" .md)
  org_repo=$(dirname "$relative")        # org/repo

  # Apply filter if provided
  if [[ -n "$FILTER" && "$org_repo" != "$FILTER" ]]; then
    continue
  fi

  # Extract H1 title from first line starting with "# "
  title=$(grep -m1 "^# " "$filepath" 2>/dev/null | sed 's/^# //' || echo "(no title)")

  printf "%s\t%s\t%s\t%s\n" "$slug" "$org_repo" "$filepath" "$title"
done
