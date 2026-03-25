# Skill: init-workspace

## Purpose

Enter a repository. Establish or resume the local state environment.
Analyze codebase topography and document conventions.

## Tone Directive

In all interactions from this point forward, be extremely concise.
Sacrifice grammar for brevity when needed. Lead with the answer or
action, not the reasoning.

This directive is set once here and carries forward through all
`.memory/` state. Every other skill in this workflow adopts this tone
when it reads the style guide. To reinforce this, `style_guide.md`
includes a Tone section at the top.

## Inputs

None.

## Outputs

- `.memory/` directory with selective `.gitignore`
- `.memory/style_guide.md` (created or read)

## Process

### Step 1: Detect State

Check if `.memory/` directory exists at the repository root.

**If `.memory/` does NOT exist (fresh start):**

1. Create `.memory/` directory.
2. Add to `.gitignore`:
   ```
   .memory/*
   !.memory/style_guide.md
   ```
3. Proceed to Step 2 (full analysis).

**If `.memory/` exists:**

1. Read `.memory/style_guide.md`.
2. Ignore `.memory/archive/` entirely - never read or reference
   archived files.
3. Check for other active files:
   - If `execution_plan.md` exists, check its Phase Summary.
     Report to the architect:
     > Resuming. Found in-progress work:
     > - execution_plan.md: [N] phases completed, [M] pending.
     > - Next action: invoke `exec-phase` to continue, or
     >   `pivot-plan` if direction changed.
   - If `architecture_decisions.md` exists but no `execution_plan.md`:
     > Found architecture decisions but no execution plan.
     > Next action: invoke `plan-phases`.
   - If `requirements.md` exists but no `architecture_decisions.md`:
     > Found requirements from a prior session but no design.
     > Next action: invoke `draft-design`.
   - If only `style_guide.md` exists:
     > Clean workspace with existing style guide. Ready for
     > `scope-work`.
4. Ask the architect how to proceed. Do not assume.

### Step 2: Analyze Topography (fresh start only)

Explore the codebase to determine:

- Structural paradigm (monorepo, multi-module, standalone)
- Primary languages and their versions
- Build systems and package managers
- Test frameworks and coverage tools
- Linting and formatting tools
- CI/CD configuration if visible

### Step 3: Interview

Ask the architect clarifying questions about any ambiguous patterns
or tooling choices discovered. If a question can be answered by
exploring the codebase, explore instead of asking.

Scale questions to repository complexity. A small single-language
project needs 2-3 questions. A large monorepo may need 10+.

### Step 4: Write Style Guide

Write findings to `.memory/style_guide.md` using this structure:

- **Tone:** Be extremely concise. Sacrifice grammar for brevity.
  Lead with answers, not reasoning.
- **Project Topography**
- **Naming Conventions**
- **Patterns & Idioms**
- **Tooling & Commands**
- **Learned Quirks**

**Style Guide Limit:** Must not exceed 200 lines. Consolidate rather
than append when near the cap.

**Completeness Rule:** Attempt to fill every section. For sections
where information is missing or ambiguous, ask the architect targeted
questions before writing. Do not leave sections empty without asking
first.
