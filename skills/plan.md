---
name: plan
description: Turns approved architecture into a phased execution blueprint with explicit target files, verification steps, and self-audit rules. Use after design approval to prepare implementation.
metadata:
  short-description: Create execution plan
  slot: p4
---

# Skill: plan

## Tone

Be extremely concise. Lead with the phase structure or sizing concern.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Translate approved architecture into a strict, self-documenting
execution plan of phased vertical slices.

## Inputs

- `.state/requirements.md`
- `.state/architecture_decisions.md`
- `.state/conventions.md`

## Outputs

- `.state/execution_plan.md`
- Optional `.state/resume.md` update when a handoff is needed

## Outcome Contract

Complete when `execution_plan.md` has sequenced phases, explicit
target files, verification steps, Definition of Done mapping,
self-audit checklists, and `Plan Status: Approved`.

Requirements, design, and conventions are controlling inputs. Stop
when a phase can't be made independently verifiable without changing
the approved design.

## Hard Rules

- No code changes.
- Write the plan as `Draft`. Set `Approved` only after explicit
  architect approval. `execute` refuses a Draft plan.
- Every verification step is a runnable command or a concrete
  manual check, each with an expected outcome. `execute` must be
  able to prove each phase.
- Design needs to change → STOP and recommend `pivot`.
- User instructions override this skill.

## Question Rule

Check the code and `.state/` before asking. Ask only what changes the
output. At most 4 questions per turn, each with a recommended answer.
Stop asking when the remaining unknowns wouldn't change the result.
Record them as open questions instead.

## Resume Rule

Session ending before the outcome is complete → write
`.state/resume.md` with: current skill, current state, next action,
read-first files, and a resume prompt. Echo the prompt in the reply.

## Process

### Step 1: Internalize

Missing state → STOP and recommend:
- `conventions.md` → `init`
- `requirements.md` → `scope`
- `architecture_decisions.md` → `design`

Read all three silently.

### Step 2: Determine Phase 0

Test strategy is "new harness" or "extend existing" → Phase 0 is test
infrastructure setup. No feature code until tests can run, because
later phases verify through them.

Test strategy "no testing" → skip Phase 0.

### Step 3: Decompose into Phases

Break the architecture into sequential vertical slices. Each phase:

- Is independently verifiable
- Touches an explicit, focused set of files
- Has a clear Definition of Done

Sizing:
- 1-5 target files per phase is ideal
- 8+ files → split it
- Unsure → split. Small phases bound the blast radius of a mistake.

Order by dependency, foundational layers first.

The architect may approve larger phases, such as mechanical renames.
Flag the risk and respect the decision.

### Step 4: Write Draft Plan

Write `.state/execution_plan.md`:

```markdown
# Execution Plan: [Feature Name]

**Plan Status:** Draft

## Objective
One-sentence goal.

## Current Baseline
State of codebase before changes.

## Rules
- One phase active at a time. Wait for architect approval.
- Maintain style per `.state/conventions.md`.
- No changes to public APIs, CLIs, schemas, or user-facing behavior
  beyond what this plan lists.
- 3-Strike Rule: 3 consecutive test/build/lint failures → STOP,
  document the error, wait for architect.
- Commit only when the architect asks. Stage with explicit paths.

## Phase Summary
| Phase | Name | Status |
|-------|------|--------|
| 0     | [Test Setup, if applicable] | Pending |
| 1     | ...  | Pending |

## Phase Details

### Phase [N]: [Name]

**Status:** Pending

**Target Files:**
- [path]: create | modify | delete

**Changes:**
- [Specific, implementable instruction]

**Verification:**
- [ ] `[command]` → [expected outcome]
- [ ] Manual: [action] → [expected outcome]

**Definition of Done:**
- [ ] [Criterion]

**Self-Audit Checklist:**
- [ ] Only target files touched
- [ ] No public-facing changes beyond the plan
- [ ] Matches conventions.md
- [ ] No hardcoded secrets or tokens
- [ ] No sensitive data in logs or errors
- [ ] External input validated at boundaries
- [ ] Error handling present where needed
- [ ] No unjustified new dependencies
- [ ] [Testing approved] All tests pass
- [ ] [Testing skipped] Build/lint passes clean
- [ ] Changes are minimum necessary

**Completion Record:**
_Filled after verification._
- Implementation notes:
- Self-audit evidence:
- Deviations from plan:
- Field notes:
```

Status values: Pending, Active, Completed, Failed.

### Step 5: Architect Review

Present the plan. The architect may adjust boundaries, reorder,
merge, or split. Revise until approved. Apply the Question Rule to
ambiguous decomposition.

On explicit approval, set `**Plan Status:** Approved`.

STOP and recommend `execute` in a fresh session.
