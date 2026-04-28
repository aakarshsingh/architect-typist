---
name: orient
description: Builds a working understanding of the current repository before taking further instructions. Reads live .state/, summarizes purpose, active workflow position, guardrails, and likely next actions. Delegates to init if .state/ is missing or inconsistent.
metadata:
  short-description: Build repo context
---

# Skill: orient

## Tone

Be extremely concise. Lead with the current state or blocker.

## Purpose

Build working context for the current repository before taking
further instructions. Prefer live `.state/` files. Do not plan or
implement.

Delegates to `init` when `.state/` is missing — does not recreate
init's logic.

## Inputs

None required. The architect may emphasize a specific area.

## Outputs

- Concise context report in the conversation

## Outcome Contract

Complete when the conversation gives a current, evidence-backed read:
repo purpose, branch/worktree state, live state, active workflow
track, key guardrails, likely next actions, and open uncertainties.

Preserve live `.state/` as the source of truth. Do not rewrite
planning or handoff files while building context. If baseline state
is missing or inconsistent, invoke `init` instead of improvising.
A failed pull is context, not a stop condition.

## Context Priorities

Prefer sources in this order:

1. `.state/resume.md` if present
2. Other live `.state/` files (excluding archive)
3. Current branch and worktree state
4. Canonical repo docs (README.md)
5. Archive content only if the architect explicitly asks

## Git Sync Rule

1. Check current branch and worktree state.
2. Git shows an in-progress operation → do NOT fetch or pull.
   Warn and STOP.
3. Worktree dirty → do NOT pull. Note context was built from local
   state with uncommitted changes.
4. Clean → run `git fetch --prune`, then `git pull --ff-only`.
   Pull fails (auth, network) → report briefly and continue from
   local state.
   Fast-forward not possible → treat as divergence. Warn and STOP.

## Process

### Step 1: Sync

Apply the Git Sync Rule. Record branch, clean/dirty, pull result.

### Step 2: Detect State

**No `.state/`:** Invoke `init`. Resume after initialization.

**`.state/` exists:**
1. Read `.state/resume.md` first if present.
2. Read all live `.state/` files except archive folders.
3. `conventions.md` missing → inconsistent. Invoke `init`.

### Step 3: Classify

Identify the active situation:
- Active resume state → read `resume.md` first, then continue with owning skill
- Active core workflow → requirements, architecture, and/or execution plan live
- Auxiliary workflow in progress → standalone campaign files present
- Conventions-only → clean workspace, suggest `scope`
- No live state after init → suggest `scope`

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

Key Guardrails / Quirks
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
Missing or inconsistent: ...
Likely next actions: ...
```

If init required:

```text
Context Status: INIT-REQUIRED

Found: ...
Why: ...
Next: invoke init
```

## Hard Rules

- Prefer live state over re-deriving context from scratch.
- Ignore `.state/archive/` unless the architect asks.
- Do NOT invent active work. Distinguish active from archived.
- Do NOT rewrite planning or handoff files during context building.
- User instructions always override this skill.
