# P4 plan: Output

> `.state/execution_plan.md` produced by `as-p4-plan`

```markdown
# Execution Plan: Discount, PDF Pages, Date, Export

## Objective
Add discount support, PDF page selection, editable date, and JSON
export to the bill-splitter app.

## Current Baseline
Commit 0ae6d9c. Working 7-screen wizard with AI parsing, formula
presets, preferences, and session save/load. No discount support.
No PDF page selection. Date is AI-extracted but not editable.
No JSON export.

## Rules
- One phase active at a time. Wait for architect approval.
- Maintain style per .state/conventions.md.
- No public-facing changes unless approved.
- 3-Strike Rule: 3 consecutive build failures -> STOP.
- Commit only when architect asks. Stage with explicit paths.
- Before starting a phase, assess session fit.

## Phase Summary
| Phase | Name                            | Status    |
|-------|---------------------------------|-----------|
| 1     | Discount System                 | Pending   |
| 2     | PDF Page Selection              | Pending   |
| 3     | Editable Date + Review Cleanup  | Pending   |

## Phase Details

### Phase 1: Discount System

**Status:** Pending

**Target Files:**
- client/src/screens/Split.jsx (modify)
- client/src/screens/Split.module.css (modify)
- client/src/screens/Output.jsx (modify)
- client/src/screens/Output.module.css (modify)
- client/src/App.jsx (modify)

**Changes:**
- Add three discount inputs (%, flat, final amount) to Split screen
- Implement Apply/Clear lock model (no live calculation)
- Proportional distribution using largest-remainder method
- Clamp discount to bill total, guard division by zero
- Show discount in Output: strikethrough originals, discount row,
  "Discount (10%)" labels when percentage mode used
- Discount in WhatsApp text and image export
- Export JSON button on Output (downloads session as .json)
- App.jsx: pass discount through onConfirm, reconstruct on load

**Verification:**
- [ ] npm start succeeds
- [ ] Enter 10% discount, Apply, verify computed flat amount
- [ ] Enter flat discount, Apply, verify computed percentage
- [ ] Enter final amount, Apply, verify computed discount
- [ ] Clear discount, verify all fields reset
- [ ] Proceed to Output, verify strikethrough and discount row
- [ ] Copy WhatsApp text, verify discount line present
- [ ] Export JSON, verify file downloads with discount object
- [ ] Save session, reload from history, verify discount restored

**Definition of Done:**
- [ ] Three discount modes with mutual exclusion on keystroke
- [ ] Apply/Clear model enforced (no live calculation)
- [ ] Proportional distribution with exact paise allocation
- [ ] Discount visible in all Output formats
- [ ] Discount survives save/load round-trip

**Self-Audit Checklist:**
- [ ] Only target files touched
- [ ] No public-facing changes without approval
- [ ] Matches conventions.md conventions (paise integers, camelCase)
- [ ] No hardcoded secrets
- [ ] No sensitive data in logs
- [ ] External input validated (discount >= 0, <= bill total)
- [ ] Error handling (division by zero guard)
- [ ] pdf-lib not added (that's Phase 2)
- [ ] Build passes clean
- [ ] Changes are minimum necessary

**Completion Record:**
_(Filled after verification)_


### Phase 2: PDF Page Selection

**Status:** Pending

**Target Files:**
- client/src/screens/Upload.jsx (modify)
- client/src/screens/Upload.module.css (modify)
- server/routes/parse.js (modify)
- package.json (modify: add pdf-lib dependency)

**Changes:**
- On PDF upload, detect page count using pdf-lib
- If pages > 1, show page selector with thumbnails or numbers
- Send selected page number with parse request
- Server: extract single page via pdf-lib before Claude call
- Single-page PDFs skip the selector entirely

**Verification:**
- [ ] npm start succeeds
- [ ] Upload single-page PDF, verify no page selector shown
- [ ] Upload multi-page PDF, verify page selector appears
- [ ] Select page 2, verify Review shows correct parsed items
- [ ] Upload image file, verify no page selector (images only)

**Definition of Done:**
- [ ] Multi-page PDFs show page selector
- [ ] Selected page extracted server-side before AI parsing
- [ ] Single-page PDFs and images unaffected

**Self-Audit Checklist:**
- [ ] Only target files touched
- [ ] Matches conventions
- [ ] No hardcoded secrets
- [ ] pdf-lib added to package.json with justification
- [ ] Build passes clean
- [ ] Changes are minimum necessary

**Completion Record:**
_(Filled after verification)_


### Phase 3: Editable Date + Review Cleanup

**Status:** Pending

**Target Files:**
- client/src/screens/Review.jsx (modify)
- client/src/screens/Review.module.css (modify)

**Changes:**
- Show AI-extracted date as editable input field on Review
- Date flows through reviewData to Output and saved sessions
- Remove PDF preview iframe (fix Phase 1 issue: squeezes table)
- Keep image preview for non-PDF uploads

**Verification:**
- [ ] npm start succeeds
- [ ] Upload bill, verify date field shows AI-extracted date
- [ ] Edit date, proceed to Output, verify edited date appears
- [ ] Upload PDF, verify no preview iframe (table uses full width)
- [ ] Upload image, verify image preview still works

**Definition of Done:**
- [ ] Date is visible and editable on Review
- [ ] Edited date flows to Output and saved sessions
- [ ] PDF preview removed, image preview retained
- [ ] Review table columns not squeezed

**Self-Audit Checklist:**
- [ ] Only target files touched
- [ ] Matches conventions
- [ ] No hardcoded secrets
- [ ] Build passes clean
- [ ] Changes are minimum necessary

**Completion Record:**
_(Filled after verification)_
```

## Sizing discussion

The architect flagged Phase 1 as large (5 files, ~400 lines of
changes). The agent justified keeping it unified:

> Splitting discount across two phases requires stubbing the data
> flow. Split.jsx computes the discount, Output.jsx displays it,
> App.jsx manages the state between them. Implementing Split without
> Output means the discount has nowhere to go. Implementing Output
> without Split means hardcoding test data. The coupling is real.

The architect accepted but added: "If you hit trouble in Output, stop
and we'll split."

Phase 0 was skipped (TS3: no testing).
