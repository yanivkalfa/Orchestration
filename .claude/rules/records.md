---
paths:
  - "docs/**"
  - "plans/**"
  - "memory/**"
---

# Records

- **Decision records are append-only.** A ruling is never rewritten; a change is a new ruling that
  names the one it amends (`docs/decisions.md`).
- **Every record carries its evidence:** a commit sha, a result file, a measurement, or the owner's
  quoted words. A record without evidence is a claim, not a record.
- **Counts are read, never recalled.** Count the table before writing a number.
- **Wave files hold the row table and plan sections only.** The commit message is the record of a
  close; no per-round prose in wave files.
- **Timestamps come from git or the result file,** never from estimates.
- **No deferral words** in a record: "later", "follow-up", "owed", "TBD". A need is a row or it is
  paid now.
- **Plan sections quote what exists** (file:line). A claim about a dependency or platform is read
  from its pinned source, never inferred.
