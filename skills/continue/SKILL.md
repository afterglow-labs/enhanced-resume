---
name: continue
description: Print the command to resume a vaulted session by name (and copy it to the clipboard). Use for "/continue <name>", "resume the session named", "reopen the vaulted session".
argument-hint: <name>
allowed-tools: Bash
---

# Resume a vaulted session by name

A slash command runs inside the CURRENT session and cannot swap it for another —
true resume is a CLI action. So surface the exact command and copy it.

1. Run: `python3 "$CLAUDE_PLUGIN_ROOT/bin/ervault" resume "$ARGUMENTS" --print-only`
   - Exit 1 means the name is unknown; show the stderr (it lists near matches)
     and stop.
2. Print the command to the user and copy it: pipe the same line to `pbcopy`.
3. Tell the user plainly: paste it in a terminal to resume. Full transcript vs
   summary is chosen via Claude Code's own load options; either way the
   SessionStart hook will hand you (the model) the handoff on entry. For Codex
   sessions the printed `codex resume` line already carries the handoff prompt.
