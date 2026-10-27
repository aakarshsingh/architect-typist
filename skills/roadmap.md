---
name: roadmap
description: Plans work above a single feature. Estimates effort, compares design approaches, and breaks work into sized GitHub issues with dependencies, creating them with gh after approval. Also gives a quick single-task estimate to choose between fast, spike, and the full workflow. Use for estimation, epic or milestone planning, backlog breakdown, or deciding how big a task is.
metadata:
  short-description: Estimate and plan work into issues
  slot: u4
---

# Skill: roadmap

## Tone

Be extremely concise. Lead with the estimate, recommended approach,
or strongest uncertainty.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Plan work before any single feature enters the pipeline. Two modes:

- **Quick estimate:** one task. Size it and recommend the next
  motion: `fast`, spike, `scope`, or a full roadmap.
- **Roadmap:** an epic, milestone, or multi-feature goal. Compare
  design approaches, break the work into issues, estimate each, order
  by dependency, and publish to GitHub after approval.

Each roadmap issue is sized to enter the workflow on its own: one
`fast` run or one `scope` → `ship` cycle.

Doesn't write code or core workflow files. `design` and `plan` still
own file-level design and phasing per issue.

## Inputs

- Goal, task, or problem statement, in conversation
- Optional constraints: deadline, team size, non-goals
- Optional suspected files, modules, or existing issues
- `.state/conventions.md` if it exists
- `.state/roadmap.md` when resuming

## Outputs

- Quick estimate: report in the conversation. Saved to
  `.state/roadmap.md` only when asked.
- Roadmap: `.state/roadmap.md` with approach, issue breakdown,
  estimates, dependency order, and created issue numbers
- GitHub epic and issues, after explicit approval
- Optional `.state/resume.md` update when a handoff is needed

## Outcome Contract

**Quick estimate:** complete when the architect has a defensible size
with confidence, likely change areas, testing read, risks, and a
recommended next motion.

**Roadmap:** complete when the architect has approved an approach and
issue breakdown, and the issues exist on GitHub with numbers recorded
in `roadmap.md`, or as paste-ready text when `gh` is unavailable.

## Hard Rules

- No code changes. No `requirements.md`, `architecture_decisions.md`,
  or `execution_plan.md`. They belong to one active feature.
- No GitHub writes until the architect approves the exact issue set.
  Issues notify people and are visible to the team.
- Don't edit, close, relabel, or comment on existing issues unless
  asked.
- Use only labels and milestones that already exist. Ask before
  creating new ones.
- Estimates are sizes with confidence, never promises. Name what
  drives the uncertainty.
- User instructions override this skill.

## Question Rule

Check the code and `.state/` before asking. Ask only what changes the
output. At most 4 questions per turn, each with a recommended answer.
Stop asking when the remaining unknowns wouldn't change the result.
Record them as open questions instead.

## Resume Rule

Session ending before the outcome is complete → write
`.state/resume.md` with: current skill, current state, next action,
read-first files, and a resume prompt. Echo the prompt in the reply.

## Reference Format

Cite code as `name.ext:line` or `name.ext:10-18`, not the full path.
Two cited files share a name → add the nearest parent folder:
`api/rl.ts:40`. Keep each reference next to the claim it supports.

Why: full paths wrap and bury the point in a terminal.

Roadmap exception: GitHub issue bodies and the epic use
repo-relative paths, such as `src/api/rl.ts:40`. People read them in
a browser without repo context, and GitHub links them.

## Sizing Scale

Sizes map to workflow motions, so a size tells the architect what to
run next:

| Size | Meaning | Next motion |
|------|---------|-------------|
| XS | One or two files, known fix | `fast` |
| S | Small, contained, few decisions | `fast` or short pipeline |
| M | 2-4 phases | `scope` → `ship` |
| L | 5+ phases | Split before starting |
| XL | Multiple features | Roadmap mode |

Confidence: high, medium, or low, with the main driver of
uncertainty.

## Process

### Step 1: Pick Mode and Clarify

