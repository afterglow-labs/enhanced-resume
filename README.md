# Enhanced Resume

Name your most important Claude Code and Codex sessions. Get back to them by
name — full transcript or summary — with a handoff you wrote to yourself
delivered the moment the session resumes.

## Commands (Claude Code)

- `/save <name>` — vault the current session and write its handoff.
- `/continue <name>` — print + copy the resume command for a vaulted session.
- `/sessions` — list what you've vaulted.
- `er <name>` — terminal launcher that actually resumes the session.

On resume, a SessionStart hook injects a pointer to that session's handoff, so
the model reads its own briefing before doing anything else. Summary vs full is
your choice via Claude Code's normal load options.

## Install

Add the plugin (marketplace or `--plugin-dir`). Put `bin/` on your PATH so `er`
works from anywhere:

```bash
echo 'export PATH="$PATH:'"$HOME"'/projects/enhanced-resume/bin"' >> ~/.zshrc
```

(Adjust the path if the plugin lives elsewhere, e.g. under
`~/.claude/plugins/...` when marketplace-installed.)

## Codex support

Codex resumes carry an initial prompt, so no hook is needed. One manual setup
step — install the Codex save prompt:

```bash
mkdir -p ~/.codex/prompts
cp codex/er-save.md ~/.codex/prompts/er-save.md
```

Then inside Codex: `/er-save <name>`. Resume with the same `er <name>` — it
detects the `codex` agent and runs `codex resume <id> "<handoff instruction>"`.

## Vault location

`~/.claude/session-vault/` — local only, never committed. One `index.json` plus
a `<name>/` dir per save holding `HANDOFF.md` + `meta.json`. Re-saving a name
rotates the previous copy to `<name>.1`.

## Tests

```bash
bash tests/run_all.sh
```
