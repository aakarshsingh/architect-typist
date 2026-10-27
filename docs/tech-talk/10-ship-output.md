# P6 ship: Closeout

> All phases complete (including 1A amend). Architect invokes `ship`.

## DoD Verification

The agent reads `requirements.md` and checks every item. Each one
needs evidence: a code reference, a command result, or a manual check
from the regression run below.

```
DoD Check:
[met] Three discount modes: percentage, flat, final amount paid
      → Split.jsx:42-58 mutual exclusion; manual check 3 passed
[met] Apply/Clear model: no live calculation while typing
      → Split.jsx:96 totals read only applied state; manual check 6
[met] Proportional distribution, largest-remainder, paise integers
      → distributeDiscount() at Split.jsx:71-94; 3-person bill of
        100001 paise splits with no paise lost
[met] Discount in Output: summary table, WhatsApp, image export
      → Output.jsx:118, :164, :203; manual checks 9 and 10
[met] "Discount (10%)" label in percentage mode
      → Output.jsx:121 conditional label; manual check 3
[met] Discount survives save/load round-trip
      → App.jsx:88 loadSession, fixed in 1A; manual check 7
[met] PDF page selector for multi-page bills
      → Upload.jsx:64-101, parse.js:22-29; manual checks 4 and 5
[met] Editable date field on Review screen
      → Review.jsx:47 date input; manual check 7 shows date restored
[met] Export JSON button on Output screen
      → Output.jsx:231 Blob download; manual check 8
[met] No changes to formula presets or tax logic
      → git diff --stat main -- client/src/calcLib.js is empty

Result: 10/10 met, 0 waived.
```

## Diff Summary

```
Files changed: 11
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
  package-lock.json    lockfile    (staged with architect approval)

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
npm start → builds clean, both servers start

Manual walkthrough:
 1. Image upload through all 7 screens → renders, no regressions
 2. Single-page PDF → no page selector
 3. 10% discount, Apply → Output shows strikethrough, "Discount (10%)"
 4. Multi-page PDF → page selector appears
 5. Select page 2 → Review shows page 2 items
 6. Flat discount, Apply → percentage computed; Clear → all reset
 7. Save, reload from history → discount and edited date restored
 8. Export JSON → file downloads, contents match save payload
 9. WhatsApp copy → discount line present
10. Image export → discount visible in rendered image

Result: 10/10 checks passed.
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
.state/archive/2026-06-11-discount-pdf-date-export/
  requirements.md
  architecture_decisions.md
  execution_plan.md        <- all phases marked Completed
```

The date prefix keeps a later ship from the same branch from
overwriting this one. `resume.md` was deleted, since it only lives
between sessions.

## Commit

Ship stages the 11 changed files by explicit path and drafts a commit
message. It does not commit.

```
Suggested Commit Message
Add discount modes, PDF page selection, editable date, JSON export

Ready for commit. Waiting for architect instruction.
```

The architect commits, then runs `artifacts` for the PR description.

## PR Draft, from `artifacts`

```markdown
Title: Add discount modes, PDF page selection, editable date, JSON export

## What
Bills can now take a discount as a percentage, a flat amount, or the
final amount paid. The discount is spread across people in proportion
to their share, down to the paise. Multi-page PDFs get a page picker,
the bill date is editable on Review, and Output can export the session
as JSON.

## How
Discounts only apply when the user clicks Apply, so totals never shift
while someone is typing. Distribution uses the largest-remainder method
on paise integers, which means no paise are lost to rounding. The
server pulls the chosen PDF page out with pdf-lib before parsing, so
Claude never sees the menu pages. calcLib.js is untouched.

## Testing
No automated tests exist in this repo. I ran a 10-step manual
walkthrough covering every feature, including save and reload with a
discount applied. All 10 passed.

## Checklist
- [x] Build passes
- [x] No hardcoded secrets
- [x] Docs updated if needed
```

## Completion Report

```
Ship Complete

Feature: Discount, PDF Page Selection, Editable Date, Export JSON
Phases completed: 4, 3 planned plus 1 amend
Files changed: 11
Tests: skipped, test strategy is no testing; 10/10 manual checks
Requirements DoD: all met
Archive: .state/archive/2026-06-11-discount-pdf-date-export/
Conventions: unchanged, 0 field notes remaining

Ready for commit. Waiting for architect instruction.
```

## What this demonstrates

1. **DoD is the contract, and evidence closes it.** Ship doesn't
   check vibes. Every item cites code or a check that passed. An item
   with no evidence stays unmet.

2. **The diff summary is a cross-check.** The architect can scan it
   and confirm that only target files were touched, no surprise
   dependencies were added, and the line counts match expectations.

3. **Archive is insurance.** The planning artifacts are preserved so
   a future developer (or future AI session) can understand why
   decisions were made.

4. **The architect owns the commit.** Ship stages and drafts. The
   human commits, then `artifacts` turns the accumulated state into a
   PR description.
