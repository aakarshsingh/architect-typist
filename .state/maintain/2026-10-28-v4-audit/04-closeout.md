# Closeout: v4 skill audit

**Status:** Closed 2026-10-28. Frozen.

This replaces an early draft that was written before the forge,
maintain, docs, and research passes. Nothing had been committed at
that point, so the draft was rewritten once, here, instead of
appended to.

## Touched

- **Skills:** all 15 existing skills reworked. `estimate` was merged
  into `roadmap`, and `roadmap`, `explain`, and `ask` were added, for
  17 in total.
- **Docs:** README.md, docs/cheatsheet.md, and docs/tech-talk/ 01-10,
  plus new examples 11-13.
- **New files:** scripts/sync-skills.sh, .gitignore,
  .state/conventions.md, .state/maintain/

## Key fixes

- Shared blocks are now verbatim across skills: Output Style, Git
  Sync Rule, Question Rule, Resume Rule, Reference Format, and Hard
  Rules.
- execute refuses a Draft plan. It runs the build before changing
  anything, may edit only the current phase in the plan, and ticks
  only with evidence.
- ship verifies every Definition of Done item with evidence and
  archives to a dated folder.
- scope's template covers non-goals, dependencies, and edge cases.
- plan and pivot accept manual checks as verification, so projects
  without tests can still prove each phase.
- explain chooses its own shape instead of following a fixed
  template.
- CLI output uses short `name.ext:line` references.
- The 977e2d7 writing standards are restored without word limits.
- fast pauses after each micro step by default.
- The README install instructions now match Claude Code's skill
  layout. It also gained Why I Built This, Philosophy, and Related
  Approaches sections.

## Verification

- No em-dashes in skills, README, or docs.
- The shared blocks match by hash in every skill that has them.
- Install slots are unique.
- Every skill appears in the README and the cheatsheet.
- The sync script installs all 17 skills. The installed copies were
  re-synced after the last change.

## Residual risks

- roadmap's `gh` sub-issue link is untested against a live repo. It
  falls back to the epic's task list.
- The tech-talk is mocked. Its line numbers and issue numbers are
  illustrative.

## Commit message

v4 - Tighten all skills, add roadmap, explain, ask, and sync script
