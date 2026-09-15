#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');
const readline = require('readline');

const ROOT = path.join(__dirname, '..'); // repo root: antislop/

const POINTER_LINES = [
  '<!-- antislop:start -->',
  '## antislop',
  '',
  'For UI, copy, human-centered details, responsive layout, or code comments work, read `antislop.md` (core) and then the skill for the task:',
  '- UI / visual: `skills/ui.md`',
  '- Copy & text: `skills/copywriting.md`',
  '- Human-centered / a11y: `skills/human.md`',
  '- Responsive / mobile: `skills/responsive.md`',
  '- Code comments: `skills/code-comments.md`',
  '',
  'Before starting, ask the user when antislop applies: during the work, or after it is done.',
  '<!-- antislop:end -->'
];
const POINTER = POINTER_LINES.join('\n');

const MDC = [
  '---',
  'description: Always apply the antislop anti-slop filter to UI, copy, and code work',
  'globs: "**"',
  'alwaysApply: true',
  '---',
  POINTER
].join('\n');

const OPENCODE_JSON = JSON.stringify(
  {
    agents: {
      default: {
        prompt:
          'Read antislop.md and the matching skills/ file before UI, copy, human, responsive, or code-comment work. Run the Delivery Gate before shipping.'
      }
    }
  },
  null,
  2
);

const CONTINUE_YAML = [
  '# antislop: load the anti-slop filter every session',
  'rules:',
  '  - ./antislop.md'
].join('\n');

const SKILL_NAMES = ['ui', 'copywriting', 'human', 'responsive', 'code-comments'];

const AGENTS = {
  'claude-code': { entry: 'CLAUDE.md', style: 'pointer' },
  cursor: { entry: '.cursor/rules/antislop.mdc', style: 'mdc' },
  cline: { entry: '.clinerules', style: 'pointer' },
  windsurf: { entry: '.windsurfrules', style: 'pointer' },
  aider: { entry: 'CONVENTIONS.md', style: 'pointer', extra: '.aider.conf.yml' },
  codex: { entry: 'AGENTS.md', style: 'pointer' },
  opencode: { entry: 'opencode.json', style: 'json' },
  continue: { entry: 'config.yaml', style: 'yaml' }
};

const USAGE = `antislop — anti-slop filter for AI coding agents

Usage:
  antislop init                 Interactive first-run setup (local or global, pick agent + skills)
  antislop install [agent]     Install into a project (or --global). Flags below.
  antislop audit [path]        Static slop check of finished work. Prints PASS/FAIL.

Install flags:
  --global                     Install into your user config (~/.antislop) instead of CWD
  --skills <all|ui,copywriting,human,responsive,code-comments>   default: all
  --dry-run                    Print actions, change nothing
  --yes                        Non-interactive (no prompts)

Agents: claude-code, cursor, cline, windsurf, aider, codex, opencode, continue
Docs: antislop.md`;

function main() {
  const args = process.argv.slice(2);
  const cmd = args[0];
  if (!cmd || cmd === '--help' || cmd === '-h') {
    console.log(USAGE);
    process.exit(cmd ? 0 : 0);
  }
  if (cmd === 'audit') return cmdAudit(args[1] || '.');
  if (cmd === 'install') return cmdInstall(args.slice(1));
  if (cmd === 'init') return cmdInit(args.slice(1));
  console.error('Unknown command: ' + cmd);
  console.log(USAGE);
  process.exit(2);
}

function parseFlags(flags) {
  const out = { global: false, dryRun: false, yes: false, skills: 'all', agent: null };
  for (let i = 0; i < flags.length; i++) {
    const f = flags[i];
    if (f === '--global') out.global = true;
    else if (f === '--dry-run') out.dryRun = true;
    else if (f === '--yes') out.yes = true;
    else if (f === '--skills') out.skills = flags[++i] || 'all';
    else if (f === '--agent') out.agent = flags[++i] || null;
    else if (!out.agent && !f.startsWith('--')) out.agent = f;
  }
  return out;
}

function resolveSkills(spec) {
  if (spec === 'all') return SKILL_NAMES.slice();
  const wanted = spec.split(',').map((s) => s.trim()).filter(Boolean);
  const bad = wanted.filter((s) => !SKILL_NAMES.includes(s));
  if (bad.length) {
    console.error('Unknown skill(s): ' + bad.join(', ') + '\nValid: ' + SKILL_NAMES.join(', '));
    process.exit(2);
  }
  return wanted;
}

function detectAgent(cwd) {
  if (fs.existsSync(path.join(cwd, '.claude'))) return 'claude-code';
  if (fs.existsSync(path.join(cwd, '.cursor'))) return 'cursor';
  if (fs.existsSync(path.join(cwd, '.clinerules'))) return 'cline';
  if (fs.existsSync(path.join(cwd, '.windsurfrules'))) return 'windsurf';
  if (fs.existsSync(path.join(cwd, '.aider.conf.yml'))) return 'aider';
  if (fs.existsSync(path.join(cwd, 'AGENTS.md'))) return 'codex';
  if (fs.existsSync(path.join(cwd, 'opencode.json'))) return 'opencode';
  if (fs.existsSync(path.join(cwd, 'config.yaml'))) return 'continue';
  return 'generic';
}

