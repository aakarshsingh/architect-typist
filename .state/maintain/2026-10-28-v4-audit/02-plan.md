# Plan: v4 skill audit

**Status:** Frozen (approved 2026-10-27)

## Cross-cutting

- Plain imperatives. Uppercase only for STOP and NOT at gates.
- A short reason on each hard rule.
- Shared blocks, verbatim across skills: Git Sync Rule (init,
  orient, maintain, with labeled exceptions), Question Rule,
  Resume Rule.
- Hard Rules in every skill, ending "User instructions override this
  skill."
- Inline the missing-state tables. Remove "same pattern as".
- Handoffs are "STOP and recommend `X`".
- One tool-agnostic line for parallel reads and subagents.
- Cut rules the model follows by default.
- Remove em-dashes from skills and cheatsheet.
- `metadata.slot` in frontmatter drives install names.

## Per skill

- init: read `resume.md`. Detect `roadmap.md` and `maintain/`.
- scope: approval gate. Template gains Non-Goals, Dependencies, and
  Edge Cases.
- design: test strategy labels match plan's strings.
- plan: `Plan Status: Draft | Approved`. Define "public-facing".
  Verification is runnable commands.
- execute: refuse a Draft plan. Divergence and 3-Strike become rule
  sections. Self-audit ticks need evidence. Pre-flight worktree
  check.
- ship: DoD evidence. Archive to `<YYYY-MM-DD>-<feature-slug>`.
- pivot: Draft while pivoting. Copy the checklist from the live plan.
- fast: optional run-through after plan approval.
- review: default target order. Verify findings.
- forge: document the house style and slot assignment.
- maintain: canonical Git Sync. Check README and cheatsheet.
- estimate: removed and merged into roadmap.

## New

- roadmap (u4), explain (u9), ask (u10)

## Docs

- README: install via `scripts/sync-skills.sh`, tables, guardrails,
  FAQ, structure
- cheatsheet: tables, guardrails, decision guide
- tech-talk: untouched, frozen demo
