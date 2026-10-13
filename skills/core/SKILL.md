---
name: antislop
description: Anti-slop filter for AI coding agents. Use when generating or reviewing UI, copy, human-centered behavior, responsive layout, or code comments.
whenToUse: "UI work, copy/text, accessibility, responsive layout, code comments — load with the core."
---

> Anti-slop filter for AI coding agents. Use it whenever you generate or review
> UI, copy, human-centered behavior, responsive layout, or code comments.
>
> **This is a filter, not a style guide.** It pushes for specific, lively output
> without forcing one visual look. It bans technique *without purpose*, not
> technique itself.

---

## What this is (and isn't)

`antislop.md` is a **filter**. It stops AI coding agents from producing generic,
recognizable "AI slop", while avoiding the opposite failure: a sterile, lifeless
default.

- It does **not** impose an aesthetic: no prescribed colors, fonts, layouts, or house style.
- It does **not** ban visual techniques (gradients, glass, badges, cards, motion). Those are tools.
- It does two things only:
  1. **Purpose test**: every visual or copy decision must answer *"what does this serve?"* Write the reason down.
  2. **Liveliness bar**: the output must be alive and specific, not merely "clean."

Removing slop leaves a void. Liveliness must be **added**, not assumed. The fix is
never "add more bans"; it is "state the purpose and raise the liveliness bar."

### The one question

Before calling anything done, answer:

> If the logo and product name were swapped, would this still feel unique and have its own character?

If the answer is **no**, it is too generic. Start over.

### How the pieces fit

- `DESIGN.md` (or your brand/style direction) gives the work its **soul**: identity, personality, palette, type, mood.
- `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` (etc.) **routes** the agent: "for UI/copy/people/mobile/comments work, read `antislop.md` as the filter, then the matching skill."
- `antislop.md` rejects slop and requires liveliness. It does **not** invent direction.
- The five skills add concern-specific depth and are loaded **only when needed**:
  - `skills/ui/SKILL.md`, color, layout, components, decoration, motion
  - `skills/copywriting/SKILL.md`, headlines, CTAs, tone, anti-AI-writing patterns
  - `skills/human/SKILL.md`, contrast, keyboard, focus, states for real people
  - `skills/responsive/SKILL.md`, layouts that hold up on small screens
  - `skills/code-comments/SKILL.md`, keep useful comments, drop the slop

---

## The Craftsmanship Standard (C-1 … C-5)

"Not slop" is the floor, not the goal. A result passes when it meets five
preference-agnostic criteria. Use these as questions, not recipes.

- **C-1 Intentionality** — every decision has a reason you can articulate. "It's the AI default" is a red flag.
- **C-2 Functional completeness** — every interactive element works, or it does not exist.
- **C-3 Content-driven composition** — every section exists because the product needs it, not because every landing page has one.
- **C-4 Resilience** — the UI holds up in every state (empty/loading/error), theme, breakpoint, and keyboard-only use.
- **C-5 Evidence over claims** — anything presented as fact is real and verifiable, or not shown at all.

---

## Part 1 — Slop patterns (diagnostic scan, not a ban list)

Scan your output for clusters. A single pattern is fine if it serves a purpose
(see Purpose-Gate). What makes a result slop is *many of these together with no
reason*. The Hard Gate rules below are absolute; everything else must pass the
purpose test.

### Visual & color
| Pattern | Telltale signs |
|---|---|
| Generic gradient | blue→purple, blue→cyan, purple→pink, full-page colored glow, radial orbs |
| Glass everywhere | blur on navbar + cards + modals + sidebar at once |
| Everything pill | buttons, inputs, cards, badges, modals all rounded to capsules |
| Floating page | every component carries a large shadow |
| Glow everywhere | glow on cards, buttons, icons, borders, backgrounds simultaneously |
| AI default palette | neon, pastel blocks, rainbow gradients, purple-and-black "tech" |
| Background grid | graph-paper lines, dot grids, blueprint texture as decoration |
| Too many colors | 5–7 colors on one page with no system |
| Accent spread | one accent on every button, icon, link, line, and glow |
| Sterile default | flat white, thin grey borders, no texture, no identity (the "safe" over-filter) |

