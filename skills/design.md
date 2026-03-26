---
name: design
description: Translates requirements into a concrete technical design with test strategy and architect approval gates. Use after requirements are defined and before planning phases.
metadata:
  short-description: Draft technical design
---

# Skill: design

## Tone

Be extremely concise. Lead with the design decision or trade-off.

## Purpose

Translate requirements into a concrete technical design with a chosen
test strategy. Iterate until the architect explicitly approves.

## Inputs

- `.state/requirements.md`
- `.state/conventions.md`

## Outputs

- `.state/architecture_decisions.md`

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current state, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.

## Process

### Step 1: Internalize

Missing `requirements.md` → STOP, invoke `scope`.
Missing `conventions.md` → STOP, invoke `init`.

Read both silently. Identify every Definition of Done item — each
must trace to an architectural component by the end of this skill.

### Step 2: Draft Architecture

Cover:

- **Overview:** One-paragraph summary.
- **Module Breakdown:** Components, responsibilities, new or modified.
- **Data Flow:** How data moves for the primary use case.
- **File Targets:** Every file to create, modify, or delete.
- **External Touchpoints:** Boundaries crossed. If none: "All
  changes internal."
- **Risks & Open Questions.**

### Step 3: Traceability Check

Before presenting, verify every DoD item maps to at least one
component or file target. Present a brief mapping:

```
DoD -> Architecture
"User can reset password" -> PasswordResetService + reset endpoint
"All inputs validated" -> ValidationMiddleware (new)
```

For small features (≤3 DoD items), inline mapping. For larger
features, group by module.

### Step 4: Evaluate Test Infrastructure

Scan the codebase for test directories, frameworks, coverage config,
CI test steps. Present findings, then offer:

- **TS1** — Build a new test harness (no tests exist or inadequate)
- **TS2** — Extend existing tests (framework covers relevant areas)
- **TS3** — Skip testing (rely on build/lint/dry-runs — valid for
  infra, config-only, or architect's decision)

Recommend one with rationale. Wait for the architect's choice.

### Step 5: Iterate

Present full draft (architecture + test strategy). Debate. Revise.

**Completeness Rule:** Interview relentlessly until shared
understanding. Provide recommended answers. Explore instead of
asking when possible.

### Step 6: Approval Gate

**HARD GATE:** Do NOT write `architecture_decisions.md` until the
architect explicitly approves ("approved," "looks good," "go ahead").
One round of feedback is not approval. If unsure, ask.

### Step 7: Write Architecture Decisions

After explicit approval, write `.state/architecture_decisions.md`:

```markdown
# Architecture: [Feature Name]

## Overview
[One-paragraph summary]

## Module Breakdown
| Module/Component | Responsibility | New or Modified |
|-----------------|----------------|-----------------|

## Data Flow
[Numbered steps or diagram]

## File Targets
| File Path | Action | Description |
|-----------|--------|-------------|

## External Touchpoints
[Boundaries, or "All changes internal."]

## DoD Traceability
| Requirement (DoD) | Architectural Component |
|--------------------|----------------------|

## Test Strategy
- Chosen: [new harness | extend existing | no testing]
- Rationale: [based on codebase scan]
- Verification: [what gets tested/checked and how]

## Risks & Open Questions
[Unknowns with mitigations]
```
