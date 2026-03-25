# Skill: draft-design

## Purpose

Translate requirements into a concrete technical design with a chosen
test strategy. Iterate with the architect until explicitly approved.

## Inputs

- `.memory/requirements.md`
- `.memory/style_guide.md`

## Outputs

- `.memory/architecture_decisions.md`

## Process

### Step 1: Internalize Requirements

Read `.memory/requirements.md` and `.memory/style_guide.md` silently.
Identify each Definition of Done item - every one must be traceable
to an architectural component by the end of this skill.

### Step 2: Draft Architecture

Draft an architecture document covering:

- **Overview:** One-paragraph summary of the approach.
- **Module Breakdown:** Components, their responsibilities, and whether
  they are new or modified.
- **Data Flow:** How data moves through the system for the primary use
  case.
- **File Targets:** Every file to be created, modified, or deleted.
- **External Touchpoints:** Any boundaries this feature crosses -
  APIs, schemas, configs, shared interfaces. If none: "No external
  touchpoints. All changes internal."
- **Risks & Open Questions:** Unknowns and mitigations.

### Step 3: Traceability Check

Before presenting the draft, verify: does every Definition of Done
item from `requirements.md` have at least one corresponding component,
module, or file target in the architecture? If any DoD item is not
covered, either add the missing architectural component or flag it to
the architect as a gap.

Present the traceability as a brief mapping:

```
DoD → Architecture
"User can reset password" → PasswordResetService + reset endpoint
"All inputs validated" → ValidationFilter (new)
```

For small features (3 or fewer DoD items), this inline mapping is
sufficient. For larger features, group by module rather than listing
every DoD item individually.

### Step 4: Evaluate Test Infrastructure

Actively scan the codebase for existing test infrastructure:

- Look for test directories (test/, tests/, __tests__/, src/test/)
- Identify test frameworks (JUnit, TestNG, pytest, Jest, etc.)
- Check for coverage configuration or reports
- Count existing test files and note their patterns
- Check CI config for test execution steps

Present findings to the architect, then offer three options:

1. **Build a new test harness** - when no tests exist or existing ones
   are inadequate for this feature.
2. **Extend existing tests** - when the current framework covers the
   relevant areas and can be built upon.
3. **Ignore testing** - rely on compilation, linting, and dry-runs for
   backpressure. Valid for infra changes, config-only work, or when
   the architect decides.

Provide your recommendation with rationale based on what you found.
Wait for the architect's choice.

### Step 5: Iterate

Present the full draft (architecture + test strategy) to the architect.
Debate. Revise based on feedback.

**Completeness Rule:** Interview the architect relentlessly about every
aspect of this design until a shared understanding is reached. Walk
down each branch of the decision tree, resolving dependencies
one-by-one. For each question, provide your recommended answer. If a
question can be answered by exploring the codebase, explore instead.

### Step 6: Approval Gate

**HARD GATE: Do NOT write `.memory/architecture_decisions.md` until
the architect explicitly says "approved" or equivalent ("looks good,"
"go ahead," "ship it").** A single round of feedback does not
constitute approval. If unsure, ask: "Are you approving this design,
or do you want another revision?"

### Step 7: Write Architecture Decisions

Only after explicit approval, write to
`.memory/architecture_decisions.md`:

```markdown
# Architecture: [Feature Name]

## Overview
[One-paragraph summary]

## Module Breakdown
| Module/Component | Responsibility | New or Modified |
|-----------------|----------------|-----------------|

## Data Flow
[Numbered steps or ASCII diagram]

## File Targets
| File Path | Action | Description |
|-----------|--------|-------------|

## External Touchpoints
[Boundaries crossed, or "No external touchpoints. All changes internal."]

## DoD Traceability
| Requirement (DoD) | Architectural Component |
|--------------------|----------------------|

## Test Strategy
- Chosen option: [new harness | extend existing | no testing]
- Rationale: [why, based on codebase scan findings]
- Verification approach: [what gets tested/checked and how]

## Risks & Open Questions
[Unknowns with mitigations]
```
