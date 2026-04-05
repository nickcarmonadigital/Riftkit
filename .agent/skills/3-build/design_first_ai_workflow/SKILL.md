---
name: Design-First AI Workflow
description: Use Stitch 2.0 for design direction + Claude Code for execution to build websites that don't look like AI slop
---

# Design-First AI Workflow

**Purpose**: Stop asking Claude Code to be both designer and developer. Use Google Stitch 2.0 for design direction first, then Claude Code for execution — producing websites that feel custom and intentional instead of generic AI output.

**Source**: Synthesized from "Stop Making Ugly Websites with Claude Code + Stitch 2.0" + production workflow patterns.

---

## TRIGGER COMMANDS

```text
"Design-first workflow for [project]"
"Build a website that doesn't look like AI"
"Use Stitch + Claude Code for [site]"
"Create a premium landing page for [product]"
"Using design_first_ai_workflow skill: [target]"
```

---

## WHEN TO USE

- Building any new website or landing page
- When previous Claude Code output looked "generic" or "AI-made"
- When the client wants a custom, premium feel
- Before website_build skill, as the design phase
- When redesigning an existing site

---

## THE CORE PROBLEM

Most people ask Claude Code to be their designer AND developer. These are **two different jobs**. The result: same hero section, same gradients, same floating cards, same generic startup vibe. You can tell AI made it.

**The fix**: Stitch handles design direction. Claude handles execution.

---

## PHASE 1: GATHER INSPIRATION (Before Opening Any Tool)

**Do NOT start from a blank prompt.** Start with real references.

### Where to Find Inspiration
- **Dribbble** — high-fidelity design concepts
- **Pinterest** — mood boards and visual direction
- **Awwwards** — award-winning live websites
- **Mobbin** — curated mobile and web app designs
- **Live websites** you admire — screenshot specific sections

### What to Collect
You're not looking for one perfect website. You're looking for **pieces**:
- One site with a hero section you love
- Another with amazing typography
- Another with a strong dark theme
- Another with cool interactive elements

### Deliverable
3-5 screenshots or URLs with notes on what you like about each:
```
Reference 1: [URL/screenshot] — love the hero layout
Reference 2: [URL/screenshot] — amazing typography choices
Reference 3: [URL/screenshot] — strong color palette
Reference 4: [URL/screenshot] — interactive elements I want
```

---

## PHASE 2: DESIGN IN STITCH 2.0

### Setup
1. Open Google Stitch (stitch.google.com)
2. Choose "Web" as device type
3. Upload your reference screenshots
4. Write a natural language prompt

### Prompt Template
Don't be robotic. Talk naturally:
```
Create a premium landing page for [product/business] using these
references as inspiration. I like the typography from [ref 1], the hero
layout from [ref 2], and I want the overall site to feel [adjectives:
polished, modern, interactive, minimal, bold].

Include: headline, CTA, social proof, features section, testimonials,
and a signup section.
```

### Iteration Strategy (This Is Where Quality Happens)
Good design doesn't happen on the first try. It happens through iteration:

1. **Generate 3+ versions** in Stitch
2. Evaluate each version for different strengths:
   - Version 1 might have the best layout
   - Version 2 might have the better font
   - Version 3 might have the strongest color palette
3. **Combine the best elements**: Tell Stitch "use the typography from version 2, the layout from version 1, and the visual style from version 3"
4. Results get dramatically better with this approach

### Refine the Design System
Once Stitch gives you something decent, slow down and refine:

```
[ ] Font feels intentional (not generic)
[ ] Color palette is cohesive
[ ] Button styles are consistent
[ ] Spacing feels balanced
[ ] Corner radius is consistent
[ ] Cards have a unified visual language
```

**Pro tip**: A stronger heading font alone can make the site feel 10x more premium.

### Screenshot-Based Editing
For fine-tuning sections:
1. Take a screenshot of the section that's "close but not right"
2. Upload it back to Stitch
3. Tell it what to change: "Make this grid denser", "Add more visual weight here", "Turn this into something more interactive"

### Exit: Design Is 80-90% Right
Don't over-polish in Stitch. Get to 80-90% and bring it to Claude Code.

---

## PHASE 3: BUILD WITH CLAUDE CODE

### Setup: The CLAUDE.md File (Critical)
Before generating anything, create a `CLAUDE.md` or system prompt:

