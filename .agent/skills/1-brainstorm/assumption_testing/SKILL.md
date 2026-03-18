---
name: Assumption Testing
description: Enumerate project assumptions, rank by risk, and design experiments to invalidate the riskiest ones
---

# Assumption Testing Skill

**Purpose**: Force explicit enumeration of every assumption the project rests on, rank them by risk (probability of being wrong multiplied by impact if wrong), and design minimum viable experiments to invalidate the riskiest ones before committing engineering resources. This prevents building the wrong thing by catching fatal assumptions early through Leap of Faith Assumptions (LOFAs), pre-mortem analysis, and Riskiest Assumption Testing (RAT).

## TRIGGER COMMANDS

```text
"Test our assumptions"
"What are we assuming?"
"Riskiest assumption"
```

## When to Use
- After initial brainstorming, before committing to a solution direction
- When a lean canvas reveals high-uncertainty boxes
- Before allocating engineering resources to a new feature or product
- When team members disagree on whether something will work

---

## PROCESS

### Step 1: Enumerate All Assumptions

Go through each category and list every assumption -- even the "obvious" ones:

| Category | Prompt Questions |
|----------|-----------------|
| **Customer** | Do they have this problem? Will they pay? Can we reach them? |
| **Problem** | Is it painful enough to solve? Are they solving it already? |
| **Solution** | Will our approach work? Can we build it? Will they use it? |
| **Market** | Is the market big enough? Is timing right? |
| **Technical** | Can the tech handle scale? Will integrations work? |
| **Business** | Can we make money? Is the unit economics viable? |
| **Team** | Do we have the skills? Can we hire what we lack? |

Record each assumption explicitly:

```markdown
## Assumption Log

| ID | Assumption | Category | Evidence For | Evidence Against |
|----|-----------|----------|-------------|-----------------|
| A1 | Users want AI-generated reports | Customer | 3 interview mentions | No quantitative data |
| A2 | We can process 10K docs/min | Technical | Napkin math | No benchmark run |
| A3 | SMBs will pay $49/mo | Business | Competitor pricing | No WTP validation |
| A4 | React Native is fast enough | Technical | Team experience | No perf testing done |
| A5 | Users will self-onboard | Customer | Similar products do it | Our product is complex |
```

### Step 2: Identify Leap of Faith Assumptions (LOFAs)

LOFAs are assumptions where, if wrong, the entire project fails. Flag them:

```markdown
## Leap of Faith Assumptions

| ID | LOFA | Why It's Fatal |
|----|------|---------------|
| A1 | Users want AI-generated reports | No demand = no product |
| A3 | SMBs will pay $49/mo | Below breakeven = no business |
```

### Step 3: Score and Rank by Risk

For each assumption, score:
- **Probability of Being Wrong** (1-5): How likely is this assumption incorrect?
- **Impact if Wrong** (1-5): How damaging if this turns out to be false?

**Risk Score** = Probability x Impact

```markdown
## Assumption Risk Ranking

| Rank | ID | Assumption | P(Wrong) | Impact | Risk Score |
|------|-----|-----------|----------|--------|------------|
| 1 | A3 | SMBs will pay $49/mo | 4 | 5 | 20 |
| 2 | A1 | Users want AI reports | 3 | 5 | 15 |
| 3 | A5 | Users will self-onboard | 4 | 3 | 12 |
| 4 | A2 | 10K docs/min processing | 2 | 4 | 8 |
| 5 | A4 | React Native performance | 2 | 3 | 6 |
```

### Step 4: Run a Pre-Mortem

Imagine the project has failed. Work backward:

```markdown
## Pre-Mortem Exercise

"It is 6 months from now. The project has been cancelled. Why?"

1. [Most likely cause of death]
2. [Second most likely]
3. [Third most likely]

**Mapping to Assumptions**: Each cause maps back to which assumption was wrong.
```

### Step 5: Design Riskiest Assumption Tests (RATs)

For the top 3-5 riskiest assumptions, design the cheapest, fastest experiment:

```markdown
## Riskiest Assumption Tests

### RAT 1: Will SMBs pay $49/mo? (A3, Risk: 20)
- **Experiment**: Fake door test -- landing page with pricing, measure "Sign Up" clicks
- **Success Criteria**: >5% click-through on pricing page
- **Time to Run**: 1 week
- **Cost**: $200 (ad spend)
- **Decision**: If <2% CTR, pivot pricing model before building

### RAT 2: Do users want AI-generated reports? (A1, Risk: 15)
- **Experiment**: 10 customer interviews with prototype mockups
- **Success Criteria**: 7/10 say "I would use this weekly"
- **Time to Run**: 2 weeks
- **Cost**: $0 (existing contacts)
- **Decision**: If <5/10, kill the feature

### RAT 3: Will users self-onboard? (A5, Risk: 12)
- **Experiment**: Unmoderated usability test with 5 users on prototype
- **Success Criteria**: 4/5 complete onboarding without help
- **Time to Run**: 1 week
- **Cost**: $250 (UserTesting.com)
- **Decision**: If <3/5, budget for guided onboarding
```

### Step 6: Execute and Record Results

After running each RAT, update the assumption log:

```markdown
## RAT Results

| ID | Assumption | Test Run | Result | Decision |
|----|-----------|----------|--------|----------|
| A3 | SMBs pay $49/mo | Fake door test | 3.1% CTR | CONDITIONAL -- test $29 tier |
| A1 | Users want AI reports | 10 interviews | 8/10 positive | VALIDATED -- proceed |
| A5 | Self-onboard | Usability test | 2/5 completed | INVALIDATED -- add guided flow |
```

### Step 7: Produce Signed Assumption Log

Save the complete log with test results to:

```
.agent/docs/1-brainstorm/assumption-log.md
```

This document feeds directly into `go_no_go_gate` and `prd_generator`.

---

## CHECKLIST

- [ ] All assumptions enumerated across all 7 categories
- [ ] Leap of Faith Assumptions (LOFAs) identified and flagged
- [ ] Each assumption scored on Probability x Impact
- [ ] Assumptions ranked by risk score
- [ ] Pre-mortem exercise completed
- [ ] RATs designed for top 3-5 riskiest assumptions
- [ ] RATs executed (or scheduled with clear timeline)
- [ ] Results recorded with GO/NO-GO decisions per assumption
- [ ] Assumption log saved to `.agent/docs/1-brainstorm/assumption-log.md`

---

*Skill Version: 1.0 | Phase: 1-Brainstorm | Priority: P1*


## Related Skills
- [`user_research`](../user_research/SKILL.md)
