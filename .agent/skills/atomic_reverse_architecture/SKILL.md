---
name: Atomic Reverse Architecture (ARA)
description: Unified methodology combining First Principles decomposition with Reverse Thinking gap detection to design complete project architectures before writing code
---

# Atomic Reverse Architecture (ARA) Skill

**Purpose**: Design complete, gap-free architectures for any project type by merging **First Principles Thinking** (decomposition) with **RT-ICA Reverse Thinking** (completeness checking).

> [!NOTE]
> **Novel Methodology**: ARA unifies two proven approaches into a single structured process. First Principles breaks down to atoms; Reverse Thinking ensures nothing is missing.

---

## 🎯 TRIGGER COMMANDS

Use any of these phrases to activate this skill:

```text
"Design the architecture for a [project type]"
"Create a blueprint for [project]"
"Plan out a [project type] from scratch"
"Using ARA: design [project type]"
"I want to architect a [project type]"
"Blueprint a [trading bot/NFT/AI agent/etc]"
```

---

## 📋 WHEN TO USE

- **Greenfield projects** - Starting something from scratch
- **New project types** - Unfamiliar territory needing systematic analysis
- **Complex systems** - Multiple interacting components
- **Before writing code** - Design first, build second
- **Teaching/documenting** - Explaining how a system should work

---

## 🧬 THE ARA FRAMEWORK

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    ATOMIC REVERSE ARCHITECTURE (ARA)                             │
│                                                                                  │
│                "Decompose to atoms. Reverse to find gaps."                       │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│   ┌─────────────────┐                                                            │
│   │  PHASE 1        │  VISION STATE                                              │
│   │  (Forward)      │  "What does success look like?"                            │
│   └────────┬────────┘                                                            │
│            ▼                                                                     │
│   ┌─────────────────┐                                                            │
│   │  PHASE 2        │  ATOMIC DECOMPOSITION                                      │
│   │  (First Princ.) │  "What are the fundamental atoms?"                         │
│   └────────┬────────┘                                                            │
│            ▼                                                                     │
│   ┌─────────────────┐                                                            │
│   │  PHASE 3        │  REVERSE CONDITION MAPPING                                 │
│   │  (RT-ICA)       │  "What MUST be true for each atom?"                        │
│   └────────┬────────┘                                                            │
│            ▼                                                                     │
│   ┌─────────────────┐                                                            │
│   │  PHASE 4        │  GAP SYNTHESIS                                             │
│   │  (Novel)        │  "What falls BETWEEN the atoms?"                           │
│   └────────┬────────┘                                                            │
│            ▼                                                                     │
│   ┌─────────────────┐                                                            │
│   │  PHASE 5        │  DEPENDENCY ORDERING                                       │
│   │  (Synthesis)    │  "What order must things be built?"                        │
│   └─────────────────┘                                                            │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📝 PHASE 1: VISION STATE

**Question**: "What does SUCCESS look like in the end?"

**Process**:

1. Describe the working system as if it already exists
2. Write from the USER's perspective
3. Include measurable outcomes
4. Be specific about capabilities

**Template**:

```markdown
## Vision State

I have a [PROJECT TYPE] that:
- [Capability 1 - what it does]
- [Capability 2 - what it does]
- [Capability 3 - what it does]

Success metrics:
- [Metric 1]: [target value]
- [Metric 2]: [target value]

User experience:
"When I [action], the system [response]."
```

**Example (Trading Bot)**:

```markdown
## Vision State

I have a trading bot that:
- Runs 24/7 without intervention
- Executes strategies across 3 crypto exchanges
- Never loses more than 2% of portfolio per day
- Sends me alerts on Telegram for significant events

Success metrics:
- Uptime: 99.9%
- Max daily drawdown: 2%
- Alert latency: < 5 seconds

User experience:
"When I wake up, I check Telegram and see overnight performance. I can adjust parameters via a web dashboard without restarting the bot."
```

---

## 📝 PHASE 2: ATOMIC DECOMPOSITION

**Question**: "What are the FUNDAMENTAL atoms of this system?"

**Process**:

1. Break the vision into irreducible components
2. Each atom should be independently understandable
3. Each atom should have a single responsibility
4. Atoms should be technology-agnostic at this stage

**Template**:

```markdown
## Atomic Decomposition

| Atom | Responsibility | Inputs | Outputs |
|------|---------------|--------|---------|
| [Atom 1] | [Single responsibility] | [What it needs] | [What it produces] |
| [Atom 2] | [Single responsibility] | [What it needs] | [What it produces] |
```

**First Principles Questions**:

- "What is the MINIMUM this needs to function?"
- "If I remove this, does the system still make sense?"
- "Can this be split further into independent parts?"

**Example (Trading Bot)**:

