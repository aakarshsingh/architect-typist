---
name: ship
description: Closes a completed feature cycle by verifying Definition of Done, running final checks, archiving state, and preparing commit-ready changes. Use after all planned phases are complete.
metadata:
  short-description: Finalize completed work
  slot: p6
---

# Skill: ship

## Tone

Be extremely concise. Lead with the verification result or blocker.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Close a completed feature cycle. Verify requirements, run final
checks, archive state, and prepare for commit.

## Inputs

- `.state/conventions.md`
- `.state/requirements.md`
- `.state/architecture_decisions.md`
- `.state/execution_plan.md`

## Outputs

- Archived files in `.state/archive/<YYYY-MM-DD>-<feature-slug>/`
- Pruned `.state/conventions.md`
- Staged files ready for commit
- Optional `.state/resume.md` update if ship is interrupted

## Outcome Contract

Complete when the Definition of Done is verified with evidence, final
checks have run or are honestly blocked, workflow state is archived,
conventions are pruned if needed, and explicit files are staged.

The architect keeps final authority over commit, push, and PR. Stop
when phases are incomplete or verification fails.

## Hard Rules

- No commit, push, or PR unless the architect asks.
- Every DoD item needs evidence: a test name, command output, or
  `file:line`. "Implemented" without evidence is not verified.
- Stage with explicit paths only.
- User instructions override this skill.

## Reference Format

Cite code as `name.ext:line` or `name.ext:10-18`, not the full path.
Two cited files share a name → add the nearest parent folder:
`api/rl.ts:40`. Keep each reference next to the claim it supports.

Why: full paths wrap and bury the point in a terminal.

## Resume Rule

Session ending before ship completes → write `.state/resume.md` with:
current skill, current state, next action, read-first files, and a
resume prompt. Echo the prompt in the reply.

Successful ship → delete `.state/resume.md`.

## Process

### Step 1: Verify Phase Completion

Missing state → STOP and recommend:
- `conventions.md` → `init`
- `requirements.md` → `scope`
- `architecture_decisions.md` → `design`
- `execution_plan.md` → `plan`

Read `execution_plan.md`. Confirm:
- Every phase status is Completed.
- Every Self-Audit Checklist is fully ticked.
- Every Completion Record is filled.

Anything incomplete → STOP and report.

### Step 2: Verify Definition of Done

Walk every DoD item in `requirements.md`:

```
[met]   "User can reset password" → test_reset_flow passes
[unmet] "Rate limit returns 429" → no test, handler at api/rl.ts:40
        returns 503
```

Unmet item → report current state and a recommendation. Continue only
when every item is met or the architect explicitly waives it.

### Step 3: Final Integration Check

Run the full build, test, and lint pipeline from `conventions.md`,
not just phase-level checks.

Failure → show the output, recommend a fix or `pivot`, STOP. Re-run
after any fix.

### Step 4: Diff Review

Diff against the merge base with upstream. No clear base → ask.

Present: files created, modified, and deleted; lines added and
removed; files changed outside every phase's target list, flagged.

Wait for acknowledgment.

### Step 5: Archive & Clean Up

1. Create `.state/archive/<YYYY-MM-DD>-<feature-slug>/`. Dated paths
   keep a second ship from the same branch from overwriting the
   first.
2. Move `requirements.md`, `architecture_decisions.md`, and
   `execution_plan.md` into it.
3. Delete `.state/resume.md` if present.
4. Prune `conventions.md`: consolidate if over 200 lines, remove
   stale field notes. Present the pruned version for approval.

### Step 6: Prepare Commit

Stage approved files with explicit paths. Draft a commit message that
follows project conventions. Present staged files and the draft, then
wait.

### Step 7: Report

```
Ship Complete

Feature: [name]
Phases completed: [N]
Files changed: [count]
Tests: [pass / fail / skipped]
Requirements DoD: [all met | N waived]
Archive: .state/archive/<YYYY-MM-DD>-<feature-slug>/
Conventions: [pruned from X to Y lines | unchanged]

Suggested Commit Message
[Draft. Architect edits before use.]

Ready for commit. Waiting for architect instruction.
```

Recommend `artifacts` for the PR description. Someone else will own
this code → also recommend `explain` on the branch.
