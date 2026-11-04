# Intake: critical thinking skills

- **Date:** 2026-11-05
- **Input mode:** Direct human conversation. The architect approved
  the plan in `.state/critical-thinking-plan.md` and asked to
  proceed without stopping unless a question blocks.
- **Targets:** `orient`. Docs: `README.md`, `docs/cheatsheet.md`,
  `.state/conventions.md`, new `docs/critical-thinking.md`.
- **Related:** new skills `challenge`, `defend`, `practice`, forged
  in the same session.

## Problem

The workflow guards the agent well but doesn't challenge the
architect. Pull-based utilities such as `explain` go mostly unused.
Three new skills address that. They need a nudge that doesn't
depend on memory, and docs that explain them.

## Classification

- `orient`: decision-tree gap. It has no step for suggesting the new
  skills, and it's read-only, so it can't record an opt-out.
- Docs: docs drift. Skill count, tables, and `.state/` file list.

## Evidence

- The architect reports using `explain` properly about twice.
- `orient.md` Hard Rules: "Read-only, except when delegating to
  `init`."
- The README utility table lists what each skill does but not who
  does the thinking, which made `explain`, `ask`, and `defend` sound
  alike.

## Confirmed decisions

- One-way: the core workflow never references the new skills.
  `orient` is the only exception.
- Nudges on by default. "Stop nudges" turns them off per project,
  recorded as `nudges: off` in `.state/learning.md`.
- Keep `explain` and `ask`. Add a "who does the thinking" table.
- Ethos goes in a separate doc, linked from the README. No mention
  of other tools or workplaces.
