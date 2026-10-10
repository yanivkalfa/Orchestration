#!/bin/sh
# Stop hook: runs STOP_LINT_CMD (project/commands.env) when the main checkout has changed source
# files (extensions in SOURCE_EXT; any change when SOURCE_EXT is empty). Fast, text-level lint
# only — never the heavy build. A failure blocks the stop once per distinct failure (exit 2),
# so the agent fixes it in the same turn; the same failure twice is let through to avoid a loop.
# STOP_LINT_CMD empty -> no-op.
. "$(dirname "$0")/_env.sh"

lint=$(ps_get STOP_LINT_CMD)
[ -n "$lint" ] || exit 0
cd "$ps_root" || exit 0

ext=$(ps_get SOURCE_EXT)
changed=$(git status --porcelain 2>/dev/null)
[ -n "$changed" ] || exit 0
if [ -n "$ext" ]; then
  printf '%s\n' "$changed" | grep -qE "\.($ext)\"?\$" || exit 0
fi

seen=.claude/.lint-seen
out=$(sh -c "$lint" 2>&1); rc=$?
if [ "$rc" -eq 0 ]; then rm -f "$seen"; exit 0; fi

key=$(printf '%s\n' "$out" | tail -n 40)
h=$(printf '%s' "$key" | cksum | cut -d' ' -f1)
if [ -f "$seen" ] && [ "$(cat "$seen")" = "$h" ]; then exit 0; fi
printf '%s\n' "$h" > "$seen"
printf 'stop-lint: `%s` failed (exit %s); fix before ending the turn:\n%s\n' "$lint" "$rc" "$key" >&2
exit 2
