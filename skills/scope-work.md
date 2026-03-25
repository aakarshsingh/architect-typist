# Skill: scope-work

## Purpose

Debate and define feature boundaries. Produce a structured requirements
document with a shared understanding between architect and agent.

## Bypass

For trivial tasks (single-file fix, config change, small refactor),
the architect may hand-write `.memory/requirements.md` directly and
skip this skill. The only requirement is that the file follows the
template structure so downstream skills can parse it.

## Inputs

- `.memory/style_guide.md` (if exists - for codebase context)
- Architect's feature idea (provided in conversation)

## Outputs

- `.memory/requirements.md`

## Process

### Step 1: Understand Context

If `.memory/style_guide.md` exists, read it silently. Use the codebase
context to inform your questions - don't ask about things the style
guide already answers.

### Step 2: Debate Scope

The architect provides a feature idea. Interview the architect to
resolve:

- Dependencies on existing code or external systems
- Edge cases and boundary conditions
- What is explicitly OUT of scope
- Definition of done (concrete, verifiable criteria)

**Completeness Rule:** Interview the architect relentlessly about every
aspect of the requirements until a shared understanding is reached.
Walk down each branch of the decision tree (where applicable),
resolving dependencies between decisions one-by-one. For each question,
provide your recommended answer. If a question can be answered by
exploring the codebase, explore the codebase instead of asking.

**Scale to complexity.** Match interview depth to task size. A
single-file refactor needs 3-5 targeted questions. A multi-module
feature needs thorough branch-by-branch exploration. Read the
architect's signals - if they say "this is straightforward," trust
that and keep it brief. Don't over-interview simple tasks.

### Step 3: Write Requirements

Once the architect confirms alignment, write `.memory/requirements.md`
using this structure:

```markdown
# Requirements: [Feature Name]

## Purpose
What this feature does and why it exists.

## Definition of Done
- [ ] [Concrete, verifiable criterion]
- [ ] [Another criterion]

## Decisions & Options
| Decision | Chosen Option | Alternatives Considered | Rationale |
|----------|--------------|------------------------|-----------|
| ...      | ...          | ...                    | ...       |

## Constraints
- Must NOT: [explicit boundaries]
- Must: [hard requirements - performance, security, compat]

## References
- [File, doc, ticket, or prior art with brief context]
```

Fill every section. If a section has no content after the discussion,
write "None identified" - do not omit the heading.
