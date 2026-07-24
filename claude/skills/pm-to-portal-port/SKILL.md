---
name: pm-to-portal-port
description: Port/migrate a feature, page, component, slice, or thunk from the deprecated property_management FE package (packages/property_management/src) into the actively-developed portal package (packages/portal/src/property_management/) in the cash-flow-portal-react monorepo. FAITHFUL REPLICATION of PM's file structure, Redux slice/thunk shape, tooling (useAPIDispatch, customAsyncThunk), and business logic — adapted only for portal's established integration seams (team/deal scoping, feature-flag+mock gating, prop-based mounting). Trigger on /pm-to-portal-port and whenever the user asks to port, migrate, replicate, mirror, or "do the same as PM" for anything in the FE property_management package, or extend a portal feature that has a PM twin.
---

# Porting PM → Portal (React/Redux, cash-flow-portal-react)

This is the frontend analog of the backend's `pm-to-im-port` skill — same philosophy, different stack. You're copying code from `packages/property_management/src` (PM — deprecated, not actively developed) into `packages/portal/src/property_management/` (the actively-developed portal package's property-management module). PM is the **source of truth** for file structure, Redux shape, tooling, and business logic. Your output should look like PM's code that happens to live in portal — not a rewrite.

The same instinct that burns the user on backend ports applies here: don't treat a port as a chance to write "better" React. They want *the same thing they already had*, moved and re-rooted. Every choice should be traceable to PM, except the specific, established seams below.

## Workflow

1. **Read the PM original in full.** Component(s), slice, thunk(s), types, helpers/utils it calls, images/constants it references. Read actual bodies, not just signatures.
2. **Find portal's existing `property_management/` building blocks.** Much of the domain may already be ported. Look at `portal/src/property_management/{slices,redux,types,constants}` for what's already there — same team/deal-context helpers, same feature-flag/mock helpers — and build the port out of these rather than inventing new ones.
3. **Mirror PM's file tree 1:1** under the equivalent `portal/src/property_management/...` path (see "File structure").
4. **Replicate PM's slice/thunk/component shape exactly**, applying only portal's established integration seams (see "Warranted additions").
5. **Flag genuine gaps** — a PM dependency, endpoint, or field that doesn't exist in portal yet (see "Unavoidable gaps").
6. **Validate** — build (see "Validation").

Delegate per the user's global rules: any codebase search → `Explore` (haiku).

## File structure — mirror 1:1

PM's top-level folders each have a same-named counterpart under `portal/src/property_management/`:

```
property_management/src/          portal/src/property_management/
├── components/           <->     ├── components/
├── constants/            <->     ├── constants/
├── features/             <->     ├── features/
├── helpers/              <->     ├── helpers/
├── hooks/                <->     ├── (check redux/hooks first — most PM hooks live there)
├── pages/                <->     ├── pages/
├── redux/                <->     ├── redux/
├── slices/                <->     ├── slices/
├── types/                <->     ├── types/
└── utils/                <->     └── utils/
```

A domain's relative path stays the same past that root — e.g. `property_management/src/slices/manager/lease.ts` → `portal/src/property_management/slices/manager/lease.ts`, `property_management/src/types/models/lease/managerView.ts` → `portal/src/property_management/types/models/lease/managerView.ts`. Don't reorganize, flatten, or regroup domains differently than PM did.

## Redux fidelity — slices & thunks

- Use `createSlice` (Redux Toolkit) and the repo's `createCustomAsyncThunk` wrapper, exactly like PM — never plain `createAsyncThunk` or hand-rolled thunks.
- Same state shape: pending booleans per action, top-level `error`, same `resetState`-style reducers, same `extraReducers` `.pending`/`.fulfilled`/`.rejected` handling per thunk.
- Same selectors, same thunk logic (request shape, response shape, what's stored vs. derived).
- Business logic inside a thunk (validation, derived fields, conditionals) — copy verbatim. Don't "fix" or simplify PM's calculations, don't add guards PM didn't have.

## Tooling — must match, no substitutions

- Use `useAPIDispatch()` / `useReducerDispatch()` from `@/property_management/redux/hooks` exactly as PM calls them from `@/redux/hooks` — same call sites, same `{ result, error }` destructuring contract, same `toastError` boolean usage. Don't reach for raw `useDispatch`, ad hoc `axios`/`fetch` calls, React Query, or any other data-fetching pattern — even if those exist elsewhere in portal for non-PM features. This module stays internally consistent with PM's Redux-thunk tooling.
- API calls stay embedded directly in the thunk `payloadCreator` (no separate `api/*.ts` files) — this is PM's pattern, keep it.
- Types: mirror PM's `types/models/<domain>/` file layout and naming convention exactly (`TM` prefix for model/payload types, `E` prefix for enums, `*View`/`*Overview`/`*Payload` suffixes) — just re-rooted under portal's `property_management/types/`.

## Component conventions

- Keep PM's exact file split for a component: `index.tsx` + `styles.ts` if PM had both; single-file if PM had one. Don't inline styles into `index.tsx` or merge files just because it's shorter.
- Preserve props, responsive/variant logic (e.g. `useIsMobile`-driven layout switches), and sub-component decomposition PM had. Dropping a prop or a hook "because portal doesn't seem to need it" is the same overreach the backend skill warns against — needs a specific, statable portal reason, not a shortcut. If unsure, ask rather than simplifying.

## Warranted additions — portal's established integration seams

Portal's real ports (see worked example below) show a consistent, narrow set of necessary divergences. These are the FE equivalent of the backend skill's "permission check" addition — apply them, but nothing beyond them without asking:

- **Thunk action-type prefix.** PM's thunks are typed like `"m/lease/getLeaseById"`; portal renames the prefix to avoid collisions in its larger combined store (e.g. `"pmLease/getLeaseById"`). Check sibling slices already ported for that domain's established prefix before inventing a new one; if none exists yet, ask.
- **Feature-flag + mock-data gating.** Where the real backend endpoint isn't wired into portal yet, guard the real call with `isRealApiEnabled(getState)` and fall back to `mockResolve(...)` sourced from `mock/mockData.ts`. Mark the real path with a `// === BE INTEGRATION SEAM === METHOD /path ===` comment — **this comment is an established portal convention, not narration** (unlike the backend skill's ban on migration-narration comments, this one is expected and should be kept/added consistent with sibling thunks).
- **Team/deal scoping.** PM's manager routes are implicitly scoped to the logged-in manager; portal's property_management module is mounted inside a specific deal's product tab. Add `teamSlug`/`dealId` params to thunks and prop-drill `deal` (or the equivalent) into pages/features where PM relied on a route param or a PM-only global context (`useCompanyContext` typically supplies `teamSlug`).
- **Prop-based mounting instead of routing.** PM's top-level pages are routed (`/m/properties`) and often own their own header/breadcrumb. Portal mounts the equivalent as a component inside an existing parent (e.g. a product-tab view) — so drop PM's route-owned header/breadcrumb chrome and accept the scoping data (e.g. `deal`) as a prop instead of reading it from the route. This is a real, necessary shape change — don't also use it as license to drop unrelated props/behavior in the same component.
- **Import path namespacing.** PM's `@/...` imports become portal's `@/property_management/...`.

If you find yourself making a change that doesn't fit one of these five buckets, treat it as an unrequested divergence — stop and ask, don't guess.

## Comments — no PM narration in code

Comments in the ported code should read like they were always portal's own — never "Mirrors PM's X", "Replicates PM's Y", "Unlike PM, which does Z", or similar comparisons to the deprecated package. That context belongs in your chat summary/PR description (see "Closing summary to the user" below), not in code that outlives the port and will confuse a reader who's never seen PM.

- Only comment where the WHY is genuinely non-obvious to someone reading *just this file* — e.g. a real constraint, an endpoint reference, or a stated gap (see "Unavoidable gaps"). Write it in terms of what portal does, not how it differs from PM.
- The one standing exception is the established `// === BE INTEGRATION SEAM === METHOD /path ===` marker — keep that; it's portal's own convention, not migration narration.
- If you're tempted to write "just like PM" or "PM does X" in a code comment, that's a sign the sentence belongs in your chat response instead — drop it from the diff.

## Unavoidable gaps — flag, don't invent

Same handling as the backend skill: if a PM dependency (an endpoint, a field, a whole sub-feature) genuinely isn't wired into portal yet, replicate PM's shape as closely as possible (keep the field/prop present, populate with what's available — typically via the mock/feature-flag seam above), don't invent new narration comments about the gap (the `BE INTEGRATION SEAM` marker already covers this, so no separate `// TODO` needed), and tell the user in chat: what PM does that portal can't yet, why, and what you did instead.

**If the gap is deep** (PM depends on a whole slice/feature/endpoint family that doesn't exist in portal at all) don't unilaterally decide how far to go — ask the user whether they want the port stubbed behind the mock/feature-flag seam only, or the missing dependency built out too.

## Worked example (real prior port in this repo)

`MyPropertiesPage`:

PM (`property_management/src/pages/Managers/MyPropertiesPage/index.tsx`) — routed page, owns its own header/breadcrumb, fetches globally-scoped properties on mount:
```tsx
const MyPropertiesPage = () => {
  const apiDispatch = useAPIDispatch();
  const reducerDispatch = useReducerDispatch();

  useEffect(() => {
    apiDispatch(getProperties());
    return () => { reducerDispatch(resetState()); };
  }, []);

  return (
    <>
      <Header />
      <HeaderBreadcrumbContainer borderBottom>{/* ... */}</HeaderBreadcrumbContainer>
      <PropertiesTable />
    </>
  );
};
```

Portal port (`portal/src/property_management/pages/Managers/MyPropertiesPage/index.tsx`):
```tsx
type MyPropertiesPageProps = { deal: { id: string } };

const MyPropertiesPage: FC<MyPropertiesPageProps> = ({ deal }) => {
  const apiDispatch = useAPIDispatch();
  const reducerDispatch = useReducerDispatch();
  const { teamSlug } = useCompanyContext();

  useEffect(() => {
    if (teamSlug) {
      apiDispatch(getPropertiesByDeal({ dealId: deal.id, teamSlug }));
    }
    return () => { reducerDispatch(resetState()); };
  }, [deal.id, teamSlug]);

  return <PropertiesTable dealId={deal.id} />;
};
```

What matches PM (deliberate): same hooks (`useAPIDispatch`/`useReducerDispatch`), same effect/cleanup shape (fetch on mount, `resetState()` on unmount), same reliance on `PropertiesTable` for the actual table.

The only divergences, each mapping to a bucket above: `deal` prop instead of route (**prop-based mounting**), `teamSlug` from context + passed into the thunk (**team/deal scoping** — also required a corresponding `getPropertiesByDeal` thunk instead of PM's global `getProperties`, mirrored 1:1 off PM's thunk otherwise), dropped `Header`/`HeaderBreadcrumbContainer` (**prop-based mounting** — portal's parent tab view owns that chrome).

**Caution — a divergence that should NOT be treated as a template:** the ported `FormSectionHeader` component in portal dropped PM's `layout` prop and `useIsMobile()` responsive switch, and inlined `styles.ts` into `index.tsx`. That doesn't map to any of the five warranted buckets above — treat it as an existing exception, not the model. Default to preserving PM's props and file split unless you have an equally concrete, statable portal-specific reason.

## Validation

- No test suite exists for either package — build is the validation gate (per this repo's `CLAUDE.md`):
  ```bash
  CI=false REACT_APP_ENV=production NODE_OPTIONS=--max-old-space-size=5120 yarn build:portal
  ```
  (`CI=false` suppresses warnings to reduce noise.) Clean up `dist/` after validating.
- Check `.claude/component-conventions.md` before implementing any common UI pattern (tooltips, modals, etc.) — use the specified shared-library component, not a raw antd/ad hoc one, per this repo's `CLAUDE.md`.

## Closing summary to the user

After a port, tell the user concisely: what you replicated 1:1 (file structure, slice/thunk shape, business logic), which warranted additions you applied and why (prefix rename, mock/feature-flag gating, team/deal scoping, prop-based mounting), and any unavoidable gaps (what PM does, why portal can't yet, what you did instead). Keep it short.
