# P1 init: Output

> `.state/conventions.md` produced by `as-p1-init`

```markdown
# Conventions: bill-splitter

## Tone
Be extremely concise. Lead with answers, not reasoning.

## Project Topography
- Monorepo: client/ (React + CSS Modules), server/ (Express)
- npm workspaces with root package.json
- CRA dev server on :3000, Express API on :3001
- Claude API for bill parsing (Vision) and assignment suggestions
- Local JSON storage in data/ (people, preferences, history)
- No test framework, no linter, no CI

## Naming Conventions
- JS: camelCase vars/functions, PascalCase components
- Files: PascalCase.jsx for components, camelCase.js for utils
- CSS: PascalCase.module.css matching component name

## Patterns & Idioms
- Session state: prop drilling via App.jsx sessionData object
- Screen flow: App renders one screen at a time, passes onNext/onBack
- Each screen receives initialData, calls onConfirm(data) to advance
- Back-nav restores from sessionData props (no re-fetching)
- API: Express routes in server/routes/, one file per endpoint
- Formula: calcLib.js shared between client screens
- Paise: all money values stored as integers (paise), displayed as rupees

## Tooling & Commands
- `npm start` from root: runs both client (:3000) and server (:3001)
- `npm install` then `cd client && npm install`
- Test mode: upload .json file to skip AI API calls

## Field Notes
(none yet)
```

## What the agent discovered

The agent scanned 34 files across client/ and server/. Three questions
were asked:

1. **Naming:** camelCase in JS, PascalCase components, kebab-case CSS.
   Confirmed by reading existing files.

2. **State management:** Prop drilling through App.jsx. Agent asked if
   there were plans to move to context or a state library. Architect
   said no.

3. **data/ directory:** Contains real session history. Agent asked
   about .gitignore policy. Architect said keep local for now.

The paise convention and the `initialData`/`onConfirm` prop pattern
were discovered by reading `calcLib.js` and `App.jsx`, not by asking.
