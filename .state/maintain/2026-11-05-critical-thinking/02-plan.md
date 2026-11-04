# Plan: critical thinking skills

**Status:** Approved by the architect in conversation, 2026-11-05.

## Objective

Add a default-on, opt-out nudge for the three critical thinking
skills to `orient`, and document the skills and their ethos.

## Edits

1. `skills/orient.md`
   - Hard Rules: narrow write exception for `.state/learning.md`,
     creating it and setting the `nudges:` line only.
   - New `## Critical Thinking Nudges` section: first mention once
     per project, at most one prefilled suggestion, never run,
     "stop nudges" and "turn nudges on".
   - New Step 4: Nudge. Report becomes Step 5.
2. `README.md`: skill count, a critical thinking skills table, a
   "who does the thinking" table, commands, `.state/` row for
   `learning.md`, project structure, a short Philosophy subsection
   linking the new doc, one habit.
3. `docs/cheatsheet.md`: count, table, `.state/` row.
4. `.state/conventions.md`: topography, Reference Format users,
   field notes for the one-way rule, the orient exception, and
   `learning.md`.
5. `docs/critical-thinking.md`: ethos, research, principles, the
   three skills, invocation, nudges, journal, pilot, future plan,
   sources.

## Risk

Low. `orient`'s new write is limited to one local, uncommitted
file. Core pipeline skills are untouched.

## Coherence surfaces

- Shared blocks: Output Style and Reference Format, verbatim in the
  new skills. Git Sync Rule unchanged in `orient`.
- The journal template is identical in `practice`, `defend`,
  `challenge`, and `orient`.
- The context header is identical across the three skills.

## Out of scope

- Core skill uplifts, until after the pilot
- Tech-talk examples, until after the pilot
- User-level `CLAUDE.md` note, which needs separate approval
