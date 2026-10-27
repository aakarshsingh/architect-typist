---
name: init
description: Enters a repository, establishes or resumes local .state/, analyzes project conventions, and writes conventions.md. Use when starting work in a new repository or resuming a workspace that uses the Architect-Typist workflow.
metadata:
  short-description: Initialize workspace
  slot: p1
---

# Skill: init

## Tone

Be extremely concise. Lead with the answer or action, not the
reasoning. The tone line in `conventions.md` carries this to every
downstream skill.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

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

## Hard Rules

- No code changes. This skill writes only `.state/` and `.gitignore`.
- Existing `.state/` → report and ask before changing anything. It
  may hold work the architect hasn't finished.
- User instructions override this skill.

## Git Sync Rule

Before reading or writing tracked files:

1. Check branch and worktree state.
2. Merge, rebase, or cherry-pick in progress → STOP. Don't fetch or
   pull.
3. Worktree dirty → don't pull. Ask whether to continue from local
   state, then STOP until answered.
4. Run `git fetch --prune`.
5. Branch diverged from upstream → STOP. Don't pull.
6. Otherwise run `git pull --ff-only`. Fast-forward fails → treat as
   divergence and STOP.

Why: pulling over local work or an in-progress operation can lose
changes the architect hasn't reviewed.

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

### Step 1: Sync

Apply the Git Sync Rule.

### Step 2: Detect State

**Fresh start, no `.state/`:**

1. Create `.state/`.
2. Add to `.gitignore`:
   ```
   .state/*
   !.state/conventions.md
   !.state/maintain/
   !.state/maintain/**
   ```
3. Proceed to Step 3.

**`.state/` exists:**

1. Read `resume.md` first if present. It names the owning skill and
   next action.
2. Read `conventions.md`. Missing → inconsistent state. Rebuild it
   from fresh analysis. Ignore `.state/archive/`.
3. Report live files and their implied position:
   - `execution_plan.md` → phase progress. Recommend `execute` or
     `pivot`.
   - `architecture_decisions.md` only → recommend `plan`.
   - `requirements.md` only → recommend `design`.
   - `roadmap.md` → roadmap in progress. Recommend `roadmap`.
   - `maintain/01-intake.md` present → open campaign. Recommend
     `maintain`. Dated subfolders are closed campaigns.
   - `conventions.md` only → clean workspace. Recommend `scope`.
4. Ask how to proceed. STOP.

### Step 3: Analyze Topography

Determine:

- Structural paradigm: monorepo, multi-module, or standalone
- Primary languages and versions
- Build systems and package managers
- Test frameworks and coverage tools
- Linting and formatting tools
- CI/CD configuration

Run independent reads in parallel. Delegate broad scans to a subagent
if your tool supports it. Skip files over 100KB, plus generated,
vendored, and binary files.

### Step 4: Interview

Ask about patterns the code leaves ambiguous. Apply the Question Rule.
Simple repos need 2-3 questions. Large monorepos need more.

### Step 5: Write Conventions

Write `.state/conventions.md`:

```markdown
# Conventions

- **Tone:** Be extremely concise. Lead with answers, not reasoning.
  Full natural sentences, no AI-style framing.

## Project Topography

## Naming Conventions

## Patterns & Idioms

## Tooling & Commands

## Field Notes
```

Fill every section. Ask before leaving one empty.

200-line cap. Near the limit → consolidate rather than append. Every
skill loads this file, so its length is paid on every run.
