# The Architect-Typist Workflow: Tech Talk

A live walkthrough of the full pipeline, from empty `.state/` to
shipped PR. Built around a real app (bill-splitter) with mocked outputs
showing every skill in action.

---

## The Problem

AI coding agents are good at writing code. They are bad at:

1. **Staying on plan.** They optimize for completion, not correctness.
   Give them a task, come back in 20 minutes, and the code works but
   doesn't match what you asked for.

2. **Knowing when to stop.** They work around problems instead of
   flagging them. By the time you notice, three files have been
   silently modified outside the plan.

3. **Surviving session boundaries.** This is the big one.

### The Session Problem

Every AI coding session carries implicit state: what was decided, what
was tried, what failed, what the architect cares about. When the
session ends (context limit, tool crash, lunch break, sleep), that
state vanishes.

The next session starts cold. The agent doesn't know what you decided
about discount UX. It doesn't know that `calcLib.js` is off-limits.
It doesn't know Phase 1 flagged an issue that Phase 3 should fix.
You re-explain everything, or the agent guesses wrong.

This is the biggest problem with agentic coding today: **the fear of
ending a session.** Developers keep sessions alive far too long,
cramming work into single conversations, because they know that
starting fresh means losing context. The context window becomes a
prison. You can't leave without paying a tax.

The Architect-Typist workflow fixes this by making sessions
disposable. All decisions, plans, progress, and field notes
live in `.state/` files on disk. Any new session rebuilds full
understanding by reading those files. Context windows become
interchangeable. You can close a session after every phase, switch
tools mid-project, or pick up a week later. The files are the
continuity, not the conversation.

---

## The Demo

We'll build four features into a real app using the full pipeline.
Every skill runs. We hit a resume scenario and a pivot scenario.

### The App

