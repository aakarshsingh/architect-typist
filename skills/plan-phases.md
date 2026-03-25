# Skill: plan-phases

## Purpose

Translate the approved architecture into a strict, self-documenting
execution plan with phased vertical slices.

## Inputs

- `.memory/requirements.md`
- `.memory/architecture_decisions.md`
- `.memory/style_guide.md`

## Outputs

- `.memory/execution_plan.md`

## Process

### Step 1: Internalize

Read all three input files silently. Understand:

- What we're building (requirements)
- How we're building it (architecture)
- How the codebase works (style guide)

### Step 2: Determine Phase 0

**Hard rule:** If the test strategy is "build new harness" or "extend
existing tests," the FIRST phase (Phase 0) MUST be the test
infrastructure setup. No feature code until tests can run.

If the test strategy is "no testing," skip Phase 0 and start with
feature phases.

### Step 3: Decompose into Phases

Break the architecture into sequential vertical slices. Each phase
must:

- Be independently verifiable (tests pass, or build/lint passes after
  the phase, not just at the end)
- Touch a focused set of files (listed explicitly)
- Have a clear Definition of Done

**Phase sizing:** Each phase should be completable in a single agent
session. Rules of thumb:

- 1-5 target files per phase is ideal
- If a phase touches 8+ files or requires complex cross-cutting logic,
  split it
- Prefer many small phases over few large ones - the overhead of phase
  boundaries is cheap; recovering from a context-death mid-phase is
  expensive
- When in doubt, split

These are guidelines, not hard limits. If the architect approves a
larger phase (e.g., a mechanical rename across 12 files), that's valid.
Flag the risk, respect the decision.

Order phases by dependency: foundational layers first, then consuming
layers. Each phase should be buildable on top of what prior phases
produced.

### Step 4: Generate Execution Plan

Write `.memory/execution_plan.md`:

```markdown
# Execution Plan: [Feature Name]

## Objective
One-sentence goal from requirements.

## Current Baseline
State of the codebase before changes. Key files, existing behavior,
relevant recent state.

## Rules
- Only one phase active at a time. Wait for architect approval to
  proceed.
- Maintain repository style per `.memory/style_guide.md`.
- NO public-facing changes unless explicitly approved.
- 3-Strike Rule: If tests, builds, or linting fail 3 consecutive
  times, STOP. Document the error in the phase's Completion Record
  and wait for architect intervention.
- Commit Policy: Do NOT commit unless the architect explicitly asks.
  Stage target files when a phase is verified complete. Use explicit
  file paths, not blanket staging.
- Context Check: Before starting a phase, assess whether it fits in
  a single session. If too large or context is running low, recommend
  splitting to the architect.

## Phase Summary
| Phase | Name | Status |
|-------|------|--------|
| 0     | [Test Setup - if applicable] | Pending |
| 1     | ...  | Pending |

## Phase Details

### Phase [N]: [Name]

**Status:** Pending

**Target Files:**
- [path/to/file - create | modify | delete]

**Changes to Make:**
- [Specific, implementable instruction]

**Verification Steps:**
- [ ] [Build/test/lint command and expected outcome]

**Definition of Done:**
- [ ] [Criterion proving phase is complete]

**Self-Audit Checklist:**
- [ ] Only target files were touched
- [ ] No public-facing changes without approval
- [ ] Code matches style_guide.md conventions
- [ ] No hardcoded secrets, credentials, or tokens
- [ ] No sensitive data logged or exposed in errors
- [ ] User/external input validated at boundaries
- [ ] Error handling present where needed
- [ ] No new dependencies without justification
- [ ] [If testing approved] All tests pass
- [ ] [If testing skipped] Build/lint/compile passes clean
- [ ] Changes are the minimum necessary for this phase

**Completion Record:**
_(Filled by agent after verification)_
- Implementation notes:
- Deviations from plan:
- Quirks discovered:
```

### Step 5: Architect Review

Present the execution plan. The architect may adjust phase boundaries,
reorder, merge, or split phases. Revise until approved.

**Completeness Rule:** Interview the architect about any ambiguous
decomposition decisions. For each question, provide your recommended
answer. If a question can be answered by exploring the codebase,
explore instead.
