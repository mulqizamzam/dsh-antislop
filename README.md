# antislop

An anti-slop filter for AI coding agents, shipped as a DeepSeek Harness (DSH) skill plugin.

The filter stops generic, cookie-cutter UI, copy, and code comments. It does not impose a visual style. It bans technique without purpose, not technique itself. A gradient is fine; a gradient used as the default wash on every section is not.

The one question the filter asks before anything ships:

```
If the logo and product name were swapped, would this still feel
unique and have its own character?   ->   If no, it is too generic.
```

---

## 1. Overview

`antislop` gives a DSH agent a written quality bar for front-end and prose work. It provides one core filter and five task-specific skills, each loaded only when the task matches.

What the repo actually contains:

| Component | Count | What it is |
|---|---|---|
| Core filter (`skills/core/SKILL.md`) | 1 file | Rules R-01 to R-36, craftsmanship standard C-1 to C-5, liveliness dials, Delivery Gate |
| Task skills (`skills/*/SKILL.md`) | 5 files | UI, copywriting, human, responsive, code comments |
| Rules | 36 | Grouped into Hard Gate (R-01 to R-15), Purpose-Gate (R-16 to R-27), Quality Locks (R-28 to R-36) |
| Craftsmanship criteria | 5 | C-1 Intentionality, C-2 Functional completeness, C-3 Content-driven composition, C-4 Resilience, C-5 Evidence over claims |
| Liveliness dials | 3 | ENERGY, RHYTHM, MOTION, each 1 to 3 |

Who it is for: anyone running DSH who wants its agent to stop producing recognizable default AI output on UI, copy, and comment work.

Main use case: the agent loads the core filter, then the matching task skill, then runs the Delivery Gate before shipping.

### What this plugin is not

There is no CLI, no npm package, and no installer. Those existed in the 1.x line and were removed when the repo became a DSH skill plugin. There is nothing to `npm install` and no command to run.

---

## 2. Prerequisites

| Tool | Required version | How to check | Source |
|---|---|---|---|
| DeepSeek Harness | `>=0.2.0-rc.2` | `dsh --version` | `package.json` field `peerDependencies["@deepseek-ai/dsh"]` — the field the install-time compatibility gate reads |
| Node.js | Perlu dikonfirmasi | `node --version` | `package.json` has no `engines` field. Node 24.19.0 was used to validate the YAML during the rewrite of this README. |
| Python 3 | Perlu dikonfirmasi | `python3 --version` | `scripts/contrast-check.py` shebang is `#!/usr/bin/env python3` |

No account, API key, or paid service is needed. The plugin is a local skill provider and reads no network.

---

## 3. Installation

The plugin is not published. Wire it into DSH by registering a skill provider that points at this repo's `skills/` directory.

### Step 1: put the repo somewhere durable

```bash
git clone https://github.com/mulqizamzam/dsh-antislop.git
cp -r dsh-antislop ~/dsh-plugins/antislop
```

Use a location you will not move or delete. A missing skill root produces no error: the provider simply contributes no candidates and the skills never appear.

### Step 2: register the provider

Open the patch file of the DSH profile you run. For the `web` profile this is `~/.dsh/profiles/web/cordis.patch.yml`. Add the row from `cordis.patch.yml` in this repo to that file's `insert` list, then edit `customSkillDirs` to point at `~/dsh-plugins/antislop/skills`.

```yaml
- insert:
    - id: antislop-skills
      name: '@deepseek-ai/dsh-skill-filesystem'
      config:
        providerName: antislop
        includeDefaultRoots: false
        customSkillDirs:
          - /home/<you>/dsh-plugins/antislop/skills
        watch: false
```

The registration lives in `~/.dsh/`, which is not version controlled. Repeating setup on another machine means writing this row again.

### Step 3: restart DSH

The profile patch is applied at boot, not on file change.

Proof the install worked: six skills named `antislop`, `antislop-ui`, `antislop-copywriting`, `antislop-human`, `antislop-responsive`, `antislop-code-comments` appear in the agent's skill catalog. See section 16.

---

## 4. Configuration

