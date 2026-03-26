---
name: plan
description: Turns approved architecture into a phased execution blueprint with target files, verification steps, and self-audit rules. Use after design approval to prepare implementation.
metadata:
  short-description: Create execution plan
---

# Skill: plan

## Tone

Be extremely concise. Lead with the phase structure or sizing concern.

## Purpose

Translate approved architecture into a strict, self-documenting
execution plan with phased vertical slices.

## Inputs

- `.state/requirements.md`
- `.state/architecture_decisions.md`
- `.state/conventions.md`

## Outputs

- `.state/execution_plan.md`

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current state, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.

## Process

### Step 1: Internalize

Missing `requirements.md` → STOP, invoke `scope`.
Missing `architecture_decisions.md` → STOP, invoke `design`.
Missing `conventions.md` → STOP, invoke `init`.

Read all three silently.

### Step 2: Determine Phase 0

**Hard rule:** If test strategy is "new harness" or "extend existing,"
Phase 0 MUST be test infrastructure setup. No feature code until
tests can run.

Test strategy "no testing" → skip Phase 0.

### Step 3: Decompose into Phases

Break architecture into sequential vertical slices. Each phase must:

- Be independently verifiable
- Touch a focused set of files (listed explicitly)
- Have a clear Definition of Done

**Sizing:**
- 1-5 target files per phase is ideal
- 8+ files → split it
- Prefer many small phases over few large ones
- When in doubt, split

Order by dependency: foundational layers first. Each phase builds on
prior phases.

The architect may approve larger phases (e.g., mechanical renames).
Flag the risk, respect the decision.

### Step 4: Write Execution Plan

Write `.state/execution_plan.md`:

```markdown
# Execution Plan: [Feature Name]

## Objective
One-sentence goal.

## Current Baseline
State of codebase before changes.

## Rules
- One phase active at a time. Wait for architect approval.
- Maintain style per `.state/conventions.md`.
- No public-facing changes unless approved.
- 3-Strike Rule: 3 consecutive test/build/lint failures → STOP,
  document error, wait for architect.
- Commit only when architect asks. Stage with explicit file paths.
- Before starting a phase, assess session fit. Recommend splitting
  if too large.

## Phase Summary
| Phase | Name | Status |
|-------|------|--------|
| 0     | [Test Setup - if applicable] | Pending |
| 1     | ...  | Pending |

## Phase Details

### Phase [N]: [Name]

**Status:** Pending

**Target Files:**
- [path — create | modify | delete]

**Changes:**
- [Specific, implementable instruction]

**Verification:**
- [ ] [Command and expected outcome]

**Definition of Done:**
- [ ] [Criterion]

**Self-Audit Checklist:**
- [ ] Only target files touched
- [ ] No public-facing changes without approval
- [ ] Matches conventions.md conventions
- [ ] No hardcoded secrets or tokens
- [ ] No sensitive data in logs or errors
- [ ] External input validated at boundaries
- [ ] Error handling present where needed
- [ ] No unjustified new dependencies
- [ ] [Testing approved] All tests pass
- [ ] [Testing skipped] Build/lint passes clean
- [ ] Changes are minimum necessary

**Completion Record:**
_(Filled after verification)_
- Implementation notes:
- Deviations from plan:
- Field notes:
```

### Step 5: Architect Review

Present the plan. The architect may adjust boundaries, reorder,
merge, or split. Revise until approved.

Interview about ambiguous decomposition. Provide recommended answers.
Explore instead of asking when possible.
