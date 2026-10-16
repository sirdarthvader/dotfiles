#!/usr/bin/env bash
# Toggle a scratch shell for the current project in a floating popup (prefix t, or Ctrl+` in Ghostty).
# The shell lives in a hidden "_popup_<session>" session, so it keeps running (and its
# history/output) between toggles. Pressing the key inside the popup hides it again.
# usage: popup.sh <session_name> <pane_current_path> <client_name>
set -euo pipefail
session=$1 dir=$2 client=$3

if [[ $session == _popup_* ]]; then
  tmux detach-client -t "$client"
  exit 0
fi

name="_popup_$session"
tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" -c "$dir"
tmux display-popup -c "$client" -E -w 85% -h 75% -T " $session · scratch " \
  "TMUX= tmux attach-session -t '=$name'"
