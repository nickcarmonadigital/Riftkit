---
name: Conversion & Engagement UX
description: Design CTAs, trust signals, friction reduction, social proof, pricing pages, and retention loops that drive conversion without dark patterns
---

# Conversion & Engagement UX

**Purpose**: Systematically increase conversion rates and user engagement through proven UX patterns — CTA design, trust signals, friction reduction, social proof, pricing page UX, and ethical retention mechanics.

---

## TRIGGER COMMANDS

```text
"Improve conversion on [page]"
"Design the pricing page for [product]"
"Add trust signals to [checkout/landing page]"
"Reduce friction in the [signup/purchase] flow"
"Build retention loops for [product]"
"Using conversion_engagement_ux skill: [target]"
```

---

## WHEN TO USE

- Landing page conversion below 3% (B2B) or 5% (B2C)
- Checkout abandonment above 70%
- Designing or redesigning a pricing page
- Building retention/engagement features
- Auditing a funnel for friction points

---

## 1. CTA DESIGN & PLACEMENT

### Button Hierarchy

| Level | Purpose | Style | Examples |
|---|---|---|---|
| **Primary** | The ONE action you want | Filled, high contrast, largest | "Start Free Trial", "Buy Now" |
| **Secondary** | Alternative valid action | Outlined or ghost, smaller | "Learn More", "See Demo" |
| **Tertiary** | Low-priority option | Text link style | "Skip for now", "Maybe later" |

### CTA Copy Rules
- **Start with a verb**: "Get", "Start", "Create", "Join", "Download"
- **Be specific**: "Start Free Trial" not "Get Started"
- **Include the value**: "Save 20% Today" not "Submit"
- **Remove risk**: "Try Free for 14 Days" not "Sign Up"
- **Max 5 words** for primary CTAs
- **Never "Submit"** — always describe the outcome

### CTA Copy Comparison

| Weak | Strong | Why |
|---|---|---|
| Submit | Create My Account | Outcome-specific |
| Sign Up | Start Free Trial | Removes risk |
| Buy Now | Get Instant Access | Emphasizes value |
| Learn More | See How It Works | More specific |
| Download | Get the Free Guide | Adds perceived value |
| Click Here | View Pricing Plans | Describes destination |

### Placement Rules
- **Above the fold**: Primary CTA visible without scrolling on landing pages
- **After value proof**: CTA after testimonials/features, not before
- **Repeat at intervals**: On long pages, repeat CTA every 2-3 scroll sections
- **Fixed/sticky CTA**: For long product pages, sticky bottom bar on mobile
- **Exit intent**: Last-chance offer on mouse-leave (desktop only, use sparingly)

### Checklist
```
[ ] One primary CTA per viewport (no competing primaries)
[ ] CTA text starts with action verb and describes outcome
[ ] Primary CTA is highest contrast element on page
[ ] CTA appears above fold AND after social proof sections
[ ] Mobile: CTA is full-width, 48px+ height, thumb-reachable
[ ] Button has hover, active, and loading states
```

---

## 2. TRUST SIGNALS

### Trust Signal Types

| Type | Placement | Impact |
|---|---|---|
| **Customer logos** | Below hero, above fold | "Companies like you trust us" |
| **Testimonials** | After features, before CTA | Social proof from peers |
| **Star ratings** | Near product/pricing | Quick quality signal |
| **Numbers** | Hero or social proof section | "50,000+ teams", "4.9/5 rating" |
| **Security badges** | Near payment forms | Reduces purchase anxiety |
| **Media mentions** | Below hero or footer | Third-party credibility |
| **Case studies** | Dedicated section or links | Deep proof for B2B |
| **Real-time activity** | Toast notifications | "Sarah from Austin just signed up" |

### Testimonial Best Practices
- **Photo + name + title + company** — anonymous testimonials have near-zero impact
- **Specific results**: "Increased conversion by 34%" not "Great product!"
- **Relevant to page**: Testimonial on pricing page should mention value/ROI
- **3-5 testimonials** is the sweet spot — more causes decision fatigue
- **Video testimonials** convert 2-3x better than text

