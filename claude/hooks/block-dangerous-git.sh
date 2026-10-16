#!/bin/bash
# Claude Code PreToolUse (Bash) hook: refuse destructive git commands.
# Normal `git push` stays allowed (still goes through the permission prompt).
COMMAND=$(jq -r '.tool_input.command // empty')

DANGEROUS_PATTERNS=(
  "git[[:space:]]+push[^;&|]*[[:space:]](--force|-f([[:space:]]|$)|--force-with-lease|--mirror|--delete|-d([[:space:]]|$))"
  "git[[:space:]]+push[^;&|]*[[:space:]]\+[^[:space:]]+"
  "git[[:space:]]+reset[^;&|]*--hard"
  "git[[:space:]]+clean[^;&|]*[[:space:]]-[a-zA-Z]*f"
  "git[[:space:]]+branch[^;&|]*[[:space:]](-D|--delete[[:space:]]+--force)"
  "git[[:space:]]+checkout[[:space:]]+(--[[:space:]]+)?\.([[:space:]]|$)"
  "git[[:space:]]+restore[[:space:]]+(--worktree[[:space:]]+)?\.([[:space:]]|$)"
  "git[[:space:]]+stash[[:space:]]+(drop|clear)"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if printf '%s' "$COMMAND" | grep -qE "$pattern"; then
    echo "BLOCKED: '$COMMAND' is a destructive git command (matched: $pattern). The user has prevented you from running it; ask them to run it themselves if it is really needed." >&2
    exit 2
  fi
done

exit 0
