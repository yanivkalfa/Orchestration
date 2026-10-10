#!/bin/sh
# PreToolUse guard (Bash | PowerShell): heavy builds go through the lane, one at a time.
# Refuses a command that STARTS one of GUARD_PROGRAMS (project/commands.env) — at the head of
# the line or after &&, ;, | — unless it is the lane itself. Mentions inside strings pass.
# GUARD_PROGRAMS empty -> no-op.
. "$(dirname "$0")/_env.sh"

progs=$(ps_get GUARD_PROGRAMS)
[ -n "$progs" ] || exit 0

cmd=$(ps_json_field command)
[ -n "$cmd" ] || exit 0

# The lane is the sanctioned caller.
if printf '%s' "$cmd" | grep -qE '(^|&&|;|\|)[[:space:]]*(sh[[:space:]]+)?([^[:space:]]*/)?lane/drain\.sh'; then
  exit 0
fi

if printf '%s' "$cmd" | grep -qE "(^|&&|;|\|)[[:space:]]*([^[:space:];&|]*/)?($progs)([[:space:]]|\$)"; then
  cat >&2 <<'MSG'
pre-tool-guard: this command runs a heavy build directly; builds go through the lane, one at a time.
  Builder:      write lane/queue/<task>-<nn>.request (one command per line),
                end your turn with `QUEUED <task>-<nn>`; the orchestrator drains it.
  Orchestrator: run `sh lane/drain.sh` (add -n for a dry run).
  See lane/README.md.
MSG
  exit 2
fi
exit 0
