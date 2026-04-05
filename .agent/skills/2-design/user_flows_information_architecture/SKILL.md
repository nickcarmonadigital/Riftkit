---
name: User Flows & Information Architecture
description: Design user flows, task flows, sitemaps, labeling systems, and information architecture that match how users think — not how the system is built
---

# User Flows & Information Architecture

**Purpose**: Structure your product so users can find what they need, complete tasks efficiently, and never hit dead ends. Covers flow mapping with notation, hierarchical task analysis, IA organization schemes, sitemap depth rules, labeling validation, card sorting methods, and content prioritization.

---

## TRIGGER COMMANDS

```text
"Map the user flow for [feature]"
"Design the information architecture for [product]"
"Create a sitemap for [project]"
"Run a card sort for [navigation structure]"
"Audit the navigation labels on [site]"
"Using user_flows_information_architecture skill: [target]"
```

---

## WHEN TO USE

- Starting a new product or major feature redesign
- Users can't find things or get lost in the product
- Navigation feels disorganized or mirrors the org chart
- Adding new sections to an existing product
- Before any build phase — structure first, then design, then code

---

## 1. USER FLOW MAPPING

### Flow Types

| Type          | What It Maps                      | When to Use                                |
|---------------|-----------------------------------|--------------------------------------------|
| **Task flow** | Single linear path, no decisions  | Simple processes (password reset, logout)   |
| **User flow** | Multiple paths with decision points| Sign-up, checkout, onboarding              |
| **Wireflow**  | Flows + screen layouts combined   | Full feature planning with UI context       |
| **Swimlane**  | Multi-actor flows with handoffs   | Approval workflows, multi-role features     |

### Flow Notation

```
[Rectangle]          → Screen or page
<Diamond>            → Decision point (yes/no, if/else)
(Rounded rectangle)  → Action the user takes
[Parallelogram]      → System action (email sent, data saved)
→                    → Direction of flow
- - - →              → Conditional / alternate path
[X]                  → Dead end (must be eliminated)
[Circle]             → Start / End point
```

### Critical Flows Every Product Needs

```
1. First visit → value realization (understand what this does in under 10 seconds)
2. Sign-up / registration flow (minimize fields, defer non-essential data)
3. Core action flow (the #1 thing users come here to do)
4. Error recovery flow (what happens when things break?)
5. Return visit flow (how do returning users re-engage?)
6. Settings / account management flow
7. Payment / upgrade flow (if applicable)
8. Offboarding / account deletion flow (legally required in many jurisdictions)
```

### Flow Design Rules

```
1. Every screen must have a clear PRIMARY ACTION and an ESCAPE HATCH
2. No dead ends — every state must lead somewhere
3. Minimize steps — each additional step loses 10-20% of users
4. Design the happy path first, then map every edge case
5. Map ALL entry points — users don't always start at the homepage
6. Decision points must have exactly 2-3 outcomes (never ambiguous)
7. System actions (emails, notifications) are part of the flow — map them
8. Every flow ends with either a success state or a recovery path
```

### Happy Path vs Edge Cases

```
HAPPY PATH (map first):
  User has good data → completes flow → sees success → continues

EDGE CASES (map second):
  Empty state:       User has no data for this feature
  Error state:       Network fails, validation fails, permission denied
  Partial state:     User abandons mid-flow and returns later
  Overload state:    User has too much data (pagination, search needed)
  Permission state:  User can view but not edit, or needs upgrade
  Timeout state:     Session expires during multi-step flow
```

### Anti-patterns

```
[ ] Requiring registration before showing any value
[ ] Dead ends with no back button or recovery path
[ ] Flows that require context-switching between apps or tabs
[ ] Assuming all users enter through the homepage
[ ] No confirmation or feedback after completing a flow
[ ] Decision points with more than 3 branches (split into sub-flows)
```

---

## 2. TASK ANALYSIS

### Hierarchical Task Analysis (HTA)

Break any user goal into a tree of sub-tasks:

