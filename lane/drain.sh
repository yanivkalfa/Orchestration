#!/bin/sh
# lane/drain.sh — runs queued build requests ONE AT A TIME. POSIX sh, no dependencies.
#
#   sh lane/drain.sh            drain every request in lane/queue/, oldest first
#   sh lane/drain.sh -n         dry run: print what would run, change nothing
#   sh lane/drain.sh --state <worktree>
#                               print the worktree's state fingerprint (compare with a result's
#                               `state:` line before closing; a mismatch means the result is STALE)
#
# Request: lane/queue/<slug>-<nn>.request, one command per line; blank lines and `#` comments
# skipped. `# worktree: <path>` overrides where it runs. Default: ../<repo>-wt/<slug> if it
# exists, else the main checkout (orchestrator requests: name them orch-<what>-<nn>).
# Result: lane/done/<slug>-<nn>.result, `STATUS: PASS|FAIL|REFUSED` on line 1, one `outcome:`
# line per command, logs beside it as <slug>-<nn>.<i>.log. Ledger: lane/lane.log.
# ADMIT_REGEX (project/commands.env), when set: every command line must match it, else REFUSED.

set -u
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/.." && pwd)
CLAUDE_PROJECT_DIR=$root
. "$root/.claude/hooks/_env.sh"
queue=$here/queue; done_dir=$here/done; ledger=$here/lane.log; lock=$here/.lock

now() { date -u +%Y-%m-%dT%H:%M:%SZ; }
secs() { date +%s; }

state_of() { # HEAD sha + checksum of tracked diff and untracked file list
  head=$(git -C "$1" rev-parse --verify -q HEAD 2>/dev/null || echo none)
  sum=$( { git -C "$1" diff HEAD --binary 2>/dev/null; git -C "$1" ls-files --others --exclude-standard 2>/dev/null; } | cksum | cut -d' ' -f1)
  printf '%s %s\n' "$head" "$sum"
}

dry=0
case "${1:-}" in
  -n|--dry-run) dry=1 ;;
  --state) [ -n "${2:-}" ] || { echo "drain: --state needs a worktree path" >&2; exit 2; }
           state_of "$2"; exit 0 ;;
  "") ;;
  *) echo "drain: unknown argument '$1' (use -n, --state <worktree>, or nothing)" >&2; exit 2 ;;
esac

if [ "$dry" -eq 0 ]; then
  mkdir "$lock" 2>/dev/null || { echo "drain: another drain holds $lock; one at a time. Remove it only if no drain is running." >&2; exit 1; }
  trap 'rmdir "$lock" 2>/dev/null' EXIT INT TERM
fi

admit=$(ps_get ADMIT_REGEX)
repo=$(basename "$root")

# Oldest first. Request names carry no spaces (<slug>-<nn>); the paths around them may.
for f in $(cd "$queue" && ls -tr -- *.request 2>/dev/null); do
  req=$queue/$f; name=${f%.request}
  slug=${name%-*}
  wt=$(sed -n 's/^#[[:space:]]*worktree:[[:space:]]*//p' "$req" | tr -d '\r' | head -n 1)
  [ -n "$wt" ] || { wt=$root/../$repo-wt/$slug; [ -d "$wt" ] || wt=$root; }
  cmds=$(grep -vE '^[[:space:]]*(#|$)' "$req" | tr -d '\r')

  if [ "$dry" -eq 1 ]; then
    printf '== %s  (in %s)\n%s\n' "$name" "$wt" "$cmds"; continue
  fi

  res=$done_dir/$name.result; tmp=$res.running
  : > "$tmp"
  status=PASS; body=""; tails=""; i=0
  echo "$(now) START $name $wt" >> "$ledger"

  if [ -n "$admit" ]; then
    bad=$(printf '%s\n' "$cmds" | grep -vE "$admit" || true)
    [ -z "$bad" ] || { status=REFUSED; body="refused: lines outside ADMIT_REGEX:
$bad"; }
  fi

  st=$(state_of "$wt")
  if [ "$status" = PASS ]; then
    # Read commands from a here-doc so a command cannot swallow the list on stdin.
    while IFS= read -r line; do
      i=$((i + 1)); log=$done_dir/$name.$i.log; t0=$(secs)
      (cd "$wt" && sh -c "$line") </dev/null > "$log" 2>&1; rc=$?
      dt=$(( $(secs) - t0 ))
      if [ "$rc" -eq 0 ]; then o=PASS; else o=FAIL; status=FAIL
        tails="$tails
--- tail of $name.$i.log (exit $rc)
$(tail -n 30 "$log")"
      fi
      body="$body
outcome: $o ${dt}s $line  (log: $name.$i.log)"
    done <<EOF
$cmds
EOF
  fi

  [ "$(state_of "$wt")" = "$st" ] || body="$body
warning: the worktree changed while the request ran; this result is STALE"
  { echo "STATUS: $status"; echo "request: $name"; echo "worktree: $wt"
    echo "state: $st"; echo "finished: $(now)"; echo "commands: $i"
    printf '%s\n' "$body"; [ -z "$tails" ] || printf '%s\n' "$tails"; } > "$tmp"
  mv "$tmp" "$res"; mv "$req" "$done_dir/$name.request"
  echo "$(now) END $name $status" >> "$ledger"
  echo "drain: $name $status -> $res"
done
