# U10 ask: Questions About the Shipped Code

> The same teammate, a day later, with questions of their own. `ask`
> answers from the code and nothing else. It doesn't start work, write
> state, or guess.

## Session

> /ask where does the discount get saved?

It's saved as part of the session payload. Output builds a `discount`
object with the amount, percentage, and applied flag
(`Output.jsx:212-219`) and posts the whole session to `/api/save`.
The route writes it to `data/history/<timestamp>.json` without looking
inside it (`save.js:14`). **Verified**

---

> does calcLib know about discounts at all?

No. A search for "discount" in `calcLib.js` finds nothing. It
calculates tax and service charge on the original item amounts, and
Split applies the discount to the totals it gets back
(`Split.jsx:96`). **Verified**

That means the discount comes off the post-tax total. The code
doesn't say whether that's intended. The archived requirements list
"any change to formula presets or tax logic" as a non-goal, which
suggests it was a deliberate trade-off. **Inferred** from
`.state/archive/2026-06-11-discount-pdf-date-export/requirements.md`.

---

> why did the PDF preview on Review get removed?

It squeezed the item table. Phase 1 spotted it as a field note: the
iframe took half the width on narrow screens. Phase 3 removed it,
since Phase 3 already owned `Review.jsx`. `git log` shows the commit
"Remove PDF preview iframe from Review", and the archived execution
plan records the field note and its resolution. Image previews were
kept (`Review.jsx:31`). **Verified**

---

> if a bill has a discount printed on it, does the parser pick it up?

I can't settle this from the code alone. The parsing prompt asks for
items, tax, and service charge and doesn't mention discounts
(`parse.js:40-62`). So a printed discount would most likely come back
as an ordinary item with a negative price, or be dropped. **Unknown**

What would settle it: run a bill with a printed discount through
`/api/parse` in test mode and look at the returned items. I haven't
run it, because parse calls the Claude API.

---

> can we make the discount apply before tax instead?

Yes, but it's a real change rather than a tweak. The discount would
have to move into the formula path in `calcLib.js`, which is shared by
all four presets (`calcLib.js:22-75`). `Split.jsx` would then pass the
discount in instead of applying it afterwards. The original
requirements ruled out touching `calcLib.js`, so this reverses a
decision. **Verified** for the code paths, the effort is my estimate.

I haven't changed anything. For a size read, run `/roadmap` in quick
estimate mode. To go ahead, start with `/scope`.

## What this demonstrates

1. **Every answer is checked against the code.** The labels tell the
   reader how much weight an answer can bear. "Verified" means the
   code path was read. "Inferred" and "Unknown" say what would settle
   them.

2. **"I don't know" is a valid answer.** The parser question couldn't
   be answered honestly without running it, so the agent said so and
   named the experiment instead of guessing.

3. **Questions don't turn into work.** The last question asked for a
   change. `ask` sized up what it would take and pointed at the right
   skill, then stopped. The architect decides whether it becomes work.

4. **Short references keep it readable.** `Split.jsx:96` fits on the
   line. A full path would wrap in most terminals.
