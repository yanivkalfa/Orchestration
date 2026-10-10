---
name: critic
description: How to brief, resume and read the independent critic that judges a row's diff against its plan section. Use when a builder has queued its first request, when a critic returned BELOW BAR and the builder answered, when a row is about to close, or when tempted to accept a verdict with conditions attached.
---

# The critic

## The rule

The critic gets **the bar and the artifact, never the builder's reasoning.** Its value is that it
shares none of the builder's assumptions.

| Gets | Never gets |
|---|---|
| The plan section (promise, dod, refusals) by path and line range | The builder's messages or explanations |
| The diff (`git -C <worktree> diff <base>` or a patch file) | The orchestrator's opinion of the code |
| Lane results, once they exist | "It's nearly done", "only a small thing left" |

## When

1. **Round 1:** a FRESH critic (`.claude/agents/critic.md`) the moment the builder queues its
   first request. It reads while the lane runs.
2. **Later rounds (only after B or M):** the SAME critic, resumed, re-verifies against the code.
3. **At the close:** one more FRESH critic reads the final diff once. A long-running critic grows
   blind to what it already accepted.

## Brief (copy and fill)

```
You are the critic for row <ROW>.
Bar: plans/<wave file>.md lines <a>-<b>. Every dod line, every refusal, the promise.
Artifact: the diff of worktree <abs path> against <base sha>.
Rules: AGENTS.md (blast-radius order), .claude/rules/code-conventions.md.
Read only. No builds, no edits, no git writes.
Return exactly one verdict line: MEETS BAR, or BELOW BAR followed by findings.
```

## Verdict vocabulary

| Mark | Meaning | What happens |
|---|---|---|
| **B** | Blocker: wrong behaviour, broken invariant, a dod leg missing or vacuous | Another round, same critic |
| **M** | Major: a requirement gap, an untested claim, a refusal violated | Another round, same critic |
| **m** | Minor: real but small (a misleading message, a weak name in a test) | Builder fixes in next request; orchestrator checks at commit; no second verdict |

- A verdict with a condition ("meets bar if…", "once X is fixed") is **BELOW BAR**.
- Each finding: site (file and function), the claim it breaks (quote the bar), the failure
  scenario, the smallest change or test that closes it.
- No style notes (the linter owns style). No praise.

## The bar never moves

B and M rounds are unlimited. The bar is never softened to end an argument, never re-scoped to
fit the code. If the bar itself is wrong, that is an owner ruling, not a critic concession.

## What the critic checks every time

- Each dod line has a test, and that test can fail (no tautologies, no assert-on-setup).
- Nothing outside the row's modules changed.
- No note pointing at a future row ("later", "follow-up", "owed").
- No changed snapshot accepted.
- Error messages state the value and the fix.
