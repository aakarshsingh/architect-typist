# Critical Thinking

Architect-Typist is my workflow for building software with AI
agents. The idea is simple: I'm the architect and the agent is the
typist. I decide what gets built and how. The agent writes the code,
fast, but never in charge.

The first versions were all about keeping the agent in check. Every
plan needs my approval. Work moves in small phases I can actually
review. Nothing gets ticked off without evidence, and if the agent
drifts from the plan, it stops and tells me instead of quietly
working around it.

That part works. This doc is about the other half: keeping me in
check.

---

## Meet the Three Skills

- **`challenge`** questions my architecture before I commit to it.
  I sketch, it pushes back, one question at a time.
- **`defend`** checks that I understand what I just built. Three
  quick questions on the real code, at most.
- **`practice`** helps me actually learn the stack I'm building on,
  or anything else, in small back-and-forth blocks.

They're light, they talk one question at a time, and they're meant
to be fun. The rest of this doc is why they exist and how they work.

---

## Why I Needed Them

Guarding the agent isn't the same as challenging myself, and I had
to be honest about how I actually work. I push back hard at the
start of a feature. Later on, when I'm tired, I accept whatever the
agent recommends, because it's right there and it reads well. And
`explain`, the skill I built to rebuild my understanding, I'd used
properly maybe twice. All my guardrails pointed at the agent. None
pointed at me.

