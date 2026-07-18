#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
export ER_VAULT_DIR="$tmp/vault"
codex_home="$tmp/codex"
version=$(python3 -c "import json; print(json.load(open('$root/.claude-plugin/plugin.json'))['version'])")
install="$codex_home/plugins/cache/enhanced-resume/enhanced-resume/$version"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$install"
cp -R "$root/hooks" "$root/bin" "$install/"
python3 "$root/bin/ervault" add \
  --name "CodexHook" \
  --agent codex \
  --id CODEX-SID \
  --cwd /tmp \
  --branch main \
  --oneliner "codex root fallback" >/dev/null

command=$(python3 -c "import json; print(json.load(open('$root/hooks/hooks.json'))['hooks']['SessionStart'][0]['hooks'][0]['command'])")

set +e
out=$(printf '%s\n' '{"session_id":"CODEX-SID","source":"resume","hook_event_name":"SessionStart"}' \
  | env -u CLAUDE_PLUGIN_ROOT -u PLUGIN_ROOT CODEX_HOME="$codex_home" bash -c "$command" 2>&1)
status=$?
set -e

[ "$status" -eq 0 ] || {
  echo "FAIL: Codex SessionStart hook exited $status without a plugin-root variable"
  echo "$out"
  exit 1
}

printf '%s\n' "$out" | python3 -c "import json,sys; c=json.load(sys.stdin)['hookSpecificOutput']['additionalContext']; assert 'CodexHook' in c and 'HANDOFF.md' in c" \
  || { echo "FAIL: Codex hook did not inject the vaulted handoff"; exit 1; }

echo "PASS"
