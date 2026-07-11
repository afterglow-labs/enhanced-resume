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

# resume --print-only emits the right claude command, prefixed with cd to the
# saved cwd (claude --resume only finds sessions belonging to the cwd's project)
$er resume Gamma --print-only | grep -q "cd /tmp && claude --resume UUID-9" || { echo "FAIL: claude resume cmd"; exit 1; }

# --cwd is verified against the transcript's real launch dir: claude scopes
# resume by project dir, so a cd'd-elsewhere pwd at save time must be corrected
fake_home="$(mktemp -d)"
trap 'rm -rf "$ER_VAULT_DIR" "$fake_home"' EXIT
mkdir -p "$fake_home/.claude/projects/-work-realproj"
printf '{"type":"user","cwd":"/work/realproj"}\n' > "$fake_home/.claude/projects/-work-realproj/UUID-heal.jsonl"
HOME="$fake_home" $er add --name Heal --agent claude --id UUID-heal --cwd /wrong/place --branch main --oneliner "h" >/dev/null 2>&1
HOME="$fake_home" $er lookup Heal | grep -q '"cwd": "/work/realproj"' || { echo "FAIL: add should correct cwd from transcript"; exit 1; }

# records vaulted with a wrong cwd before the transcript existed self-heal at
# resume time
HOME="$fake_home" $er add --name Stale --agent claude --id UUID-stale --cwd /wrong/place --branch main --oneliner "s" >/dev/null
mkdir -p "$fake_home/.claude/projects/-work-otherproj"
printf '{"type":"user","cwd":"/work/otherproj"}\n' > "$fake_home/.claude/projects/-work-otherproj/UUID-stale.jsonl"
HOME="$fake_home" $er resume Stale --print-only | grep -q "cd /work/otherproj && claude --resume UUID-stale" || { echo "FAIL: resume should self-heal cwd from transcript"; exit 1; }

# codex agent yields a codex resume command carrying the handoff instruction
$er add --name Delta --agent codex --id CX-7 --cwd /tmp --branch main --oneliner "d" >/dev/null
line=$($er resume Delta --print-only)
echo "$line" | grep -q "codex resume CX-7" || { echo "FAIL: codex resume cmd"; exit 1; }
echo "$line" | grep -q "HANDOFF.md" || { echo "FAIL: codex handoff prompt"; exit 1; }
echo "PASS"
