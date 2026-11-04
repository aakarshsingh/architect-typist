---
name: orient
description: Builds a working understanding of the current repository before taking further instructions. Reads live .state/, summarizes purpose, active workflow position, guardrails, and likely next actions, including at most one critical thinking suggestion. Delegates to init if .state/ is missing or inconsistent.
metadata:
  short-description: Build repo context
  slot: u1
---

# Skill: orient

## Tone

Be extremely concise. Lead with the current state or blocker.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Build working context for the current repository before taking
further instructions. Prefer live `.state/` files. Don't plan or
implement.

Delegates to `init` when `.state/` is missing or inconsistent rather
than recreating init's logic.

## Inputs

None required. The architect may emphasize a specific area.

## Outputs

- Concise context report in the conversation

## Outcome Contract

Complete when the conversation has a current, evidence-backed read:
repo purpose, branch and worktree state, live state, active workflow
track, key guardrails, likely next actions, and open uncertainties.

Live `.state/` is the source of truth. A failed pull is context, not
a stop condition.

## Hard Rules

- Read-only, except when delegating to `init`, and except for
  `.state/learning.md`: create it and set its `nudges:` line, nothing
  else. It's local and uncommitted, and it holds only the opt-out.
- Don't rewrite planning or handoff files. Another session may own
  them.
- Ignore `.state/archive/` unless the architect asks.
- Don't invent active work. Distinguish active from archived.
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

Orient exceptions, because it only reads:
- Dirty worktree → don't ask. Note that context comes from local
  state with uncommitted changes, and continue.
- Fetch or pull fails on auth or network → report briefly and
  continue from local state.

## Context Priorities

Prefer sources in this order:

1. `.state/resume.md`
2. Other live `.state/` files, excluding `archive/`
3. Current branch and worktree state
4. Canonical repo docs such as README.md
5. Archive content, only if the architect asks

## Critical Thinking Nudges

`challenge`, `defend`, and `practice` keep the architect thinking
and learning. The core workflow never calls them, so `orient` is
where they get suggested. Nudges are on by default, because skills
that wait to be remembered go unused.

- `.state/learning.md` says `nudges: off` → skip this section.
- No `nudges:` line yet → mention the three skills once, one line
  each, and that "stop nudges" turns them off for this project.
  Then create the file with the template below, or add the line, so
  the mention isn't repeated.
- After that, add at most one suggestion to Likely Next Actions,
  chosen from live state:
  - A phase Completed with no `defend` row in the journal since →
    `defend stage=closeout work=<feature>`
  - `requirements.md` exists, no `architecture_decisions.md`, and no
    `challenge` row for it → `challenge stage=design work=<feature>`
  - Want to Learn has items and no `practice` row in the last five
    journal rows → `practice <item>`
- Suggest, never run. Prefill only known fields. Leave `seen` out
  unless you know it, because a wrong `seen=no` fakes independence.
- "Stop nudges" → set `nudges: off` and confirm in one line. "Turn
  nudges on" → set `nudges: on`.

Template:

```markdown
# Learning: [project]

nudges: on

## Want to Learn

## Journal
| Date | Skill | What | Ran/Skipped | Changed | Felt |
|------|-------|------|-------------|---------|------|

## Can Now Do Without AI
```

## Process

### Step 1: Sync

Apply the Git Sync Rule. Record branch, clean or dirty, pull result.

### Step 2: Detect State

**No `.state/`:** run `init`, then resume here.

**`.state/` exists:**
1. Read `resume.md` first if present.
2. Read all live `.state/` files except `archive/`.
3. `conventions.md` missing → inconsistent. Run `init`.

### Step 3: Classify

Identify the active situation:
- Resume state → name the owning skill and its next action
- Core workflow → requirements, architecture, or execution plan live.
  Report phase progress and `Plan Status`.
- Utility work → `roadmap.md` or an open `maintain/` campaign
- Conventions only → clean workspace. Recommend `scope`, `fast`, or
  `roadmap`.

### Step 4: Nudge

Apply Critical Thinking Nudges. Skip it when delegating to `init`.
The first-time mention and any suggestion go under Likely Next
Actions in the report.

### Step 5: Report

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

Partially reliable:

```text
Context Status: PARTIAL

Confirmed: ...
Missing or inconsistent: ...
Likely next actions: ...
```

Init required:

```text
Context Status: INIT-REQUIRED

Found: ...
Why: ...
Next: init
```
