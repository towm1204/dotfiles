#!/usr/bin/env bash
# Usage: note-find.sh <slug>
# Outputs tab-separated: found<TAB><path> or new<TAB><path> (where it would be created)

set -euo pipefail

SLUG="${1:-}"

if [[ -z "$SLUG" ]]; then
  echo "Usage: note-find.sh <slug>" >&2
  exit 1
fi

NOTE_PATH="${HOME}/.claude/notes/${SLUG}.md"

if [[ -f "$NOTE_PATH" ]]; then
  printf "found\t%s\n" "$NOTE_PATH"
else
  printf "new\t%s\n" "$NOTE_PATH"
fi
