# Intake: v4 skill audit (2026-10-27)

**Status:** Frozen

- **Input mode:** direct human conversation
- **Targets:** all 15 skills, README, cheatsheet. New: roadmap,
  explain, ask.
- **Asks:**
  1. Audit every skill, tighten gaps, and align with how current
     models follow instructions.
  2. Fix the README sync instructions.
  3. Add skills: work planning (estimates, design options, GitHub
     issue breakdown), explanation (chunked mental models), and repo
     Q&A (read-only, code-grounded).

## Classification

- Wording drift: shouted emphasis, the "invoke" vs STOP wording,
  em-dashes, init tone heading
- Heuristic gap: question rules over-asked; review didn't verify its
  findings
- Stop-rule problem: plan could be executed while still a draft;
  execute's self-audit invited ticking unchecked items
- Docs drift: README install command, Hard Rules only in 7 of 15
  skills, 3 different Git Sync wordings
- Decision-tree gap: init ignored `resume.md`; scope's template had
  no non-goals, dependencies, or edge cases

## Architect decisions

- Apply all tightening.
- Install names prefixed `as-<slot>-<slug>`.
- Merge `estimate` into `roadmap`.
- `roadmap` creates issues with `gh` after approval and falls back to
  paste-ready text.
