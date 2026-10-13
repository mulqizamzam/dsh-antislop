---
name: antislop-responsive
description: Mobile layout skill for antislop. Use for layouts that reflow on small screens: grids, overflow, tap targets.
whenToUse: "Load with the core 'antislop' skill."
---

> Part of the antislop system. Read together with `skills/core/SKILL.md` (core). Load this skill ONLY for layouts that must hold up on small screens: breakpoints, overflow, grids, tap targets, nav.

## How to use this skill

This skill is a supplement, not a replacement. The hard gates in `skills/core/SKILL.md` still decide whether your work ships. Load this skill the moment a task touches anything that renders on a phone: a page, a card grid, a navbar, a form, a modal. It exists to stop the specific kind of slop that only appears at 360px and never in a desktop preview.

Cite the gates that apply:

- **R-03 (mobile layout must be flawless)** is the hard gate behind every section here: no horizontal overflow, text contained, cards that don't collide or clip, a navbar that is usable, tap targets ≥44px, spacing consistent across breakpoints.
- **R-12 (verify before delivery)** is why the last section is "test at real widths," not "trust your eye." Build, run, click through at mobile widths, report the evidence.
- **R-09 (keyboard + focus)** and **R-08 (required states)** are the parts of mobile correctness that have no visible product on a touchscreen demo but break the moment a real person uses the page.
- **R-28 (layout structure)** forbids template layouts and demands the RHYTHM dial is followed. Grids here must earn their shape from content.
- **R-36 (every decision has a written reason)** means a breakpoint, a column count, and a spacing value each need a justification, not a copied value from a boilerplate.
- **C-4 (resilience)** is the craftsmanship lock: the layout holds up at every breakpoint and every state, not just the one you happened to preview.

Run the Responsive Checklist at the end alongside the core Delivery Gate. If any box is not a clean YES, the layout is not done — R-03 does not grade on a curve.

**When NOT to load this skill:** a pure backend change, a server config, a build script, anything with no rendered surface. Loading it for non-visual work is noise. When in doubt about whether a change touches the rendered surface, load it — a "backend-only" tweak that silently affects a template still ships a layout.

**Write the reasons (R-36).** Every breakpoint, every column count, every spacing override you add must carry a written reason: not "it's responsive now" but "the card grid collapses at 360px because three 120px cards need 360px plus gaps, so it stacks to one column." The reason is what stops the next agent from "fixing" the responsive behavior back into slop.

## No horizontal overflow (R-03)

The single most common mobile slop tell is a page that scrolls sideways. On desktop you never see it because the offender sits just off the right edge of the canvas. On a phone it is the first thing a user feels: the page has no right edge, content spills off-screen, and the layout visibly fails. A page with horizontal scroll is, by definition, a broken page.

Causes, in order of how often they bite:

- **Fixed-width elements.** A child with `width: 320px` inside a 360px viewport with padding leaves a horizontal-scrolling sliver.
- **`white-space: nowrap` on long strings.** URLs, emails, IDs, and generated tokens don't wrap and shove the page wider.
- **`width: 100vw`.** `100vw` includes the vertical scrollbar width on desktop and ignores nothing on mobile; it is wider than the visible viewport. Use `100%`, which respects the parent's available width.
- **Unconstrained images or tables.** A `<table>` with many columns or an `<img>` with intrinsic width blows past the screen.
- **`translateX` / off-canvas transforms** without `overflow-x: hidden` on a containing ancestor, or worse, sliding something into view that was never clipped. An off-canvas panel that is only shifted off-screen (not `display:none` or clipped) still occupies layout width and drags the page wider. Clip the drawer with `position` and `overflow` on its wrapper, or take it out of flow entirely when closed.

Fixes:

```css
img, video, table, canvas { max-width: 100%; }
/* long unbreakable strings: */
.user-text { overflow-wrap: break-word; word-break: break-word; }
/* never this on a full-width element: */
.wide { width: 100%; }          /* not 100vw */
/* horizontal scroll is allowed ONLY inside an intentional scroller: */
.scroller { overflow-x: auto; -webkit-overflow-scrolling: touch; }
```

Horizontal scroll is legitimate inside a deliberately scrollable region — a carousel, a comparison table — but that region must be the container, and the page itself stays contained. Test at **360px**, the narrowest mainstream target; if it's clean there, it's clean most places. If there is ANY sideways scroll, the layout fails R-03.

