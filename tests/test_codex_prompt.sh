#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
f="$root/codex/er-save.md"
[ -f "$f" ] || { echo "FAIL: no codex prompt"; exit 1; }
grep -q "agent codex" "$f" || { echo "FAIL: prompt must record agent codex"; exit 1; }
grep -q "HANDOFF.md" "$f" || { echo "FAIL: prompt must write handoff"; exit 1; }
grep -q "rollout-" "$f" || { echo "FAIL: prompt must explain session-id discovery"; exit 1; }
# ORDERING: `ervault add` must come BEFORE the HANDOFF.md write. add() rotates
# any existing <name>/ dir — writing the handoff first gets it rotated away
# into <name>.1/ on every save, leaving resume pointing at a missing file.
add_line=$(grep -n "ervault add" "$f" | head -1 | cut -d: -f1)
handoff_line=$(grep -n "HANDOFF.md" "$f" | head -1 | cut -d: -f1)
[ -n "$add_line" ] && [ -n "$handoff_line" ] && [ "$add_line" -lt "$handoff_line" ] \
  || { echo "FAIL: ervault add (line $add_line) must precede HANDOFF.md write (line $handoff_line)"; exit 1; }
echo "PASS"
