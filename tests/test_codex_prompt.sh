#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
f="$root/codex/er-save.md"
[ -f "$f" ] || { echo "FAIL: no codex prompt"; exit 1; }
grep -q "agent codex" "$f" || { echo "FAIL: prompt must record agent codex"; exit 1; }
grep -q "HANDOFF.md" "$f" || { echo "FAIL: prompt must write handoff"; exit 1; }
grep -q "rollout-" "$f" || { echo "FAIL: prompt must explain session-id discovery"; exit 1; }
echo "PASS"