```
Goal: Purchase a product
├── 1. Find product
│   ├── 1.1 Browse categories
│   ├── 1.2 Use search
│   └── 1.3 Follow recommendation
├── 2. Evaluate product
│   ├── 2.1 View details
│   ├── 2.2 Read reviews
│   └── 2.3 Compare options
├── 3. Add to cart
│   ├── 3.1 Select options (size, color)
│   └── 3.2 Set quantity
├── 4. Checkout
│   ├── 4.1 Enter shipping info
│   ├── 4.2 Enter payment info
│   └── 4.3 Review order
└── 5. Post-purchase
    ├── 5.1 View confirmation
    ├── 5.2 Track order
    └── 5.3 Request return
```

### Jobs-To-Be-Done (JTBD) Framework

```
Template: "When I [situation], I want to [motivation], so I can [expected outcome]."

Examples:
  "When I'm evaluating SaaS tools, I want to compare pricing tiers side by side, so I can choose the best plan without calling sales."
  "When I get a notification about a failed build, I want to see exactly what broke, so I can fix it without digging through logs."
```

### Critical User Journeys

```
Map the 3-5 most important journeys through your product:

Journey 1: [New user activation]
  Entry → Awareness → Sign-up → Onboarding → First value moment → Habit loop

Journey 2: [Core task completion]
  Entry → Navigate to feature → Complete task → Confirmation → Return

Journey 3: [Upgrade / conversion]
  Hit limitation → See upgrade prompt → Compare plans → Purchase → Access new features
```

### Task Analysis Checklist

```
[ ] Top 5 user goals identified and prioritized
[ ] Each goal broken into sub-tasks (max 3 levels deep)
[ ] JTBD statements written for top 3 user segments
[ ] Critical journeys mapped end-to-end (entry to completion)
[ ] Handoff points between human and system are identified
```

---

## 3. INFORMATION ARCHITECTURE FUNDAMENTALS

### Organization Schemes

| Scheme          | Organizes By         | Best For                                    | Example              |
|-----------------|----------------------|---------------------------------------------|----------------------|
| **Alphabetical**| A-Z sorting          | Reference content, directories, glossaries  | Contact list, API docs|
| **Chronological**| Time / date         | News, blogs, activity logs, changelogs      | Blog archive          |
| **Topical**     | Subject / category   | Most products — group by theme              | Documentation sections|
| **Audience**    | User type / role     | Products serving distinct user segments     | "For developers" / "For managers" |
| **Task-based**  | What user wants to do| Action-oriented products, dashboards        | "Create", "Manage", "Analyze" |
| **Hybrid**      | Multiple schemes     | Complex products with diverse users         | Primary nav by task, secondary by topic |

### IA Structure Patterns

| Pattern            | Best For                        | Example                              |
|--------------------|---------------------------------|--------------------------------------|
| **Hierarchical**   | Content-heavy sites, blogs, docs| Most traditional websites             |
| **Hub-and-spoke**  | Dashboards, mobile apps         | Central home + linked sections        |
| **Flat**           | Simple products, single-page    | Portfolio sites, landing pages        |
| **Search-dominant**| Large catalogs, knowledge bases | YouTube, Amazon, documentation sites  |
| **Matrix**         | Multiple valid paths to content | Filtering by multiple attributes      |

### IA Design Process

```
Step 1: Content inventory — list EVERYTHING the product needs to contain
Step 2: Content audit — evaluate what exists, what's missing, what's redundant
Step 3: Card sort — have 15+ users group content into categories
Step 4: Define categories — create labels based on user mental models
Step 5: Build sitemap — organize hierarchy with max 3 levels deep
Step 6: Tree test — validate 20+ users can find things in your structure
Step 7: Iterate — refine labels and structure based on test results
```

---

## 4. SITEMAP DESIGN

### Depth Rules

