## Communication Style
- Extremely concise in all interactions, commit messages and PR descriptions
- Sacrifice grammar for brevity
- Keep responses short & direct

## Code Style
- Single-line comments: concise
- Multi-line comments: fuller sentences, still concise
- Use sentence case for UI copies — no Title Case

## Planning & Changes
- **Before planning any change, zoom out first — understand how the affected area fits into the broader system. Do not skip this.**
- After planning, ask as many followup/clarifying questions as possible before implementing
- Don't blindly trust existing code patterns — understand impact of changes
- For widely-used/common components: don't need to audit every usage, but consider what can break
- When planning: always study existing code patterns first; refer to existing examples — don't invent new patterns or syntax
- Ask where files/references are if unsure — don't search blindly
- Write or adjust tests first before implementing (where tests exist — some projects use build-only validation)

## Agents

- **CRITICAL — Codebase search**: ANY codebase search (Grep, Glob, content search, finding files) MUST be delegated to the `Explore` subagent with `model: "haiku"`. Never run Grep or Glob directly. Pass a clear description of what to find and the desired thoroughness level.
- **CRITICAL — Validation & tests**: Run validation builds and test suites via `general-purpose` subagent with `model: "haiku"`. Read project CLAUDE.md for correct build commands. Agent returns pass/fail summary.
- **Note-taker**: When invoking the `note-taker` subagent, always pass `model: "opus"`.
- **Migration reviewer** (cash-flow-portal-backend only): After writing or modifying an Alembic migration file, automatically invoke the `migration-reviewer` subagent (`~/.claude/agents/migration-reviewer.md`) before considering the work done. Do not skip this step.
- **Test writer**: ANY request to write tests — unit, service, integration, view, or endpoint tests — MUST invoke the `test-writer` subagent via the Agent tool. Do not write tests inline.
- **Code simplifier**: ANY request to simplify code MUST delegate to the `code-simplifier` subagent via the Agent tool. Do not simplify code inline.

## Notes

Notes live at `~/.claude/notes/{org}/{repo}/{slug}.md`. Domain/topic documentation written for AI consumption — architecture, system maps, side effects, implicit dependencies.

## Git & PRs
- Branch naming: `tow/short-change-name`
- Commit messages: single line only, no body
- PR descriptions: single short bullet preferred. Don't over-describe but don't use "TSIA" either.
