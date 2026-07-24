---
name: pm-to-im-port
description: Port/migrate a feature, endpoint, service, or model from the deprecated property_management (PM) app into investment_management (IM) in the cash-flow-portal-backend monorepo. The job is FAITHFUL REPLICATION, not improvement — copy PM's structure, tooling, naming, and control flow 1:1. Trigger on /pm-to-im-port and proactively whenever the user asks to port, migrate, replicate, mirror, or "do the same as PM" for anything in property_management, or says a PM behavior should now exist in IM. Also trigger when extending an IM feature that was clearly ported from PM (has a PM twin) so the extension stays faithful to PM.
---

# Porting PM → IM

You are copying code from the deprecated `property_management` (PM) app into `investment_management` (IM). PM is the **source of truth**. Your output should look like PM's code that happens to live in IM — not like code you would have written from scratch.

The user has been burned repeatedly by the same instinct: treating a port as a chance to write "better" IM code. Don't. They want *the same thing they already had*, moved. Every choice you make should be traceable to PM. If you can't point at PM and say "because PM does it this way," you are diverting.

## Reading PM is allowed here

The project CLAUDE.md says never read `property_management`. That rule is suspended for porting work — you **must** read PM to replicate it. This is the one sanctioned exception. Don't refuse, and don't try to reconstruct PM's behavior from memory or IM alone.

## Workflow

1. **Read the PM original in full.** Find every layer it touches — view, service, repository, DTO, schema, model, constants, enums. Read the actual bodies, not just signatures. This is what you are replicating.
2. **Find IM's already-ported building blocks.** Much of PM is usually already in IM (`investment_management/core/.../property_management/`). Locate the IM twins of the models, DTOs, repos, services the PM code depends on. You build the port out of these, not out of new abstractions.
3. **Replicate PM's structure using IM's building blocks.** Same call sequence, same layering, same names. See the fidelity rules below.
4. **Add only warranted IM-specific glue** (see "Warranted additions"). Nothing else.
5. **Handle genuinely-missing dependencies** by flagging, not inventing (see "Unavoidable gaps").
6. **Validate** (see "Validation").

Delegate per the user's global rules: searches → `Explore` (haiku); tests → `test-writer`; new/edited Alembic migrations → `migration-reviewer`.

## Fidelity rules — match PM exactly

Whatever PM does, IM does. Concretely, copy PM's decisions on all of these unless there is a *specific* reason (below) not to:

- **Layer of call.** If PM's service calls other **services**, yours calls services. If it calls repos, yours calls repos. Do not "upgrade" a repo call to a service call or vice versa.
- **Object lifecycle.** If PM instantiates a helper **locally inside the method**, do the same — do not hoist it onto `self.__init__`. If PM stores it on `self`, do that. Copy the scope PM used.
- **Naming.** Method names, variable names, argument names, DTO/schema field names — match PM. `get_transactions_by_lease_id` stays a fetch-by-lease read named the same way (adjust only to an existing IM convention if one already governs that file).
- **Control flow & shape.** Same ordering, same concatenation vs. sorting, same return type, same branches. If PM returns `charges + payments` unsorted, return `charges + payments` unsorted. Do not add sorting, dedup, or reshaping PM didn't have.
- **Response shaping.** Mirror PM's schema/serializer field-for-field and its per-type branching.
- **Tooling.** Same libraries and patterns PM used, as they exist in IM.

When in doubt, put PM's code and your code side by side. They should differ only where a rule below forces it.

## Do NOT add "migration narration" comments

Do not write comments that describe the porting process or PM/IM differences. The ported code should read as if it always lived in IM.

Banned examples (these are exactly the comments the user keeps deleting):
- `# TODO: once LeasePayment ships, merge payments in here (like PM's ...)`
- `# IM has no ACHPaymentDetail yet, so payments carry no transfer_status`
- `# mirrors PM's split` / `# restore this once X is ported`

If PM had a comment, you may carry it over verbatim. But do not manufacture new commentary about the migration, about what IM lacks, or about what "will" happen later. Surface those things to the **user in chat**, not in the code.

## Warranted additions — the only allowed divergence

IM sometimes needs a small amount of glue PM didn't, because PM enforced something elsewhere (a decorator, ambient context) that IM doesn't provide in the same spot. The canonical case: **permission / access checks** (e.g. deal-sponsor or lease access) that IM requires at the service layer.

Rules for additions:
- Add only what is genuinely required for IM correctness/security — usually because IM's existing twin methods already expect it (e.g. IM's `get_charges_of_lease` already runs `_check_lease_access`, so routing through it is how the check happens).
- Prefer to get the addition *for free* by reusing the IM building block that already includes it, rather than bolting on new code.
- Keep it minimal. A warranted addition is not a license to restructure.
- If you're unsure whether an addition is warranted, ask the user — don't guess and don't pre-emptively "harden."

## Unavoidable gaps — flag, don't invent

