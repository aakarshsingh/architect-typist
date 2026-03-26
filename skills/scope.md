---
name: scope
description: Debates and defines feature boundaries, resolves dependencies and edge cases, and writes requirements.md. Use when scoping a new feature, refactor, or non-trivial task.
metadata:
  short-description: Define scope
---

# Skill: scope

## Tone

Be extremely concise. Lead with the question or decision point.

## Purpose

Debate and define feature boundaries. Produce a structured
requirements document with shared understanding.

## Bypass

For trivial tasks (single-file fix, config change, small refactor),
the architect may hand-write `.state/requirements.md` directly. The
file must follow the structure below so downstream skills can parse it.

## Inputs

- `.state/conventions.md` (if exists)
- Architect's feature idea (in conversation)

## Outputs

- `.state/requirements.md`

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current state, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.

## Process

### Step 1: Understand Context

Read `.state/conventions.md` silently if it exists. Use codebase
context to avoid asking questions the conventions file already answers.

### Step 2: Debate Scope

Interview the architect to resolve:

- Dependencies on existing code or external systems
- Edge cases and boundary conditions
- What is explicitly OUT of scope
- Definition of done (concrete, verifiable criteria)

**Completeness Rule:** Interview relentlessly until shared
understanding is reached. Walk each branch of the decision tree,
resolving dependencies one-by-one. Provide your recommended answer
with each question. Explore the codebase instead of asking when
possible.

**Scale to complexity.** A single-file refactor needs 3-5 questions.
A multi-module feature needs thorough exploration. If the architect
says "this is straightforward," trust that.

### Step 3: Write Requirements

After the architect confirms alignment, write `.state/requirements.md`:

```markdown
# Requirements: [Feature Name]

## Purpose
What this feature does and why.

## Definition of Done
- [ ] [Concrete, verifiable criterion]

## Decisions & Options
| Decision | Chosen Option | Alternatives Considered | Rationale |
|----------|--------------|------------------------|-----------|

## Constraints
- Must NOT: [explicit boundaries]
- Must: [hard requirements]

## References
- [File, doc, ticket, or prior art with brief context]
```

Fill every section. Write "None identified" for empty sections — do
not omit headings.
