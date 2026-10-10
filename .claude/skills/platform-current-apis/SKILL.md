---
name: platform-current-apis
description: Current API names and test idioms of the platform version this project pins, versus the renamed or removed APIs models emit from stale training data. Use when writing or reviewing code against <platform / framework>, or when code fails with "unresolved reference", "not found", "deprecated" or "no such method" errors on a name the model is sure exists. TEMPLATE — rename and fill.
---

# <platform / framework> API currency — TEMPLATE

> Rename this skill to `<platform>-current-apis`, fill the sections, and delete this box.

## Why this exists

Models learn APIs from training data that lags the version you pin. They will confidently write
names that were renamed or removed. Every entry below was **verified against the pinned source**,
not recalled.

## The pin

| Item | Value |
|---|---|
| Package / SDK | `<name>` |
| Pinned version | `<version>` |
| Where it is pinned | `<file:line, e.g. the version catalog or lock file>` |
| Where its source can be read | `<local path to the downloaded sources or docs>` |
| Last verified | `<date>` against `<version>` |

## How to add an entry

1. An agent wrote a stale name and the build or a test failed on it (evidence).
2. Find the current name in the pinned source; note `file:line`.
3. Add one row below. Old name, new name, the cited site. Nothing recalled.
4. On every version bump, re-verify every row; delete rows that no longer apply.

## Renamed or removed (stale → current)

| Stale (do not write) | Current | Verified at |
|---|---|---|
| `<old API>` | `<new API>` | `<path:line>` |

> Example — replace (Kotlin-flavoured shape only, not a claim about any version):
> `| <old lifecycle-collection call> | <current lifecycle-aware collector> | <path:line> |`

## Test idioms

- `<how a unit test sets up the framework's test harness>`
- `<how time, threads or the main loop are controlled in tests>`
- `<the one trap that makes a test pass vacuously>`

## Red flags

- A name you "remember" but cannot find in the pinned source: it is stale until proven otherwise.
- A compile error on a name you are sure of: read this table before guessing a fix.
