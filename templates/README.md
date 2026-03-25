# Templates

These are **read-only reference copies** of the `.memory/` file
structures that the skills produce during a workflow run.

**Do not edit these files directly.** They exist so you can understand
the expected format without invoking a skill. The skills themselves
generate and populate these files in your project's `.memory/`
directory.

| Template | Produced By | Purpose |
|----------|------------|---------|
| `style_guide.md` | `init-workspace` | Codebase conventions, tooling, patterns |
| `requirements.md` | `scope-work` | Feature scope, DoD, constraints |
| `architecture_decisions.md` | `draft-design` | Technical design, test strategy |
| `execution_plan.md` | `plan-phases` | Phased implementation blueprint |