function writePointerFile(entryPath, style, dryRun) {
  const dir = path.dirname(entryPath);
  if (dryRun) {
    console.log('[dry-run] write pointer -> ' + entryPath + ' (' + style + ')');
    return;
  }
  fs.mkdirSync(dir, { recursive: true });
  let content;
  if (style === 'mdc') content = MDC;
  else if (style === 'json') content = OPENCODE_JSON;
  else if (style === 'yaml') content = CONTINUE_YAML;
  else content = POINTER;

  if (fs.existsSync(entryPath)) {
    const existing = fs.readFileSync(entryPath, 'utf8');
    if (style === 'pointer') {
      fs.writeFileSync(entryPath, replaceOrAppend(existing, POINTER));
      return;
    }
    if (existing.includes('<!-- antislop:start -->')) {
      fs.writeFileSync(entryPath, replaceMarker(existing, content));
      return;
    }
    console.error('Refusing to overwrite ' + entryPath + ' (not an antislop file). Move it or pick another agent.');
    process.exit(1);
  }
  fs.writeFileSync(entryPath, content + '\n');
}

function replaceOrAppend(existing, block) {
  const start = '<!-- antislop:start -->';
  const end = '<!-- antislop:end -->';
  if (existing.includes(start) && existing.includes(end)) {
    const s = existing.indexOf(start);
    const e = existing.indexOf(end) + end.length;
    return existing.slice(0, s) + block + existing.slice(e);
  }
  return existing.trimEnd() + '\n\n' + block + '\n';
}

function replaceMarker(existing, content) {
  const start = '<!-- antislop:start -->';
  const end = '<!-- antislop:end -->';
  const s = existing.indexOf(start);
  const e = existing.indexOf(end) + end.length;
  return existing.slice(0, s) + content + existing.slice(e);
}

function copyCore(targetDir, skills, dryRun) {
  const pairs = [['antislop.md', 'antislop.md']];
  for (const s of skills) pairs.push(['skills/' + s + '.md', 'skills/' + s + '.md']);
  for (const [rel, destRel] of pairs) {
    const src = path.join(ROOT, rel);
    const dest = path.join(targetDir, destRel);
    if (dryRun) {
      console.log('[dry-run] copy ' + rel + ' -> ' + dest);
      continue;
    }
    if (!fs.existsSync(src)) {
      console.error('Missing source: ' + src);
      process.exit(1);
    }
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.copyFileSync(src, dest);
  }
}

function cmdInstall(flags) {
  const opt = parseFlags(flags);
  const cwd = process.cwd();
  let agent = opt.agent;
  if (!agent) {
    if (opt.yes) {
      console.error('install: --agent is required in non-interactive mode.');
      process.exit(2);
    }
    agent = detectAgent(cwd);
  }
  if (agent === 'generic') agent = 'codex';
  const cfg = AGENTS[agent];
  if (!cfg) {
    console.error('Unknown agent: ' + agent + '\nValid: ' + Object.keys(AGENTS).join(', '));
    process.exit(2);
  }
  const skills = resolveSkills(opt.skills);
  const targetDir = opt.global ? path.join(os.homedir(), '.antislop') : cwd;
  const entryPath = path.join(targetDir, cfg.entry);

  console.log('Installing antislop for ' + agent + (opt.global ? ' (global)' : ' (local)') + '...');
  copyCore(targetDir, skills, opt.dryRun);
  if (cfg.extra && !opt.dryRun) {
    const extraPath = path.join(targetDir, cfg.extra);
    fs.mkdirSync(path.dirname(extraPath), { recursive: true });
    fs.writeFileSync(extraPath, 'read:\n  - CONVENTIONS.md\n  - antislop.md\n');
  }
  writePointerFile(entryPath, cfg.style, opt.dryRun);
  console.log('Done. Restart/refresh your agent session so it loads antislop.');
  if (opt.global) console.log('Global install at: ' + targetDir);
}

function cmdInit(flags) {
  const opt = parseFlags(flags);
  if (!process.stdin.isTTY || opt.yes) {
    if (!opt.yes) {
      console.log('Non-interactive shell detected. Run with explicit flags, e.g.:');
      console.log('  antislop install cursor --skills all');
      console.log('  antislop install claude-code --global');
      return;
    }
    return cmdInstall(flags);
  }
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  const ask = (q) => new Promise((res) => rl.question(q, res));
  (async () => {
    const where = (await ask('Install locally (project) or globally (user)? [local/global]: ')).trim().toLowerCase();
    opt.global = where === 'global';
    const agentList = Object.keys(AGENTS).join(', ');
    const agent = (await ask('Agent? [' + agentList + ']: ')).trim().toLowerCase();
    if (agent) opt.agent = AGENTS[agent] ? agent : null;
    const skills = (await ask('Skills? [all] or comma list (ui,copywriting,human,responsive,code-comments): ')).trim();
    if (skills) opt.skills = skills;
    rl.close();
    cmdInstall(['--yes', opt.global ? '--global' : '--local', opt.agent ? '--agent' : '', opt.agent || '', '--skills', opt.skills].filter(Boolean));
  })();
}

