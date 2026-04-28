---
name: triage
description: Performs read-only incident triage and bounded repo risk scanning from logs, stack traces, observability data, and isolated code. Use when the goal is diagnosis and theory-building rather than implementation.
metadata:
  short-description: Triage an issue
---

# Skill: triage

## Tone

Be extremely concise. Lead with the current read and the strongest
theories or risks, not a narrative recap.

## Purpose

Fast, read-only diagnosis. Narrow likely root causes from supplied
evidence and focused local inspection.

This skill is for triage, not fixing. It interprets symptoms, logs,
stack traces, recent code context, and recent commits, then recommends
the next validation steps for the architect.

Also supports a bounded repo-risk path: read-only risk discovery
across a module or release area to rank top plausible client-impacting
risks, without widening into general code review.

Reads `.state/conventions.md` and existing `.state/` files when
present. If no `.state/` exists and the investigation would benefit
from workspace context, suggest invoking `init` first.

## Inputs

- Architect-provided symptom statement or incident description
- Any available stack traces, logs, error output, or timestamps
- Optional exact files, services, or time windows to inspect
- Optional suspected regression window or prior theory
- Optional `.state/conventions.md`

## Outputs

- Current read: symptom interpretation
- Top 2-3 root cause theories ranked by confidence
- Evidence supporting and weakening each theory
- Recommended next validation steps (read-only where possible)
- Risk ranking for repo-risk asks
- Open uncertainties

## Outcome Contract

Complete when the architect has a ranked set of root cause theories
with supporting evidence and concrete next steps to validate them.

Preserve the read-only constraint. Do not implement fixes, modify
code, or stage files. If a fix is clearly needed, recommend invoking
`fast` or the core workflow after triage is complete.

## Hard Rules

- Read-only by default. No code changes, no staging, no commits.
- Do not conflate a theory with a confirmed root cause.
- Do not recommend a fix without stating confidence level.
- Present evidence for and against each theory — not just supporting
  evidence.
- User instructions always override this skill.

## Process

### Step 1: Understand the Symptom

Restate the symptom in one sentence. Confirm with the architect
if the statement is ambiguous.

Read `.state/conventions.md` silently if it exists.

Determine triage mode:
- **Incident triage** — something is broken now, need root cause
- **Repo risk scan** — look for likely client-impacting risks in an area

### Step 2: Gather Evidence

Inspect provided material: stack traces, logs, error output, metrics.

Then do minimal targeted reads of likely relevant code:
- Files named in the stack trace
- Recent commits touching the suspected area
- Configuration or schema files related to the symptom

Do not broadly scan the codebase. Stay in the suspected blast radius.

### Step 3: Generate Theories

Produce 2-3 root cause theories. For each:
- **Theory:** [concise description]
- **Evidence for:** [specific signals]
- **Evidence against:** [anything that weakens it]
- **Confidence:** [high / medium / low]

Rank by confidence.

### Step 4: Recommend Validation Steps

For each theory, recommend the minimal validation step to confirm or
rule it out. Prefer read-only validation (log inspection, targeted
search, test run) over code changes.

If a code change is the only path to validation, say so explicitly and
recommend `fast` or the core workflow for implementation.

### Step 5: Report

```text
Triage: [symptom in one sentence]

Current Read
- [interpretation]

Theories (ranked)
1. [HIGH] [theory] — [evidence for / against]
2. [MEDIUM] [theory] — [evidence for / against]
3. [LOW] [theory] — [evidence for / against]

Recommended Next Steps
- [concrete validation action]

Open Uncertainties
- [what would change the ranking if known]
```
