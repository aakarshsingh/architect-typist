# Session Break + Resume Demo

> This scenario happens between Phase 1 and Phase 2.
> The architect needs to step away mid-session.

## The break

After Phase 1 completes and the architect commits, they say:

> "I need to step away. Let's continue later."

The agent writes `.state/resume.md`:

```markdown
# Resume State

## Current Position
- Skill: execute
- Phase 1 (Discount System): COMPLETED, committed
- Phase 2 (PDF Page Selection): PENDING, not started
- Phase 3 (Editable Date + Review Cleanup): PENDING

## Last Stable Checkpoint
Phase 1 committed. All target files staged and clean.

## Next Action
Start a new session and invoke `as-p5-execute`.
The agent will read execution_plan.md, find Phase 2 Pending,
and begin PDF page selection implementation.

## Read-First Files
1. .state/execution_plan.md (check Phase Summary for current state)
2. .state/conventions.md (has a new field note from Phase 1)
3. .state/architecture_decisions.md (Phase 2 targets and changes)

## Resume Prompt
> /as-p5-execute
> Resume: Phase 1 complete and committed. Phase 2 (PDF Page Selection)
> is next. Read .state/ files to rebuild context.
```

The agent echoes in the conversation:

```
Session saved. To resume:

/as-p5-execute
Resume: Phase 1 complete and committed. Phase 2 (PDF Page Selection)
is next. Read .state/ files to rebuild context.
```

## The resume (new session, possibly hours or days later)

The architect starts a fresh Claude Code session and types:

```
/as-p5-execute
```

The agent reads `.state/` files in order:

1. **resume.md** - sees Phase 2 is next, reads the resume prompt
2. **conventions.md** - picks up the PDF preview note from Phase 1
3. **requirements.md** - re-reads the DoD items for Phase 2
4. **architecture_decisions.md** - re-reads Phase 2 targets
5. **execution_plan.md** - confirms Phase 1 Completed, Phase 2 Pending

The agent reports:

```
Resuming. Read .state/ files.

Phase 1 (Discount System): Completed
Phase 2 (PDF Page Selection): Pending <- starting this one

Target files:
- Upload.jsx, Upload.module.css, parse.js, package.json

Pre-flight: reading target files now.
```

The session continues exactly as if there was no break. The `.state/`
files are the continuity mechanism. The conversation history from the
previous session is irrelevant.

## What this demonstrates

1. **resume.md is a bookmark, not a brain dump.** It points to the
   authoritative state files rather than repeating their content.

2. **The resume prompt is concrete.** Copy-paste it to start the next
   session. No ambiguity about where to pick up.

3. **Fresh-session discipline holds.** The new session builds context
   from files, not from memory of what happened before. Even if the
   architect uses a different AI tool or a different machine, the
   `.state/` files provide full continuity.

4. **resume.md is transient.** It exists between sessions. On
   successful ship, it gets deleted. It's never committed to git.

## If orient is used instead

The architect might not remember exactly where they left off. They
can invoke `as-u1-orient` instead:

```
/as-u1-orient
```

Orient reads `.state/resume.md` first (highest priority), then all
other state files, and produces a context report:

```
Context Status: READY

Repo Purpose
- Bill-splitting app with AI parsing

Branch / Worktree
- main, clean (Phase 1 committed)

State
- resume.md: points to Phase 2
- execution_plan.md: Phase 1 Completed, Phases 2-3 Pending
- conventions.md: 1 field note (PDF preview width)

Active Track
- Execute: Phase 2 (PDF Page Selection) is next

Key Guardrails / Notes
- Paise integers, no floats
- PDF preview iframe squeezes Review table (fix in Phase 3)

Likely Next Actions
- /as-p5-execute to start Phase 2

Open Uncertainties
- None
```

The architect now has full context and can proceed.