**Find the offender fast.** When a page scrolls sideways, don't guess. Compare `document.documentElement.scrollWidth` against `clientWidth` — the gap is the overflow. Then bisect: temporarily set `overflow-x: hidden` on candidate containers or use the devtools "scroll into view" on the offending node. The cause is almost always one element wider than the viewport, not the whole page, so isolate it rather than clipping the body with `overflow: hidden` — that hides the symptom and creates the clipping failure below.

## Tap targets ≥44px (R-03)

A desktop cursor has pixel accuracy. A thumb does not. Targets that are comfortable at 16px on a monitor become an exercise in frustration on a phone, and R-03 promises the UI is usable on mobile.

Enforce a minimum touch area of **44 × 44 CSS px** for every interactive element: buttons, links, nav items, icon toggles, list rows that act as buttons. The visual can be smaller than the hit area — pad the control or use a larger transparent hit box — but the thing a finger lands on must be at least 44px in both dimensions.

```css
.button {
  min-height: 44px;
  min-width: 44px;
  padding: 12px 16px;   /* padding grows the hit area without puffing the text */
}
```

Rules that stop slop:

- **Don't pack 12 tiny icons in a row.** A row of 22px icon buttons is un-tappable and reads as a control panel a phone cannot operate. Group, label, or move secondary actions into a menu.
- **Separate the visual size from the hit size.** A 20px icon can sit inside a 48px button; an underlined 14px link can sit inside a 44px-tall list row. Minimum touch area is a floor on the *pressable* region, not on the glyph — meeting it visually is easy, meeting it structurally is what most mobile slop misses.
- **Primary actions can be larger, never smaller.** 44px is the floor for anything tappable, not the target size for your main call to action. A checkout button or a send action deserves more room — 48–56px — because it is the thing the thumb is hunting for. Reserve the tight 44px for secondary controls in a list, not for the action you most want tapped.
- **Leave spacing between tappable items.** Two 44px targets touching each other behave like one 88px target — the user cannot reliably pick either. Keep a clear gap so press areas don't overlap.
- **Hover-only affordances are invisible on touch.** A `:hover` reveal, tooltip, or highlight does not exist for a finger. Provide a persistent state: a visible `:active` press feedback, a tap-to-open equivalent, and a control that shows its affordance without needing a pointer.

## Text stays in its container (R-03)

Text that escapes its box is the quieter cousin of horizontal overflow, and just as fatal to the promise of a contained mobile layout.

- **Long words and links break.** Apply `overflow-wrap: break-word` to any container that may hold URLs, IDs, or user-generated text. The alternative — a string that pushes the whole page wider — is the overflow failure above.
- **Inputs don't overflow.** A text input with a fixed width wider than its column, or a `min-width` that refuses to shrink, pushes the form off-screen. Let inputs be `width: 100%` of their field wrapper, and give the wrapper room to shrink.
- **Modals and popovers fit the viewport.** A dialog sized for a 1280px canvas renders half-off-screen on a phone. Cap its width to the viewport, anchor it so it cannot clip beyond the top or bottom, and let long content scroll inside the dialog rather than escaping it.
- **Don't shrink body text to 11px to fit.** Legibility is not negotiable. If body copy needs to drop below ~14–15px to fit, the layout is wrong, not the type size — reduce other elements, restructure, or let the section grow. Shrinking text to invisibility is the slop move R-03 forbids; it looks "fit" while being unreadable.

```css
.modal {
  width: min(92vw, 480px);   /* never wider than the screen, with a desktop cap */
  max-height: 85vh;
  overflow-y: auto;
}
```

**Watch the viewport units.** `100vh` on mobile includes the browser chrome, so a `100vh` section overflows the visible area and the "fold" lands in the wrong place. Use the dynamic unit `dvh` where a real full-height section is intended, or let sections size to their content (`auto`). A `100vh` hero that looked perfect on desktop becomes a slab that pushes everything below the fold on a phone — the height failure is just overflow in the other axis.

**Respect zoom and text resize.** A layout that only holds at the default font size breaks the moment a user bumps their browser's minimum text size. Don't fight the user's settings with fixed-height rows that clip enlarged text; let containers grow with their content. The accessibility angle (contrast, focus, zoom) is covered by `antislop-human`, but containment here is the layout half of the same promise.

