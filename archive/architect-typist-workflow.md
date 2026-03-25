# The Architect-Typist Workflow (Universal Local State Edition)

This framework leverages AI agents (the "Typist") while keeping the human (the "Architect") in complete control of state, architecture, and version history. All context is stored locally in a `.memory/` directory. It is entirely language, framework, and structure agnostic.

## Phase 0: Workspace & Baseline Alignment
* **Objective:** Secure the local state environment and establish the repository's baseline patterns, project structure, and language idioms.
* **Action:** Trigger the agent in the repository. The agent must first create the `.memory/` directory and append it to `.gitignore` to ensure state files never leak into version control. It then analyzes the topography (e.g., monorepo, multi-module, flat structure), identifies the primary languages/build tools, and asks clarifying questions about your preferred patterns.
* **State Output:** The agent writes its findings to `.memory/style_guide.md`.

## Phase 1: Scope Definition
* **Objective:** Flexibly debate the work item to reach a rock-solid shared understanding.
* **Action:** Provide the feature idea. Guide the conversation based on task complexity. The agent must ask questions to resolve dependencies, uncover hidden edge cases, and define exact boundaries.
* **State Output:** Once alignment is reached, the agent summarizes the scope into `.memory/requirements.md`.

## Phase 2: Architecture & Test Strategy
* **Objective:** Translate requirements into a concrete technical design and establish the backpressure mechanism.
* **Action:** The agent drafts an architecture document. Crucially, it must evaluate the current testing harness and present three options: 
  1. Build a new test harness.
  2. Extend existing tests.
  3. Ignore testing (relying instead on strict compilation/linting/dry-runs).
* **The Feedback Loop:** You debate the proposed architecture and select a test strategy. The agent revises the design until explicitly approved.
* **State Output:** The final design and chosen test strategy are written to `.memory/architecture_decisions.md`.

## Phase 3: Execution Blueprinting
* **Objective:** Translate the approved architecture into a strict, self-documenting execution plan.
* **Action:** The agent generates `.memory/execution_plan.md`. If a test harness is being built or extended, this is always Step 0.
* **State Output Structure:** The document must contain:
  * **Objective:** Overall goal summary.
  * **Current Baseline:** Codebase state before changes.
  * **Rules:** * Only one phase active at a time. Wait for human approval.
    * Maintain repository style per `.memory/style_guide.md`.
    * **Passive APIs:** Make NO changes to PUBLIC APIs unless separately approved.
    * **3-Strike Rule:** If tests, builds, or lint checks fail 3 consecutive times, STOP, document the error, and wait for human help.
    * **Staging Only:** Do NOT run `git commit`. You may only stage files upon completing a phase.
  * **Phase Summary:** High-level list of phases (Pending, Active, Completed, Blocked, Failed).
  * **Detailed Phases:** Each phase includes: Header, Target Files, Status, Changes to Make, Verification Steps, Definition of Done, Self-Audit Checklist, and an empty Completion Record.

## Phase 4: The Execution Loop (Implementation & Audit)
* **Objective:** Code, verify, audit, and stage a single vertical slice.
* **Action:** Wipe the agent's context window. Trigger the agent using the execution prompt so it internalizes the local `.memory` state.
* **Workflow:**
  1. The agent fetches the next phase.
  2. It writes code. If testing was approved, it uses a Red-Green-Refactor loop. If testing was ignored, it uses compile/lint/build checks for backpressure.
  3. **Self-Audit:** It updates `.memory/execution_plan.md` (Marks Completed, ticks audit list, fills Completion Record).
  4. **Continuous Learning:** It appends newly discovered codebase quirks to `.memory/style_guide.md`.
  5. **Stage & Yield:** It stages the changes via `git add .` (or specific target files), then stops for human review and manual commit.