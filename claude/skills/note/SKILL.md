---
name: note
description: Find notes for the current repository — list all or search by keyword. Use `/grok` to create or update a note.
argument-hint: [query]
---

**Run the scripts below via a general-purpose agent with model: haiku (it returns the raw output).**

# Note Skill

Notes are stored at `~/.claude/notes/{org}/{repo}/{slug}.md` — org/repo derived from git remote.

## Step 1: Parse argument

`query` = search term (optional)

## Step 2: No query — list all notes

```bash
~/.claude/skills/note/scripts/note-list.sh
```

Returns tab-separated `<slug>\t<org/repo>\t<path>\t<title>` per line.
Display as a readable list with slug and title. **Always ask: "Want me to read any of these?"**
If empty: "No notes found" and suggest `/grok` to create one.

## Step 3: With query — smart search

First try exact slug match:
```bash
result=$(~/.claude/skills/note/scripts/note-find.sh {query})
status=$(echo "$result" | cut -f1)
note_path=$(echo "$result" | cut -f2)
```

- If `found`: read and summarize the note, then ask "Want me to keep this in context?" Stop here.
- If `new` (no exact match): fall back to search:

```bash
~/.claude/skills/note/scripts/note-search.sh {query}
```

Returns tab-separated `<slug>\t<path>\t<title>` for each match (case-insensitive, searches slug + title).

If matches found: display as a list, then ask "Want me to read any of these?"
If no matches: say nothing found, suggest `/grok` to create one.
