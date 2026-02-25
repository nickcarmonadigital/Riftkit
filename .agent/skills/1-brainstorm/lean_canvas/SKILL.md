---
name: Lean Canvas
description: One-page business model canvas with uncertainty analysis and MVP scope definition
---

# Lean Canvas Skill

**Purpose**: Guide completion of a Lean Canvas -- the one-page business model adapted from Business Model Canvas for startups and new products. After filling all 9 boxes, this skill identifies which box has the highest uncertainty (the riskiest assumption), designs an MVP scope to test it, and produces a `lean-canvas.md` document. This provides a fast, structured way to capture the business model before investing in detailed planning.

## TRIGGER COMMANDS

```text
"Lean canvas for [product]"
"One-page business model"
"Validate before building"
```

## When to Use
- At the start of Phase 1, before deep-diving into individual brainstorm skills
- When you need to quickly capture and communicate a business model
- When deciding between multiple product ideas (create one canvas per idea)
- As input to `assumption_testing` to identify what needs validation

---

## PROCESS

### Step 1: Fill the 9-Box Canvas

Work through each box in the recommended order (not left-to-right, but by priority):

**Recommended fill order**: Problem > Customer Segments > UVP > Solution > Channels > Revenue Streams > Cost Structure > Key Metrics > Unfair Advantage

```markdown
# Lean Canvas: [Product Name]
## Date: [DATE] | Version: [1.0]

+----------------------------+----------------------------+----------------------------+
|                            |                            |                            |
|  2. PROBLEM                |  4. SOLUTION               |  3. UNIQUE VALUE           |
|                            |                            |     PROPOSITION            |
|  Top 3 problems:           |  Top 3 features:           |                            |
|  1. ___                    |  1. ___                    |  Single clear message:     |
|  2. ___                    |  2. ___                    |  ___                       |
|  3. ___                    |  3. ___                    |                            |
|                            |                            |  High-level concept:       |
|  Existing alternatives:    |                            |  "[X] for [Y]"             |
|  - ___                     |                            |                            |
|                            |                            |                            |
+----------------------------+----------------------------+----------------------------+
|                            |                            |                            |
|  8. KEY METRICS            |  5. CHANNELS               |  9. UNFAIR ADVANTAGE       |
|                            |                            |                            |
|  Key activities to         |  Path to customers:        |  Cannot be easily copied:  |
|  measure:                  |  - ___                     |  - ___                     |
|  - ___                     |  - ___                     |                            |
|  - ___                     |  - ___                     |  (OK to leave blank --     |
|                            |                            |   most startups don't      |
|                            |                            |   have one yet)            |
+----------------------------+----------------------------+----------------------------+
|                            |                            |                            |
|  7. COST STRUCTURE         |             1. CUSTOMER SEGMENTS                        |
|                            |                            |                            |
|  Fixed costs:              |  Target customers:         |  Early adopters:           |
|  - ___                     |  - ___                     |  - ___                     |
|  Variable costs:           |  - ___                     |                            |
|  - ___                     |                            |                            |
|                            |                            |                            |
+----------------------------+----------------------------+----------------------------+
|                                                         |                            |
|  6. REVENUE STREAMS                                     |                            |
|                                                         |                            |
|  Revenue model: ___                                     |                            |
|  Pricing: ___                                           |                            |
|  LTV estimate: ___                                      |                            |
|  CAC estimate: ___                                      |                            |
|                                                         |                            |
+---------------------------------------------------------+----------------------------+
```

### Step 2: Fill Each Box with Guidance

#### Box 1: Customer Segments
- Who are the target customers? Be specific (not "everyone").
- Who are the early adopters? (The first people who will use it despite it being rough.)
- Are there multiple segments? Pick ONE to start.

#### Box 2: Problem
- What are the top 3 problems for this customer segment?
- How are they solving these problems today (existing alternatives)?
- How painful is each problem (1-5 scale)?

