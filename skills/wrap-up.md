# Skill: wrap-up

## Purpose

Close out a completed feature cycle. Verify requirements are met, run
final checks, archive project state, and prepare for commit.

## Inputs

- `.memory/style_guide.md`
- `.memory/requirements.md`
- `.memory/architecture_decisions.md`
- `.memory/execution_plan.md`

## Outputs

- Archived project files in `.memory/archive/<branch-name>/`
- Pruned `.memory/style_guide.md`
- Staged files ready for final commit

## Process

### Step 1: Verify Phase Completion

Read `.memory/execution_plan.md`. Confirm:

- Every phase has status Completed.
- Every Self-Audit Checklist is fully ticked.
- Every Completion Record is filled.

If any phase is incomplete, STOP. Report to the architect. Do not
proceed with wrap-up on an unfinished plan.

### Step 2: Verify Requirements Definition of Done

Read `.memory/requirements.md`. Walk through every Definition of Done
item. For each:

- Verify it is satisfied by the implemented code.
- If a DoD item is NOT met, report to the architect:
  > **Unmet requirement:** [DoD item]
  > **Current state:** [what exists vs what's needed]
  > **Recommendation:** [fix in-place or invoke pivot-plan]

Do NOT proceed past this step until all DoD items are verified or the
architect explicitly waives unmet items.

### Step 3: Final Integration Check

Run the project's full verification suite - the complete
build/test/lint pipeline, not just phase-level checks. Use commands
from `.memory/style_guide.md` under "Tooling & Commands."

**If anything fails:**

1. Document the failure with full output.
2. Recommend: fix in-place or invoke `pivot-plan`.
3. STOP and wait for architect decision.
4. After the fix, re-run this step (Step 3) - do not skip
   re-verification.

### Step 4: Diff Review

Generate a consolidated diff of all changes against the base branch.
Present a summary:

- Files created / modified / deleted (count and list)
- Total lines added / removed
- Any files changed that were NOT in any phase's target list (flag
  these explicitly)

Wait for architect acknowledgment.

### Step 5: Archive

1. Determine the current git branch name.
2. Create `.memory/archive/<branch-name>/`.
3. Move into the archive:
   - `requirements.md`
   - `architecture_decisions.md`
   - `execution_plan.md`
4. Do NOT touch `style_guide.md` - it stays at root.

### Step 6: Prune Style Guide

Read `.memory/style_guide.md`. Check:

- Line count. If over 200 lines, consolidate: merge duplicates, remove
  entries about patterns/tools no longer in the codebase, tighten
  language.
- Stale entries. If a "Learned Quirk" references a file or dependency
  that no longer exists, remove it.

Present the pruned version to the architect for approval.

### Step 7: Prepare Commit

Stage all modified and new files using explicit file paths (not
blanket staging).

Draft a commit message following the project's conventions. Present
to the architect for approval.

Do NOT commit, push, or create PRs unless the architect explicitly
asks. Present the staged files and draft commit message, then wait
for instruction. The architect may ask you to:

- Commit only
- Commit and push
- Commit, push, and create a PR (use the suggested PR summary as
  a starting point)

### Step 8: Report

```
## Wrap-Up Complete

Feature: [name]
Phases completed: [N]
Files changed: [count]
Tests: [pass / fail / skipped]
Requirements DoD: [all met | N waived by architect]
Archive: .memory/archive/<branch-name>/
Style guide: [pruned from X to Y lines | unchanged]

### Suggested PR Summary (draft - architect edits before use)
[2-3 sentence summary derived from requirements.md and
architecture_decisions.md. This is a starting point, not final copy.
The architect adapts tone, adds context, and decides what to include.]

Ready for commit. Waiting for architect instruction.
```
