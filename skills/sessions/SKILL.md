---
name: sessions
description: List the sessions saved in the Enhanced Resume vault. Use for "/sessions", "list my saved sessions", "what have I vaulted".
allowed-tools: Bash
---

# List vaulted sessions

1. Run: `python3 "$CLAUDE_PLUGIN_ROOT/bin/ervault" list`
2. If the array is empty, tell the user the vault is empty and that `/save <name>`
   adds the current session.
3. Otherwise render a compact table, newest first, one row per session:
   **name · saved date (from savedAt) · agent · branch · oneliner**.
   Keep the project dir out unless the user asks — the name and one-liner are
   what they navigate by.
