#!/usr/bin/env bash
# Matrix rain effect for tmux status bar
# Each column independently simulates a rain drop at a random phase

CHARS="ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟｦｧｨｩｪｫｬｭｮｯ"
LENGTH=22
output=""

for ((i = 0; i < LENGTH; i++)); do
  roll=$((RANDOM % 100))
  idx=$((RANDOM % ${#CHARS}))
  c="${CHARS:$idx:1}"

  if   (( roll < 8  )); then
    # 8%  — white-hot drop head (the iconic bright tip)
    output+="#[fg=#ccffcc,bold]${c}"
  elif (( roll < 22 )); then
    # 14% — neon green (just behind the head)
    output+="#[fg=#00ff41,bold]${c}"
  elif (( roll < 40 )); then
    # 18% — bright green trail
    output+="#[fg=#33ff33]${c}"
  elif (( roll < 60 )); then
    # 20% — mid green (the bulk of visible rain)
    output+="#[fg=#1a8c1a]${c}"
  elif (( roll < 80 )); then
    # 20% — dark green background noise
    output+="#[fg=#0d5e0d]${c}"
  elif (( roll < 92 )); then
    # 12% — barely visible ghost characters
    output+="#[fg=#062e06]${c}"
  else
    # 8%  — void (empty column gap)
    output+="#[fg=#0a0a0a] "
  fi
done

echo "$output"
