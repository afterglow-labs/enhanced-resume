---
name: save
description: Use when the user asks to save, name, bookmark, or vault the current Claude Code or Codex session for later resumption.
argument-hint: <name>
allowed-tools: Bash, Read, Write
---

# Save this session to the Enhanced Resume vault

Vault THIS session under the requested name so it can be resumed with a handoff.
In Claude Code, the name is `$ARGUMENTS`. In Codex, it is the text following
`$enhanced-resume:save`. Ask for a name if none was supplied.

Do this now, in order:

1. **Identify the current runtime and session id.** Inspect
   `CLAUDE_CODE_SESSION_ID` and `CODEX_THREAD_ID`.
   - Non-empty `CLAUDE_CODE_SESSION_ID`: use that id and `agent=claude`. The
     eventual `ervault add` call must pass `--agent claude`.
   - Otherwise, non-empty `CODEX_THREAD_ID`: use that id and `agent=codex`. The
     eventual `ervault add` call must pass `--agent codex`.
   - If both are empty but `CLAUDE_PLUGIN_ROOT` is set, infer the Claude id from
     the newest `~/.claude/projects/*/*.jsonl` transcript and tell the user it
     was inferred.
   - If no runtime can be identified, stop. Never guess from the newest Codex
     rollout because another concurrently active session may be newer.
2. **Gather metadata.** Current dir: `pwd`. Git branch (if any):
   `git branch --show-current 2>/dev/null`.
3. **Locate `ervault`.** Prefer
   `$CLAUDE_PLUGIN_ROOT/bin/ervault` when it exists. Otherwise find the newest
   `*/enhanced-resume/*/bin/ervault` below `~/.codex/plugins/cache` or
   `~/.claude/plugins/cache`; finally try `command -v ervault`. Stop with a
   clear installation error if none exists.
4. **Record it in the index FIRST.** This creates (and, if the name was already
   vaulted, rotates) the directory and prints the authoritative path to write.
   Run, quoting every value:
   `python3 "<ervault>" add --name "<name>" --agent "<agent>" --id "<id>" --cwd "<pwd>" --branch "<branch>" --oneliner "<one-line summary you compose>"`
   Capture the printed path as `<vaultdir>`. Do not sanitize the name yourself —
   `ervault` owns that, and writing to a path you guessed would land outside the
   directory it just created.
5. **Write the handoff** to `<vaultdir>/HANDOFF.md`. Address it to your future
   self and cover exactly these sections — be specific, cite real files/commits,
   and do not restate information already persisted by memory tooling:
   - **Mission** — what this session is about, two sentences.
   - **State** — branch, commits, running processes, what is verified vs assumed.
   - **Decisions & why** — choices made and the reasoning a fresh instance would
     otherwise re-litigate.
   - **Open threads** — unfinished work, priority order, with the next action.
   - **Landmines** — looks-wrong-but-isn't, looks-fine-but-isn't, approaches
     already tried and refuted.
   - **Pointers** — key files with line refs, commit SHAs, links.
6. **Confirm** the name, vault path, detected agent, and resume line
   `er <name>`.

Keep the handoff tight and high-signal. It is the point of the whole feature.
