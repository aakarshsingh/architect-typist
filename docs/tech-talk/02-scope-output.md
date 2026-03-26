# P2 scope: Output

> `.state/requirements.md` produced by `as-p2-scope`

## Architect's request

> I want to add discount support to the bill splitter. Users should be
> able to enter a discount on the Split screen and see it reflected in
> Output. I also want PDF page selection for multi-page bills, an
> editable date field on Review, and an Export JSON button on Output.

## Agent interview (6 questions)

```
1. Discount model: flat amount, percentage, or both?
   Recommended: all three (%, flat rupees, final amount paid).
   Three inputs, user picks one. Covers "10% off" and "we paid 5000" equally.
   -> Architect: agreed.

2. How should discount distribute across people?
   Recommended: proportionally by pre-discount share, using
   largest-remainder method for exact paise allocation. No rounding errors.
   -> Architect: agreed.

3. When does discount apply? Live while typing, or explicit action?
   Recommended: live calculation as user types.
   -> Architect: NO. I want Apply/Clear buttons. No live calculation.
      The user commits to a discount explicitly. This is a hard constraint.

4. Should discount survive save/load?
   Recommended: yes. Save discount object in session JSON,
   reconstruct splitDiscount state on load.
   -> Architect: agreed.

5. PDF page selection: server-side or client-side extraction?
   Recommended: server-side via pdf-lib. Client sends page number,
   server extracts that single page before sending to Claude Vision.
   Avoids sending irrelevant menu pages to the AI.
   -> Architect: agreed.

6. Export JSON: what goes in the file?
   Recommended: same payload as save (full session dump) but downloaded
   as .json instead of written to data/history/.
   -> Architect: agreed.
```

## Requirements document

```markdown
# Requirements: Discount, PDF Pages, Date, Export

## Purpose
Add discount support to the bill splitter with three input modes.
Add PDF page selection, editable date, and JSON export as secondary features.

## Definition of Done
- [ ] Three discount modes: percentage, flat amount, final amount paid
- [ ] Apply/Clear model: no live calculation while typing
- [ ] Discount distributes proportionally (largest-remainder, paise integers)
- [ ] Discount reflected in Output: summary table, WhatsApp, image export
- [ ] Discount label shows "Discount (10%)" when percentage mode used
- [ ] Discount survives save/load round-trip
- [ ] PDF page selector for multi-page bills (server extracts page via pdf-lib)
- [ ] Editable date field on Review screen (pre-filled from AI extraction)
- [ ] Export JSON button on Output screen
- [ ] No changes to existing formula presets or tax logic

## Decisions & Options
| Decision | Chosen | Alternatives | Rationale |
|----------|--------|-------------|-----------|
| Discount distribution | Proportional with largest-remainder | Equal split, round-robin | Fairest: heavy spenders absorb more discount |
| Discount UX | Apply/Clear buttons | Live calculation | Architect requirement: explicit commitment |
| PDF extraction | Server-side pdf-lib | Client-side, send all pages | Avoids sending irrelevant pages to Claude |
| Export format | Same as save payload | Custom schema | Reuse existing structure, no new schema |

## Constraints
- Must: Apply/Clear model. No discount applied until user confirms.
- Must: Paise integers throughout. No floating point money math.
- Must: Discount persists on back-nav and save/load.
- Must NOT: Change existing formula presets or tax logic.
- Must NOT: Add new dependencies without justification.

## References
- calcLib.js: existing tax/SC formula logic (do not modify)
- App.jsx: session state management (sessionData object)
- Split.jsx: current per-person calculation (will be extended)
- Output.jsx: summary/WhatsApp/image export (will be extended)
```

## What happened

The architect overrode the agent's recommendation on question 3. The
agent suggested live calculation; the architect insisted on Apply/Clear.
This became a hard constraint in the requirements and directly shaped
the implementation in Split.jsx.

Without the scope debate, this would have been discovered mid-coding
as a "the architect doesn't like this" moment, requiring a rewrite.