### Placement Rules
```
[ ] Customer logos visible within first viewport
[ ] Testimonials placed before primary conversion CTA
[ ] Security badges visible near payment/email fields
[ ] Numbers are specific (50,247 not "50,000+") when possible
[ ] Trust signals match the page purpose (pricing → ROI proof)
[ ] No fake reviews or manufactured social proof
```

---

## 3. FRICTION AUDIT

Every extra step, field, click, or moment of confusion reduces conversion. Audit systematically.

### Friction Identification Framework

| Friction Type | Example | Fix |
|---|---|---|
| **Cognitive** | Confusing options, unclear pricing | Simplify, add comparison table |
| **Interaction** | Too many clicks, tiny targets | Reduce steps, enlarge buttons |
| **Visual** | Cluttered layout, competing CTAs | White space, single primary CTA |
| **Speed** | Slow load, lag on interaction | Performance optimization |
| **Trust** | No social proof, unclear refund policy | Add trust signals |
| **Registration** | Must create account to buy/use | Guest checkout, social login |
| **Information** | Not enough info to decide | Add FAQs, comparison, specs |

### Friction Audit Process
```
1. Map the entire funnel (landing → signup/purchase → confirmation)
2. Count total clicks/steps from first visit to conversion
3. Time each step — any step taking >30s is a friction point
4. Watch 10+ session recordings of users who abandoned
5. Note where users hesitate, scroll back, or rage-click
6. For each friction point: remove, reduce, or explain
```

### Quick Friction Fixes

| Problem | Fix |
|---|---|
| Account required before purchase | Add guest checkout |
| Long registration form | Social login (Google/Apple/GitHub) |
| Complex pricing | Highlight "Most Popular" plan |
| Shipping cost surprise at checkout | Show shipping estimate on product page |
| Slow page load | Lazy load images, reduce JS bundle |
| Unclear next step | Larger, more descriptive CTA |

---

## 4. SOCIAL PROOF PATTERNS

### Pattern Selection by Product Type

| Product Type | Best Social Proof | Why |
|---|---|---|
| **B2B SaaS** | Customer logos + case studies | Decision-makers need peer validation |
| **E-commerce** | Star ratings + review count | Quick quality signal |
| **Marketplace** | Transaction volume + seller ratings | Trust in marketplace integrity |
| **Developer tools** | GitHub stars + community size | Developer trust signals |
| **Consumer app** | Download count + user testimonials | Social momentum |
| **Service business** | Before/after + specific results | Proof of outcome |

### Implementation Rules
- **Numbers should be specific** — "12,847 teams" > "10,000+ teams"
- **Update dynamically** — stale "10,000+" for years looks fake
- **Match the audience** — enterprise testimonials for enterprise page
- **Place before the ask** — social proof comes before CTA, not after
- **Real-time proof** — "3 people viewing this" creates gentle urgency (but be honest)

---

## 5. PRICING PAGE UX

### Layout Rules
- **3 plans maximum** for initial view (most common: Free/Pro/Enterprise)
- **Highlight recommended plan** — visual emphasis (border, badge, size)
- **Annual/monthly toggle** — show savings for annual ("Save 20%")
- **Feature comparison table** below the plan cards
- **FAQ section** at bottom addressing common objections

### Plan Card Design

| Element | Rule |
|---|---|
| **Plan name** | Descriptive: "Starter", "Pro", "Team" (not Plan 1, Plan 2) |
| **Price** | Large, prominent, with period ("/mo" or "/year") |
| **Key differentiator** | 1 sentence explaining who this plan is for |
| **Feature list** | 5-7 most important features (not 20) |
| **CTA** | Specific: "Start Pro Trial" not "Select" |
| **Recommended badge** | "Most Popular" or "Best Value" on middle plan |

### Pricing Anti-Patterns
- Showing too many plans (>4 causes decision paralysis)
- Hiding the price ("Contact us" for all plans kills self-serve)
- Feature lists that are too long to compare
- No annual discount option
- Confusing per-seat vs per-team vs per-usage pricing
- Enterprise plan with no starting price indicator at all

