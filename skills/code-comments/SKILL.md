---
name: antislop-code-comments
description: "Code comment hygiene for AI coding agents: remove generic AI-slop comments, keep the valuable ones, never touch the code."
whenToUse: "Load with the core 'antislop' skill."
---

> Part of the antislop system. Read together with `skills/core/SKILL.md` (core). Load this skill ONLY when writing or editing code comments. It filters slop comments and keeps useful ones. It changes comments only, never the code.

## How to use this skill

This skill supplements the core Delivery Gate. Load it whenever you are about to write, edit, review, or prune code comments. Keep `skills/core/SKILL.md` open beside it; this file is a focused extension, not a replacement.

The single most important rule is the SCOPE GUARDRAIL from R-15:

**SCOPE GUARDRAIL**: Comments are the ONLY thing this skill touches. Never modify executable code, identifiers, imports, formatting, indentation, control flow, or logic. When in doubt, leave the code alone. Every comment must add information the code does not already show, read short and natural in sentence case, and state its reason in one line.

Apply these core rules while you work:

- **R-15** (Code comments: SCOPE GUARDRAIL): only comments change; code stays untouched. Every comment must add info the code doesn't show, read naturally in sentence case, and carry its reason in one line.
- **R-02** (no em dash in any text): this includes comment prose. Use a period, colon, or comma instead of `—`.
- **R-31** (no buzzwords): applies to comment prose too. Say what you mean; drop words like "leverage", "utilize", "robust", "seamless", "optimal".
- **R-36** (every decision has a written reason): the keystone rule. A comment exists because the code can't explain itself. If you can't state the reason in one line, the comment probably shouldn't exist.

The filter removes generic AI-slop comments and keeps the valuable ones. It never touches the code. That boundary is non-negotiable.

## Comments that add nothing (REMOVE)

Each pattern below shows what to spot and how to fix it. These are the classic tells of machine-generated commentary.

### Decorative separators

**Tell:** banner lines, ALL-CAPS labels, and box-drawn headers that exist only to look structural.

```js
// ============================================
// USER SERVICE
// ============================================
function getUser(id) { ... }
```

**Why:** no human bothers drawing a box to mark a function. It reads as template filler.

**Fix:** delete the banners. Keep a real comment only if it explains the module's purpose.

### Restating the obvious

**Tell:** a comment that just names what the line already says.

```js
// Initialize the variable
let count = 0;

// User class
class User {}
```

**Why:** the code states it plainly. The comment doubles the reading cost for zero new information.

**Fix:** remove. The declaration is the declaration.

### Workflow narration

**Tell:** step-by-step captions walking through trivial control flow.

```js
// Step 1: Validate
validate(input);
// Step 2: Compute
const result = compute(input);
// Step 3: Return
return result;
```

**Why:** the sequence is visible in the code. Numbered steps are a lecture the reader didn't ask for.

**Fix:** collapse to one comment only if a non-obvious reason exists, e.g. `// Validation must run before compute because compute trusts its input.`

### Empty labels

**Tell:** vague signposts that point at nothing specific.

```js
// Main logic
// Important: read this
```

**Why:** they add no information and pretend to. "Important" with no content is noise.

**Fix:** delete. If the section truly is subtle, say why in one line.

### Vague TODOs

**Tell:** future-work notes with no actionable detail.

```js
// TODO: improve this
// FIXME: stuff
```

**Why:** a marker with no owner, no scope, and no reason is a gravestone, not a task.

**Fix:** either make it concrete (`// TODO: bound cache to 1000 entries to cap memory on low-RAM hosts`) or delete it. Per R-36, a reason is required.

### Signature echo

**Tell:** JSDoc or doc comments that merely repeat the name and parameter list.

```js
/**
 * @param {number} a the first number
 * @param {number} b the second number
 * @returns {number} the sum
 */
function add(a, b) { return a + b; }
```

**Why:** the types and names already say this. The doc restates the signature.

**Fix:** delete unless it conveys something the signature can't, like why the function exists or what contract it guarantees.

### Decorative emoji

**Tell:** icons used as status or decoration in comments.

```js
// ✅ Validation
// 🚀 Launch the worker
```

**Why:** emoji adds no information and screams "generated". It also breaks search and screen readers.

**Fix:** remove. Plain sentence-case text carries the meaning.

### End markers

**Tell:** closing tags that narrate the end of a block.

```js
} // end if
} // end of function
# end of loop
```

**Why:** the brace or indent already closes the block. The marker is pure redundancy.

**Fix:** delete. Modern editors show block boundaries on hover.

## How it should read

**Line-by-line narration** (a comment on every trivial line) becomes **one concise comment per logical block**. Group the why, not the what. If a block is self-explanatory, write no comment at all.

**Stiff or loud wording** (formal tone, ALL-CAPS, ceremonial phrasing) becomes **short sentence-case developer voice**. Write like you're explaining it to a teammate in a quick message.

Bad:

```js
// THE FOLLOWING SECTION IS RESPONSIBLE FOR VALIDATING USER CREDENTIALS
```

Good:

```js
// Validate credentials before issuing a token.
```

The good version is one line, sentence case, and it states the reason (before issuing a token). That is the voice to aim for.

## Not a ban (PRESERVE these)

This is a filter, not a style guide. The following comment types earn their place because they explain something the code cannot show on its own. Keep them, and keep them clear:

- **Business logic / intent**: why the system behaves this way, not just what it does.
- **Architectural decisions**: why this shape was chosen over another.
- **Security**: threat assumptions, trust boundaries, what is untrusted.
- **Performance trade-offs**: why something is slower, faster, or cached.
- **Concurrency**: locking, ordering, race conditions, why a sleep or retry exists.
- **Protocol**: wire format, versioning, what the other side expects.
- **API contracts**: what a caller must guarantee or will receive.
- **Workarounds**: the bug or quirk being dodged, and where it comes from.
- **Edge cases / assumptions**: inputs that break the naive path.
- **Licensing**: required attribution or usage terms.

Example that must stay:

```js
// Stripe may retry webhook deliveries for up to three days.
// Ignore duplicate events using the event ID.
```

The code can dedupe by event ID, but it cannot tell the reader that Stripe retries for three days and that this is the reason dedupe matters. That is exactly the information a comment is for.

A comment earns its place when it explains something the code doesn't show.

## Code Comment Checklist

Run this with the core Delivery Gate. Every box must be YES before you ship:

- [ ] Every comment adds information the code doesn't show (R-36).
- [ ] No decorative separators or ALL-CAPS banners.
- [ ] No restating the obvious line, declaration, or signature.
- [ ] No step-by-step narration (`Step 1`, `Step 2`, ...).
- [ ] No empty labels or vague TODOs without a reason.
- [ ] No decorative emoji or end markers (`// end if`).
- [ ] Density is one comment per logical block, not one per line.
- [ ] Remaining comments are short, natural, and sentence-case.
- [ ] SCOPE GUARDRAIL held: only comments changed, code untouched (R-15).

If any box is NO, fix the comment, not the code. The code is out of scope.