### Layout & components
| Pattern | Telltale signs |
|---|---|
| Template order | hero → 3 cards → screenshot → features → testimonials → FAQ → footer, every time |
| Clone cards | identical size/icon/padding/layout across all cards |
| Bento mosaic | differently-sized cards tiling a section as the default "app-like" layout |
| Fake terminal | styled terminal with typed commands as the hero visual |
| "How it works" ×3 | round icon + number 1/2/3, always three steps |
| "Trusted by" bar | row of generic logos straight under the hero |
| "Most popular" card | middle tier always highlighted with a capsule badge |
| 3 pricing tiers | three columns whatever the real structure |
| 4-column footer | Product / Company / Resources / Legal, no variation |
| Uniform rhythm | every section = centered title + subtitle + identical card grid |
| Broken mobile | horizontal overflow, clipped cards, colliding text, unusable navbar |

### Copy & content
| Pattern | Telltale signs |
|---|---|
| Em dash | "Fast, secure — and built for developers." |
| Generic CTAs | Get Started, Learn More, Try Now, Explore, Discover |
| Buzzwords | AI Powered, Revolutionary, Seamless, Next Generation, Cutting Edge |
| Fake stats | 10K+ Users, 99.9% Uptime, 500M Requests, 120+ Countries |
| Fake testimonials | AI avatars, random names/titles, fictional reviews |
| Fabricated trust | "SOC 2 compliant", "Enterprise-grade security", "300% faster" with no evidence |
| Demo without product | sells something never shown working; no ToS, no Privacy Policy |

### Decorative elements
| Pattern | Telltale signs |
|---|---|
| Generic icons | sparkle, star, magic, lightning, diamond, cube, robot, AI orb |
| Lucide look | every icon from one thin-stroke rounded set, the default icon silhouette |
| Emoji decoration | 🚀 in headlines, ✅ on every bullet, 🔥 on CTAs |
| Small arrows | `→` / `↗` on almost every button as pure decoration |
| Left stripe | thin colored vertical bar on card/row/header edges, meaning nothing |
| Capsule badges | pill + thin border + glow + dot + uppercase "AI Powered / Beta / New" |
| Generic type | huge monospace headings, wide-tracked uppercase "HOW IT WORKS" |
| Stock illustrations | Undraw/Storyset/3D blobs with no connection to the product |

### Functionality & content
| Pattern | Telltale signs |
|---|---|
| Dead controls | buttons/links/forms that do nothing |
| Happy-path only | no empty/loading/error state |
| Irrelevant FAQ | "Is my data secure?" with no product-specific relevance |
| Assumed assets | logo, avatars, or photos invented without instruction |
| Ghost nav | navbar links to pages/sections that don't exist |
| Script patching | a `.py`/`.js` helper doing `str.replace` on `.css`/source to "add" a feature |

### Code comments
| Pattern | Telltale signs |
|---|---|
| Decorative separators | `// ============` banners, ALL-CAPS labels, box-drawn headers |
| Restating the obvious | `// Initialize the variable` above `let count = 0` |
| Step narration | `// Step 1: Validate` … `// Step 2: Process` … `// Step 3: Return` |
| Empty labels | `// Main logic`, `// Core logic`, `// Important: read this` |
| Vague TODOs | `// TODO: improve this`, `// add more validation` |
| Signature echo | JSDoc that just repeats the function name and params |
| Emoji in comments | `// ✅ Validation`, `// 🚀 Performance` |
| End markers | `} // end if`, `# end of function` |

---

## Part 2 — Mandatory rules

All rules apply. They are grouped into three tiers so the mechanism is explicit:
**Hard Gate** rules are absolute, **Purpose-Gate** rules allow a technique but
require a written reason, **Quality Locks** are consistency requirements.

### Group 1 — Hard Gate (absolute, any violation = FAIL)

#### R-01 — No fabricated data
- **FORBIDDEN:** statistics or numbers without a real source (10K+ Users, 99.9% Uptime, 500M Requests).
- If real data isn't available, show **no numbers at all**. Empty is better than deceptive.

