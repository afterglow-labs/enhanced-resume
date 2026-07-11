#!/usr/bin/env bash
# SKILLS is extended as skills land (Task 5: save. Task 6: + continue sessions).
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS=(save)
fail=0
for s in "${SKILLS[@]}"; do
  f="$root/skills/$s/SKILL.md"
  [ -f "$f" ] || { echo "FAIL: missing $f"; fail=1; continue; }
  head -1 "$f" | grep -q '^---$' || { echo "FAIL: $s no frontmatter"; fail=1; }
  grep -q "^name:" "$f" || { echo "FAIL: $s no name"; fail=1; }
  grep -q "^description:" "$f" || { echo "FAIL: $s no description"; fail=1; }
done
[ "$fail" = 0 ] && echo "PASS" || exit 1
