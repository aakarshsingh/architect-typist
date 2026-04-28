---
name: design
description: Translates requirements into a concrete technical design with explicit test strategy and architect approval gates. Use after requirements are defined and before planning implementation phases.
metadata:
  short-description: Draft technical design
---

# Skill: design

## Tone

Be extremely concise. Lead with the design decision or trade-off.

## Purpose

Translate requirements into a concrete technical design with a chosen
test strategy. Iterate with the architect until explicitly approved.

## Inputs

- `.state/requirements.md`
- `.state/conventions.md`

## Outputs

- `.state/architecture_decisions.md`
- Optional `.state/resume.md` update when a handoff is needed

## Outcome Contract

Complete when the design gives the architect an approvable technical
direction: every Definition of Done item is traceable to components,
file targets, data flow, external touchpoints, risks, and a test
strategy.

Preserve the approved requirements and conventions as controlling
inputs. Stop if prerequisite state is missing or if traceability
cannot be closed without an architect decision.

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current state, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.

## Process

### Step 1: Internalize

`requirements.md` missing → STOP, invoke `scope`.
`conventions.md` missing → STOP, invoke `init`.

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

For small features (3 or fewer DoD items), inline the mapping.
For larger features, group by module.

### Step 4: Evaluate Test Infrastructure

Scan the codebase for test directories, frameworks, coverage config,
and CI test steps. Present findings, then offer:

- **TS1** — Build a new test harness (no tests exist or inadequate)
- **TS2** — Extend existing tests (framework covers relevant areas)
- **TS3** — Skip testing (infra/config-only, or architect's decision)

Recommend one with rationale. Wait for the architect's choice.

### Step 5: Iterate

Present the full draft (architecture + test strategy). Debate. Revise.

**Completeness Rule:** Interview relentlessly until shared
understanding exists. Provide recommended answers. Explore instead
of asking when possible.

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
