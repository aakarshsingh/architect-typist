# P6 ship: Closeout

> All phases complete (including 1A amend). Architect invokes `as-p6-ship`.

## DoD Verification

The agent reads `requirements.md` and checks every item:

```
DoD Check:
- [x] Three discount modes: percentage, flat amount, final amount paid
      -> Split.jsx: three inputs with mutual exclusion on keystroke
- [x] Apply/Clear model: no live calculation while typing
      -> Split.jsx: Apply button locks, Clear resets
- [x] Discount distributes proportionally (largest-remainder, paise integers)
      -> Split.jsx: distributeDiscount() with largest-remainder
- [x] Discount reflected in Output: summary table, WhatsApp, image export
      -> Output.jsx: strikethrough + discount row in all formats
- [x] Discount label shows "Discount (10%)" when percentage mode used
      -> Output.jsx: conditional label rendering
- [x] Discount survives save/load round-trip
      -> App.jsx: loadSession reconstructs splitDiscount (fixed in 1A)
- [x] PDF page selector for multi-page bills
      -> Upload.jsx: page count detection + selector UI
- [x] Editable date field on Review screen
      -> Review.jsx: date input with onChange
- [x] Export JSON button on Output screen
      -> Output.jsx: Blob download with session payload
- [x] No changes to existing formula presets or tax logic
      -> calcLib.js not in any phase's target files. Confirmed untouched.

Result: 10/10 DoD items satisfied.
```

## Diff Summary

```
Files changed: 10
Lines added:   +501
Lines removed: -21

Phase 1 (Discount System):
  Split.jsx            +245 lines  (discount inputs, Apply/Clear, distribution)
  Split.module.css     +38 lines   (discount section styling)
  Output.jsx           +133 lines  (discount display, Export JSON)
  Output.module.css    +22 lines   (strikethrough, discount row)
  App.jsx              +19 lines   (discount in session state, load)

Phase 2 (PDF Page Selection):
  Upload.jsx           +59 lines   (page count, page selector UI)
  Upload.module.css    +14 lines   (page selector styling)
  parse.js             +27 lines   (server-side page extraction)
  package.json         +1 line     (pdf-lib dependency)

Phase 3 (Editable Date + Review Cleanup):
  Review.jsx           +37/-14     (date input, removed PDF preview)
  Review.module.css    +8/-7       (date row, removed preview panel)

Phase 1A (Amend: Discount UX):
  Split.jsx            modified    (mutual exclusion on keystroke)
  App.jsx              modified    (history restore fix)
  Split.jsx            modified    (division by zero guard)
```

## Full Regression Check

```
npm start -> builds clean, both servers start
Manual walkthrough:
- Upload image -> Review -> People -> Instructions -> Assign -> Split -> Output
  All screens render correctly. No regressions.

- Upload single-page PDF -> same flow. No page selector shown. Correct.
- Upload multi-page PDF -> page selector appears. Select page 2. Correct.

- Enter 10% discount -> Apply -> Output shows strikethrough + discount.
- Enter flat discount -> Apply -> percentage auto-computed.
- Enter final amount -> Apply -> discount derived from difference.
- Clear -> all discount fields reset.

- Save session -> reload from history -> discount restored. Date restored.
- Export JSON -> file downloads. Contents match save payload.

- WhatsApp copy -> discount line present.
- Image export -> discount visible in rendered image.

Result: all features verified.
```

## Conventions Prune

```diff
 # Conventions: bill-splitter

 ## Field Notes
-  (none active)
+(none)
```

No field notes remain. The Phase 1 note (PDF preview width) was
resolved in Phase 3.

## Archive

```
.state/archive/discount-pdf-date-export/
  requirements.md
  architecture_decisions.md
  execution_plan.md        <- all phases marked COMPLETED
  conventions_snapshot.md  <- conventions at time of ship
```

resume.md deleted (transient, only lives between sessions).

## PR Draft

```markdown
## Discount, PDF Page Selection, Editable Date, Export JSON

### Summary
- Three-mode discount system (%, flat, final amount) with Apply/Clear model
- Proportional discount distribution using largest-remainder (exact paise)
- PDF page selector for multi-page bills (server-side extraction via pdf-lib)
- Editable date field on Review screen
- Export JSON button on Output screen
- Discount survives save/load round-trip

### Changes
- Split.jsx: discount inputs, mutual exclusion, Apply/Clear, distribution
- Output.jsx: discount display (strikethrough, labels), Export JSON
- App.jsx: discount in session state, load reconstruction
- Upload.jsx: PDF page count detection, page selector
- parse.js: server-side PDF page extraction
- Review.jsx: editable date, removed PDF preview iframe
- pdf-lib added as dependency

### Test plan
- [ ] Upload single-page PDF, verify no page selector
- [ ] Upload multi-page PDF, select page, verify correct parse
- [ ] Enter each discount mode, Apply, verify Output reflects it
- [ ] Clear discount, verify reset
- [ ] Save session with discount, reload, verify discount restored
- [ ] Edit date on Review, verify it flows to Output
- [ ] Export JSON, verify file contents
- [ ] WhatsApp copy includes discount line
- [ ] Image export includes discount
```

## Completion Report

```
Ship: Discount, PDF Page Selection, Editable Date, Export JSON - COMPLETE

Phases: 3 planned + 1 amend = 4 executed
DoD: 10/10 satisfied
Regressions: 0
Files changed: 10
New dependency: pdf-lib (justified: PDF page extraction)
Field notes: 1 added, 1 resolved, 0 remaining
Archive: .state/archive/discount-pdf-date-export/
```

## What this demonstrates

1. **DoD is the contract.** Ship doesn't check vibes. It walks the
   DoD list item by item and maps each to the implementing code.

2. **The diff summary is a cross-check.** The architect can scan it
   and confirm that only target files were touched, no surprise
   dependencies were added, and the line counts match expectations.

3. **Archive is insurance.** The planning artifacts are preserved so
   a future developer (or future AI session) can understand why
   decisions were made.

4. **PR draft writes itself.** All the information (DoD, target files,
   test verification) already exists in `.state/`. Ship assembles it.
