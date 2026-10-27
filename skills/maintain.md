---
name: maintain
description: Maintains existing skills using human or agent feedback, structured local memory, cross-skill coherence checks, and approval gates. Use when improving an existing skill, reconciling run feedback, or aligning dependent skills and docs. Not for new skill creation; use forge.
metadata:
  short-description: Maintain existing skills
  slot: u8
---

# Skill: maintain

## Tone

Be extremely concise. Lead with the finding, plan decision, or
blocking ambiguity.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Maintain existing skills and their supporting docs coherently.

Accepts direct human feedback, relayed run feedback from another
agent, or mixed input. May touch multiple related skills in one
campaign when their contracts overlap.

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

## Outcome Contract

Complete when the finished campaign has a frozen closeout, all touched
skills are internally coherent, caller/callee alignment is verified,
and the architect has approved commit.

Preserve one active campaign at a time. Stop when plan no longer fits
the discovered state rather than silently adapting. Do not commit
or push without explicit approval.

## Agentic Feedback Loop

For every campaign, normalize incoming feedback through these steps:

1. Normalize into a structured intake.
2. Separate evidence from inference.
3. Separate repo or tool failures from skill-design failures.
4. Ask only targeted clarification questions when the plan would be
   unsafe without them. Provide a recommended answer with each.
5. Turn the approved interpretation into a concrete maintenance plan.

Accepted intake modes:
- direct human conversation
- relayed run feedback from another agent
- questionnaire-style answers

## Hard Rules

- Existing skills only. New drafts → `forge`.
- One active campaign at a time. It may touch multiple skills.
- Freeze `01-intake.md` after human confirms framing.
- Freeze `02-plan.md` after approval.
- `03-run-log.md` is newest-first.
- `04-closeout.md` is write-once.
- Classify problems explicitly: wording drift, heuristic gap,
  decision-tree gap, stop-rule problem, docs drift, or tool/repo
  failure, which is not a skill-design issue.
- Don't rewrite approved memory files for tidiness. They record what
  was decided.
- When a callee contract changes, align its callers. Skills load
  alone, so a stale caller silently breaks the handoff.
- Run the final coherence scan before reporting completion.
- No commit or push without explicit approval.
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

Maintain exception: dirty worktree and `03-run-log.md` exists, or the
architect asked to continue local work → treat it as the campaign's
own changes. Warn once and continue.

## Question Rule

Check the code and `.state/` before asking. Ask only what changes the
output. At most 4 questions per turn, each with a recommended answer.
Stop asking when the remaining unknowns wouldn't change the result.
Record them as open questions instead.

## Resume Rule

Session ending before the outcome is complete → write
`.state/resume.md` with: current skill, current state, next action,
read-first files, and a resume prompt. Echo the prompt in the reply.

`.state/maintain/` is authoritative, not the resume file.
On successful closeout, delete `.state/resume.md` if no other
workflow needs it.

## Process

### Step 1: Sync

Apply the Git Sync Rule.

### Step 2: Gather Input

Read feedback and existing maintenance memory. Create
`.state/maintain/` if needed.

Write `01-intake.md`: scope, input mode, target skills, problem
classification, related skills/docs, evidence, inferences needing
confirmation.

### Step 3: Process Input

Separate: repo/tool failure vs skill-design failure vs docs drift.

Apply the Question Rule.

Freeze `01-intake.md` after human confirms framing.

### Step 4: Build Plan

Write `02-plan.md`: objective, targets, risk classification, exact
edits, coherence surfaces, memory updates.

May span multiple skills when dependencies warrant.

### Step 5: Get Approval

Present plan. STOP until explicit approval. Freeze `02-plan.md`.

### Step 6: Implement

Update only approved files and maintenance memory.

Log steps in `03-run-log.md`, newest first.

Plan no longer fits → STOP, ask whether to supersede or restart.
Do not rewrite the frozen plan.

### Step 7: Verify

Mandatory before reporting completion:

- Touched skills internally coherent
- Caller/callee skills checked and updated
- Repeated or contradictory guidance removed
- README and `docs/cheatsheet.md` updated if a user-facing contract
  changed
- Shared rule blocks still match their siblings verbatim
- Maintenance memory reflects durable lessons

Final coherence scan across changed skills, siblings, and docs.

### Step 8: Finalize

Write `04-closeout.md`: status, touched skills, docs, memory, key
fixes, residual risks, recommended commit message.

Move `01`-`04` into `.state/maintain/<YYYY-MM-DD>-<slug>/`. The root
holds only the active campaign, so the next one starts clean.

Ask for approval:
1. Commit
2. Push

STOP until approved.

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