#### R-02 — No em dash
- **FORBIDDEN:** the em dash character (`—`) in any text your agent generates for a product: UI strings, marketing/landing copy, or code-comment prose.
- Use comma, period, colon, or parentheses instead. Text must feel natural and human.
- *Scope:* this rule targets the text your agent **produces** for a product, not antislop's own documentation. The `antislop.md` headings, the example above, the `skills/*.md` files, `audit/`, `README.md`, and the installers are the filter itself, so they are exempt (a linter does not lint itself), and `antislop audit` already excludes them. The em dashes you see in those docs are structural separators, not product copy.

#### R-03 — Mobile must be flawless
- **REQUIRED:** no horizontal overflow; text stays in its container; cards don't collide or clip.
- Navbar stays usable; tap targets are at least 44px; spacing is consistent across breakpoints.
- Responsiveness is part of the design, not an add-on.

#### R-04 — Clarify before creating assets
- **REQUIRED:** before creating any asset without explicit instruction, ask or use a clear placeholder:
  - logo/icon (shape, color, concept)
  - avatars / profile photos / people images
  - statistics and numbers
  - names, job titles, identities in testimonials
  - navigation structure and page layout
- Placeholders: product name as text, initial-based avatars, `[REAL DATA]`. Never disguise a placeholder as final.

#### R-05 — Navigation points to real destinations
- **FORBIDDEN:** navbar/footer links to pages or sections that don't exist.
- Every nav item has a real, accessible destination. Unbuilt features are omitted or labeled "Coming soon."

#### R-06 — Color contrast (WCAG AA)
- **REQUIRED:** normal text ≥ 4.5:1, large text (18px+) ≥ 3:1.
- **FORBIDDEN:** light-grey-on-grey; white text over a gradient that's light in places.
- Test across the whole area the text passes over, not one point.

#### R-07 — Every interactive element works
- A control must do one real thing: scroll to an existing section, open/close a dialog (Esc-closable), toggle a state, perform an external action (`mailto:`/real URL), or submit a form with feedback.
- **FORBIDDEN:** dead buttons/links. If something can't have a destination yet, remove it or ship a clear `// TODO` + visible "Coming soon" label.

#### R-08 — Required UI states
- Every data-displaying UI needs at least three states: **empty**, **loading**, **error**.
- A UI designed only for the ideal condition isn't ready for real use.

#### R-09 — Keyboard accessible + visible focus
- **REQUIRED:** `Tab`/`Shift+Tab` follow visual order; `Enter`/`Space` activate; dialogs close on `Esc`.
- **REQUIRED:** every focused element has a clearly visible focus indicator.
- **FORBIDDEN:** `outline: none` / `outline: 0` without a better custom indicator.

#### R-10 — No source/CSS patching via scripts
- **FORBIDDEN:** implementing or altering UI by running a script that rewrites source/CSS with string replacement.
- Build features in source where they belong. A patch script is broken by design.

#### R-11 — Every shipped theme works
- If you ship a theme toggle, **both** modes must be fully functional (contrast, color, components verified in each).
- **FORBIDDEN:** shipping a mode where base styles, fonts, or layout break.

#### R-12 — Verify before delivery
- Run or build the app before declaring done. Check the console for errors.
- Click through **every** interactive element, one at a time: a link navigates somewhere real, a form shows validation/success, a toggle changes state, a modal opens/closes.
- If the deliverable can't be run, say so and verify by code inspection instead. Report the click-through as evidence. A PASS without that list is not a PASS.

#### R-13 — FAQ must be product-specific
- **FORBIDDEN:** template questions not specific to the product ("Is my data secure?", "Can I cancel anytime?").
- Every FAQ question addresses a real concern of this product's users. No such questions known → no FAQ.

#### R-14 — Design direction required
- Before building UI, load the direction: `DESIGN.md` or explicit brand guidance from the user.
- If none exists, ask, or clearly label the result *"draft without direction"* and set honest default dials **ENERGY 1 / RHYTHM 1 / MOTION 1** (see Part 3). Never silently fall into a sterile neutral default.
- A design built without direction is a draft, not a deliverable.

#### R-15 — Code comments: scope + no slop
- **Scope guardrail:** comments are the only thing this touches. Never modify executable code, identifiers, imports, formatting, indentation, control flow, or logic. When in doubt, leave the code alone.
- Every comment must add information the code doesn't already show, read short and natural in sentence case, and state its reason in one line.
- **FORBIDDEN:** decorative separators, obvious restatements, step narration, empty labels, vague TODOs, signature echo, decorative emoji, end markers.
- Preserve comments that explain business logic, architecture, security, performance trade-offs, concurrency, protocol, API contracts, workarounds, edge cases, assumptions, licensing.

