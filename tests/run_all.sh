#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
for t in test_manifest.sh test_ervault_index.sh test_ervault_resume.sh test_hook.sh test_skills_frontmatter.sh test_er_alias.sh test_codex_prompt.sh; do
  printf '%-32s ' "$t"; bash "$t"
done
echo "ALL PASS"
