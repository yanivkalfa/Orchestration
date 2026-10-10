---
name: research-pass
description: Turns a filled project/PROJECT.md and docs/direction.md into wave files with row tables and the first plan sections. Use when the project has no wave files yet, when the owner asks for "the research pass", "plan the project" or "what should we build", or when a new area of the product needs its own wave.
---

# The research pass

Output: one wave file per theme under `plans/`, each with a row table, and plan sections for the
first rows. Research counts as a task; it holds no module.

## Checklist

```
- [ ] 1. Read PROJECT.md, direction.md, the existing code tree (if any)
- [ ] 2. Refuse to start while PROJECT.md has unfilled placeholders that matter
- [ ] 3. List capabilities the product needs, from the user's point of view
- [ ] 4. Read the yardstick / reference sources for what a complete product has
- [ ] 5. Group capabilities into themes → waves
- [ ] 6. Cut each wave into rows: one module, one day
- [ ] 7. Order rows: dependencies first; shared modules serial
- [ ] 8. Ask the owner only what cannot be decided, one line each
- [ ] 9. Write the wave files from plans/wave-template.md
- [ ] 10. Write plan sections for the first rows of the first wave
- [ ] 11. Report: waves, row counts (counted from the files), the proposed first wave
```

## Step 3 — capabilities

Write each as "a user can …" or "a developer can …". If it cannot be said that way, it is not a
row yet. Include the unglamorous: errors, empty states, offline, accessibility, settings, logging,
build and release.

## Step 4 — the yardstick

Compare against the reference in `docs/direction.md`. Anything the reference has and the list
lacks is either added or recorded as a non-goal in `docs/direction.md` by owner ruling.

## Step 6 — sizing a row

| Too big | Right | Too small |
|---|---|---|
| "Auth" | "Email sign-in screen" | "Add the sign-in button colour" |
| Touches 4 modules | One module, or one tight pair | Not worth a critic round |

A row has at least one dod leg a test can check. If its promise is untestable, rewrite it.

## Step 8 — asking

One chat line per question: `q<n>: <question> — (A) …, (B) …. I recommend (A): <reason>.`
Never a dialog, never a batch of ten. Make every reversible choice yourself and list it in the
report.

## Step 9 — the wave file

Header (theme, order rule), the row table, the plan sections. Status `OPEN` for every row.
Row ids `W<wave>-<letter><n>`.

## Step 10 — plan sections

Write ahead: the first open rows of the first wave are sectioned before the pass ends, so builders
can launch at once. Use `plans/wave-template.md`; every dod line names a test.

## Never

- A row that says "later", "follow-up" or "phase 2" of another row.
- A count quoted from memory: count the table.
- Planning past the owner's stated scope without a ruling.
