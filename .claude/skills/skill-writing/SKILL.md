---
name: skill-writing
description: Decides whether new knowledge becomes a skill, a CLAUDE.md line, a path-scoped rule, a hook, or a memory file — and how to write, test and maintain a skill here. Use when creating or editing any skill, when an agent repeated the same mistake twice, when a CLAUDE.md section has grown into a procedure, or when someone says "we should remember/document this".
---

# Writing skills

Skills are code: evidence-driven, minimal, tested, reviewed. Never write one for an imagined need.

## Step 0 — does this deserve to be a skill?

| It is… | It goes to… |
|---|---|
| An always-true fact needed every session | `CLAUDE.md` / `AGENTS.md` — one line |
| A convention for part of the codebase only | `.claude/rules/<topic>.md` with `paths:` globs |
| Something that must happen every time, no exceptions | **A hook.** Prose is advisory; hooks are deterministic |
| A single learned fact about this project or owner | `memory/<fact>.md` + one index line |
| A deterministic transformation | A script (inside a skill if agents trigger it) |
| A one-off, or practice the model already knows | Nothing |
| A procedure or domain knowledge needed sometimes, with evidence | **A skill** |

Evidence bar: an agent failed at this, or needed this guidance, **at least twice on real tasks**.

## Step 1 — evals before docs

1. Run ≥ 3 representative scenarios in fresh contexts WITHOUT the skill. Record the exact failures.
2. Write eval cases into the skill folder (`evals/evals.json`: query, files, expected behaviour).
3. Only then write the smallest SKILL.md that makes them pass.

## Step 2 — frontmatter

- `name`: ≤ 64 chars, lowercase-hyphens, specific (never `utils`, `helper`).
- `description`: **third person**. What it does + "Use when…" with concrete triggers: error
  strings, symptoms, file types, tool names. Describe the problem, not the workflow (agents follow
  a summary instead of reading the body). Key use case first; listings truncate.
- Side-effectful workflow → `disable-model-invocation: true`. File-scoped → `paths:`.

## Step 3 — body

- Short. Under 150 lines here; every sentence stays in context once loaded.
- Freedom matches fragility: prose for judgement, templates where a pattern exists, exact
  commands only for fragile sequences.
- Multi-step → a checklist. Quality-critical → a check-fix-repeat loop.
- One default plus an escape hatch, never a menu. One term per concept. One good example.
- No time-sensitive facts, no war stories.
- References one level deep, each linked from SKILL.md with its purpose.

## Step 4 — test with a fresh instance

- A different, fresh session works real tasks with the skill installed. Check it triggers when it
  should, does not over-trigger, and the agent applies the right part.
- Re-read a reference repeatedly → promote it into SKILL.md. Never read → delete it.
- Discipline skills get pressure tests (time pressure plus sunk cost); add every new
  rationalization to a red-flags list. No "unless it matters" clauses.
- Commit the skill and its evals together. Editing a skill also needs a failing eval first.

## Maintenance

Prune or fix a skill when it never triggers, over-triggers, its facts drifted (re-verify after
every platform upgrade), or its content became always-true (move it to CLAUDE.md or a rule).
