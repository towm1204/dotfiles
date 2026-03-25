---
name: remember
description: Review session for learnings and save to appropriate CLAUDE.md or domain agent
---
Review the current session for learnings using the guidelines
in the "Memory management" section of ~/.claude/CLAUDE.md.

Route learnings to the right target:
- Cross-cutting → project root CLAUDE.md
- Domain-specific → relevant .claude/agents/ file (create if needed)
- Workflow pattern → propose a .claude/skills/ file
- Personal → ~/.claude/CLAUDE.md

If $ARGUMENTS is provided, also consider saving that specific information.
