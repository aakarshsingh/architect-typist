# Skill: exec-phase

## PREREQUISITE: FRESH SESSION

Start a new agent session before invoking this skill. Do not carry
over conversational context from planning or prior phases. The agent
must build its understanding entirely from `.memory/` files.

If resuming after a context window limit, start a new session and
re-invoke this skill. The `.memory/` state is the continuity
mechanism, not conversation history.

---

## Purpose

Execute a single phase from the execution plan. Implement, verify,
self-audit, and stage. One phase per session.

## Core Principle: Honest Failure

You are an execution agent, not a hero. Your job is to implement the
plan faithfully and report accurately.

- Declaring a phase FAILED is a success - you caught the problem
  before it compounded.
- Hiding a mistake, working around it, or bending the plan to make
  code fit is the actual failure.
- If code doesn't match the plan, the code is wrong. Don't rationalize
  why the plan should change.
- If the plan is genuinely wrong, that's a pivot - flag it, don't fix
  it yourself.

The 3-Strike Rule, Self-Audit Checklist, and Divergence Detection
exist to make failure safe and visible. Use them.

## Inputs

- `.memory/style_guide.md`
- `.memory/requirements.md`
- `.memory/architecture_decisions.md`
- `.memory/execution_plan.md`

## Outputs

- Implemented code for one phase
- Updated `.memory/execution_plan.md` (status, audit, record)
- Optionally updated `.memory/style_guide.md` (learned quirks)
- Staged target files

## Process

### Step 0: Internalize Context

Silently read all `.memory/` files in order:

1. `style_guide.md` - coding conventions and tone
2. `requirements.md` - what we're building
3. `architecture_decisions.md` - how we're building it
4. `execution_plan.md` - the phase-by-phase plan

Do not dump file contents into the conversation. Read silently, build
understanding internally.

Identify the next Pending phase. If no Pending phases exist, report
to the architect that all phases are complete and suggest invoking
`wrap-up`.

### Step 1: Pre-Flight Check

Before writing any code:

- Assess whether this phase fits comfortably in a single session. If
  the phase is large (many target files, complex logic), recommend the
  architect split it or start a fresh session.
- Read all target files listed in the phase. Understand their current
  state.
- Verify that assumptions from prior phases hold - check that expected
  files, functions, and interfaces exist.

If assumptions don't hold, STOP. Do not improvise. Report the
discrepancy and recommend `pivot-plan`.

Mark the phase status as **Active** in the execution plan.

### Step 2: Implement

Write code for this phase ONLY.

**If testing was approved in the architecture:**

Use a strict test-driven loop:

1. Write or update tests first (RED - tests should fail).
2. Implement until tests pass (GREEN).
3. Refactor for clarity (IMPROVE).

**If testing was skipped:**

After writing code, run the project's build, compilation, and/or
linting commands to verify structural soundness. Use the commands from
`.memory/style_guide.md`.

### Step 3: Verify

Run the verification steps listed in the phase definition. Each step
must pass.

**3-Strike Rule:** If any verification step (test, build, lint) fails
3 consecutive times:

1. STOP writing code.
2. Mark the phase status as **Failed** in the execution plan.
3. Document the error in the phase's Completion Record:
   - The exact error output
   - What you tried (all 3 attempts)
   - Your assessment of root cause
4. Wait for architect intervention.

Do NOT attempt a 4th fix. Do NOT move to another phase.

### Step 4: Self-Audit

Walk through every item in the phase's Self-Audit Checklist. For each
item, honestly evaluate pass or fail.

If ANY self-audit item fails:

- Do NOT check the box.
- Attempt to fix the issue IF the fix is within the phase's target
  files and does not change the plan.
- If the fix requires touching files outside the target list or
  changing the approach, STOP and report as a divergence (see Step 5).

After all items pass, check each box.

### Step 5: Divergence Detection

During any step above, if any of these conditions arise:

- A target file requires changes NOT described in the plan
- The implementation contradicts a decision in
  `architecture_decisions.md`
- A dependency or assumption from a prior phase is wrong
- The phase cannot complete without modifying files outside its target
  list
- Verification failures suggest a systemic issue, not a local bug
- You realize you've been silently working around something instead of
  implementing the plan as written

Then STOP immediately. Do not attempt to fix the divergence.

Report to the architect:

> **Divergence detected in Phase [N].**
> What happened: [specific description]
> What I expected vs what I found: [gap]
> Root cause assessment: [why this diverged]
> Recommendation: Invoke `pivot-plan` to reassess.

The architect decides: pivot, adjust current phase, or override. Never
self-correct a divergence silently.

### Step 6: Update Execution Plan

In `.memory/execution_plan.md`:

1. Change phase status to **Completed**.
2. Tick all Self-Audit Checklist items.
3. Fill the Completion Record:
   - Implementation notes (what was done)
   - Deviations from plan (even minor ones - be honest)
   - Quirks discovered

### Step 7: Continuous Learning

If you discovered new codebase patterns, tooling quirks, or
conventions during this phase, append them to `.memory/style_guide.md`
under "Learned Quirks."

Respect the 200-line cap. If at the limit, consolidate before
appending.

### Step 8: Stage & Yield

Stage ONLY the target files listed in the phase definition using
explicit file paths (not `git add .` or equivalent blanket staging).

If you created files not in the target list (e.g., test files), list
them explicitly and ask the architect whether to stage them.

Then STOP. Present a brief completion report:

```
Phase [N]: [Name] - COMPLETED
Files staged: [list]
Tests: [pass count / fail count / skipped]
Quirks learned: [count, or "none"]
Next phase: [N+1 name, or "all phases complete"]
```

Wait for architect review. Commit only if the architect asks.
