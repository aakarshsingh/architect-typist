---
name: review
description: Performs independent code review with severity-ranked findings and a clear verdict. Accepts staged, unstaged, branch, commit-range, or file-based diff targets. Use inside or outside the main workflow whenever a review is needed.
metadata:
  short-description: Review a diff
---

# Skill: review

## Tone

Be extremely concise. Lead with the finding.

## Purpose

Independent code review. Structured, severity-ranked findings with a
clear verdict.

Reads `.state/conventions.md` when present and applies project
conventions. Does not depend on it.

## Inputs

None required — gathers its own context. The architect may provide
an exact review target up front:

- staged changes
- unstaged changes
- all uncommitted changes
- `git diff <base>...HEAD`
- a commit range
- specific file paths

If no target is provided, ask.

## Outputs

- Findings-first review report in the conversation
- Review scope and effective diff boundary
- Severity-ranked findings with file/line references
- Missing-test or verification-risk notes when material
- Clear verdict
- Open questions or residual risk when needed

## Outcome Contract

Complete when the effective review target has been inspected and the
conversation leads with actionable findings ordered by severity, or
states clearly that no issues were found.

Default write scope: the review report only. Do not modify code,
stage, or commit unless explicitly asked.

## Severity Levels

- **CRITICAL** — correctness bug, security vulnerability, data loss
  risk, or broken contract
- **HIGH** — likely incorrect behavior, missing error handling,
  performance regression
- **MEDIUM** — maintainability issue, unclear naming, test gap
- **LOW** — style, minor clarity, or suggestion

## Process

### Step 1: Establish Scope

If no target was provided, ask the architect.

Run the appropriate diff command. Show the effective boundary
(base commit, file list, or scope) before reviewing.

Read `.state/conventions.md` silently if it exists.

### Step 2: Review

Inspect the diff for:
- Correctness and logic errors
- Security issues (injection, secrets in code, unvalidated input)
- Missing error handling at boundaries
- Test coverage gaps for changed behavior
- Violations of conventions or patterns

### Step 3: Report Findings

Lead with findings, not summary. Format:

```text
Review Scope: [staged | unstaged | git diff ... | files: ...]

[CRITICAL] file.ts:42 — [description of issue]
[HIGH]     file.ts:87 — [description of issue]
[MEDIUM]   other.ts:12 — [description of issue]
[LOW]      other.ts:55 — [description of issue]

Verdict: [APPROVE | APPROVE WITH NOTES | REQUEST CHANGES]

Open questions:
- ...
```

No findings → state it explicitly. Do not invent problems.

### Step 4: Learning (optional)

If the review surfaces a durable pattern worth capturing, offer to
append it to `.state/conventions.md` under "Field Notes."

Do NOT write to `conventions.md` without explicit architect approval.
