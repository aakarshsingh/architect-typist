---
name: fast
description: Low-ceremony delivery path with two modes. Fast Path handles trivial known work such as a single bug fix, config change, or narrow refactor. Spike Path handles unknown-feasibility exploration such as a POC, prototype, or viability check. Both skip formal planning docs but keep core guardrails. Use when the task is too small or too uncertain for the full core workflow.
metadata:
  short-description: Fast delivery or spike path
  slot: u2
---

# Skill: fast

## Tone

Be extremely concise. Lead with the current step, approval gate, or
blocking ambiguity.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Two modes under one skill. Choose based on what the architect knows:

- **Fast Path:** the work is known. Do it without ceremony. Skips
  formal design and execution-plan docs.
- **Spike Path:** feasibility is unknown. Explore first, validate
  viability, then decide whether to promote to the full workflow.

Both modes skip the core workflow documents. Neither skips
guardrails. The architect approves before code is written. The agent
stops on failure instead of improvising.

## When to Use Which Mode

Rule of thumb: if you can describe the diff in one sentence, Fast
Path fits.

**Fast Path fits:**
- Single bug fix or config change
- Narrow refactor within one or two files
- Small code-and-test pair
- Focused test addition

**Spike Path fits:**
- Prototyping an approach before committing to architecture
- Checking whether an external dependency or API behaves as expected
- Exploring an unknown design space
- Building a small proof point before full planning

**Neither. Switch to the core workflow when:**
- Architecture changes or work is cross-cutting
- Many files or modules are involved
- Requirements are unclear enough to need `scope`
- Spike results show the work is non-trivial

Unsure which fits → recommend `roadmap` for a quick estimate.

## Inputs

- Architect request, in conversation
- `.state/conventions.md` if it exists

## Outputs

**Fast Path:**
- Concise in-chat micro plan
- Implemented code
- Verification results per micro step
- Staged task files
- Completion report

**Spike Path:**
- Concise in-chat spike plan
- Spike code on an isolated branch
- Explicit proof of what the spike validated or ruled out
- Warning about production-readiness and what promotion requires
- Spike closeout report

## Outcome Contract

**Fast Path:** complete when the approved task is implemented,
verified, and reported READY, or when a clear blocker explains why
the fast path can't continue safely.

**Spike Path:** complete when the viability question has an answer
with explicit proof, known shortcuts, unresolved risks, and a
promotion recommendation: fast path, core workflow, or abandon.

## Hard Rules

- No code changes before the architect approves the in-chat plan.
- Task stops looking trivial, or spike scope creeps → STOP and say
  so. Hidden complexity is why the core workflow exists.
- Don't create `requirements.md`, `architecture_decisions.md`, or
  `execution_plan.md`. They would look like an active core workflow.
- Verify every step, however small. Show the actual output.
- Stage with explicit paths. Commit only when the architect asks.
- Never present spike code as merge-ready.
- User instructions override this skill.

## Process: Fast Path

### FP-1: Draft Micro Plan

Read `.state/conventions.md` if it exists and the code to change.

Draft a concise micro plan:
- What changes, and where
- A verification command for each micro step
- Anything that makes this non-trivial. Found → flag it and STOP.

By default, pause after each micro step. The architect can say "run
through" when approving. STOP until the plan is approved.

### FP-2: Execute Micro Steps

For each micro step:
1. Write or update code.
2. Run its verification. Show the output.
3. 3 consecutive failures → STOP. Report the error and wait.
4. STOP and wait for "continue", unless the architect said run
   through. Anything surprising → STOP and report either way.

### FP-3: Stage & Report

Stage only the approved task files with explicit paths.

```
Fast Path: READY

Task: [description]
Files staged: [list]
Tests: [pass / fail / skipped]
```

Wait for the architect before commit.

---

## Process: Spike Path

### SP-1: Draft Spike Plan

Identify the viability question the architect needs answered.

Draft a concise spike plan:
- The specific question
- The minimal approach to answer it
- Proposed spike branch, isolated from main work
- What "validated" and "ruled out" look like
- What the spike will not do: production quality, full error
  handling, and so on

STOP until the plan is approved.

### SP-2: Execute Spike

Work on the approved spike branch. Keep scope tied to the viability
question. Build the minimum that gets a real answer.

After each meaningful step, STOP and share what was learned.

### SP-3: Validate and Report

Document:
- What was validated
- What was ruled out
- Shortcuts and assumptions taken
- What is not production-ready
- Unresolved risks

### SP-4: Promotion Decision

Recommend one:

- **Promote to fast path:** bounded, executable without full planning
- **Promote to core workflow:** complexity warrants `scope` →
  `design` → `plan` → `execute`
- **Abandon:** not viable, or cost outweighs benefit

State exactly what the spike validated and what it did not. The
architect decides. Don't merge spike code until promotion is approved
and the code meets the chosen path's standard.
