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
- When planning: always study existing code patterns first before proposing implementation
- Implement tests before writing code (TDD); exception: existing modules with no existing tests — testing optional for now

## File Navigation & Research
- Don't search for files via text search — ask where things are if unsure
- If grep is taking >~20 seconds, ask instead
- Use imports/usage for context; if that's also taking >~20 seconds, ask instead
- Refer to existing examples when implementing/planning — don't invent new patterns or syntax
- Ask what to reference if unclear

## Agents

- **CRITICAL — Code review**: ANY request related to reviewing code — including "review", "diff", "check changes", "look at changes", "review this branch", "review PR", or any variant — MUST immediately invoke the `code-reviewer` subagent via the Agent tool. Never run `git diff` yourself. Never do an inline review. Do not do any preliminary work — invoke the agent as the first and only action.
- **CRITICAL — Codebase search**: ANY codebase search (Grep, Glob, content search, finding files) MUST be delegated to the `Explore` subagent. Never run Grep or Glob directly. Pass a clear description of what to find and the desired thoroughness level.
- **CRITICAL — Validation**: After making code changes, ALWAYS run validation using the `general-purpose` subagent with `model: "haiku"`. Read the project's CLAUDE.md for the correct build commands. The agent should return a pass/fail summary.
- **Note-taker**: When invoking the `note-taker` subagent, always pass `model: "opus"`.

## Notes

Notes live at `~/.claude/notes/{org}/{repo}/{slug}.md`. These capture non-obvious discoveries — architecture orientation, system maps, side effects, disjointed dependencies — things that take 30+ min to reverse-engineer and are invisible from the code.

## Git & PRs
- Branch naming: `tow/short-change-name`
- Commit messages: single line only, no body
- PR descriptions: single short bullet preferred. Don't over-describe but don't use "TSIA" either.
