# antislop-human

> Part of the antislop system. Read together with `antislop.md` (core). Load this skill ONLY when making sure a UI works for real people: contrast, keyboard, focus, states, motion-safety.

## How to use this skill

This skill is a supplement to the core Delivery Gate in `antislop.md`, not a replacement for it. The core file sets the hard gates; this skill tells you what "works for real people" actually looks like so you can pass them. Pull it in when a task touches anything a human will see or operate: a page, a form, a modal, a theme toggle, an error message, even a loading spinner.

The gates this skill defends, by number:

- **R-06** — text contrast must meet WCAG AA (see Contrast).
- **R-08** — required states (empty / loading / error) must exist (see Required states).
- **R-09** — keyboard operable + visible focus (see Keyboard & focus).
- **R-11** — every shipped theme works in both modes (see Every theme works).
- **R-12** — verify before delivery: build/run + click-through (see Verify with real people).
- **R-04** — clarify before creating assets like avatars or photos (see Don't invent people).
- **R-36** — every decision has a written reason (state your palette and state choices in the handoff).
- **C-4** — resilience: the UI must hold up in every state, theme, breakpoint, and keyboard path.

If a UI ships without these checked, it fails the gate regardless of how polished it looks in the happy path. Accessibility is not a feature you bolt on; it is the floor.

## Contrast (R-06)

Text must be readable by people with low vision, cataracts, screen glare, or a phone in sunlight. WCAG AA is the minimum bar:

- **Normal text (under ~18px, or under ~14px bold): 4.5:1** against its background.
- **Large text (18px+ normal, or 14px+ bold): 3:1**.

These are floors, not targets. If you have room, aim for 7:1 (AAA) on body text. The point is that contrast is a measured property, not a feeling.

Forbidden by R-06:

- Light-grey-on-grey secondary text that "looks subtle" but reads as 2:1.
- White (or near-white) text over a gradient or photo that is light in places. Contrast must hold across the *whole* area the text passes over, not at one lucky pixel.
- Placeholder text so faint it disappears. `::placeholder` still carries information.
- Disabled buttons rendered at 1.5:1 "so they look off." A disabled control is still content; if it must be visible, it must be legible, or it must be hidden.
- Text over images without a scrim or solid panel behind it.

Test the real pairs, not the brand deck. A label is usually dark-on-light, but the same label inside a toast, a tooltip, a selected row, or a hover chip may sit on a different background. Every combination is its own measurement.

Verify with the helper script — never eyeball it:

```bash
python3 scripts/contrast-check.py "#1a1a1a" "#ffffff"
```

The script prints the WCAG ratio and the AA / AAA pass/fail for that foreground/background pair. Run it for each text color against each background it can appear on, in each theme. If the script says fail, the pair fails; no aesthetic argument overrides it.

Common failures and fixes:

- **Low-contrast secondary text** → lift the grey or darken the background; re-run the script until it passes.
- **Placeholder text** → give it its own measured pair; do not reuse the disabled-button grey.
- **Disabled states** → either keep them legible or remove them from the visible layout; do not ship invisible controls.
- **Text over images** → add a solid panel, a gradient scrim, or a blurred backdrop so one measured pair holds everywhere.

Choose pairings from the palette with the script. The fix is almost always "pick a different combination that passes," not "make the font bigger."

A note on the math: the WCAG ratio is a function of *relative luminance*, not of how dark a hex code looks to you. `#777` on `#fff` is about 4.48:1 — a hair under AA — which is exactly the kind of pairing that looks fine in a mockup and fails the gate. This is why you measure. The same grey that fails on white may pass on a dark panel, so the script is your arbiter per pair, not per color.

## Keyboard & focus (R-09)

Some users never touch a mouse. The entire interface must be reachable and operable with a keyboard alone.

- **Tab / Shift+Tab** must move focus in visual order, top to bottom, left to right — not in DOM order that jumps around the screen.
- **Enter and Space** must activate the focused control. Buttons activate on both; links on Enter; custom widgets must replicate this.
- **Esc** must close dialogs, menus, and popovers.
- **Arrow keys** should move within composite widgets (menus, tablists, radio groups) once inside them.

Every focusable element needs a **visible focus indicator**. You must be able to see where you are. This is non-negotiable.

Forbidden by R-09:

- `outline: none` or `outline: 0` on a focusable element without a *better* custom indicator in its place. Stripping the default outline and adding nothing is how you blind keyboard users. If you remove the outline, you must add a ring, a border change, an underline, a background shift — something that is at least as obvious and that itself meets contrast.
- Relying on `:hover` for anything a keyboard user needs. Hover and focus are different states.
- Trapping focus on the page body with no way to reach the footer, or skipping a control because it is "decorative."

Add the practical aids:

- **Skip link** at the top of long pages: "Skip to content" that jumps past the nav. It can be visually hidden until focused.
- **Focus trap** inside modals: Tab cycles within the dialog until it closes, and focus returns to the trigger when it does.
- **Visible focus on the first element** when a modal opens, and a clear close path.

If you can tab to it, you must be able to see you are on it. No exceptions.

Test the focus path like a user who cannot see the mouse: open the page, press Tab from the address bar, and watch. Does focus land on the skip link first (if present)? Does it enter the modal and stay there? Does it leave a visible trail you can follow? If you lose track of where you are, a keyboard user has already lost. Also confirm that focus order matches what a sighted user reads — a control that is visually last but focuses first is disorienting and usually a DOM-order bug.

## Required states (R-08)

Every data-driven UI has moments when there is nothing to show, something is loading, or something broke. Each of those moments is a required screen, not a gap to leave blank.

**Empty state** — says *why* it's empty and offers the *one* action to fill it.

- Bad: a blank box.
- Good: "You have no projects yet. Create your first project." with a Create button.
- A filtered search returning nothing is different from a first-run empty account. "No results for 'q3 report'" is not the same as "You haven't saved anything." Write the specific empty state for each cause.

**Loading state** — says *what* is loading, not just that something is happening.

- Bad: a spinner with no label.
- Good: "Loading your invoices…" with a determinate or at least honest indeterminate indicator. Don't fake progress you don't have; don't leave the user guessing whether it's working.

**Error state** — says *what failed* and the *next step*.

- Bad: "Error." or a red box with a stack trace.
- Good: "We couldn't load your messages. Check your connection and retry." with a Retry button.
- Distinguish error causes: a network failure, a permission denial, and a not-found are three different screens with three different next actions. A 403 "You don't have access to this folder" is not the same as a 404 "This page was moved or deleted."

These states must hold up at every breakpoint and in both themes (see R-11, C-4). Don't design the happy path and forget that the first time a user opens your app, it is almost always an empty or loading state.

## Every theme works (R-11)

If you ship a theme toggle — light/dark, or any multi-mode scheme — *both* modes are part of the product. You do not get to ship a broken one.

- Both modes must pass contrast (R-06) for every text/background pair. A pairing that is fine on light can fail badly on dark; measure both.
- Both modes must hold layout: no text that disappears into the background, no control that becomes invisible, no focus ring that blends in.
- Both modes must have complete required states (R-08). An error toast that is readable in light but invisible in dark is a failed delivery.
- The toggle itself must be keyboard operable and announce its state (R-09).

Do not ship a "dark mode" as a stretch goal that silently fails R-06 the moment someone enables it. Either both modes meet the gates or the toggle does not ship. A single, excellent, accessible theme beats two themes where one is broken.

## Verify with real people (R-12, C-4)

The gate is not "it renders." The gate is "a real person can use it." Verification is a step you perform, not a hope you express.

1. **Run the build / start the app** (R-12). If it doesn't compile or boot, nothing else matters.
2. **Tab through with the keyboard only.** No mouse. Confirm every control is reachable, operable, and shows a visible focus indicator. Esc closes dialogs. Skip link works.
3. **Check contrast in both themes** with `scripts/contrast-check.py` for every text/background pair, including hover, selected, disabled, and toast states.
4. **Exercise empty, loading, and error** states. Force them if you must (empty account, slow network, bad request). Confirm each says why and what to do next.
5. **Report the evidence.** Name the pairs you measured and their ratios, the states you triggered, and the keyboard path you walked. "I tested it" is not evidence; the ratios and the walkthrough are.

C-4 is the resilience lock: the UI must hold up in *every* state, theme, breakpoint, and keyboard path — not just the one you demoed. If you only checked the desktop light-mode happy path, you have not verified.

## Respect motion & attention

Motion can help or harm. Some users get vertigo, nausea, or distraction from animation; others simply prefer calm.

- **Honor `prefers-reduced-motion`.** Wrap non-essential animation in a media query so it is disabled or replaced for users who ask the OS to reduce motion:

  ```css
  @media (prefers-reduced-motion: reduce) {
    * { animation: none; transition: none; }
  }
  ```

- **Don't make an endless loop the only way to read content.** A carousel that auto-advances forever, with no pause and no manual control, hides information from anyone who can't catch the frame. Provide pause/play and prev/next, and never auto-play something essential.
- **Don't rely on color alone to convey state.** An error in red text and a success in green text fail colorblind users and anyone viewing in monochrome. Add an icon, a label, or both: "Error:" / "Saved ✓". State must be legible without color perception.

Calm, controllable, and redundant (icon + text) beats flashy every time for real people.

## Don't invent people (R-04)

Avatars, names, faces, and "sample" user data are assets about real humans. Do not fabricate them.

- Before generating any avatar, photo, name, or testimonial, **clarify with the user** (R-04). Ask what real data or brand assets should go there.
- Until you have real assets, use **neutral placeholders**: initial-based circles (`JD`), a `[LOGO]` slot, or explicitly labeled `[REAL DATA]` / `[SAMPLE]` markers.
- **Never disguise a placeholder as final.** A grey silhouette with no label reads as "this is a person"; a `[LOGO]` box reads as "drop the brand here." The second is honest, the first is a lie waiting to ship.
- Don't seed a demo database with fake names that look like real customers. Mark demo content as demo content.

Inventing people is both a trust violation and a delivery bug: it ships assumptions the user then has to hunt down and remove.

## Human-Centered Checklist

Run this with the core Delivery Gate. Every item must be **YES** before delivery.

- [ ] **Contrast AA verified with the script** for every text/background pair, including hover, selected, disabled, and toast states — in *both* themes (R-06).
- [ ] **Keyboard reaches every control** in visual order via Tab / Shift+Tab; Enter/Space activate; Esc closes dialogs (R-09).
- [ ] **Visible focus everywhere** — no focusable element left with bare `outline: none` and nothing in its place (R-09).
- [ ] **Empty, loading, and error states present and specific** — each says why and the one next action; first-run, filtered-to-nothing, and permission-denied are distinct (R-08).
- [ ] **Both themes functional** — pass contrast and layout, complete states, and the toggle is operable and announced (R-11).
- [ ] **Reduced-motion honored** — `prefers-reduced-motion` disables non-essential animation; no content lives only inside an auto-loop (C-4).
- [ ] **State never conveyed by color alone** — errors and success carry an icon or text too.
- [ ] **No assumed people or assets** — placeholders are labeled (`[LOGO]`, `[REAL DATA]`); nothing fabricated passed as final (R-04).

If any box is not a clean YES, the UI is not delivered. Fix it, re-verify, report the evidence. Real people use what you ship; build it so they can.
