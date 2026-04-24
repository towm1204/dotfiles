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
- When planning: always study existing code patterns first; refer to existing examples — don't invent new patterns or syntax
- Ask where files/references are if unsure — don't search blindly
- Write or adjust tests first before implementing

## Agents

- **CRITICAL — Code review**: ANY request related to reviewing code — including "review", "diff", "check changes", "look at changes", "review this branch", "review PR", or any variant — MUST immediately invoke the `code-reviewer` subagent via the Agent tool. Never run `git diff` yourself. Never do an inline review. Do not do any preliminary work — invoke the agent as the first and only action.
- **CRITICAL — Codebase search**: ANY codebase search (Grep, Glob, content search, finding files) MUST be delegated to the `Explore` subagent. Never run Grep or Glob directly. Pass a clear description of what to find and the desired thoroughness level.
- **CRITICAL — Validation & tests**: Run validation builds and test suites via `general-purpose` subagent with `model: "haiku"`. Read project CLAUDE.md for correct build commands. Agent returns pass/fail summary.
- **Note-taker**: When invoking the `note-taker` subagent, always pass `model: "opus"`.

## Notes

Notes live at `~/.claude/notes/{org}/{repo}/{slug}.md`. These capture non-obvious discoveries — architecture orientation, system maps, side effects, disjointed dependencies — things that take 30+ min to reverse-engineer and are invisible from the code.

## Git & PRs
- Branch naming: `tow/short-change-name`
- Commit messages: single line only, no body
- PR descriptions: single short bullet preferred. Don't over-describe but don't use "TSIA" either.

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.

## graphify — project graph usage

If a project has `graphify-out/` in its root:
- Before answering architecture or codebase questions, read `graphify-out/GRAPH_REPORT.md` for god nodes and community structure
- If `graphify-out/wiki/index.md` exists, navigate it instead of reading raw files
- For cross-module "how does X relate to Y" questions, prefer `graphify query "<question>"`, `graphify path "<A>" "<B>"`, or `graphify explain "<concept>"` over grep — these traverse the graph's EXTRACTED + INFERRED edges instead of scanning files
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)
