#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
export ER_VAULT_DIR="$(mktemp -d)"
export CLAUDE_PLUGIN_ROOT="$root"
trap 'rm -rf "$ER_VAULT_DIR"' EXIT
python3 "$root/bin/ervault" add --name Hooky --agent claude --id SID-42 --cwd /tmp --branch main --oneliner "h" >/dev/null
hook="bash $root/hooks/session-start.sh"

# hit on resume → additionalContext mentioning the handoff
out=$(echo '{"session_id":"SID-42","source":"resume","hook_event_name":"SessionStart"}' | $hook)
echo "$out" | python3 -c "import json,sys; c=json.load(sys.stdin)['hookSpecificOutput']['additionalContext']; assert 'Hooky' in c and 'HANDOFF.md' in c" \
  || { echo "FAIL: no injection on hit"; exit 1; }

# miss → empty output, exit 0
out=$(echo '{"session_id":"UNKNOWN","source":"resume"}' | $hook); [ -z "$out" ] || { echo "FAIL: injected on miss"; exit 1; }

# compact source → suppressed even on a known id
out=$(echo '{"session_id":"SID-42","source":"compact"}' | $hook); [ -z "$out" ] || { echo "FAIL: injected on compact"; exit 1; }
echo "PASS"
