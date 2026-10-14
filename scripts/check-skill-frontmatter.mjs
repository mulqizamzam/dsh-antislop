#!/usr/bin/env node
/**
 * Every SKILL.md must parse as YAML frontmatter with a name and description, or
 * dsh-skill-filesystem drops the whole skill silently: an unquoted description
 * containing `: ` reads as a nested mapping and fails the parse.
 *
 *   node scripts/check-skill-frontmatter.mjs
 *
 * Exits 1 and names the offending file. Dependency-free, so it runs without an
 * install: the frontmatter shape is the flat `key: value` block the skill files
 * use, which is all this needs to check.
 */
import { readdir, readFile } from 'node:fs/promises'
import { dirname, join, relative } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = join(dirname(fileURLToPath(import.meta.url)), '..')
const skillsDir = join(root, 'skills')
const namePattern = /^[a-z0-9]+(?:-[a-z0-9]+)*$/
/** A bare `key: value` scalar line; anything else here is the shape this check cannot trust. */
const scalarLine = /^([A-Za-z][\w-]*):(?:[ \t]+(.+))?$/
const failures = []

for (const entry of (await readdir(skillsDir, { withFileTypes: true })).sort((a, b) => a.name.localeCompare(b.name))) {
  if (!entry.isDirectory()) continue
  const label = relative(root, join(skillsDir, entry.name, 'SKILL.md'))
  const raw = await readFile(join(skillsDir, entry.name, 'SKILL.md'), 'utf8')
  const match = /^---\r?\n([\s\S]*?)\r?\n---/.exec(raw)
  if (match === null) {
    failures.push(`${label}: missing YAML frontmatter`)
    continue
  }
  const fields = new Map()
  for (const line of match[1].split(/\r?\n/)) {
    if (line.trim() === '') continue
    const field = scalarLine.exec(line)
    if (field === null) {
      // An unquoted value carrying `: ` lands here: YAML reads it as a nested mapping.
      failures.push(`${label}: unquoted or non-scalar frontmatter line: ${line.slice(0, 60)}`)
      continue
    }
    const raw = field[2]?.trim() ?? ''
    // A quoted value must open and close with the same quote; `: ` inside an
    // unquoted one makes YAML parse a nested mapping and drop the whole skill.
    const quote = raw[0] === '"' || raw[0] === "'" ? raw[0] : undefined
    if (quote === undefined && raw.includes(': ')) {
      failures.push(`${label}: unquoted value contains ": ", which YAML reads as a nested mapping`)
      continue
    }
    if (quote !== undefined && !(raw.length >= 2 && raw.endsWith(quote))) {
      failures.push(`${label}: unbalanced ${quote} quote in frontmatter line: ${raw.slice(0, 60)}`)
      continue
    }
    fields.set(field[1], quote === undefined ? raw : raw.slice(1, -1))
  }
  const name = fields.get('name')
  const description = fields.get('description')
  if (name === undefined) failures.push(`${label}: frontmatter requires a name`)
  else if (!namePattern.test(name)) failures.push(`${label}: "${name}" is not kebab-case`)
  if (description === undefined) failures.push(`${label}: frontmatter requires a description`)
  else if (description === '') failures.push(`${label}: description is empty`)
}

if (failures.length > 0) {
  for (const failure of failures) process.stderr.write(`${failure}\n`)
  process.stderr.write(`\n${failures.length} skill(s) would be dropped from the catalog. Quote any description containing ": ".\n`)
  process.exit(1)
}
process.stdout.write('every SKILL.md parses with a name and description\n')