### Checklist
```
[ ] 3 plan tiers maximum visible (with enterprise "Contact Us" separate)
[ ] Recommended plan visually highlighted
[ ] Annual/monthly toggle with savings shown
[ ] Feature comparison table below plan cards
[ ] Each plan card has specific CTA (not generic "Select")
[ ] FAQ addresses top 5 pricing objections
[ ] Free trial or money-back guarantee prominently displayed
```

---

## 6. RETENTION & RE-ENGAGEMENT

### Retention Mechanics

| Mechanic | Implementation | Best For |
|---|---|---|
| **Habit loop** | Trigger → action → reward → investment | Daily-use products |
| **Streaks** | Track consecutive days of usage | Learning, fitness, productivity |
| **Progress** | Show progress toward a goal | Course platforms, project tools |
| **Notifications** | Relevant, timely, actionable alerts | Social, messaging, task tools |
| **Email hooks** | Weekly digest, activity summary | Any product with content |
| **Saved state** | "Pick up where you left off" | Content, learning, builder tools |

### Notification Design Rules
- **Relevant**: Only notify about things the user has opted into
- **Actionable**: Every notification should have a clear next action
- **Timely**: Send when the user can act on it (not 3am)
- **Batched**: Group multiple notifications (daily digest, not 10 pings)
- **Decreasing frequency**: New users get more, veterans get fewer
- **Easy to disable**: Granular notification settings, not just on/off

### Win-Back Flows
```
Day 3 inactive:  In-app: "Pick up where you left off on [project]"
Day 7 inactive:  Email: "Here's what you missed + quick win suggestion"
Day 14 inactive: Email: "We've added [new feature] — come see"
Day 30 inactive: Email: "We miss you — here's 20% off" (if applicable)
Day 60 inactive: Email: Final re-engagement, then reduce frequency
```

---

## 7. ETHICAL PERSUASION

### Dark Patterns to NEVER Use

| Pattern | What It Is | Why It's Wrong |
|---|---|---|
| **Confirmshaming** | "No thanks, I don't want to save money" | Manipulates through guilt |
| **Roach motel** | Easy to subscribe, impossible to cancel | Traps users |
| **Hidden costs** | Fees revealed only at checkout | Breaks trust |
| **Forced continuity** | Free trial → auto-charge with no warning | Deceptive |
| **Misdirection** | Visual tricks to select wrong option | Manipulative |
| **Sneak into basket** | Pre-checked add-ons in cart | Deceptive |
| **Fake urgency** | "Only 2 left!" when there are 2,000 | Dishonest |
| **Fake social proof** | Made-up testimonials or numbers | Fraudulent |

### Ethical Alternatives

| Instead Of | Do This |
|---|---|
| Confirmshaming | Neutral dismiss: "No thanks" or "Maybe later" |
| Hidden fees | Show total cost upfront, including shipping/tax |
| Forced continuity | Email 3 days before trial ends, one-click cancel |
| Fake urgency | Real urgency: "Sale ends Friday" with actual end date |
| Pre-checked upsells | Unchecked by default, clear description of add-on |
| Difficult cancellation | Cancel from settings, no phone call required |

### Checklist
```
[ ] No confirmshaming language on dismiss buttons
[ ] All costs visible before final purchase step
[ ] Trial end date clearly communicated + reminder email sent
[ ] Cancel is self-serve and findable within 2 clicks
[ ] No pre-checked upsells or add-ons
[ ] Urgency is real, not manufactured
[ ] Social proof is genuine (real users, real numbers)
[ ] Notifications respect user preferences and local time
```

---

## EXIT CRITERIA

```
[ ] Primary CTA is specific, verb-first, and highest contrast element
[ ] Only one primary CTA per viewport — no competing actions
[ ] Trust signals placed before primary conversion points
[ ] Testimonials have photo + name + specific results
[ ] Friction audit completed — every unnecessary step removed
[ ] Pricing page has 3 tiers, recommended plan highlighted, annual toggle
[ ] Social proof matches the audience and page purpose
[ ] Retention mechanics defined (notifications, email hooks, saved state)
[ ] No dark patterns — ethical persuasion only
[ ] Mobile: sticky CTA, full-width buttons, thumb-zone placement
[ ] Conversion funnel instrumented with analytics at every step
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: Conversion optimization research + behavioral economics*
