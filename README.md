# The Architect-Typist Workflow

You decide. The AI builds.

A disciplined pipeline for shipping features with AI agents.
The human stays in the architect seat, setting direction, making
decisions, owning every commit. The AI is the typist: fast, capable,
but never in charge.

All state is local. All decisions are human. All commits are
human-authorized.

Language-agnostic. Framework-agnostic. Tool-agnostic.

---

## Why This Exists

AI agents are powerful but not accountable. They optimize for
completion, not correctness. Without structure, they silently drift
from the plan, skip edge cases, and ship code that looks right but
isn't.

This workflow fixes three failure modes:

**Context death.** Sessions expire. Windows close. Token limits
truncate history. `.state/` files survive all of it. The agent
rebuilds understanding from files, never from conversation memory.

**Compounding errors.** One large session is fragile. One mistake
cascades into everything after it. Phased execution bounds the
blast radius: each phase is independently verifiable. If something
breaks, you lose one phase of work, not all of it.

**Silent drift.** Agents don't stop when they're wrong. They work
around problems. Human gates at every phase boundary force
engagement with the actual output. Divergence detection makes
drift visible, cheap, and fixable.

---

## Quick Start

### 1. Add the skills

**Claude Code:**
```bash
cp -r skills/ ~/.claude/skills/architect-typist/
```

**Any other agent:**
The skills are plain markdown. Load them however your tool supports
persistent instructions: system prompts, context files, or paste.

### 2. Initialize

```
/as-p1-init
```

The agent scans your repo, asks questions, writes
`.state/conventions.md`.

### 3. Build something

```
/as-p2-scope for this task: add rate limiting to the API
```

Then follow the pipeline. One skill at a time. One approval at a time.

---

## The Pipeline

Ten skills. Seven form a pipeline. Three are utilities you reach for
when you need them.

```
P1 init  →  P2 scope  →  P3 design  →  P4 plan  →  P5 execute  →  P6 ship
                                              ↑
                                        P7 pivot (escape hatch)
```

Each pipeline skill reads from `.state/`, does its job, writes back
to `.state/`, and waits for the architect to approve before the next
skill runs.

```mermaid
flowchart TD
    START([Enter Repository]) --> INIT[P1 init]
    INIT -->|conventions.md| SCOPE[P2 scope]
    SCOPE -->|requirements.md| DESIGN[P3 design]
    DESIGN -->|architecture_decisions.md| PLAN[P4 plan]
    PLAN -->|execution_plan.md| EXEC[P5 execute]

    EXEC --> AUDIT{Self-Audit\nPass?}
    AUDIT -->|Yes| DONE{More\nPhases?}
    AUDIT -->|Divergence| PIVOT_Q{Architect\nDecision}

    DONE -->|Yes: new session| EXEC
    DONE -->|No| SHIP[P6 ship]

    PIVOT_Q -->|Adjust in-place| EXEC
    PIVOT_Q -->|Replan| PIVOT[P7 pivot]
    PIVOT_Q -->|Restart design| DESIGN

    PIVOT --> EXEC

    SHIP --> ARCHIVE([Archive + Commit])
```

### Pipeline Skills

| # | Skill | Slug | What it does | Produces |
|---|-------|------|-------------|----------|
| P1 | [init](skills/init.md) | `as-p1-init` | Enter the repo, learn conventions | `conventions.md` |
| P2 | [scope](skills/scope.md) | `as-p2-scope` | Debate and define what to build | `requirements.md` |
| P3 | [design](skills/design.md) | `as-p3-design` | Architect the solution, choose test strategy | `architecture_decisions.md` |
| P4 | [plan](skills/plan.md) | `as-p4-plan` | Break work into phased vertical slices | `execution_plan.md` |
| P5 | [execute](skills/execute.md) | `as-p5-execute` | Build one phase, verify, self-audit | Code + updated plan |
| P6 | [ship](skills/ship.md) | `as-p6-ship` | Verify DoD, archive state, prepare commit | Archive + staged changes |
| P7 | [pivot](skills/pivot.md) | `as-p7-pivot` | Replan when direction changes | Updated planning state |

### Utility Skills

Use these anytime, inside or outside the pipeline.

| # | Skill | Slug | What it does |
|---|-------|------|-------------|
| U1 | [orient](skills/orient.md) | `as-u1-orient` | Get your bearings in an existing workspace |
| U2 | [forge](skills/forge.md) | `as-u2-forge` | Turn a rough skill idea into a proper skill |
| U3 | [maintain](skills/maintain.md) | `as-u3-maintain` | Run structured maintenance on existing skills |

