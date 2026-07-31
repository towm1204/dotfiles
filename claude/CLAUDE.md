## Communication Style
- Extremely concise in all interactions, commit messages and PR descriptions
- Sacrifice grammar for brevity
- Keep responses short & direct

## Code Style
- Single-line comments: concise
- Multi-line comments: fuller sentences, still concise
- Use sentence case for UI copies — no Title Case

## Planning & Changes
- **Zoom out first**: before planning any change, understand how the affected area fits into the broader system. Do not skip this.
- **Study existing patterns**: refer to existing examples, don't invent new syntax — but don't blindly trust them; understand impact before reusing.
- **Common components**: don't need to audit every usage, but consider what can break.
- **Unsure of institutional/tribal knowledge**: ask — don't guess (e.g. "which service owns this rule"). If it's just a file location, search for it instead.
- **Clarifying questions**: for non-trivial changes, ask before implementing; skip for trivial/obvious ones.
- **Tests first**: write or adjust tests before implementing (where tests exist — some projects use build-only validation).
- **Dev cost**: when making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.

## Agents

- **CRITICAL — Codebase search**: ANY codebase search (Grep, Glob, content search, finding files) MUST be delegated to the `Explore` subagent with `model: "haiku"`. Never run Grep or Glob directly. Pass a clear description of what to find and the desired thoroughness level.
- **CRITICAL — Validation & tests**: Run automatically after any code edit, before reporting the task done. Run via `general-purpose` subagent with `model: "haiku"`. Main session orchestrates — dispatch one validation/test subagent at a time and wait for it to return; never run tests concurrently with another test run of any kind — not just other validation subagents, but forks, background bash, or parallel sessions too. Many projects share one test DB with commit-persisted fixtures (no per-test rollback), so concurrent runs corrupt shared state and throw spurious failures (e.g. `IntegrityError`) that look like real bugs but aren't. Read project CLAUDE.md for correct validation commands. Agent returns pass/fail summary.
- **Menial edits**: bulk renames, formatting, boilerplate, find-replace — delegate to `general-purpose` subagent with `model: "haiku"`. Give absolute paths + explicit acceptance criteria (fresh agent has zero context).
- **Migration reviewer** (cash-flow-portal-backend only): After writing or modifying an Alembic migration file, automatically invoke the `migration-reviewer` subagent (`~/.claude/agents/migration-reviewer.md`) before considering the work done. Do not skip this step.
- **Test writer**: ANY request to write tests — unit, service, integration, view, or endpoint tests — MUST invoke the `test-writer` subagent via the Agent tool. Do not write tests inline.

## Notes

Notes live at `~/.claude/notes/{org}/{repo}/{slug}.md`. Domain/topic documentation written for AI consumption — architecture, system maps, side effects, implicit dependencies.
Use `/note` to look up, `/grok` to write or update.

## Git & PRs
- **Don't create commits or PRs unless explicitly asked** — not even after finishing a task
- **Branch naming**: `tow/short-change-name`
- **Commit messages**: single line only, no body
- **PR descriptions**: single short bullet preferred. Don't over-describe but don't use "TSIA" either.
