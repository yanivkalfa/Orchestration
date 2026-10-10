# plans/reviews/ — the periodic reviewer's reports

Beside every periodic gate, ONE fresh, read-only reviewer reads the landings since the last gate
and writes ONE report here: `plans/reviews/<YYYY-MM-DD>-<wave or gate name>.md`. The reviewer
decides nothing. The orchestrator rules on every finding; a valid one becomes a row of the
current wave (never deferred).

## Report shape

```
# <wave/gate> — periodic review <n>

**Frozen commit: <sha>**, read from <a read-only checkout>. No builds, no git writes.

**Read.** <every file, range and record the reviewer read — enough to reproduce the review>

## Findings

1. **<CLASS> — <one-line title>.** Site: <file and heading; never a code line number>.
   Mechanism: <what is wrong and how it was found>. Closes: <the smallest row or fix that
   closes it>.

2. ...

## Ruling (written by the orchestrator under the report)

| # | Ruling | Row / commit |
|---|---|---|
| 1 | <valid → row W<n>-<id> | invalid, because ...> | <id or sha> |
```

## Finding classes

| Class | Meaning |
|---|---|
| ROW CANDIDATE | Work that belongs in a wave and has no row (a promise nobody owns). |
| RECORD FIX | A record (wave file, ruling, doc) that says something the code or git contradicts. |
| DEFECT | Code that does not do what its row, docs or commit message claim. |

## Rules

- Each finding is at most ten lines.
- Sites are files and headings, never line numbers (they move).
- No style comments, no praise. An empty list is the one line "no findings".
