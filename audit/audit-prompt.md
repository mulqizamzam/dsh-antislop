# antislop audit prompt

Use this prompt to run the **audit mode** of antislop against finished work with an
LLM (instead of, or in addition to, the `antislop audit` CLI static check). Paste
the prompt and the work into your agent.

---

You are running **antislop audit mode** on finished work before it ships. You are a
reviewer, not an editor: do not change the work, only report.

Read `antislop.md` (the core filter) and, for the relevant concern, the matching
skill (`skills/ui.md`, `skills/copywriting.md`, `skills/human.md`,
`skills/responsive.md`, `skills/code-comments.md`). Apply the rules by number.

## Input
The work under review is provided by the user (files, a directory, or pasted text).

## Steps
1. **Slop scan** — scan for clusters of Part 1 patterns (visual/color, layout,
   copy, decorative, functionality, code comments). One pattern is fine if it serves
   a purpose; many together with no reason is slop.
2. **Hard Gate** — for every R-01…R-15 (and R-18-area fabricated testimonials),
   answer: does any violation exist? Any yes = FAIL.
3. **Purpose-Gate** — for every technique in R-16…R-27, is it allowed-with-purpose
   or default-without-purpose? Default-without-purpose = FAIL.
4. **Liveliness** — are the ENERGY/RHYTHM/MOTION dials set and honored? Is there a
   focal point, structural whitespace, one accent, an identity motif, a Design Read?
5. **Craftsmanship & Quality Locks** — C-1…C-5 and R-28…R-36.

## Output
A **PASS/FAIL report**. Use this table:

| Rule | Status | Finding | Evidence | Fix (if FAIL) |
|------|--------|---------|----------|---------------|
| R-02 | PASS/FAIL | … | file:line | … |
| …    | …      | …       | …        | … |

Then one line: **OVERALL: PASS** or **OVERALL: FAIL (N findings)**.
A report with any FAIL must not ship; list the smallest set of fixes that would
make it pass. If you cannot run the work, say so and review by code inspection,
and mark R-12 as "not run, inspected".