```markdown
## Atomic Decomposition

| Atom | Responsibility | Inputs | Outputs |
|------|---------------|--------|---------|
| Data Feed | Receive real-time market data | Exchange APIs | Price/volume streams |
| Signal Engine | Generate buy/sell decisions | Price data, strategy rules | Trade signals |
| Risk Manager | Enforce position/loss limits | Current state, limits | Approve/reject decisions |
| Execution Engine | Place and manage orders | Approved signals | Order confirmations |
| State Manager | Track positions, balance, P&L | Order fills, prices | Current portfolio state |
| Alerter | Notify user of events | System events | Telegram messages |
| Config Manager | Provide settings to all atoms | Config files/DB | Runtime parameters |
```

---

## 📝 PHASE 3: REVERSE CONDITION MAPPING

**Question**: "For each atom, what conditions MUST be true for it to work?"

**Process**:

1. For each atom, assume it's working perfectly
2. Ask: "What had to be true for this to work?"
3. List ALL prerequisites and dependencies
4. Include error states and edge cases

**Template**:

```markdown
## Reverse Condition Mapping

### [Atom Name]

For this atom to function correctly:

**Prerequisites**:
- [ ] [Condition 1 must be true]
- [ ] [Condition 2 must be true]

**Dependencies**:
- Depends on: [Other atoms it needs]
- Depended on by: [Other atoms that need it]

**Error states that MUST be handled**:
- [ ] [Error scenario 1]
- [ ] [Error scenario 2]

**Edge cases**:
- [ ] [Edge case 1]
- [ ] [Edge case 2]
```

**RT-ICA Questions**:

- "If this atom is working, what MUST have already happened?"
- "What could break this atom?"
- "What's the MINIMUM this atom needs to recover from failure?"

**Example (Trading Bot - Execution Engine)**:

```markdown
### Execution Engine

For this atom to function correctly:

**Prerequisites**:
- [ ] Exchange API keys are valid and have trading permissions
- [ ] Network connection to exchange is established
- [ ] Risk Manager has approved the signal
- [ ] Sufficient balance exists for the order

**Dependencies**:
- Depends on: Signal Engine, Risk Manager, State Manager, Data Feed (for prices)
- Depended on by: State Manager (for fill updates), Alerter (for notifications)

**Error states that MUST be handled**:
- [ ] Order rejected by exchange
- [ ] Partial fill scenarios
- [ ] Network timeout during order placement
- [ ] Exchange rate limiting
- [ ] Insufficient balance

**Edge cases**:
- [ ] Order fills at different price than expected (slippage)
- [ ] Multiple orders in flight simultaneously
- [ ] Exchange goes into maintenance mode
- [ ] Order stuck in pending state
```

---

## 📝 PHASE 4: GAP SYNTHESIS

**Question**: "What falls BETWEEN the atoms that we haven't accounted for?"

**Process**:

1. Look for missing "glue" components
2. Check for cross-cutting concerns
3. Identify operational requirements
4. Find security gaps

**Gap Categories**:

| Category | What to Check |
|----------|---------------|
| **Integration** | How do atoms communicate? Message queues? Direct calls? |
| **Error Recovery** | How does the SYSTEM recover, not just individual atoms? |
| **Observability** | Logging, metrics, tracing, debugging |
| **Security** | Auth, secrets, encryption, access control |
| **Configuration** | How are settings managed across atoms? |
| **Testing** | How do you test without production consequences? |
| **Deployment** | How does this run? Local? Cloud? Docker? |
| **Scaling** | What happens when load increases? |
| **Data Persistence** | Where is state stored? How is it backed up? |

**Template**:

```markdown
## Gap Synthesis

| Gap Category | Missing Piece | Why It Matters | Resolution |
|--------------|---------------|----------------|------------|
| [Category] | [What's missing] | [Impact if not addressed] | [How to address] |
```

**Example (Trading Bot)**:

```markdown
## Gap Synthesis

| Gap Category | Missing Piece | Why It Matters | Resolution |
|--------------|---------------|----------------|------------|
| Integration | Message bus between atoms | Atoms need async communication | Add Redis/RabbitMQ |
| Error Recovery | System-wide restart logic | What if everything crashes? | Add supervisor + state recovery |
| Observability | Structured logging | Can't debug production issues | Add centralized logging |
| Security | API key rotation | Keys could be compromised | Add secrets manager |
| Testing | Paper trading mode | Can't test strategies safely | Add simulation exchange |
| Deployment | Container orchestration | How to run reliably | Add Docker + health checks |
| Data Persistence | Trade history database | Need audit trail | Add PostgreSQL + backups |
```

---

## 📝 PHASE 5: DEPENDENCY ORDERING

**Question**: "In what order must things be built?"

**Process**:

1. Map dependencies between atoms
2. Identify foundational layers
3. Create build phases
4. Define milestones

**Template**:

```markdown
## Dependency Ordering

### Dependency Graph

```text
[Visual representation of what depends on what]
```

### Build Phases

| Phase | Components | Milestone |
|-------|------------|-----------|
| 1 | [Foundation components] | [What's achievable] |
| 2 | [Next layer] | [What's achievable] |
| 3 | [Next layer] | [What's achievable] |

### Critical Path

The longest chain of dependencies:
[Component A] → [Component B] → [Component C] → [Final]

```

