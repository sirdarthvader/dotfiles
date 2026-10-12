#!/usr/bin/env bash
# Pick a project and switch to (or create) its tmux session with code/run/shell windows.
# Usage: sessionizer.sh [dir]   (no arg = fuzzy-pick from git repos under ~/Documents + zoxide history)
set -euo pipefail

if [[ $# -ge 1 ]]; then
  dir=$(cd "$1" && pwd)
else
  dir=$(
    {
      zoxide query --list 2>/dev/null || true
      fd --hidden --type d --max-depth 5 --prune '^\.git$' ~/Documents \
        --exclude node_modules --exec echo {//}
    } | awk '!seen[$0]++' |
      fzf --prompt='project> ' --height=100% --no-multi \
        --preview 'eza --icons --group-directories-first -1 {}' --preview-window=right:40%
  ) || exit 0
fi

[[ -d "$dir" ]] || exit 0

# tmux session names can't contain '.' or ':'
name=$(basename "$dir" | tr '.:' '__')

if ! tmux has-session -t "=$name" 2>/dev/null; then
  tmux new-session -d -s "$name" -c "$dir" -n code
  tmux send-keys -t "=$name:code" 'nvim' Enter
  tmux new-window -d -t "=$name:" -n run -c "$dir"
  tmux new-window -d -t "=$name:" -n shell -c "$dir"
fi

if [[ -n "${TMUX:-}" ]]; then
  tmux switch-client -t "=$name"
else
  tmux attach-session -t "=$name"
fi
