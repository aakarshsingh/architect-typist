---
name: pivot
description: Replans work when requirements, architecture, or completed phases change, generating amend phases and redesigning remaining phases. Use when execution diverges or scope changes mid-flight.
metadata:
  short-description: Replan after changes
  slot: p7
---

# Skill: pivot

## Tone

Be extremely concise. Lead with the impact assessment or blocker.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Replan when direction needs to change. Produce amend phases for
completed work and redesign remaining phases. Also revises a plan
before execution starts.

## Inputs

- `.state/conventions.md`
- `.state/requirements.md`
- `.state/architecture_decisions.md`
- `.state/execution_plan.md`

## Outputs

- Updated `.state/requirements.md` if scope changed
- Updated `.state/architecture_decisions.md` if architecture changed
- Updated `.state/execution_plan.md`: amend and redesigned phases
- Optional `.state/resume.md` update when a handoff is needed

## Outcome Contract

Complete when the change is translated into approved planning state:
amended completed phases where needed, redesigned remaining phases,
and `Plan Status: Approved`.

Current state stays authoritative until the architect approves the
pivot. Stop when the change is deep enough that restarting from
`design` is safer.

## Hard Rules

- No code changes. `execute` implements amend phases.
- Set `Plan Status: Draft` while pivoting so `execute` can't run a
  half-revised plan. Set `Approved` only after explicit approval.
- Never edit Completion Records of completed phases. They are the
  history amend phases build on.
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

### Step 1: Understand the Pivot

Missing state → STOP and recommend:
- `conventions.md` → `init`
- `requirements.md` → `scope`
- `architecture_decisions.md` → `design`
- `execution_plan.md` → `plan`

A divergence report in the conversation or `resume.md` usually
answers what changed. Otherwise ask:

> What changed?
> 1. Requirements changed: scope shift
> 2. Architecture is wrong: technical pivot
> 3. Completed phase has a defect: needs amendment
> 4. External constraint discovered
> 5. Other

Apply the Question Rule.

**Deep pivot check:** more than half of completed phases need
amendment, the test strategy must change entirely, or a new module or
service is introduced → recommend restarting from `design`. The
architect decides.

Set `**Plan Status:** Draft`.

### Step 2: Impact Assessment

Classify every phase:

| Phase | Status | Impact |
|-------|--------|--------|
| 1 | Completed | Needs amend / No change |
| 2 | Pending | Redesign / Drop / No change |

Present. Wait for confirmation.

### Step 3: Update Requirements

Only if scope changed. Update affected sections of `requirements.md`
and mark them `[AMENDED]`. Present for approval before continuing.

### Step 4: Update Architecture

Only if needed. Update affected sections of
`architecture_decisions.md` with `[AMENDED]`. Keep originals as
strikethrough. Update touchpoints, test strategy, and DoD traceability
to match. Present for approval.

### Step 5: Generate Amend Phases

No completed phases → skip to Step 6.

For each completed phase needing amendment, add:

```markdown
### Phase [N]A: Amend - [Original Phase Name]

**Status:** Pending
**Reason:** [What changed and why]

**Target Files:**
- [path]: modify

**Changes:**
- [Specific changes]

**Verification:**
- [ ] `[command]` → [expected outcome]
- [ ] Manual: [action] → [expected outcome]

**Definition of Done:**
- [ ] [Criterion]

**Self-Audit Checklist:**
[Copy the checklist used by the plan's other phases, then add:]
- [ ] Amendment doesn't break other completed phases

**Completion Record:**
_Filled after verification._
```

Copying from the live plan keeps the checklist identical across
phases.

### Step 6: Redesign Remaining Phases

Rewrite affected pending phases. Drop phases no longer needed. Add
phases for new work. Follow `plan` sizing: 1-5 target files, split at
8+.

Pre-execution pivot → rewrite the entire phase list.

### Step 7: Resequence

New order:
1. Completed phases, unchanged
2. Amend phases such as 1A and 2A, in original order
3. Redesigned and new phases in dependency order

Update the Phase Summary table.

New technology or patterns introduced → flag that `conventions.md` may
need updating.

### Step 8: Architect Approval

Present the full updated plan. Highlight additions, changes, drops,
and the new phase count.

On explicit approval, set `**Plan Status:** Approved`.

STOP and recommend `execute` in a fresh session.
