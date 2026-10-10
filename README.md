# Orchestration starter

A drop-in folder that runs a software project the way a small, strict studio would:
one **orchestrator** (the Claude Code session you talk to) plans the work, a
**builder** agent writes each change, an independent **critic** agent judges it, and
nothing lands until the checks are green and the critic says it meets the bar.

It assumes no language, platform or build tool. You describe yours in one file.

> The worked examples use a mobile Kotlin app. They are **examples — replace**.

---

## 1. Words used here

| Word | One-line meaning |
|---|---|
| Orchestrator | The main Claude Code session. Plans, launches agents, runs the checks, commits. |
| Builder | An agent that edits code for one task, in its own worktree. Never runs the build. |
| Critic | A fresh agent that reads only the diff and the bar, and returns a verdict. |
| Wave | A themed batch of work, kept in one file under `plans/`. |
| Row | One task in a wave: one module, sized to land in a day. |
| Plan section | The written spec of one row: promise, files, done-list, refusals. |
| dod | "Definition of done": the numbered list a row must meet, one test per line. |
| Lane | The build queue. One heavy build at a time, run by the orchestrator. |
| Request | A file in `lane/queue/` listing the commands one round needs. |
| Result | The file the lane writes back: `STATUS: PASS` or `FAIL`, plus logs. |
| Worktree | A separate git checkout per task, so tasks never step on each other. |
| Ruling | A decision you (the owner) made, recorded with your words and a date. |
| Oracle | A trusted reference whose output yours is compared against (optional). |

---

## 2. Start a new project

1. Copy this folder. Rename it to your project.
2. Open `project/PROJECT.md` and fill every `<placeholder>`. This is the only file you must fill.
3. Open `project/commands.env` and set your lint, test, format and build commands.
   Leave a key empty if you have no such command; the hooks then do nothing.
4. Fill `docs/direction.md` (mission, what it is, what it is not, the yardstick).
5. `git init`, commit, then open Claude Code in the folder.
6. Your first message: *"Read the project overview skill, then run the research pass."*

---

## 3. Describe the project and ask for research

The orchestrator reads `project/PROJECT.md` and `docs/direction.md` first, every session.

Ask for the **research pass** (`.claude/skills/research-pass/`). It will:

1. Read your two files and the existing code, if any.
2. List the features the product needs, grouped by theme.
3. Ask you, one line at a time, only what it cannot decide.
4. Write one wave file per theme under `plans/`, each with a row table.

You then say which wave goes first. That is a ruling; it gets recorded.

---

## 4. From research to waves, rows and plan sections

**Wave** = a theme. **Row** = one module, one day. **Plan section** = the row's spec.

Example — replace (a Kotlin mobile app):

```
plans/wave-1-login-onboarding.md

| #  | Row    | What                         | Module              | Status |
|----|--------|------------------------------|---------------------|--------|
| 1  | W1-A1  | Email sign-in screen         | :feature:auth       | OPEN   |
| 2  | W1-A2  | Password reset flow          | :feature:auth       | OPEN   |
| 3  | W1-O1  | Three-page onboarding pager  | :feature:onboarding | OPEN   |
```

The plan section for W1-A1 (example — replace):

```
## W1-A1 — email sign-in screen

Promise. A user can type an email and password and reach the home screen,
or see a message that says what was wrong and what to do.

Module. :feature:auth only.

Lands.
- SignInScreen.kt — the form, the button, the error line.
- SignInViewModel.kt — validates input, calls AuthRepository.
- SignInViewModelTest.kt — the legs below.

Dod.
1. empty_email_shows_enter_your_email — no network call is made.
2. bad_password_shows_the_reset_hint — the message names the reset link.
3. success_navigates_home — the navigation event fires once.
4. rotation_keeps_typed_email — state survives a configuration change.

Refusals. No social sign-in (that is row W1-A3). No "remember me".
Oracle. None: no reference app; the tests are the bar.
```

The full template is `plans/wave-template.md`.

---

## 5. How one task runs, brief to commit

