---
paths:
  - "<source root glob, e.g. src/** or modules/**>"
---

# Code conventions (fill the placeholders)

- **You do not run the checks yourself.** Write a lane request (`lane/README.md`) and end your
  turn with `QUEUED <task>-<nn>`.
- **Tests live beside the code:** `<where, e.g. src/test/ next to src/main/ in each module>`.
  Slow or device-bound tests are marked `<how>` and run only by name.
- **Error messages are recovery scripts:** state the offending value AND the fix.
  Bad: `invalid input`. Good: `email "a@" has no domain; expected name@example.com`.
- **Every lint suppression carries a reason** in the project's suppression syntax.
- **Determinism (if the project needs it):** no unseeded randomness; seed every random source
  from `<the project's seed type>`. No wall-clock reads in logic that must replay; inject a clock.
- **Logging** through `<logger>`, never bare prints in shipped code.
- **Snapshots:** create new ones freely; NEVER accept a changed one.
- **Module size band:** `<e.g. 300–800 lines per file>`. Over the band: split along a real seam.
- **Named constants:** a number with a meaning gets a name at module scope and a comment saying
  where it comes from.
- **Platform APIs:** read the `platform-current-apis` skill before writing against `<platform>`.
