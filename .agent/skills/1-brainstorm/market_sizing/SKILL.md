---
name: Market Sizing
description: TAM-SAM-SOM analysis with top-down and bottom-up approaches for product viability
---

# Market Sizing Skill

**Purpose**: Guide a structured TAM-SAM-SOM analysis using both top-down (industry reports) and bottom-up (unit economics) approaches. This skill covers market sizing for consumer, B2B SaaS, marketplace, and developer tools product types. It includes willingness-to-pay validation and revenue projection methodology. The output is a `market-sizing.md` document with key metrics that feeds into `go_no_go_gate` and `prd_generator`.

## TRIGGER COMMANDS

```text
"Market sizing for [product]"
"TAM SAM SOM analysis"
"How big is the market"
```

## When to Use
- During Phase 1 brainstorming to validate that the opportunity is worth pursuing
- Before presenting a business case to stakeholders or investors
- When comparing multiple product ideas and need to prioritize by market size
- After `competitive_analysis` to contextualize the competitive landscape

---

## PROCESS

### Step 1: Define the Market Boundaries

Before sizing, define what you are measuring:

```markdown
## Market Definition

- **Product**: [What you are building]
- **Customer Segment**: [Who pays -- SMBs, Enterprise, Consumers, Developers]
- **Geography**: [Global, US, EU, specific countries]
- **Category**: [Which industry / software category]
- **Time Horizon**: [Current year + 3-5 year projection]
```

### Step 2: Top-Down Analysis (TAM)

Start from the total market and narrow down:

```markdown
## Top-Down: Total Addressable Market (TAM)

### Data Sources
- [Industry report 1: Name, publisher, year]
- [Industry report 2: Name, publisher, year]
- [Government / census data if applicable]

### Calculation
- Global [category] market size: $___B (Source: ___)
- Annual growth rate (CAGR): ___%
- Projected market in [target year]: $___B

### TAM = $___B
```

### Step 3: Bottom-Up Analysis (SAM and SOM)

Build from unit economics upward:

```markdown
## Bottom-Up: Serviceable Addressable Market (SAM)

### Unit Economics
- Target customer count in segment: ___
- Average revenue per customer per year: $___
- Calculation: [customers] x [ARPU] = $___

### Filters Applied
- Geography filter: [reduces TAM by X%]
- Segment filter: [e.g., only SMBs with 10-200 employees]
- Technology filter: [e.g., only companies using cloud infrastructure]

### SAM = $___M

---

## Serviceable Obtainable Market (SOM)

### Realistic Capture Rate
- Year 1 target customers: ___
- Year 1 revenue: $___
- Market share this represents: ___%
- Basis for estimate: [comparable company growth rates, sales capacity]

### SOM = $___M (Year 1)
```

### Step 4: Segment by Product Type

Apply the relevant model:

**B2B SaaS**:
```
TAM = [Total companies in category] x [Average contract value]
SAM = [Companies matching ICP] x [ACV]
SOM = [Realistic Y1 wins] x [ACV]
Key metric: LTV/CAC ratio target > 3x
```

**Consumer**:
```
TAM = [Total potential users] x [ARPU]
SAM = [Reachable users in target geo/demo] x [ARPU]
SOM = [Realistic Y1 active users] x [ARPU]
Key metric: DAU/MAU ratio, viral coefficient
```

**Marketplace**:
```
TAM = [Total transaction volume in category]
SAM = [Transactions addressable by platform] x [Take rate]
SOM = [Realistic Y1 GMV] x [Take rate]
Key metric: Liquidity (supply-demand match rate)
```

**Developer Tools**:
```
TAM = [Total developers in ecosystem] x [Tool spend/dev]
SAM = [Developers in target segment] x [Pricing tier]
SOM = [Realistic Y1 adopters] x [Avg plan price]
Key metric: Developer adoption curve (PLG conversion)
```

### Step 5: Willingness-to-Pay Validation

Do not rely on market size alone -- validate that customers will actually pay:

```markdown
## Willingness-to-Pay (WTP) Analysis

### Method Used
- [ ] Van Westendorp Price Sensitivity Meter
- [ ] Gabor-Granger direct pricing
- [ ] Competitive pricing comparison
- [ ] Customer interview qualitative signals

### Findings
- Price point too cheap (perceived low quality): $___
- Price point acceptable (bargain): $___
- Price point getting expensive: $___
- Price point too expensive (rejection): $___
- **Optimal price range**: $___  to $___

### Revenue Projection
| Year | Customers | ARPU | Revenue | Growth |
|------|-----------|------|---------|--------|
| Y1 | ___ | $___ | $___ | -- |
| Y2 | ___ | $___ | $___ | ___% |
| Y3 | ___ | $___ | $___ | ___% |
```

### Step 6: Sanity Check

Before finalizing, verify your numbers pass basic sanity checks:

- [ ] TAM > SAM > SOM (the funnel narrows, never expands)
- [ ] SOM is achievable with current team size and funding
- [ ] Growth assumptions are comparable to similar-stage companies
- [ ] ARPU assumptions align with WTP validation
- [ ] At least 2 independent data sources corroborate TAM estimate

### Step 7: Produce Market Sizing Document

Save the complete analysis to:

```
.agent/docs/1-brainstorm/market-sizing.md
```

---

## CHECKLIST

- [ ] Market boundaries defined (product, segment, geography, time horizon)
- [ ] Top-down TAM calculated with cited data sources
- [ ] Bottom-up SAM calculated from unit economics
- [ ] SOM estimated with realistic capture rate and basis
- [ ] Product-type-specific model applied
- [ ] Willingness-to-pay validated through at least one method
- [ ] Revenue projections built for Years 1-3
- [ ] Sanity checks passed (TAM > SAM > SOM, achievable SOM)
- [ ] Document saved to `.agent/docs/1-brainstorm/market-sizing.md`
- [ ] Key metrics ready for `go_no_go_gate` evaluation

---

*Skill Version: 1.0 | Phase: 1-Brainstorm | Priority: P1*
