---
name: antislop-ui
description: UI and visual skill for antislop. Use when building or editing any interface: color, layout, components, motion.
whenToUse: "Load with the core 'antislop' skill."
---

> Part of the antislop system. Read together with `antislop.md` (core). Load this skill ONLY when the task builds or edits a website, web app, or any interface: color, layout, components, decoration, motion.

---

## How to use this skill

This file is a **supplement**, not a replacement. The core `antislop.md` owns the Delivery Gate (R-12) and the rule numbering. You do not re-issue or re-number those rules here — you cite them and give the UI-specific shape of each violation.

Load order:

1. Read the core (`antislop.md`) first. It sets the dials (ENERGY 1–3, RHYTHM 1–3, MOTION 1–3), the purpose test ("what does this serve?"), and the liveliness levers (one focal point, hierarchical contrast, whitespace as structure, one deliberate accent, identity motif).
2. Load this skill when the task touches anything visual: palette, layout, components, decoration, animation.
3. Before delivery, run the **UI Skill Checklist** at the bottom *alongside* the core Delivery Gate (R-12). Both must pass.

Two principles this skill enforces above all:

- **No technique is banned, only technique without purpose.** A gradient is fine if it marks depth on a real surface (R-16). A glow is fine if it shows focus (R-24). The slop is the *default* version applied with no reason.
- **A dead-flat page is still slop.** The fix for "too much decoration" is never "remove decoration." The fix is a `DESIGN.md` direction (R-14, R-32) and dials turned up deliberately (C-1). The over-filtered void fails the liveliness bar just as hard as the neon orb.

Every entry below follows the same spine: **Tell** (what the slop looks like), **Why** (why a human reads it as cheap), **Fix** (what to do, citing the rule).

---

## Visual & Color

### Generic gradient
**Tell** — Full-bleed `linear-gradient(135deg, #6366f1, #a855f7)` hero, or any blue→purple sweep. No light source, no second stop, no meaning.
**Why** — It is the exact same fill every model emits on turn one. It signals "the agent didn't think about color." (R-16, R-34)
**Fix** — Open `DESIGN.md`. Pick ≤3 core colors + 1 accent that relate to the product's actual context. A gradient is allowed **only** to show elevation or a real light direction on a specific surface — never as a page background. Before: `hero bg: indigo→violet`. After: `hero bg: #0E1116 (ink), accent #FF6B35 on the single CTA`.

### Glass everywhere
**Tell** — `backdrop-filter: blur()` on the nav, the cards, the modal, the footer. Frosted panels stacked four deep.
**Why** — Glass is a depth cue. With no solid surface behind it, it reads as a screenshot filter, not design. (R-22)
**Fix** — Glass is an accent, ≤1–2 surfaces per screen. Use it for the one floating element that needs to sit above content (e.g. the sticky command bar). Everything else gets a real background. Before: 6 blurred cards. After: 1 blurred top nav, 5 solid cards.

### Everything pill
**Tell** — Every button, input, chip, and badge at `border-radius: 999px`.
**Why** — One radius removes the hierarchy that shape carries. Pills say "friendly call-to-action"; on a data input they say "this is a toy." (R-29)
**Fix** — Vary radius by role. Sharp or 6–8px for structural/input edges, pill only for the primary action or tags. Match the radius to the element's job, not the model default.

### Floating page (shadow)
**Tell** — The whole content column lifted on a `box-shadow: 0 20px 60px rgba(0,0,0,.3)`, no anchor, no reason.
**Why** — A shadow is an elevation marker. A shadow with nothing beneath it is decoration, and it breaks on dark themes. (R-23, R-11)
**Fix** — Shadow only marks a real layer: a popped menu, a raised card, a sticky bar. On a flat page, use whitespace and a hairline border instead. If you ship a shadow, ship its dark-theme variant too.

### Glow everywhere
**Tell** — Outer glow on the logo, the heading, the button, the icon. Everything humming.
**Why** — Glow is a focus accent. Spread across the screen it means nothing and tanks contrast. (R-24, R-06)
**Fix** — Glow only on the ≤1–2 elements that need attention right now (the active field, the primary CTA on hover/focus). Zero resting glow elsewhere. AA contrast must hold with the glow on.

