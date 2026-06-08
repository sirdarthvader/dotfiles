#!/usr/bin/env bash
# Tmux theme switcher — cycle or pick from a menu
# Usage:
#   tmux-theme.sh menu    → popup picker
#   tmux-theme.sh next    → cycle to next theme
#   tmux-theme.sh <name>  → apply specific theme

THEME_FILE="/tmp/tmux-current-theme"
THEMES=(matrix cyberpunk dracula nord catppuccin gruvbox)

current_theme() {
  if [[ -f "$THEME_FILE" ]]; then
    cat "$THEME_FILE"
  else
    echo "matrix"
  fi
}

apply_theme() {
  local theme="$1"
  echo "$theme" > "$THEME_FILE"

  case "$theme" in
    matrix)
      tmux set -g status-style "bg=#0a0a0a,fg=#33ff33"
      tmux set -g window-status-current-format "#[fg=#0a0a0a,bg=#00ff41,bold] #I:#W #[fg=#00ff41,bg=#0a0a0a]"
      tmux set -g window-status-format "#[fg=#1a8c1a,bg=#0a0a0a] #I:#W "
      tmux set -g status-left "#[fg=#0a0a0a,bg=#00ff41,bold]  #S #[fg=#00ff41,bg=#0a0a0a] "
      tmux set -g pane-active-border-style "fg=#00ff41"
      tmux set -g pane-border-style "fg=#0d5e0d"
      tmux set -g message-style "bg=#0a0a0a,fg=#00ff41,bold"
      ;;
    cyberpunk)
      tmux set -g status-style "bg=#0d0221,fg=#ff00ff"
      tmux set -g window-status-current-format "#[fg=#0d0221,bg=#ff00ff,bold] #I:#W #[fg=#ff00ff,bg=#0d0221]"
      tmux set -g window-status-format "#[fg=#6b2fa0,bg=#0d0221] #I:#W "
      tmux set -g status-left "#[fg=#0d0221,bg=#00ffff,bold]  #S #[fg=#00ffff,bg=#0d0221] "
      tmux set -g pane-active-border-style "fg=#ff00ff"
      tmux set -g pane-border-style "fg=#6b2fa0"
      tmux set -g message-style "bg=#0d0221,fg=#00ffff,bold"
      ;;
    dracula)
      tmux set -g status-style "bg=#282a36,fg=#f8f8f2"
      tmux set -g window-status-current-format "#[fg=#282a36,bg=#bd93f9,bold] #I:#W #[fg=#bd93f9,bg=#282a36]"
      tmux set -g window-status-format "#[fg=#6272a4,bg=#282a36] #I:#W "
      tmux set -g status-left "#[fg=#282a36,bg=#50fa7b,bold]  #S #[fg=#50fa7b,bg=#282a36] "
      tmux set -g pane-active-border-style "fg=#bd93f9"
      tmux set -g pane-border-style "fg=#6272a4"
      tmux set -g message-style "bg=#282a36,fg=#50fa7b,bold"
      ;;
    nord)
      tmux set -g status-style "bg=#2e3440,fg=#d8dee9"
      tmux set -g window-status-current-format "#[fg=#2e3440,bg=#88c0d0,bold] #I:#W #[fg=#88c0d0,bg=#2e3440]"
      tmux set -g window-status-format "#[fg=#4c566a,bg=#2e3440] #I:#W "
      tmux set -g status-left "#[fg=#2e3440,bg=#a3be8c,bold]  #S #[fg=#a3be8c,bg=#2e3440] "
      tmux set -g pane-active-border-style "fg=#88c0d0"
      tmux set -g pane-border-style "fg=#4c566a"
      tmux set -g message-style "bg=#2e3440,fg=#a3be8c,bold"
      ;;
    catppuccin)
      tmux set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
      tmux set -g window-status-current-format "#[fg=#1e1e2e,bg=#cba6f7,bold] #I:#W #[fg=#cba6f7,bg=#1e1e2e]"
      tmux set -g window-status-format "#[fg=#585b70,bg=#1e1e2e] #I:#W "
      tmux set -g status-left "#[fg=#1e1e2e,bg=#a6e3a1,bold]  #S #[fg=#a6e3a1,bg=#1e1e2e] "
      tmux set -g pane-active-border-style "fg=#cba6f7"
      tmux set -g pane-border-style "fg=#585b70"
      tmux set -g message-style "bg=#1e1e2e,fg=#a6e3a1,bold"
      ;;
    gruvbox)
      tmux set -g status-style "bg=#1d2021,fg=#ebdbb2"
      tmux set -g window-status-current-format "#[fg=#1d2021,bg=#fabd2f,bold] #I:#W #[fg=#fabd2f,bg=#1d2021]"
      tmux set -g window-status-format "#[fg=#665c54,bg=#1d2021] #I:#W "
      tmux set -g status-left "#[fg=#1d2021,bg=#b8bb26,bold]  #S #[fg=#b8bb26,bg=#1d2021] "
      tmux set -g pane-active-border-style "fg=#fabd2f"
      tmux set -g pane-border-style "fg=#665c54"
      tmux set -g message-style "bg=#1d2021,fg=#b8bb26,bold"
      ;;
  esac

  tmux display "[ theme: $theme ]"
}

next_theme() {
  local cur
  cur=$(current_theme)
  local idx=0
  for i in "${!THEMES[@]}"; do
    if [[ "${THEMES[$i]}" == "$cur" ]]; then
      idx=$i
      break
    fi
  done
  local next_idx=$(( (idx + 1) % ${#THEMES[@]} ))
  apply_theme "${THEMES[$next_idx]}"
}

case "${1:-menu}" in
  menu)
    choice=$(printf '%s\n' "${THEMES[@]}" | fzf-tmux -p 30%,40% --header="  Pick a theme" --reverse --border)
    [[ -n "$choice" ]] && apply_theme "$choice"
    ;;
  next)
    next_theme
    ;;
  *)
    apply_theme "$1"
    ;;
esac
