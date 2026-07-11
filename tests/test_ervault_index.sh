#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
export ER_VAULT_DIR="$(mktemp -d)"
trap 'rm -rf "$ER_VAULT_DIR"' EXIT
er="python3 $root/bin/ervault"

dir=$($er add --name Alpha --agent claude --id UUID-1 --cwd /tmp/p --branch main --oneliner "first")
[ -f "$ER_VAULT_DIR/Alpha/meta.json" ] || { echo "FAIL: no meta"; exit 1; }
[ "$dir" = "$ER_VAULT_DIR/Alpha" ] || { echo "FAIL: add did not print dir"; exit 1; }

# lookup is case-insensitive, preserves stored case
row=$($er lookup alpha)
echo "$row" | python3 -c "import json,sys; r=json.load(sys.stdin); assert r['name']=='Alpha'; assert r['id']=='UUID-1'; assert r['agent']=='claude'"

# missing lookup exits 1
if $er lookup Nope >/dev/null 2>&1; then echo "FAIL: missing should exit 1"; exit 1; fi

# re-save rotates
$er add --name Alpha --agent claude --id UUID-2 --cwd /tmp/p --branch dev --oneliner "second" >/dev/null
[ -d "$ER_VAULT_DIR/Alpha.1" ] || { echo "FAIL: no rotation"; exit 1; }
row=$($er lookup Alpha)
echo "$row" | python3 -c "import json,sys; assert json.load(sys.stdin)['id']=='UUID-2'"

# list returns both distinct names newest-first after adding Beta
$er add --name Beta --agent codex --id CX-1 --cwd /tmp/q --branch main --oneliner "b" >/dev/null
$er list | python3 -c "import json,sys; r=json.load(sys.stdin); names=[x['name'] for x in r]; assert names[0]=='Beta', names; assert 'Alpha' in names"
echo "PASS"
