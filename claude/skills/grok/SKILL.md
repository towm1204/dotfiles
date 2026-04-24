---
name: grok
description: Document a domain, topic, or system area. Pass context (what to document + any sources/files). Lists existing notes so the user can pick one to update or create a new one.
argument-hint: <context about what to document>
---

# Grok Skill

Takes user-provided context and writes or updates a note around that domain/topic.

## Step 1: Validate argument

If no argument is provided, ask: "What do you want to document? Include the domain, topic, and any relevant files or sources."

## Step 2: List existing notes

```bash
~/.claude/skills/note/scripts/note-list.sh
```

Display as a numbered list (`1. slug — title`), with a final option: **N. New note**. Ask: "Which note should I update, or N for a new one?"

## Step 3: Resolve destination

- **Existing selected**: use that slug. Pass slug + context to note-taker agent.
- **New selected**: ask "What should I file this under?" — use their answer as the slug. Pass slug + context to note-taker agent.

## Step 4: Invoke note-taker agent

Pass verbatim:
- The full user argument (context, domain/topic, sources mentioned)
- The resolved slug (existing or new)

The agent has no conversation history — the context is its only source. It will read any files mentioned in the context.

## Step 5: Show result

After the agent completes, read the note file and display its full contents. Do not rely on the agent's summary.
