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
