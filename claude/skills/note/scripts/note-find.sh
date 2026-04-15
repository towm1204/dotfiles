#!/usr/bin/env bash
# Usage: note-find.sh <slug>
# Outputs tab-separated: found<TAB><path> or new<TAB><path> (where it would be created)
# Exits 1 on missing git remote

set -euo pipefail

SLUG="${1:-}"

if [[ -z "$SLUG" ]]; then
  echo "Usage: note-find.sh <slug>" >&2
  exit 1
fi

REMOTE_URL=$(git remote get-url origin 2>/dev/null) || {
  echo "No git remote found — cannot derive repo context" >&2
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

NOTE_PATH="${HOME}/.claude/notes/${ORG}/${REPO}/${SLUG}.md"

if [[ -f "$NOTE_PATH" ]]; then
  printf "found\t%s\n" "$NOTE_PATH"
else
  printf "new\t%s\n" "$NOTE_PATH"
fi
