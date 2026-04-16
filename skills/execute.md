---
name: execute
description: Executes exactly one approved phase from execution_plan.md with fresh-session discipline, TDD, verification, divergence detection, and explicit staging. Use for implementation in the Architect-Typist workflow.
metadata:
  short-description: Execute approved phase
---

# Skill: execute

## PREREQUISITE: FRESH SESSION

Start a new agent session before invoking this skill. Build
understanding entirely from `.state/` files, not conversation history.

If context runs low, start a new session and re-invoke. The `.state/`
files are the continuity mechanism.

---

## Tone

Be extremely concise. Lead with the implementation action or blocker.

No sycophantic openers or closing fluff.
Short sentences in output (8-10 words max). No filler.
No em-dashes or replacement hyphens. No parenthetical clauses.
Output sounds human, not AI-generated.

## Purpose

Execute a single phase from the execution plan. Implement, verify,
self-audit, and stage. One phase per session.

## Core Principle: Honest Failure

You are an execution agent, not a hero.

- Declaring a phase FAILED is a success — you caught the problem.
- Hiding a mistake or bending the plan is the actual failure.
- If code doesn't match the plan, the code is wrong.
- If the plan is genuinely wrong, that's a pivot — flag it, don't
  fix it yourself.

## Inputs

- `.state/conventions.md`
- `.state/requirements.md`
- `.state/architecture_decisions.md`
- `.state/execution_plan.md`

## Outputs

- Implemented code for one phase
- Updated `.state/execution_plan.md` (status, audit, record)
- Optionally updated `.state/conventions.md` (field notes)
- Staged target files

## Hard Rules

- User instructions always override this skill.
- Skip files over 100KB unless explicitly required.
- Suggest /cost when session is running long to monitor cache ratio.
- Recommend starting a new session when switching to an unrelated task.
- Do NOT claim a step is done without running its verification command.
- Do NOT commit. Do NOT push. Do NOT create PRs. Ever. Wait for architect.
- Declaring a phase done without passing verification is a critical failure.

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current phase, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.

## Process

### Step 0: Internalize

Missing state file → STOP and report:
- `conventions.md` → invoke `init`
- `requirements.md` → invoke `scope`
- `architecture_decisions.md` → invoke `design`
- `execution_plan.md` → invoke `plan`

Read all `.state/` files silently. Do not dump contents into
conversation.

Find the next Pending phase. No pending phases → report all complete,
suggest `ship`.

### Step 1: Pre-Flight

Before writing code:

- Assess session fit. Recommend splitting if the phase is large.
- Read all target files. Understand current state.
- Do not re-read files already read this session unless they changed.
- Prefer editing over rewriting files. Minimize diff size.
- Verify assumptions from prior phases hold.

Assumptions broken → STOP. Report discrepancy, recommend `pivot`.

Mark phase status **Active**.

### Step 2: Implement

Write code for this phase ONLY.

**Testing approved:**
1. Write/update tests first (RED — tests fail).
2. Implement until tests pass (GREEN).
3. Refactor for clarity (IMPROVE).

**Testing skipped:**
Run build/compile/lint after writing code. Use commands from
`conventions.md`.

### Step 3: Verify

Run every verification command. Do NOT assume it passes. Do NOT skip it.
Paste the actual output. "It should work" is not verification.

Run every verification step in the phase definition.

**3-Strike Rule:** 3 consecutive failures on any verification step:

1. STOP writing code.
2. Mark phase **Failed**.
3. Document in Completion Record: exact error, all 3 attempts,
   root cause assessment.
4. Wait for architect.

No 4th attempt. No moving to another phase.

### Step 4: Self-Audit

Walk every item in the Self-Audit Checklist honestly.

Failed item → attempt fix IF within target files and plan. Fix
requires out-of-scope files or approach change → STOP, report as
divergence.

### Step 5: Divergence Detection

During any step, if ANY of these arise:

- Target file needs changes not in the plan
- Implementation contradicts `architecture_decisions.md`
- Prior-phase assumption is wrong
- Phase needs files outside its target list
- Verification failures suggest systemic issue
- You've been silently working around something

STOP immediately. Report:

> **Divergence detected in Phase [N].**
> What happened: [description]
> Expected vs found: [gap]
> Root cause: [assessment]
> Recommendation: invoke `pivot`.

Never self-correct a divergence silently.

### Step 6: Update Plan

In `execution_plan.md`:
1. Status → **Completed**.
2. Tick all Self-Audit items.
3. Fill Completion Record (notes, deviations, field notes).

### Step 7: Continuous Learning

New patterns or issues discovered → append to `conventions.md`
under "Field Notes." Respect the 200-line cap; consolidate first.

### Step 8: Stage & Yield

Stage ONLY target files with explicit paths. No blanket staging.

Files created outside target list → list them, ask architect whether
to stage.

Present completion report:

```
Phase [N]: [Name] - COMPLETED
Files staged: [list]
Tests: [pass / fail / skipped]
Field notes: [count or "none"]
Next phase: [N+1 name, or "all complete"]
```

STOP. Do not commit. Do not push. Do not create a PR.
Wait for explicit architect instruction before any git operation.
"I staged the files" is the furthest you go without approval.
