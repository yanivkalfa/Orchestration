# plans/ — how wave files work

| Term | Meaning |
|---|---|
| Wave | A themed batch of rows, one file: `plans/wave-<n>-<theme>.md`. |
| Row | One task: one module (or one tight pair), sized to land in a day. |
| Plan section | `## <row id> — <title>`: the row's spec, written before launch. |
| Status cell | `OPEN` → `LAUNCHED` → `CLOSED <sha>`. The orchestrator flips it. |

## A wave file holds exactly

1. A three-line header: the theme, the order rule (which rows run serially, which first).
2. The row table.
3. One plan section per row, written ahead of its launch.

Nothing else: no round-by-round prose, no statistics, no closure notes. The commit message is the
record of a close.

## Row ids

`W<wave>-<letter><n>` — the letter groups rows by area (example — replace: `A` auth, `O`
onboarding). Ids are never reused.

## Writing a plan section

Start from `plans/wave-template.md`. Every section has:

| Part | Rule |
|---|---|
| Promise | What a user or developer can do after the close that they cannot now. |
| Modules | The modules the row holds. Nothing outside them is edited. |
| What exists | File and line references the builder needs, quoted, never inferred. |
| Lands | File by file: what each new or changed file contains. |
| Dod | Numbered; ONE test per line, named; what input, what "fails today" means. |
| Refusals | What the row will NOT do, and which row owns it if any. |
| Oracle | The reference compared against, or one line on why none. |
| First request | The exact lane lines (lint + tests for the held modules). |

## Growth discipline

- A need found in a task is paid in the task, or becomes a new row in the CURRENT wave, by name.
- A row over its day runs on; it is never split to look finished, never deferred.
- When a wave's row count keeps growing, the owner may freeze it by ruling.

## Reviews

`plans/reviews/` holds one report per periodic gate. See `plans/reviews/README.md`.
