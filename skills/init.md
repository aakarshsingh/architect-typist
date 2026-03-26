---
name: init
description: Enters a repository, establishes or resumes local .state/, analyzes project conventions, and writes conventions.md. Use when starting work in a new repo or resuming workspace.
metadata:
  short-description: Initialize workspace
---

# Skill: init

## Tone

Be extremely concise. Lead with the answer or action. This directive
carries forward through all `.state/` files and every downstream skill.

## Purpose

Enter a repository. Establish or resume `.state/`. Analyze codebase
topography and document conventions.

## Inputs

None.

## Outputs

- `.state/` directory with selective `.gitignore`
- `.state/conventions.md`

## Git Sync Rule

Before any repo analysis or `.state/` writes:

1. Check current branch and worktree state.
2. Worktree clean → `git pull`.
3. Worktree dirty → do NOT pull. Warn the architect, STOP until
   they answer.

If `git pull` fails, report the reason and STOP.

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current state, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.

## Process

### Step 1: Sync

Apply the Git Sync Rule.

### Step 2: Detect State

Check if `.state/` exists at the repo root.

**Fresh start (no `.state/`):**

1. Create `.state/`.
2. Add `.gitignore`:
   ```
   .state/*
   !.state/conventions.md
   !.state/maintain/
   !.state/maintain/**
   ```
3. Proceed to Step 3.

**Resuming (`.state/` exists):**

1. If `conventions.md` exists, read it.
2. If `conventions.md` is missing, report inconsistent state and
   rebuild from fresh analysis.
3. Check for active state and report:
   - `execution_plan.md` exists → report phase progress, suggest
     `execute` or `pivot`.
   - `architecture_decisions.md` only → suggest `plan`.
   - `requirements.md` only → suggest `design`.
   - `conventions.md` only → clean workspace, ready for `scope`.
4. Ask the architect how to proceed. Do not assume.

### Step 3: Analyze Topography

Scan the codebase for:

- Structure (monorepo, multi-module, standalone)
- Languages and versions
- Build systems and package managers
- Test frameworks and coverage
- Linting and formatting
- CI/CD configuration

### Step 4: Interview

Ask targeted questions about ambiguous patterns. Explore the codebase
instead of asking when possible. Scale to complexity: 2-3 questions
for simple repos, more for large monorepos.

### Step 5: Write Conventions

Write `.state/conventions.md`:

- **Tone:** Be extremely concise. Lead with answers, not reasoning.
- **Project Topography**
- **Naming Conventions**
- **Patterns & Idioms**
- **Tooling & Commands**
- **Field Notes**

**200-line cap.** Consolidate rather than append near the limit.

Fill every section. Ask before leaving any section empty.
