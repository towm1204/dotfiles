---
name: note
description: Find, create, or update notes for the current repository. Use `find` to search existing notes; use a slug to create or update one.
argument-hint: [find|<slug>]
model: haiku
---

# Note Skill

Notes are stored at `~/.claude/notes/{org}/{repo}/{slug}.md` — org/repo derived from git remote.

## Arguments

- `find` — find existing notes without creating
  - `/note find` — list all notes for current repo
  - `/note find {q}` — smart search: exact slug match first, falls back to title+filename search
- `<slug>` — create or update a note; invokes the note-taker agent

## Step 1: Parse arguments

- `find_mode` = true if first argument is `find`
- `query` = search term (optional in find mode)

## Step 2: Route by mode

### Find mode

**No query — list all notes:**

```bash
~/.claude/skills/note/scripts/note-list.sh
```

Returns tab-separated `<slug>\t<org/repo>\t<path>\t<title>` per line.
Display as a readable list with slug and title. Offer to open any of them.
If empty: "No notes found" and suggest `/note <slug>` to create one.

**With query — smart search:**

First try exact slug match:
```bash
result=$(~/.claude/skills/note/scripts/note-find.sh {query})
status=$(echo "$result" | cut -f1)
note_path=$(echo "$result" | cut -f2)
```

- If `found`: show path, read and summarize, offer to open or edit. Stop here.
- If `new`: fall back to search:

```bash
~/.claude/skills/note/scripts/note-search.sh {query}
```

Returns tab-separated `<slug>\t<path>\t<title>` for each match (case-insensitive, searches slug + title).

If matches found: display as a list and offer to open any of them.
If no matches: say nothing found, suggest `/note {slug}` to create one.

**Then stop** — do not create notes in find mode.

### Create/Update mode

If slug is missing, ask the user what to name the note and suggest one based on recent context.

Invoke the note-taker agent in Write mode with the slug and current session context.
