# Archive

These are the original draft files that started the Architect-Typist
workflow. They are preserved here for reference and attribution.

## Initial Motivation

The core observation: AI agents are excellent typists but unreliable
architects. They generate code fast, but left unsupervised they drift
from requirements, make silent architectural decisions, accumulate
hidden technical debt, and lose context across sessions. The more
capable the model, the more confidently it diverges.

The Architect-Typist model inverts the default. Instead of giving an
AI agent a goal and hoping for the best, the human stays in the
architect seat - defining scope, approving designs, reviewing every
phase - while the AI handles the mechanical work of writing code,
running tests, and maintaining state files.

The key insight was that **local file-based state** (`.memory/`)
solves the context continuity problem without depending on any AI
tool's built-in memory, conversation history, or session management.
When a context window fills up, you start a new session. The agent
reads `.memory/` and picks up where it left off. No information loss.

## Original Files

### `architect-typist-workflow.md`

The first draft of the workflow. Defined 5 phases (0-4):

- Phase 0: Workspace & Baseline Alignment
- Phase 1: Scope Definition
- Phase 2: Architecture & Test Strategy
- Phase 3: Execution Blueprinting
- Phase 4: The Execution Loop

Key concepts already present in the original: `.memory/` directory,
`.gitignore` protection, 3-Strike Rule, one-phase-at-a-time
execution, human-gated approval, continuous learning into the style
guide, staging-only (no agent commits).

### `skill-workbook.md`

The original prompt library with 5 skills (numbered 0-4):

- `bootstrap-context` (now `init-workspace`)
- `define-boundaries` (now `scope-work`)
- `design-system` (now `draft-design`)
- `plan-execution` (now `plan-phases`)
- `implement-phase` (now `exec-phase`)

These were raw prompts designed to be pasted into an AI chat session.

## What Changed

The original drafts went through a structured design session to reach
their current form. Here is a summary of what changed and why.

### Structural Changes

- **5 skills became 8.** Three new skills were added:
  - `wrap-up` - closes the cycle with DoD verification, integration
    check, archival, and commit preparation. The original had no
    post-execution phase.
  - `pivot-plan` - handles mid-flight replanning with amend phases
    for completed work. The original assumed a linear happy path.
  - `review-code` - standalone code review skill, independent of
    the pipeline. Usable for any code review, not just pipeline work.

- **Skills renamed.** Moved from numbered (`Skill 0`, `Skill 1`) to
  verb-noun naming (`init-workspace`, `scope-work`). Numbers implied
  rigid ordering; names communicate purpose and allow composability.

- **File templates formalized.** Each `.memory/` file now has a
  defined structure with required sections. The original left file
  format to the agent's discretion.

### Behavioral Changes

- **Honest Failure principle added.** `exec-phase` now has an
  explicit philosophy: declaring failure is success, hiding mistakes
  is failure. This didn't exist in the original.

- **Divergence Detection added.** The agent now actively monitors for
  plan drift during execution and stops when detected. The original
  had self-audit checklists but no divergence-specific escalation.

- **Completeness Rule added.** Skills that produce `.memory/` files
  now interview the architect relentlessly to fill every section,
  scaled to task complexity. The original said "ask questions" but
  didn't mandate completeness.

- **Hard approval gates added.** `draft-design` now has an explicit
  gate: the agent cannot write `architecture_decisions.md` until the
  architect says "approved." The original relied on implicit approval.

- **DoD traceability added.** `draft-design` maps every Definition of
  Done item to an architectural component. `wrap-up` verifies all DoD
  items are satisfied before closing. The original had no traceability
  mechanism.

- **Test harness evaluation made active.** `draft-design` now scans
  the codebase for test infrastructure before presenting options. The
  original said "evaluate the existing test harness" without
  specifying how.

### Operational Changes

- **`git add .` replaced with targeted staging.** All skills now use
  explicit file paths. The original allowed `git add .`.

- **Action authority model introduced.** The original prohibited all
  git operations by the agent ("Do NOT run `git commit`"). The current
  design uses a three-tier authority model: autonomous actions (read,
  write code, run tests, stage), delegated actions (commit, push,
  create PRs - only when the architect explicitly asks), and
  prohibited actions (modifying files outside target list, skipping
  approval gates, self-correcting divergences). This gives the
  architect flexibility to delegate mechanical git operations while
  keeping the safety boundary on irreversible or externally-visible
  actions.

- **Style guide capped at 200 lines.** The original had continuous
  learning but no growth limit. Now, skills consolidate rather than
  append when near the cap.

- **Selective `.gitignore`.** The original ignored all of `.memory/`.
  Now, `style_guide.md` is committed to git (team-shared knowledge)
  while execution artifacts stay local and get archived per branch.

- **Resume logic added.** `init-workspace` now detects existing
  `.memory/` state and routes the architect to the appropriate next
  skill, rather than always starting fresh.

- **Phase sizing guidance added.** `plan-phases` now has explicit
  rules of thumb (1-5 target files, split if 8+, prefer small phases)
  with an architect override clause.

- **Pivot sequencing defined.** When a pivot happens mid-execution,
  completed phases get amend phases (1A, 2A) and remaining phases
  are redesigned. The sequence is: completed → amends → redesigned.

- **Deep pivot escalation added.** If more than half the completed
  phases need amendment, `pivot-plan` recommends restarting from
  `draft-design` instead of patching.
