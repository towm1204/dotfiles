# Real samples

Verbatim from Tow's GitHub (pre-2026-03, before Claude-drafted PRs), URLs
replaced with `<placeholders>`. Typos left in only where fixing them would
change meaning; don't copy typos into new text.

## PR titles

- [Banking] Initiator user id on transfer create
- [Banking investment funding] Support paying to CFP bank without verification
- [Accreditation] Auto accred 90 days warning
- Fixes redirecting to 2nd half of funnel
- Fixes funnel updating investment status < SIGNED
- Make sure we mark investment.accreditation_charged_at on canceled letters
- Do not require signature for sending funding instructions
- Implement returning investor AML skip setting
- Remove error handlers
- Account restricted UI
- Banking investment funding - prompt reconnection on missing RN/AN
- Show reinvestment percentage - minor adjustment

## PR descriptions

### One-liners

```
Make sure we can convert python date time -> string before saving

<slack thread>
```

```
right now it doesn't filter by team :/
```

```
Have to filter by deal_business_customer_id as well, since its not unique by dwolla_funding_source_id anymore
```

```
Unnecessary boiler-plate code + errors here will not bubble up to app error handlers
<asana link>
```

```
Missed a commit that was supposed to be in <PR link>
```

### Bullets

```
<paired PR link>
- sumsub reads from offering/investment is_returning_lead_sponsor_investor instead
- UI to skip KYC based on is_returning_lead_sponsor_investor
```

```
- Deposit endpoint
- Banking service for creating deposits will have CFP specific deposit validation before handing on IncreaseProvider
- IncreaseProvider does increase specific stuff with an ACH transfer
- Minor type fix with uuid.UUID
```

```
- banking_service.create_ach_transfer used for both
  - cannot be send-only account for debits
- increase_service checks balance if its a credit
- entry description and direction differs
- most files are tests
```

```
- Differs from original spec in that IncreaseTransferDetail is holding the FK. Thinking again it makes more sense to have the child hold the FK of the parent
```

```
- refactor getting "deal bank accounts" into its own endpoint
- refactor stuff related to "deal banking" to a separate service
- pro here is we don't have to query entities?deal_id={} to get bank accounts specific to a deal. Permission for stuff in this new service is pretty different from banking service too
- removes unused endpoints / service

<paired PR link>
```

```
- Able to reconnect bank accounts that has plaid auth revoked
- Refactor plaid connection into hook
- Removes plaid from redux (this causes bugs when sharing same hook and used in 2 different places)

<paired PR link>

Reconnect on funding
<loom>

Reconnect on withdrawal
<loom>
```

```
<loom>
- Changed some FE copies from the loom video
- Sorry about the extra migration here, made a mistake that was already merged into master

<paired PR link>
```

### Bug fixes

```
<asana link>

If token expires on whitelabel / subdomain, user is kicked out to CFP.com
1. We don't need switchToGeneralPortal. If its wrong portal, thats already handled by thunk. This doesn't really handle it gracefully
2. We're going to "Private" page for whitelabel, since we're only checking for `whitelabel_enabled == false` not `whitelabel_enabled === false`
```

```
To reproduce:
1. Accreditation after signing
2. Make sure to have document become "signed" first, from webhook update, before going Next on the accreditation step
3. Accreditation step calls PATCH endpoint with status=document_signing_started and turns status back to that

Solution is to include "signed" as a status that we don't turn back as well. After investor has signed document and is in the 2nd half of the funnel, we never want to turn it back to "document signing started"
```

```
Issue: Investor didn't sign subscription doc. If there are no docs, we don't allow sending funding instructions.
Expected: If they don't have a subscription doc at all and added through offering, we still allow them to send funding instructions
```

```
Context: Found that some of the funding sources that were supposed to be updated going forward didn't have account and routing number.
- Cause: Its only from funding sources created from transferring them when Dwolla customer record goes from unverified -> verified.
- Solution: Making sure we fill out those fields if the transfer is successful
```

```
Context:
1. I assumed all profiles had `unverified_dwolla_customer_id`. This is an incorrect assumption.
2. When users needs to verify their profile - if its an increase GP, they can bypass that. With this change, we also make sure they also have unverified_dwolla_customer_id already created
```

```
<asana link>

Here the fix is if its hard-commitment, we don't automatically switch investment_status. BE just reacts to `investment_status` inputs
```

### Flow change / larger

```
Before:
1. Add / select owner
2. Connect with plaid

Now:
1. Connect with plaid
2. Add / select owner along with confirming authorization

<loom>
<asana link>
```

