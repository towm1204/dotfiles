---
name: take-notes
description: Review the current session or branch diff and identify discoveries worth documenting as notes. Proposes candidates, waits for confirmation, then writes them.
argument-hint: [branch|session|both|changes]
---

# Take Notes Skill

Gathers context and hands it to the note-taker agent to evaluate, propose candidates, confirm with the user, and write.

## Step 1: Gather context

**No argument or `session`:** Summarize the current conversation — what was explored, discovered, debugged.

**`branch`:** Get the diff between current branch and master:
```bash
git diff master...HEAD
```

**`both`:** Gather both (session summary + branch diff).

**`changes`:** Get uncommitted and unstaged changes (working tree vs HEAD):
```bash
git diff HEAD
```

## Step 2: Invoke note-taker agent

Pass the gathered context to the note-taker agent with no slug. The agent handles evaluation, proposing candidates, confirming with the user, and writing.
