---
name: scope
description: Debates and defines feature boundaries, resolves dependencies and edge cases, and writes requirements.md. Use when scoping a new feature, refactor, or non-trivial task.
metadata:
  short-description: Define scope
  slot: p2
---

# Skill: scope

## Tone

Be extremely concise. Lead with the question or decision point.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Debate and define feature boundaries. Produce a requirements document
that captures shared understanding between architect and agent.

## Bypass

For trivial tasks the architect may hand-write
`.state/requirements.md` and skip this skill. It must follow the
template below so downstream skills can parse it.

## Inputs

- `.state/conventions.md` if it exists
- Architect's feature idea, in conversation
- Optional GitHub issue or `roadmap` item to seed the scope

## Outputs

- `.state/requirements.md`
- Optional `.state/resume.md` update when a handoff is needed

## Outcome Contract

Complete when the architect has approved requirements covering scope,
non-goals, dependencies, edge cases, constraints, and a concrete
Definition of Done, written to `.state/requirements.md`.

The architect's decisions are the source of truth. Stop when
unresolved choices would make the requirements ambiguous.

## Hard Rules

- No code changes.
- Write `requirements.md` only after explicit approval. Downstream
  skills treat it as a contract.
- Every DoD item must be verifiable by a test, command, or
  observable behavior. Vague DoD items can't be checked at `ship`.
  Behavior reads well as "When X, then Y".
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

### Step 1: Understand Context

Read `.state/conventions.md` silently if it exists. Read the code the
feature will touch. Don't ask what the code already answers.

### Step 2: Debate Scope

Resolve, branch by branch:

- Dependencies on existing code or external systems
- Edge cases and boundary conditions
- What is explicitly out of scope
- Definition of Done

Apply the Question Rule. A single-file change needs a few questions.
A multi-module feature needs several rounds.

### Step 3: Approval Gate

Present a short summary of the scope. Wait for explicit approval
such as "approved" or "go ahead". Feedback alone is not approval.

### Step 4: Write Requirements

Write `.state/requirements.md`:

```markdown
# Requirements: [Feature Name]

## Purpose
What this feature does and why.

## Definition of Done
- [ ] [Concrete, verifiable criterion]

## Non-Goals
- [Explicitly out of scope]

## Dependencies
- [Code, service, or decision this relies on]

## Edge Cases
- [Case] → [expected behavior]

## Decisions & Options
| Decision | Chosen Option | Alternatives Considered | Rationale |
|----------|---------------|-------------------------|-----------|

## Constraints
- Must NOT: [explicit boundaries]
- Must: [hard requirements]

## References
- [File, doc, issue, or prior art with brief context]
```

Fill every section. Write "None identified" for empty sections rather
than omitting headings.

STOP and recommend `design`.
