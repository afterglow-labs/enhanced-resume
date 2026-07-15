# Enhanced Resume

Name your most important Claude Code and Codex sessions. Get back to them by
name — full transcript or summary — with a handoff you wrote to yourself
delivered the moment the session resumes.

## Commands

Claude Code:

- `/save <name>` — vault the current session and write its handoff.
- `/continue <name>` — print + copy the resume command for a vaulted session.
- `/sessions` — list what you've vaulted.

Codex:

- `$enhanced-resume:save <name>` — vault the current session and write its handoff.

Both agents resume from a terminal with `er <name>`.

For Claude Code, a SessionStart hook injects a pointer to that session's handoff
when it resumes. Summary vs full is your choice via Claude Code's normal load
options. Codex receives the handoff as its opening resume prompt.

## Install for Claude Code

From inside Claude Code:

```
/plugin marketplace add afterglow-labs/enhanced-resume
/plugin install enhanced-resume@enhanced-resume
```

Or clone and load it directly:

```bash
git clone https://github.com/afterglow-labs/enhanced-resume.git
claude --plugin-dir /path/to/enhanced-resume
```

Then put `bin/` on your PATH so `er` works from any terminal:

```bash
echo 'export PATH="$PATH:/path/to/enhanced-resume/bin"' >> ~/.zshrc
```

(When marketplace-installed, point PATH at the versioned `bin` directory under
`~/.claude/plugins/cache/enhanced-resume/enhanced-resume/`.)

## Install for Codex

Install the same plugin through Codex:

```bash
codex plugin marketplace add afterglow-labs/enhanced-resume
codex plugin add enhanced-resume@enhanced-resume
```

Restart Codex after installation so it refreshes its skill registry. Invoke the
save skill with `$enhanced-resume:save <name>`. Codex resumes carry the handoff
as their opening prompt, so they do not need Claude Code's SessionStart hook.

For `er` from any terminal, add the plugin's versioned `bin` directory under
`~/.codex/plugins/cache/enhanced-resume/enhanced-resume/` to PATH.

## Vault location

`~/.claude/session-vault/` — local only, never committed. One `index.json` plus
a `<name>/` dir per save holding `HANDOFF.md` + `meta.json`. Re-saving a name
rotates the previous copy to `<name>.1`.

## Tests

```bash
bash tests/run_all.sh
```
