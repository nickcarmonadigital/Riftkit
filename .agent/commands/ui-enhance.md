# UI Enhance

Comprehensive UI/UX enhancement workflow. Loads all UI/UX knowledge, audits the current project, and asks targeted questions before making any changes.

**CRITICAL: Do NOT write any code or make any changes until all questions are answered and the enhancement plan is approved.**

---

## Step 1: Load UI/UX Knowledge Base

Read ALL of these skills before doing anything:

1. `.agent/skills/3-build/shadcn_vercel_ai_stack/SKILL.md` — Primary stack (shadcn/ui, AI SDK 6, AI Elements, v0)
2. `.agent/skills/2-design/visual_hierarchy_mastery/SKILL.md` — Hierarchy, typography, spacing, color, shadows, states
3. `.agent/skills/2-design/premium_web_design_psychology/SKILL.md` — Halo effect, cognitive load, micro interactions
4. `.agent/skills/3-build/design_first_ai_workflow/SKILL.md` — Stitch + Claude Code workflow
5. `.agent/skills/3-build/ui_ux_library_selector/SKILL.md` — 200+ library decision framework
6. `.agent/skills/3-build/ui_ux_component_ecosystem/SKILL.md` — Design systems, Figma kits, builders
7. `.agent/skills/3-build/ui_polish/SKILL.md` — Polish checklist (spacing, typography, colors, states, forms)
8. `.agent/skills/3-build/design_system_development/SKILL.md` — Design tokens, component library patterns
9. `.agent/skills/3-build/frontend_patterns/SKILL.md` — React, Next.js, state management patterns

---

## Step 2: Audit the Current Project

Scan the project codebase to understand what exists:

### Tech Stack Detection
```
[ ] Framework: Next.js / Vite / Remix / other?
[ ] Styling: Tailwind / CSS Modules / styled-components / other?
[ ] Component library: shadcn/ui / MUI / Ant Design / none?
[ ] State management: Zustand / TanStack Query / Redux / other?
[ ] Animation: Motion / GSAP / none?
[ ] Icons: Lucide / Heroicons / Font Awesome / none?
[ ] Forms: React Hook Form / Formik / native?
[ ] AI features: AI SDK / custom / none?
```

### UI/UX Audit (Score Each 1-10)
```
[ ] Visual hierarchy — Is there a clear eye flow? Do primary elements stand out?
[ ] Typography — Tight headings? Consistent scale? Professional font?
[ ] Spacing — 4px grid? Grouped elements? Breathing room?
[ ] Color — Purposeful palette? Semantic colors? Proper contrast?
[ ] Dark mode — Proper surface elevation? Dimmed accents? No harsh borders?
[ ] Shadows — Subtle and elevation-appropriate?
[ ] Icons — Sized to text line-height? Consistent library?
[ ] Buttons — All 4 states (default, hover, active, disabled)?
[ ] Inputs — Focus, error, disabled states?
[ ] Micro interactions — Hover lifts, scroll reveals, smooth transitions?
[ ] Loading states — Skeletons? Spinners? Empty states?
[ ] Overlays — Text readable over images? Proper gradients?
[ ] First impression — Positive halo in 50ms? Clear hero?
[ ] Cognitive load — One goal per section? Simple navigation?
[ ] Overall "aliveness" — Does the site feel responsive and alive?
```

### File Structure Scan
- Read `package.json` for dependencies
- Read `tailwind.config.*` for theme configuration
- Read `globals.css` or equivalent for CSS variables
- Read main layout file for structure
- Read 2-3 key pages/components for current patterns
- Check for existing design tokens or theme files

---

## Step 3: Present Findings and Ask Questions

Present the audit results, then ask ALL of the following questions. Do not proceed until every question is answered.

### CATEGORY 1: Scope & Priority

1. **What pages/components do you want enhanced?**
   - Entire site? Specific pages? Just one component?
   - List them explicitly.

2. **What's the #1 thing that bothers you about the current UI?**
   - "It looks generic" / "Spacing is off" / "Colors feel wrong" / "It's not premium"

3. **Priority order — rank these 1-6:**
   - Visual hierarchy & layout
   - Typography & fonts
   - Color palette & theming
   - Animations & micro interactions
   - Component states (hover, focus, loading, error, empty)
   - Dark mode

