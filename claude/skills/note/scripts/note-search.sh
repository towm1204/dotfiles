#!/usr/bin/env bash
# Usage: note-search.sh <query>
# Case-insensitive search across slug (filename) and H1 title for current repo.
# Output tab-separated: slug<TAB>path<TAB>title

set -euo pipefail

QUERY="${1:-}"

if [[ -z "$QUERY" ]]; then
  echo "Usage: note-search.sh <query>" >&2
  exit 1
fi

REMOTE_URL=$(git remote get-url origin 2>/dev/null) || {
  echo "No git remote found" >&2
  exit 1
}

if [[ "$REMOTE_URL" =~ ^git@[^:]+:([^/]+)/([^/.]+)(\.git)?$ ]]; then
  ORG="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
elif [[ "$REMOTE_URL" =~ ^https?://[^/]+/([^/]+)/([^/.]+)(\.git)?$ ]]; then
  ORG="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
else
  echo "Could not parse org/repo from remote: $REMOTE_URL" >&2
  exit 1
fi

NOTES_DIR="${HOME}/.claude/notes/${ORG}/${REPO}"

[[ -d "$NOTES_DIR" ]] || exit 0

QUERY_LOWER=$(echo "$QUERY" | tr '[:upper:]' '[:lower:]')

for note_path in "$NOTES_DIR"/*.md; do
  [[ -f "$note_path" ]] || continue

  slug=$(basename "$note_path" .md)
  title=$(grep -m1 "^# " "$note_path" 2>/dev/null | sed 's/^# //' || echo "(no title)")

  slug_lower=$(echo "$slug" | tr '[:upper:]' '[:lower:]')
  title_lower=$(echo "$title" | tr '[:upper:]' '[:lower:]')

  if [[ "$slug_lower" == *"$QUERY_LOWER"* || "$title_lower" == *"$QUERY_LOWER"* ]]; then
    printf "%s\t%s\t%s\n" "$slug" "$note_path" "$title"
  fi
done
