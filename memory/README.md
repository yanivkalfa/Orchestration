# memory/ — what the orchestrator learns

One fact per file. `memory/MEMORY.md` is the index: one line per file, under ~200 characters.
Keep the index short; it is loaded every session. Detail lives in the file, not the index line.

> If your Claude Code setup keeps auto-memory outside the repository, use the same convention
> there; this folder is for facts you want versioned with the project.

## When to write one

- The owner corrected the orchestrator, and the correction will apply again.
- A mistake cost a round, and a one-line rule prevents it.
- A fact about the project or the machine that is not derivable from the code.

Not for: things already in `AGENTS.md`, `CLAUDE.md` or a skill; one-off events; anything a test
could enforce (write the test, or a hook).

## File shape

`memory/<short-kebab-name>.md`:

```
---
name: <short-kebab-name>
description: "<one sentence: the rule and the evidence that it matters>"
type: <feedback | fact | procedure | preference>
---

<The rule, in one or two sentences.>

**Why:** <what went wrong, or what the owner said, quoted>.

**How to apply:** <the concrete check or step>.
```

## Index line shape

```
- [<Title>](<file>.md) — <the rule in a few words>
```

## Maintenance

- A memory that keeps proving true and applies every session graduates to `CLAUDE.md` or a hook
  (see the `skill-writing` skill) and its file is deleted.
- A memory that turned false is deleted, not left with a note.
- An index over ~25 KB is too long: shorten lines, merge related facts.
