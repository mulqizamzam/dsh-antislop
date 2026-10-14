---
name: antislop-copywriting
description: "Copy and text skill for antislop. Use when writing or editing prose: headlines, tone, CTAs, and anti-AI-writing patterns."
whenToUse: "Load with the core 'antislop' skill."
---

> Part of the antislop system. Read together with `skills/core/SKILL.md` (core). Load this skill ONLY when writing or editing prose: headlines, subheads, CTAs, value props, landing copy, product text, microcopy.

## How to use this skill

This skill is a supplement to the core Delivery Gate in `skills/core/SKILL.md`, not a replacement for it. The core file owns the rule numbers and the gate. This skill only adds copy-specific guidance and shows the shape of good and bad prose under each rule. Cite rules by their canonical ID and never renumber them here.

Load this skill before you write or edit any string a human will read: the hero headline, the CTA button, the empty-state message, the FAQ, the testimonial block, the pricing line. If you are only touching code or layout, the core file and the other antislop skills cover you and this one stays unloaded.

Concretely, load on these triggers: you are drafting a landing page, a feature announcement, an error string, an onboarding tour, a pricing table, or any marketing or product text. Do not load it to name a CSS class or pick a color; those are the UI and code skills. When in doubt about whether a string is "copy," treat it as copy. A button label is copy. A tooltip is copy. A form hint is copy.

The three dials from the core (ENERGY, RHYTHM, MOTION, each 1 to 3) still apply. For copy, ENERGY mostly controls tone: ENERGY 1 is calm and plain, ENERGY 3 is more charged but must still be specific. A high ENERGY setting never licenses a buzzword, a fake number, or a generic CTA. Those are banned at every dial position.

Run the Copywriting Checklist (at the end) as part of the core Delivery Gate. If any checkbox is not a clean YES, the copy is not shippable, no matter how polished it looks.

## The core move: specific over generic

Slop copy comes in two shapes. The first is template-shaped: it fills a Mad Libs slot with safe words. "Powerful AI platform for modern teams." You could swap in any other product and the sentence would still "work," which is exactly why it says nothing. The second is claim-shaped: it asserts a value without naming the value. "Revolutionary experience that scales." Who scales what, and how would anyone verify it?

The fix is naming the real three things: the product's actual function, the reader's actual job, and the benefit they get that they cannot get elsewhere. Specificity is the only move that separates your copy from the million other agents that would write the same sentence.

- Generic: "Powerful AI platform for modern teams."
- Specific: "Syntax-check your SQL before it hits Postgres, so reviewers stop catching typos in pull requests."

The specific line names the function (SQL syntax check), the audience (engineers shipping to Postgres), and the benefit (fewer review cycles). It throws away the adjectives and keeps the facts. That is the entire trick. Do it every time.

A quick way to test your own draft: delete the product name and ask whether the sentence could describe a competitor. If yes, it is template-shaped and you have not done the work. Rewrite until the sentence is true only for what you are actually building.

- Generic: "The ultimate solution for effortless collaboration."
- Specific: "Leave comments on a design file and they sync to the matching line in the repo."
- Generic: "Next generation insights for data teams."
- Specific: "See which dashboard filter your teammates used most last week, so you stop rebuilding theirs."

## Em dash (R-02)

No em dash (—) in any UI or copy text. This is a hard gate. Em dashes read as the signature of template marketing prose, and they are almost always a crutch for a sentence that should be two sentences. When you reach for one, you are usually joining a claim to a weak amplification, which is the slop pattern itself.

Replace the em dash with a comma, period, colon, or parentheses, whichever the sentence actually wants:

- Before: "Track every build — without the noise."
- After: "Track every build, without the noise."
- Before: "One source of truth — for the whole team."
- After: "One source of truth for the whole team."
- Before: "Fast imports — usually under a second."
- After: "Fast imports (usually under a second)."
- Before: "Built for developers — who ship daily."
- After: "Built for developers who ship daily."
- Before: "No config needed — it just works."
- After: "No config needed. It runs with your existing make target."

Documentation carve-out: this skill file may display the em dash only inside quoted "before" examples that show the banned pattern, as above. The rule itself stays free of em dashes. Your product copy, UI strings, and microcopy must stay free of them too.

## Generic CTAs (R-30)

