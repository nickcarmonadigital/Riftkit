# UX Enhance

Comprehensive UX (user experience) enhancement workflow. Audits how the product WORKS and FEELS — not how it looks. Loads all UX knowledge, audits the current project against behavioral UX standards, and asks targeted questions before making any changes.

**CRITICAL: Do NOT write any code or make any changes until all questions are answered and the enhancement plan is approved.**

---

## Step 1: Load UX Knowledge Base

Read ALL of these skills before doing anything:

1. `.agent/skills/2-design/ux_writing_microcopy/SKILL.md` — Button labels, error messages, empty states, tooltips, tone
2. `.agent/skills/2-design/user_flows_information_architecture/SKILL.md` — User flows, task flows, sitemaps, IA, labeling
3. `.agent/skills/2-design/navigation_search_ux/SKILL.md` — Nav patterns, search UX, filtering, breadcrumbs, wayfinding
4. `.agent/skills/2-design/accessibility_design/SKILL.md` — WCAG conformance, a11y planning, inclusive patterns
5. `.agent/skills/3-build/onboarding_activation_ux/SKILL.md` — First-run experience, activation funnels, progressive disclosure
6. `.agent/skills/3-build/form_ux_mastery/SKILL.md` — Field design, validation, multi-step forms, mobile forms
7. `.agent/skills/3-build/conversion_engagement_ux/SKILL.md` — CTAs, trust signals, friction reduction, retention mechanics
8. `.agent/skills/3-build/ai_conversational_ux/SKILL.md` — Chat UX, agent workflows, transparency, tool approval
9. `.agent/skills/3-build/accessibility_implementation/SKILL.md` — ARIA, focus management, screen reader, keyboard nav

---

## Step 2: UX Audit — Score the Current Product

Scan the codebase and score each dimension 1-10:

### FLOWS & ARCHITECTURE
```
[ ] /10 — Can users complete the core task without getting lost?
[ ] /10 — Are there dead ends or flows with no escape hatch?
[ ] /10 — Is navigation predictable and consistent?
[ ] /10 — Is content organized by user mental models (not org chart)?
[ ] /10 — Can critical content be reached in ≤ 3 clicks?
[ ] /10 — Does search exist as a fallback for complex structures?
```

### COPY & COMMUNICATION
```
[ ] /10 — Do button labels use verb + object (not "Submit")?
[ ] /10 — Do error messages explain what happened + how to fix?
[ ] /10 — Do empty states guide users to take action?
[ ] /10 — Is terminology consistent across the product?
[ ] /10 — Is tone appropriate per context (warm for success, calm for errors)?
[ ] /10 — Are confirmation dialogs specific about consequences?
```

### ONBOARDING & ACTIVATION
```
[ ] /10 — Can new users see the product's value in < 10 seconds?
[ ] /10 — Is the first meaningful action achievable in < 60 seconds?
[ ] /10 — Are there templates/sample data for cold-start?
[ ] /10 — Can setup steps be skipped?
[ ] /10 — Is there a success state at the aha moment?
```

### FORMS
```
[ ] /10 — Single-column layout?
[ ] /10 — Inline validation with specific messages?
[ ] /10 — Labels above fields (not placeholder-as-label)?
[ ] /10 — Correct input types for mobile keyboards?
[ ] /10 — Smart defaults and autofill support?
```

### CONVERSION & TRUST
```
[ ] /10 — Is the value proposition clear above the fold?
[ ] /10 — Are trust signals placed at decision points?
[ ] /10 — Do CTAs use specific action verbs?
[ ] /10 — Is unnecessary friction removed from the funnel?
[ ] /10 — Is there social proof (testimonials, logos, numbers)?
```

### FEEDBACK & STATES
```
[ ] /10 — Do loading states show what's happening (not just a spinner)?
[ ] /10 — Are error states recoverable (not dead ends)?
[ ] /10 — Do success states confirm what happened + what's next?
[ ] /10 — Are empty states helpful (not just blank)?
[ ] /10 — Does the product respond to every user action?
```

### AI EXPERIENCE (if applicable)
```
[ ] /10 — Is AI reasoning transparent?
[ ] /10 — Can users stop, regenerate, and give feedback on AI output?
[ ] /10 — Are tool actions previewed before execution?
[ ] /10 — Does the AI communicate uncertainty?
```

### ACCESSIBILITY
```
[ ] /10 — Keyboard navigable throughout?
[ ] /10 — Screen reader compatible?
[ ] /10 — Reduced motion respected?
[ ] /10 — Sufficient contrast ratios?
```