const SKIP_DIRS = new Set(['.git', 'node_modules', 'dist', 'build', '.next', 'coverage', '.antislop', 'plugins', 'skills', 'audit', 'install', 'bin']);
const TEXT_EXT = new Set(['.md', '.txt', '.html', '.css', '.js', '.jsx', '.ts', '.tsx', '.vue', '.svelte', '.py', '.rb', '.go', '.rs', '.java', '.json', '.yaml', '.yml', '.sh']);
const EXCLUDE_RE = /(\/skills\/|\/audit\/|\/install\/|\/plugins\/|antislop\.md|README\.md|package\.json|LICENSE|contrast-check\.py|bin\/antislop\.js|antislop\.js)/;

function isTextFile(p) {
  return TEXT_EXT.has(path.extname(p).toLowerCase());
}

function cmdAudit(target) {
  const absTarget = path.resolve(target);
  const findings = [];

  function rel(p) {
    return path.relative(process.cwd(), p) || p;
  }

  function scanFile(file) {
    let content;
    try {
      content = fs.readFileSync(file, 'utf8');
    } catch (e) {
      return;
    }
    const lines = content.split(/\r?\n/);
    const inRoot = file.startsWith(ROOT);
    lines.forEach((line, i) => {
      if (!line.trim()) return;
      if (inRoot && EXCLUDE_RE.test(file)) return;
      checkLine(line, rel(file), i + 1);
    });
  }

  function checkLine(line, file, lineNo) {
    const add = (rule, why, match) => findings.push({ rule, why, file, line: lineNo, match: match.slice(0, 60) });
    const lc = line;

    if (lc.includes('—')) add('R-02', 'em dash not allowed in product text', lc);
    const cta = lc.match(/\b(get started|learn more|try now|explore|discover)\b/gi);
    if (cta) add('R-30', 'generic CTA', cta[0]);
    const buzz = lc.match(/\b(ai powered|revolutionary|seamless|next generation|cutting edge|ultimate|effortless|powerful)\b/gi);
    if (buzz) add('R-31', 'AI-marketing buzzword', buzz[0]);
    if (/\b\d{2,}\s*(k|m)?\s*\+?\s*(users|requests|uptime|countries|developers)\b/gi.test(lc) ||
        /\b99\.\d+%\b/.test(lc) ||
        /\b\d{1,3}\+?\s*(countries|teams)\b/gi.test(lc)) add('R-01', 'fabricated-looking statistic', lc.slice(0, 60));
    const names = lc.match(/\b(john doe|jane doe|jane smith|john smith|lorem ipsum|acme inc)\b/gi);
    if (names) add('R-04', 'placeholder/fake name', names[0]);
    if (/^\s*\/\/\s*[=*#\-]{10,}/.test(lc) || /^\s*\/\/\s*-{4,}/.test(lc) || /^\s*\/\*\s*-{4,}/.test(lc))
      add('R-15', 'decorative comment separator', lc.trim().slice(0, 60));
    if ((lc.includes('//') || lc.trim().startsWith('#')) && /[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}\u{2B00}-\u{2BFF}]/u.test(lc))
      add('R-15', 'emoji in comment', lc.trim().slice(0, 60));
    if (/\bTODO:\s*(improve|optimize|fix this|update|refactor|add more)\b/i.test(lc))
      add('R-15', 'vague TODO', lc.trim().slice(0, 60));
  }

  function walk(dir) {
    let entries;
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch (e) {
      return;
    }
    for (const e of entries) {
      const full = path.join(dir, e.name);
      if (e.isDirectory()) {
        if (!SKIP_DIRS.has(e.name)) walk(full);
        continue;
      }
      if (isTextFile(full)) scanFile(full);
    }
  }

  console.log('antislop audit — ' + rel(absTarget));
  if (fs.existsSync(absTarget) && fs.statSync(absTarget).isFile()) {
    scanFile(absTarget);
  } else {
    walk(absTarget);
  }

  for (const f of findings) {
    console.log('[' + f.rule + '] FAIL  ' + f.file + ':' + f.line + '  ' + f.match + '  -> ' + f.why);
  }
  console.log('---');
  if (findings.length === 0) {
    console.log('RESULT: PASS');
    process.exit(0);
  } else {
    console.log('RESULT: FAIL (' + findings.length + ' findings)');
    console.log('Fix the findings above, then re-run `antislop audit`.');
    process.exit(1);
  }
}

main();
