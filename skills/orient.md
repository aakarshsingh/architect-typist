---
name: orient
description: Builds a working understanding of the current repository before taking further instructions. Reads live .state/, summarizes purpose, active state, and likely next actions. Delegates to init if .state/ is missing.
metadata:
  short-description: Build repo context
---

# Skill: orient

## Tone

Be extremely concise. Lead with the current state or blocker.

No sycophantic openers or closing fluff.
Short sentences in output (8-10 words max). No filler.
No em-dashes or replacement hyphens. No parenthetical clauses.
Output sounds human, not AI-generated.

## Purpose

Build working context for the current repository before taking
further instructions. Prefer live `.state/` files. Do not plan or
implement.

This skill delegates to `init` when `.state/` is missing — it does
not recreate init's logic.

## Inputs

None required. The architect may emphasize a specific area.

## Outputs

- Concise context report in conversation

## Git Sync Rule

1. Check branch and worktree state.
2. Worktree clean → try `git pull`.
3. Pull fails → report briefly, continue from local state.
4. Worktree dirty → do NOT pull. Note that context was built from
   local state with uncommitted changes.

A failed pull is context, not a stop condition.

## Context Priorities

1. `.state/resume.md` (if present)
2. Other live `.state/` files (not archive)
3. Branch and worktree state
4. Canonical docs (README.md)
5. Archive only if architect asks

## Process

### Step 1: Sync

Apply Git Sync Rule. Record branch, clean/dirty, pull result.

### Step 2: Detect State

**No `.state/`:** Invoke `init`. Resume after initialization.

**`.state/` exists:**
1. Read `resume.md` first if present.
2. Read all live `.state/` files except archive.
3. If `conventions.md` is missing, treat as inconsistent — invoke
   `init`.

### Step 3: Classify

Determine which situation:
- Active resume state
- Active core workflow (requirements, architecture, execution plan)
- Conventions-only (clean workspace)
- No live state after init

### Step 4: Report

```text
Context Status: READY

Repo Purpose
- ...

Branch / Worktree
- ...

State
- ...

Active Track
- ...

Key Guardrails / Notes
- ...

Likely Next Actions
- ...

Open Uncertainties
- ...
```

If partially reliable:

```text
Context Status: PARTIAL

Confirmed: ...
Missing/Inconsistent: ...
Likely next: ...
```

If init needed:

```text
Context Status: INIT-REQUIRED

Found: ...
Why: ...
Next: invoke init
```

## Hard Rules

- Prefer live state over re-deriving from scratch.
- Ignore `.state/archive/` unless architect asks.
- Do NOT invent active work. Distinguish active from archived.
- Do NOT rewrite planning or handoff files during context building.
- User instructions always override this skill.
- Skip files over 100KB unless explicitly required.
- Suggest /cost when session is running long to monitor cache ratio.
- Recommend starting a new session when switching to an unrelated task.
