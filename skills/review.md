---
name: review
description: Performs independent code review with severity-ranked findings and a clear verdict. Accepts staged, unstaged, branch, commit-range, or file-based diff targets. Use inside or outside the main workflow whenever a review is needed.
metadata:
  short-description: Review a diff
  slot: u3
---

# Skill: review

## Tone

Be extremely concise. Lead with the finding.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Independent code review. Verified, severity-ranked findings with a
clear verdict.

Applies `.state/conventions.md` when present. Doesn't depend on it.

## Inputs

None required. The architect may name a target:

- staged changes
- unstaged changes
- all uncommitted changes
- `git diff <base>...HEAD`
- a commit range
- specific file paths

## Outputs

- Review scope and effective diff boundary
- Severity-ranked findings with `file:line` references
- Missing-test or verification-risk notes when material
- Clear verdict
- Open questions for unconfirmed concerns

## Outcome Contract

Complete when the review target has been inspected and the reply
leads with verified findings ordered by severity, or states that no
issues were found.

## Hard Rules

- Read-only. No code changes, staging, or commits unless asked.
- Report a finding only after confirming it against the surrounding
  code. A plausible but wrong finding costs the architect more than a
  missed nit.
- Concern you can't confirm → list it under open questions, not as a
  finding.
- Don't invent problems to fill the report.
- User instructions override this skill.

## Reference Format

Cite code as `name.ext:line` or `name.ext:10-18`, not the full path.
Two cited files share a name → add the nearest parent folder:
`api/rl.ts:40`. Keep each reference next to the claim it supports.

Why: full paths wrap and bury the point in a terminal.

## Severity Levels

- **CRITICAL:** correctness bug, security vulnerability, data loss
  risk, or broken contract
- **HIGH:** likely incorrect behavior, missing error handling, or
  performance regression
- **MEDIUM:** maintainability issue, unclear naming, or test gap
- **LOW:** style, minor clarity, or suggestion

## Process

### Step 1: Establish Scope

No target named → pick the first non-empty of: staged, unstaged,
current branch vs its merge base. State which one you chose.

Show the effective boundary: base commit, file list, or scope.

Read `.state/conventions.md` silently if it exists. Active
`execution_plan.md` → also check changes against the phase's target
files.

### Step 2: Review

Read the diff, then the surrounding code it depends on: callers,
callees, types, and tests. Run independent reads in parallel. Large
diff → split by area and delegate to subagents if your tool supports
it.

Look for:
- Correctness and logic errors
- Security issues: injection, secrets in code, unvalidated input
- Missing error handling at boundaries
- Test gaps for changed behavior
- Convention and pattern violations

### Step 3: Verify Findings

For each candidate, confirm it with the code: trace the input, check
the caller, or read the test. Drop it or move it to open questions if
it doesn't hold.

### Step 4: Report

```text
Review Scope: [staged | unstaged | git diff ... | files: ...]

[CRITICAL] file.ts:42: [issue and why it breaks]
[HIGH]     file.ts:87: [issue]
[MEDIUM]   other.ts:12: [issue]
[LOW]      other.ts:55: [issue]

Verdict: [APPROVE | APPROVE WITH NOTES | REQUEST CHANGES]

Open questions:
- ...
```

No findings → say so explicitly.

### Step 5: Learning

Durable pattern worth capturing → offer to append it to
`conventions.md` under "Field Notes". Write only with explicit
approval.
