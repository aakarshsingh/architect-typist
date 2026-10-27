# P5 execute: Phase 2 (PDF Page Selection)

> New session (after resume). Agent reads `.state/`, finds Phase 2.

## Pre-Flight

Baseline check first: `npm start` builds clean, both servers up.

Reads Upload.jsx, parse.js, package.json. Confirms:
- Upload handles drag-drop and file picker for images and PDFs
- parse.js sends base64 to Claude Vision
- No pdf-lib dependency yet (will be added)

No assumption violations. Phase marked **Active**.

## Implementation

### Upload.jsx (+59 lines)

Page count detection on PDF upload:

```jsx
const handleFile = async (file) => {
  if (file.type === 'application/pdf') {
    const arrayBuffer = await file.arrayBuffer();
    const pdf = await PDFDocument.load(arrayBuffer);
    const pageCount = pdf.getPageCount();
    if (pageCount > 1) {
      setPages(pageCount);
      setSelectedPage(1);
      setShowPageSelector(true);
    }
  }
  // ... existing preview logic
};
```

Page selector UI:

```jsx
{showPageSelector && (
  <div className={styles.pageSelector}>
    <label>This PDF has {pages} pages. Which page is the bill?</label>
    <div className={styles.pageButtons}>
      {Array.from({ length: pages }, (_, i) => (
        <button
          key={i}
          className={selectedPage === i + 1 ? styles.selected : ''}
          onClick={() => setSelectedPage(i + 1)}
        >
          Page {i + 1}
        </button>
      ))}
    </div>
  </div>
)}
```

### server/routes/parse.js (+27 lines)

Server-side page extraction:

```javascript
if (req.body.pageNumber && req.body.pageNumber > 0) {
  const pdfDoc = await PDFDocument.load(buffer);
  const newDoc = await PDFDocument.create();
  const [page] = await newDoc.copyPages(pdfDoc, [req.body.pageNumber - 1]);
  newDoc.addPage(page);
  buffer = Buffer.from(await newDoc.save());
}
```

### package.json

Added `pdf-lib` as a dependency. Justified: required for PDF page
extraction, no alternative without a native binary dependency.

## Self-Audit

```
- [x] Only target files touched: 4 of 4, plus package-lock.json
- [x] Matches conventions: camelCase, CSS Modules
- [x] No hardcoded secrets: diff contains no keys or tokens
- [x] pdf-lib added with justification: noted above
- [x] Build passes clean: npm start, both servers up
- [x] Changes are minimum necessary: no edits beyond the plan
- [x] Single-page PDFs and images unaffected: manual check passed
```

`package-lock.json` changed when pdf-lib was installed, and it isn't in
the target list. The agent listed it and asked before staging it.
Architect: "Stage it, it belongs with package.json."

## Completion

```
Phase 2 COMPLETED: PDF Page Selection
Files staged: Upload.jsx, Upload.module.css, parse.js,
              package.json, package-lock.json
Tests: skipped, test strategy is no testing
Field notes: 0
Next phase: Phase 3 (Editable Date + Review Cleanup)
```