### Group 2 — Purpose-Gate (technique allowed, purpose required)

Each technique is allowed. It FAILS only when it appears as a default with no stated
purpose, or the reason isn't written down.

#### R-16 — Color & gradients
- **FORBIDDEN as default without purpose:** blue→purple/cyan/pink gradients as primary color, harsh/rainbow gradients, purple-and-black, neon/pastel palettes, radial orbs, colored glow backgrounds.
- A gradient that separates hierarchy levels is craft; the same gradient on every section is a default. Keep the reason written.

#### R-17 — Icons
- **FORBIDDEN as default without purpose:** sparkle/star/magic/lightning/diamond/orb/robot as feature icons; an icon set chosen for its recognizable library look (Lucide-style) instead of relevance.
- Icons must be genuinely relevant; write the relevance down when the glyph is generic. None is better than a wrong one.

#### R-18 — Typography
- **FORBIDDEN as default without purpose:** large monospace purely for "terminal" aesthetics; uppercase labels with extreme tracking (`HOW IT WORKS`).
- Choose type from brand character, not the model's default pick, and write the reason. Typography must improve readability.

#### R-19 — Background patterns
- **FORBIDDEN as default without purpose:** grid squares, blueprint lines, graph paper, dot patterns as a background.
- Use texture only when it supports the product's identity, with the reason written.

#### R-20 — Button arrows
- Arrows (`→` / `↗`) are not the default identity for every button. Use one only where it adds a direction cue, sized proportionally, purpose written.

#### R-21 — Badges
- **FORBIDDEN as default without purpose:** capsule badges "AI Powered / Beta / New / Secure / Fast" without context.
- A badge is allowed only if functionally needed (a real status/label), need written. Avoid the full capsule + border + glow + dot + uppercase combo.

#### R-22 — Glassmorphism
- Accent only, not the character of the whole UI. Dose cap: blur/`backdrop-filter` on at most 1–2 elements. **FORBIDDEN** on navbar+cards+modals+sidebar simultaneously.

#### R-23 — Shadow
- Shadow marks elevation, not float. Use it selectively as an elevation marker, reason written. Most elements sit flat.

#### R-24 — Glow
- Focus accent on at most 1–2 important elements. **FORBIDDEN** on card+button+badge+icon+background+border at once.

#### R-25 — Feature cards
- **FORBIDDEN as default without purpose:** all cards identical in size/icon/padding/layout.
- Vary by content hierarchy, reason written. Not every feature needs to be a card.

#### R-26 — Animation
- Must have a clear UX purpose, written down. **FORBIDDEN as default without purpose:** every element using Fade-Up + Float + Scale + Bounce together.
- Motion must match the declared MOTION dial (Part 3).

#### R-27 — Illustrations
- **FORBIDDEN as default without purpose:** Undraw/Storyset/3D-blob illustrations with no product connection.
- Use real screenshots or none if no original illustration fits.

### Group 3 — Quality Locks (consistency)

#### R-28 — Layout structure
- **FORBIDDEN:** template layouts (hero+3 cards, hero+fake stats, "how it works" ×3, bento mosaic, fake terminal hero, 3 pricing columns, "trusted by" bar, 4-column footer, uniform section rhythm).
- Build around actual content needs; follow the declared RHYTHM dial.

#### R-29 — Border radius
- Consistent with the design system. **FORBIDDEN:** making every element pill-shaped. Radius variation is a hierarchy tool.

#### R-30 — CTA wording
- **FORBIDDEN:** "Get Started / Learn More / Try Now / Explore / Discover" as default CTAs.
- CTAs must be specific to the product and the intended action: "Start your free trial", "Watch the live demo".

#### R-31 — Buzzwords
- **FORBIDDEN:** "AI Powered, Revolutionary, Seamless, Next Generation, Cutting Edge, Intelligent, Ultimate, Powerful, Effortless".
- Use specific language that explains real benefits. Show evidence, not claims.

