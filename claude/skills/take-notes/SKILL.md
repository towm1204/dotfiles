---
name: take-notes
description: Review the current session or branch diff and identify discoveries worth documenting as notes. Lists existing notes so the user can pick one to update, or create a new one.
argument-hint: [branch|session|changes]
---

# Take Notes Skill

Gathers context, lists existing notes, lets the user pick a destination, then hands off to the note-taker agent to write.

## Step 1: Gather context

**No argument or `session`:** Walk the full conversation and produce a structured list of every topic explored, workflow traced, discovery made, or decision reached. For each item include:
- What it is (system, concept, file, flow, pattern)
- Where it lives (file paths, module names, entry points) if known
- What was non-obvious or surprising about it
- Any side effects, dependencies, or gotchas uncovered

Do not compress or summarize — the agent receiving this has no conversation history, so this list must be complete enough for it to write a useful note and for a reader to rediscover the topic independently.

**`branch`:** Get the diff between current branch and master:
```bash
git diff master...HEAD
```
Then produce the same structured list above based on the diff.

**`changes`:** Get uncommitted and unstaged changes (working tree vs HEAD):
```bash
git diff HEAD
```
Then produce the same structured list above based on the diff.

## Step 2: List existing notes

```bash
~/.claude/skills/note/scripts/note-list.sh
```

Present a numbered list of existing notes (slug + title), with a final option for **New note**. Ask the user to pick.

## Step 3: Invoke note-taker agent

Pass the full structured list from Step 1 verbatim to the note-taker agent — do not re-summarize it. The agent has no conversation history; this list is its only source of truth.
- **Existing note selected:** pass the slug — agent goes straight to Write mode for that note.
- **New note selected:** ask the user "This looks like a new topic — what should I file it under?" and use their answer as the note topic/slug. Pass that slug to the agent — agent goes straight to Write mode without proposing its own slug.

## Step 4: Show the result

After the agent completes, **read the note file and display its full contents** to the user. Do not rely on the agent's summary — show the actual written note.
