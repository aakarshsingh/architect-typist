# P5 execute: Phase 3 (Editable Date + Review Cleanup)

> New session. Agent reads `.state/`, finds Phase 3 Pending.
> Also reads the Phase 1 field note about PDF preview width.

## Pre-Flight

Baseline check first: `npm start` builds clean, both servers up.

Reads Review.jsx and Review.module.css. Confirms:
- Review shows editable table with item name, type, qty, prices
- PDF preview iframe sits in a CSS grid alongside the table
- Date is extracted by AI but not shown or editable on this screen
- The Phase 1 field note (PDF preview squeezing table) is confirmed

Phase marked **Active**.

## Implementation

### Review.jsx (+37/-14 lines)

Editable date input:

```jsx
<div className={styles.dateRow}>
  <label>Bill Date:</label>
  <input
    type="date"
    value={billDate}
    onChange={(e) => setBillDate(e.target.value)}
  />
</div>
```

Remove PDF preview iframe (fixing the Phase 1 field note):

```jsx
// REMOVED: PDF preview panel that squeezed table
// <div className={styles.previewPanel}>
//   <iframe src={previewUrl} ... />
// </div>

// KEPT: image preview for non-PDF uploads
{previewUrl && !isPdf && (
  <img src={previewUrl} alt="Bill preview" className={styles.preview} />
)}
```

Date flows through reviewData:

```jsx
const handleConfirm = () => {
  onConfirm({
    ...reviewData,
    date: billDate,   // edited date replaces AI-extracted date
  });
};
```

### Review.module.css (-7 lines)

Removed `.previewPanel` grid styles. Table now uses full width.
Added `.dateRow` styling.

## Self-Audit

```
- [x] Only target files touched: git diff --name-only lists 2 of 2
- [x] Matches conventions: camelCase, CSS Modules
- [x] PDF preview removal resolves the Phase 1 field note
- [x] Date field is editable and flows downstream: manual check
- [x] Image preview still works for non-PDF uploads: manual check
- [x] Build passes clean: npm start, both servers up
- [x] Changes are minimum necessary: no edits beyond the plan
```

## Conventions Update

Removed the field note (resolved):

```diff
 ## Field Notes
-- Review: PDF preview iframe takes 50% width, squeezes table on
-  narrow viewports. Image preview does not have this issue.
+(none active)
```

## Completion

```
Phase 3 COMPLETED: Editable Date + Review Cleanup
Files staged: Review.jsx, Review.module.css
Tests: skipped, test strategy is no testing
Field notes: 0 (1 resolved)
Next phase: All phases complete -> suggest ship
```
