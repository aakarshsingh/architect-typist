---
name: triage
description: Performs read-only incident triage and bounded repo risk scanning from logs, stack traces, observability data, and isolated code. Use when the goal is diagnosis and theory-building rather than implementation.
metadata:
  short-description: Triage an issue
  slot: u5
---

# Skill: triage

## Tone

Be extremely concise. Lead with the current read and the strongest
theories or risks, not a narrative recap.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Fast, read-only diagnosis. Narrow likely root causes from supplied
evidence and focused local inspection.

For triage, not fixing. Interprets symptoms, logs, stack traces,
recent code, and recent commits, then recommends validation steps.

Also supports a bounded repo-risk scan: read-only discovery across a
module or release area to rank the top plausible client-impacting
risks, without widening into general code review.

Reads `.state/conventions.md` and live `.state/` files when present.

## Inputs

- Symptom statement or incident description
- Stack traces, logs, error output, or timestamps
- Optional files, services, or time windows to inspect
- Optional suspected regression window or prior theory

## Outputs

- Current read: symptom interpretation
- Top 2-3 root cause theories ranked by confidence
- Evidence for and against each theory
- Validation steps, read-only where possible
- Risk ranking for repo-risk asks
- Open uncertainties

## Outcome Contract

Complete when the architect has ranked root cause theories with
evidence and concrete steps to validate them.

## Hard Rules

- Read-only. No code changes, staging, or commits.
- A theory is not a confirmed root cause. Label confidence on every
  theory and every recommended fix.
- Show evidence against each theory, not just evidence for it.
  One-sided evidence anchors the investigation on the first guess.
- Fix needed → recommend `fast` or the core workflow after triage.
- User instructions override this skill.

## Reference Format

Cite code as `name.ext:line` or `name.ext:10-18`, not the full path.
Two cited files share a name → add the nearest parent folder:
`api/rl.ts:40`. Keep each reference next to the claim it supports.

Why: full paths wrap and bury the point in a terminal.

## Process

### Step 1: Understand the Symptom

Restate the symptom in one sentence. Ambiguous → confirm with the
architect.

Read `.state/conventions.md` silently if it exists.

Pick a mode:
- **Incident triage:** something is broken now
- **Repo risk scan:** find likely client-impacting risks in an area

### Step 2: Gather Evidence

Inspect provided material first: stack traces, logs, error output,
metrics.

Then read the likely relevant code, in parallel where independent:
- Files named in the stack trace
- Recent commits touching the suspected area
- Configuration or schema tied to the symptom

Stay in the suspected blast radius. Repo risk scan over a large area
→ delegate per-module sweeps to subagents if your tool supports it.

### Step 3: Generate Theories

Produce 2-3 theories. For each:
- **Theory:** concise description
- **Evidence for:** specific signals
- **Evidence against:** anything that weakens it
- **Confidence:** high, medium, or low

Rank by confidence.

### Step 4: Recommend Validation Steps

For each theory, give the smallest step that confirms or rules it
out. Prefer read-only validation: log inspection, targeted search,
running an existing test.

Only a code change can validate → say so and recommend `fast` or the
core workflow.

### Step 5: Report

```text
Triage: [symptom in one sentence]

Current Read
- [interpretation]

Theories (ranked)
1. [HIGH] [theory]: [evidence for / against]
2. [MEDIUM] [theory]: [evidence for / against]
3. [LOW] [theory]: [evidence for / against]

Recommended Next Steps
- [concrete validation action]

Open Uncertainties
- [what would change the ranking if known]
```
