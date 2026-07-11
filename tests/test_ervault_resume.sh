#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
export ER_VAULT_DIR="$(mktemp -d)"
trap 'rm -rf "$ER_VAULT_DIR"' EXIT
er="python3 $root/bin/ervault"

$er add --name Gamma --agent claude --id UUID-9 --cwd /tmp --branch main --oneliner "g" >/dev/null

# lookup-session by id prints "name<TAB>handoffpath" and exits 0
out=$($er lookup-session UUID-9)
echo "$out" | grep -q "Gamma" || { echo "FAIL: session name"; exit 1; }
echo "$out" | grep -q "$ER_VAULT_DIR/Gamma/HANDOFF.md" || { echo "FAIL: handoff path"; exit 1; }

# unknown id exits 1
if $er lookup-session NOPE >/dev/null 2>&1; then echo "FAIL: unknown id should exit 1"; exit 1; fi

# resume --print-only emits the right claude command
$er resume Gamma --print-only | grep -q "claude --resume UUID-9" || { echo "FAIL: claude resume cmd"; exit 1; }

# codex agent yields a codex resume command carrying the handoff instruction
$er add --name Delta --agent codex --id CX-7 --cwd /tmp --branch main --oneliner "d" >/dev/null
line=$($er resume Delta --print-only)
echo "$line" | grep -q "codex resume CX-7" || { echo "FAIL: codex resume cmd"; exit 1; }
echo "$line" | grep -q "HANDOFF.md" || { echo "FAIL: codex handoff prompt"; exit 1; }
echo "PASS"
