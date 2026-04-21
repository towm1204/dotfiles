---
name: cleanup-memory
description: Audit CLAUDE.md files in the repository for stale, redundant, or low-value content. Suggest trims.
---

**Invoke the general-purpose agent with model: sonnet to execute this skill.**

Audit CLAUDE.md files for content that can be trimmed or improved.

## Scope

- If `$ARGUMENTS` specifies file paths, only audit those files.
- Otherwise, find all `CLAUDE.md` files in the repository (use Glob for `**/CLAUDE.md`).
- Do NOT audit `~/.claude/CLAUDE.md` (user's global config).

## What to look for

Flag content that fits any of these categories:

1. **Redundant** — same information repeated across sections or files
2. **Discoverable** — info Claude can infer from code (e.g. listing dependencies already in package.json, version numbers that change)
3. **Human-only** — advice directed at human developers that Claude won't act on (e.g. "ask other engineers", onboarding steps)
4. **Stale** — references to tools, patterns, or structures that no longer exist in the codebase. Verify against actual files before flagging.
5. **Too verbose** — sections that can be said in fewer words without losing meaning
6. **Generic advice** — advice that applies to any project, not specific to this one (e.g. "write clean code", "follow best practices")

## Process

1. Audit each file individually against the categories above.
2. After individual audits, compare across all CLAUDE.md files for duplicated content. Prefer keeping shared knowledge in the most ancestral file (e.g. root `CLAUDE.md` over subdirectory ones).

## Output format

For each file audited, show line count, then findings:

**`path/to/CLAUDE.md`** — X lines

| Section/Lines | Issue | Severity | Suggestion |
|---|---|---|---|
| ... | Redundant / Discoverable / Human-only / Stale / Verbose / Generic | High / Medium / Low | What to do |

Severity guide:
- **High** — actively harmful or misleading (stale refs to deleted files, wrong instructions)
- **Medium** — wastes context window without adding value (verbose, redundant, generic)
- **Low** — minor improvement opportunity (could be slightly shorter)

After all files, show cross-file redundancy findings if any.

Then propose a concrete trimmed version of each file with a summary: **X lines → Y lines**.

**Stop condition**: If all findings across all files are Low severity, report "Files are clean — no changes recommended" and skip proposing trimmed versions.

## Rules

- Wait for user approval before making any edits
- Be aggressive about trimming — bias toward less content
- Preserve anything that genuinely steers Claude's behavior in ways it couldn't figure out on its own
- When checking for staleness, actually verify against the codebase (check if referenced files/patterns exist)
