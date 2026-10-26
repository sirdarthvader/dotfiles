#!/usr/bin/env bash
# Delete regenerable dependencies and build output (node_modules, .next, .nx, dist, target, ...) in a project.
# Safety: only folders git ignores, never inside .claude/worktrees, and nothing at all while another
# tmux session has a pane in the tree. Run by close-project.sh (prefix Q); log: ~/.cache/project-cleanup.log
# usage: cleanup.sh [--dry-run] <dir>   (--dry-run prints what would go, with sizes)
set -euo pipefail

dry=0
if [[ ${1:-} == --dry-run ]]; then dry=1; shift; fi
dir=$(cd "$1" && pwd -P)
log=~/.cache/project-cleanup.log
names='^(node_modules|\.next|\.nx|\.turbo|dist|build|cdk\.out|coverage|target)$'

say() { if ((dry)); then echo "$*"; else echo "$(date '+%F %T') $*" >>"$log"; fi; }

if [[ $dir == "$HOME" || $dir == / ]]; then say "skip $dir: refusing home/root"; exit 0; fi
if ! git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then say "skip $dir: not a git repo"; exit 0; fi

top=$(git -C "$dir" rev-parse --show-toplevel)

# Still in use if another session has a pane below this dir (worktrees are separate trees), or above it
# within the same repo (e.g. the monorepo root while closing one of its packages).
in_use() {
  local p
  while read -r p; do
    p=$(cd "$p" 2>/dev/null && pwd -P) || continue
    if [[ ($p == "$dir" || $p == "$dir"/*) && ${p#"$dir"} != */.claude/worktrees/* ]] ||
      [[ $dir == "$p"/* && ($p == "$top" || $p == "$top"/*) ]]; then return 0; fi
  done < <(tmux list-panes -a -F '#{pane_current_path}' 2>/dev/null)
  return 1
}

if in_use; then
  if ((dry)); then echo "note: a tmux session is working in $dir, so a real run would skip it"
  else say "skip $dir: still open in another tmux session"; exit 0; fi
fi

free_kb() { df -k "$dir" | awk 'NR==2 {print $4}'; }
before=$(free_kb)
n=0
while read -r c; do
  c=${c%/}
  git -C "$dir" check-ignore -q -- "$c" || continue
  if ((dry)); then du -sh "$c"; else rm -rf -- "$c"; fi
  n=$((n + 1))
done < <(fd --hidden --no-ignore --type d --prune --exclude .git --exclude .claude/worktrees "$names" "$dir")

if ((!dry)); then say "cleaned $dir: $n folders, freed ~$((($(free_kb) - before) / 1024)) MB"; fi