### CATEGORY 2: Design Direction

4. **What feeling should the site communicate in the first 50ms?**
   - Options: Calm & professional / Bold & energetic / Minimal & elegant / Warm & friendly / Technical & precise / Premium & luxurious

5. **Show me 1-3 reference sites you think look great.**
   - URLs or names of sites whose vibe you want

6. **Font preference?**
   - Keep current / Suggest something better / I want [specific font]
   - Heading vs body — same or different?

7. **Color direction?**
   - Keep current palette / Refine current / Start fresh
   - Primary brand color (hex if known)?
   - Light mode only / Dark mode only / Both?

### CATEGORY 3: Technical Decisions

8. **Component library?**
   - Already using shadcn/ui? → Enhance what's there
   - Not using shadcn? → Migrate to shadcn?
   - Using something else? → Keep it or switch?

9. **Animation budget?**
   - None (keep it simple)
   - Subtle (hover effects, smooth transitions, scroll reveals)
   - Moderate (page transitions, staggered animations, loading sequences)
   - Premium (parallax, complex micro interactions, spring physics)

10. **Are there AI features that need AI Elements?**
    - Chat interface?
    - Completion/generation?
    - Structured data streaming?
    - None — just standard UI

### CATEGORY 4: Constraints

11. **Performance constraints?**
    - Bundle size matters? (mobile-first, slow connections)
    - SEO-critical? (need SSR, no layout shift)
    - Any library restrictions?

12. **Browser/device targets?**
    - Desktop only / Mobile-first / Both
    - Specific browser requirements?

13. **Accessibility requirements?**
    - WCAG AA / WCAG AAA / Best effort
    - Screen reader testing needed?

14. **Timeline?**
    - Quick pass (1-2 hours) / Thorough overhaul (half day) / Full redesign (multi-session)

---

## Step 4: Build Enhancement Plan

Based on the answers, create a prioritized enhancement plan:

```markdown
## UI Enhancement Plan for [Project]

### Design Direction
- Feeling: [from Q4]
- References: [from Q5]
- Font: [from Q6]
- Colors: [from Q7]

### Priority Stack (ordered by user ranking)
1. [Highest priority area] — specific changes listed
2. [Second priority] — specific changes listed
3. [Third priority] — specific changes listed
...

### Technical Changes
- [ ] Component library changes: [add/migrate/enhance]
- [ ] Theme/token updates: [CSS variables, tailwind config]
- [ ] Animation additions: [which libraries, which components]
- [ ] State additions: [which components need hover/focus/error/loading]
- [ ] Dark mode: [add/fix/skip]

### Files to Modify
1. [file] — [what changes]
2. [file] — [what changes]
...

### Estimated Scope
[Quick/Moderate/Major] — [time estimate]
```

**Present the plan. Wait for approval before writing any code.**

---

## Step 5: Execute

Only after plan approval:

1. Start with foundational changes (theme, tokens, fonts, colors)
2. Then structural changes (layout, spacing, hierarchy)
3. Then component-level polish (states, interactions)
4. Then motion/animation layer
5. Then dark mode adjustments
6. Run the `ui_polish` checklist as final verification

After each major change, screenshot or describe the result and confirm direction before continuing.

---

## Step 6: Verify

Run the full verification checklist from `visual_hierarchy_mastery` and `premium_web_design_psychology`:

```
[ ] Visual hierarchy is clear — eye flows naturally
[ ] Typography is tightened (headings: -2% letter-spacing, 110-120% line-height)
[ ] Spacing follows 4px grid with intentional grouping
[ ] Colors are purposeful with semantic meaning
[ ] All interactive elements have hover + active + disabled states
[ ] All inputs have focus + error states
[ ] Loading states exist for async operations
[ ] Micro interactions on buttons, cards, scroll
[ ] First impression creates positive halo (50ms test)
[ ] Cognitive load is low — one goal per section
[ ] Dark mode follows proper rules (if applicable)
[ ] Shadows are subtle and elevation-appropriate
[ ] Icons match text line-height
[ ] Site feels alive, not static
```

Report the before/after scores from the Step 2 audit.
