#!/usr/bin/env bash
# Close a project session (prefix Q): kill it and its scratch popup, then run cleanup.sh on its
# folder in the background to delete node_modules and build output.
# usage: close-project.sh <session_name> <session_path> <client_name>
set -euo pipefail
session=$1 dir=$2 client=$3

if [[ $session == _popup_* ]]; then
  tmux display-message -c "$client" "Close the project from its own session, not the scratch popup"
  exit 0
fi

# Killing the attached session would detach the client, so move it to the most recent other session.
other=$(tmux list-sessions -F '#{session_last_attached} #{session_name}' | sort -rn | cut -d' ' -f2- |
  grep -vx -e "$session" -e '_popup_.*' | head -n 1 || true)
[[ -z $other ]] || tmux switch-client -c "$client" -t "=$other"

# Detached (nohup) so it survives the tmux server exiting when this was the last session;
# it waits for the session to be gone so cleanup.sh doesn't see its panes as "in use".
nohup bash -c 'while tmux has-session -t "=$1" 2>/dev/null; do sleep 0.2; done; exec "$2" "$3"' \
  _ "$session" ~/.config/tmux/cleanup.sh "$dir" >/dev/null 2>&1 &

tmux kill-session -t "=_popup_$session" 2>/dev/null || true
tmux kill-session -t "=$session"