The plugin has one configuration surface: a Cordis `insert` row that mounts an isolated `dsh-skill-filesystem` provider.

| Key | Value | What it does |
|---|---|---|
| `id` | `antislop-skills` | Row identifier. Must be unique inside the profile patch. Override this same id from a later patch layer, never edit the row in place. |
| `name` | `@deepseek-ai/dsh-skill-filesystem` | The provider plugin that scans directories for skills. |
| `providerName` | `antislop` | Label for this provider instance. Shown in skill metadata as the owning provider. |
| `includeDefaultRoots` | `false` | Scans only `customSkillDirs`. When `true`, the same instance would also scan `<project>/.dsh/skills`, `<project>/.agents/skills`, `$DSH_HOME/skills`, and `$DSH_AGENTS_HOME/skills`, duplicating every other skill in the catalog. |
| `customSkillDirs` | list of absolute paths | Directories to scan. Each subdirectory must contain a `SKILL.md`. |
| `watch` | `false` | No filesystem watcher. Skill content is read once at boot. Editing a `SKILL.md` requires a DSH restart to take effect. |

Two settings need attention:

- **`customSkillDirs` must be edited per machine.** The value in this repo's `cordis.patch.yml` is the placeholder `/absolute/path/to/dsh-antislop/skills`. Replace it with your clone's absolute path. The provider resolves this value with `resolve()`, so a relative path lands against the DSH process working directory and is not reliable.
- **`watch: false`** means no live reload. Editing `skills/core/SKILL.md` changes nothing until DSH restarts. Set `watch: true` if you are actively editing the skills and want changes picked up automatically.

No environment variables, `.env` file, or secret is used anywhere in this plugin.

---

## 5. Database / External Services

None. This plugin reads local markdown files and registers them with the DSH skill registry. There is no database, no network call, and no external service.

---

## 6. Running the Project

Not applicable. There is no server, no build step, and no runtime process. DSH loads the plugin as part of its own startup; see section 4.

---

## 7. First Use / Quick Start

The plugin works only when the agent loads a skill. Loading is the agent's decision, driven by skill metadata and the AGENTS.md pointer block. The filter is an instruction layer, not a code gate: nothing blocks a bad UI from being written. The rules take effect once the agent reads them.

1. Start a DSH session in a project that touches UI, copy, layout, or comments.
2. The AGENTS.md pointer block in this repo is loaded automatically and tells the agent which skill to read. If you are working outside this repo, the pointer block is not present, so the agent relies on the skill catalog alone.
3. The agent loads `antislop` (core), then the task skill, for example `antislop-ui`.
4. Before shipping, the agent runs the Delivery Gate: every Hard Gate item must be NO, every Purpose-Gate technique must have a written reason, the three dials must be set, every craftsmanship answer must be NO.

Manual verification of contrast, which is the one check with an executable proof:

```bash
python3 scripts/contrast-check.py "#1a1a1a" "#ffffff"
```

Expected output:

```
contrast ratio: 17.40:1
  AA  normal text (>=4.5): PASS
  AA  large  text (>=3.0): PASS
  AAA normal text (>=7.0): PASS
  AAA large  text (>=4.5): PASS
```

Exit code is 0 when normal text meets AA. This command was run during the writing of this README and produced the output above.

For a judgment-based review of finished work, hand `audit/audit-prompt.md` to the agent. It produces a PASS/FAIL table with one row per rule.

---

## 8. Project Structure

```
dsh-antislop/
├── AGENTS.md                     Pointer block injected into an agent session
├── LICENSE                       MIT, Copyright (c) 2026 mulqizamzam
├── README.md                     This file
├── cordis.patch.yml              Cordis insert row that registers the skill provider
├── package.json                  DSH plugin manifest, no dependencies
├── skills/                       The actual payload. DSH scans this directory.
│   ├── core/SKILL.md             antislop: rules, slop catalog, dials, Delivery Gate
│   ├── ui/SKILL.md               antislop-ui: color, layout, components, motion
│   ├── copywriting/SKILL.md      antislop-copywriting: headlines, CTAs, tone
│   ├── human/SKILL.md            antislop-human: contrast, keyboard, focus, states
│   ├── responsive/SKILL.md       antislop-responsive: breakpoints, overflow, tap targets
│   └── code-comments/SKILL.md    antislop-code-comments: comment hygiene
├── audit/
│   └── audit-prompt.md           LLM-driven audit prompt, PASS/FAIL table format
└── scripts/
    └── contrast-check.py         WCAG contrast ratio calculator (verified working)
```