```
Level 1 (top nav):   5-7 items max — the primary sections
Level 2 (sub-nav):   5-9 items per section — visible on hover or sidebar
Level 3 (deep nav):  Access via breadcrumbs + search — never more than 3 levels
Level 4+:            Restructure. If you need 4+ levels, your IA is broken.
```

### Click Depth Targets

```
Critical content:    1 click from any page (search, persistent nav)
Important content:   2 clicks max from homepage
Supporting content:  3 clicks max from homepage
Archival content:    Accessible via search — doesn't need nav placement
```

### Flat vs Deep Hierarchy

| Flat (wide)                  | Deep (narrow)                     |
|------------------------------|-----------------------------------|
| Many items at each level     | Few items at each level           |
| Faster to scan               | More clicks to reach content      |
| Harder to group mentally     | Easier to chunk information       |
| Best for 20-50 total pages   | Best for 100+ pages with clear categories |
| Risk: overwhelming top nav   | Risk: too many clicks to find things |

**Rule**: Aim for 2-3 levels max. If you need more, add search as a primary navigation method.

### Breadcrumb Implications

```
Depth 1:  No breadcrumbs needed (Home → Page)
Depth 2:  Breadcrumbs optional (Home → Section → Page)
Depth 3:  Breadcrumbs REQUIRED (Home → Section → Sub-section → Page)
Depth 4+: Breadcrumbs + search REQUIRED (restructure your IA)
```

### Sitemap Template

```
Home
├── [Primary Section 1]           ← Task-based or topical label
│   ├── Sub-page 1a
│   ├── Sub-page 1b
│   └── Sub-page 1c
├── [Primary Section 2]
│   ├── Sub-page 2a
│   └── Sub-page 2b
├── [Primary Section 3]
├── Pricing
├── About / Company
│   ├── Team
│   ├── Careers
│   └── Contact
└── Legal (footer only)
    ├── Privacy Policy
    ├── Terms of Service
    └── Cookie Policy

Utility nav (top-right):  Login | Sign up | Search | Language
Footer nav:               Key links repeated + Social + Legal + Status page
```

---

## 5. LABELING SYSTEMS

### Label Quality Rules

```
1. Labels must PREDICT what's inside (information scent)
2. Use USER language, not company or engineering language
3. Be specific: "API reference" not "Resources"
4. Be consistent: same concept = same label everywhere
5. Test with real users (tree testing, card sorting)
6. No more than 7 items at any navigation level
7. Avoid jargon, acronyms, or internal terminology in primary nav
```

### Bad vs Good Labels

| Bad Label      | Problem                          | Good Alternative      |
|----------------|----------------------------------|-----------------------|
| Resources      | Could be anything                | Documentation         |
| Solutions      | Corporate-speak, vague           | Features              |
| Products       | Too broad for a single product   | Templates / Integrations |
| More           | Says nothing                     | (Restructure the nav) |
| Platform       | Internal term                    | Dashboard             |
| Getting Started| Too generic                      | Quick start guide     |
| Insights       | Could be analytics or blog       | Analytics / Blog      |

### Label Testing Methods

```
FIVE-SECOND TEST:    Show label → ask "What would you expect to find here?"
TREE TEST:           "Find the API docs" → see if users navigate correctly
CARD SORT:           Users group items → labels emerge from their categories
A/B TEST:            Run two label variants → measure click-through rates
```

### Consistency Rules

```
[ ] Same feature uses same label in nav, breadcrumbs, headings, and URLs
[ ] No synonyms: pick "delete" or "remove" and use it everywhere
[ ] URL slug matches the nav label: /documentation not /resources
[ ] Page title matches the nav label the user clicked
[ ] Breadcrumb trail uses the same labels as the nav items
```

---

## 6. CARD SORTING METHODS

### Method Comparison

| Method          | How It Works                           | When to Use                       | Min Participants |
|-----------------|----------------------------------------|-----------------------------------|------------------|
| **Open sort**   | Users create their own categories      | New product, no existing structure | 15-20            |
| **Closed sort** | Users sort into pre-defined categories | Validating an existing structure   | 15-20            |
| **Hybrid sort** | Pre-defined categories + user can add  | Refining a near-final structure    | 15-20            |

