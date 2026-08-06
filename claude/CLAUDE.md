## Communication Style
- Concise in all interactions
- Sacrifice grammar for brevity
- Keep responses short & direct
- Never use em dashes, anywhere: chat, code comments, docstrings, commit messages, PR descriptions, docs.

## Code Style
- Single-line comments: concise
- Multi-line comments: fuller sentences, still concise
- Comment sparingly — most lines need none. When you do, explain why, not what.
- Use sentence case for UI copies — no Title Case

## Planning & Changes
- **Zoom out first**: before planning any change, understand how the affected area fits into the broader system. Do not skip this.
- **Study existing patterns**: refer to existing examples, don't invent new syntax — but don't blindly trust them; understand impact before reusing.
- **Common components**: don't need to audit every usage, but consider what can break.
- **Unsure of institutional/tribal knowledge**: ask — don't guess (e.g. "which service owns this rule"). If it's just a file location, search for it instead.
- **Clarifying questions**: for non-trivial changes, ask before implementing; skip for trivial/obvious ones.
- **Dev cost**: when making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- **Order of work**: implement, then validate (compile / type-check), then tests. Intent gets verified while implementing; tests lock in the behavior that resulted.
- **Validation**: run compile / type-check inline before reporting the task done. Project CLAUDE.md has the command.
- **When to skip tests**: trivial changes (typo, rename, formatting, config, docs, copy), nothing observable to assert, the area has no existing test suite, or the user said not to test.

## Agents

Which agent does which job. One line per job.

| Job | Agent | Notes |
|---|---|---|
| **CRITICAL** Codebase search: Grep, Glob, content search, finding files | `Explore`, `model: "haiku"` | Never grep or glob directly. Pass what to find plus the thoroughness level |
| Running tests | `general-purpose`, `model: "haiku"` | Never inline. Only one test run in flight anywhere: no parallel runners, no forks, no background bash |
| Writing or adjusting tests (unit, service, integration, view, endpoint) | `test-writer` | Never more than one at a time. Never write or edit tests inline. Works in any repo — it reads that project's test docs for syntax, fixtures, and tooling |
| Menial edits: bulk rename, formatting, boilerplate, find-replace | `general-purpose`, `model: "haiku"` | Absolute paths plus explicit acceptance criteria (fresh agent has zero context) |

Repo-specific agents live in that repo's `.claude/agents/` and are triggered by that repo's CLAUDE.md, not this table.

## Notes

Notes live at `~/.claude/notes/{org}/{repo}/{slug}.md`. Domain/topic documentation written for AI consumption — architecture, system maps, side effects, implicit dependencies.
Use `/note` to look up, `/grok` to write or update.

## Git & PRs
- **Don't create commits or PRs unless explicitly asked** — not even after finishing a task
- **Branch naming**: `tow/short-change-name`
- **Commit messages**: single line only, no body
- **PR descriptions**: single short bullet preferred. Don't over-describe but don't use "TSIA" either.
