#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
export ER_VAULT_DIR="$(mktemp -d)"
trap 'rm -rf "$ER_VAULT_DIR"' EXIT
python3 "$root/bin/ervault" add --name Zeta --agent claude --id UUID-Z --cwd /tmp --branch main --oneliner "z" >/dev/null
"$root/bin/er" Zeta --print-only | grep -q "claude --resume UUID-Z" || { echo "FAIL"; exit 1; }
echo "PASS"
