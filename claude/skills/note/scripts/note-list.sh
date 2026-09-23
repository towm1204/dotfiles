#!/usr/bin/env bash
# Usage: note-list.sh
# Lists every note. Outputs tab-separated: slug  path  title

set -euo pipefail

NOTES_DIR="${HOME}/.claude/notes"

[[ -d "$NOTES_DIR" ]] || exit 0

for note_path in "$NOTES_DIR"/*.md; do
  [[ -f "$note_path" ]] || continue
  slug=$(basename "$note_path" .md)
  title=$(grep -m1 "^# " "$note_path" 2>/dev/null | sed 's/^# //' || echo "(no title)")
  printf "%s\t%s\t%s\n" "$slug" "$note_path" "$title"
done
