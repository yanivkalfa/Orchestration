# lane/ — the build queue

**One heavy build job at a time.** Builders never run builds or tests; they queue a request. The
orchestrator drains the queue serially. Two heavy builds at once waste the machine (or crash it),
and a build an agent ran itself is a claim nobody can check.

## Files

| Path | Who writes it | What |
|---|---|---|
| `lane/queue/<slug>-<nn>.request` | Builder (or orchestrator) | One command per line |
| `lane/done/<slug>-<nn>.result` | `drain.sh` | `STATUS:` on line 1, one `outcome:` line per command |
| `lane/done/<slug>-<nn>.<i>.log` | `drain.sh` | Full output of command `i` |
| `lane/done/<slug>-<nn>.request` | `drain.sh` | The request, moved here once run |
| `lane/lane.log` | `drain.sh` | The ledger: one START and one END line per request |

## The protocol

1. **Builder** writes `lane/queue/<slug>-<nn>.request` in the MAIN checkout with the Write tool.
2. Builder lists the file to confirm it exists, then ends its turn with exactly `QUEUED <slug>-<nn>`.
3. **Orchestrator** runs `sh lane/drain.sh` (`-n` first, to see what will run).
4. Orchestrator resumes the same builder with the `.result` path.
5. Numbers start at `01` and are never reused, even after a refusal.

## Request shape (the admitted lines)

```
# worktree: <optional absolute path; default ../<repo>-wt/<slug>, else the main checkout>
<LINT_CMD for module A>
<TEST_CMD for module A>
<one line per slow or device test the diff reaches, by name>
```

Nothing else: no full gate, no doc build, no formatter. Set `ADMIT_REGEX` in
`project/commands.env` to make `drain.sh` refuse any other line (`STATUS: REFUSED`).

Orchestrator requests are named `orch-<what>-<date>-<nn>` and run in the main checkout.

## Result shape

```
STATUS: PASS | FAIL | REFUSED
request: <slug>-<nn>
worktree: <path>
state: <HEAD sha> <checksum of the uncommitted diff>
finished: <UTC time>
commands: <n>
outcome: PASS 41s <command>  (log: <slug>-<nn>.1.log)
outcome: FAIL 63s <command>  (log: <slug>-<nn>.2.log)
--- tail of <slug>-<nn>.2.log (exit 1)
<last 30 lines>
```

Read **every** `outcome:` line, not the first few.

## Is the result still valid at the close?

```
sh lane/drain.sh --state ../<repo>-wt/<slug>
```

must print the same pair as the result's `state:` line. Different → the worktree changed after the
run → the result is STALE → queue a new request. Never close on a stale result.

## Worktrees

```
git worktree add ../<repo>-wt/<slug> -b wt/<slug>    # open, at launch
git -C ../<repo>-wt/<slug> diff HEAD --binary > ../<slug>.patch   # the close diff
git apply --index ../<slug>.patch                    # stage it in the main checkout
git worktree remove ../<repo>-wt/<slug>              # after the commit
git branch -D wt/<slug>
```

Untracked files: `git -C <worktree> add -N <file>` before taking the diff, or they are missed.

## Stuck versus working

A step with no output and no progress past its expected time is stuck: kill it, note it in the
ledger, re-queue under the next number. A step that is slow but progressing is working: never kill it.

## Lock

`drain.sh` holds `lane/.lock` (a directory) while it runs. A second drain refuses. Remove a stale
lock only when no drain process is alive.
