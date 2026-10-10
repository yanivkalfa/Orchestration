#!/bin/sh
# PostToolUse (Edit | Write): formats the edited file with FORMAT_CMD from project/commands.env,
# replacing {file} with the edited path. Only files whose extension matches SOURCE_EXT (when set).
# FORMAT_CMD empty -> no-op. A formatter failure is reported, never blocks.
. "$(dirname "$0")/_env.sh"

fmt=$(ps_get FORMAT_CMD)
[ -n "$fmt" ] || exit 0

file=$(ps_json_field file_path)
[ -n "$file" ] && [ -f "$file" ] || exit 0

ext=$(ps_get SOURCE_EXT)
if [ -n "$ext" ]; then
  printf '%s' "$file" | grep -qE "\.($ext)\$" || exit 0
fi

# {file} becomes "$PS_FILE", so any path (spaces, quotes) reaches the formatter intact.
run=$(printf '%s' "$fmt" | sed 's/{file}/"$PS_FILE"/g')

out=$(cd "$ps_root" && PS_FILE=$file sh -c "$run" 2>&1) || {
  printf 'post-edit-format: `%s` failed on %s:\n%s\n' "$fmt" "$file" "$(printf '%s\n' "$out" | tail -n 20)" >&2
}
exit 0
