@AGENTS.md
@docs/orchestration.md

## Claude-specific extras

- **Read first in any session:** the `project-overview` skill (it reads `project/PROJECT.md`,
  `docs/direction.md` and the open wave files).
- **How a task runs is `docs/orchestration.md`**, imported above. It is the one rule stack.
- **Model on every Agent call:** `<model for builders and critics>` unless a ruling says otherwise.
- **Skills:** `project-overview` (first), `research-pass` (the first planning pass),
  `task-brief` (before launching a builder), `critic` (before launching a critic),
  `platform-current-apis` (before writing code against `<platform>`), `skill-writing`
  (before creating or editing a skill).
- **All heavy builds go through the lane** (`lane/README.md`). Builders write a request and
  end their turn with `QUEUED <task>-<nn>`; the orchestrator runs `lane/drain.sh`. The
  `PreToolUse` hook refuses `<build command>` run directly.
- **Hooks:** `PostToolUse` formats the edited file (`FORMAT_CMD`); `Stop` runs `LINT_CMD` when
  source files changed — fix its failures in the same turn. Commands live in `project/commands.env`.
- **Questions to the owner:** one chat line, options (A)/(B), a recommendation. Never a dialog.
- **Chat is terse:** speak at commits, verdicts, rulings, problems, and when asked.
- **Memory:** `memory/README.md`. One fact per file; `memory/MEMORY.md` is the index.

## Project-specific extras (fill in)

- `<extra rule 1 — e.g. a platform quirk every agent must know>`
- `<extra rule 2>`