### AI default palette
**Tell** — #6366f1 / #8b5cf6 / #ec4899 / slate gray / white, or "calm SaaS" teal-on-gray. The colors carry no relation to the product.
**Why** — These are the training-set averages. They prove no one chose. (R-16, R-34, R-32)
**Fix** — Derive the palette from a real constraint: the domain (medical → desaturated clinical tones, not neon), the brand, or a single motif (R-32). ≤2–3 core + 1 accent. Write the reason in `DESIGN.md`.

### Background grid
**Tell** — Faint `repeating-linear-gradient` blueprint grid or dotted canvas behind the hero.
**Why** — It is the model's stand-in for "technical." It adds noise with no information. (R-19)
**Fix** — A background earns its place only if it carries meaning (a real map, a product-relevant texture). Otherwise: solid color, or a single subtle radial tied to the light source. Default grid → remove.

### Too many colors
**Tell** — Five accent colors, each section a different hue, tags in rainbow.
**Why** — Color without hierarchy is visual shouting. Nothing is emphasized because everything is. (R-34)
**Fix** — Lock the palette: ≤2–3 core + 1 accent. Use **one** accent for the one focal point per screen. Differentiate the rest with weight, size, and whitespace, not new hues.

### Accent spread
**Tell** — The accent color appears on the logo, three buttons, the link, the border, and the footer mark — all at once.
**Why** — An accent only works if it is rare. Spread it and you've spent your one deliberate accent on nothing. (R-34, lever: one deliberate accent)
**Fix** — Reserve the accent for the single most important action or signal on the screen. Everything else is core color or neutral. If two things need accent, one of them is not actually important.

### Sterile default (the over-filtered void)
**Tell** — Pure white, system font, one gray button, zero decoration, "clean" in the worst way. Often the result of over-applying antislop.
**Why** — This fails the liveliness bar just as hard as the neon. Removing slop is not the goal; *adding purpose* is. A blank page has no focal point and no identity. (C-1, C-3, R-32)
**Fix** — Do NOT add more bans. Open `DESIGN.md` (R-14, R-32) and raise the dials with intent: pick a real typeface with character (R-18), set one focal point, add one accent used once, give the rhythm some shape (R-28). The answer to "too much" is direction, not deletion.

---

## Layout & Components

### Monotonous template layout
**Tell** — Sticky nav, centered hero, 3 feature cards, wide CTA band, footer. The exact Vercel/Stripe landing skeleton, every time.
**Why** — Template rhythm is the absence of composition. It passes no purpose test: the layout wasn't chosen for this content. (R-28, C-3)
**Fix** — Compose around the content. Let the RHYTHM dial (1–3) drive section alternation — asymmetric splits, a full-bleed break, a two-column that flips. One focal point per screen; lead with it.

### Clone feature cards
**Tell** — Three identical cards, same icon weight, same height, same drop shadow, generic "Fast / Secure / Easy" copy.
**Why** — Identical cards imply identical importance. They also imply the features were invented to fill the row. (R-25, R-35)
**Fix** — Vary by hierarchy (R-25): one hero feature large, two secondary smaller; or a list with differing emphasis. Only show features that are real and differentiated. Match the visual weight to actual importance.

### Bento mosaic
**Tell** — The 6–9 tile "bento" grid with one big tile and assorted small ones, copied from Apple/Linear marketing pages.
**Why** — Bento is a *layout answer* applied before there was a *layout question*. It becomes slop the moment it's decorative. (R-28, C-1)
**Fix** — Use a mosaic only if the content genuinely has unequal-sized, unequal-importance blocks. If not, a clean list or grid serves better. Never ship the default 6-tile mosaic "because dashboards do."

### "How it works" ×3
**Tell** — A three-step numbered row (Sign up → Connect → Ship) under every hero.
**Why** — It is the most over-used section in AI landing pages and almost never reflects the actual product flow. (R-35, C-3)
**Fix** — Include it only if the product is genuinely a 3-step flow and the steps are specific. Otherwise cut it or replace with a real walkthrough of *this* product.

### "Trusted by" bar
**Tell** — A row of grayscale fake company logos above the fold.
**Why** — Without real logos it's fabrication-adjacent (R-01) and even with them it's a copied trust play. (R-01, R-35)
**Fix** — Only show logos you have rights to and that are real customers. If you don't have them, drop the bar — a specific testimonial or metric beats a logo ghost-row.

