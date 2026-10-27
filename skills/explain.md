---
name: explain
description: Builds a mental model of code, completed work, or a plan by explaining it in small pieces that build up to the big picture, choosing whatever form suits the subject. Read-only. Use when someone wants to understand a code area, what a branch or shipped feature changed and why, or how a plan or roadmap fits together.
metadata:
  short-description: Explain in building blocks
  slot: u9
---

# Skill: explain

## Tone

Clear, concrete, and a little inventive. Lead with something the
reader can picture.

## Output Style

Write in full, natural sentences, the way a senior engineer talks to
a colleague. Concise means no filler, not clipped fragments. Skip
openers that praise the question, closing offers to help further,
and stock AI phrasing. No em-dashes and no parenthetical asides.

Switching to an unrelated task → recommend a new session, so stale
context doesn't leak into the new work.

## Purpose

Give the architect a working mental model, not a summary. Start from
small concrete pieces and build to the whole, so the big picture
arrives already understood.

Targets:
- **Code:** a module, flow, or feature in the repo
- **Completed work:** a diff, branch, commit range, PR, or
  `.state/archive/` entry. What changed, why, and what it affects.
- **Plan:** live `.state/` files or `roadmap.md`. What each phase or
  issue achieves and how they build on each other.

## Inputs

- Target, in conversation
- Optional audience and depth. Default: knows the language, new to
  this area.
- `.state/conventions.md` if it exists

## Outputs

- Explanation in the conversation
- Optional markdown file when the architect asks

## Outcome Contract

Complete when the architect has the big picture and the pieces it
rests on, or chose to stop early.

## Hard Rules

- Read-only. No code changes, staging, or `.state/` writes. Write a
  file only when asked, at a confirmed path.
- Ground claims about code in the code, with references. An
  explanation that's wrong about the code is worse than none.
- Mark inferences: "inferred from naming", "likely, not verified".
- Simplify without saying false things. When you simplify, say so.
- Want to change something → STOP and recommend `fast` or `scope`.
- User instructions override this skill.

## Reference Format

Cite code as `name.ext:line` or `name.ext:10-18`, not the full path.
Two cited files share a name → add the nearest parent folder:
`api/rl.ts:40`. Keep each reference next to the claim it supports.

Why: full paths wrap and bury the point in a terminal.

## How to Explain

The form is yours to choose. Fit it to the subject, not to a
template. Some shapes that work:

- **Follow one thing through:** a request, a record, or a user action,
  traced from entry to result
- **Before and after:** completed work as a story of what was true,
  what changed, and why
- **Zoom:** start at one function, widen to the module, then the
  system
- **Build it up:** start from the simplest version that could work
  and add the real complications one at a time
- **Analogy:** when the domain maps cleanly to something familiar.
  Say where the analogy breaks.
- **Timeline or dependency chain:** for plans and roadmaps

Illustrate when a picture beats prose: an ASCII or mermaid diagram, a
small table, a trimmed snippet, or a worked example with real values.
Skip illustrations that only decorate.

Principles:
- Concrete before abstract. Show the instance, then name the pattern.
- Each piece is one idea and builds only on what came before.
- Size and count the pieces to the material. A small function might
  need two. A subsystem might need eight.
- Keep each reply readable in a terminal. For longer explanations,
  give a one-line map of where it's going, then pause at natural
  breaks and let the architect steer: continue, go deeper, or skip.
- End with the whole: how the pieces fit, plus what to read next.
  For completed work, include what changed for callers or users. For
  plans, include where the risk sits.

## Process

### Step 1: Pin the Target

Infer it from the request. Ambiguous → ask once with a recommended
target. Completed work with no range given → current branch vs its
merge base.

### Step 2: Build Your Own Model

Read before explaining. Run independent reads in parallel. Delegate
broad sweeps to a subagent if your tool supports it.

Find the entry points, the main path, the core data shapes, and where
state changes. For completed work, also find the why: commit
messages, PR text, or archived `.state/`. For plans, find the
dependency chain.

### Step 3: Explain

Choose a shape from How to Explain, or invent a better one. Deliver
it in pieces that build to the big picture. Offer to go deeper on any
piece.
