# Save this Codex session to the Enhanced Resume vault

The user wants to vault THIS Codex session under the name they passed. Do this:

1. Resolve this session's id: it is the UUID in today's newest rollout file,
   `ls -t ~/.codex/sessions/*/*/*/rollout-*.jsonl | head -1` — the id is the
   trailing UUID in that filename (after the timestamp).
2. Get the working dir (`pwd`) and git branch
   (`git branch --show-current 2>/dev/null`).
3. Write a handoff to your future self at
   `~/.claude/session-vault/<name>/HANDOFF.md` with these sections: Mission,
   State, Decisions & why, Open threads, Landmines, Pointers. Be specific; do
   not restate boilerplate.
4. Record it (adjust the path to the installed plugin location):
   `python3 ~/.claude/plugins/*/enhanced-resume/bin/ervault add --name "<name>" --agent codex --id "<uuid>" --cwd "<pwd>" --branch "<branch>" --oneliner "<summary>"`
5. Confirm the name and that `er <name>` will resume this Codex session with the
   handoff delivered as its opening prompt.
