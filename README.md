# antislop

**A filter, not a style guide.** `antislop` helps AI coding agents stop producing
generic, cookie-cutter UI, copy, and code comments — by pushing for specific,
lively output without forcing one visual look.

It works like a filter: it bans *technique without purpose*, not technique itself.
A gradient is fine. A gradient used as the default blue→purple wash on every
section is not. The fix is never "add more bans" — it is "state the purpose and
raise the liveliness bar."

```
If the logo and product name were swapped, would this still feel
unique and have its own character?   →   If no, it's too generic.
```

---

## What's in the box

| File | What it is |
|---|---|
| `antislop.md` | **The core filter.** One readable file: the rules, the slop-pattern catalog, the liveliness toolkit, and the Delivery Gate (audit). Read this first. |
| `skills/ui/SKILL.md` | UI / visual depth: color, layout, components, decoration, motion. |
| `skills/copywriting/SKILL.md` | Copy depth: headlines, CTAs, tone, anti-AI-writing patterns. |
| `skills/human/SKILL.md` | Human-centered depth: contrast, keyboard, focus, states. |
| `skills/responsive/SKILL.md` | Responsive depth: breakpoints, overflow, grids, tap targets. |
| `skills/code-comments/SKILL.md` | Code-comment hygiene: drop the slop, keep the useful, never touch the code. |
| `bin/antislop.js` | The CLI: `init`, `install`, and the `audit` pass/fail mode. |
| `install/install.sh` · `install/install.ps1` | Simple installer flow for every common agent. |
| `plugins/` | Drop-in "plugin style" setups for Claude Code, Cursor, Cline, Windsurf, Aider, Codex, OpenCode, Continue. |
| `scripts/contrast-check.py` | WCAG contrast verifier (used by `skills/human/SKILL.md`). |
| `audit/audit-prompt.md` | LLM-driven audit prompt for finished work. |

---

## First-time: 3 steps

### 1. Get the tool
```bash
git clone <this-repo> antislop && cd antislop
# optional, to use the `antislop` command globally:
npm link          # now `antislop` is on your PATH
```

### 2. Install into your agent (loads every session)
Run the interactive installer — it asks local/global, which agent, and which skills:
```bash
./install/install.sh          # macOS / Linux
# or:  pwsh install/install.ps1
# or:  antislop init           # the Node CLI version (cross-platform)
```
Or go straight to a target:
```bash
./install/install.sh --agent cursor --skills all --local
antislop install claude-code --global --skills ui,copywriting
```

The installer copies `antislop.md` + the skills you picked next to your agent's
config and writes a small **pointer block** into the entry file
(`CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, `.clinerules`, `.windsurfrules`, …)
so antislop loads **every session**. Restart/refresh the session once.

> **Local vs global.** `--local` (default) installs into the current project —
> great for per-repo control. `--global` installs into your user config
> (`~/.antislop` + the user-level entry file) so every project gets it.

### 3. Use it — and audit before shipping
Your agent now reads `antislop.md` and loads the right skill for the task. Before
you ship finished work, run the **audit mode**:
```bash
antislop audit .              # fast static check: reports PASS/FAIL + findings
```
Or paste `audit/audit-prompt.md` into your agent for an LLM review pass.

---

## The five skills (load only when needed)

antislop keeps the core small and breaks depth into skills you load per task:

| Load when… | File | Core rules it leans on |
|---|---|---|
| building/editing any interface | `skills/ui/SKILL.md` | R-16–R-27, R-32, R-34, R-35 |
| writing/editing prose, CTAs, headlines | `skills/copywriting/SKILL.md` | R-02, R-30, R-31, R-01 |
| accessibility / real people | `skills/human/SKILL.md` | R-06, R-08, R-09, R-11 |
| small-screen layouts | `skills/responsive/SKILL.md` | R-03, R-28 |
| writing/editing code comments | `skills/code-comments/SKILL.md` | R-15 |

Each skill uses the same shape — **Tell / Why / Fix** — and ends with a checklist
to run alongside the core's Delivery Gate. None of them renumber or duplicate the
core rules; they cite them by number.

---

## Audit mode (before you ship)

`antislop audit <path>` is a dependency-free static checker. It walks your files
(skipping `node_modules`, `dist`, `.git`, …) and flags slop heuristics:

- em dash `—` in copy (R-02)
- generic CTAs — "Get Started", "Learn More" (R-30)
- buzzwords — "AI Powered", "Seamless", "Revolutionary" (R-31)
- fabricated-stat patterns — `99.9%`, `10K+ users` (R-01)
- placeholder/fake names — "John Doe", "Lorem ipsum" (R-04/R-38)
- decorative comment separators, emoji-in-comments, vague TODOs (R-15)

It prints each finding as `[RULE] SEVERITY  file:line  match → why`, then a
`RESULT: PASS` or `RESULT: FAIL (n findings)` line, and exits non-zero on FAIL so
it can gate CI:

```bash
antislop audit src/ && echo "ship it" || echo "fix the slop first"
```

For a deeper, judgment-based review, hand `audit/audit-prompt.md` to your agent.

---

## Plugin setups for common agents

`plugins/` holds ready-made drop-ins. The installer wires the right one
automatically; you can also copy one in by hand:

| Agent | Drop-in | Loads every session via |
|---|---|---|
| Claude Code | `plugins/claude-code/` (`plugin.json` + `/antislop-audit` command + `CLAUDE.md`) | `/plugin add` or the `CLAUDE.md` pointer |
| Cursor | `plugins/cursor/.cursor/rules/antislop.mdc` | alwaysApply rule |
| Cline | `plugins/cline/.clinerules` | project rules file |
| Windsurf | `plugins/windsurf/.windsurfrules` | rules file |
| Aider | `plugins/aider/` (`CONVENTIONS.md` + `.aider.conf.yml`) | `read:` config |
| Codex | `plugins/codex/AGENTS.md` | `AGENTS.md` |
| OpenCode | `plugins/opencode/opencode.json` | agent prompt |
| Continue | `plugins/continue/config.yaml` | `rules:` list |

See `plugins/README.md` for what each contains.

---

## The core idea (30-second version)

1. **Purpose test** — every visual/copy decision must answer *"what does this
   serve?"* Write the reason down (R-36).
2. **Liveliness bar** — set three dials, ENERGY / RHYTHM / MOTION (1–3), hold them
   start to finish, and add one focal point, structural whitespace, one accent, and
   an identity motif.
3. **Delivery Gate** — before shipping, run the Hard Gate / Purpose-Gate /
   Liveliness / Craftsmanship checklist in `antislop.md`. Any FAIL = do not ship.

Read `antislop.md` for the full rules (R-01…R-36), the slop catalog, and the
Delivery Gate.

---

## License

MIT — see `LICENSE`. Fork it, ship it, make your agents stop sounding like every
other agent.
