---
name: maintain
description: Maintains existing skills using human or agent feedback, structured local memory, cross-skill coherence checks, and approval gates. Use when improving an existing skill, reconciling feedback, or aligning dependent skills and docs.
metadata:
  short-description: Maintain existing skills
---

# Skill: maintain

## Tone

Be extremely concise. Lead with the finding, plan decision, or
blocking ambiguity.

## Purpose

Maintain existing skills and their supporting docs coherently.

Not for new skill drafting — that's `forge`. Accepts direct human
feedback, relayed agent feedback, questionnaire answers, or mixed
input. May touch multiple related skills when contracts overlap.

Owns local maintenance memory under `.state/maintain/`.

## Inputs

- Human feedback in conversation
- Optional relayed run feedback from another agent
- Optional target skill or skill family
- Optional existing `.state/maintain/` memory
- `.state/conventions.md` if it exists

## Outputs

- `.state/maintain/01-intake.md`
- `.state/maintain/02-plan.md`
- `.state/maintain/03-run-log.md`
- `.state/maintain/04-closeout.md`
- Updated skill files, docs, and maintenance memory
- Approval checkpoint for commit and push

## Hard Rules

- Existing skills only. New drafts → `forge`.
- One active campaign at a time (may touch multiple skills).
- Freeze `01-intake.md` after human confirms framing.
- Freeze `02-plan.md` after approval.
- `03-run-log.md` is newest-first.
- `04-closeout.md` is write-once.
- Classify problems explicitly: wording drift, heuristic gap,
  decision-tree gap, stop-rule problem, docs drift, tool/repo
  failure (not skill-design).
- Do NOT rewrite approved memory files for tidiness.
- Do NOT skip caller/callee alignment when a callee contract changes.
- Do NOT skip final coherence scan.
- Do NOT commit or push without explicit approval in that order.

## Git Sync Rule

Before reading or editing tracked files:

1. Check branch and worktree state.
2. Worktree clean → `git pull`.
3. Worktree dirty → do NOT pull.
   - If `03-run-log.md` exists or architect asked to continue local
     work → treat dirty state as maintenance boundary, warn once.
   - Otherwise → ask how to proceed, STOP.

## Resume Rule

If the session is ending, write `.state/resume.md` with: current
skill, current state, next action, read-first files, and a concrete
resume prompt. Echo the resume prompt in the reply.
`.state/maintain/` is authoritative, not the resume file.
On successful closeout, delete `.state/resume.md` if no other
workflow needs it.

## Process

### Step 1: Sync

Apply Git Sync Rule. If pull fails after retry, STOP before editing
tracked files.

### Step 2: Gather Input

Read feedback and existing maintenance memory. Create
`.state/maintain/` if needed.

Write `01-intake.md`: scope, input mode, target skills, problem
classification, related skills/docs, evidence, inferences needing
confirmation.

### Step 3: Process Input

Separate: repo/tool failure vs skill-design failure vs docs drift.

Ask only targeted questions needed for safe planning. Provide
recommended answers.

Freeze `01-intake.md` after human confirms framing.

### Step 4: Build Plan

Write `02-plan.md`: objective, targets, risk classification, exact
edits, coherence surfaces, memory updates.

May span multiple skills when dependencies warrant.

### Step 5: Get Approval

Present plan. STOP until explicit approval. Freeze `02-plan.md`.

### Step 6: Implement

Update only approved files and maintenance memory.

Log steps in `03-run-log.md` (newest first).

Plan no longer fits → STOP, ask whether to supersede or restart.
Do not rewrite the frozen plan.

### Step 7: Verify

Mandatory before reporting completion:

- Touched skills internally coherent
- Caller/callee skills checked and updated
- Repeated/contradictory guidance removed
- README and docs updated if user-facing contract changed
- Maintenance memory reflects durable lessons
- Resume state accurate

Final coherence scan across changed skills, siblings, and docs.

### Step 8: Finalize

Write `04-closeout.md`: status, touched skills, docs, memory, key
fixes, residual risks, recommended commit message.

Ask for approval:
1. Commit
2. Push

Do NOT act until approved.

## Output Format

Before approval:

```text
Maintenance Status: PLANNING

Findings
- ...

Related skill/doc impact
- ...

Plan
- ...

Questions
- ...
```

No questions → `Questions: None.`

After implementation:

```text
Maintenance Status: READY

What changed
- ...

Coherence checks
- ...

Docs and memory
- ...

Approvals needed
1. commit
2. push
```