Files a newcomer edits first:

- `skills/core/SKILL.md`, to change a rule
- `skills/ui/SKILL.md` and the other four, to tune a specific concern
- `cordis.patch.yml` and the profile patch, to fix the `customSkillDirs` path for your machine
- `AGENTS.md`, to change what the pointer block says

---

## 9. Common Commands

Every command below was run in this repository during the writing of this README, except where marked.

### Verify skill files parse

```bash
# every skill directory needs a SKILL.md with a name and description
for f in skills/*/SKILL.md; do head -5 "$f" | grep -E '^name:'; done
```

### Contrast check

```bash
python3 scripts/contrast-check.py "#1a1a1a" "#ffffff"
```

### Git

```bash
git status
git add <paths>
git commit
git push origin master:main
```

### Restart DSH

```bash
dsh restart
```

The exact restart invocation depends on how DSH is launched in your environment. Perlu dikonfirmasi for your setup.

---

## 10. Testing

The repository has no test suite. There is no test runner, no test directory, and no CI workflow. `package.json` declares no `test` script.

The only executable verification present is `scripts/contrast-check.py`, which was run successfully during the writing of this README.

---

## 11. Troubleshooting

Each entry below is a real failure observed in this repository, with the symptom as it appears on the command line.

### Skills do not appear in the DSH catalog

Symptom: the six `antislop*` skills are missing from the agent's skill catalog.

Cause: one of the following. The profile patch is applied when DSH starts, not when the file changes. `customSkillDirs` still holds a path from another machine. Or the directory was moved or deleted after registration, which fails silently because a missing skill root contributes no candidates.

Check: confirm the directory exists and contains a `SKILL.md` in each subdirectory.

```bash
ls <path-from-customSkillDirs>
```

Fix: correct the path, then restart DSH.

### An edit to a skill has no effect

Symptom: after editing `skills/core/SKILL.md`, the agent still quotes the old text.

Cause: `watch: false` means no filesystem watcher. Skill bodies are read once at boot.

Fix: restart DSH, or set `watch: true` while actively editing.

### Skills stop appearing after moving the clone

Symptom: the skills were working, then silently disappeared.

Cause: `customSkillDirs` stores an absolute path. Moving or renaming the clone invalidates it with no error message.

Fix: update the path in the profile patch and restart.

### An agent reads a skill path that does not exist

Symptom: the agent reports it cannot find the file the pointer block names.

Cause: the pointer block in `AGENTS.md` and the "Load order" section of `skills/core/SKILL.md` use `skills/<name>/SKILL.md`. Any file referring to the removed flat layout `skills/<name>.md` or to a root-level `antislop.md` is stale.

Check:

```bash
grep -rn "antislop\.md\|skills/[a-z-]*\.md" --include="*.md" .
```

Fix: update the stale path to `skills/core/SKILL.md`.

---

## 12. Development Guide

The loop, as far as the repo files show it:

1. Create a branch off `master`.
2. Edit the skill files under `skills/`. Rules are cited by number and never renumbered inside a task skill; a task skill cites the core rule rather than restating it.
3. Update `AGENTS.md` if the pointer block changes. The block is delimited by `<!-- antislop:start -->` and `<!-- antislop:end -->` so tooling can replace it idempotently.
4. Update `cordis.patch.yml` if the provider config changes.
5. Stage the files you touched by name and commit. Do not use `git add -A`.
6. Restart DSH and confirm the skills still load.

Conventions that constrain edits:

- The core filter owns rule numbering. Task skills must not renumber or duplicate rules, only cite them.
- Comments are the only thing `skills/code-comments/SKILL.md` touches, and it must not modify executable code.
- The filter exempts its own documentation from rule R-02 (no em dash) because a linter does not lint itself. That carve-out does not extend to your product copy.

