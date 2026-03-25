# Skill: pivot-plan

## Purpose

Replan mid-flight when the architect determines the current direction
needs to change. Produces amend phases for completed work and
redesigns remaining phases.

Can also be invoked pre-execution (during planning review) to revise
before any phases run.

## Inputs

- `.memory/style_guide.md`
- `.memory/requirements.md`
- `.memory/architecture_decisions.md`
- `.memory/execution_plan.md`

## Outputs

- Updated `.memory/requirements.md` (if scope changed)
- Updated `.memory/architecture_decisions.md` (if arch changed)
- Updated `.memory/execution_plan.md` (amend + redesigned phases)

## Process

### Step 1: Understand the Pivot

Ask the architect:

> What changed?
> 1. Requirements changed (scope shift)
> 2. Architecture is wrong (technical pivot)
> 3. Completed phase has a defect (needs amendment)
> 4. External constraint discovered (dependency, blocker)
> 5. Other (describe)

Interview relentlessly to understand the full scope of the change. For
each question, provide your recommended answer. If a question can be
answered by exploring the codebase, explore instead.

**Deep pivot check:** If the discussion reveals that the fundamental
approach is wrong - not just specific phases but the core
architecture - recommend re-running `draft-design` from scratch
instead of patching via pivot-plan. Indicators:

- More than half the completed phases need amendment
- The test strategy needs to change entirely
- A new module or service is being introduced that wasn't in the
  original architecture
- The architect says something like "we need to rethink this"

Present the recommendation. The architect decides whether to pivot
in-place or restart from `draft-design`.

### Step 2: Impact Assessment

Read the current execution plan. Classify every phase:

| Phase | Status | Impact |
|-------|--------|--------|
| 1     | Completed | Needs amend / No change |
| 2     | Completed | Needs amend / No change |
| 3     | Pending   | Redesign / Drop / No change |

Present to the architect. Wait for confirmation.

### Step 3: Update Requirements (if scope changed)

If the pivot is option 1 (scope shift) or if the discussion reveals
scope changes:

1. Read current `.memory/requirements.md`.
2. Update affected sections: Purpose, Definition of Done, Constraints,
   Decisions & Options.
3. Mark changed items with `[AMENDED]` prefix for traceability.
4. Present updated requirements to the architect for approval before
   proceeding.

### Step 4: Update Architecture (if needed)

If the pivot affects the architecture (options 1, 2, or 4):

1. Read current `.memory/architecture_decisions.md`.
2. Update affected sections. Mark changes with `[AMENDED]`.
3. Preserve original text as strikethrough for traceability.
4. Update External Touchpoints if boundaries changed.
5. Update Test Strategy if verification approach changed.
6. Update DoD Traceability if requirements changed.
7. Present to architect for approval.

### Step 5: Generate Amend Phases (if completed work needs fixing)

**Pre-execution pivot (no completed phases):** Skip this step
entirely. Go to Step 6 to redesign all phases.

**Mid-execution pivot:** For each completed phase that needs
amendment, create an amend phase:

```markdown
### Phase [N]A: Amend - [Original Phase Name]

**Status:** Pending
**Reason for Amendment:** [What changed and why]

**Target Files:**
- [files that need modification]

**Changes to Make:**
- [Specific changes to fix/update completed work]

**Verification Steps:**
- [ ] [How to verify the amendment]

**Definition of Done:**
- [ ] [Criteria]

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
- [ ] Changes are the minimum necessary
- [ ] Amendment does not break other completed phases

**Completion Record:**
_(Filled after verification)_
```

### Step 6: Redesign Remaining Phases

For pending phases affected by the pivot:

- Rewrite from scratch based on updated architecture.
- Drop phases no longer needed.
- Add new phases if the pivot introduces new work.

**Pre-execution pivot:** Rewrite the entire phase list.

Each phase follows the same structure as the original plan.

### Step 7: Resequence & Style Guide Check

Assemble the new execution order:

1. Completed phases needing NO amendment (unchanged)
2. Amend phases (1A, 2A...) in original phase order
3. Redesigned / new pending phases in dependency order

Update the Phase Summary table.

**Style guide check:** If the pivot introduces new technology,
patterns, or tools, note that `.memory/style_guide.md` may need
updating. The next `exec-phase` invocation will handle this via
Continuous Learning, but flag significant changes to the architect now.

### Step 8: Architect Approval

Present the full updated plan. Highlight:

- What was added (amend phases, new phases)
- What was changed (redesigned phases)
- What was dropped
- New total phase count

Do NOT proceed to execution. The architect reviews, approves, then
invokes `exec-phase`.