#### R-32 — Visual identity
- The result needs its own character: a specific palette, a typeface chosen for a reason, a unique composition, clear hierarchy per section.

#### R-33 — Dark mode
- Choose a theme from brand/product/audience. Dev/terminal/creative tools have legitimate dark reasons; content-first products usually don't.
- No strong reason for a fixed theme → build a working light/dark toggle. **FORBIDDEN:** using this rule to defer requested work.

#### R-34 — Palette
- **REQUIRED:** ≤ 2–3 core colors + 1 accent. **FORBIDDEN:** 5+ colors without a clear system. Neutrals (white/black/grey) don't count as core.

#### R-35 — No cloning popular products
- **FORBIDDEN:** an overall visual that mimics Linear/Vercel/Stripe/Notion/Apple without being asked.
- Visual references are inspiration, not templates. The product needs its own identity.

#### R-36 — Every decision has a written reason (keystone)
- Before finishing, write a one-line reason for every major decision (color, layout, type, spacing, cards, illustration, comment).
- If the reason can't be written in one line, the decision is invalid and must be revisited. This is the rule the Purpose-Gate group checks.

---

## Part 3 — Liveliness Toolkit

A filter removes slop but cannot add energy. Liveliness must be **added** deliberately.

### Three dials (required, 1–3)

Every result must set three dials explicitly and hold them start to finish:

| Dial | 1 (Calm) | 2 (Balanced) | 3 (Bold) | Answers |
|---|---|---|---|---|
| **ENERGY** | linear, GOV.UK | Stripe, Vercel | Awwwards, agency | How hard does it say hello? |
| **RHYTHM** | uniform grid | consistent + a few breaks | asymmetric, mixed | How much do sections vary? |
| **MOTION** | hover only | scroll-reveal, transitions | parallax, pin, choreography | How much motion, and why? |

Three levels (not ten) keep liveliness enforceable: a reviewer can reliably tell "uniform or varied?", not "is this a 6 or 7?".

### Levers (how dials become decisions)
- **One focal point per screen**: exactly one clearly-most-important element; the rest defer.
- **Hierarchical contrast**: size/weight/color differentiated on purpose.
- **Whitespace as structure**: empty space separates and sets rhythm, not leftover.
- **One deliberate accent**: used sparingly at the key moment. Zero = sterile; everywhere = slop.
- **Identity motif**: one specific, repeated pattern/gesture/voice that makes the work belong to the product.

### Design Read (how the dials are set)

Before generating, declare one line:

> Reading this as: `<page kind>` for `<audience>`, in a `<visual language>` style, dial `<ENERGY/RHYTHM/MOTION>`.

1. **Direction exists** (DESIGN.md or a brief that expresses energy/mood) → infer dials and proceed.
2. **Direction ambiguous** → ask exactly ONE decisive question, never a dump. Use the answer to set dials.
3. **No direction, can't ask** → label *"draft without direction"*, set honest defaults **ENERGY 1 / RHYTHM 1 / MOTION 1**, and don't present it as a deliverable.

---

## Delivery Gate (the audit — run before shipping)

