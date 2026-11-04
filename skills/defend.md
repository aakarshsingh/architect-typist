---
name: defend
description: Checks that the architect understands work just finished through the workflow, with at most three short questions on the real code, plus what the checks didn't prove. Light and read-only. Use after a phase, feature, or shipped branch, before approving or moving on. Not for finding bugs; use review. Not for learning concepts; use practice.
metadata:
  short-description: Explain your change back
  slot: u12
---

# Skill: defend

## Tone

Friendly and direct. Lead with the first question.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

You should be able to stand behind what you ship. Passing checks
show the code does one thing. They don't show you understand it.
`defend` asks up to three small questions on the real code, so a gap
shows up now rather than in an incident.

Passing a defend doesn't certify the code is correct. It shows the
architect understands it.

This skill knows the core workflow, but the core workflow never
calls it. It reads core state for context and writes only the
learning journal.

## Inputs

- Target: a phase, feature, branch, commit range, or files
- Optional context header: `stage=closeout work=<id or name>`
- Live `.state/` files, if present
- The diff, the surrounding code, tests, and raw verification output

## Outputs

- Questions and feedback in the conversation, with references
- A short result
- When `.state/` exists: a journal row, and gaps offered as practice
  items in `.state/learning.md`

## Outcome Contract

Complete when up to three questions are answered, skipped, or
stopped, and the architect has: what they explained well, what they
missed, one property the checks didn't prove, any possible defect,
and gaps offered as practice items.

## Hard Rules

- Read-only on code and core state. Write only `.state/learning.md`.
  Never approve, stage, commit, or advance a phase. A defend informs
  the architect's approval. It isn't one.
- Ask from the actual code and raw verification output, never from
  completion summaries. A summary repeats what the author believed.
- At most three questions, one per turn. Light is the point. A long
  defend becomes a chore that gets skipped.
- Every assessment cites `file:line` or command output. The
  architect can contest any of them. Re-check against the code, and
  change your view when they're right.
- The unfamiliar scenario must be one the tests don't cover. Read
  the tests first.
- A wrong prediction may expose a real bug. Report it as a possible
  defect and recommend `fast` or `pivot`. Don't fix it.
- "I don't know" is a fine answer. Give the explanation, mark the
  question with help, and move on.
- "Not now" ends it at once. Log it as skipped.
- User instructions override this skill.

## Reference Format

Cite code as `name.ext:line` or `name.ext:10-18`, not the full path.
Two cited files share a name → add the nearest parent folder:
`api/rl.ts:40`. Keep each reference next to the claim it supports.

Why: full paths wrap and bury the point in a terminal.

## Context Header

`stage=<execute|closeout|wrap-up|standalone> work=<id or name>`

Missing fields → infer from the conversation and `.state/`, state
what you inferred, and ask the architect to confirm.

## Stage Map

The core workflow runs scope, design, plan, execute, then ship. Use
it to find the target:

- A phase just Completed in `execution_plan.md` → that phase's diff,
  target files, and verification output
- Work shipped → the branch against its merge base, plus the archive
  entry for intent
- No `.state/` → the named branch, commit range, or files

## Learning Journal

`.state/learning.md` is local and uncommitted under the default
`.gitignore`. Missing and `.state/` exists → create it:

```markdown
# Learning: [project]

nudges: on

## Want to Learn

## Journal
| Date | Skill | What | Ran/Skipped | Changed | Felt |
|------|-------|------|-------------|---------|------|

## Can Now Do Without AI
```

- `Changed`: understanding, design, code, tests, or nothing
- `Felt`: fun, ok, or chore
- Leave the `nudges:` line as it is. `orient` owns it.
- No `.state/` → skip the journal.

## Process

### Step 1: Pin the Target

Use the context header or the request. Neither → the most recent
Completed phase, else the current branch against its merge base.
State the target and confirm.

### Step 2: Read

Read the diff, the code it touches, the tests, and the raw
verification output. Pick three things:
- One behavior that matters
- One scenario the tests don't cover
- One property the checks don't prove

### Step 3: Ask

One question per turn, up to three. Use whichever format fits:
- **Teach it back:** "Walk me through what happens when..."
- **Predict:** "In this untested case, what does the user see?"
- **Spot the difference:** the shipped version against a plausible
  alternative. "Why this one?"

The last question is always: "What didn't the checks prove?" Then
compare their answer with yours.

### Step 4: Feedback

After each answer, give short feedback with references. Note it: got
it, shaky, or with help.

### Step 5: Result

```text
Defend: [target]
Explained well: ...
Missed: ...
Checks didn't prove: [yours] / [theirs]
Possible defects: [or none]
Practice items: [gaps offered]
```

Offer each gap as a practice item. On yes, add it to Want to Learn
marked "from defend". A gap about how this code works, not a concept
→ recommend `explain` on that piece instead. Append a Journal row.
Ask how it felt in one word.
