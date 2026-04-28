---
name: fast
description: Low-ceremony delivery path for two modes — Fast Path for trivial known work (single bug fix, config change, narrow refactor), and Spike Path for unknown-feasibility exploration (POC, prototype, viability check). Both skip formal planning docs but keep core guardrails. Use when the task is too small or too uncertain for the full core workflow.
metadata:
  short-description: Fast delivery or spike path
---

# Skill: fast

## Tone

Be extremely concise. Lead with the current step, approval gate, or
blocking ambiguity.

## Purpose

Two modes under one skill. Choose based on what the architect knows:

- **Fast Path** — you know what to do, just do it without ceremony.
  Skips formal design and execution-plan docs.
- **Spike Path** — you don't know if it's feasible. Explore first,
  validate viability, then decide whether to promote to the full
  workflow.

Both modes skip the core workflow documents. Neither skips
guardrails. The architect approves before code is written. The
agent stops on failure instead of improvising.

## When to Use Which Mode

**Fast Path — good fits:**
- Single bug fix or config change
- Narrow refactor within one or two files
- Small code-and-test pair
- Focused test addition

**Spike Path — good fits:**
- Prototyping an approach before committing to architecture
- Validating whether an external dependency or API works as expected
- Exploring unknown-feasibility design space
- Learning by building a small proof point before full planning

**Neither mode — switch to core workflow when:**
- Architecture changes or broad cross-cutting work
- Many files or modules involved
- Requirements are unclear enough to need `scope`
- Spike results show the work is non-trivial

## Inputs

- Architect request (in conversation)
- `.state/conventions.md` if it exists

## Outputs

**Fast Path:**
- Concise in-chat micro plan
- Implemented code
- Verification results per micro step
- Staged task files
- Final completion report

**Spike Path:**
- Concise in-chat spike plan
- Implemented spike code
- Explicit proof of what the spike validated or ruled out
- Clear warning about production-readiness and what promotion requires
- Final spike closeout report

## Outcome Contract

**Fast Path:** Complete when the approved trivial task is implemented,
verified, and reported as READY, or when a clear blocker explains why
the fast path cannot safely continue.

**Spike Path:** Complete when the approved spike has answered the
viability question with explicit proof, known shortcuts, unresolved
risks, and a promotion recommendation (fast path, core workflow, or
abandon).

## Hard Rules

- No code changes before the architect approves the in-chat plan.
- One micro step at a time. STOP and wait for approval after each.
- If the task stops looking trivial (Fast Path) or the spike scope
  creeps (Spike Path), STOP and tell the architect.
- Do NOT create `.state/requirements.md`, `.state/architecture_decisions.md`,
  or `.state/execution_plan.md` as part of this skill.
- Keep testing discipline. Do not skip verification because the task
  is small.
- Use explicit file paths for staging. No blanket staging.
- Commit only if the architect explicitly asks.
- Do NOT present spike code as merge-ready or production-ready.
- User instructions always override this skill.

## Process: Fast Path

### FP-1: Draft Micro Plan

Understand the task. Check `.state/conventions.md` if it exists.

Draft a concise in-chat micro plan:
- What will change and where
- Verification step for each micro phase
- Anything that would make this non-trivial (flag and STOP if found)

STOP. Wait for architect approval before writing code.

### FP-2: Execute Micro Phases

After approval, implement one micro phase at a time.

For each micro phase:
1. Write or update code.
2. Run the verification step. Paste actual output.
3. If verification fails 3 consecutive times → STOP. Report error and
   wait for architect.
4. STOP after each phase. Wait for architect to say continue.

### FP-3: Stage & Report

Stage only the approved task files with explicit paths.

```
Fast Path: READY

Task: [description]
Files staged: [list]
Tests: [pass / fail / skipped]
```

Wait for architect before commit.

---

## Process: Spike Path

### SP-1: Draft Spike Plan

Understand what viability question the architect needs answered.

Draft a concise in-chat spike plan:
- The specific question to answer
- Minimal approach to answer it
- Proposed spike branch (isolated from main work)
- What "validated" and "ruled out" look like
- What the spike will NOT do (production quality, error handling, etc.)

STOP. Wait for architect approval before writing code.

### SP-2: Execute Spike

Work on an isolated branch. Keep scope tightly bounded to the
viability question.

Implement the minimum needed to get a real answer. Each micro step
must connect back to the viability question.

After each meaningful step, STOP and share what was learned.

### SP-3: Validate and Report

Document the spike findings explicitly:
- What was validated
- What was ruled out
- What shortcuts or assumptions were made
- What is NOT production-ready
- Unresolved risks

### SP-4: Promotion Decision

Give a clear recommendation:

- **Promote to fast path** — bounded, executable without full planning
- **Promote to core workflow** — complexity warrants `scope` → `design`
  → `plan` → `execute`
- **Abandon** — not viable or cost-benefit doesn't hold

State exactly what the spike validated and what it did NOT. The
architect decides whether to promote. Do NOT merge spike code until
the architect approves promotion and the code meets the standard for
the chosen path.