A CTA is an instruction to the reader. "Get Started" is not an instruction; it is a label on a door with no room behind it. R-30 forbids the generic CTA words: Get Started, Learn More, Try Now, Explore, Discover. They name no action the reader can picture, so they convert worse and read as filler.

A good CTA names the next concrete thing the reader will do after the click. If you cannot name it, the button should not exist yet.

| Weak CTA | Specific CTA |
|----------|--------------|
| Get Started | Start your free trial |
| Learn More | Watch the 2-minute demo |
| Try Now | Create a free account |
| Explore | Browse the template gallery |
| Discover | See the pricing plans |

The specific column makes a promise about what happens next. "Watch the 2-minute demo" tells the reader the cost (two minutes) and the reward (a demo). "Start your free trial" says there is no charge to begin. That is the bar: the words on the button should match the first screen the reader lands on.

## Buzzwords (R-31)

R-31 bans a fixed list of inflate-words: AI Powered, Seamless, Revolutionary, Next Generation, Cutting Edge, Intelligent, Ultimate, Powerful, Effortless. (The core file owns the exact list; treat it as closed.)

These words assert and never inform. "Seamless integration" tells the reader nothing about what connects to what, or how long setup takes, or what breaks. Every buzzword is a claim with the evidence removed. The reader has learned to skip them, so they cost you attention and return nothing.

Replace the buzzword with the mechanism or the measurable benefit. Show the actual thing instead of naming the feeling you want them to have.

| Buzzword | Say this instead |
|----------|------------------|
| AI Powered | Uses a model to flag duplicate tickets |
| Seamless | Imports from Jira in one click, no export step |
| Revolutionary | Cuts deploy time from 20 minutes to 90 seconds |
| Next Generation | Built on the v3 query engine |
| Cutting Edge | Supports WebGPU rendering |
| Intelligent | Suggests the next field from prior entries |
| Ultimate | The only tool with offline sync |
| Powerful | Handles 50k rows without lag |
| Effortless | One command sets up the whole pipeline |

If you catch yourself reaching for one of these, stop and ask what fact you were about to hide. Write that fact.

Note the asymmetry: naming the mechanism is shorter and more convincing than the buzzword it replaces. "One command sets up the whole pipeline" is both more specific and fewer words than "Effortless setup." Slop is not just dishonest, it is inefficient. The reader spends the same glance and learns more from the plain version.

## Fake statistics & claims (R-01)

R-01 is a hard gate: no fabricated data, numbers, or stats. Never invent "10K+ users," "99.9% uptime," "500M requests processed," or "120+ countries." If a number is not real and sourced, it is a lie, and a lie in copy destroys trust the moment a single user checks.

Empty is better than deceptive. A landing page with no logos and no stats beats one that fabricates them. If you have a real number, cite where it came from and make it defensible:

- Before: "Trusted by 10,000+ teams worldwide."
- After: "Used by the 14 teams in our public case-study list." (link to the list)

- Before: "99.9% uptime guaranteed."
- After: "Status page shows the last 90 days of uptime." (link to status)

When you are unsure whether a number is real, treat it as false. Either verify it against a source you can link, or omit it. There is no third option under R-01.

Comparisons are claims too. "Faster than X" needs a benchmark you can show, not a feeling. "Twice as fast as last year's build" is fine if you link the two runs. "The fastest tool on the market" is not, because you cannot have tested every competitor.

- Before: "500M requests processed every month."
- After: "Our public metrics show last month's request count." (link to metrics)

- Before: "The fastest static site generator."
- After: "Builds this 200-page site in 1.8 seconds on a CI runner (see the linked log)."

## Fabricated testimonials (R-04)

R-04 says clarify before creating assets, and that includes people. Do not invent testimonials: no AI-generated avatars, no random names with invented titles, no five-star quotes you wrote yourself. Fabricated social proof is the most damaging slop because it pretends to be a real person vouching for you.

Use verifiable social proof or none at all:

- A real quote from a customer who agreed to be named, with a real role and company.
- A link to a public review, issue, or post the person actually wrote.
- Nothing, if you have no permission yet.

- Before: "Priya M., VP Engineering, says: 'This tool changed everything for us!'"
- After: "Read Dana's write-up of our migration on her public blog." (link)

If you need testimonials, the correct move is to ask the user for real ones (R-04), not to manufacture them. Empty beats fake every time, same as with stats.

## Irrelevant FAQ (R-13)

