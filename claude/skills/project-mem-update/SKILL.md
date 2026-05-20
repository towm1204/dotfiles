---
name: project-mem-update
description: Review session and update project CLAUDE.md files with useful project-wide knowledge (patterns, conventions, framework guidance).
---

**Invoke the general-purpose agent with model: sonnet to execute this skill.**

# Project Memory Update

Review the current session and propose updates to project CLAUDE.md files. Captures project-wide structural knowledge — not product-specific data models or endpoint details (those belong in notes).

## What belongs in CLAUDE.md

- Framework patterns, conventions, syntax
- Architecture guidance (e.g. how endpoints are structured under a path)
- Tooling know-how, build/deploy patterns
- Testing conventions, gotchas that apply broadly
- Style rules, naming conventions
- Cross-cutting concerns (auth patterns, error handling patterns)

## What does NOT belong (goes in notes instead)

- Specific data model fields or relationships
- Individual endpoint behavior or business logic
- Product feature details
- One-off debugging findings

## Process

### Step 1: Review session

Summarize the current conversation. Identify any learnings that qualify as project-wide knowledge per the criteria above. Be selective — only surface things that would genuinely help future sessions.

If nothing qualifies, say so and stop.

### Step 2: Propose target file

Find all existing CLAUDE.md files:
```bash
find . -name "CLAUDE.md" -not -path "*/node_modules/*" | sort
```

Propose which CLAUDE.md to update — or propose creating a new one in a subdirectory if the knowledge is scoped to a specific area (e.g. `investment_management/core/api/CLAUDE.md`, `investment_management/core/models/CLAUDE.md`).

Present:
- The target file path
- Why this location makes sense
- If new: what the file would cover

**Wait for user confirmation or redirect before continuing.**

### Step 3: Review existing content + propose diff

Read the target CLAUDE.md (if it exists). Then:

1. **Merge**: integrate new knowledge into the existing structure. Don't just append — find the right section, or create one if needed.
2. **Deduplicate**: if the new knowledge overlaps with or supersedes existing content, merge them. Remove the redundant version.
3. **Contradiction check**: if new knowledge contradicts existing content, flag it and ask the user which is correct before proceeding.
4. **Trim**: while you're in the file, flag any existing content that looks stale, redundant, or overly verbose — same criteria as `/cleanup-memory`. Propose removing it as part of the same update.

Present the proposed changes as a clear before/after or diff summary. Include:
- What's being added
- What's being removed or merged (if anything)
- Any contradictions found (ask user)

**Wait for user approval before editing.**

### Step 4: Apply changes

Edit the CLAUDE.md file. Show the final result.

## Rules

- Never edit `~/.claude/CLAUDE.md` (user's global config)
- Never auto-edit — always get user approval on both location and content
- Be aggressive about conciseness — match the terse style of existing CLAUDE.md files
- One update per invocation — don't try to update multiple CLAUDE.md files at once
- If multiple files could benefit, propose the most impactful one and mention the others