## Navbar usable on mobile (R-03)

The navbar is the first thing a mobile user meets, and it is where reflow matters most: a person has to find where to go before they can go anywhere. A broken or overlapping nav is not a cosmetic bug; it is a dead end.

- **The menu must actually open and close.** A hamburger that animates but never reveals links, or one that opens and cannot be dismissed, fails R-03 outright. Wire the toggle to real state, and make it **Esc-closable** (R-09) and **focus-trapped** so keyboard and screen-reader users are not stranded inside it.
- **Links must be reachable.** Every destination available on desktop must be reachable on mobile. Hiding critical nav behind a broken or undiscoverable menu is the worst case: the only path to a section is gone on the device most used to reach it.
- **Don't hide critical nav behind a bare icon.** If a menu is the only route to something important, label it ("Menu") or keep primary destinations visible and hide only the secondary ones. A bare hamburger assumes knowledge the user may not have.
- **Lock body scroll while the menu is open.** An open overlay with a still-scrolling page behind it lets the user lose the menu; trap scroll with `overflow: hidden` on the body (restored on close) and keep the menu within the safe-area insets so it isn't clipped by the device notch or home indicator.
- **Never a broken or overlapping nav.** A desktop top bar kept as a cramped row of links wraps into two rows or spills past the viewport. Collapse into a real mobile pattern at the breakpoint: a bottom nav for the few primary destinations, or an overflow menu for the rest. Keep fixed nav compact so it never letterboxes the content (reserve its height; respect safe-area insets). A tall sticky header turns the visible area into a letterbox and the content into a sliver — navigation should be present, not the main occupant of the screen.

## Grids that reflow (R-28)

R-28 forbids template layouts and requires the RHYTHM dial to drive structure. A grid's job is to promise how width is shared — when the viewport narrows and the grid does not re-stack, every column becomes a sliver, text becomes unreadable, and cards collide. That collision is the desktop side-by-side becoming a mobile pileup.

Use fluid, content-driven grids:

```css
/* columns shrink and wrap with the content, not the viewport spec */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: clamp(12px, 2vw, 24px);
}
```

- **Avoid hard-coded 3- or 4-column layouts** that crush on phones. `grid-template-columns: repeat(4, 1fr)` gives each card a quarter of 360px — unusable. Prefer `minmax()` / `auto-fit` / `clamp()` so the count falls out of the card's minimum size.
- **Decide breakpoints from content, not a template.** A breakpoint is the width where the layout stops holding — a column becomes unreadable, a row of cards gets too narrow. Set it there, not at a copied device width.
- **Know `auto-fit` vs `auto-fill`.** `auto-fit` collapses empty tracks so the remaining items stretch to fill the row — good when you want the last card to grow. `auto-fill` keeps the empty tracks, leaving gaps — good when you want a fixed grid that fills with placeholder slots. Picking the wrong one is how a "responsive" grid ships with a lonely stretched card or a row of empty holes. Choose by what the content should do, and verify both the full and partial rows at 360px.
- **Keep RHYTHM consistent with the dial.** The gap between cards and the section padding must follow the same rhythm at every size; a grid that suddenly uses a different gutter at mobile reads as a different design bolted on.
- **A grid is a layout, not a span exercise.** Forcing a 12-column system on content that wants one or two columns fits the element to an invisible grid the user never sees. Let columns follow the content; usually one column on mobile, two at most.
- **Freeze grid children with `min-width: 0`.** The classic collapse failure: a grid item holds an image or a long string, refuses to shrink below its content, and bursts the track wider than the viewport. `min-width: 0` on the child lets it shrink with the container so the grid reflows instead of overflowing. Pair it with `overflow-wrap: break-word` on the text inside.

## Spacing consistent across breakpoints (R-03)

A spacing scale that collapses or explodes between 360px and desktop is a layout that was not designed, only squeezed. R-03 demands consistency across breakpoints; the rhythm has to hold, not snap.

