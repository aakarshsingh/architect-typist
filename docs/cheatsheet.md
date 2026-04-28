# Architect-Typist Cheatsheet

Quick reference for all 15 skills. Full docs in each skill file.

---

## The Rule

Human decides. Agent builds. One approval at a time.

---

## Core Pipeline

Run these in order. Each feeds the next. Each waits for architect
approval before the next starts.

```
/init → /scope → /design → /plan → /execute → /ship
                                        ↑
                                    /pivot (when needed)
```

| Skill | Invoke | Input | Output |
|-------|--------|-------|--------|
| `init` | `/init` | — | `.state/conventions.md` |
| `scope` | `/scope for: [task]` | idea | `.state/requirements.md` |
| `design` | `/design` | requirements | `.state/architecture_decisions.md` |
| `plan` | `/plan` | architecture | `.state/execution_plan.md` |
| `execute` | `/execute` (new session each time) | execution plan | code + updated plan |
| `ship` | `/ship` | completed plan | archive + staged commit |
| `pivot` | `/pivot because [reason]` | any pipeline state | updated planning state |

**Execute loops:** run `/execute` once per session, once per phase.
New session each time. The `.state/` files carry the context.

---

## Utilities

Use anytime, inside or outside the pipeline.

| Skill | Invoke | Use when |
|-------|--------|----------|
| `orient` | `/orient` | Returning to an existing workspace |
| `fast` | `/fast [task]` | Task is trivial OR feasibility unknown |
| `review` | `/review` | Code is written and needs a second look |
| `estimate` | `/estimate [ask]` | Not sure if it's trivial or large |
| `triage` | `/triage [symptom]` | Something is broken, need diagnosis |
| `artifacts` | `/artifacts [type]` | Need a PR description, team update, or doc |
| `forge` | `/forge on [draft]` | Have a rough skill idea to formalize |
| `maintain` | `/maintain on [feedback]` | Existing skill needs improvement |

---

## fast: Two Modes

**Fast Path** — you know what to do, skip formal docs:
- Good for: single bug fix, config change, narrow refactor, small test
- Not for: architecture changes, multi-file cross-cutting work

**Spike Path** — you don't know if it's feasible:
- Good for: POC, prototype, API exploration, viability check
- Not for: production implementation (spike code is disposable until promoted)

Both modes require architect approval of the in-chat plan before code is written.

---

## .state/ Files

| File | Written by | Purpose |
|------|------------|---------|
| `conventions.md` | `init` | Repo conventions, patterns, commands |
| `requirements.md` | `scope` | Approved scope + Definition of Done |
| `architecture_decisions.md` | `design` | Technical design + test strategy |
| `execution_plan.md` | `plan` | Phased implementation plan |
| `resume.md` | any skill | Session handoff bookmark |
| `estimate.md` | `estimate` | Work effort snapshot (optional) |
| `maintain/` | `maintain` | Maintenance campaign memory |
| `archive/` | `ship` | Completed work history |

**Committed:** `conventions.md`, `maintain/`
**Local only:** everything else

```gitignore
.state/*
!.state/conventions.md
!.state/maintain/
!.state/maintain/**
```

---

## Guardrails (enforced by skills)

| Rule | What it means |
|------|--------------|
| One phase at a time | Architect approves before next phase starts |
| 3-Strike Rule | 3 failures → stop, document, wait. No 4th attempt. |
| Honest Failure | Declaring FAILED is success. Hiding mistakes is failure. |
| Divergence Detection | Any drift from plan → stop and report immediately |
| Targeted Staging | Explicit paths only. Never `git add .` |
| 200-line cap | `conventions.md` consolidates rather than grows |
| No silent git ops | No commit/push/PR without explicit ask |

---

## Pivot Triggers

Invoke `/pivot` when:
- Requirements changed mid-flight
- Architecture decision is wrong
- Completed phase has a defect
- External constraint discovered

**Deep pivot rule:** If more than 50% of completed phases need
amendment or the entire test strategy must change → recommend
restarting from `design`. Architect decides.

---

## Session Habits

1. Start `execute` in a fresh session every time.
2. Write `resume.md` when closing mid-work. It points to state files —
   the next session reads files, not the summary.
3. Run `/orient` when returning to a repo after time away.
4. Check context window usage before starting a large phase. If heavy,
   start fresh.
5. One skill, one job. Don't run two pipeline skills in the same session.

---

## Quick Decision Guide

```
New feature or non-trivial task
  └─ /estimate → how complex?
        ├─ trivial        → /fast
        ├─ unknown        → /fast (spike mode)
        └─ real work      → /init → /scope → /design → /plan → /execute (×N) → /ship

Something is broken
  └─ /triage → what's the likely cause?
        ├─ small fix      → /fast
        └─ real fix       → /pivot or core pipeline

Code is written, need a check
  └─ /review

Need to communicate what was built
  └─ /artifacts

Rough skill idea
  └─ /forge

Existing skill needs fixing
  └─ /maintain
```
