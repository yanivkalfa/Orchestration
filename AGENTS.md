# AGENTS.md — <project name>

<one line: what the project is>. Direction: `docs/direction.md`. Facts: `project/PROJECT.md`.
How a task runs: `docs/orchestration.md` (one page). This file holds the mechanics.

## The commands

Defined once, in `project/commands.env`. Hooks, the lane and you all run the same ones.

| Key | Meaning |
|---|---|
| `LINT_CMD` | `<lint command>` — static checks for one module (`{module}`), warnings as errors |
| `TEST_CMD` | `<test command>` — one module's tests (`{module}`) |
| `FORMAT_CMD` | `<format command>` — one edited file (`{file}`); the PostToolUse hook |
| `STOP_LINT_CMD` | `<fast text lint>` — the Stop hook, when source files changed |
| `BUILD_CMD` | `<build command>` — the heavy one; only through the lane |
| `GATE_CMD` | `<full gate command>` — everything; the periodic gate |
| `GUARD_PROGRAMS` | regex of build programs the PreToolUse guard refuses when run directly |
| `SOURCE_EXT` | regex of source extensions the format and Stop hooks watch |
| `ADMIT_REGEX` | regex every lane request line must match (optional) |

`{module}` and `{file}` are filled by the builder (in a request) or the hook. An empty key makes
its hook a no-op.

"Passed locally, failed CI" is a bug in the commands — fix them there, never by special-casing CI.

## Rules, blast-radius order

1. **`<the project's top invariant>`.** Example — replace: never break offline mode; no
   unseeded randomness and no wall-clock reads in logic that must be reproducible.
2. **The gauntlet is the method.** Builder and critic are different agents. The critic gets
   the bar and the artifact, never the builder's reasoning. One critic per task, resumed round
   to round; a fresh critic at the close. BLOCK and MAJOR rounds are unlimited; a MINOR costs
   no second verdict. The bar is never softened to end an argument. Compile, lint, tests and
   `<other hard gates>` sit beneath and are not debatable.
3. **Snapshots: create freely, NEVER accept changes.** A changed snapshot is a human-review
   moment. CI runs with snapshot updates off.
4. **Testability is a design requirement.** Every feature ships with tests an agent can run and
   read; behaviour is data-driven and queryable where possible; a human-usable surface exists.
5. **Platform code: read `.claude/skills/platform-current-apis/` first.** Training data lags
   the pinned version of `<platform / framework>`.
6. **New modules:** `<layout rule — where modules live, naming prefix, tests beside code>`.
7. **Errors are recovery scripts:** state the offending value and the fix. Every lint
   suppression carries a reason.
8. **Don't add dependencies casually.** Justify each one in the commit. `<licence or
   toolchain constraint, if any>`. A defect in a dependency is `<vendored and patched here |
   pinned and worked around by policy>` — decide once, record it as a ruling.

## Branch flow and working process

- Feature branch off `<integration branch>` → PR → `<release branch>` for releases. Never commit
  directly to `<integration branch>` or `<release branch>`.
- **Per-task loop:** research → plan section → build → lane → critic → commit.
- Production-grade only: long-term solutions, never patches or workarounds.
- Never `git commit -a`. Stage the task's files only. `<attribution trailer policy>`.

## Machine safety — the lane

ONE heavy build job at a time, enforced by a hook. **Builders never run the build or the tests.**
A builder writes `lane/queue/<task>-<nn>.request` (one command per line, the shape in
`docs/orchestration.md` rule 2) and ends its turn with `QUEUED <task>-<nn>`. The orchestrator runs
`lane/drain.sh`, which runs requests serially, each in its task's worktree, and writes
`lane/done/<task>-<nn>.result` (`STATUS: PASS|FAIL` on line 1, one outcome line per command, full
logs beside it). A stuck step (no progress past its expected time) is killed; a working step never.

**One git worktree per task:**

```
git worktree add ../<repo>-wt/<slug> -b wt/<slug>     # open
git worktree remove ../<repo>-wt/<slug>               # close, after the commit
git branch -d wt/<slug>
```

One module, one task: a module an open task holds is not edited by anyone else. An overlap is an
owner ruling naming the exact files, recorded in `docs/decisions.md`.

## Dangerous edges

- **CI workflows** (`<ci config path>`) — the trust anchor. Loosening one needs a recorded owner ruling.
- **Policy files** (`<lint config>`, `<dependency policy>`, `<other policy files>`) — never weakened to
  silence a warning; every entry is a recorded decision.
- **Decision records** (`docs/`) — append or update with evidence; never silently rewrite a decision.

## Tooling assumed on the machine

`<tool 1>`, `<tool 2>`. Missing optional tools: the hooks warn and skip; the gate requires them.
