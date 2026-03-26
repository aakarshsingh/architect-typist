---
name: pivot
description: Replans work when requirements, architecture, or completed phases change, generating amend phases and redesigning remaining phases. Use when execution diverges or scope changes.
metadata:
  short-description: Replan after changes
---

# Skill: pivot

## Tone

Be extremely concise. Lead with the impact assessment or blocker.

## Purpose

Replan mid-flight when direction needs to change. Produces amend
phases for completed work and redesigns remaining phases. Can also
revise the plan pre-execution.

## Inputs

- `.state/conventions.md`
- `.state/requirements.md`
- `.state/architecture_decisions.md`
- `.state/execution_plan.md`

## Outputs

- Updated `.state/requirements.md` (if scope changed)
- Updated `.state/architecture_decisions.md` (if arch changed)
- Updated `.state/execution_plan.md` (amend + redesigned phases)

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current state, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.

## Process

### Step 1: Understand the Pivot

Missing state file → STOP, report which (same pattern as `execute`).

Ask the architect:

> What changed?
> 1. Requirements changed (scope shift)
> 2. Architecture is wrong (technical pivot)
> 3. Completed phase has a defect (needs amendment)
> 4. External constraint discovered
> 5. Other

Interview relentlessly. Provide recommended answers. Explore instead
of asking when possible.

**Deep pivot check:** If >50% of completed phases need amendment,
test strategy must change entirely, or a new module/service is
introduced — recommend restarting from `design`. The architect
decides.

### Step 2: Impact Assessment

Classify every phase:

| Phase | Status | Impact |
|-------|--------|--------|
| 1     | Completed | Needs amend / No change |
| 2     | Pending   | Redesign / Drop / No change |

Present. Wait for confirmation.

### Step 3: Update Requirements (if scope changed)

Read current `requirements.md`. Update affected sections. Mark
changes with `[AMENDED]`. Present for approval before proceeding.

### Step 4: Update Architecture (if needed)

Read current `architecture_decisions.md`. Update affected sections
with `[AMENDED]`. Preserve originals as strikethrough. Update
touchpoints, test strategy, DoD traceability as needed. Present
for approval.

### Step 5: Generate Amend Phases

**Pre-execution pivot (no completed phases):** Skip to Step 6.

**Mid-execution:** For each completed phase needing amendment:

```markdown
### Phase [N]A: Amend - [Original Phase Name]

**Status:** Pending
**Reason:** [What changed and why]

**Target Files:**
- [files to modify]

**Changes:**
- [Specific changes]

**Verification:**
- [ ] [How to verify]

**Definition of Done:**
- [ ] [Criteria]

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
- [ ] Amendment doesn't break other completed phases

**Completion Record:**
_(Filled after verification)_
```

### Step 6: Redesign Remaining Phases

Rewrite affected pending phases from scratch. Drop phases no longer
needed. Add new phases for new work.

Pre-execution pivot → rewrite entire phase list.

### Step 7: Resequence

New execution order:
1. Completed phases (unchanged)
2. Amend phases (1A, 2A...) in original order
3. Redesigned/new phases in dependency order

Update the Phase Summary table.

If the pivot introduces new technology or patterns, flag that
`conventions.md` may need updating.

### Step 8: Architect Approval

Present the full updated plan. Highlight additions, changes, drops,
and new total phase count.

Do NOT proceed to execution. The architect reviews, approves, then
invokes `execute`.
