# Save this Codex session to the Enhanced Resume vault

The user wants to vault THIS Codex session under the name they passed. Do this:

1. Resolve this session's id: it is the UUID in today's newest rollout file,
   `ls -t ~/.codex/sessions/*/*/*/rollout-*.jsonl | head -1` — the id is the
   trailing UUID in that filename (after the timestamp).
2. Get the working dir (`pwd`) and git branch
   (`git branch --show-current 2>/dev/null`).
3. Record it in the index FIRST — this creates (and, if the name was already
   vaulted, rotates) the directory, and prints the authoritative path to write
   into. Locate `ervault` (marketplace installs are versioned,
   `cache/<marketplace>/<plugin>/<version>/`; fall back to PATH for clone or
   `--plugin-dir` setups):
   `EV=$(ls ~/.claude/plugins/cache/*/enhanced-resume/*/bin/ervault 2>/dev/null | sort -V | tail -1); EV="${EV:-$(command -v ervault)}"`
   Then run:
   `python3 "$EV" add --name "<name>" --agent codex --id "<uuid>" --cwd "<pwd>" --branch "<branch>" --oneliner "<summary>"`
   Capture the printed path as `<vaultdir>`. Do not write the handoff before
   this step and do not guess the path yourself — `ervault add` rotates any
   existing `<name>/` dir, so a handoff written first would be rotated away.
4. Write a handoff to your future self at `<vaultdir>/HANDOFF.md` with these
   sections: Mission, State, Decisions & why, Open threads, Landmines,
   Pointers. Be specific; do not restate boilerplate.
5. Confirm the name and that `er <name>` will resume this Codex session with the
   handoff delivered as its opening prompt.
