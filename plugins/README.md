# antislop plugin drop-ins

Ready-made, agent-specific drop-ins for the [antislop](../../) anti-slop filter. Each
subfolder is a self-contained drop-in for one AI coding agent: copy it into your
project (or your user/global config), or run the installer in `../install` to wire it
up automatically.

Every drop-in does the same job: load `antislop.md` (the core filter) on every
session, point the agent at the right `skills/*.md` for the task, and tell it to run
the Delivery Gate before shipping. The exact mechanism differs per agent.

## What each subfolder contains

- **`claude-code/`** — a Claude Code plugin. Drop `CLAUDE.md` (the pointer block) into
  your project or `~/.claude/CLAUDE.md`, plus `.claude-plugin/plugin.json` (plugin
  manifest) and `commands/antislop-audit.md` (the `/antislop-audit` slash command).
- **`cursor/`** — a Cursor rule: `.cursor/rules/antislop.mdc` with `alwaysApply: true`,
  so the filter loads on every request.
- **`cline/`** — a Cline rules file: `.clinerules` (plain pointer block markdown).
- **`windsurf/`** — a Windsurf rules file: `.windsurfrules` (plain pointer block markdown).
- **`aider/`** — an Aider drop-in: `CONVENTIONS.md` (the pointer block) plus
  `.aider.conf.yml` that tells Aider to read `CONVENTIONS.md` and `antislop.md` every
  session.
- **`codex/`** — a Codex drop-in: `AGENTS.md` (the pointer block).
- **`opencode/`** — an OpenCode drop-in: `opencode.json` with a `default` agent prompt
  that loads the filter.
- **`continue/`** — a Continue drop-in: `config.yaml` whose `rules:` list loads
  `./antislop.md` every session.

## Installation

Fastest path: run the installer.

```bash
# from this repo root
./install/install.sh --agent auto      # detect your agent and wire it up
./install/install.ps1 -Agent auto      # Windows (PowerShell)
```

Or copy the relevant subfolder's files into your project / user config by hand. Either
way, make sure `antislop.md` and the `skills/` folder sit next to the pointer file so
the relative paths resolve.
