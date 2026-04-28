---
name: init
description: Enters a repository, establishes or resumes local .state/, analyzes project conventions, and writes conventions.md. Use when starting work in a new repository or resuming a workspace that uses the Architect-Typist workflow.
metadata:
  short-description: Initialize workspace
---

# Skill: init

## Tone Directive

Be extremely concise. Lead with the answer or action, not the reasoning.
This directive carries forward through all `.state/` files and every
downstream skill.

## Purpose

Enter a repository. Establish or resume `.state/`. Analyze codebase
topography and document conventions.

## Inputs

None.

## Outputs

- `.state/` directory with selective `.gitignore`
- `.state/conventions.md`
- Optional `.state/resume.md` update when a handoff is needed

## Outcome Contract

Complete when the repo has a usable `.state/` baseline and
`.state/conventions.md`, or when existing baseline state has been
confirmed as the current starting point.

Stop before analysis or writes when Git state needs an architect
decision.

## Git Sync Rule

Before any repository analysis or `.state/` writes:

1. Check current branch and worktree state.
2. Git shows an in-progress operation (merge, rebase, cherry-pick) →
   do NOT fetch or pull. Warn and STOP until architect answers.
3. Worktree is dirty → do NOT pull. Warn, ask whether to continue
   from local state or clean up first, and STOP until architect answers.
4. Run `git fetch --prune`.
5. Branch is diverged → do NOT pull. Warn and STOP.
6. Worktree clean and not diverged → run `git pull --ff-only`.
   Fast-forward not possible → treat as divergence. Warn and STOP.

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current state, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.

## Process

### Step 1: Sync

Apply the Git Sync Rule. Stop if sync cannot complete safely.

### Step 2: Detect State

**`.state/` does NOT exist (fresh start):**

1. Create `.state/`.
2. Add `.gitignore`:
   ```
   .state/*
   !.state/conventions.md
   !.state/maintain/
   !.state/maintain/**
   ```
3. Proceed to Step 3.

**`.state/` exists:**

1. Read `conventions.md` if present.
2. `conventions.md` missing → inconsistent state. Rebuild from fresh
   analysis. Ignore `.state/archive/`.
3. Report what active files exist and their implied state:
   - `execution_plan.md` → report phase progress, suggest `execute`
     or `pivot`.
   - `architecture_decisions.md` only → suggest `plan`.
   - `requirements.md` only → suggest `design`.
   - `conventions.md` only → clean workspace, suggest `scope`.
4. Ask how to proceed. Do not assume.

### Step 3: Analyze Topography

Explore the codebase to determine:

- Structural paradigm (monorepo, multi-module, standalone)
- Primary languages and versions
- Build systems and package managers
- Test frameworks and coverage tools
- Linting and formatting tools
- CI/CD configuration

Skip files over 100KB.

### Step 4: Interview

Ask targeted questions about ambiguous patterns. Explore the codebase
instead of asking when possible. Scale to complexity: 2-3 questions
for simple repos, more for large monorepos.

### Step 5: Write Conventions

Write `.state/conventions.md`:

```markdown
# Conventions

- **Tone:** Be extremely concise. Lead with answers, not reasoning.

## Project Topography

## Naming Conventions

## Patterns & Idioms

## Tooling & Commands

## Field Notes
```

**200-line cap.** Consolidate rather than append when near the limit.
Fill every section. Ask before leaving any section empty.
