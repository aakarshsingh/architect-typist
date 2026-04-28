---
name: estimate
description: Estimates likely work effort from a short problem statement or high-level requirements by asking targeted questions, scanning probable change areas, inspecting nearby tests, and producing a defensible complexity read. Use before deciding whether to move fast, spike first, or enter the full workflow.
metadata:
  short-description: Estimate work effort
---

# Skill: estimate

## Tone

Be extremely concise. Lead with the estimate, blocker, or strongest
uncertainty.

## Purpose

Estimate likely work effort from a short ask. A lightweight standalone
path between a vague idea and full planning.

Asks targeted questions, reads just enough repo context, identifies
likely change areas, inspects nearby tests, and returns a short
work-effort report.

This skill is estimate-only. It does NOT implement code or write core
workflow planning files.

## Inputs

- Short problem statement from the architect (in conversation)
- Optional named files, modules, or areas already suspected to be
  relevant
- Optional constraints or non-goals

## Outputs

- Short estimate report in the conversation
- Shareable one-paragraph summary for team communication
- Optional `.state/estimate.md` for local reference

## Outcome Contract

Complete when the architect has a defensible effort read with
feasibility, complexity, likely change areas, testing guidance,
things to watch out for, and a recommended next motion.

This skill is standalone. It does not depend on core workflow files.
It may read `.state/conventions.md` if present.

## Process

### Step 1: Clarify

Read `.state/conventions.md` silently if it exists.

Ask 2-4 targeted questions to close critical ambiguities before
estimating. With each question, provide a recommended answer based
on what you can infer from the codebase. Explore before asking when
possible.

### Step 2: Scan Probable Change Areas

Inspect likely impacted files, modules, and interfaces. Identify:
- Primary files to change
- Secondary files likely touched
- Configuration or schema files involved
- Integration boundaries crossed

### Step 3: Inspect Nearby Tests

Look at the test coverage adjacent to the change area:
- Are tests present? What kind (unit, integration, e2e)?
- Are the likely changed paths exercised?
- What would need new or updated tests?

### Step 4: Produce Estimate Report

```
Estimate: [Feature or Task Name]

Feasibility: [clearly feasible | feasible with caveats | uncertain]

Complexity: [trivial | small | medium | large | very large]

Likely change areas:
- [file or module] — [why it's involved]

Testing assessment:
- [coverage status]
- [what new tests would be needed]

Things to watch out for:
- [risk or gotcha]

Open questions:
- [anything blocking a confident estimate]

Recommended next motion:
- [fast path | spike first | full workflow | needs more scoping]

---

Summary (shareable):
[2-3 sentences suitable for team communication]
```

### Step 5: Save (optional)

If the architect wants a local record, write `.state/estimate.md`
with the full report. Do not write without being asked.