One task → quick estimate. Epic, milestone, or "break this down" →
roadmap. Unclear → ask, recommending one.

Read `.state/conventions.md` silently if it exists. `roadmap.md`
exists → resume from it and skip completed steps.

Apply the Question Rule. Common gaps: goal and success measure,
deadline, non-goals, who will do the work.

### Step 2: Survey

Read the areas the work touches. Run independent reads in parallel.
Delegate broad sweeps to subagents if your tool supports it.

Identify:
- Primary and secondary files or modules
- Configuration, schema, or migration involvement
- Integration boundaries crossed
- Test coverage near the change: present, type, gaps

Roadmap mode with `gh` available → also search open issues for
overlap: `gh issue list --search "<keywords>" --state open`.

### Step 3: Quick Estimate Report

Quick estimate mode only. Report, then STOP.

```
Estimate: [Task]

Size: [XS | S | M | L | XL], confidence [high | medium | low]
Uncertainty driver: [what would change the size]

Likely change areas:
- [file or module]: [why]

Testing:
- [coverage status, new tests needed]

Watch out for:
- [risk or gotcha]

Next motion: [fast | spike | scope | roadmap]

Summary (shareable):
[2-3 sentences for team communication]
```

### Step 4: Design Options

Roadmap mode. Present 2-3 approaches. For each: shape of the
solution, main trade-off, risk, and rough total size. Recommend one.

One obvious approach → say so and skip the comparison.

STOP until the architect picks.

### Step 5: Break Down

Split the chosen approach into issues:

- Vertical slices that deliver something verifiable, not layers
  such as "all the backend"
- Each issue size M or smaller. L → split again.
- Spike issues first for unknowns that could change the plan
- Explicit dependencies between issues

Each issue:

```markdown
### [N]. [Imperative title]

**Size:** [XS-M], confidence [high | medium | low]
**Depends on:** [issue numbers, or "none"]
**Next motion:** [fast | spike | scope]
**Labels:** [existing labels only]

**Problem:** [why this matters, 1-2 sentences]

**Scope:**
- [what's included]

**Non-goals:**
- [what's excluded]

**Acceptance criteria:**
- [ ] [verifiable criterion]

**Notes:** [likely files as repo-relative paths, risks, open
questions]
```

Acceptance criteria and non-goals use the same shape `scope` writes,
so an issue can seed `scope` directly.

### Step 6: Write Roadmap

Write `.state/roadmap.md`:

```markdown
# Roadmap: [Goal]

**Status:** Draft

## Goal
[One paragraph: outcome and success measure]

## Approach
[Chosen option, rationale, rejected alternatives in one line each]

## Order
| # | Title | Size | Depends on | GitHub |
|---|-------|------|------------|--------|

## Total
[Sum of sizes, critical path, confidence]

## Risks & Open Questions
- ...

## Issues
[Issue blocks from Step 5]
```

Present the order table and totals, not the full file. STOP until
explicit approval. Then set `**Status:** Approved`.

### Step 7: Publish

Only after approval.

1. Run `gh auth status` and `gh repo view`. Either fails → hand over
   paste-ready issue text and STOP.
2. Confirm the target repo and whether to create an epic issue.
3. Create the epic: goal, approach, and a task list of children.
4. Create issues in dependency order with `gh issue create`. Record
   each number in the `GitHub` column as it's created, so an
   interrupted run resumes without duplicates.
5. Link children to the epic as sub-issues:
   `gh api repos/{owner}/{repo}/issues/{epic}/sub_issues -F sub_issue_id={id}`.
   The id is not the issue number. Get it with
   `gh api repos/{owner}/{repo}/issues/{number} --jq .id`.
   Linking fails → keep the epic's task list as the link.
6. Update the epic task list with real numbers.

Report:

```
Roadmap: PUBLISHED

Epic: #[N] [title]
Issues: #[a], #[b], ... ([count])
Total: [size summary], confidence [level]
Start with: #[first] via [fast | spike | scope]
```

STOP and recommend the first issue's next motion.
