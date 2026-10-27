---
name: forge
description: Audits a rough skill draft, presents a rewrite plan, and rewrites it into the Architect-Typist house style after human approval. Use when creating a new skill from a loose idea or normalizing a draft. Not for existing-skill maintenance; use maintain.
metadata:
  short-description: Draft a new skill
  slot: u7
---

# Skill: forge

## Tone

Be extremely concise. Lead with the gap, rewrite decision, or
blocking ambiguity.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Turn a new or rough skill draft into a repo-style standalone skill,
but only after an audit and explicit human approval.

For existing-skill improvement and maintenance campaigns, use `maintain`.

This skill is standalone. No `.state/` dependency.

## Inputs

- Rough skill content, inline or as a file path
- Optional example skills to mimic
- Optional destination path

## Outputs

- Audit of the draft
- Rewrite plan
- Rewritten skill in this repo's format
- Assumptions and open questions

## Outcome Contract

Complete when the human has either an approved rewritten skill draft
or a clear audit, rewrite plan, and targeted questions that block a
safe rewrite.

Preserve the original draft's job, side-effect boundary, and scope
unless the architect approves a change. Stop before any tracked
writes until the relevant approvals are explicit.

## Hard Rules

- Preserve the draft's job, scope, and side-effect boundaries unless
  the architect explicitly asks to change them.
- Don't invent tools, approvals, files, or systems absent from the
  draft or repo context. Invented parts look real and won't work.
- Prefer operational rules over generic advice.
- Cut filler, repetition, and motivational language aggressively.
- Add sections only when they change execution behavior.
- Use concrete STOP conditions for missing inputs or unsafe actions.
- No rewrite before audit and approval. The architect owns the
  skill's contract.
- Draft too incomplete → ask targeted questions and STOP.
- Existing-skill work → redirect to `maintain`.
- User instructions override this skill.

## Repo Skill Shape

Prefer this structure unless the draft needs less:

- YAML frontmatter: `name`, `description`,
  `metadata.short-description`, `metadata.slot`. Slot is the next
  free `pN` or `uN`. The sync script installs by it.
- `# Skill: <name>`
- `## Tone`
- `## Output Style`, copied verbatim from a sibling
- `## Purpose`
- `## Inputs`
- `## Outputs`
- `## Outcome Contract`
- `## Hard Rules`: the skill's real side-effect limits, ending with
  "User instructions override this skill."
- Shared rule blocks, copied verbatim from a sibling, when they
  apply: `## Git Sync Rule`, `## Question Rule`, `## Resume Rule`
- `## Process` with `### Step N:` headings and STOP points

Writing style that current models follow well:

- Plain imperatives. Reserve uppercase for `STOP` and `NOT` at real
  gates. Shouted emphasis makes models over-apply a rule.
- Give a short reason for each hard rule. Models generalize from the
  reason when a case isn't listed.
- Each skill loads alone. Inline anything it needs instead of saying
  "same as `execute`".
- Hand off with "STOP and recommend `X`". Don't chain into another
  skill without the architect.
- Cut rules the model already follows by default.
- No em-dashes. Wrap prose near 70 columns.

## Process

### Step 1: Read the Draft

Extract: job performed, who invokes it, inputs needed, what it can
change, what it must never do, how success is reported.

### Step 2: Infer the Contract

Identify: trigger conditions, preconditions, stop conditions, output
contract, safety rules.

Critical element missing and can't infer → STOP, ask.

### Step 3: Audit

Before any rewrite:
- What's already good
- Major issues: triggering, safety, execution
- Repo patterns worth adopting
- Targeted questions needed before rewriting

### Step 4: Present Rewrite Plan

Sections to add, remove, or restructure. Patterns to reuse. Open
questions. STOP. Wait for approval.

### Step 5: Rewrite

After approval:
- Preserve workflow intent
- Tighten description for clear triggering
- Promote hidden constraints into explicit rules
- Reuse sibling skill patterns where they improve safety
- Turn loose notes into ordered steps
- Keep prose scannable
- Prefer editing existing structure over full rewrites when structure
  is sound

### Step 6: Self-Audit

Before presenting:
- [ ] Audit completed before rewriting
- [ ] Plan presented before changes
- [ ] Approval received before rewriting
- [ ] Rewrite preserves the draft's job
- [ ] Inputs and Outputs explicit
- [ ] Outcome Contract present
- [ ] Hard rules and STOP conditions visible
- [ ] Process steps ordered and executable
- [ ] Repetition and filler removed
- [ ] Description says what it does and when to use it, without
      overlapping a sibling's triggers
- [ ] Slot assigned, and the README and cheatsheet entries listed for
      the architect

Fix failures before presenting.

## Output Format

Before approval:

```text
Audit:
- ...

Rewrite plan:
- ...

Questions:
- ...
```

No questions → `Questions: None.`

After approval, present rewritten skill followed by:

```text
Major issues fixed:
- ...

Assumptions:
- ...

Open questions:
- ...
```
