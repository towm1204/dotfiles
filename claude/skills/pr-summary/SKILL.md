---
name: pr-summary
description: >
  Summarize the changes in the current PR or branch as concise bullet points.
  Use whenever the user asks to recap, summarize, or describe what's changed
  in a PR, branch, or diff — "what did we do", "what's in this PR", "recap
  changes", "what changed", or similar. Trigger proactively for any
  high-level overview of pending changes.
---

# PR Summary

## Steps

1. Find base: `git log origin/main..HEAD --oneline` or `origin/master..HEAD`. Neither returns commits → ask user what to compare against.
2. `git diff <base>...HEAD --name-only` for the file list (authoritative — commits may add/revert). `git log <base>..HEAD --oneline` for intent only, not file enumeration.
3. One bullet per logical change. Group tightly related pieces (migration + field, script + its registration, feature + its tests) into one bullet.

## Output format

- Lead with what changed, not how
- One short fragment per bullet — imperative mood, present tense verb ("Merge X into Y", "Fix Z to use A instead of B"), not past tense ("Added", "Fixed")
- Sacrifice grammar for brevity: drop articles and filler words where the meaning stays clear ("tenant decorator" not "the tenant decorator")
- No colon-separated sub-lists, no parentheticals
- Skip function/prop/field names and internal wiring unless needed for clarity
- No header, no preamble
- Bigger diff = more compression, not more bullets
- Phrasing follows the `tow-voice` skill (`~/.claude/skills/tow-voice/SKILL.md`). This file wins where the two conflict

## Example

- Merge and simplify tenant decorator into `tenancy_required` decorator. Reading tenancy_id from path, query, view_as_tenant param
- Fix dwolla endpoints to use tenant_profile_id instead of just user_id

Not this (too granular — splits one change into its parts, past tense, over-explained):
- Added migration for `last_tax_info_updated`
- Added field to InvestmentProfileEntity
- Added field to InvestmentProfileIndividual
- Added backfill script
- Registered backfill in scheduled_manage.py
- Added tests
