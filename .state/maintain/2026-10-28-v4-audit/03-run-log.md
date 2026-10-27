# Run Log: v4 skill audit

Newest first.

- 2026-10-28: Campaign closed. Rewrote `04-closeout.md` to the final
  state and committed v4.
- 2026-10-28: Research fold-in. execute runs the build before
  changing anything and may only edit the current phase in the plan.
  scope suggests "When X, then Y" DoD items. fast gets the
  one-sentence-diff rule of thumb. ship recommends explain when
  someone else will own the code. The README gained a "Why I Built
  This" section, a fourth principle ("Short bursts, never long
  runs"), Related Approaches with sources, and two new guardrails.
  Tagline: "Model and tool agnostic agentic coding."
- 2026-10-28: Docs pass. Brought tech-talk 01-10 to v4 formats: Plan
  Status, evidence on audits and the DoD, dated archive, no TS labels,
  new completion headers, artifacts for the PR. Added examples 11
  roadmap, 12 explain, 13 ask. The README gained a Philosophy
  section. Skill fix: plan and pivot accept manual checks as
  verification, because a "no testing" project can't verify by
  command alone.
- 2026-10-28: Restored the 977e2d7 output style as a shared
  `## Output Style` block in all 17 skills. Per the architect: full
  natural sentences, no word limits, no AI framing. fast pauses after
  each micro step by default again.
- 2026-10-28: Full repo pass against 977e2d7 standards and README
  ethos. Restored init's 100KB skip, which v4 had dropped by mistake.
  Removed parenthetical clauses, ` - ` stand-ins, and leftover
  `Do NOT` emphasis from forge and maintain. Fixed the README quick
  start to use prefixed commands.
- 2026-10-28: Follow-up done. Added `## Reference Format` to review,
  triage, and ship. The block is identical in all 6 skills that
  have it.
- 2026-10-28: Ran forge on explain, ask, and roadmap. explain now
  uses principles and a toolbox of shapes instead of a fixed
  template. Added `## Reference Format` (short `name.ext:line`) to
  all three. roadmap issue bodies use repo-relative paths.
  **Open follow-up:** a maintain pass to add the same Reference
  Format section to review, triage, and ship.
- 2026-10-28: Checks. No em-dashes in skills, README, or cheatsheet.
  Git Sync and Question Rule blocks are identical in every skill that
  has them. All 17 skills have Hard Rules. Sync script tested in a
  temp dir: 17 installed, stale `as-u4-estimate` reported.
- 2026-10-28: README and cheatsheet updated.
- 2026-10-28: Added `scripts/sync-skills.sh`.
- 2026-10-27: Wrote roadmap, explain, and ask. Removed
  `skills/estimate.md`.
- 2026-10-27: Rewrote or edited all 15 existing skills per the plan.