### "Most popular" pricing card (+ 3-tier default)
**Tell** — Three plans, middle one highlighted with "Most Popular", identical feature lists, invented prices.
**Why** — The 3-tier-middle-highlighted pattern is the single most templated pricing layout. The highlight is applied by reflex, not because the middle tier is actually the focus. (R-25, R-29, R-01)
**Fix** — Build tiers from real plan differences. Highlight only the plan you actually want users to pick, for a stated reason. Drop tiers that don't exist. Never invent prices or features (R-01).

### 4-column footer
**Tell** — Product / Company / Resources / Legal, four equal columns, same links every SaaS ships.
**Why** — Copied structure with no relation to what this product actually offers. (R-28, R-35)
**Fix** — Footer should map to *this* site's real sections. Two columns or five — whatever the content needs. Don't fill "Legal" with placeholder links.

### Uniform section rhythm
**Tell** — Every section same height, same padding, same centered max-width, no variation top to bottom.
**Why** — Flat rhythm is the visual equivalent of a monotone voice. It fails the liveliness bar. (R-28, RHYTHM dial)
**Fix** — Let the RHYTHM dial shape the page: alternate tight and spacious sections, flip alignment, use one full-bleed moment. Whitespace is structure, not emptiness (lever).

### Fake terminal window
**Tell** — A `macOS` dot-row window chrome with a hardcoded `npm install && npm run dev` snippet, purely decorative.
**Why** — It shows a command that does nothing for the visitor and exists only because "dev tools have terminals." (R-27, C-1)
**Fix** — Include a terminal only if the product is genuinely CLI/dev and the snippet is real and copyable. Otherwise show the actual product surface.

---

## Decorative Elements

### Generic icons
**Tell** — Icons chosen because they exist in the set, not because they represent the feature. A lightning bolt for "speed" by default.
**Why** — Decorative icons add noise and frequently misrepresent the feature. (R-17)
**Fix** — Each icon must map to a specific, real function. If no icon fits, use a label. Relevance over availability.

### Lucide-default look
**Tell** — The uniform 24px stroke, rounded-cap, single-weight Lucide set used everywhere with no customization.
**Why** — It is the unmistakable "model picked the first icon set" signature. (R-17, R-32)
**Fix** — Either commit to a deliberate icon system (custom strokes, consistent metaphor) or drop icons where they aren't needed. Identity over default (R-32).

### Emoji decoration
**Tell** — ✨🌟🚀 sprinkled into headings and buttons for "energy."
**Why** — Emoji are the cheapest possible accent and almost never carry product meaning. (R-21, C-1)
**Fix** — No decorative emoji. If an emoji is part of the brand voice (rare, intentional), use it once, knowingly. Otherwise the accent comes from color/type/motion, not pictographs.

### Small arrows on every button
**Tell** — `→` appended to every CTA regardless of destination.
**Why** — The arrow implies forward motion/next step on actions that don't have one (e.g. "Settings"). (R-20)
**Fix** — Arrow only when the button navigates onward or implies progression. Static actions ("Save", "Copy") get no arrow. Purpose over pattern (R-20).

### Left color stripe
**Tell** — A 4px accent bar on the left edge of every card or list row.
**Why** — Copied from a specific design system's selected-state idiom, now applied to everything as decoration. (R-22, C-1)
**Fix** — Use a stripe only to signal a real state (selected/active). For static items, no stripe. Let emphasis come from the one accent, used once.

### Capsule badges
**Tell** — Pill badges ("NEW", "BETA", "v2.0") scattered across the page.
**Why** — Badges without a functional meaning are noise. (R-21)
**Fix** — A badge only if it carries live status the user needs (status, version-in-use, unread). Otherwise delete it. Functional or gone (R-21).

### Generic typography
**Tell** — Inter everywhere, single weight, no scale logic. The model's default sans.
**Why** — No brand character; the type doesn't do any work. (R-18, R-32)
**Fix** — Choose type with intent (R-18): a display face with personality for headlines, a readable text face for body, a real scale (not 16/16/16). The typeface is part of the identity (R-32).

### Stock illustrations
**Tell** — The abstract "people around a glowing node" vector, or a generic isometric scene, unrelated to the product.
**Why** — Stock art signals "we bought filler art." It's disconnected from the actual offering. (R-27)
**Fix** — Illustration only if it's connected to the product (R-27) — a diagram of *this* workflow, a real screenshot, a custom mark. Otherwise, none.

---

## App & Dashboard

