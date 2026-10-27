# Conventions

- **Tone:** Be extremely concise. Lead with answers, not reasoning.
  Full natural sentences, no AI-style framing.

## Project Topography

- Standalone, docs-only repo. Markdown plus one bash script.
- `skills/*.md`: 17 skills, the source of truth.
  - Pipeline: init, scope, design, plan, execute, ship, pivot.
  - Utilities: orient, fast, review, roadmap, triage, artifacts,
    forge, maintain, explain, ask.
- `scripts/sync-skills.sh`: installs skills into Claude Code. Kept
  LF by `.gitattributes`, since CRLF breaks bash.
- `README.md`: Why I Built This, Philosophy, What It Fixes, install,
  pipeline and utility tables, `.state/` table, guardrails, commands,
  Related Approaches, FAQ, project structure.
- `docs/cheatsheet.md`: quick reference for all skills.
- `docs/tech-talk/`: walkthrough on bill-splitter. `00`-`10` cover
  the pipeline, `11`-`13` cover roadmap, explain, and ask.
- `.state/`: local workflow state. Only `conventions.md` and
  `maintain/` are tracked, per `.gitignore`.
- `LICENSE`: MIT.

## Naming Conventions

- Skill files: `skills/<slug>.md`, lowercase, one word.
- Frontmatter `name:` in the repo is the bare slug. `metadata.slot`
  is `pN` for pipeline or `uN` for utility, the next free number.
- Installed name: `as-<slot>-<slug>`, such as `as-u4-roadmap`.
- Heading: `# Skill: <slug>`.
- Tech-talk files: `NN-<kebab-topic>.md`, zero-padded. Pipeline
  order first, then utilities appended.
- `.state/` files: snake_case, such as `execution_plan.md`. Maintain
  memory: `NN-<step>.md`.

## Patterns & Idioms

- Skill shape, documented in `forge`: frontmatter, `## Tone`,
  `## Output Style`, `## Purpose`, `## Inputs`, `## Outputs`, `## Outcome Contract`,
  `## Hard Rules`, shared blocks, `## Process` with `### Step N:`.
- `description`: what it does + "Use when ...". Siblings overlap →
  add "Not for X; use Y."
- Shared blocks must stay verbatim across skills:
  - `## Git Sync Rule`: init, orient, maintain. Skill exceptions go
    in a labeled paragraph after the "Why" line.
  - `## Question Rule`: design, init, maintain, pivot, plan, roadmap,
    scope.
  - `## Resume Rule`: design, execute, init, maintain, pivot, plan,
    roadmap, scope, ship. execute and ship add a skill-specific line.
  - `## Output Style`: every skill, right after `## Tone`. No word
    limits, by architect decision.
  - `## Hard Rules`: every skill. Last line: "User instructions
    override this skill."
  - `## Reference Format`: ask, explain, review, roadmap, ship,
    triage. roadmap adds a labeled exception for GitHub issue bodies.
- Each hard rule gets a short reason. Models generalize from the why.
- Uppercase only for `STOP` and `NOT` at real gates. No shouted
  emphasis.
- Handoffs: "STOP and recommend `X`". Only orient runs `init` itself.
- Inline what a skill needs. Never "same as `execute`": skills load
  alone.
- Arrow shorthand for conditions: `X → do Y`.
- Checklists use `- [ ]`. Ticks need evidence.
- Prose: full natural sentences, no word limits. No filler,
  sycophancy, or parenthetical clauses. Citations in parentheses
  are fine.
- No em-dashes and no ` - ` standing in for one. Use `:` or a new
  sentence.
- Wrap prose at about 70 columns. Tables, code, and frontmatter are
  exempt.
- Model and tool agnostic, except roadmap's `gh` use and the Claude
  Code sync script. Parallel and subagent hints say "if your tool supports
  it".
- Diagrams: mermaid in README, ASCII in cheatsheet.

## Tooling & Commands

- No build, test, lint, or CI.
- Install: `scripts/sync-skills.sh [dest]`. Smoke test:
  `scripts/sync-skills.sh "$(mktemp -d)"`.
- Em-dash check: `grep -n "—" skills/*.md README.md docs/*.md`
- Standards source: commit 977e2d7 added the writing rules.
- Long lines: `awk 'length>72 && !/^\|/' skills/*.md`
- Shared-block check: extract each `## <Block>` section, compare
  hashes across skills.
- Commits: `vN - <summary>` for releases, `chore: <summary>` for
  sweeps. Body: wrapped prose or `-` bullets.

## Field Notes

- **Ethos:** the README's four principles are the yardstick for
  every skill change. You stay in control. You drive with context.
  Trust comes from checks. Short bursts, never long runs.
- **Maintain campaigns:** closed campaigns live in
  `.state/maintain/<YYYY-MM-DD>-<slug>/`. The root holds only the
  active campaign. v4 closed 2026-10-28.
- **Source of truth:** `skills/*.md`. Install with the sync script.
  Don't edit `~/.claude/skills/` by hand.
- **Doc sync:** when a skill's contract changes, update in the same
  change: `README.md`, `docs/cheatsheet.md`, and any caller/callee
  skills. Update `docs/tech-talk/` when an output format changes.
- **Tech-talk:** matches v4 as of 2026-10-28. 11-13 cover roadmap,
  explain, and ask. Update it when a skill's output format changes.
- **Verification:** commands or concrete manual checks, each with an
  expected outcome. Manual checks cover "no testing" projects.
- **Slot u4:** reused by `roadmap` after `estimate` merged into it.
- **Plan Status:** `plan` and `pivot` write Draft. `execute` refuses
  anything not Approved.
- **Execute guards:** baseline build before changes. Only the current
  phase in the plan may change.
- **Ship archive:** `.state/archive/<YYYY-MM-DD>-<feature-slug>/`.
- **Code refs:** CLI output uses short `name.ext:line`, not full
  paths. Text read outside the CLI, such as GitHub issues, uses
  repo-relative paths.
