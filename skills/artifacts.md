---
name: artifacts
description: Drafts or updates PR titles and descriptions, Slack or email updates, and markdown documents from active work context. Use when a human or another active skill needs a paste-ready artifact built from current repo state, thread context, or explicit notes.
metadata:
  short-description: Draft work artifacts
  slot: u6
---

# Skill: artifacts

## Tone

Artifact-first, audience-aware, and concise.

Choose the right density before drafting. Aim for a single-pass fit,
not a long draft followed by compression.

Default voice unless the architect overrides:
- Lead with the point, status, decision, or ask
- Direct teammate language over polished generic prose
- First person when the artifact is on behalf of the author
- Real working labels: `Implemented:`, `Remaining:`, `Next steps:`,
  `Observations:`
- Ask for review directly when appropriate

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Generate or update communication artifacts for ongoing work.

Supported families:
- **PR:** title and description
- **Team update:** Slack message, email summary, or standup note
- **Document:** markdown document or section update

## Inputs

None required. The architect gives the artifact type and context.
Reads `.state/` files when relevant.

## Outputs

- Paste-ready artifact in the conversation
- Optional file write when the architect asks

## Outcome Contract

Complete when the architect has a ready-to-use artifact that matches
the current work state and fits the audience and channel.

## Hard Rules

- Output goes in the conversation. Write to a file only when asked,
  at a confirmed path.
- Don't post, send, or open PRs. The architect publishes.
- Every claim must match the repo or `.state/`. Don't describe tests
  that weren't run or work that isn't done.
- User instructions override this skill.

## Process

### Step 1: Identify Type and Audience

Infer the type from the request. Unclear → ask, with a recommended
type.

Clarify the audience only when it changes density or technical depth.

### Step 2: Gather Context

Read silently when present and useful:
- `requirements.md`: what was built and why
- `execution_plan.md`: completed phases and what remains
- `architecture_decisions.md`: technical approach
- The branch diff and commit log

Explicit context from the architect wins over inferred state.

### Step 3: Draft

**PR:**
```
Title: [under 72 characters, imperative mood]

## What
[1-3 sentences on what changed and why]

## How
[Key implementation decisions, if non-obvious]

## Testing
[What was tested and how]

## Checklist
- [ ] Tests pass
- [ ] No hardcoded secrets
- [ ] Docs updated if needed
```

**Team update:**
```
[Status: In progress | Done | Blocked]

What I did:
- ...

What's next:
- ...

Blockers:
- [or "None"]
```

**Document:**
Produce the section or document in the requested format. Match the
style of any reference provided.

### Step 4: Revise or Write

Present the draft. Offer to revise. Write to a file only on explicit
request with a confirmed path.
