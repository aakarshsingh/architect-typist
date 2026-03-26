# P3 design: Output

> `.state/architecture_decisions.md` produced by `as-p3-design`

```markdown
# Architecture: Discount, PDF Pages, Date, Export

## Overview
Four independent features sharing no architectural coupling. Discount
is the largest, touching Split, Output, and App for state management.
The other three are self-contained in one or two files each.

## Module Breakdown
| Module              | Responsibility                     | New/Modified |
|---------------------|------------------------------------|-------------|
| Split.jsx           | Discount input with Apply/Clear    | Modified    |
| Split.module.css    | Discount UI styling                | New (empty before) |
| Output.jsx          | Discount display + Export JSON     | Modified    |
| Output.module.css   | Strikethrough and discount styles  | Modified    |
| App.jsx             | Discount state in session flow     | Modified    |
| Upload.jsx          | PDF page selector UI               | Modified    |
| Upload.module.css   | Page selector styling              | New (empty before) |
| Review.jsx          | Editable date, PDF page preview    | Modified    |
| Review.module.css   | Date input styling                 | Modified    |
| server/routes/parse.js | Extract selected PDF page       | Modified    |

## Data Flow
1. Upload: user selects PDF page -> sends pageNumber with file
2. parse.js: extracts page via pdf-lib -> sends to Claude Vision
3. Review: shows AI-extracted date as editable input
4. Review: date flows into reviewData
5. Split: user enters discount -> clicks Apply -> locked state
6. Split: proportional distribution computed per person
7. App: onConfirm receives splitData with discount object
8. Output: reads discount from splitData for display/export
9. Save: discount object persisted in session JSON
10. Load: App.jsx reconstructs splitDiscount from saved discount

## File Targets
| File Path                   | Action  | Description                          |
|-----------------------------|---------|--------------------------------------|
| client/src/screens/Split.jsx      | Modify  | Three discount inputs, Apply/Clear   |
| client/src/screens/Split.module.css | Modify | Discount section styling           |
| client/src/screens/Output.jsx     | Modify  | Discount display, Export JSON button |
| client/src/screens/Output.module.css | Modify | Strikethrough, discount row styles |
| client/src/App.jsx                | Modify  | Discount in session state, load reconstruct |
| client/src/screens/Upload.jsx     | Modify  | PDF page count, page selector        |
| client/src/screens/Upload.module.css | Modify | Page selector styling              |
| client/src/screens/Review.jsx     | Modify  | Editable date input                  |
| client/src/screens/Review.module.css | Modify | Date input styling                 |
| server/routes/parse.js            | Modify  | PDF page extraction with pdf-lib     |

## External Touchpoints
- pdf-lib: new server dependency for PDF page extraction
- No other external changes. All changes internal.

## DoD Traceability
| Requirement                        | Component                          |
|------------------------------------|------------------------------------|
| Three discount modes               | Split.jsx: three input fields      |
| Apply/Clear model                  | Split.jsx: lock/apply/clear state  |
| Proportional distribution          | Split.jsx: largest-remainder calc  |
| Discount in Output                 | Output.jsx: summary + breakdown    |
| Discount in exports                | Output.jsx: WhatsApp + image + JSON|
| Discount survives save/load        | App.jsx: loadSession reconstruct   |
| PDF page selection                 | Upload.jsx + parse.js              |
| Editable date                      | Review.jsx: date input             |
| Export JSON                        | Output.jsx: download button        |
| No formula changes                 | calcLib.js not in target list      |

## Test Strategy
- Chosen: TS3 (no testing)
- Rationale: no test framework exists. Adding one for this feature
  is overhead without payoff. Build + manual verification.
- Verification: npm start succeeds, manual flow through each feature

## Risks & Open Questions
- Split.jsx will grow significantly (+200 lines). Monitor for
  extract-to-component opportunity.
- PDF preview on Review takes 50% width. May cause layout issues
  if we add more columns. Not blocking but worth watching.
```

## Traceability check

Every DoD item maps to at least one file target. The agent flagged
that `calcLib.js` is explicitly NOT in the target list, confirming the
"no formula changes" constraint is architecturally enforced.

## Test strategy decision

The agent scanned for test directories, CI config, and coverage tools.
Found nothing. Recommended TS3 (no testing) with rationale. The
architect agreed: this app is a personal tool, not production software.
