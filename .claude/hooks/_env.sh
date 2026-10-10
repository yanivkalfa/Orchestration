# Shared helper for the hooks and the lane. Sourced, never run.
# Reads KEY=value from project/commands.env WITHOUT executing the file
# (values hold spaces and {placeholders}). An absent file or key gives "".

ps_root=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}
ps_env_file="$ps_root/project/commands.env"

# ps_get KEY  -> prints the value of KEY (last definition wins), or nothing.
ps_get() {
  [ -f "$ps_env_file" ] || return 0
  sed -n "s/^$1=//p" "$ps_env_file" | tr -d '\r' | tail -n 1
}

# ps_json_field NAME  -> first string value of "NAME" in the JSON on stdin.
# Good enough for hook payloads; unescapes \" and turns \\ into /.
ps_json_field() {
  sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\(\(\\\\.\|[^\"\\\\]\)*\)\".*/\1/p" |
    head -n 1 | sed 's/\\\\/\//g; s/\\"/"/g'
}
