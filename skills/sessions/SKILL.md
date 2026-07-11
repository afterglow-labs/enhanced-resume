---
name: sessions
description: List the sessions saved in the Enhanced Resume vault. Use for "/sessions", "list my saved sessions", "what have I vaulted".
allowed-tools: Bash, Read
---

# List vaulted sessions

1. Run: `python3 "$CLAUDE_PLUGIN_ROOT/bin/ervault" list`
2. If the array is empty, tell the user the vault is empty and that `/save <name>`
   adds the current session.
3. Otherwise, for each session, also read its handoff at
   `~/.claude/session-vault/<name>/HANDOFF.md` (respect `$ER_VAULT_DIR` if set)
   and extract the FIRST item under `## Open threads` — that is where the
   session left off.
4. Render one short block per session, newest first. The reader is deciding
   "which one do I reopen?", so lead with the left-off state, not past
   accomplishments. Raw ids, agent, and full paths stay out unless asked:

   **`<name>`** — <how long ago, from savedAt> · <last path segment of cwd><` · <branch>` if any>
   <oneliner>
   **Left off:** <first open-threads item compressed to one plain sentence; `no handoff found` if the file is missing>
   **Resume:** `er <name>`
