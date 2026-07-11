#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
manifest="$root/.claude-plugin/plugin.json"
[ -f "$manifest" ] || { echo "FAIL: no manifest"; exit 1; }
python3 -c "import json,sys; d=json.load(open('$manifest')); assert d['name']=='enhanced-resume'; assert d['version']; assert d['description']" \
  || { echo "FAIL: manifest invalid"; exit 1; }
echo "PASS"