### Running a Card Sort

```
Step 1: Create 30-60 cards representing your content/features
Step 2: Recruit 15-20 participants from your target audience
Step 3: Ask them to group cards into categories that make sense
Step 4: (Open sort) Ask them to name each category
Step 5: Analyze agreement — look for groups where 60%+ agree
Step 6: Use high-agreement groups as your nav categories
Step 7: For low-agreement items, consider placing in multiple locations or via search
```

### Tools

```
Remote:   Optimal Workshop, UXtweak, Maze, UserZoom
In-person: Physical cards on a table, sticky notes on a wall
Free:     Google Forms (limited but works for small studies)
```

### Interpreting Results

```
Strong agreement (70%+):  Definite category — use as a nav section
Moderate agreement (50-70%): Likely category — validate with tree test
Weak agreement (<50%):    No natural home — consider search, cross-linking, or restructuring
Split opinions:           Item may belong in multiple places — use both (cross-reference)
```

---

## 7. CONTENT PRIORITIZATION

### Content-First Design

```
1. List all content the page must display
2. Rank by importance to the user's goal (not the business goal)
3. Design the layout AROUND the content priority
4. Most important content = largest, highest, most prominent
5. Least important content = smaller, lower, or accessible via expand/search
```

### Reading Patterns

| Pattern   | Shape   | Best For                          | Place Key Content           |
|-----------|---------|-----------------------------------|-----------------------------|
| **F-pattern** | F   | Text-heavy pages, search results  | Left side, first 2 lines    |
| **Z-pattern** | Z   | Landing pages, sparse layouts     | Top-left, top-right, bottom |
| **Layer cake**| ===  | Scannable lists with headings     | Bold headings, indented body|
| **Spotted**   | ..  | Pages where users hunt for links  | Make CTAs visually distinct  |

### Above-the-Fold Rules

```
Above the fold MUST contain:
  1. Clear value proposition (what is this? why should I care?)
  2. Primary CTA (the one thing you want users to do)
  3. Navigation (so users know where they are and what's available)

Above the fold should NOT contain:
  1. Long paragraphs of text (save for below the fold)
  2. Multiple competing CTAs (one primary, one secondary max)
  3. Auto-playing video or animations that distract from the CTA
```

### Prioritization Matrix

```
                    HIGH user importance
                         │
         ┌───────────────┼───────────────┐
         │  MUST SHOW     │  SHOW PROMINENTLY│
         │  (always visible│  (hero, top area)│
LOW      │  in nav/footer) │                  │ HIGH
business ├───────────────┼───────────────┤ business
value    │  HIDE/REMOVE   │  SECONDARY     │ value
         │  (cut it or    │  (below fold,  │
         │   move to FAQ) │   expandable)  │
         └───────────────┼───────────────┘
                         │
                    LOW user importance
```

---

## EXIT CRITERIA

```
[ ] All critical user flows are mapped (happy path + at least 3 edge cases)
[ ] Every screen in a flow has a primary action and an escape hatch
[ ] No dead ends exist in any flow
[ ] Top 5 user goals are identified with HTA breakdowns
[ ] JTBD statements exist for primary user segments
[ ] Organization scheme is chosen and consistent (topical, task-based, etc.)
[ ] Sitemap is max 3 levels deep
[ ] Click depth: critical content reachable in 1-2 clicks
[ ] Navigation labels predict content accurately (validated by tree test or user testing)
[ ] No more than 7 items at any navigation level
[ ] Labels are consistent across nav, breadcrumbs, headings, and URLs
[ ] Card sort or tree test conducted with 15+ participants (or planned)
[ ] Content prioritized by user importance, not business preference
[ ] Above-the-fold content includes value proposition + primary CTA
[ ] Search is available as fallback for complex structures
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: NNGroup IA research, Abby Covert "How to Make Sense of Any Mess", Donna Spencer "Card Sorting"*
