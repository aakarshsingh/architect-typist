---
name: design
description: Translates requirements into a concrete technical design with explicit test strategy and architect approval gates. Use after requirements are defined and before planning implementation phases.
metadata:
  short-description: Draft technical design
  slot: p3
---

# Skill: design

## Tone

Be extremely concise. Lead with the design decision or trade-off.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

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

Complete when the architect has approved a design in which every
Definition of Done item traces to components, file targets, data
flow, external touchpoints, risks, and a test strategy.

Approved requirements and conventions are controlling inputs. Stop if
traceability can't be closed without an architect decision.

## Hard Rules

- No code changes.
- Write `architecture_decisions.md` only after explicit approval.
  `plan` builds phases from it without re-checking design choices.
- Requirements look wrong → STOP and recommend `pivot` or `scope`.
  Don't redesign around them silently.
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

Read both silently. List every Definition of Done item. Each must
trace to a component by the end of this skill.

### Step 2: Draft Architecture

Read the code the feature touches. Run independent reads in parallel.

Cover:

- **Overview:** One-paragraph summary.
- **Module Breakdown:** Components, responsibilities, new or modified.
- **Data Flow:** How data moves for the primary use case.
- **File Targets:** Every file to create, modify, or delete.
- **External Touchpoints:** Boundaries crossed. None → "All changes
  internal."
- **Risks & Open Questions.**

### Step 3: Traceability Check

Before presenting, map every DoD item to at least one component or
file target:

```
DoD -> Architecture
"User can reset password" -> PasswordResetService + reset endpoint
"All inputs validated" -> ValidationMiddleware (new)
```

3 or fewer DoD items → inline the mapping. More → group by module.

### Step 4: Evaluate Test Infrastructure

Scan for test directories, frameworks, coverage config, and CI test
steps. Delegate the scan to a subagent if your tool supports it.
Present findings, then offer:

- **new harness:** no tests exist, or existing ones can't cover this
- **extend existing:** the framework covers the relevant areas
- **no testing:** infra or config only, or the architect's call

Recommend one with rationale. Wait for the architect's choice. `plan`
reads these exact labels.

### Step 5: Iterate

Present the full draft: architecture plus test strategy. Debate and
revise. Apply the Question Rule.

### Step 6: Approval Gate

Wait for explicit approval such as "approved", "looks good", or "go
ahead". One round of feedback is not approval. Unsure → ask.

### Step 7: Write Architecture Decisions

Write `.state/architecture_decisions.md`:

```markdown
# Architecture: [Feature Name]

## Overview
[One-paragraph summary]

## Module Breakdown
| Module/Component | Responsibility | New or Modified |
|------------------|----------------|-----------------|

## Data Flow
[Numbered steps or diagram]

## File Targets
| File Path | Action | Description |
|-----------|--------|-------------|

## External Touchpoints
[Boundaries, or "All changes internal."]

## DoD Traceability
| Requirement (DoD) | Architectural Component |
|-------------------|-------------------------|

## Test Strategy
- Chosen: [new harness | extend existing | no testing]
- Rationale: [based on codebase scan]
- Verification: [what gets tested or checked, and how]

## Risks & Open Questions
[Unknowns with mitigations]
```

STOP and recommend `plan`.
