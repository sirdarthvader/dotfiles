#!/usr/bin/env bash
# Tmux system stats — cached output, macOS only
# Returns:  CPU%  │  MEM%  │ ↑ UP ↓ DOWN

CACHE_FILE="/tmp/tmux-sysstat"
NET_PREV="/tmp/tmux-sysstat-net"
CACHE_TTL=4  # seconds

# Use cache if fresh enough
if [[ -f "$CACHE_FILE" ]]; then
  age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE") ))
  if (( age < CACHE_TTL )); then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# ── CPU ──────────────────────────────────────────────────
cpu=$(top -l 2 -n 0 -F 2>/dev/null | grep "CPU usage" | tail -1 | sed 's/.*sys, *//;s/% *idle.*//' | awk '{printf "%.0f", 100 - $1}')

# ── Memory ───────────────────────────────────────────────
# Only active + wired + compressor (skip inactive/cache)
total_bytes=$(sysctl -n hw.memsize)
stats=$(vm_stat)
page_size=16384

active=$(echo "$stats" | awk '/Pages active/ {gsub(/[^0-9]/,"",$NF); print $NF}')
wired=$(echo "$stats" | awk '/Pages wired down/ {gsub(/[^0-9]/,"",$NF); print $NF}')
compressor=$(echo "$stats" | awk '/occupied by compressor/ {gsub(/[^0-9]/,"",$NF); print $NF}')

used_bytes=$(( (active + wired + compressor) * page_size ))
mem_pct=$(( used_bytes * 100 / total_bytes ))

# ── Network ──────────────────────────────────────────────
# Read current cumulative bytes on en0
net_line=$(netstat -ib 2>/dev/null | grep -E "^en0\s" | grep "<Link" | head -1)
now_in=$(echo "$net_line" | awk '{print $7}')
now_out=$(echo "$net_line" | awk '{print $10}')
now_ts=$(date +%s)

# Human-readable bytes/sec
human_rate() {
  local bps=$1
  if (( bps >= 1048576 )); then
    awk "BEGIN {printf \"%.1fM\", $bps/1048576}"
  elif (( bps >= 1024 )); then
    awk "BEGIN {printf \"%.0fK\", $bps/1024}"
  else
    echo "${bps}B"
  fi
}

net_up="-"
net_down="-"

if [[ -f "$NET_PREV" ]]; then
  read -r prev_ts prev_in prev_out < "$NET_PREV"
  elapsed=$(( now_ts - prev_ts ))
  if (( elapsed > 0 )); then
    rate_in=$(( (now_in - prev_in) / elapsed ))
    rate_out=$(( (now_out - prev_out) / elapsed ))
    net_down=$(human_rate "$rate_in")
    net_up=$(human_rate "$rate_out")
  fi
fi

echo "$now_ts $now_in $now_out" > "$NET_PREV"

# ── Output ───────────────────────────────────────────────
result=" atapi ${cpu}% │  vatapi ${mem_pct}% │ ↑${net_up} ↓${net_down}"
echo "$result" | tee "$CACHE_FILE"
