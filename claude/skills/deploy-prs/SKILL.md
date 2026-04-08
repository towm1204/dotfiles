---
name: deploy-prs
description: Create staging and release deployment PRs
model: haiku
---
Create two deployment PRs:

1. **master → staging**: title `STAGING - {today's date YYYY-MM-DD}`, body "deployment"
2. **staging → release**: title `RELEASE - {today's date YYYY-MM-DD}`, body "deployment"

## Steps

1. Get today's date in YYYY-MM-DD format.
2. Check for existing PRs by searching `gh pr list --base staging --search "STAGING - YYYY-MM-DD" --state all` and `gh pr list --base release --search "RELEASE - YYYY-MM-DD" --state all`. Run both in parallel.
3. Only create PRs that don't already exist. For existing ones, note "already exists" and include the existing PR URL. When creating: staging PR uses `--head master --base staging`, release PR uses `--head staging --base release`.
4. Return all PR URLs (new + existing).
