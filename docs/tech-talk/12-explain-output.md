# U9 explain: The Discount Feature

> After ship. A teammate who will maintain bill-splitter wasn't part of
> any of the sessions. The architect runs `explain` on the shipped
> discount feature so the teammate can own it.

## Request

> /explain the discount feature that just shipped. Assume they know
> React but have never seen this codebase.

## The agent's choice

The agent read the branch diff, the archived `.state/` for the
feature, and the commit messages. It picked its shape based on the
subject:

> This feature is about money moving through screens, so I'll follow
> one real bill through it. One dinner, ₹3,000, three people, ₹100
> off. Four stops: typing a discount, applying it, splitting it, and
> where it ends up. I'll pause after the second stop.

## 1. Typing changes nothing

There are three ways to enter a discount: a percentage, a flat amount,
or the final amount you actually paid. Only one can hold a value at a
time. Typing in one clears the other two, which removes any doubt
about what Apply will use (`Split.jsx:42-58`).

Nothing is calculated while you type. Totals stay exactly as they were
until you press Apply. That was the architect's call during scoping,
and it's why there's an `applied` flag rather than a live value.

```
 Discount %    [ 10   ]
 Flat amount   [      ]   ← cleared when you typed in %
 Final paid    [      ]   ← cleared too
                  [Apply]  [Clear]
```

## 2. Apply turns words into paise

Pressing Apply converts whatever you typed into one number: the
discount in paise. All money in this app is integer paise, never
rupees with decimals, so ₹100 becomes `10000`.

Each mode gets there differently (`Split.jsx:96-110`):

| You typed | Calculation | Discount |
|---|---|---|
| 10% of ₹3,000 | 300000 × 10 / 100 | 30000 |
| Flat ₹100 | 100 × 100 | 10000 |
| Final paid ₹2,900 | 300000 − 290000 | 10000 |

The result is clamped so it can never exceed the bill. For our dinner,
the discount is 10000 paise.

> **Continue, go deeper on the modes, or skip to the big picture?**
>
> Teammate: continue

## 3. Splitting without losing a paise

Now 10000 paise has to be shared among three people who each ate
₹1,000 worth. A fair split is 3333.33 paise each, but you can't pay a
third of a paisa.

The code uses the largest-remainder method (`Split.jsx:71-94`). Give
everyone the whole-number part first, then hand the leftover paise,
one at a time, to whoever had the biggest fractional part.

| Person | Exact share | Floor | Remainder | Final |
|---|---|---|---|---|
| Asha | 3333.33 | 3333 | 0.33 | 3334 |
| Ben | 3333.33 | 3333 | 0.33 | 3333 |
| Chitra | 3333.33 | 3333 | 0.33 | 3333 |
| **Total** | | 9999 | **1 left** | **10000** |

There's a three-way tie, so the first person in the list gets the
extra paisa. The total always matches the discount exactly. The same
logic works when shares are unequal, which is the usual case: someone
who ate twice as much absorbs twice the discount.

## 4. Where the discount ends up

When you leave Split, the discount travels inside `splitData` to
`App.jsx`, which keeps it in the session. From there it shows up in
three places:

- **Output** shows each original total struck through with the
  discounted total beside it, plus a "Discount (10%)" row in
  percentage mode (`Output.jsx:118-124`).
- **WhatsApp text and image export** include a discount line
  (`Output.jsx:164`, `Output.jsx:203`).
- **Saved sessions** store a `discount` object. On reload, `App.jsx`
  rebuilds the Split screen's applied state from it (`App.jsx:88`).
  This last part was missing at first and was fixed in amend Phase 1A.

## The big picture

```
  Split screen                       App.jsx                Output
 ┌─────────────────────┐   onConfirm   ┌─────────────┐   props  ┌──────────────┐
 │ 1 type (one field)  │ ────────────▶ │ sessionData │ ───────▶ │ strikethrough│
 │ 2 Apply → paise     │   splitData   │  .discount  │          │ WhatsApp     │
 │ 3 largest remainder │               └──────┬──────┘          │ image export │
 └─────────────────────┘                      │ save            └──────────────┘
            ▲                                 ▼
            │ rebuild on load          data/history/*.json
            └─────────────────────────────────┘
```

The discount is a layer on top of the existing split, not part of the
tax formula. `calcLib.js` computes tax and service charge exactly as
before, and the discount is applied to the result. That keeps the
formula presets untouched, which was a hard constraint. It also means
the discount comes off the post-tax total, so keep that in mind if
anyone asks for "discount before tax".

For users, the visible change is a discount box on Split and a
discount line everywhere the bill is shared. Nothing else moved.

The main risk is size. `Split.jsx` grew by about 245 lines, and design
flagged it as a candidate for extracting a `DiscountPanel` component.

**Read next:** `Split.jsx:71` for the distribution, `App.jsx:88` for
the reload path, and `Output.jsx:118` for the display.

## What this demonstrates

1. **The shape fits the subject.** A money feature is easiest to
   understand by following real money. A plan or a refactor would
   get a different shape: a timeline, or a before-and-after.

2. **Small pieces, then the whole.** Each stop is one idea that builds
   on the last. The diagram at the end connects things the reader
   already understands, rather than introducing them all at once.

3. **Grounded, not paraphrased.** Every claim points at a line of
   code, and references stay short enough to read in a terminal.

4. **This is how comprehension debt gets paid down.** The teammate
   didn't write a line of this feature. Ten minutes later they know
   where the money goes, why, and where it could break.
