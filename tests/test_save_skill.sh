#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
skill="$root/skills/save/SKILL.md"
readme="$root/README.md"
fail=0

expect_text() {
  local pattern="$1"
  local file="$2"
  local message="$3"
  grep -Fq -- "$pattern" "$file" || { echo "FAIL: $message"; fail=1; }
}

[ ! -e "$root/codex/er-save.md" ] \
  || { echo "FAIL: legacy Codex prompt still exists"; fail=1; }

expect_text 'CLAUDE_CODE_SESSION_ID' "$skill" 'save skill does not detect Claude Code'
expect_text 'CODEX_THREAD_ID' "$skill" 'save skill does not detect Codex'
expect_text '--agent claude' "$skill" 'save skill does not register Claude sessions'
expect_text '--agent codex' "$skill" 'save skill does not register Codex sessions'
expect_text '/save <name>' "$readme" 'README does not document the Claude invocation'
expect_text '$enhanced-resume:save <name>' "$readme" 'README does not document the Codex skill invocation'

if grep -Fq -- 'cp codex/er-save.md' "$readme"; then
  echo "FAIL: README still requires the legacy Codex prompt installation"
  fail=1
fi

[ "$fail" -eq 0 ] && echo "PASS" || exit 1