```markdown
You are a senior UI designer and front-end developer.

## Design Rules
- Preserve the imported design language exactly
- Prioritize clean spacing, premium typography, polished interactions
- Avoid generic layouts — this design is intentional
- Use Tailwind CSS and shadcn/ui where appropriate
- Build reusable components

## Quality Standards
- Every interactive element needs hover + press states
- Smooth transitions (200-300ms, cubic-bezier easing)
- Loading states for all async operations
- Mobile-responsive from the start
```

### Initial Build Prompt
```
I've created this design in Stitch. Turn it into a polished
production-ready site. Keep the design system intact. Use Tailwind
and shadcn/ui. Run it locally.
```

Claude isn't guessing what looks good — it already has a strong foundation.

### Polish Priorities (In Order)

**1. Background & Depth**
- Subtle gradients, glows, or texture
- Adds character beyond flat white/dark backgrounds
- Even small background effects make a page feel more complete

**2. Motion & Animation**
- Hover effects on interactive elements
- Smooth section reveals on scroll
- Cards lifting slightly on hover
- Buttons feeling responsive
- NOT crazy animations everywhere — subtle is premium

**3. Typography (Revisit)**
- Tighten heading letter-spacing
- Ensure font weights create clear hierarchy
- Check line-heights and max-widths

**4. Product Integration**
- Auth with Supabase
- Payments with Stripe
- Email flows with Resend
- Deploy with Vercel/GitHub

---

## PHASE 4: FINAL POLISH

### Polish Checklist
```
[ ] Background has depth (gradients, glows, texture)
[ ] All buttons have hover + active states
[ ] Scroll triggers subtle section reveals
[ ] Cards have hover lift effect
[ ] Typography is tightened (headings especially)
[ ] Loading states exist for async operations
[ ] Mobile responsive at all breakpoints
[ ] Page load animation is smooth
[ ] Empty states are handled
[ ] Error states are designed
[ ] Favicon and meta tags are set
[ ] Performance is good (<3s load)
```

---

## TECH STACK RECOMMENDATIONS

### For New Projects
| Layer        | Recommended                     | Why                             |
|--------------|----------------------------------|---------------------------------|
| Framework    | Next.js / Remix                  | SSR + React ecosystem           |
| Styling      | Tailwind CSS                     | Utility-first, fast iteration   |
| Components   | shadcn/ui                        | Own the code, accessible        |
| Animation    | Framer Motion (Motion)           | Declarative, spring physics     |
| Icons        | Lucide                           | Clean, consistent               |
| Auth         | Supabase Auth / Clerk            | Fast to implement               |
| Payments     | Stripe                           | Industry standard               |
| Email        | Resend                           | Developer-friendly              |
| Deploy       | Vercel                           | Zero-config Next.js deploy      |
| Database     | Supabase (Postgres)              | Real-time, auth built in        |

### For WordPress Projects
Same principles apply:
1. Design first in Stitch
2. Build in Claude Code
3. Convert to WordPress theme
4. Add security (e.g., MalCare for defense layer)

---

## COMMON MISTAKES

| Mistake                                        | Fix                                           |
|------------------------------------------------|-----------------------------------------------|
| Starting in Claude Code without design         | Always start with references + Stitch         |
| Prompt: "build me a modern website"            | Be specific: references + adjectives + sections |
| Accepting Stitch v1 without iteration          | Generate 3+ versions, combine best elements   |
| No CLAUDE.md with design standards             | Always set design rules before building       |
| Skipping background/depth polish               | Background effects add 10x more premium feel  |
| Over-animating everything                      | Subtle > flashy. 200-300ms transitions max    |
| Forgetting mobile responsiveness               | Test at 375px, 768px, 1024px, 1440px          |

---

## WORKFLOW SUMMARY

```
1. INSPIRE  → Collect 3-5 reference screenshots/URLs
2. DESIGN   → Stitch 2.0: prompt + iterate + refine design system
3. INSTRUCT → Create CLAUDE.md with design standards
4. BUILD    → Claude Code: convert design to production code
5. POLISH   → Background, motion, typography, states
6. SHIP     → Auth, payments, email, deploy
```

---

## EXIT CRITERIA

```
[ ] Design references were collected before any tool was opened
[ ] Design was iterated in Stitch (3+ versions evaluated)
[ ] Design system (fonts, colors, spacing, radius) is defined
[ ] CLAUDE.md file sets clear design standards for Claude Code
[ ] Code preserves the design system from Stitch
[ ] Background has depth and character
[ ] Micro interactions on all interactive elements
[ ] Typography is premium (tight headings, proper hierarchy)
[ ] Mobile responsive at all breakpoints
[ ] Site does NOT look like generic AI output
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: "Stop Making Ugly Websites with Claude Code + Stitch 2.0"*
