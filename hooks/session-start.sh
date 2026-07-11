#!/usr/bin/env bash
# SessionStart: if this session is vaulted, tell the model to read its handoff.
# Silent + exit 0 on any miss so it never disrupts an ordinary session start.
set -euo pipefail
input=$(cat)

sid=$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null || true)
src=$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('source',''))" 2>/dev/null || true)
[ -n "$sid" ] || exit 0
case "$src" in startup|resume|"") ;; *) exit 0 ;; esac  # brief on entry, not mid-session compaction

hit=$(python3 "${CLAUDE_PLUGIN_ROOT}/bin/ervault" lookup-session "$sid" 2>/dev/null) || exit 0
name=$(printf '%s' "$hit" | cut -f1)
path=$(printf '%s' "$hit" | cut -f2)

ctx="This is your vaulted session \"$name\". Before anything else, read your handoff-to-future-self at $path — it holds the decisions, current state, open threads, and landmines from when you saved it."
python3 - "$ctx" <<'PY'
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": sys.argv[1]}}))
PY
