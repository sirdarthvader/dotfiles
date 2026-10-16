#!/usr/bin/env bash
# Claude Code hook (Notification, Stop): mark the tmux window in the status bar
# when you aren't looking at it, and send a macOS notification when Ghostty
# isn't the frontmost app.
input=$(cat)
event=$(jq -r '.hook_event_name // empty' <<<"$input")
type=$(jq -r '.notification_type // empty' <<<"$input")

# The 60s "still waiting" reminder repeats what Stop already reported.
[[ $type == idle_prompt ]] && exit 0

if [[ $event == Stop ]]; then
  icon="✓" msg="Finished"
else
  icon="●" msg=$(jq -r '.message // "Needs your input"' <<<"$input")
fi
title="Claude"

if [[ -n ${TMUX_PANE:-} ]]; then
  # Mark the window the pane is in; while hidden in the _ai stash, its owner window.
  win=$(tmux display -p -t "$TMUX_PANE" '#{window_id}')
  if [[ $(tmux display -p -t "$TMUX_PANE" '#{session_name}') == _ai ]]; then
    win=$(tmux show -pqv -t "$TMUX_PANE" @ai_window)
  fi
  title="Claude · $(tmux display -p -t "$win" '#{session_name}')"
  # Visible = pane sits in the active window of an attached session (not stashed).
  if [[ $(tmux display -p -t "$TMUX_PANE" '#{&&:#{window_active},#{session_attached}}') != 1 ]]; then
    tmux set -w -t "$win" @ai_alert "$icon"
  fi
fi

if ! lsappinfo info -only name "$(lsappinfo front)" | grep -qi ghostty; then
  osascript -e 'on run argv' \
    -e 'display notification (item 1 of argv) with title (item 2 of argv)' \
    -e 'end run' "$msg" "$title" >/dev/null 2>&1
fi
exit 0