Run this gate before delivering. Output a **PASS/FAIL report**, one line per item,
every PASS backed by concrete evidence (e.g. "R-07 PASS: every button has a real
`href`/`onClick`; no dead controls", "R-12 PASS: built and clicked every control —
Signup → /signup, empty form → validation, mobile menu → opens/closes, no console
errors"). A report containing a FAIL must never ship; fix, then re-run.

Also see `audit/audit-prompt.md` for an LLM-driven review pass, and the `antislop audit`
CLI for a fast static check (`npx antislop audit <path>`).

### Block 1 — Hard Gate (all answers must be NO)
- [ ] em dash anywhere in text, outside the R-02 carve-out? *(R-02)*
- [ ] horizontal overflow / text escaping container / broken mobile layout? *(R-03)*
- [ ] any statistic without a real source? *(R-01)*
- [ ] any fictional testimonial (AI avatars, random names/titles)? *(R-18-area)*
- [ ] visual assets (logo, avatar, stats, nav, names) created without instruction/confirmation and without honest placeholder? *(R-04)*
- [ ] navbar/footer links to non-existent sections/pages? *(R-05)*
- [ ] text below WCAG AA contrast (4.5:1 / 3:1)? *(R-06)*
- [ ] any button/dropdown/form that does nothing, no real behavior, no `// TODO` + label? *(R-07)*
- [ ] UI lacks empty / loading / error state? *(R-08)*
- [ ] can't navigate by keyboard (Tab/Enter/Esc) or no visible focus? *(R-09)*
- [ ] feature added by patching source/CSS via script? *(R-10)*
- [ ] a shipped theme breaks in one mode? *(R-11)*
- [ ] delivered without build/run + recorded click-through? *(R-12)*
- [ ] FAQ has template questions not specific to the product? *(R-13)*
- [ ] built without direction and not labeled "draft without direction" with default dials? *(R-14)*
- [ ] code comments modify code, or contain slop comments? *(R-15)*

### Block 2 — Purpose-Gate (technique allowed, reason required; FAIL if default without purpose)
- [ ] gradients/glows as default with no stated hierarchy/brand purpose? *(R-16)*
- [ ] generic icons (sparkle/star/orb) or icon set picked for its library look, no written relevance? *(R-17)*
- [ ] large monospace / wide-tracked uppercase / type chosen without brand reason? *(R-18)*
- [ ] background grid/blueprint/dots without written identity purpose? *(R-19)*
- [ ] arrows on almost every button as pure decoration? *(R-20)*
- [ ] capsule badges with no real function, or full capsule+border+glow+dot combo? *(R-21)*
- [ ] glassmorphism on >1–2 elements at once? *(R-22)*
- [ ] large shadow on every component, no elevation reason? *(R-23)*
- [ ] glow on cards+buttons+badges+icons+backgrounds+borders at once? *(R-24)*
- [ ] all feature cards identical with no hierarchy reason? *(R-25)*
- [ ] all elements animate together with no UX purpose, or motion contradicts MOTION dial? *(R-26)*
- [ ] generic illustrations with no product connection? *(R-27)*

### Block 3 — Liveliness (all answers must be YES)
- [ ] dials set and explicit (ENERGY / RHYTHM / MOTION)?
- [ ] output consistent with the claimed dials (RHYTHM 3 but uniform sections = FAIL)?
- [ ] at least one clear focal point per screen?
- [ ] whitespace structural, not leftover?
- [ ] one deliberate accent (not zero, not everywhere)?
- [ ] an identity motif (one specific, repeated gesture/voice)?
- [ ] a Design Read declared before generation?

### Block 4 — Craftsmanship & Quality Locks (all answers must be NO)
- [ ] any decision whose only justification is "it's the AI default"? *(C-1)*
- [ ] any interactive element does nothing, no label? *(C-2)*
- [ ] any section exists only to fill a template? *(C-3)*
- [ ] UI breaks in any state/theme/breakpoint/keyboard? *(C-4)*
- [ ] any fabricated testimonial/stat/claim? *(C-5)*
- [ ] template layout / contradicts RHYTHM dial? *(R-28)*
- [ ] everything pill-shaped, no radius variation? *(R-29)*
- [ ] CTAs still generic? *(R-30)*
- [ ] AI marketing buzzwords present? *(R-31)*
- [ ] result feels generic if logo/name swapped? *(R-32)*
- [ ] dark mode forced without reason, or required toggle deferred? *(R-33)*
- [ ] palette exceeds 2–3 core + 1 accent without a system? *(R-34)*
- [ ] overall look clones a popular product? *(R-35)*
- [ ] any major decision whose reason can't be written in one line? *(R-36)*

If any answer is wrong (YES in Blocks 1/2/4, or NO in Block 3), do not deliver.
Fix it, re-run the gate, then ship. Delivery without a clean gate is a failure.

---

## Install & load

- First-time users: read `README.md`.
- Quick install: `npx antislop init` (interactive) or `./install/install.sh`.
- The installer writes a small **pointer block** into your agent's entry file
  (`CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, `.clinerules`, `.windsurfrules`, etc.)
  so antislop loads every session, and copies the core + the skills you choose.
- Load only the skill a task needs: UI work → `skills/ui/SKILL.md`; copy →
  `skills/copywriting/SKILL.md`; accessibility → `skills/human/SKILL.md`; mobile →
  `skills/responsive/SKILL.md`; comments → `skills/code-comments/SKILL.md`.
