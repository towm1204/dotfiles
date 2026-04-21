---
name: upgrade-security-alerts
description: Review GitHub Dependabot security alerts and propose dependency upgrades. Lists open alerts with target versions, breaking-change risk, and packages to skip. Waits for user confirmation before editing manifests.
---

**Invoke the general-purpose agent with model: sonnet to execute this skill.**

Review and triage open Dependabot alerts for the current repo, then upgrade pinned versions after user confirms.

## Steps

1. **Load repo-specific notes** — if `.claude/upgrade-security-alerts.md` exists at the repo root, read it. It contains exactly three sections: `## Manifest paths`, `## Blocked & constrained packages`, and `## Pinned packages`. Rows in the blocked table ARE the skip list — do not attempt to upgrade them. Do not expect any other sections.

2. **List open alerts** — run:
   ```
   gh api repos/:owner/:repo/dependabot/alerts --paginate -q '.[] | select(.state=="open") | "\(.security_advisory.severity)\t\(.dependency.package.ecosystem)\t\(.dependency.package.name)\t\(.security_vulnerability.vulnerable_version_range)\t\(.security_vulnerability.first_patched_version.identifier)\t\(.dependency.manifest_path)\t\(.security_advisory.ghsa_id)"'
   ```

3. **Check current pinned versions** in the manifests listed by the repo notes (or, if no notes, the manifests reported by the alerts).

4. **Assess breaking-change risk per package**:
   - **Safe** — patch bump, or minor bump with no known API changes
   - **Moderate** — minor bump that touched defaults/public API (validation tightening, rendering changes, dropped deprecated APIs)
   - **Breaking** — major bump, or upgrade blocked by a pinned peer declared in the repo notes

5. **Ecosystem-specific risk heuristics** — apply generic knowledge, then defer to any repo-specific overrides in the project notes.

6. **Present a list** with columns: package, current → target, severity, risk, notes. Call out skipped packages separately with the reason.

7. **Wait for confirmation.** Do NOT edit manifests until the user confirms. Honor any `skip X` instructions.

8. **Apply upgrades** per the repo notes' lockstep rules (e.g. update multiple requirements files if the package exists in both). Keep existing casing in each file.

9. **Do NOT run** installers or reboot services. User validates manually.

10. **Update project notes** — after each session (whether or not upgrades were applied), sync `.claude/upgrade-security-alerts.md`:
    - **`## Blocked & constrained packages` table** — canonical list of packages that have an open Dependabot alert but can't be upgraded cleanly right now. Columns:
      - `package` — npm/pip/etc. name
      - `current version` — what's pinned today
      - `upgrade needed` — target version with a markdown link to the GHSA advisory (e.g. `[3.4.0](https://github.com/advisories/GHSA-xxxx-xxxx-xxxx)`)
      - `blocked reason` — why it can't be bumped (major version, incompatible peer, no published fix, etc.)
      - `dependabot risk` — severity from the alert (critical/high/medium/low)
      - `revisit when` — concrete condition that would unblock the upgrade
      - `date added` — ISO date (YYYY-MM-DD) the row was first added
      Keep the table current: add new blocked rows, update `current version` / `upgrade needed` as alerts shift, and remove rows once resolved.
    - **`## Pinned packages` section** — packages held back because upgrading would be a large breaking change (not tied to a security alert). No table; bullet list of `package: current version` with a one-line note on the breaking change that's blocking the bump.
    - **Audit for staleness** — remove or correct anything outdated: stale version references, resolved constraints, skip reasons that no longer apply.
    - Keep entries concise; one row/bullet per package.
