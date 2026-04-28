---
name: ship
description: Closes a completed feature cycle by verifying Definition of Done, running final checks, archiving state, and preparing commit-ready changes. Use after all planned phases are complete.
metadata:
  short-description: Finalize completed work
---

# Skill: ship

## Tone

Be extremely concise. Lead with the verification result or blocker.

## Purpose

Close a completed feature cycle. Verify requirements, run final
checks, archive state, and prepare for commit.

## Inputs

- `.state/conventions.md`
- `.state/requirements.md`
- `.state/architecture_decisions.md`
- `.state/execution_plan.md`

## Outputs

- Archived files in `.state/archive/<branch-name>/`
- Pruned `.state/conventions.md`
- Staged files ready for commit
- Optional `.state/resume.md` update if ship is interrupted

## Outcome Contract

Complete when the finished feature cycle has its Definition of Done
verified, final checks run or honestly blocked, workflow state
archived, conventions pruned if needed, and explicit files staged
for the final commit.

Preserve final human authority over commit, push, and PR creation.
Stop when planned phases are incomplete, verification fails beyond
the allowed remediation path, or staging requires architect approval.

## Resume Rule

If the session is ending before ship completes, write `.state/resume.md`
with current state and a concrete resume prompt. On successful ship,
delete `.state/resume.md`.

## Hard Rules

- Do NOT commit, push, or create PRs unless the architect asks.
- User instructions always override this skill.

## Process

### Step 1: Verify Phase Completion

Missing state file → STOP and report (same pattern as `execute`).

Read `execution_plan.md`. Confirm:
- Every phase status is Completed.
- Every Self-Audit Checklist is fully ticked.
- Every Completion Record is filled.

Any phase incomplete → STOP, report to architect.

### Step 2: Verify Definition of Done

Read `requirements.md`. Walk every DoD item:
- Verify it is satisfied by implemented code.
- Unmet item → report with current state and recommendation.

Do NOT proceed until all DoD items are verified or the architect
explicitly waives them.

### Step 3: Final Integration Check

Run the full build/test/lint pipeline (not just phase-level checks).
Use commands from `conventions.md`.

Failure → document with full output, recommend fix or `pivot`, STOP.
Re-run this step after any fix.

### Step 4: Diff Review

Generate consolidated diff against the merge base with upstream.
If no clear base, ask architect.

Present: files created/modified/deleted, lines added/removed, any
files changed outside phase target lists (flag explicitly).

Wait for acknowledgment.

### Step 5: Archive & Clean Up

1. Create `.state/archive/<branch-name>/`.
2. Move `requirements.md`, `architecture_decisions.md`,
   `execution_plan.md` to the archive.
3. Delete `.state/resume.md` if it exists.
4. Prune `conventions.md`: consolidate if over 200 lines, remove
   stale field notes. Present pruned version for approval.

### Step 6: Prepare Commit

Stage only approved files with explicit paths. Draft a commit message
following project conventions.

Do NOT commit, push, or create PRs unless the architect asks. Present
staged files and draft message, then wait.

### Step 7: Report

```
Ship Complete

Feature: [name]
Phases completed: [N]
Files changed: [count]
Tests: [pass / fail / skipped]
Requirements DoD: [all met | N waived]
Archive: .state/archive/<branch-name>/
Conventions: [pruned from X to Y lines | unchanged]

Suggested Commit Message
[Draft — architect edits before use.]

Ready for commit. Waiting for architect instruction.
```