Then I read Addy Osmani's essay
[Critical thinking when agents do the work](https://x.com/addyosmani/status/2117512471930167377),
and it gave that drift a name. He describes three places you can sit
when you work with an agent:

- **Offloading:** you hand over the task but still own the result.
  You could explain it and defend it.
- **Deferral:** the agent's output quietly becomes your starting
  point. It stopped being a guess somewhere along the way.
- **Surrender:** the output becomes yours without a second look.

"Cognitive surrender" comes from Steven Shaw and Gideon Nave at
Wharton. Nobody jumps straight there. You read one answer carefully,
so you skim the next, and then the one after that. Then someone asks
about a line and you can't explain it, even with the agent's help.
That's the test that stuck with me: if you can't explain it, you've
given up ownership of it.

Reading it, I knew I was somewhere in deferral. These skills are my
course correction.

---

## What the Research Says

A few ideas from the research shaped everything here.

**How you use AI matters more than whether you use it.** Anthropic
ran a study in January 2026 where developers learned a Python
library they'd never used, some with AI help and some without. The
AI group learned noticeably less, and the biggest gap was in
debugging, the skill you need most when something breaks. But not
everyone lost ground. People who used the AI to understand kept
their learning: they wrote code and then asked why it worked, asked
conceptual questions, or fixed their own errors. The people who
handed over the whole task learned the least. That's where
`practice` comes from: make something yourself, then learn from the
feedback.

**Commit to your own answer first.** A 2021 study by Zana Buçinca,
Maja Malaya, and Krzysztof Gajos found that small nudges at the
moment of decision stop people from simply going along with the AI.
Asking people to give their own answer before seeing the AI's, or to
rule out an alternative, worked better than explaining the AI's
reasoning to them. That's why `challenge` has me sketch before it
says anything. It also showed that these nudges have to stay light,
or people start avoiding them, so everything here is small and easy
to skip.

**Understanding is a debt that hides.** Comprehension debt is code
that works but that nobody can explain. The tests pass and the repo
looks clean, right up until an incident or a handover needs someone
to reason about it. Osmani's essay points to a paradox from
Anthropic's research on its own engineers: supervising an agent
takes exactly the skills that leaning on it too much wears down.
That's what `defend` is for.

**You don't need to hold it all in your head.** The same essay
describes the Claude Code team rebuilding understanding on demand,
asking the agent to explain a slice when they need it. That feels
like the realistic goal: know what you don't understand, and be able
to get it back. That's where `explain` and `ask` still fit.

---

## What I Believe

**Think first.** On anything that shapes the design, I give my
answer before I see the agent's. Once you've seen a recommendation,
it's hard to unsee. Even a bad guess is useful, because it shows me
what I actually thought.

**Architecture stays mine.** However good the agent gets, deciding
what to build and how the pieces fit is my job. If my design is
weak, I want to hear it plainly, with the reason.

**Make, don't just read.** A good explanation feels like learning.
Predicting, fixing, and explaining it back is what makes it stick.

**Honesty over looking smart.** "I don't know", "I guessed", and
"I'm rusty" are good answers. They show where to look. Anything that
punishes them teaches you to fake it.

**A green check proves one thing.** Passing tests say the code does
what the tests check. They don't say I understand it, or what the
tests missed.

**Light, on by default, easy to skip.** If I have to remember a
skill, I won't use it, and if it's heavy, I'll dodge it. So the
nudges come to me, they're small, and "not now" always wins.

**Fun, not homework.** I mostly use these on personal projects where
I'm learning something new. If a skill starts feeling like a chore,
that's a reason to change it or drop it.

---

## Who Does the Thinking

The workflow has five skills that deal with understanding, and
they're easy to mix up. The difference is who's doing the thinking.

| Skill | Who talks | Job |
|-------|-----------|-----|
| `explain` | Agent → you | Builds a mental model of code, a change, or a plan for you |
| `ask` | You ask, agent answers | Q&A grounded in the code |
| `defend` | You → agent | You explain your change; it checks whether you understand it |
| `challenge` | Agent asks, you answer | Pushes on your architecture before you commit to it |
| `practice` | Back and forth | You learn or revise a concept by doing |

`explain` and `ask` rebuild understanding when you need it. The new
three make you produce it yourself.

---

## How Each One Works

All three talk in small blocks, never a wall of text. They know the
core workflow, but the workflow never calls them, so you can use
them anytime or not at all. They only read your `.state/`, and the
one file they write is `.state/learning.md`. They never approve
anything or move a phase forward.

### challenge

Think of it as a friend who reviews designs for fun. You sketch
first: the pieces, where the state lives, how data moves. Then it
pushes. Is this worth building? What's the smallest version that's
still satisfying? What can't change? Where do the pieces meet, and
what breaks there? Does this tech actually fit the design? Once
you've answered, it tells you what it would do and where you differ.

It's especially useful on a stack you don't know yet, because it
watches for habits that don't carry over. Thread-per-request thinking
on Node's event loop is a classic. It can also do a blind spot pass,
"what will bite me here?", or argue the strongest case against your
choice.

### defend

A quick check after a phase, a feature, or a shipped branch. At most
three questions on the real code: walk me through this behavior,
predict what happens in a case the tests don't cover, and what didn't
the checks prove? It backs every answer with the code, and you can
push back. Passing doesn't mean the code is right. It means you
understand it.

### practice

The broad one. It works on any topic, with or without a project.
"Java streams today" is a whole session. It adjusts to how well you
know the topic:

- **New:** it teaches a little first, starting from what you already
  know
- **Rusty:** you recall what you can, then it fills the gaps
- **Revise:** you try cold, and it only teaches what you miss
- **Project review:** what did this project actually teach you?

The exercises are small: predict the output, fix the bug, explain it
back, spot the difference, and now and then fill in one line. Hints
only come when you ask. Each block gets a light note, got it, shaky,
or with help, and a lucky guess counts as shaky. It ends with a short
summary. No points, no streaks.

---

## Using Them

After installing with `scripts/sync-skills.sh`:

```
/as-u11-challenge stage=design work=bill-splitter seen=no
/as-u12-defend stage=closeout work=bill-splitter
/as-u13-practice java streams
/as-u13-practice this project
```

Everything after the command is optional. `stage` says where you are
in the workflow and `work` names what you're working on. Leave them
out and the skill works it out, tells you what it guessed, and asks
you to confirm. `seen` only matters for `challenge`: have you already
seen a proposal? If so, it knows your answer isn't fully your own.

You don't have to remember any of this. When you return to a project
and run `orient`, it mentions the three skills once. After that it
may suggest one ready-to-run command, like `defend` after you finish
a phase, but it never runs it for you. Say "stop nudges" and it stops
for that project for good. Folders without `.state/`, like notes or
journals, never see any of it.

Each project keeps a small learning journal in `.state/learning.md`,
which stays on your machine. It tracks what you want to learn, one
line per session with how it felt, and a list of things you can now
do without AI. That list only grows when you've actually shown it.

---

## Where This Goes

These are experimental. I'm trying them first on bill-splitter, then
on my next project from start to finish. Whatever I actually use,
whatever changes how I work, and whatever stays fun gets kept. The
rest gets reworked or dropped.

The skills that earn their place will move into the core workflow
itself: answering first on design questions, `defend` offered when a
feature ships, and phases sized around how much I can really review.

---

## Sources

- [Addy Osmani, Critical thinking when agents do the work](https://x.com/addyosmani/status/2117512471930167377), the essay that started this
- [Anthropic: How AI assistance impacts the formation of coding skills](https://www.anthropic.com/research/AI-assistance-coding-skills)
- [Shen and Tamkin, arXiv 2601.20245](https://www.arxiv.org/pdf/2601.20245)
- [Buçinca, Malaya, and Gajos, To Trust or to Think, CSCW 2021](https://www.eecs.harvard.edu/~kgajos/papers/2021/bucinca2021trust.shtml)
- [Comprehension debt](https://www.oreilly.com/radar/comprehension-debt-the-hidden-cost-of-ai-generated-code/)