---

## Step 3: Present Findings and Ask Questions

Present the audit scores with specific examples, then ask ALL of these questions. Do NOT proceed until every answer is received.

### CATEGORY 1: Scope & Goals

1. **What is the #1 task users come to your product to accomplish?**
   - This is your core flow. Everything else is secondary.

2. **Where are users getting confused or dropping off?**
   - Specific pages, forms, steps — or "I don't know" (we'll find out)

3. **What are the 3 most important screens/flows to fix?**
   - Rank them. We work in priority order.

4. **Who are your users?**
   - Technical/non-technical? Age range? Mobile or desktop primary? Power users or casual?

### CATEGORY 2: Flows & Navigation

5. **How does a new user go from landing on your site to getting value?**
   - Walk me through the current flow step by step
   - Where does it break or feel slow?

6. **How many clicks does it take to reach the most important feature?**
   - Target: ≤ 3 clicks from homepage

7. **Do users need search? If so, what are they searching for?**
   - Products, docs, people, settings, content?

8. **Is there a mobile experience? How different is it from desktop?**

### CATEGORY 3: Copy & Content

9. **What voice/tone should the product have?**
   - Professional & precise / Friendly & casual / Technical & direct / Warm & encouraging

10. **Are there specific error scenarios that frustrate users?**
    - Form validation, payment errors, permissions, API failures?

11. **Do you have empty states that are just blank?**
    - List them — these are conversion killers

### CATEGORY 4: Conversion & Engagement

12. **What is the primary conversion action?**
    - Sign up, purchase, subscribe, book a demo, start free trial?

13. **Do you have social proof? What kind?**
    - Testimonials, logos, case studies, numbers, reviews?
    - If not, can we add any?

14. **What happens after a user converts? Is there a post-conversion experience?**
    - Confirmation page, welcome email, onboarding sequence?

### CATEGORY 5: AI Features (if applicable)

15. **Does the product have AI features? What kind?**
    - Chat, completion, generation, agents, copilot?

16. **Can the AI take actions on behalf of the user? Which ones?**
    - Do users need to approve actions before they execute?

### CATEGORY 6: Constraints

17. **What are your biggest UX pain points right now?**
    - Free-text — tell me what bothers YOU most

18. **Budget / timeline?**
    - Quick pass (1-2 hours) / Thorough overhaul / Full UX redesign

---

## Step 4: Build UX Enhancement Plan

Based on answers, create a prioritized plan:

```markdown
## UX Enhancement Plan for [Product]

### Core Flow Fix
- Current: [current flow with pain points marked]
- Improved: [redesigned flow with changes listed]
- Expected impact: [what gets better]

### Priority Areas (ordered by impact)
1. [Highest impact area] — specific changes
2. [Second priority] — specific changes
3. [Third priority] — specific changes

### Copy Changes
- [ ] [Component]: Change "[current copy]" → "[improved copy]"
- [ ] [Component]: Add empty state copy
- [ ] [Component]: Fix error messages

### Flow Changes
- [ ] [Flow]: Remove step X (unnecessary friction)
- [ ] [Flow]: Add escape hatch at step Y
- [ ] [Flow]: Add progress indicator

### State Changes
- [ ] [Component]: Add loading state
- [ ] [Component]: Add empty state
- [ ] [Component]: Improve error recovery

### Files to Modify
1. [file] — [what changes]
2. [file] — [what changes]
```

**Present the plan. Wait for approval before writing any code.**

---

## Step 5: Execute

After approval, work in this order:

1. **Fix the core flow first** — Remove friction, add escape hatches, ensure completion
2. **Fix copy** — Error messages, empty states, button labels, confirmation dialogs
3. **Fix forms** — Validation, field design, mobile optimization
4. **Fix navigation** — Labels, structure, search, breadcrumbs
5. **Add trust signals** — Social proof, security badges, friction reducers
6. **Fix feedback states** — Loading, success, error, empty
7. **Fix onboarding** — First-run experience, activation path
8. **Fix AI UX** — Transparency, tool approval, streaming states (if applicable)

After each major change, describe the improvement and confirm direction.

---

## Step 6: Verify

Re-score the audit dimensions from Step 2 and report before/after:

```
DIMENSION                    BEFORE → AFTER
Core flow completion:        5/10   → 8/10
Error message clarity:       3/10   → 9/10
Empty state helpfulness:     2/10   → 8/10
...
TOTAL IMPROVEMENT:           X points
```

Run the full checklists from each loaded skill as final verification.
