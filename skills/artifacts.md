---
name: artifacts
description: Drafts or updates PR titles and descriptions, Slack or email updates, and markdown documents from active work context. Use when a human or another active skill needs a paste-ready artifact built from current repo state, thread context, or explicit notes.
metadata:
  short-description: Draft work artifacts
---

# Skill: artifacts

## Tone

Artifact-first, audience-aware, and concise.

Choose the right density before drafting — aim for single-pass fit,
not a long draft followed by compression.

Default voice unless the architect overrides:
- Lead with the point, status, decision, or ask
- Use direct teammate language over polished generic prose
- Use first-person when the artifact is clearly on behalf of the author
- Structure around real working labels: `Implemented:`, `Remaining:`,
  `Next steps:`, `Observations:`
- Ask for review directly when appropriate

Explicit architect instructions on tone, audience, structure, and
length always win.

## Purpose

Generate or update communication artifacts for ongoing work.

Supported families:
- **PR** — title and description
- **Team update** — Slack message, email summary, or standup note
- **Document** — markdown document or section update

## Inputs

None required. The architect provides the artifact type and context.
Optionally reads `.state/` files if relevant to the artifact.

## Outputs

- Paste-ready or file-ready artifact in the conversation
- Optional write to a specific file if the architect asks

## Outcome Contract

Complete when the architect has a ready-to-use artifact that
accurately reflects the current work state and fits the intended
audience and channel.

Default scope: produce the artifact in conversation only.
Do not write to tracked files without explicit approval.

## Process

### Step 1: Identify Artifact Type and Audience

Ask if the type is not clear:
- PR description
- Team update (Slack, email, standup)
- Markdown document or section

Clarify audience when it affects density or technical depth.

### Step 2: Gather Context

Read relevant `.state/` files silently if present and useful:
- `requirements.md` — what was built and why
- `execution_plan.md` — which phases completed, what remains
- `architecture_decisions.md` — technical approach

Prefer explicit context the architect provides over inferred state.

### Step 3: Draft

**PR:**
```
Title: [under 72 characters, imperative mood]

## What
[1-3 sentences on what changed and why]

## How
[Key implementation decisions or approach, if non-obvious]

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
Produce the section or document in the requested format.
Match existing doc style if a reference is provided.

### Step 4: Offer Revision or Write

Present the draft. Offer to revise.

Write to a file only if the architect explicitly asks, and only with
a specific path confirmed.
