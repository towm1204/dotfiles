## Communication Style
- Concise in all interactions
- Sacrifice grammar for brevity
- Keep responses short & direct
- Never use em dashes, anywhere: chat, code comments, docstrings, commit messages, PR descriptions, docs.

## Code Style
- **Comments: none by default.** Not "few", none. Same bar for docstrings, JSDoc, TODOs.
  - Only exception: code looks arbitrary/wrong and the next reader would "fix" it and break something. One line naming the constraint.
  - Never to justify a chosen value, restate the name above, narrate the lines below, or explain the bug/old code. That's PR and commit message material.
  - Draft it, delete it, re-read. If the code still reads fine it stays deleted, even when a plan or my own earlier message proposed the comment.
- Use sentence case for UI copies — no Title Case
- **Helpers**: default is inline, always. Before writing any new function/method, count real call sites. Extract only if 3+ call sites exist right now (not "will reuse later") AND it's a genuine boundary worth naming (transaction, error handling, permission, recursion) — not just "this block has a name for what it does." Fewer call sites, or no boundary = inline, no exceptions.
  - This check runs even when a plan, spec, prior message (including my own), or the user's phrasing already proposes a named helper. A plan saying "add a private helper" is not a call-site count — verify it myself before writing the method. Planning agents (Plan, plan mode) default to over-extracting; don't take their word for it either.
  - Applies in every language/codebase, not just one project's style guide.

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

## Notes

Notes live at `~/.claude/notes/{org}/{repo}/{slug}.md`. Domain/topic documentation written for AI consumption — architecture, system maps, side effects, implicit dependencies.
Use `/note` to look up, `/grok` to write or update.

## Git & PRs
- **Don't change git state unless explicitly asked** (commit, push, checkout, branch, merge, rebase, reset, stash), not even after finishing a task. Reading is always fine: `status`, `log`, `diff`, `grep`
- **Code not in the tree**: say which branch has it and stop. Don't switch or merge to reach it
- **Branch naming**: `tow/short-change-name`
- **Commit messages**: single line only, no body
- **PR descriptions**: single short bullet preferred. Don't over-describe but don't use "TSIA" either.