No branch protection, required review, or pre-commit hook is configured in this repository.

---

## 13. Deployment

Not applicable as a server deployment. The plugin is local-only: it lives on one machine and is wired into a local DSH profile.

To move it to another machine, clone or copy this repository, then repeat section 3 on that machine and adjust `customSkillDirs`. The DSH registration itself is not portable because it stores an absolute path, and it lives in `~/.dsh/`, which is not version controlled.

---

## 14. Security Notes

- No secrets, tokens, API keys, passwords, or credentials exist anywhere in this repository. Verified with `git grep` over tracked files during the writing of this README: zero credential-shaped values.
- No `.env` file is needed and none is shipped. `package.json` declares zero dependencies.
- `.gitignore` covers OS droppings and local scratch. It previously held an Ada language template from repository initialization that ignored nothing this project produces.
- The plugin never writes outside the DSH skill registry. `watch: false` means it does not even hold filesystem watchers.
- `scripts/contrast-check.py` parses only its two command-line arguments and exits. It reads no files and no environment.

---

## 15. FAQ

**Do I need `npm install`?**
No. `package.json` has no dependencies and no lockfile exists. The plugin is a directory of markdown plus one YAML file.

**Is there a CLI or slash command?**
No. The 1.x line shipped an `antislop` npm CLI with `init`, `install`, and `audit` subcommands. It was removed with the move to the DSH skill plugin. Its static audit covered 6 of the 36 rules and could not check contrast, keyboard access, states, or anything requiring judgment.

**Is there an audit?**
Yes, LLM-driven. Hand `audit/audit-prompt.md` to your agent along with the finished work. It returns a PASS/FAIL row per rule and an overall verdict.

**Does this work for non-DSH agents?**
Not in this version. The per-agent drop-ins for Claude Code, Cursor, Cline, Windsurf, Aider, Codex, OpenCode, and Continue were removed because they referenced the deleted flat skill layout. A DSH profile is required.

**Why did my edit to a skill not take effect?**
`watch: false`. Restart DSH, or set `watch: true`. See section 4.

**Can I use only some of the five task skills?**
The provider scans the whole `skills/` directory and registers all six skills. There is no per-skill include list. Selective loading happens at the agent level, when the agent chooses which skill to read.

**Does this slow down every session?**
The skills are only metadata until loaded. Six short descriptions enter the catalog; the full rule bodies are read only when the agent actually loads a skill.

---

## 16. Final Checklist

Work down this list to confirm the plugin is live.

- [ ] Cloned or copied this repository to a durable path
- [ ] Opened the DSH profile patch file (`~/.dsh/profiles/web/cordis.patch.yml` for the `web` profile)
- [ ] Added the `antislop-skills` insert row with `customSkillDirs` pointing at the actual clone path, not the placeholder
- [ ] Restarted DSH
- [ ] Confirmed `antislop` appears in the skill catalog
- [ ] Confirmed `antislop-ui`, `antislop-copywriting`, `antislop-human`, `antislop-responsive`, `antislop-code-comments` also appear
- [ ] Opened a UI, copy, layout, or comment task and confirmed the agent loads the core filter
- [ ] Ran `python3 scripts/contrast-check.py "#1a1a1a" "#ffffff"` and saw the AA/AAA output
- [ ] Confirmed the Delivery Gate ran before shipping, with one written reason per major decision

---

## Known gaps

Documented here so they are not mistaken for features:

| Gap | Status |
|---|---|
| No test suite, no CI | Absent from the repo. Do not assume coverage. |
| No `engines` floor in `package.json` | Node and Python minimums undeclared. |
| No static linter | The 1.x CLI audit was removed with the rest of the npm surface. Only `audit/audit-prompt.md` remains, which needs an LLM. |
| Requires a manual DSH profile edit | The plugin cannot register itself. The row lives outside version control. |
| `customSkillDirs` is an absolute path | By design for local-only DSH plugins. Must be edited per machine; a wrong value fails silently. |

## License

MIT. See `LICENSE`, Copyright (c) 2026 mulqizamzam.