#### Box 3: Unique Value Proposition
- Write a single clear sentence: "We help [customer] [achieve outcome] by [approach]"
- High-level concept: "[Known thing] for [target segment]" (e.g., "Uber for dog walking")

#### Box 4: Solution
- For each problem listed, what is the simplest feature that solves it?
- Resist scope creep -- list only the top 3 features.

#### Box 5: Channels
- How will you reach customers? (Content, paid ads, partnerships, sales, PLG)
- What is the primary channel? What is the fallback?

#### Box 6: Revenue Streams
- How will you make money? (Subscription, usage, marketplace, freemium)
- What is the price point? (Reference `market_sizing` WTP analysis if available)
- Estimate LTV and CAC.

#### Box 7: Cost Structure
- What are the fixed costs? (Hosting, salaries, tools)
- What are the variable costs? (Per-user, per-transaction)
- What is the monthly burn rate?

#### Box 8: Key Metrics
- What is the ONE metric that matters most right now? (OMTM)
- What are the pirate metrics (AARRR): Acquisition, Activation, Retention, Revenue, Referral?

#### Box 9: Unfair Advantage
- What do you have that cannot be easily copied or bought? (Network effects, data moats, expertise, community, regulatory advantage)
- It is OK to leave this blank initially -- most new products do not have one yet.

### Step 3: Identify Highest Uncertainty Box

Rate each box on uncertainty (1-5):

```markdown
## Uncertainty Analysis

| Box | Confidence (1-5) | Evidence | Uncertainty |
|-----|------------------|----------|-------------|
| Customer Segments | 4 | 20 interviews conducted | Low |
| Problem | 4 | Validated in interviews | Low |
| UVP | 3 | Resonated in 60% of tests | Medium |
| Solution | 2 | No prototype tested | High |
| Channels | 3 | Some experiments run | Medium |
| Revenue Streams | 2 | Pricing untested | High |
| Cost Structure | 4 | Known infrastructure costs | Low |
| Key Metrics | 3 | Benchmarks available | Medium |
| Unfair Advantage | 1 | None identified yet | Very High |

**Riskiest Box**: [The one with lowest confidence that has highest impact]
```

### Step 4: Design MVP Scope

Based on the riskiest box, define the minimum product needed to test it:

```markdown
## MVP Definition

### What the MVP Tests
- Primary hypothesis: [From the riskiest box]
- Success criteria: [Measurable outcome]
- Timeline: [Weeks to build + test]

### MVP Features (Minimum Viable)
| Feature | Purpose | Effort |
|---------|---------|--------|
| [Feature 1] | Tests [hypothesis] | S |
| [Feature 2] | Minimum usable product | M |
| [Feature 3] | Data collection for validation | S |

### Explicitly NOT in MVP
- [Feature X] -- not needed to test the hypothesis
- [Feature Y] -- nice to have, defer to v2
- [Feature Z] -- premature optimization
```

### Step 5: Produce Lean Canvas Document

Save the completed canvas, uncertainty analysis, and MVP definition to:

```
.agent/docs/1-brainstorm/lean-canvas.md
```

This feeds into `assumption_testing` (riskiest box becomes the top LOFA) and `prd_generator` (business model context).

---

## CHECKLIST

- [ ] All 9 canvas boxes filled (Unfair Advantage may be blank with rationale)
- [ ] Customer segment is specific, not generic
- [ ] Problems are validated or flagged as assumptions
- [ ] UVP is a single clear sentence
- [ ] Solution maps to specific problems (not feature bloat)
- [ ] Revenue model and pricing defined (even if estimated)
- [ ] Uncertainty analysis completed for all 9 boxes
- [ ] Riskiest box identified
- [ ] MVP scope defined to test the riskiest hypothesis
- [ ] Canvas saved to `.agent/docs/1-brainstorm/lean-canvas.md`

---

*Skill Version: 1.0 | Phase: 1-Brainstorm | Priority: P1*
