---
name: save
description: Vault the current session under a human name so it can be resumed later by name. Use when the user says "/save <name>", "save this session as", or "vault this session".
argument-hint: <name>
allowed-tools: Bash, Read, Write
---

# Save this session to the Enhanced Resume vault

The user wants to bookmark THIS session under `$ARGUMENTS` so a future session
can resume it by name and get a handoff briefing.

Do this now, in order:

1. **Resolve the session id.** Run: `echo "$CLAUDE_CODE_SESSION_ID"`.
   - If empty, fall back to the newest transcript in this project's dir:
     `ls -t ~/.claude/projects/*/*.jsonl | head -1` and take the basename
     without `.jsonl`. Tell the user you inferred it.
2. **Gather metadata.** Current dir: `pwd`. Git branch (if any):
   `git branch --show-current 2>/dev/null`.
   Note: `--cwd` must be the directory the session was LAUNCHED from —
   `claude --resume` only finds sessions belonging to that directory's project.
   `ervault add` cross-checks the id against `~/.claude/projects/` and corrects
   the cwd from the transcript if the shell has since cd'd elsewhere, so `pwd`
   is just the fallback for when no transcript is found.
3. **Record it in the index FIRST** — this creates (and, if the name was already
   vaulted, rotates) the directory, and prints the authoritative path to write
   into. Run, quoting every value:
   `python3 "$CLAUDE_PLUGIN_ROOT/bin/ervault" add --name "$ARGUMENTS" --agent claude --id "<id>" --cwd "<pwd>" --branch "<branch>" --oneliner "<one-line summary you compose>"`
   Capture the printed path as `<vaultdir>`. Do not sanitize the name yourself —
   `ervault` owns that, and writing to a path you guessed would land outside the
   directory it just created.
4. **Write the handoff** to `<vaultdir>/HANDOFF.md`. Address it to your future
   self and cover exactly these sections — be specific, cite real files/commits,
   and do NOT restate anything claude-mem or your memory directory already
   persists:
   - **Mission** — what this session is about, two sentences.
   - **State** — branch, commits, running processes, what is verified vs assumed.
   - **Decisions & why** — choices made and the reasoning a fresh instance would
     otherwise re-litigate.
   - **Open threads** — unfinished work, priority order, with the next action.
   - **Landmines** — looks-wrong-but-isn't, looks-fine-but-isn't, approaches
     already tried and refuted.
   - **Pointers** — key files with line refs, commit SHAs, links.
5. **Confirm** to the user: the name, the vault path, and the resume line
   `er <name>` (plus that `/continue <name>` prints it in-session).

Keep the handoff tight and high-signal. It is the point of the whole feature.