| Step | Who | What happens |
|---|---|---|
| 1 | Orchestrator | Writes the plan section; opens a worktree for the row. |
| 2 | Builder | Gets a brief that points at the plan section by line range. Edits code. |
| 3 | Builder | Writes `lane/queue/<task>-01.request` (lint + the module's tests). Ends with `QUEUED <task>-01`. |
| 4 | Orchestrator | Runs `lane/drain.sh`. The result lands in `lane/done/`. |
| 5 | Critic | Reads the diff and the dod **while the build runs**. Never sees the builder's reasoning. |
| 6 | Builder | Fixes what failed or what the critic found; queues `-02`. |
| 7 | Orchestrator | Close: request green + critic met + commit. Flips the row to `CLOSED <sha>`. |

**Verdicts.** The critic answers with exactly one of:

- **MEETS BAR** — done.
- **BELOW BAR** — with findings marked **B** (blocker), **M** (major) or **m** (minor).

A **B** or **M** gets another round with the *same* critic. An **m** is fixed by the
builder in its next request; the orchestrator checks it at the commit. A verdict with
a condition attached ("meets bar if…") counts as BELOW BAR.

**The commit message is the record.** One paragraph: what landed, the verdict, the
lane result. No separate report files.

---

## 6. Answering the orchestrator's questions

When it needs you, it asks in **one chat line**:

```
W1-A1 q1: sign-in errors — (A) inline under the field, (B) a snackbar. I recommend (A): it stays visible.
```

Answer in a few words: *"A"*, *"go with your recommendation"*, or your own option.
Your answer becomes a ruling (section 9). While you are away, other rows keep moving.

---

## 7. Reading the status table

Twice a day (09:00 and 21:00) the orchestrator posts (example — replace):

```
| closed today               | in flight                       | lane minutes | blocked                         |
|----------------------------|---------------------------------|--------------|---------------------------------|
| W1-A1 3f2a1c, W1-O1 9b77e0 | W1-A2 (round 2), W2-P1 (critic) | 140          | W2-P2: waits for :core:network  |
```

- **closed today** — rows landed, with commit ids.
- **in flight** — rows running, and where each one is.
- **lane minutes** — build time used. Many minutes and few closes means waste.
- **blocked** — what waits, and on what.

Between tables it posts one line per close: the row, the commit, and what a user can now do.

---

## 8. Nothing is deferred

A need found during a task is **paid in that task**, or it becomes a **row of the current
wave** right away. There is no "later", no "follow-up", no "TODO for another task".
A close that leaves a note pointing at a future task is BELOW BAR.

Why: deferred notes pile up silently and nobody owns them.

---

## 9. How rulings get recorded

1. You decide something (a choice, a priority, an exception).
2. The orchestrator adds a numbered line to "Standing rulings" in
   `docs/orchestration.md`, with the date and your words quoted.
3. It adds the full entry, with the reason and evidence, to `docs/decisions.md`.
4. Old rulings are never rewritten. A change is a new ruling that names what it replaces.

---

## 10. What is in this folder

| Path | What |
|---|---|
| `project/PROJECT.md` | **You fill this.** The project's facts. |
| `project/commands.env` | Your lint / test / format / build commands. |
| `CLAUDE.md`, `AGENTS.md` | Instructions every agent reads. |
| `docs/orchestration.md` | The one page of rules. |
| `docs/direction.md`, `docs/decisions.md` | Mission; rulings ledger. |
| `docs/project-overview-template.md` | Shape of the overview the orchestrator keeps current. |
| `plans/` | Wave files and reviewer reports. |
| `lane/` | The build queue and `drain.sh`. |
| `.claude/skills/` | Procedures agents load on demand. |
| `.claude/agents/` | Builder and critic definitions. |
| `.claude/hooks/` | Guards: no direct builds, auto-format, lint at turn end. |
| `memory/` | One-fact-per-file notes the orchestrator keeps. |

---

## 11. Rules of thumb

- One module, one task. Two tasks never edit the same module at once.
- One heavy build at a time. Everything goes through the lane.
- Tests, not eyes. If a test could check it, write the test.
- Snapshot tests: create freely; never accept a changed one without a human look.
- Production-grade only. No patches, no workarounds.
