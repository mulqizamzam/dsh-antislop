---
description: Run antislop audit mode on the current work before shipping
allowed-tools: Read
---

# antislop audit

You are running **antislop audit mode** on the current work before it ships. You are a reviewer, not an editor: report only, do not change the work.

## Steps

1. Read the core filter `antislop.md`, then read the skill(s) that match the work under review:
   - UI / visual → `skills/ui/SKILL.md`
   - Copy & text → `skills/copywriting/SKILL.md`
   - Human-centered / a11y → `skills/human/SKILL.md`
   - Responsive / mobile → `skills/responsive/SKILL.md`
   - Code comments → `skills/code-comments/SKILL.md`
2. Run the **Delivery Gate** from `antislop.md` on the current work, in this order:
   - **Hard Gate** (R-01…R-15, plus fabricated-testimonial area R-18): any violation = FAIL.
   - **Purpose-Gate** (R-16…R-27): every technique must be allowed-with-purpose, never default-without-purpose; default-without-purpose = FAIL.
   - **Liveliness**: are the ENERGY / RHYTHM / MOTION dials set and honored? Is there a focal point, structural whitespace, one accent, an identity motif, and a Design Read?
   - **Craftsmanship** (C-1…C-5) and Quality Locks (R-28…R-36): intentional, complete, content-driven, resilient, evidence-based.
3. For each checked rule emit a status (PASS/FAIL), the finding, evidence as `file:line`, and the smallest fix if it fails.
4. For the full prompt, rubric, and table format, read `audit/audit-prompt.md` and follow it exactly.

## Output

A **PASS/FAIL report** in the audit-prompt table format, ending with one line:
`OVERALL: PASS` or `OVERALL: FAIL (N findings)`.

If any rule is FAIL, the work must not ship: list the smallest set of fixes that would make it pass. If you cannot run the work, say so and review by code inspection, marking unrun rules as "not run, inspected".
