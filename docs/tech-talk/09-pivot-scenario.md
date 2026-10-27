# Pivot Scenario: Discount UX Redesign

> This happens after all three phases are complete, before ship.
> The architect reviews the discount implementation and finds UX
> problems. This triggers `pivot`.

## The trigger

After Phase 3 completes, the architect does a manual walkthrough of
the discount feature and reports:

> "The discount UX has problems. The onFocus toggle is flimsy. If I
> click into the flat discount field and then click into the percentage
> field, both have values and it's ambiguous which one Apply will use.
> Also, loading a saved session with a discount doesn't restore the
> discount state on the Split screen. And there's no guard against
> division by zero if the pre-discount total is somehow zero."

## Pivot invocation

The architect invokes `pivot`. The agent reads all `.state/`
files and asks:

```
What changed?
1. Requirements changed (scope shift)
2. Architecture is wrong (technical pivot)
3. Completed phase has a defect (needs amendment)     <- this one
4. External constraint discovered
5. Other

Understanding the scope:
- The discount UX (onFocus toggle) in Split.jsx needs redesign
- History restore is missing discount reconstruction (App.jsx)
- Division by zero guard needed (Split.jsx)

This affects Phase 1 (Discount System) only.
Phases 2 and 3 are unaffected.

Deep pivot check: 1 of 3 completed phases needs amendment.
Well under 50%. Architecture is sound. Pivot in-place is appropriate.

Plan Status set to Draft while the pivot is in progress.
```

## Impact assessment

```
| Phase | Status    | Impact                        |
|-------|-----------|-------------------------------|
| 1     | Completed | Needs amend (discount UX)     |
| 2     | Completed | No change                     |
| 3     | Completed | No change                     |
```

Architect confirms.

## Amend phase generated

The agent adds Phase 1A to the execution plan:

```markdown
### Phase 1A: Amend - Discount UX Redesign

**Status:** Pending
**Reason:** Code review found three issues in Phase 1's discount
implementation: ambiguous Apply with multiple fields, missing history
restore, division by zero risk.

**Target Files:**
- client/src/screens/Split.jsx (modify)
- client/src/screens/Split.module.css (modify)
- client/src/App.jsx (modify)

**Changes:**
- Replace onFocus toggle with mutual exclusion: typing in any field
  clears the other two on keystroke. Only one field can have a value
  when Apply is clicked.
- App.jsx loadSession: reconstruct splitDiscount from saved session's
  discount object (amount, pct, applied state).
- Guard all discountPaise/preTotalPaise derived values with
  preTotalPaise > 0 check.

**Verification:**
- [ ] `npm start` → both servers start, no build errors
- [ ] Manual: type in Discount % → the other two fields clear
- [ ] Manual: type in Flat Discount → the other two fields clear
- [ ] Manual: type in Final Amount → the other two fields clear
- [ ] Manual: save with discount, reload → discount restored
- [ ] Manual: pre-discount total of zero → no crash, shows 0.0%

**Definition of Done:**
- [ ] No ambiguous Apply state possible
- [ ] Discount survives save/load (full round-trip)
- [ ] No division by zero possible

**Self-Audit Checklist:**
- [ ] Only target files touched
- [ ] No public-facing changes beyond the plan
- [ ] Matches conventions.md conventions (paise integers, camelCase)
- [ ] No hardcoded secrets
- [ ] No sensitive data in logs
- [ ] External input validated (discount >= 0, <= bill total)
- [ ] Error handling (division by zero guard)
- [ ] Build passes clean
- [ ] Changes are minimum necessary
- [ ] Amendment doesn't break other completed phases
```

The checklist is copied from Phase 1 in the live plan, with the
amendment check added at the end. Phase 1's Completion Record is left
untouched. It stays as history for the amend to build on.

## Updated Phase Summary

```
| Phase | Name                            | Status    |
|-------|---------------------------------|-----------|
| 1     | Discount System                 | Completed |
| 2     | PDF Page Selection              | Completed |
| 3     | Editable Date + Review Cleanup  | Completed |
| 1A    | Amend: Discount UX Redesign     | Pending   |
```

Execution order: 1A runs next (amends must run before ship).

## Architect approves

The architect reviews the amend phase and says "approved". The agent
sets `Plan Status: Approved` and recommends `execute` in a fresh
session.

## Execute Phase 1A

New session. Agent reads `.state/`, confirms `Plan Status: Approved`,
finds Phase 1A Pending.

### Implementation

**Split.jsx:** Mutual exclusion on keystroke:

```jsx
const handleDiscountChange = (field, value) => {
  setApplied(false);
  if (field === 'pct') {
    setDiscountPct(value);
    setDiscountFlat('');    // clear others
    setFinalAmount('');
  } else if (field === 'flat') {
    setDiscountFlat(value);
    setDiscountPct('');
    setFinalAmount('');
  } else {
    setFinalAmount(value);
    setDiscountPct('');
    setDiscountFlat('');
  }
};
```

**App.jsx:** History restore:

```jsx
if (session.discount) {
  newSessionData.splitDiscount = {
    amount: session.discount.amount,
    pct: session.discount.pct || null,
    applied: true,
  };
}
```

**Split.jsx:** Division by zero guard:

```jsx
const displayPct = preTotalPaise > 0
  ? ((computedDiscount / preTotalPaise) * 100).toFixed(1)
  : '0.0';
```

### Self-Audit

```
- [x] Only target files touched: git diff --name-only lists 3 of 3
- [x] No public-facing changes beyond the plan
- [x] Matches conventions.md: paise integers, camelCase
- [x] No hardcoded secrets: diff contains no keys or tokens
- [x] No sensitive data in logs: no new console output
- [x] Input validated: mutual exclusion on keystroke, Split.jsx:42
- [x] Division by zero guarded on derived values, Split.jsx:131
- [x] Build passes clean: npm start, both servers up
- [x] Changes are minimum necessary: no edits beyond the amend
- [x] Amendment doesn't break Phases 2 or 3: manual flow passed
```

### Completion

```
Phase 1A COMPLETED: Amend, Discount UX Redesign
Files staged: Split.jsx, Split.module.css, App.jsx
Tests: skipped, test strategy is no testing
Field notes: 0
Next phase: All phases complete (including amends) -> suggest ship
```

## What this demonstrates

1. **Pivot is surgical.** Only the affected phase gets an amend.
   Completed phases that work fine are untouched.

2. **The deep pivot check prevents overreaction.** 1 of 3 phases
   needing amendment is well under the 50% threshold for restarting
   from design. The architecture is sound; just the UX needs fixing.

3. **Amend phases have the same structure as regular phases.**
   Same self-audit, same completion record, same staging rules.
   No shortcuts because it's "just a fix."

4. **A half-revised plan can't run.** The plan sits at Draft from the
   start of the pivot until the architect approves the amend.

5. **The code review finding was treated as a pivot, not a silent
   fix.** The architect reported the issue. The agent created a
   formal amend phase. The fix is tracked, audited, and staged
   separately. No hidden changes.
