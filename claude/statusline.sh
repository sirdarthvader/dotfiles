#!/bin/bash
# Claude Code status line: model │ dir  branch │ context used (green → yellow → red)
input=$(cat)
model=$(jq -r '.model.display_name // "?"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
pct=$(jq -r '.context_window.used_percentage // 0 | floor' <<<"$input")

branch=$(git -C "$dir" branch --show-current 2>/dev/null)
dirty=$([[ -n $(git -C "$dir" status --porcelain 2>/dev/null | head -1) ]] && echo "*")

# Tokyo Night: blue, purple, green/yellow/red, dim
blue=$'\e[38;2;122;162;247m' purple=$'\e[38;2;187;154;247m' dim=$'\e[38;2;86;95;137m' reset=$'\e[0m'
if ((pct >= 80)); then ctx=$'\e[38;2;247;118;142m'
elif ((pct >= 50)); then ctx=$'\e[38;2;224;175;104m'
else ctx=$'\e[38;2;158;206;106m'; fi

line="${blue}${model}${reset} ${dim}│${reset} ${dir##*/}"
[[ -n $branch ]] && line+=" ${purple} ${branch}${dirty}${reset}"
line+=" ${dim}│${reset} ${ctx}ctx ${pct}%${reset}"
((pct >= 80)) && line+=" ${dim}(/compact or /clear soon)${reset}"
printf '%s\n' "$line"