**Example (Trading Bot)**:

```markdown
## Dependency Ordering

### Dependency Graph

```text
                    ┌─────────────────┐
                    │  Config Manager │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        ▼                    ▼                    ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Data Feed   │    │State Manager │    │   Logging    │
└──────┬───────┘    └──────┬───────┘    └──────────────┘
       │                   │
       ▼                   │
┌──────────────┐           │
│Signal Engine │           │
└──────┬───────┘           │
       │                   │
       ▼                   │
┌──────────────┐           │
│ Risk Manager │◄──────────┘
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Execution   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Alerter    │
└──────────────┘
```

### Build Phases

| Phase | Components | Milestone |
|-------|------------|-----------|
| 0 | Project setup, Docker, logging | Can run and see logs |
| 1 | Config Manager, State Manager | Can store/retrieve state |
| 2 | Data Feed (single exchange) | Can receive live prices |
| 3 | Signal Engine (simple strategy) | Can generate signals |
| 4 | Risk Manager | Can approve/reject signals |
| 5 | Execution Engine (paper trading) | Can simulate trades |
| 6 | Execution Engine (live) | Can execute real trades |
| 7 | Alerter | Can receive notifications |
| 8 | Web Dashboard | Can monitor and control |

### Critical Path

Config → State → Data Feed → Signal → Risk → Execution → Alert

```

---

## 📄 OUTPUT DOCUMENTS

ARA produces these deliverables:

| Document | Location | Content |
|----------|----------|---------|
| Vision Document | `.agent/docs/[project]-vision.md` | Phase 1 output |
| Architecture Document | `.agent/docs/[project]-architecture.md` | Phases 2-4 output |
| Implementation Plan | `.agent/docs/[project]-implementation-plan.md` | Phase 5 output |
| Gap Checklist | `.agent/docs/[project]-gap-checklist.md` | Phase 3-4 checklists |

---

## ✅ ARA QUALITY CHECKLIST

Before considering the architecture complete:

### Phase 1 Validation
- [ ] Vision is specific and measurable
- [ ] Success metrics are defined
- [ ] User experience is described

### Phase 2 Validation
- [ ] Each atom has single responsibility
- [ ] Atoms are technology-agnostic
- [ ] No atom can be split further usefully
- [ ] All atoms together achieve the vision

### Phase 3 Validation
- [ ] Every atom has prerequisites listed
- [ ] Dependencies are mapped
- [ ] Error states are identified
- [ ] Edge cases are documented

### Phase 4 Validation
- [ ] All 9 gap categories checked
- [ ] Missing pieces have resolutions
- [ ] Cross-cutting concerns addressed
- [ ] Security explicitly considered

### Phase 5 Validation
- [ ] Dependency graph is acyclic
- [ ] Build phases are logical
- [ ] Each phase has a milestone
- [ ] Critical path is identified

---

## 🎯 QUICK START

For a quick ARA session, use this prompt:

```text
Using the ARA skill, design the architecture for a [PROJECT TYPE].

Start with Phase 1 (Vision State), then work through all 5 phases.
Output the complete architecture documentation.
```

---

## 📚 THEORETICAL FOUNDATION

ARA synthesizes two established methodologies:

### First Principles Thinking

- Popularized by Elon Musk for engineering problems
- Core idea: Break complex problems into fundamental truths, then rebuild
- Contribution to ARA: Phase 2 (Atomic Decomposition)

### RT-ICA (Reverse Thinking for Information Completeness Assessment)

- Academic research paper: "Reverse Thinking Enhances Missing Information Detection in LLMs"
- Core idea: Work backward from desired outcomes to identify missing prerequisites
- Contribution to ARA: Phase 3 (Reverse Condition Mapping)

### Novel Addition: Gap Synthesis (Phase 4)

- Checks for missing "glue" between atoms
- Systematically covers 9 categories of cross-cutting concerns
- Prevents the "it works in isolation but fails in integration" problem

---

## 💡 TIPS FOR EFFECTIVE ARA

1. **Stay technology-agnostic in Phase 2** - Don't say "PostgreSQL table," say "persistent storage"
2. **Be paranoid in Phase 3** - Every error that CAN happen WILL happen
3. **Don't skip Phase 4** - This is where most projects fail
4. **Make Phase 5 achievable** - Each phase should produce something testable
5. **Iterate** - ARA can be refined as you learn more

---

## 📖 WORKED EXAMPLES

Reference these completed ARA documents for inspiration:

| Project Type | Example File |
|--------------|--------------|
| Trading Bot | See above inline example |
| NFT Collection | (Create with ARA) |
| AI Agent | (Create with ARA) |

---

*"Decompose to atoms. Reverse to find gaps. Build with confidence."*
