# U4 roadmap: Planning the Four Features

> A prequel. Before any of the pipeline ran, the architect had a loose
> list of four features and an existing GitHub issue. `roadmap` turned
> that into a planned, sized set of issues.

## Architect's request

> I want to plan the next release of bill-splitter. Discounts are the
> big one, there's already an issue for it. I also want PDF page
> selection, an editable date, and a JSON export. Break it down.

## Mode and questions

The request covers several features, so the agent picked roadmap mode
and asked two questions.

```
1. Is this one release, or can features ship separately?
   Recommended: one release, but each feature as its own issue so
   small ones can go through fast without waiting on discounts.
   -> Architect: one release, separate issues.

2. Any deadline or constraint I should plan around?
   Recommended: none assumed. Without a date, I'll order by
   dependency and risk.
   -> Architect: no deadline. Don't touch calcLib.js.
```

## Survey

The agent read the screens, the server routes, and `calcLib.js` in
parallel, then searched for overlapping issues.

```
$ gh issue list --search "discount OR pdf OR export" --state open
#12  Support discounts on bills          enhancement
```

Findings it reported:

- Discount touches `Split.jsx`, `Output.jsx`, and `App.jsx`. Money is
  paise integers throughout, see `calcLib.js:8`.
- PDF upload goes straight to Claude Vision in `parse.js:31`. Picking a
  page needs server-side extraction, and nothing in the repo does that
  yet.
- The date is already extracted by the parser but only displayed,
  `Review.jsx:112`.
- There are no tests, no linter, and no CI.
- Issue #12 already covers discounts. The agent proposed reusing it
  rather than creating a duplicate, and didn't touch it.

## Design options

The agent compared approaches for the only feature with a real design
choice.

```
Discount: where does it live?

A. Bill-level discount on the Split screen       ← recommended
   Applied after the existing formula runs. calcLib.js stays untouched.
   Trade-off: discount is spread by share, not by item.
   Size: M

B. Discount as a negative line item on Review
   Reuses the item table. But it would be assigned to people like a
   dish, which makes proportional splitting awkward.
   Size: S, with UX problems later

C. Discount as a new formula preset in calcLib.js
   Most precise, applies before tax. Violates "don't touch calcLib".
   Size: M-L
```

Architect: "A."

## Breakdown

The PDF work has one unknown: whether page extraction works without a
native dependency. The agent put a spike first so that answer arrives
before anyone commits to the approach.

```
| # | Title                                   | Size | Depends on | GitHub |
|---|-----------------------------------------|------|------------|--------|
| 1 | Spike: extract one PDF page server-side | XS   | none       | #14    |
| 2 | Support discounts on bills              | M    | none       | #12    |
| 3 | Pick a page from multi-page PDF bills   | S    | 1          | #15    |
| 4 | Make the bill date editable on Review   | XS   | none       | #16    |
| 5 | Export a session as JSON from Output    | XS   | 2          | #17    |

Total: one M, one S, three XS. Confidence: medium.
Uncertainty driver: the spike. If pdf-lib can't do it cleanly, #15
grows to M.
Critical path: #14 → #15. Discounts can run in parallel.
```

One issue body as it went to GitHub. Paths are repo-relative because
people read issues in a browser without the repo open.

```markdown
### 3. Pick a page from multi-page PDF bills

**Size:** S, confidence medium
**Depends on:** #14
**Next motion:** scope
**Labels:** enhancement

**Problem:** Multi-page PDFs send every page to Claude Vision,
including menus, which slows parsing and confuses item extraction.

**Scope:**
- Detect page count on upload
- Show a page picker when there is more than one page
- Extract the chosen page on the server before parsing

**Non-goals:**
- Parsing several pages in one request

**Acceptance criteria:**
- [ ] Multi-page PDFs show a page picker
- [ ] Only the selected page reaches the parser
- [ ] Single-page PDFs and images skip the picker

**Notes:** likely files `client/src/screens/Upload.jsx`,
`server/routes/parse.js`. Depends on the pdf-lib result from #14.
```

The roadmap was written to `.state/roadmap.md` as Draft. The architect
read the order table and said "approved".

## Publish

```
$ gh auth status          ✓ Logged in
$ gh repo view            aakarshsingh/bill-splitter

Created epic   #13  Release: discounts, PDF pages, date, JSON export
Created        #14  Spike: extract one PDF page server-side
Created        #15  Pick a page from multi-page PDF bills
Created        #16  Make the bill date editable on Review
Created        #17  Export a session as JSON from Output
Linked as sub-issues of #13: #12, #14, #15, #16, #17
```

```
Roadmap: PUBLISHED

Epic: #13 Release: discounts, PDF pages, date, JSON export
Issues: #12, #14, #15, #16, #17 (5)
Total: 1 M, 1 S, 3 XS, confidence medium
Start with: #14 via spike
```

## What happened next

The spike ran through `fast` and confirmed pdf-lib extracts a page with
no native binaries. The architect then chose to scope #12, #15, #16,
and #17 together as one pipeline cycle, since they ship in the same
release. That cycle is [02-scope-output.md](02-scope-output.md)
onward.

## What this demonstrates

1. **Sizes point at a next step.** XS means `fast`, M means the full
   pipeline. The estimate is useful because it tells you what to run.

2. **Unknowns go first.** The spike is ordered ahead of the work it
   could change, so a bad surprise costs an hour, not a phase.

3. **Nothing reaches GitHub without approval.** The agent drafted,
   the architect approved, and only then were issues created. The
   existing issue #12 was reused, not duplicated or edited.

4. **Roadmap doesn't replace design.** It picked the shape of the
   discount feature. `design` still decided the files and data flow.
