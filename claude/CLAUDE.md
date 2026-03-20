## Communication Style
- Extremely concise in all interactions
- Sacrifice grammar for brevity
- Keep responses short & direct

## Code Style
- Single-line comments: concise
- Multi-line comments: fuller sentences, still concise
- Use sentence case for UI copies

## Planning & Changes
- After planning, ask as many followup/clarifying questions as possible before implementing
- Don't blindly trust existing code patterns — understand impact of changes
- For widely-used/common components: don't need to audit every usage, but consider what can break

## Git & PRs
- Branch naming: `tow/short-change-name`
- PR descriptions: single short bullet preferred. Don't over-describe but don't use "TSIA" either.

## Memory management

**Proactive learning — after completing any task, check if any of these occurred:**
- Learned something new about the project (architecture, patterns, gotchas)
- User corrected an implementation detail or source code I generated
- Struggled to find information and had to infer/look up project details
- Discovered something non-obvious that should be persisted for future sessions

**Quality gate:** only persist things that would change Claude's behavior in a future session. Skip one-off fixes, obvious-from-code details, or generic knowledge.

**When a learning is detected, proactively surface it using this format:**

> **📝 Learning detected:** [concise description of what was learned]
> **Proposed save location:** `[file path]` — [section if applicable]

Then prompt user to sign-off before saving.

**Rules:**
- Each entry: 1-3 lines max (including section header). If it needs more, it's too complex for CLAUDE.md — graduate it to a `/docs:topic` skill instead.
- Before saving, check the target file for existing entries on the same topic. Update in place rather than appending duplicates.
- Before saving, check target file line count. If >150 lines, run `/cleanup-memory` first before adding more.
- Where to save: defer to project `CLAUDE.md` for save locations; cross-project/personal → `~/.claude/CLAUDE.md`