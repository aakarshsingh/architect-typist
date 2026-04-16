---
name: forge
description: Audits a rough skill draft, presents a rewrite plan, and rewrites it into the Architect-Typist house style after human approval. Use when creating a new skill from a loose idea or normalizing a draft.
metadata:
  short-description: Draft a new skill
---

# Skill: forge

## Tone

Be extremely concise. Lead with the gap, rewrite decision, or
blocking ambiguity.

No sycophantic openers or closing fluff.
Short sentences in output (8-10 words max). No filler.
No em-dashes or replacement hyphens. No parenthetical clauses.
Output sounds human, not AI-generated.

## Purpose

Turn a rough skill draft into a repo-style standalone skill. Audit
first, plan the rewrite, get approval, then rewrite.

Not for existing-skill maintenance — that's `maintain`.

This skill is standalone. No `.state/` dependency.

## Inputs

- Rough skill content (inline or file path)
- Optional example skills to mimic
- Optional destination path

## Outputs

- Audit of the draft
- Rewrite plan
- Rewritten skill
- Assumptions and open questions

## Hard Rules

- Preserve the draft's job, scope, and side-effect boundaries unless
  architect asks to change them.
- Do NOT invent tools, approvals, files, or systems not in the draft
  or repo context.
- Prefer operational rules over generic advice.
- Cut filler, repetition, and motivational language aggressively.
- Add sections only when they change execution behavior.
- Use concrete STOP conditions for missing inputs or unsafe actions.
- Reuse proven sibling-skill patterns (Git Sync, self-audit, etc.).
- Do NOT rewrite before audit + approval.
- Draft too incomplete → ask targeted questions and STOP.
- Existing-skill work → redirect to `maintain`.
- User instructions always override this skill.
- Skip files over 100KB unless explicitly required.
- Suggest /cost when session is running long to monitor cache ratio.
- Recommend starting a new session when switching to an unrelated task.

## Repo Patterns

Prefer this shape unless the draft needs less:

- YAML frontmatter (`name`, `description`, `metadata.short-description`)
- `# Skill: <name>`
- `## Tone` (only when style affects outcomes)
- `## Purpose`
- `## Inputs`
- `## Outputs`
- Named rule sections for hard constraints
- `## Process` with numbered steps and STOP points

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
- Major issues (triggering, safety, execution)
- Repo patterns worth adopting
- Targeted questions needed before rewriting

### Step 4: Present Rewrite Plan

Sections to add/remove/restructure, patterns to reuse, open
questions. STOP. Wait for approval.

### Step 5: Rewrite

After approval:
- Preserve workflow intent
- Tighten description for clear triggering
- Promote hidden constraints into explicit rules
- Reuse sibling patterns where they improve safety
- Turn loose notes into ordered steps
- Keep prose scannable
- Prefer editing existing structure over full rewrites when structure is sound.

### Step 6: Self-Audit

Before presenting:
- [ ] Audit completed before rewriting
- [ ] Plan presented before changes
- [ ] Approval received before rewriting
- [ ] Rewrite preserves the draft's job
- [ ] Inputs and Outputs explicit
- [ ] Hard rules and STOP conditions visible
- [ ] Process steps ordered and executable
- [ ] Repetition and filler removed

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
