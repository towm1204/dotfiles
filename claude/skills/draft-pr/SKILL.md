---
name: draft-pr
description: Create a draft PR from the current branch
model: haiku
---
Create a draft pull request from the current branch against master.

## Arguments

$ARGUMENTS format: `{prefix}: {title}` (e.g. `Dwolla KYC: Add kyc_business_customer_id to Investment model`)

## Steps

1. Push branch to remote with `-u` if needed.
2. Parse $ARGUMENTS: prefix is before `:`, title is after.
3. PR title: `[{prefix}] {title}`
4. `git diff master...HEAD` to understand changes.
5. Write a very concise bullet-point summary. Use "TSIA" if changes are obvious from the title. Each bullet max 1 sentence. Prefer fewer bullets — don't split one logical change into multiple bullets.
6. Create draft PR with `gh pr create --draft`. Never include "Generated with Claude Code" or any AI attribution.
7. Return the PR URL.
