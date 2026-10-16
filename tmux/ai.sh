#!/usr/bin/env bash
# One AI pane (claude/copilot) per tmux window, docked on the right or popped out
# into its own window. It's always the same process, so the conversation survives.
# usage: ai.sh toggle|show|focus|pop|pick [pane-id]
#   toggle  open (claude) / hide / bring back (jumps to it when popped out)
#   show    bring back a hidden pane without moving focus (used by nvim sends)
#   focus   show + select it
#   pop     move it between docked and its own "ai" window
#   pick    fzf: choose tool, continue or resume
set -euo pipefail

action=${1:-toggle}
target=${2:-${TMUX_PANE:-$(tmux display -p '#{pane_id}')}}
default_cmd="claude --ide"
width=40%
stash=_ai # hidden session holding AI panes while toggled off

# Is the pane/window still around? (display exits 0 for dead targets, so check output)
alive() { [[ -n $(tmux display -p -t "$1" '#{pane_id}' 2>/dev/null) ]]; }

win=$(tmux display -p -t "$target" '#{window_id}')
# Run from inside the AI pane: act on the window that owns it.
owner=$(tmux show -pqv -t "$target" @ai_window)
if [[ -n $owner ]] && alive "$owner"; then
  win=$owner target=$owner
fi
ai=$(tmux show -wqv -t "$win" @ai_pane)
if [[ -n $ai ]] && ! alive "$ai"; then ai=""; fi

open() {
  local dir env=()
  dir=$(tmux display -p -t "$target" '#{pane_current_path}')
  # Opened from nvim: pin Claude to that nvim (claudecode.nvim's port) instead of
  # letting --ide guess, which fails when VS Code / another nvim has the same repo.
  if [[ -n ${CLAUDE_CODE_SSE_PORT:-} ]]; then
    env=(-e "CLAUDE_CODE_SSE_PORT=$CLAUDE_CODE_SSE_PORT" -e ENABLE_IDE_INTEGRATION=true)
  fi
  ai=$(tmux split-window ${env[@]+"${env[@]}"} -h -l "$width" -t "$target" -c "$dir" -P -F '#{pane_id}' "$1")
  tmux set -w -t "$win" @ai_pane "$ai"
  tmux set -p -t "$ai" @ai_window "$win"
}

# docked | stashed | popped
state() {
  if [[ $(tmux display -p -t "$ai" '#{window_id}') == "$win" ]]; then echo docked
  elif [[ $(tmux display -p -t "$ai" '#{session_name}') == "$stash" ]]; then echo stashed
  else echo popped; fi
}

dock() {
  tmux join-pane -d -h -l "$width" -s "$ai" -t "$target"
  tmux set -wu -t "$win" @ai_alert
}

hide() {
  tmux has-session -t "=$stash" 2>/dev/null || tmux new-session -d -s "$stash"
  tmux break-pane -d -s "$ai" -t "=$stash:"
}

pop_out() {
  tmux break-pane -s "$ai" -n ai -t "$(tmux display -p -t "$win" '#{session_id}'):"
}

go() { tmux select-window -t "$ai" && tmux select-pane -t "$ai"; }

case $action in
  toggle)
    if [[ -z $ai ]]; then open "$default_cmd"
    else
      case $(state) in
        docked) hide ;;
        stashed) dock && go ;;
        popped) go ;;
      esac
    fi
    ;;
  show) [[ -z $ai || $(state) != stashed ]] || dock ;;
  focus)
    [[ -n $ai ]] || exit 0
    [[ $(state) != stashed ]] || dock
    go
    ;;
  pop)
    [[ -n $ai ]] || open "$default_cmd"
    if [[ $(state) == popped ]]; then dock && go; else pop_out; fi
    ;;
  pick)
    if [[ -n $ai ]]; then
      tmux display-message "AI pane already open in this window (prefix a toggles it, /exit to switch tool)"
      exit 0
    fi
    choice=$(printf '%s\n' \
      "claude --ide" "claude --ide --continue" "claude --ide --resume" \
      "copilot" "copilot --continue" "copilot --resume" |
      fzf --prompt='ai> ' --no-multi --reverse) || exit 0
    open "$choice"
    ;;
  *) echo "usage: ai.sh toggle|show|focus|pop|pick [pane-id]" >&2; exit 1 ;;
esac
