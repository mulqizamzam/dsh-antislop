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

Who it is for: anyone running DSH who wants its agent to stop producing recognizeable default AI output on UI, copy, and comment work.

Main use case: the agent loads the core filter, then the matching task skill, then runs the Delivery Gate before shipping.

---

## 2. Prerequisites

| Tool | Required version | How to check | Source |
|---|---|---|---|
| DeepSeek Harness | `>=0.2.0-rc.2` | `dsh --version` | `package.json` field `dsh.engines.dsh` |
| Node.js | Perlu dikonfirmasi | `node --version` | `package.json` has no `engines` field |
| Python 3 | Perlu dikonfirmasi | `python3 --version` | `scripts/contrast-check.py` shebang is `#!/usr/bin/env python3` |

No account, API key, or paid service is needed. The plugin is a local skill provider and reads no network.

The Node and Python version floors are not declared in the repo. The two scripts were verified on Node 24.19.0 and Python 3 on this machine; other versions were not tested.

---

## 3. Installation

The plugin is not published to npm. It is wired into DSH by registering a skill provider, either by pointing DSH at this repo directly or by copying the repo into a stable location.

### Option A: use this repo in place

```bash
git clone https://github.com/mulqizamzam/dsh-antislop.git
cd dsh-antislop
```

Then add the provider registration to the DSH profile patch file (see section 4).

### Option B: copy to a stable location

The registration file stores an absolute path. If you move or delete the clone, the plugin breaks silently. Copy it somewhere durable first:

```bash
cp -r dsh-antislop ~/dsh-plugins/antislop
```

Then point the registration at `~/dsh-plugins/antislop/skills`.

Proof the install worked: after restarting DSH, six skills named `antislop`, `antislop-ui`, `antislop-copywriting`, `antislop-human`, `antislop-responsive`, `antislop-code-comments` appear in the agent's skill catalog. See section 16.

---

## 4. Configuration

The plugin has one configuration surface: a Cordis `insert` row that mounts an isolated `dsh-skill-filesystem` provider.

Open the patch file of the DSH profile you run. For the `web` profile this is `~/.dsh/profiles/web/cordis.patch.yml`. Add this row to the existing `insert` list:

```yaml
- insert:
    - id: antislop-skills
      name: '@deepseek-ai/dsh-skill-filesystem'
      config:
        providerName: antislop
        includeDefaultRoots: false
        customSkillDirs:
          - /absolute/path/to/dsh-antislop/skills
        watch: false
```

| Key | Value | What it does |
|---|---|---|
| `id` | `antislop-skills` | Row identifier. Must be unique inside the profile patch. Override this same id from a later patch layer, never edit the row in place. |
| `name` | `@deepseek-ai/dsh-skill-filesystem` | The provider plugin that scans directories for skills. |
| `providerName` | `antislop` | Label for this provider instance. Shown in skill metadata as the owning provider. |
| `includeDefaultRoots` | `false` | Scans only `customSkillDirs`. When `true`, the same instance would also scan `<project>/.dsh/skills`, `<project>/.agents/skills`, `$DSH_HOME/skills`, and `$DSH_AGENTS_HOME/skills`, duplicating every other skill in the catalog. |
| `customSkillDirs` | list of absolute paths | Directories to scan. Each subdirectory must contain a `SKILL.md`. |
| `watch` | `false` | No filesystem watcher. Skill content is read once at boot. Editing a `SKILL.md` requires a DSH restart to take effect. |

Two settings need attention:

- **`customSkillDirs` is an absolute path.** The value shipped in `cordis.patch.yml` inside this repo is `/home/administrator/agent-workspace/dsh-custom/plugins/antislop/skills`, which only resolves on the machine of the original author. If you clone elsewhere, edit this path or your skills will not load. A relative path resolves against the DSH process working directory and is not reliable, which is why local-only DSH plugins use absolute paths.
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
2. The AGENTS.md pointer block in the repo is loaded automatically and tells the agent which skill to read. If you are working outside this repo, the pointer block is not present, so the agent relies on the skill catalog alone.
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

