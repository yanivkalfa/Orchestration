# Orchestration — the one page

The ONE owner of the operating rules. `CLAUDE.md` imports this file; `AGENTS.md` holds the
mechanics (the lane, worktrees, rules in blast-radius order). Nothing binds unless this page
says it. Commands come from `project/commands.env`.

## The ten rules

1. **Tasks in flight: `<N, default 3>`, each one row on one module (or one tight module pair),
   sized to land in one day.** A row on a held module waits and launches when it frees.
   Research counts as a task. The orchestrator may raise N when the lane has room.
2. **A round's request is the project's lint and the touched modules' tests, nothing else:**
   `LINT_CMD` for each module the diff touches, `TEST_CMD` for each, plus one line per slow or
   device-bound test the diff reaches, plus one non-build line for an oracle run the row needs.
   No full gate, no doc build, no format check in a request: hooks own those.
3. **The critic reads the diff while the lane runs; a second round exists only for a B or M.**
   Round 1 is a fresh agent with the bar (the plan section's dod) and the artifact (the diff),
   never the builder's reasoning. An m is fixed in the builder's next request and checked by the
   orchestrator at the commit. B and M get unlimited rounds, the same critic resumed. Verdicts:
   MEETS BAR, or BELOW BAR with B/M/m findings. A verdict with a condition is BELOW BAR.
4. **Close = the request green, the critic met, the commit on the branch.** No extra close
   ceremony. The orchestrator reads the diff and the result itself before committing; for visual
   work it looks at the picture. The row's status cell flips to `CLOSED <sha>`.
5. **The commit message is the record.** One paragraph: what landed, the verdict, the lane result.
   Wave files hold the row table and plan sections, nothing else — no round-by-round prose.
6. **Fixtures are data.** A fixture changes when its reference is re-run and a test compares
   against it; the git diff is the receipt. No hash headers, no receipt rows, no restamps.
   Golden files are produced only by a test that reads them the same day.
7. **One module, one task.** An overlap is an owner ruling naming the exact files. Reference
   (oracle) directories are not held: a re-record is a run, not an edit.
8. **The gate is periodic: `<weekly | at each wave close>`, whichever comes first.** `GATE_CMD`
   from the main checkout over a frozen tree, plus one fresh read-only reviewer over the landings
   since the last gate (report under `plans/reviews/`). Every red is attributed by name and paid
   by its owner before the next landing; an unclaimed red is the orchestrator's.
9. **Visible progress.** One chat line per close: the row, the commit, what a user can now do.
   A table at 09:00 and 21:00: rows closed, rows in flight, lane minutes, what is blocked by what.
10. **This page is the rule stack.** A ruling is added under "Standing rulings" below; a ruling
    that would push this page past one screen is a reason to say no.

## A task, step by step

1. **Plan section.** The orchestrator writes `## <row> —` in the wave file: promise, modules,
   what lands file by file, the dod with a test per line, refusals, oracle or why none.
   Short enough to read in minutes; exact enough to build without guessing.
2. **Open and launch.** `git worktree add ../<repo>-wt/<slug> -b wt/<slug>`. Launch the builder
   with the `task-brief` skill: the plan section by line range, never prose reasoning.
3. **Lane loop.** Builder writes `lane/queue/<slug>-<nn>.request`, ends with `QUEUED <slug>-<nn>`.
   Orchestrator runs `lane/drain.sh`, resumes the builder with the `.result` path.
4. **Critic.** Launched the moment the first request is queued (`critic` skill). B/M: the
   builder fixes, the same critic re-verifies against the code. m: fixed, no second verdict.
   At the close, a fresh critic reads the final diff once.
5. **Commit and close.** Check the result was produced on the tree being committed (no edit
   after the request). Stage only the task's files from the worktree diff. Commit with the
   paragraph. Flip the row cell. Remove the worktree. Post the one chat line.
6. **Next row** launches into the freed slot: the next open row whose module is free.

## Nothing is deferred

A need found in a task is paid in that task, or becomes a row of the current wave at once.
A close whose record points at a future task ("later", "follow-up", "owed by") is BELOW BAR.

## Machine safety

One heavy job at a time through the lane; builders never build; a stuck step is killed, a
working step never; a worktree per task; `<machine-specific limits, e.g. job count>`.

## Standing rulings

Empty. Add a ruling as the next numbered line, newest last, in this shape:

```
- <n> (<YYYY-MM-DD HH:MM>): the owner ("<their exact words>") — <what is now true, in one or two
  sentences>. docs/decisions.md §<n>.
```

Rules: number in order, never renumber; quote the owner; one or two sentences here, the full
entry (reason, evidence, what it replaces) in `docs/decisions.md`; a change is a new ruling
that names the one it amends — never an edit of the old line.
