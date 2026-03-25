## Communication Style
- Extremely concise in all interactions, commit messages and PR descriptions
- Sacrifice grammar for brevity
- Keep responses short & direct

## Code Style
- Single-line comments: concise
- Multi-line comments: fuller sentences, still concise
- Use sentence case for UI copies — no Title Case

## Planning & Changes
- After planning, ask as many followup/clarifying questions as possible before implementing
- Don't blindly trust existing code patterns — understand impact of changes
- For widely-used/common components: don't need to audit every usage, but consider what can break

## Settings
- **CRITICAL**: All settings changes go to `~/.claude/settings.json` (user-level). **NEVER** write to project `.claude/settings.local.json`. No exceptions.

## Git & PRs
- Branch naming: `tow/short-change-name`
- Commit messages: single line only, no body
- PR descriptions: single short bullet preferred. Don't over-describe but don't use "TSIA" either.