[bill-splitter](https://github.com/aakarshsingh/bill-splitter): a
React + Express app that splits restaurant bills with AI parsing.
We start from the Feature 2 baseline.

> See: [00-baseline.md](00-baseline.md) for repo structure and key
> patterns.

### The Features

1. Discount system (three modes, Apply/Clear, proportional distribution)
2. PDF page selection for multi-page bills
3. Editable date on the Review screen
4. Export JSON on the Output screen

---

## Pipeline Walkthrough

### Step 1: Initialize the workspace

Skill: `as-p1-init`

The agent scans the repo, discovers conventions (paise integers,
prop drilling, CSS Modules, PascalCase components), and asks three
clarifying questions. Writes `conventions.md`.

> Output: [01-init-output.md](01-init-output.md)

The conventions file becomes shared memory. Every future skill reads it.
The paise convention and the `initialData`/`onConfirm` pattern were
discovered by reading code, not by asking.

---

### Step 2: Define scope

Skill: `as-p2-scope`

The architect describes what they want. The agent runs a structured
interview (6 questions). On question 3, the architect overrides the
agent's recommendation: no live discount calculation, Apply/Clear
buttons instead. This becomes a hard constraint.

> Output: [02-scope-output.md](02-scope-output.md)

Without scope, this disagreement surfaces mid-coding as "I don't like
this, redo it." With scope, it's caught before any code is written.

---

### Step 3: Design the architecture

Skill: `as-p3-design`

The agent produces a module breakdown (10 files), data flow (10
steps), and a traceability table mapping every DoD item to its
implementing file. Test strategy: TS3 (no testing, justified by the
absence of any test infrastructure).

> Output: [03-design-output.md](03-design-output.md)

The traceability table is the key artifact. It proves that nothing in
the DoD is unaccounted for. It also proves `calcLib.js` is NOT in the
target list, architecturally enforcing the "no formula changes"
constraint.

---

### Step 4: Plan execution phases

Skill: `as-p4-plan`

Three phases, each with target files, changes, verification steps,
DoD mapping, and a self-audit checklist. Phase 1 is the largest (5
files). The architect flags it as borderline; the agent justifies the
coupling.

> Output: [04-plan-output.md](04-plan-output.md)

Each phase is a self-contained unit with its own success criteria.
If Phase 1 fails, Phases 2 and 3 are unaffected.

---

### Step 5: Execute Phase 1 (Discount System)

Skill: `as-p5-execute`

New session. The agent reads `.state/`, finds Phase 1 Pending.
Reads all 5 target files. Implements mutual exclusion on discount
inputs, Apply/Clear lock model, largest-remainder distribution,
strikethrough display, Export JSON, and session load reconstruction.

During self-audit, discovers a near-divergence: the PDF preview
iframe on Review squeezes the table. Correctly identifies this as
outside Phase 1's target files and defers to Phase 3.

> Output: [05-execute-phase1.md](05-execute-phase1.md)

The near-divergence is the guardrail in action. The agent found a
real problem, resisted the urge to fix it (wrong phase), documented
it as a field note, and moved on.

---

### Step 6: Session break and resume

**This is the most important demo.**

The architect needs to step away after Phase 1. The agent writes
`resume.md`: a bookmark pointing to the authoritative state files,
with a concrete resume prompt the architect can copy-paste into the
next session.

Hours or days later, a fresh session starts. The agent reads
`.state/`, rebuilds full context from files, and picks up exactly
where it left off. No re-explanation. No context loss. No drift.

> Output: [06-resume-scenario.md](06-resume-scenario.md)

What makes this work:

- **resume.md is a bookmark, not a brain dump.** It points to files
  rather than repeating their content. No stale copies.
- **The resume prompt is concrete.** Copy-paste it. No ambiguity.
- **Fresh-session discipline holds.** The new session builds context
  from files, not from memory. Even if you switch AI tools between
  sessions, the `.state/` files provide full continuity.
- **resume.md is transient.** It exists between sessions. On ship,
  it's deleted.

Every skill in the pipeline has a resume hook. Session boundaries
become free. You can close a session after every phase, after every
hour, or whenever the context window gets heavy. The files carry
the state. The conversation is disposable.

This flips the mental model. Instead of dreading the end of a
session, you welcome it. Fresh sessions are sharper. They start with
clean context. The fear of ending a session disappears because
ending a session costs nothing.

---

### Step 7: Execute Phase 2 (PDF Page Selection)

Skill: `as-p5-execute`

New session (after resume). Reads `.state/`, finds Phase 2 Pending.
Also reads the Phase 1 field note about PDF preview width. Implements page
count detection, page selector UI, and server-side page extraction
with pdf-lib.

> Output: [07-execute-phase2.md](07-execute-phase2.md)

---

### Step 8: Execute Phase 3 (Editable Date + Review Cleanup)

Skill: `as-p5-execute`

Reads `.state/`, finds Phase 3 Pending. Adds editable date input.
Removes the PDF preview iframe, fixing the Phase 1 field note.
Updates the conventions file to mark it as resolved.

> Output: [08-execute-phase3.md](08-execute-phase3.md)

The field note lifecycle is complete: discovered in Phase 1, documented
in conventions, deferred to Phase 3, fixed in Phase 3, removed from
conventions. All tracked. Nothing forgotten.

---

### Step 9: Pivot (Discount UX Redesign)

After all three phases complete, the architect reviews the discount
feature and finds three problems: ambiguous Apply behavior with
multiple field values, missing history restore, and a division-by-zero
edge case.

This triggers `as-p7-pivot`. The agent assesses impact (1 of 3 phases
affected, well under the 50% threshold for restarting from design),
generates Phase 1A as a surgical amend, and executes it.

> Output: [09-pivot-scenario.md](09-pivot-scenario.md)

The pivot is formal. It's not a silent fix. The architect reported
the issue, the agent created a tracked amend phase with its own
self-audit, and the fix is staged separately. If someone reads the
execution plan later, they'll see exactly what changed and why.

---

### Step 10: Ship

Skill: `as-p6-ship`

All phases complete (including the 1A amend). The agent walks the
DoD checklist (10/10 satisfied), produces a diff summary, runs a full
regression check, prunes the conventions file, archives the planning
artifacts, and drafts a PR.

> Output: [10-ship-output.md](10-ship-output.md)

Ship doesn't check vibes. It walks the contract. Every DoD item is
mapped to implementing code. The PR draft writes itself from the
accumulated state.

---

## Key Takeaways

### 1. Sessions are disposable

The `.state/` directory is the memory. The conversation is not. You
can close any session, at any time, with zero cost. The next session
picks up from files. This eliminates the biggest friction in agentic
coding: the fear of losing context.

### 2. Human gates prevent drift

The architect approves at every phase boundary. The agent cannot
advance without explicit approval. Divergence detection makes drift
visible, cheap, and fixable. Problems are caught when they're small.

### 3. Phases bound the blast radius

Each phase is independently verifiable. If something breaks, you lose
one phase of work. Not all of it. The 3-Strike Rule prevents the
agent from brute-forcing past failures.

### 4. Pivots are surgical, not catastrophic

When things go wrong post-execution, the pivot skill assesses impact
and generates minimal amendments. It doesn't restart from scratch
unless the fundamental approach is wrong (>50% of phases affected).

### 5. Planning artifacts are reusable

The DoD, architecture decisions, and execution plan are written once
and referenced everywhere: during execution for self-audit, during
ship for verification, during pivot for impact assessment, and in the
PR for documentation.

### 6. The workflow is tool-agnostic

`.state/` files are plain markdown. Start with Claude Code, continue
with Cursor, review with Codex. The skills communicate through files,
not through any tool's proprietary memory.

---

## File Index

| File | Contents |
|------|----------|
| [00-baseline.md](00-baseline.md) | Bill-splitter repo structure at Feature 2 |
| [01-init-output.md](01-init-output.md) | `conventions.md` output from init |
| [02-scope-output.md](02-scope-output.md) | Scope interview + `requirements.md` |
| [03-design-output.md](03-design-output.md) | `architecture_decisions.md` with traceability |
| [04-plan-output.md](04-plan-output.md) | `execution_plan.md` with 3 phases |
| [05-execute-phase1.md](05-execute-phase1.md) | Phase 1 execution + near-divergence |
| [06-resume-scenario.md](06-resume-scenario.md) | Session break, resume.md, fresh pickup |
| [07-execute-phase2.md](07-execute-phase2.md) | Phase 2 execution (PDF pages) |
| [08-execute-phase3.md](08-execute-phase3.md) | Phase 3 execution + field note resolution |
| [09-pivot-scenario.md](09-pivot-scenario.md) | Post-execution pivot + Phase 1A amend |
| [10-ship-output.md](10-ship-output.md) | DoD verification, archive, PR draft |
