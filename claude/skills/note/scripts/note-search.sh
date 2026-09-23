#!/usr/bin/env bash
# Usage: note-search.sh <query>
# Case-insensitive match across slug, H1 title, and Summary section.
# Outputs tab-separated: slug  path  title

set -euo pipefail

QUERY="${1:-}"

if [[ -z "$QUERY" ]]; then
  echo "Usage: note-search.sh <query>" >&2
  exit 1
fi

NOTES_DIR="${HOME}/.claude/notes"

[[ -d "$NOTES_DIR" ]] || exit 0

QUERY_LOWER=$(echo "$QUERY" | tr '[:upper:]' '[:lower:]')

for note_path in "$NOTES_DIR"/*.md; do
  [[ -f "$note_path" ]] || continue

  slug=$(basename "$note_path" .md)
  title=$(grep -m1 "^# " "$note_path" 2>/dev/null | sed 's/^# //' || echo "(no title)")

  slug_lower=$(echo "$slug" | tr '[:upper:]' '[:lower:]')
  title_lower=$(echo "$title" | tr '[:upper:]' '[:lower:]')
  summary_lower=$(awk '/^## Summary/{found=1; next} found && /^#/{exit} found{print}' "$note_path" | tr '[:upper:]' '[:lower:]')

  if [[ "$slug_lower" == *"$QUERY_LOWER"* || "$title_lower" == *"$QUERY_LOWER"* || "$summary_lower" == *"$QUERY_LOWER"* ]]; then
    printf "%s\t%s\t%s\n" "$slug" "$note_path" "$title"
  fi
done
