# Baseline: bill-splitter at Feature 2

> Commit `0ae6d9c` on `aakarshsingh/bill-splitter`

## What the app does

A local bill-splitting app. Upload a restaurant bill, let AI parse it,
assign items to people, calculate a fair split with tax and service
charge handled correctly.

## Tech stack

- **Frontend:** React (CSS Modules, no frameworks)
- **Backend:** Node.js + Express
- **AI:** Claude API (claude-sonnet-4-20250514) for bill parsing + assignment
- **Storage:** Local JSON files (`data/` directory)
- **Tests:** None. No linter. No CI.

## Screen flow

```
Upload -> Review -> People -> Instructions -> Assign -> Split -> Output
  1         2        3          4              5        6        7
```

## Repo structure

```
bill-splitter/
├── client/
│   ├── src/
│   │   ├── App.jsx                 # Session state, screen routing
│   │   ├── calcLib.js              # Shared tax/SC formula logic
│   │   └── screens/
│   │       ├── Upload.jsx          # Drag-drop, file picker, past sessions
│   │       ├── Review.jsx          # AI-parsed items, editable table
│   │       ├── People.jsx          # Friend chips, preferences modal
│   │       ├── Instructions.jsx    # Auto-generated, @ and # autocomplete
│   │       ├── Assign.jsx          # Item-person matrix, +/- shares
│   │       ├── Split.jsx           # Per-person totals, share bars
│   │       └── Output.jsx          # Summary, WhatsApp copy, image export
│   └── package.json
├── server/
│   ├── index.js
│   └── routes/
│       ├── parse.js                # POST /api/parse (Claude Vision)
│       ├── assign.js               # POST /api/assign (Claude NLP)
│       ├── people.js               # GET/POST /api/people
│       ├── preferences.js          # GET/POST /api/preferences
│       ├── save.js                 # POST /api/save
│       └── load.js                 # GET/POST /api/load
├── data/
│   ├── people.json
│   ├── preferences.json
│   ├── test-bill.json
│   └── history/
├── CLAUDE.md
├── README.md
└── package.json
```

## Key patterns to know

- **Paise:** All money values are integers (paise, not rupees). No floats.
- **Session state:** Prop drilling via `App.jsx`'s `sessionData` object.
  Each screen gets `initialData` and calls `onConfirm(data)` to advance.
- **Back-nav:** Screens restore state from `sessionData` props, no re-fetching.
- **Formula presets:** calcLib.js supports Indian GST, Flat, SC-then-Tax,
  Tax-then-SC. Selected on Review, flows through all downstream screens.
- **Test mode:** Upload a `.json` file to skip AI calls entirely.
