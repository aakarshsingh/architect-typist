# P5 execute: Phase 1 (Discount System)

> New session. Agent reads `.state/`, finds Phase 1 Pending.

## Pre-Flight

Agent reads all 5 target files silently. Confirms:

- Split.jsx: 15 lines, basic per-person cards with share bars
- Output.jsx: summary table, WhatsApp copy, image export
- App.jsx: sessionData with splitData passed via onConfirm
- Money is paise throughout (confirmed from calcLib.js import)

No assumption violations. Phase marked **Active**.

## Implementation

### Split.jsx (+245 lines)

Three discount inputs with mutual exclusion:

```jsx
// User types in one field -> other two clear
const handleDiscountChange = (field, value) => {
  if (field === 'pct') {
    setDiscountPct(value);
    setDiscountFlat('');
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
  setApplied(false);  // Reset applied state
};
```

Apply button locks the active field, computes the other two:

```jsx
const handleApply = () => {
  let discountPaise;
  if (discountPct) {
    discountPaise = Math.round(preTotalPaise * parseFloat(discountPct) / 100);
  } else if (discountFlat) {
    discountPaise = Math.round(parseFloat(discountFlat) * 100);
  } else if (finalAmount) {
    discountPaise = preTotalPaise - Math.round(parseFloat(finalAmount) * 100);
  }
  discountPaise = Math.max(0, Math.min(discountPaise, preTotalPaise));
  setComputedDiscount(discountPaise);
  setApplied(true);
};
```

Proportional distribution using largest-remainder:

```javascript
const distributeDiscount = (people, discountPaise, preTotalPaise) => {
  if (preTotalPaise <= 0) return people.map(() => 0);
  const raw = people.map(p => (p.totalPaise / preTotalPaise) * discountPaise);
  const floored = raw.map(Math.floor);
  let remainder = discountPaise - floored.reduce((a, b) => a + b, 0);
  const indexed = raw.map((r, i) => ({ i, frac: r - floored[i] }));
  indexed.sort((a, b) => b.frac - a.frac);
  for (let j = 0; j < remainder; j++) floored[indexed[j].i]++;
  return floored;
};
```

### Output.jsx (+133 lines)

Discount display with strikethrough:

```jsx
{discount && discount.amount > 0 && (
  <>
    <span className={styles.originalAmount}>
      Rs {Math.round(person.totalPaise / 100)}
    </span>
    <span className={styles.discountedAmount}>
      Rs {Math.round((person.totalPaise - person.discountPaise) / 100)}
    </span>
  </>
)}
```

Export JSON button:

```jsx
const handleExportJSON = () => {
  const blob = new Blob([JSON.stringify(sessionPayload, null, 2)],
    { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `${establishment}-${date}.json`;
  a.click();
  URL.revokeObjectURL(url);
};
```

### App.jsx (+19 lines)

Load session reconstructs discount:

```jsx
const loadSession = (session) => {
  // ... existing restore logic ...
  if (session.discount) {
    setSessionData(prev => ({
      ...prev,
      splitDiscount: {
        amount: session.discount.amount,
        pct: session.discount.pct || null,
        applied: true
      }
    }));
  }
};
```

## Near-Divergence

During self-audit, the agent discovered the PDF preview width issue:

```
NEAR-DIVERGENCE in Phase 1.

The PDF preview iframe on Review takes 50% width via CSS grid.
With the existing Effective column, the table's rightmost columns
(remove button) are pushed off-screen on viewports under 1200px.

This existed before our changes but becomes more visible with
discount amounts flowing through. The Effective column matters
more now.

This is a Review.jsx issue. Review.jsx is NOT in Phase 1's target
files.

Assessment: cosmetic, does not block discount functionality.
Recommendation: defer to Phase 3 which already touches Review.jsx.
Do not fix here.
```

Architect response: "Good catch. Fix it in Phase 3."

## Self-Audit

```
- [x] Only target files touched (5/5)
- [x] No public-facing changes without approval
- [x] Matches conventions.md (paise integers, camelCase, CSS Modules)
- [x] No hardcoded secrets
- [x] No sensitive data in logs
- [x] Input validated (discount >= 0, clamped to bill total)
- [x] Division by zero guarded (preTotalPaise > 0 check)
- [x] pdf-lib NOT added (correct, that's Phase 2)
- [x] Build passes clean
- [x] Changes are minimum necessary
```

## Completion Record

```
Phase 1: Discount System - COMPLETED

Implementation notes:
- Three discount modes with mutual exclusion on keystroke
- Apply/Clear model with computed read-only grey fields
- Largest-remainder for exact paise allocation
- Export JSON reuses save payload structure

Deviations from plan: none

Field notes:
- PDF preview iframe on Review squeezes table (deferred to Phase 3)
```

Conventions updated:

```
## Field Notes
- Review: PDF preview iframe takes 50% width, squeezes table on
  narrow viewports. Image preview does not have this issue.
```

## Completion Report

```
Phase 1: Discount System - COMPLETED
Files staged: Split.jsx, Split.module.css, Output.jsx,
              Output.module.css, App.jsx
Tests: N/A (TS3)
Field notes: 1
Next phase: Phase 2 (PDF Page Selection)
```