```
<loom>
<paired PR link>

Changes:
1. Returns sub_deal_id in various places (GP and LP endpoints)
2. Returns sub_deal_name in investment list and investment detail
3. Filter out subdeal when doing LP sharing with "all investments"
4. Adjust display in deal investor list, investment details
5. Hide manage sharing
  - Contact investment list
  - Sharing tab investment detail
  - LP deal detail view (if only subdeals and no non-subdeals. Otherwise, show and filter out subdeal)
6. Hide switch profile

<spec doc>
```

```
1. Implementing a `DealBankingService.initiate_investment_payment`. This calls provider.create_ach_transfer_for_investment_funding()
2. Make sure we save stuff needed for increase - `ach_transfer.investment_payment_id`, `.receiving_verified_funding_source_id`, `investment_payment.is_increase_transfer`
3. Make sure we take in idempotency key
4. Changes investment payment to "created" after success - it is now ready for webhook updates

* This PR still missing tests for new stuff: `initiate_investment_payment`, `create_ach_transfer_for_investment_funding`.
```

### Screenshot captions

```
Deposit return with account not restricted
<img>

Deposit return with account restricted
<img>

Withdrawal return
<img>

- Change from withdrawal -> payment
```

## Review comments

- this would be N+1?
- is this nullable or no
- unused? And i think we don't want to delete tags either
- shouldn't need to touch investment status here?
- could name this "investor", will be easier to distinguish them from GP
- could use back_populates on both ends if possible
- use back_populates instead - pro is its explicitly defined on both sides.
- can just be a set too, since you're just checking for ID
- is this a user error? if not lets raise 500?
- should we still log this or log something if it gets to this branch? for debugging
- we could refactor this out of the loop and build the map up 1 time?
- this should already be covered because lead sponsor will have a deal sponsor record
- not related to this PR? could add check constraint with changes in model file
- nit but can probably combine code
- Lets add tests since these are new endpoints / services too
- Should we make it null instead of "" if its cleared out? Initially it would be null
- can we break it down into different endpoints? Create, get all, get one, update. A lot easier and efficient to review than all together in 1 go
- if its not too much of a lift can probably add the same lead / admin sponsor permission for these endpoints as well?
- May not be related to your PR but when testing this - dates gets pushed forward to the next date if UTC is +1 day on PT.
- Wait can we also make sure profile hydration does not bug out

Longer:

```
this will send an email to all sponsors involved, including the one sending the email. We may want a different service there that is only for notifying investor of the change. Thought this could be the function after the if/else <here>
```

```
in this part, I think it should be combined with the query above
1. query the team / users to exclude
2. then exclude those when looking for selected sponsors (investment owners)
3. exclude those when looking for other contact owners
```

```
if number of payments > 1, we already don't allow them to try pay in the UI right?

But if they're > 300K, we still allow them to pay in the UI. Just thinking error message can be more specific for > 300K.
```

## Replies to reviewers

- Oh yeah, team makes sense
- Yep, I'm good with preselecting
- oh yeah my bad there, found the mistake only after testing views
- It should? Cus error is when it commits
- Yeah should be in dto good catch. but can be a separate PR too
- Same thing here - was existing behavior. I can fix it for all in a later PR
- yup good catch, should fall back to `{}`
- oh you're right
- Yeah I think user_id is a good indication of a pure contact
- Yeah good call, it is intended to close that gap. I think it doesn't hurt to also gate by is_tenant_contact_at just to be consistent. But I don't think its needed functionally and should co-exist fine too
- yeah wasn't planning to backfill since its just for reference - same with `is_created` - added comment that we just assume old ones are update
- right now they cannot have same slug. Think that could be an improvement too but not important yet i think

## Code comments

- `# we don't want to fail the entire process if dwolla customer creation fails`
- `# duplicated in underwriting_deal.py to avoid import issue`
- `# if funding_source.removed is still true, we don't touch the status. Else, we clear removed status`
- `# make sure its not over the autopay limit. If its over the limit, send email to tenant to pay manually`
- `# if yearly cadence and pref for the whole year have not been paid, pro-rata it to all classes`
- `# take only coc hurdles. Paths in the waterfall is not allowed`
- `# next unit price in the pointer - pointer maxes out at len-1`
- `// pass in ID so BE converts unverified customer to verified customer instead of`
- `// if there is an investment profile but nothing loaded, show placeholder instead of uuid`
- `// trim numeric columns before validation. afterChanges has the same trimming`