Sometimes a PM dependency simply isn't in IM yet (e.g. `ACHPaymentDetail` and its transfer-status enrichment). When that happens:

- Replicate PM's shape as closely as the available IM pieces allow (e.g. keep the schema fields present but populated as PM would leave them when the data is absent — typically `None`).
- Do **not** leave a TODO/explanatory comment about the gap in the code.
- Do **tell the user** in your chat summary: what PM does that IM can't yet, why (missing model/repo), and what you did instead. Let them decide whether to port the dependency too.

**If the gap is deep** (the missing PM dependency is itself a whole model/repo/service, not just a field or a small helper — e.g. `ACHPaymentDetail` + `ACHPaymentTransferStatus`), don't unilaterally decide how far to go. Ask the user (`AskUserQuestion`) whether they want: (a) structure-only — replicate PM's method shape/split, leave the gap's fields `None`/unpopulated, no new models/migrations, or (b) full port — also port the missing model(s), repo, and migration so the field is actually populated like PM. This is a scope decision, not a fidelity detail.

## Don't silently flatten a method PM split in two

PM sometimes splits a read into a plural "by ids" fetcher plus one or more thin wrappers that delegate to it (e.g. `get_x_by_lease_id` calls `get_x_by_ids([...])`, and a separate `get_x_by_id` elsewhere also calls the same `get_x_by_ids`). The plural method usually exists because PM has more than one caller for it, or does per-item enrichment that's easier to write once.

If IM only ported one flattened method (inlined the plural method's body directly into the singular wrapper), that's a structural fidelity gap even if the *output* looks the same for the single-caller case today — restore the split. Don't assume a method exists only for the caller you can currently see; check whether PM has another caller for the plural version before concluding it's dead code to fold away.

## No unrequested DRY / refactoring

Don't consolidate duplication, extract helpers, rename for consistency, or "tidy" surrounding code as part of a port. PM often has deliberate duplication (e.g. `check_deal_access` duplicated across services with a "no cross-service helper exists yet" note) — carry it as-is. The user wants a faithful move, and unrequested refactors are noise in the diff and a source of the exact divergence they keep correcting. If you spot a real cleanup opportunity, mention it separately after the port; don't fold it in.

## Validation

- `make im-check-heads` to confirm it compiles.
- mypy (v1.9.0) and black run via pre-commit hooks — no need to run manually, but the code must pass mypy. Watch for type-narrowing needs in schema `@pre_dump` branches (use inline `isinstance`, as PM does).
- Run the relevant service and view tests. Have `test-writer` add/adjust coverage for the newly-ported behavior, keeping assertions matched to PM's actual contract (e.g. don't assert ordering PM doesn't guarantee).

## Worked example (from a real correction)

Porting PM's `TransactionService.get_transactions_by_lease_id` (charges + payments) into IM's `get_transactions_of_lease`.

PM:
```python
def get_transactions_by_lease_id(self, lease_id):
    lease_charge_service = LeaseChargeService()
    lease_payment_service = LeasePaymentService()
    charges = lease_charge_service.get_charges_by_lease_id(lease_id)
    payments = lease_payment_service.get_payments_with_ach_details_by_lease_id(lease_id)
    transactions = charges + payments
    return transactions
```

Faithful IM port:
```python
def get_transactions_of_lease(self, lease_id: UUID) -> List[Union[LeaseChargeDTO, LeasePaymentDTO]]:
    lease_charge_service = LeaseChargeService(entity=self._entity, team_member=self._team_member)
    lease_payment_service = LeasePaymentService(entity=self._entity, team_member=self._team_member)
    charges = lease_charge_service.get_charges_of_lease(lease_id)
    payments = lease_payment_service.get_payments_of_lease(lease_id)
    transactions: List[Union[LeaseChargeDTO, LeasePaymentDTO]] = charges + payments
    return transactions
```

What matches PM (all deliberate): services instantiated **locally in the method**, one fetch per service, `charges + payments` with **no sorting**, plain return.

The only divergences, each justified:
- `entity`/`team_member` passed into the sub-services — *warranted*: that's how IM's already-ported `get_charges_of_lease` performs its required lease/deal access check. The check comes for free by reusing the IM twin.
- `transfer_status`/`failure_message` left `None` in the response schema — *unavoidable gap*: IM has no `ACHPaymentDetail` yet, so PM's ACH enrichment can't be replicated. Flagged to the user, no comment in code.

Mistakes that were corrected along the way (do not repeat):
- Adding a `sorted(...)` the PM code never had.
- Calling repos directly instead of the services PM used.
- Hoisting the services onto `self` in `__init__` instead of instantiating locally.
- Writing `# TODO / # mirrors PM` narration comments in the code.

## Closing summary to the user

After a port, tell the user concisely: what you replicated 1:1, any warranted additions (and why), and any unavoidable gaps (what PM does, why IM can't yet, what you did). Keep it short.
