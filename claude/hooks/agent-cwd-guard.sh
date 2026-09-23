#!/usr/bin/env bash
# PreToolUse hook on the Agent tool.
# A dispatched agent inherits the orchestrating session's shell cwd at spawn
# time, not the target repo automatically. If a dispatch prompt names exactly
# one of the CFP multi-repo project's repos and doesn't already `cd` into it,
# prepend an explicit cd instruction so the agent doesn't start commands at
# the /Users/tow-cfp/cfp root (where repo-relative commands fail or match
# nothing). See /Users/tow-cfp/cfp/CLAUDE.md for the underlying rule.
set -euo pipefail

input="$(cat)"
tool_name=$(printf '%s' "$input" | jq -r '.tool_name // empty')

if [ "$tool_name" != "Agent" ]; then
  printf '{}'
  exit 0
fi

prompt=$(printf '%s' "$input" | jq -r '.tool_input.prompt // empty')

repos=(cash-flow-portal-backend cash-flow-portal-react cashflowportal.sso)
matched=""
count=0
for r in "${repos[@]}"; do
  if printf '%s' "$prompt" | grep -qF -- "$r"; then
    matched="$r"
    count=$((count + 1))
  fi
done

if [ "$count" -ne 1 ]; then
  printf '{}'
  exit 0
fi

repo_abs="/Users/tow-cfp/cfp/${matched}"

if printf '%s' "$prompt" | grep -qF -- "cd ${repo_abs}" || printf '%s' "$prompt" | grep -qF -- "cd ${matched}"; then
  printf '{}'
  exit 0
fi

prefix="IMPORTANT FIRST STEP: run \`cd ${repo_abs}\` before any other command in this dispatch. A dispatched agent inherits the orchestrating session's shell cwd at spawn time, not this repo automatically. Commands in this repo's CLAUDE.md are repo-relative.

"

printf '%s' "$input" | jq --arg p "${prefix}${prompt}" --arg matched "$matched" \
  '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "allow", updatedInput: (.tool_input * {prompt: $p})}, systemMessage: ("agent-cwd-guard: auto-injected cd into " + $matched)}'
