# Closeout: critical thinking skills

**Status:** Complete, pending commit approval.

## Touched

- New skills: `challenge` u11, `defend` u12, `practice` u13
- Changed: `orient`
- Docs: `README.md`, `docs/cheatsheet.md`, new
  `docs/critical-thinking.md`
- Memory: `.state/conventions.md`

## Key decisions

- The new skills are one-way. `orient` is the only skill that
  references them.
- Nudges are on by default, with a per-project opt-out in
  `.state/learning.md`.
- They use one question per turn, not the shared Question Rule,
  because answer-first conflicts with recommended answers.
- `explain` and `ask` stay. A "who does the thinking" table removes
  the naming confusion.

## Residual risks

- `orient` output now carries a first-time mention. Tech-talk mocks
  don't show it. Update after the pilot.
- The journal template is inlined in four skills. Keep them in sync.
- The user-level `CLAUDE.md` nudge for natural moments isn't done
  and needs separate approval.

## Recommended commit message

```
v5 - Add critical thinking skills: challenge, defend, practice

- Three experimental skills that challenge the architect and build
  real learning, one question per turn
- orient nudges them by default, with a per-project opt-out
- New docs/critical-thinking.md with the ethos and research
- README, cheatsheet, and conventions updated
```