---

## How It Works

The pipeline is a conversation between two roles. The boundary is
strict.

```mermaid
sequenceDiagram
    participant A as Architect (Human)
    participant T as Typist (AI Agent)
    participant S as .state/

    Note over A,S: P1 init
    A->>T: Enter this repo
    T->>T: Scan topography
    T->>A: Questions
    A->>T: Answers
    T->>S: conventions.md

    Note over A,S: P2 scope
    A->>T: I want to build [feature]
    T->>A: Targeted questions
    A->>T: Scope decisions
    T->>S: requirements.md

    Note over A,S: P3 design
    T->>T: Scan test infrastructure
    T->>A: Architecture draft + test options
    A->>T: Revisions > Approved
    T->>S: architecture_decisions.md

    Note over A,S: P4 plan
    T->>A: Proposed execution plan
    A->>T: Adjust phase boundaries
    T->>S: execution_plan.md

    Note over A,S: P5 execute (one phase per session)
    A->>T: New session > execute
    T->>S: Read all state
    T->>T: Implement + TDD + self-audit
    alt Divergence
        T->>A: STOP - divergence report
        A->>T: Adjust / pivot / override
    end
    T->>S: Update execution_plan.md
    T->>A: Staged files + completion report

    Note over A,S: P6 ship
    T->>T: Verify DoD, run full suite
    T->>A: Diff summary + PR draft
    T->>S: Archive
    A->>T: Commit + push
```

### Who Owns What

| Action | Architect | Typist |
|--------|:---------:|:------:|
| Set direction and scope | **owns** | asks questions |
| Make architecture decisions | **owns** | proposes options |
| Approve designs and plans | **owns** | waits |
| Write code | reviews | **owns** |
| Run verification | reviews output | **owns** |
| Self-audit against the plan | reviews honestly | **owns** |
| Detect divergence and stop | can also catch | **owns** |
| Decide to pivot or continue | **owns** | recommends |
| Commit, push, create PR | **owns** | only when asked |

---

## .state/

Everything the agent needs to know lives in `.state/` at the repo
root. It survives context window wipes, session restarts, and tool
switches. The agent reads these files to rebuild understanding. It
never relies on conversation history.

| File | Written By | Read By | Purpose |
|------|------------|---------|---------|
| `resume.md` | Any skill | `orient`, then owning skill | Session handoff bookmark |
| `conventions.md` | `init` | All skills | Conventions and field notes |
| `requirements.md` | `scope` | `design` through `ship` | Approved scope and DoD |
| `architecture_decisions.md` | `design` | `plan` through `ship` | Approved technical design |
| `execution_plan.md` | `plan` | `execute`, `ship`, `pivot` | Phase-by-phase state |
| `maintain/` | `maintain` | `maintain` | Maintenance campaign memory |
| `archive/` | `ship` | Human reference | Completed work history |

### What Gets Committed

| File | Git? | Why |
|------|:----:|-----|
| `conventions.md` | **Yes** | Team-shared knowledge |
| `maintain/` | **Yes** | Repo-tracked maintenance memory |
| Everything else | No | Ephemeral or local-only |

```gitignore
.state/*
!.state/conventions.md
!.state/maintain/
!.state/maintain/**
```

---

## Guardrails

These aren't suggestions. They're embedded in the skills and enforced
by the agent.

**One phase at a time.** No parallel execution. The architect
approves before the next phase starts.

**3-Strike Rule.** Three consecutive test/build/lint failures and the
agent stops, documents the error, and waits. No brute-forcing.

**Honest Failure.** Declaring a phase FAILED is a success. The agent
caught the problem before it compounded. Hiding mistakes is the
actual failure.

**Divergence Detection.** If implementation drifts from the plan, the
agent stops and reports. It never self-corrects silently.

**Targeted Staging.** Explicit file paths only. No `git add .`.

**200-Line Conventions Cap.** The conventions file consolidates
rather than growing unbounded.

### Action Authority

| Action | Authority |
|--------|-----------|
| Read files | Autonomous |
| Write code to target files | Autonomous (current phase only) |
| Run build/test/lint | Autonomous |
| Stage files (explicit paths) | Autonomous |
| Append to conventions | Autonomous (200-line cap) |
| Update execution plan | Autonomous (status + audit) |
| Commit / Push / Create PR | **Delegated** (only when asked) |
| Create or delete branches | **Delegated** (only when asked) |
| Touch files outside target list | **Prohibited** (triggers divergence) |
| Advance to next phase | **Prohibited** (architect gates every phase) |
| Self-correct a divergence | **Prohibited** (must stop and report) |
| 4th fix attempt after 3-Strike | **Prohibited** (must stop and wait) |

