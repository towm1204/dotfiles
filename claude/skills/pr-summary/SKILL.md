---
name: pr-summary
description: >
  Summarize the changes in the current PR or branch as concise bullet points.
  Use this skill whenever the user asks to recap, summarize, or describe what's
  changed in a PR, branch, or diff — even if they say "what did we do", "what's
  in this PR", "recap changes", "what changed", or similar. Trigger proactively
  any time the user wants a high-level overview of pending changes.
---

# PR Summary

Produce a concise bullet-point summary of what changed in the current branch/PR.

## Steps

1. **Find the base branch.** Try `git log origin/main..HEAD --oneline` and `git log origin/master..HEAD --oneline`. Use whichever returns commits. If neither does (e.g. the branch is already merged, or the remote ref is unclear), ask the user what to compare against.

2. **Gather the diff.**
   - `git diff <base>...HEAD --name-only` — authoritative list of files in the final PR diff. Use this, not individual commit stats, to determine what's actually in the PR (commits may add and revert things).
   - `git log <base>..HEAD --oneline` — for context on intent, not for file enumeration

3. **Write the summary.** Bullet points, one per logical change. Group tightly related things — a migration + the model field it adds = one bullet; a backfill script + its scheduled task registration = one bullet; tests for a feature = one bullet alongside the feature (or omit if minor). Don't split what belongs together.

## Output format

- Start each bullet with the **what**, not the how
- One short sentence per bullet, no fluff — a bullet that needs a colon-separated
  list of sub-details or a parenthetical aside is a sign it should be split or
  trimmed, not padded
- Skip implementation minutiae (function/prop/variable names, which existing
  component got reused, field names on a type) unless the bullet is otherwise
  ambiguous without it — the reader wants what changed, not how it was wired up
- No header, no preamble — just the bullets
- This applies double on large or complex diffs: the more there is to summarize,
  the more each bullet needs to compress, not expand

## Example

Given commits touching a migration, model fields, a backfill script, a scheduled task, and tests:

- Added `last_tax_info_updated` column to all four investment profile models.
- Added change log constants + service method to record tax detail update events.
- Backfill script + scheduled task to populate the field from existing change log history.
- Tests for the backfill script and new service method.

Not this (too granular):
- Added migration for `last_tax_info_updated`
- Added field to InvestmentProfileEntity
- Added field to InvestmentProfileIndividual
- Added field to InvestmentProfileIRA
- Added field to InvestmentProfileJointAccount
- Added backfill script
- Registered backfill in scheduled_manage.py
- Added tests

Given a large diff implementing ACH payments in a funnel plus a few smaller fixes:

- ACH payment flow implemented for capital call drawdown funnel (pay, schedule, cancel, ledger summary).
- `drawdown_participant_id` added to payment query/mutation for capital call context.
- `FUND_CAPITAL_CALL` bumped to top action-required priority.
- Fixed "partially funded" amount calc.

Not this (verbose — explains internals, names components/props, hedges with asides):
- Implemented ACH payment flow for the capital call drawdown funnel (previously a TODO): payment initiation/scheduling, 2FA wall, cancel-scheduled-payment, and a funded-payment ledger summary view, reusing `InvestmentPaymentButtonV2`/`InitiatePaymentConfirmation` and extending `InvestorCapitalCallDrawdown` with `receiving_bank_account_id`/`ach_receiving_bank_id` for GP-increase detection.
- Added `drawdown_participant_id` to the investment payment query/mutation so ACH payments can be scoped to a specific capital call participant.