### Default dashboard shell
**Tell** — Left sidebar + top stat row + a chart + a table, the universal "admin template" with no relation to the user's actual decisions.
**Why** — The shell was chosen because it's the default, not because it serves this user's job. (R-28, C-3)
**Fix** — Build the layout around the user's primary decision. What does this person need to *do* first? Lead with that. The sidebar is fine — but only after the content shape is intentional.

### Stat cards with invented numbers
**Tell** — "12,480 Active Users ↑ 24%" with numbers pulled from nowhere.
**Why**** — Fabricated metrics are a hard violation. (R-01)
**Fix** — Every number is real or explicitly a labeled placeholder ("—" with "Demo data"). Never invent growth, counts, or deltas (R-01, R-36).

### Filler activity feed
**Tell** — "Jane liked a comment · 2m ago" rows with fake names and no product purpose.
**Why** — Filler social proof with no function. (R-01, R-21)
**Fix** — Show activity only if it's real and useful to this user. Otherwise omit. Empty state should name the cause and next action (R-08).

### Charts without a question
**Tell** — A line chart with no axis labels, no title, no hypothesis — decoration in chart form.
**Why** — A chart must answer a question. A chart with no question is slop with axes. (R-26, C-3)
**Fix** — Every chart states the question it answers in its title/labels. If you can't name the question, cut the chart. Animate only to reveal the answer (MOTION dial, R-26).

### Generic table columns
**Tell** — Name / Email / Status / Date / Actions on every table, regardless of domain.
**Why** — Copied column set that doesn't match the actual records. (R-28, R-35)
**Fix** — Columns reflect the real entity and the user's real task. Drop columns nobody acts on. Right-align numbers, left-align text, make the actionable column obvious.

### Filler data in fields
**Tell** — "Lorem ipsum" or "User #4839" in form fields, profiles, and rows.
**Why** — Ships the appearance of function without function. (R-01, R-08)
**Fix** — Real data, or a clear empty/loading/error state that names the cause and the next action (R-08). A skeleton is fine; fake content is not.

---

## Motion

### Endless pulses/loops
**Tell** — A permanently pulsing "live" dot, an infinite spinner that never resolves, a breathing glow.
**Why** — Perpetual motion trains the eye to ignore it and drains attention. It fails "clear UX purpose." (R-26)
**Fix** — Motion must have a job: draw attention to a change, confirm an action, reveal content. A pulse stops once acknowledged. Cap loops at the MOTION dial — at MOTION 1, essentially none.

### Template animations stacked
**Tell** — Fade-in + slide-up + stagger + parallax + hover-lift all on one page, none tied to a real transition.
**Why** — Animation without a UX reason is the MOTION dial cranked past purpose. (R-26)
**Fix** — Set the MOTION dial (1–3) from the core and let it govern the whole page. At MOTION 1: transitions only on state change. At MOTION 3: richer but still every animation answers "what changed?" No stacked template effects. Respect `prefers-reduced-motion`.

---

## UI Skill Checklist

Run this alongside the core Delivery Gate (R-12). Every item must be **YES**.

- [ ] **Palette comes from `DESIGN.md`**, not a default gradient — R-16, R-34, R-32
- [ ] **Accent appears only at the key moment**, nowhere else — R-34, lever: one deliberate accent
- [ ] **No decorative emoji** anywhere in the UI — R-21, C-1
- [ ] **Section rhythm follows the RHYTHM dial** (1–3), not a uniform template — R-28
- [ ] **Free of bento / fake-terminal / 3-tier-highlight / left-stripe defaults** unless purpose-justified — R-28, R-22, R-25, R-27
- [ ] **Every nav item, link, and control has a real destination** or a visible "Coming soon" label — R-07, R-36
- [ ] **Motion follows the MOTION dial** with no endless loops or stacked template effects — R-26
- [ ] **Glass ≤1–2 surfaces, glow ≤1–2, shadow marks real elevation, radius varied by role** — R-22, R-24, R-23, R-29
- [ ] **App layout is built around the user's decision**, not the sidebar+stat+chart+table default — R-28, C-3
- [ ] **Every number, delta, feed, and table row is real or a labeled placeholder** — R-01, R-36
- [ ] **Empty / loading / error states name the cause and the next action** — R-08
- [ ] **Holds up at every breakpoint, theme, and state, keyboard-only** — R-03, R-11, R-09, R-06

If any item is NO, fix it before delivery. A passing core gate with a failing UI checklist is not shippable.
