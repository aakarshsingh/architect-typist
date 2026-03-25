# Agent Skills (Prompt Library)

Keep these prompts handy as text snippets or CLI aliases. Use them to trigger the agent at each phase of the Architect-Typist Workflow.

## Skill 0: `bootstrap-context`
**Trigger this when starting a new project or entering a new repository.**

> Initialize in this repository. First, create a `.memory/` directory at the root and append `.memory/` to the `.gitignore` file to ensure our state does not leak into version control. Next, analyze the project topography to determine the primary programming languages, build systems, and structural paradigm (e.g., monorepo, multi-module, standalone). Scan for naming conventions and existing patterns. If you are confused by any architecture or tooling choices, ask me clarifying questions. Once we are aligned, concisely document the topography and rules in `.memory/style_guide.md`. In all our interactions moving forward, be extremely concise and sacrifice grammar for brevity.

## Skill 1: `define-boundaries`
**Trigger this when proposing a new feature, refactor, or task.**

> I want to build/execute: [Insert Idea Here]. Let's debate the scope. Ask me targeted questions to resolve dependencies and edge cases. Scale your questions based on the complexity of this feature. Once we reach a shared understanding, summarize the agreed-upon scope into `.memory/requirements.md`.

## Skill 2: `design-system`
**Trigger this after the scope boundaries are strictly defined.**

> Read `.memory/requirements.md` and `.memory/style_guide.md`. Draft a concise architecture decisions document outlining the proposed modules, data flows, and file targets. Next, evaluate the existing test harness. Based on your evaluation, ask me to choose a test strategy: 1) Build a new harness, 2) Extend existing tests, or 3) Ignore testing and rely strictly on compilation/linting. Pause and wait for my feedback. We will iterate on the architecture and test strategy until I explicitly approve. Once approved, write the final design to `.memory/architecture_decisions.md`.

## Skill 3: `plan-execution`
**Trigger this to generate the implementation blueprint.**

> Read `.memory/architecture_decisions.md`. Translate this design into a strict execution blueprint at `.memory/execution_plan.md`.
> 
> The document MUST contain these exact sections:
> 1. Objective
> 2. Current Baseline
> 3. Rules: 
>    - Only one phase active at a time. Wait for human approval to proceed.
>    - Maintain repository style per `.memory/style_guide.md`.
>    - NO changes to public APIs unless explicitly approved.
>    - 3-Strike Rule: If tests, builds, or linting fail 3 consecutive times, STOP, document the error, and wait for human help.
>    - Staging Only: Do NOT run a git commit. Only stage files when a phase is complete.
> 4. Phase Summary (Pending, Active, Completed, Blocked, Failed)
> 5. Detailed Phases: If a test harness is being built/extended, make that Phase 0. Follow with sequential vertical slices. Each phase must include: Header, Target Files, Status, Changes to Make, Verification Steps, Definition of Done, Self-Audit Checklist, and an empty Completion Record.

## Skill 4: `implement-phase`
**Trigger this ONLY AFTER WIPING THE CONTEXT WINDOW to execute a single task.**

> You are an execution agent. Before writing any code, silently read `.memory/style_guide.md`, `.memory/requirements.md`, and `.memory/architecture_decisions.md`. 
> 
> Then, read `.memory/execution_plan.md` and execute ONLY the next pending Phase. 
> 
> If testing was approved in the architecture, use a strict test-driven loop. If testing was ignored, you must run the project's native build, compilation, or linting commands to ensure your code is structurally sound.
> 
> Upon successful verification:
> 1. Update `.memory/execution_plan.md`: change the phase status to Completed, tick the self-audit list, and fill out the Completion Record with implementation notes.
> 2. Continuous Learning: If you discovered any new tooling quirks or repository patterns during this phase, append them to `.memory/style_guide.md`.
> 3. Stage the modified files using `git add .` (or equivalent targeting specific files).
> 4. STOP and wait for my review and manual commit.