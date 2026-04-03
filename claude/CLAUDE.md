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
- **CRITICAL**: All settings and permission settings go to `~/.claude/settings.json` (user-level) no exceptions and never save to `.claude/settings.local.json`

## File Navigation & Research
- Don't search for files via text search — ask where things are if unsure
- If grep is taking >~20 seconds, ask instead
- Use imports/usage for context; if that's also taking >~20 seconds, ask instead
- Reference existing examples when implementing/planning — don't invent new patterns or syntax
- Ask what to reference if unclear

## Git & PRs
- Branch naming: `tow/short-change-name`
- Commit messages: single line only, no body
- PR descriptions: single short bullet preferred. Don't over-describe but don't use "TSIA" either.