- **Define one spacing scale.** The same named steps (xs, sm, md, lg) apply at every width; only their values shift at the breakpoint. If mobile uses ad-hoc gaps and desktop uses the design system, the page reads as two designs.
- **Let gaps breathe but not burst.** A `gap` tuned for a wide canvas left unchanged on mobile becomes a desert between every element; a gap that scales linearly can explode on large screens. Use `clamp()` so spacing grows and shrinks fluidly within bounds:

```css
.section { padding: clamp(24px, 5vw, 64px) clamp(16px, 4vw, 48px); }
.stack > * + * { margin-top: clamp(12px, 2vw, 20px); }
```

- **Watch section padding.** Desktop-scale vertical padding (96px, 128px) turns into tall empty voids on a phone, breaking the rhythm R-05/R-28 calls for. Drop section padding to a mobile register (roughly half or less) and verify the page scrolls at a natural density instead of through emptiness.
- **Keep the rhythm, change the register.** Consistency does not mean identical values — it means the same logic. If desktop uses an 8px base scale, mobile uses the same 8px scale at smaller steps, not a new 5px scale invented on the spot. A spacing system that forks per breakpoint is two systems, and two systems are how layouts drift. Document the scale once (R-36) and let `clamp()` express the fluid range within it.

## Test at real widths (R-12)

R-12 is the gate that makes every other rule real: build and run, then click through at mobile widths, and report the evidence. Do not claim "responsive" because the CSS has a media query. A media query can still ship sideways scroll, clipped modals, and a dead hamburger.

Check at these widths, in this order:

- **360px** — the narrowest mainstream phone. The hardest test. If it's clean here, most phones are clean.
- **390px** — the common modern iPhone width.
- **768px** — the classic tablet / large-phone landscape boundary where nav and grids make their biggest jumps.
- **1280px** — a desktop baseline to confirm the wide layout still holds after your mobile changes.

At 360px specifically, **click through every control**: open the menu, close it with Esc, tap every button, submit the form, open the modal, resize a long input. If you cannot exercise it with touch/keyboard alone, it is not verified.

Report the evidence with the Delivery Gate: the widths checked, the controls exercised, and the specific result at each. "It looks fine on my laptop" is not testing. A passing layout you did not test at mobile width is not a passing layout (R-12, C-4). Resilience means it holds at every breakpoint and every state — the empty state, the loading state, the error state, the long-content state — not just the happy path you previewed.

**Use the device toolbar, not your imagination.** The browser's responsive mode at 360px with touch emulation is the minimum bar; it catches overflow, broken menus, and un-tappable controls that a resized desktop window hides. Where possible, check on a real device or at least with pointer emulation on, because hover-only affordances (above) pass in a desktop preview and die on a thumb. If you cannot run it, say so in the Delivery Gate — reporting "untested at mobile width" is honest and fails the gate; claiming "responsive" without testing is the slop the gate exists to stop.

## Responsive Checklist

Run this alongside the core Delivery Gate. Every box must be **YES** for the layout to ship. A single NO is not a near-miss — it is a failed gate. Re-read the matching section above, fix the cause (not the symptom), and re-test at the width where it failed before ticking the box.

If a box cannot be YES because of a constraint outside your control (a third-party embed that overflows, a design decision that forbids a mobile nav), write that constraint into the Delivery Gate notes with the R-number it conflicts with — silence is how a known failure becomes an "untested pass." The checklist catches slop only if you answer it honestly.

- [ ] **Zero horizontal overflow at 360px** — no sideways scroll; `100vw`, fixed widths, and `nowrap` strings all contained.
- [ ] **Tap targets ≥44px** — every button, link, nav item, and tappable row is at least 44×44 CSS px with spacing between them.
- [ ] **Text contained, no clipping** — long words/links break, inputs fit, modals/popovers fit the viewport, body text stays legible (not shrunk to 11px).
- [ ] **Navbar opens/closes and is keyboard usable** — menu toggles real state, is Esc-closable and focus-trapped, and no critical nav is hidden behind a broken menu.
- [ ] **Grids reflow via minmax / auto-fit / clamp** — no hard-coded multi-column crush; breakpoints set from content; RHYTHM consistent.
- [ ] **Spacing scale consistent across breakpoints** — one scale from 360px to desktop; gaps and padding don't collapse or explode (use `clamp()`).
- [ ] **Every interactive element verified at mobile width** — built, run, and clicked through at 360/390/768/1280; evidence reported; holds at every state (R-12, C-4).
