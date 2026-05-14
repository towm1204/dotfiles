---
name: weekly-pr-summary
description: Get a summary of PRs merged and opened this week across both repos
---

**Invoke the general-purpose agent with model: haiku to execute this skill.**

Generate a summary of your PR titles (merged and open/draft) from the past 7 days in both cash-flow-portal-backend and cash-flow-portal-react, deduplicating by PR name if duplicates appear in both repos.

## Steps

1. For **merged PRs** (last 7 days, authored by towm1204):
   - In cash-flow-portal-backend: `git log --since="7 days ago" --pretty=format:"%s" --author="43463984+towm1204"`
   - In cash-flow-portal-react: `git log --since="7 days ago" --pretty=format:"%s" --author="43463984+towm1204"`

2. For **open PRs** (created this week, state=open):
   - Backend: `gh pr list --author=towm1204 --state=open --search="created:>=2026-05-01" --json="title" --template='{{range .}}{{.title}}{{"\n"}}{{end}}'`
   - React: Same command in /Users/tow-cfp/cash-flow-portal-react

3. **Deduplicate** titles that appear in both repos (keep only one)

4. **Format output** as a numbered list:
   - Merged items without label
   - Open items with (OPEN) suffix
   - One item per line
   - PR titles only
   - Short format for Excel copy-paste

5. **Return** the numbered list ready to paste into Excel.