---

## When Things Go Wrong

```mermaid
flowchart TD
    DETECT[Divergence detected] --> ASSESS{How deep?}

    ASSESS -->|Contained to<br/>current phase| FIX[Adjust in-place<br/>Continue execute]

    ASSESS -->|Multiple phases<br/>affected| PIVOT[Invoke pivot]
    PIVOT --> AMEND{Completed phases<br/>need fixing?}
    AMEND -->|Yes| APHASE[Amend phases: 1A, 2A...]
    AMEND -->|No| REDESIGN[Redesign remaining]
    APHASE --> RESEQ[Resequence plan]
    REDESIGN --> RESEQ
    RESEQ --> APPROVE[Architect approves]
    APPROVE --> EXEC[Resume execute]

    ASSESS -->|Fundamental<br/>approach wrong| RESTART[Restart from design]
    RESTART --> EXEC
```

---

## Commands

### Core Pipeline

Run these in order. Each one feeds the next.

| Slug | Command | What happens |
|------|---------|-------------|
| `as-p1-init` | `/as-p1-init` | Scans repo, writes `conventions.md` |
| `as-p2-scope` | `/as-p2-scope for: [describe task]` | Debates scope, writes `requirements.md` |
| `as-p3-design` | `/as-p3-design` | Drafts architecture, writes `architecture_decisions.md` |
| `as-p4-plan` | `/as-p4-plan` | Breaks into phases, writes `execution_plan.md` |
| `as-p5-execute` | `/as-p5-execute` | Builds next pending phase (one per session) |
| `as-p6-ship` | `/as-p6-ship` | Verifies DoD, archives state, stages commit |
| `as-p7-pivot` | `/as-p7-pivot because [reason]` | Replans when direction changes |

### Utilities

Use anytime.

| Slug | Command | What happens |
|------|---------|-------------|
| `as-u1-orient` | `/as-u1-orient` | Reads `.state/`, reports where you are |
| `as-u2-forge` | `/as-u2-forge on [draft]` | Audits and rewrites a rough skill |
| `as-u3-maintain` | `/as-u3-maintain on [feedback]` | Runs maintenance on existing skills |

### Habits

- Follow the pipeline in order.
- Run `/as-p5-execute` repeatedly, one phase per session.
- Use `/as-p7-pivot` instead of silently changing direction.
- Use `/as-u1-orient` when returning to a repo with existing `.state/`.

---

## See It In Action

The [tech talk](docs/tech-talk/README.md) walks through the entire
pipeline on a real codebase
([bill-splitter](https://github.com/aakarshsingh/bill-splitter)).
Four features go from empty `.state/` to shipped PR, with mocked
outputs for every skill along the way.

What it covers:

- Every pipeline skill (init through ship) with full output artifacts
- Session resume: the architect steps away mid-project, returns hours
  later, and the agent picks up with zero context loss
- A near-divergence caught by self-audit and deferred to a later phase
- A post-execution pivot where the architect finds UX problems and the
  agent generates a surgical amend phase
- Field notes discovered, tracked, and resolved across phases

---

## FAQ

**Can I skip phases?**
Yes. Hand-write `requirements.md` and jump to `plan`. The skills
communicate through files, not conversation.

**Can I use multiple AI tools?**
Yes. `.state/` is plain markdown. Start with Claude, continue with
Cursor, review with Codex.

**Context window filled up?**
New session, re-invoke `execute`. The files are the continuity
mechanism.

**Disagree with the self-audit?**
You're the architect. Override anything.

**Team use?**
`conventions.md` is committed and shared. Execution state stays
local to each developer.

---

## Project Structure

```
README.md
skills/
  init.md            P1  enter repo, learn conventions
  scope.md           P2  define what to build
  design.md          P3  architect the solution
  plan.md            P4  break into phases
  execute.md         P5  build one phase
  ship.md            P6  close the cycle
  pivot.md           P7  replan when needed
  orient.md          U1  get your bearings
  forge.md           U2  create new skills
  maintain.md        U3  improve existing skills
docs/
  tech-talk/           Full pipeline walkthrough with mocked outputs
```