For a judgment-based review of finished work instead of the static check, hand `audit/audit-prompt.md` to the agent. It produces a PASS/FAIL table with one row per rule.

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
├── scripts/
│   └── contrast-check.py         WCAG contrast ratio calculator (verified working)
├── bin/antislop.js               Legacy CLI. Currently broken, see section 11.
├── install/                      Legacy installer. Currently broken, see section 11.
├── plugins/                      Legacy per-agent drop-ins. Currently stale, see section 11.
└── antislop.md                   Legacy copy of the core filter, superseded by skills/core/SKILL.md
```

Files a newcomer edits first:

- `skills/core/SKILL.md`, to change a rule
- `skills/ui/SKILL.md` and the other four, to tune a specific concern
- `cordis.patch.yml`, to fix the `customSkillDirs` path for your machine
- `AGENTS.md`, to change what the pointer block says

---

## 9. Common Commands

Every command below was run in this repository during the writing of this README, except where marked.

### DSH skill provider (core use)

```bash
# restart DSH so the profile patch is re-applied
dsh restart
```

The exact restart invocation depends on how DSH is launched in your environment. Perlu dikonfirmasi for your setup.

### Verify skill files parse

```bash
# every skill directory needs a SKILL.md with a name and description
for f in skills/*/SKILL.md; do head -5 "$f" | grep -E '^name:'; done
```

### Contrast check

```bash
python3 scripts/contrast-check.py "#1a1a1a" "#ffffff"
```

### Static slop audit

```bash
node bin/antislop.js audit <path>
```

Currently broken, see section 11. Not verified working in this repo.

### Git

```bash
git status
git add <paths>
git commit
git push origin master:main
```

---

## 10. Testing

The repository has no test suite. There is no test runner, no test directory, and no CI workflow. `package.json` declares no `test` script.

The only executable verification present is `scripts/contrast-check.py`, which was run successfully during the writing of this README.

The static audit in `bin/antislop.js` is meant to serve as a CI gate, but it does not run in the current repo state.

---

## 11. Troubleshooting

Each entry below is a real failure observed in this repository, with the symptom as it appears on the command line.

### `node bin/antislop.js audit .` crashes with `require is not defined`

Symptom:

```
ReferenceError: require is not defined in ES module scope, you can use import instead
This file is being treated as an ES module because it has a '.js' file extension
and 'package.json' contains "type": "module".
```

Cause: the repo declared `"type": "module"` in `package.json` during the DSH refactor, but `bin/antislop.js` is still CommonJS. It uses `require()` four times and `__dirname` once. Both are unavailable in ESM scope.

Check:

```bash
node bin/antislop.js audit .
```

Fix options: rename the file to `bin/antislop.cjs`, or convert the four `require` calls to `import` and replace `__dirname` with `import.meta.url`. Alternatively delete `bin/` entirely, since `package.json` no longer declares a `bin` field and nothing in the DSH path uses the CLI.

This error was reproduced before writing this README.

### Skills do not appear in the DSH catalog after editing `cordis.patch.yml`

Symptom: the six `antislop*` skills are missing from the agent's skill catalog.

Cause: the profile patch is applied when DSH starts, not when the file changes. Also possible: `customSkillDirs` still points at a path from the original author's machine.

Check: confirm the directory exists and contains a `SKILL.md` in each subdirectory.

```bash
ls <path-from-customSkillDirs>
```

Fix: correct the path, then restart DSH. Note that deleting or moving the clone breaks the plugin without any error message, because a missing skill root simply contributes no candidates.

### `install/install.sh` copies files that do not exist

Symptom: installer reports it cannot find skill files, or writes a pointer block that points at dead paths.

Cause: the installer still references the pre-refactor flat layout `skills/ui.md`, `skills/copywriting.md`, `skills/human.md`, `skills/responsive.md`, `skills/code-comments.md`. Those five files were replaced by `skills/<name>/SKILL.md` directories. The shell function `skill_file` still maps a skill name to the old flat filename, and `cp "$SKILLS_DIR/$(skill_file "$s")"` therefore targets paths that no longer exist.

Check:

```bash
grep -n 'skills/[a-z-]*\.md' install/install.sh
```

Fix: update `skill_file` and the pointer block to the directory layout, or drop `install/` and use the DSH registration in section 4.

### Pointer blocks under `plugins/` and the root `AGENTS.md` point at stale paths

Symptom: an agent following the pointer reads a file that does not exist.

Cause: the drop-ins for Claude Code, Cursor, Cline, Windsurf, Aider, Codex, OpenCode, and Continue were updated to the `skills/*/SKILL.md` path form, but they still tell the agent to read `antislop.md` at the repo root as the core filter, which is a stale duplicate of `skills/core/SKILL.md`.

Fix: point the drop-ins at `skills/core/SKILL.md`, or retire the `plugins/` directory since the DSH path does not use it.

### Two copies of the core filter disagree

Symptom: an agent reads `antislop.md` at the repo root and applies rules that differ from the skill the catalog serves.

Cause: `antislop.md` at the repo root is the pre-refactor core filter. `skills/core/SKILL.md` is the current one, and it is what DSH actually serves. The two files are near-identical in content but the root copy is no longer the source of truth.

Fix: delete the root `antislop.md` once the `plugins/` drop-ins stop referencing it.

### `.gitignore` does not ignore anything this project produces

Symptom: editor droppings or local scratch files show up in `git status`.

Cause: `.gitignore` came from the GitHub repository initialization and is an Ada language template: it ignores `*.o` and `*.ali`. Nothing in this repo produces those.

Fix: replace it with a gitignore matching this project, for example `node_modules/`, `.DS_Store`, and `*.log`.

---

## 12. Development Guide

The loop, as far as the repo files show it:

1. Create a branch off `master`.
2. Edit the skill files under `skills/`. Rules are cited by number and never renumbered inside a task skill; a task skill cites the core rule rather than restating it.
3. Update `AGENTS.md` if the pointer block changes. The block is delimited by `<!-- antislop:start -->` and `<!-- antislop:end -->` so tooling can replace it idempotently.
4. Update the matching file in `plugins/` only if you are keeping the legacy path alive.
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

To move it to another machine, clone or copy this repository, then repeat section 4 on that machine and adjust `customSkillDirs`. The DSH registration itself is not portable because it stores an absolute path, and it lives in `~/.dsh/`, which is not version controlled. Anything you set up locally there must be re-done on a new machine.

---

## 14. Security Notes

- No secrets, tokens, API keys, passwords, or credentials exist anywhere in this repository. Verified: `git grep` over tracked files returns no such values.
- No `.env` file is needed and none is shipped. `package.json` declares zero dependencies.
- `.gitignore` currently ignores only `*.o` and `*.ali`, an Ada template from repository initialization. It does not cover `node_modules/`, editor state, or OS droppings. If you add tooling to this repo, update it.
- The plugin never writes outside the DSH skill registry. `watch: false` means it does not even hold filesystem watchers.
- `scripts/contrast-check.py` parses only its two command-line arguments and exits. It reads no files and no environment.

---

## 15. FAQ

**Do I need `npm install`?**
No. `package.json` has no dependencies and no lockfile exists. The plugin is a directory of markdown plus one YAML file.

**Why is there no `bin` entry in `package.json`?**
The previous version published an `antislop` CLI to npm. This version is a DSH skill plugin, so the CLI entry and the npm `files` list were removed. The file `bin/antislop.js` is still in the tree but is broken, see section 11.

**Does the filter work for non-DSH agents?**
That was the original design, served by `install/` and `plugins/`. Those paths are stale and non-functional after the refactor. If you need them, fix the paths listed in section 11, or use the DSH path only.

**Why did my edit to a skill not take effect?**
`watch: false`. Restart DSH. That setting is in section 4.

**Can I use only some of the five task skills?**
The provider scans the whole `skills/` directory and registers all six skills. There is no per-skill include list in the DSH registration, unlike the old installer's `--skills` flag. Selective loading happens at the agent level, when the agent chooses which skill to read.

**Does this slow down every session?**
The skills are only metadata until loaded. Six short descriptions enter the catalog; the full rule bodies are read only when the agent actually loads a skill.

---

## 16. Final Checklist

Work down this list to confirm the plugin is live.

- [ ] Cloned or copied this repository to a durable path
- [ ] Opened the DSH profile patch file (`~/.dsh/profiles/web/cordis.patch.yml` for the `web` profile)
- [ ] Added the `antislop-skills` insert row with `customSkillDirs` pointing at the actual clone path, not the shipped default
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
| `bin/antislop.js` | Broken, `require` under ESM. Not runnable as shipped. |
| `install/install.sh`, `install/install.ps1` | Reference deleted `skills/*.md` paths. Not runnable as shipped. |
| `plugins/` drop-ins, 8 agents | Stale pointer paths, reference the superseded root `antislop.md`. |
| Root `antislop.md` | Stale duplicate of `skills/core/SKILL.md`. |
| `.gitignore` | Ada template, irrelevant to this project. |
| Hardcoded absolute path in `cordis.patch.yml` | Works only at the original author's path. Must be edited per machine. |

## License

MIT. See `LICENSE`, Copyright (c) 2026 mulqizamzam.
