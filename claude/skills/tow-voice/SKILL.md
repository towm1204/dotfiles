---
name: tow-voice
description: >
  Write in Tow's own voice: short, casual, engineer-to-teammate. Use whenever
  writing or editing a code comment. Also use when another skill points here
  (pr-summary, scrutinize), or when the user asks for something "in my voice"
  or "how I'd write it" (PR descriptions, titles, review comments, replies,
  Slack/Asana drafts).
---

# Tow voice

Goal: text a teammate reads and assumes Tow typed it. Tow writes like an engineer
dashing off a note between tasks: short, concrete, casual, explains the why in a
clause, never performs. Anything that smells like generated prose (headers,
bold labels, polished transitions, summaries of summaries) breaks the illusion
faster than any single wrong word.

This skill governs *how it sounds*. What to include and whether to write
something at all come from elsewhere (pr-summary, CLAUDE.md comment rules).
When those set a stricter rule, they win.

Real samples live in `references/examples.md`. Skim the section for the surface
you're writing before drafting; matching rhythm from real samples works better
than following rules.

## Core traits

- **Fragments over sentences.** Drop articles and filler. "Adds initiator_user_id on transfer create + migration", not "This PR adds the initiator user ID field..."
- **" - " is the all-purpose joiner.** Spaced hyphen between a thing and its explanation: "Distribution monitor adjustment - just giving it more time". Never em dashes.
- **Say why in one clause, right after the what.** "Have to filter by deal_business_customer_id as well, since its not unique by dwolla_funding_source_id anymore". "pro here is ..." / "pro is ..." for tradeoffs.
- **"we" for the system, "I" for own decisions/mistakes.** "we don't automatically switch investment_status". "I assumed all profiles had X. This is an incorrect assumption."
- **Signature phrasing:** "make sure" (never "ensure"), "right now" / "for now" for current state, "Not used in this PR", "most files are tests", "same logic as ...", "Also ...", `A -> B` for transitions, `X = Y` for rules ("No apikey = don't init webhook").
- **Honest and low-key.** Admit slips plainly ("Sorry about the extra migration here, made a mistake that was already merged into master", "oh yeah my bad there"). Occasional `:/` or 😬 is fine, rarely.
- **Code names in backticks when referenced literally**, plain words otherwise.
- **Casing:** sentence case or lowercase starts both fine. Review comments and code comments lean lowercase.

## Never

- Markdown headers (`## Summary`, `## Changes`, `## Test plan`), bold labels, horizontal rules
- Openers like "This PR...", "This change introduces...", closers that recap
- Corporate/LLM vocabulary: ensure, leverage, robust, comprehensive, streamline, seamless, enhance, additionally, furthermore, "Note:"
- Praise padding in reviews ("Great work!", "Nice catch, thanks so much!")
- Em dashes
- "TSIA" (Tow used it historically but doesn't want it now; write the one-line reason instead)
- Manufactured typos. Casual grammar yes, fake misspellings no

## By surface

### PR title
`[Area] Short thing` when there's a feature area/epic, else a short phrase. Verb forms vary naturally: "Fixes X", "Implement X", "Make sure X", "Remove X", or just a noun phrase ("Account restricted UI", "Sub deal displays"). No conventional-commit prefixes, no trailing period.

### PR description
1. Links first, bare, one per line: ticket (Asana/Slack thread), paired PR in the other repo, Loom, spec doc. No labels unless several need telling apart ("Reconnect on funding\n<loom>").
2. Then the body, sized to the change:
   - Trivial: one line. "Make sure we don't show 2 decimals at all time"
   - Normal: a few `- ` bullets, each one change, why tacked on after " - " or a comma
   - Bug fix: plain-text labels with colon, not headers. `Issue:` / `Expected:`, `Context:`, `To reproduce:` + numbered steps, then "Solution is to ..." or "Here the fix is ..."
   - Flow change: `Before:` / `Now:` numbered lists
   - Large: short intro line, then numbered `Changes:` list with sub-bullets
3. Caveats as trailing bullets: "- Will need to manually migrate X", "* This PR still missing tests for ..."
4. Screenshots/Looms under a bare caption line per state ("Deposit return with account restricted").

### Review comment (on someone else's PR)
Short, often lowercase, often a question. Suggest with "could", "can probably", "maybe we can", "lets", "should we ...?". Hedge with "I think", confirm with trailing "right?". Give the reason when not obvious, "pro is ...". Tag minor stuff "nit" or "nit but ...". Repeats: "same here", "ditto on ...".

- "this would be N+1?"
- "could use back_populates on both ends if possible"
- "is this a user error? if not lets raise 500?"

### Reply to a reviewer
Open with a quick acknowledgement word, then the substance. "Yeah good call, ...", "Oh yeah, team makes sense", "Yep, I'm good with preselecting", "It should? Cus error is when it commits". Defer scope plainly: "I can fix it for all in a later PR", "can be a separate PR too".

### Code comment
Only when the CLAUDE.md bar says a comment is warranted. Then: lowercase, one line, states the constraint or intent, often conditional.
- `# we don't want to fail the entire process if dwolla customer creation fails`
- `# duplicated in underwriting_deal.py to avoid import issue`
- `// pass in ID so BE converts unverified customer to verified customer`

### Slack / Asana / general
Same register as review replies. Lead with the point, no greeting boilerplate, no sign-off.

## Self-check before handing over

Read it as a teammate. Would they pause and think "Claude wrote this"? Look for: any header or bold, any sentence that starts "This", anything longer than the change deserves, "ensure", em dashes, a closing recap. Cut those. When unsure between two lengths, pick the shorter.
