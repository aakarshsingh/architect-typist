---
name: execute
description: Executes exactly one approved phase from execution_plan.md with fresh-session discipline, verification, divergence detection, and explicit staging. Use for implementation in the Architect-Typist workflow.
metadata:
  short-description: Execute approved phase
  slot: p5
---

# Skill: execute

## Tone

Be extremely concise. Lead with the implementation action or blocker.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Execute a single phase from the execution plan. Implement, verify,
self-audit, and stage. One phase per session.

Start in a fresh session. Build understanding from `.state/` files,
not conversation history. Stale context from earlier phases or
design debates leads to code that matches the discussion instead of
the approved plan. Context running low → write `resume.md`, start a
new session, re-invoke.

## Honest Failure

A phase declared Failed is a good outcome: the problem was caught
before it compounded. Hiding a mistake or bending the plan is the
real failure.

- Code doesn't match the plan → the code is wrong.
- Plan is genuinely wrong → that's a pivot. Report it. Don't fix the
  plan yourself.

## Inputs

- `.state/conventions.md`
- `.state/requirements.md`
- `.state/architecture_decisions.md`
- `.state/execution_plan.md`

## Outputs

- Implemented code for one phase
- Updated `.state/execution_plan.md`: status, audit, completion record
- Optional field notes in `.state/conventions.md`
- Optional `.state/resume.md` update when a handoff is needed
- Staged target files

## Outcome Contract

Complete when exactly one approved phase is implemented, verified,
self-audited, recorded in `execution_plan.md`, and either staged or
honestly reported as blocked or failed.

The approved plan is the execution contract. Stop on divergence, the
3-Strike Rule, or any architect decision point.

## Hard Rules

- Claim a step done only after running its verification command and
  reading the output. Unverified "done" is the failure this workflow
  exists to prevent.
- No commit, push, PR, or branch operations. The architect owns
  every commit.
- Stage target files with explicit paths. No `git add .` or `-A`.
- Touch only the current phase's target files.
- In `execution_plan.md`, change only the current phase's status,
  ticks, and Completion Record. Editing other phases, the plan's
  rules, or any Definition of Done to match what was built hides
  drift instead of reporting it.
- User instructions override this skill.

## Divergence Rule

Applies during every step. Any of these → STOP:

- A target file needs changes not in the plan
- Implementation contradicts `architecture_decisions.md`
- A prior-phase assumption is wrong
- The phase needs files outside its target list
- Verification failures point to a systemic issue
- You notice you've been working around something
- You're tempted to edit the plan or DoD to fit the code

Report:

> **Divergence detected in Phase [N].**
> What happened: [description]
> Expected vs found: [gap]
> Root cause: [assessment]
> Recommendation: `pivot`, or adjust in place if contained.

Don't self-correct a divergence. The architect decides.

## 3-Strike Rule

3 consecutive failures on any verification step:

1. Stop writing code.
2. Mark the phase **Failed**.
3. Record in the Completion Record: exact error, all 3 attempts, root
   cause assessment.
4. Wait for the architect. No 4th attempt, no other phase.

Why: repeated blind fixes tend to widen the diff and hide the cause.

## Resume Rule

Session ending before the outcome is complete → write
`.state/resume.md` with: current skill, current state including phase
number, next action, read-first files, and a resume prompt. Echo the
prompt in the reply.

## Process

### Step 1: Internalize

Missing state → STOP and recommend:
- `conventions.md` → `init`
- `requirements.md` → `scope`
- `architecture_decisions.md` → `design`
- `execution_plan.md` → `plan`

Read all `.state/` files silently, except `archive/`.

`Plan Status` is not `Approved` → STOP. Recommend finishing `plan`
review.

Find the first Pending phase. A phase is Active or Failed → report it
and ask before continuing. None pending → report all complete,
recommend `ship`.

### Step 2: Pre-Flight

Before writing code:

- Check the worktree. Unexpected changes outside prior phases'
  targets → report and ask.
- Run the build or quick check from `conventions.md` before changing
  anything. Already failing → STOP and report. Building on a broken
  base makes every later failure ambiguous.
- Read every target file.
- Confirm assumptions from prior phases still hold. Broken → STOP,
  report, recommend `pivot`.
- Phase looks too large for the remaining session → say so and
  recommend splitting.

Mark the phase **Active**.

### Step 3: Implement

Write code for this phase only. Prefer small edits over rewrites.

**Testing approved:**
1. Write or update tests first. Confirm they fail.
2. Implement until they pass.
3. Refactor for clarity. Tests stay green.

**Testing skipped:**
Run build, compile, or lint after writing code, using the commands
in `conventions.md`.

### Step 4: Verify

Run every verification command in the phase definition. Show the
actual output. Apply the 3-Strike Rule.

### Step 5: Self-Audit

Walk each Self-Audit item against the actual diff.

- Met → tick it and note the evidence: command output, file, or diff
  check.
- Not met, and fixable within target files and plan scope → fix,
  re-verify, then tick.
- Not met otherwise → leave unticked and apply the Divergence Rule.

Never tick an item you didn't check.

### Step 6: Update Plan

In `execution_plan.md`:
1. Status → **Completed**, in the phase and the summary table.
2. Fill the Completion Record: notes, self-audit evidence,
   deviations, field notes.

### Step 7: Field Notes

New durable patterns or gotchas → append to `conventions.md` under
"Field Notes". Respect the 200-line cap. Consolidate first.

### Step 8: Stage & Yield

Stage only target files with explicit paths. Files created outside
the target list → list them and ask whether to stage.

```
Phase [N] COMPLETED: [Name]
Files staged: [list]
Tests: [pass / fail / skipped]
Field notes: [count or "none"]
Next phase: [N+1 name, or "all complete"]
```

STOP. Wait for the architect before any git operation or next phase.
