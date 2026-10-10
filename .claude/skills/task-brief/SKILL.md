---
name: task-brief
description: The shape of a builder brief and the request/QUEUED hand-back protocol. Use when launching or resuming a builder agent on a row, when a builder's first request was refused, or when a builder ran the build itself or reported QUEUED without writing the request.
---

# Builder brief

## Before launching

```
- [ ] The row's plan section exists and has a dod with a test per line
- [ ] The row's modules are free (no other open task holds them)
- [ ] Worktree opened: git worktree add ../<repo>-wt/<slug> -b wt/<slug>
- [ ] Row cell flipped to LAUNCHED
- [ ] The agent id is noted (to resume it later)
```

## The brief (copy and fill)

```
You are the builder for row <ROW> in worktree <abs path to worktree>.

Bar: plans/<wave file>.md lines <a>-<b> (the plan section). Read it first; it is the whole spec.
Also read: AGENTS.md, .claude/rules/code-conventions.md, <platform skill if code touches it>.

You may edit ONLY: <module paths>. Nothing else in the repository.
You never run the build, the tests or the linter. When the code is ready:
  1. Write lane/queue/<slug>-<nn>.request in the MAIN checkout (<abs path>), using the Write
     tool, one command per line, exactly these shapes:
       <LINT_CMD for each held module>
       <TEST_CMD for each held module>
       <one line per slow/device test the diff reaches, by name>
  2. Confirm the file exists (list it).
  3. End your turn with exactly: QUEUED <slug>-<nn>
Number <nn> from 01; never reuse a number.

A need you find outside your modules: stop and report it in one line; do not work around it.
No TODOs, no "later", no notes pointing at future rows.
```

## Resuming

Resume the SAME builder with: the `.result` path, and the critic's findings verbatim (B/M/m with
sites). Never paraphrase the critic; never pass your own theory of the failure as fact.

## Hand the builder

- The plan section by line range.
- File:line pointers to what exists.
- Results and critic findings.

## Never hand the builder

- Another builder's reasoning, or the critic's private notes.
- A softened bar ("just get the main legs green").

## Red flags in a hand-back

| Symptom | Action |
|---|---|
| `QUEUED` but no request file | Resume: write it, list it, then QUEUED. |
| The builder ran a build command | The guard should have refused; check the hook; discard the claim. |
| A request with lines outside the shape | Refuse it; resume the builder with the shape. |
| "Done" with failing legs explained away | Not done. Resume with the result. |