R-13 requires that every FAQ be product-specific. Template FAQ questions are slop: "Is my data secure?", "How do I get started?", "What is your pricing?" They appear on every site on the internet and answer nothing about your product in particular.

An FAQ entry earns its place only if it addresses a real concern of THIS product's users, something a competitor's FAQ would not say. If you do not know the real concerns, that is a sign you should not write an FAQ yet.

- Before: "Is my data secure?" (on a CLI tool that runs fully offline)
- After: "Does the linter send my source anywhere? No. It runs in your repo and never opens a network connection."

- Before: "How can I contact support?"
- After: "Where do I file a bug? Open an issue on the repo; we triage every Monday."

When the real questions are unknown, ship no FAQ. A missing FAQ section is neutral. A fake one actively undermines the page.

## Headlines that earn attention

A headline is not a slogan. It is a promise that the page keeps. Good headlines use one of four concrete devices, and they never use title-case hype ("The Ultimate Solution For Modern Teams").

1. Name the reader's job: "For backend engineers who hate flaky CI."
2. Name the actual outcome: "Ship pull requests without waiting on the test queue."
3. Name a number you can defend: "Cut code review time from 3 days to 4 hours."
4. Name a contrast: "The linter that runs in your editor, not in a dashboard."

Three before/after pairs:

- Before: "Unlock Your Team's Potential Today"
- After: "See every flaky test before it reaches main"

- Before: "The Intelligent Way To Manage Data"
- After: "Query your Postgres replica from the same notebook as your CSVs"

- Before: "Revolutionary New Platform"
- After: "A diff viewer that shows you the merge conflict before you pull"

The after lines are specific enough that a reader can tell in one glance whether the product is for them. That is the only job a headline has.

## Microcopy & empty states

Microcopy is the small text that tells a person what just happened and what to do next: button labels, error messages, placeholders, empty states. Slop microcopy is either vague ("Oops! Something went wrong") or fake-cheerful ("Yay! You did it!"). Both waste the reader's attention at the exact moment they need help.

Plain and specific wins. Name what failed and the next step. Reference real states (R-08) when you describe them: empty, loading, error, success, disabled. Each state gets its own honest wording.

- Before: "Oops! Something went wrong."
- After: "Could not save the file. Your disk is full. Free 200 MB and try again."

- Before: "No data found." (empty state)
- After: "You have not imported a project yet. Drop a folder here or paste a Git URL."

- Before: placeholder "Enter text here"
- After: placeholder "Search issues by title or label"

The reader should never have to guess what a button does or why a screen is blank. Specific microcopy is the cheapest trust you will ever buy.

More pairs:

- Before: "Error 0x1F. Please try again later."
- After: "We could not reach the billing service. Your card was not charged. Retry in a minute or email billing@you.com."

- Before: button "Submit"
- After: button "Send invitation" (the button sends an invitation, so say that)

- Before: "Success!"
- After: "Saved. Your changes go live after the next deploy."

- Before: "Loading..." (indefinite)
- After: "Syncing 3 of 412 invoices..." (names progress and what is happening)

In every case the rewrite tells the reader the state they are in and the move that follows. Vague positive or negative words are removed; the concrete fact stays.

## Copywriting Checklist

Run this with the core Delivery Gate. Every box must be YES before the copy ships.

- [ ] No em dash (—) appears in any UI or copy string (R-02).
- [ ] Every CTA names a concrete next action and avoids Get Started / Learn More / Try Now / Explore / Discover (R-30).
- [ ] No banned buzzwords: AI Powered, Seamless, Revolutionary, Next Generation, Cutting Edge, Intelligent, Ultimate, Powerful, Effortless (R-31).
- [ ] No fabricated stats, numbers, or claims; real numbers cite a source, otherwise none appear (R-01).
- [ ] No fabricated testimonials; only verifiable social proof or none (R-04).
- [ ] Every FAQ addresses a real, product-specific concern, or there is no FAQ (R-13).
- [ ] Every claim is backed by a written reason or is absent; no unsupported assertions (R-36, keystone).
- [ ] Headlines name a real reader, outcome, defendable number, or contrast (not title-case hype).
- [ ] Microcopy is plain, specific, and humane; errors name the failure and the next step (R-08).
- [ ] Code-comment copy follows the same discipline: no em dash, no buzzwords (R-15).

If any box is NO, fix the copy. Do not ship slop and call it done.
