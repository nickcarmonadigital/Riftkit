---
name: "ATOM v3 Protocol"
description: "Axiomatic Thinking for Omnidirectional Meta-analysis — A 53-Loop, 51-Method Universal Discovery Engine for Systematic Gap Analysis. v3 includes machine-optimized output format."
triggers:
  - "/atom"
  - "/age"
  - "/gap-analysis"
  - "/adversarial-audit"
  - "/discovery"
---

# ATOM — Axiomatic Thinking for Omnidirectional Meta-analysis

*Named for Atom from Pluto — the AI that transcends its programming to achieve genuine understanding.*

> "I'm a unit tester!" — Ralph Wiggum
>
> Every loop starts stupid. That is the point.
> The protocol does not trust your memory. It does not trust your confidence.
> It trusts only what survives 53 independent attempts to destroy it.

---

## OUTPUT FORMAT — READ THIS FIRST

**This section defines how gaps MUST be formatted. Read it before reading anything else.
All gaps in the final report MUST follow this exact format. No exceptions.**

### Gap Format (use ### h3 headings, exactly three hashes)
```
### GAP-{NNN}: {Title}

**Severity**: Critical | High | Medium | Low
**Component**: {file_name.ext}
**Evidence**: {file.ext}:{line} — "{N} files affected" or "{N} instances found"
**Description**: This is a **{layer}** gap affecting **{attribute}**. {What the gap is}.
  You can {test/verify/reproduce} this by {specific method}. {N} instances across {M} files.
**Impact**: {Quantified} — "affects {N}% of {requests/users/endpoints}"
**Recommendation**: Should {fix/implement/add/remove/resolve} by {specific action}.
  {Implementation detail}. This would resolve {N} instances.
**Discovery Method**: {Loop name that found this gap}
```

### Rules (non-negotiable)
1. Use `### GAP-` headings (three hashes). NOT `##`. NOT `####`.
2. Use `**Severity**: Critical` (simple label). NOT RPN tables. NOT FMEA scores. NOT "SHOWSTOPPER".
3. Every Description MUST contain: a number, test/verify/reproduce, and bold **layer** + **attribute**
4. Every Recommendation MUST contain: fix/implement/add/remove/resolve/should/recommend
5. Every Evidence MUST reference source files with line numbers AND include a count
6. End the report with a MAP-Elites 8×8 coverage matrix (see full details in Gap Report Format section below)
7. Target 25-35 gaps. Severity distribution: ~15% Critical, ~30% High, ~35% Medium, ~20% Low

### MAP-Elites Dimensions (use these exact bold terms in gap descriptions)
**Layers**: **architecture**, **security**, **performance**, **reliability**, **data**, **integration**, **operations**, **user experience**
**Attributes**: **completeness**, **correctness**, **consistency**, **robustness**, **efficiency**, **maintainability**, **testability**, **documentation**

---

## Philosophy

### The Ralph Wiggum Protocol

Every loop in ATOM begins with zero context. The AI forgets everything — every prior
conclusion, every assumption, every intermediate finding. It reads only one thing: the
gap log. This is not a limitation. It is the core design principle.

Why? Because intelligent systems fail in predictable ways. They anchor on early findings.
They confirm their own hypotheses. They build elaborate structures on unverified
foundations. Ralph Wiggum does none of this. He walks into the room fresh every time and
says something that either reveals a new truth or confirms an old one.

### Why 51 Methods from 5 Domains

ATOM draws from five distinct intellectual traditions:

- **AI/ML Research (~29%)**: 15 methods from peer-reviewed papers (NeurIPS, ICML, ICLR,
  ACL, EMNLP). These are the sharpest tools — chain-of-thought variants, self-consistency,
  multi-agent debate, reflexion, and self-play bootstrapping.
- **Philosophical Reasoning (~20%)**: 10 methods rooted in 2,400 years of systematic
  thought — from Aristotle's first principles to Popper's falsification to Pearl's causal
  calculus. These catch the failures that pure computation misses.
- **Engineering Frameworks (~16%)**: 8 methods drawn from systems engineering, quality
  assurance, and industrial design — FMEA, TRIZ, Theory of Constraints, morphological
  analysis. These ensure practical completeness.
- **Universal Operations (~16%)**: 8 methods covering supply chain, error propagation,
  configuration entropy, data lifecycle, graceful degradation, temporal assumptions,
  onboarding, and rollback recovery. These catch operational gaps every system has.
- **Safety, Security & Systems Science (~23%)**: 10 methods from safety engineering
  (STAMP, Swiss Cheese), resilience engineering (Drift Into Failure), organizational theory
  (Normal Accidents), decision theory (Antifragility), complex systems (Emergent Behavior),
  security engineering (STRIDE/Attack Trees), and behavioral economics (Cognitive Bias Audit).
  These catch the failures that exist BETWEEN components, ACROSS time, and INSIDE decisions.

Each method addresses a DIFFERENT failure mode. Self-Discover catches reasoning gaps.
Falsification catches unfounded claims. FMEA catches severity blindness. STAMP catches
control hierarchy breakdowns. Swiss Cheese catches temporal defense alignment. Drift Into
Failure catches incremental boundary migration. No single method covers all failure modes.
Together, they form a near-complete net.

### The "Axiomatic" in ATOM

Everything starts from irreducible truths. Loop 1 is always First Principles Decomposition.
Before any gap hunting, before any verification, the protocol demands: what are the
foundational truths about this system that cannot be decomposed further? Every subsequent
loop builds on — and challenges — these axioms.

### Multi-Method as Insurance

The protocol is deliberately redundant. If method A misses a gap, methods B through Z will
catch it. If a gap survives all 51 methods, it is real. If it does not survive, it was
noise. This is not efficiency — it is thoroughness weaponized.

### Adversarial Verification

Discovery is not enough. Phases 1-2 generate candidate gaps. Phase 3 tries to DESTROY
them. Every gap must survive falsification testing, dialectical debate, causal inference
auditing, step-aware verification, and constitutional rigor checks. Gaps that cannot
survive attack are not real gaps — they are artifacts of the discovery process.

### Self-Improvement

ATOM is not static. Loops 51-53 (Phase 7: EVOLVE) turn the protocol on itself. Reflexion
extracts lessons from the current run. CRITIC evaluates quantitative metrics. Absolute Zero
generates adversarial challenges the protocol failed to anticipate. Each run makes the
next run better.

### Method Composition

The 51 methods are not applied randomly. They follow a deliberate sequence:

1. AXIOMS (Loops 1-4): Establish irreducible foundations
2. HUNT (Loops 5-30): Discover gaps using 26 diverse methods
3. VALIDATE (Loops 31-40): Verify gaps using 10 adversarial methods
4. SOLVE (Loops 41-46): Architect solutions
5. SYNTHESIZE (Loops 47-49): Merge, deduplicate, report
6. CACHE (Loop 50): Extract reusable knowledge
7. EVOLVE (Loops 51-53): Self-improve the protocol

---

## Research Foundations

### Tier 1 — AI/ML Research Methods (15)

| # | Method | Source | What It Does |
|---|--------|--------|--------------|
| 1 | Self-Discover | Zhou et al. (2024), NeurIPS, arXiv:2402.03620 | Auto-select reasoning modules per gap type (32% improvement over CoT) |
| 2 | Step-Back Prompting | Zheng et al. (2023), arXiv:2310.06117 | Abstract to high-level principles BEFORE diving into details |
| 3 | RT-ICA Reverse Thinking | arXiv:2512.10273 (2024) | Work backward from ideal end-state (+27% missing info detection) |
| 4 | Contrastive Chain-of-Thought | Chia et al. (2023), arXiv:2311.09277 | Learn from valid AND invalid examples to reduce false positives |
| 5 | Cumulative Reasoning | Zhang et al. (2023), TMLR, arXiv:2308.04371 | Build DAG of verified propositions; Proposer then Verifier then Reporter |
| 6 | Graph of Thoughts | Besta et al. (2023), AAAI/ICLR 2024, arXiv:2308.09687 | Model gaps as directed graph with dependencies, merges, cycles |
| 7 | Chain of Verification | Dhuliawala et al. (Meta 2023), ACL 2024, arXiv:2309.11495 | Generate independent verification questions (50-70% hallucination reduction) |
| 8 | DiVeRSe Step-Aware Verification | Li et al. (2022), ACL 2023, arXiv:2206.02336 | Verify each STEP in reasoning chain, not just final claim |
| 9 | Multi-Agent Debate | Du et al. (2023), ICML 2024, arXiv:2305.14325 | Parallel instances debate adversarially to improve factual accuracy |
| 10 | Faithful Chain-of-Thought | Lyu et al. (2023), IJCNLP, arXiv:2301.13379 | Symbolic verification — reasoning traces are not post-hoc fabrication |
| 11 | Constitutional Self-Critique | Bai et al. (Anthropic 2022), arXiv:2212.08073 | Principle-based self-evaluation for every claim |
| 12 | Reasoning via Planning (RAP) | Hao et al. (2023), EMNLP, arXiv:2305.14992 | MCTS-guided search over solution space (33% improvement over CoT) |
| 13 | Buffer of Thoughts | Yang et al. (2024), NeurIPS Spotlight, arXiv:2406.04271 | Cache reasoning templates; retrieve and adapt across runs |
| 14 | Reflexion | Shinn et al. (NeurIPS 2023), arXiv:2303.11366 | Verbal RL — learn from previous runs via episodic memory |
| 15 | Absolute Zero | Zhao et al. (NeurIPS 2025), arXiv:2505.03335 | Self-play bootstrapping — self-generate challenges, learn from execution |

### Tier 2 — Philosophical Reasoning Foundations (10)

| # | Method | Source | What It Does |
|---|--------|--------|--------------|
| 16 | First Principles Decomposition | Aristotle, "first basis from which a thing is known" | Decompose to irreducible truths, then rebuild from survivors |
| 17 | Abductive Reasoning | Peirce; arXiv:2307.10250, arXiv:2601.02771 | Inference to best explanation — generate hypotheses for observed gaps |
| 18 | Falsificationism | Popper; arXiv:2502.09858, arXiv:2601.02380 | Every claim must be falsifiable; design experiments to disprove |
| 19 | Dialectical Synthesis | Hegel; arXiv:2501.14917 (Microsoft Research) | Thesis then Antithesis then SYNTHESIS across multiple rounds |
| 20 | Socratic Elenchus | Plato; arXiv:2303.08769 (Chang 2023) | Guided questioning that exposes hidden contradictions |
| 21 | Bayesian Updating | Bayes; Nature Communications 2025, arXiv:2503.17523 | Probabilistic confidence — update priors with evidence |
| 22 | Causal Inference | Pearl's do-calculus; arXiv:2410.16676, NAACL 2025 | Separate correlation from causation using the three rungs |
| 23 | Analogical Transfer | arXiv:2310.01714, ACM CHI 2023 | Cross-domain knowledge transfer — what failed elsewhere |
| 24 | Second-Order Effects | Systems thinking, consequence scanning | Cascade analysis — what happens AFTER the first impact |
| 25 | Emergence Detection | Complexity Journal 2017, BKB framework | System-level properties invisible at component level |

### Tier 3 — Engineering and Systems Frameworks (10)

| # | Method | Source | What It Does |
|---|--------|--------|--------------|
| 26 | Morphological Analysis | Zwicky (1969), General Morphology | Exhaustive dimension grid — enumerate all combinations |
| 27 | Pre-Mortem Projection | Gary Klein (HBR 2007) | Assume failure, then explain why (+30% failure mode discovery) |
| 28 | Negative Space Analysis | Art theory applied to engineering | Find gaps by examining what is structurally ABSENT |
| 29 | TRIZ Contradiction Matrix | Altshuller (2M+ patents analyzed) | Resolve engineering contradictions using inventive principles |
| 30 | FMEA Criticality Scoring | MIL-STD-1629A, ISO 31010 | Risk Priority Number = Severity x Occurrence x Detection |
| 31 | Industry Standards Scan | OWASP, DORA, ISO 27001, NIST, SLSA, CIS | Benchmark against established frameworks and standards |
| 32 | Theory of Constraints | Goldratt (1984), The Goal | Find THE single bottleneck that limits system throughput |
| 33 | MAP-Elites Coverage Grid | Mouret & Clune (2015), Nature | Quality-diversity coverage — ensure all niches are explored |
| 34 | Self-Consistency Decoding | Wang et al. (ICLR 2023), arXiv:2203.11171 | Sample multiple interpretations, majority vote for consensus |
| 35 | CRITIC Tool-Interactive | Gou et al. (2023), arXiv:2305.11738 | External tool validation — verify claims against real data |

---

## Architecture Overview

```
============================================================================
  ATOM PROTOCOL — 53 Loops, 7 Phases, 51 Methods
============================================================================

  PHASE 1: AXIOMS     (Loops 1-4)    -- First Principles Foundation
  PHASE 2: HUNT       (Loops 5-30)   -- Multi-Method Gap Discovery
  PHASE 3: VALIDATE   (Loops 31-40)  -- Adversarial Verification
  PHASE 4: SOLVE      (Loops 41-46)  -- Solution Architecture
  PHASE 5: SYNTHESIZE (Loops 47-49)  -- Merge, Deduplicate, Report
  PHASE 6: CACHE      (Loop 50)      -- Knowledge Extraction
  PHASE 7: EVOLVE     (Loops 51-53)  -- Self-Improvement

============================================================================

  Flow:

  [AXIOMS] --> [HUNT] --> [VALIDATE] --> [SOLVE] --> [SYNTHESIZE]
                                                          |
                                                     [CACHE] --> [EVOLVE]
                                                                    |
                                                          (feeds next run)

============================================================================
```

For each loop:
1. RESET CONTEXT — forget everything, read only the gap log
2. EXECUTE the method assigned to that loop number
3. APPEND findings to `memory/gaps.log`
4. Format: `[Loop N] [Method Name] -> {Finding}`

---

## Phase 1: AXIOMS (Loops 1-4) — First Principles Foundation

The foundation phase. Before hunting for gaps, establish what is irreducibly true
about the target system. Every subsequent loop builds on these axioms.

### Loop 1: First Principles Decomposition (Aristotle)

**Method**: First Principles Decomposition (#16)
**Source**: Aristotle — "the first basis from which a thing is known"
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Ask: "What does 'complete coverage' ACTUALLY mean for this target?"

Execute three steps:

Step 1 — List every assumption. Write down every single thing you are assuming about
the target system. Include assumptions about its purpose, its users, its architecture,
its constraints, its environment, its dependencies, and its failure modes. Be exhaustive.
Aim for 15-30 assumptions.

Step 2 — Challenge each assumption. For every assumption, ask: "Is this actually true,
or am I inheriting this belief from convention, documentation, or habit?" Mark each
assumption as VERIFIED (has evidence), ASSUMED (no evidence but plausible), or
UNFOUNDED (no evidence and possibly wrong).

Step 3 — Rebuild from survivors. Take only the VERIFIED assumptions. These are your
axioms — the irreducible truths. Everything else is a potential gap.

**The SpaceX Analogy**: Elon Musk asked "Why do rockets cost $65M?" and decomposed
to raw materials ($200K). The gap between axiom (materials cost) and reality
(total cost) revealed the actual problem: process overhead, not physics. Apply the
same logic to your target.

**Output**: AXIOM SET — a numbered list of irreducible truths about the target system,
plus a list of challenged assumptions that may represent gaps.

```
[Loop 1] [First Principles] -> AXIOM SET:
  A1: {irreducible truth}
  A2: {irreducible truth}
  ...
  CHALLENGED ASSUMPTIONS:
  C1: {assumption} — Status: ASSUMED/UNFOUNDED — Potential gap: {description}
```

### Loop 2: Step-Back Abstraction (Zheng et al. 2023)

**Method**: Step-Back Prompting (#2)
**Source**: Zheng et al. (2023), arXiv:2310.06117
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Before diving into specifics, step back and abstract to high-level principles.

Ask: "What are the 5 fundamental principles this system embodies?"

For each principle:
1. Name it (e.g., "Separation of Concerns", "Fail-Safe Defaults", "Least Privilege")
2. Explain WHY this principle matters for this specific system
3. Assess whether the system actually follows this principle or merely claims to
4. Identify where violations of this principle would create gaps

The step-back is critical because detail-first analysis misses structural problems.
You cannot see the forest when you are counting bark patterns on individual trees.

**Output**: PRINCIPLE SET — 5 fundamental principles with violation analysis.

```
[Loop 2] [Step-Back Abstraction] -> PRINCIPLE SET:
  P1: {principle} — Adherence: {full/partial/violated} — Gap risk: {description}
  P2: {principle} — Adherence: {full/partial/violated} — Gap risk: {description}
  ...
```

### Loop 3: Self-Discover Module Selection (Zhou et al. 2024)

**Method**: Self-Discover (#1)
**Source**: Zhou et al. (2024), NeurIPS, arXiv:2402.03620
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Auto-select which reasoning modules are most relevant for THIS specific target.

Available modules (select 5-8 most relevant):
- Critical Thinking: evaluate claims, identify biases
- Systems Thinking: understand interconnections and feedback loops
- Causal Reasoning: distinguish cause from correlation
- Adversarial Thinking: think like an attacker or hostile user
- Probabilistic Reasoning: assess likelihoods and uncertainties
- Analogical Reasoning: transfer knowledge from similar domains
- Temporal Reasoning: consider time-dependent behaviors and sequences
- Constraint Analysis: identify limits, boundaries, and edge cases
- Stakeholder Analysis: consider different user perspectives
- Failure Mode Analysis: systematic enumeration of how things break
- Integration Analysis: focus on boundaries between components
- Compliance Analysis: check against standards and regulations

For each selected module:
1. Explain why it is relevant to this target
2. Define what specific gaps it will help find
3. Assign it a priority (primary, secondary, supporting)

**Output**: REASONING BLUEPRINT — the selected modules and their assignments.

```
[Loop 3] [Self-Discover] -> REASONING BLUEPRINT:
  Module 1: {name} — Priority: {primary/secondary/supporting} — Focus: {description}
  Module 2: {name} — Priority: {primary/secondary/supporting} — Focus: {description}
  ...
```

### Loop 4: Morphological Space Enumeration (Zwicky 1969)

**Method**: Morphological Analysis (#26)
**Source**: Zwicky (1969), General Morphology
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Define the dimensions of the analysis space and enumerate all combinations.

Dimension 1 — Layer: What are the architectural layers of the target?
(e.g., UI, API, Business Logic, Data, Infrastructure, External Dependencies)

Dimension 2 — Quality Attribute: What qualities matter?
(e.g., Security, Performance, Reliability, Scalability, Maintainability, Usability,
Observability, Compliance, Cost, Data Integrity)

Dimension 3 — Lifecycle Phase: When do gaps manifest?
(e.g., Design, Build, Test, Deploy, Operate, Decommission)

Dimension 4 — Stakeholder: Who is affected?
(e.g., End User, Developer, Operator, Auditor, Attacker)

Generate the combinatorial grid: Layer x Quality x Lifecycle x Stakeholder.
Flag any cells that are obviously under-explored or completely unaddressed.

**Output**: COVERAGE GRID — the morphological grid with flagged empty cells.

```
[Loop 4] [Morphological Analysis] -> COVERAGE GRID:
  Dimensions: {N} layers x {N} qualities x {N} phases x {N} stakeholders
  Total cells: {N}
  Populated: {N}
  Empty (potential gaps): {N}
  Flagged cells:
    - {Layer} x {Quality} x {Phase} x {Stakeholder}: No coverage
    ...
```

---

## Phase 2: HUNT (Loops 5-16) — Multi-Method Gap Discovery

The discovery phase. Twelve methods from three domains systematically hunt for gaps.
Each method attacks the problem from a different angle, ensuring that gaps missed by
one method are caught by another.

### Loop 5: RT-ICA Reverse Thinking (arXiv:2512.10273)

**Method**: RT-ICA Reverse Thinking (#3)
**Source**: arXiv:2512.10273 (2024), +27% missing information detection
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Work BACKWARD from the ideal end-state.

Step 1: Define the ideal. "If this system were perfect in every way, what would be true?"
Write 10-15 statements about the ideal end-state.

Step 2: Trace backward. For each ideal statement, ask: "For this to be true, what MUST
have happened before it? What preconditions are required?" Chain backward 3-5 steps.

Step 3: Find the breaks. Compare the backward chain to reality. Where does the chain
break? Each break point is a gap.

The power of reverse thinking: forward analysis follows the path the designers intended.
Backward analysis reveals the paths they forgot.

**Output**: 5-10 gaps discovered by tracing backward from the ideal state.

```
[Loop 5] [RT-ICA Reverse Thinking] -> BACKWARD GAPS:
  Ideal: {statement}
  Chain: {ideal} <- {precondition} <- {precondition} <- BREAK: {gap}
  ...
```

### Loop 6: Abductive Hypothesis Generation (Peirce)

**Method**: Abductive Reasoning (#17)
**Source**: Peirce; arXiv:2307.10250, arXiv:2601.02771
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Inference to the best explanation. Look at the existing gap log and the target system.
Generate hypotheses about WHY these gaps exist.

For each existing gap (or cluster of gaps):
1. What is the most likely explanation for this gap's existence?
2. What organizational, technical, or conceptual root cause would produce this gap?
3. If that root cause exists, what OTHER gaps should we expect to find?

Then generate 3-5 NEW hypotheses about gaps that SHOULD exist but have not been found yet,
based on the root causes you identified.

**Output**: Root cause hypotheses and predicted gaps.

```
[Loop 6] [Abductive Reasoning] -> HYPOTHESES:
  H1: Root cause: {explanation} -> Predicts gaps: {gap1, gap2, gap3}
  H2: Root cause: {explanation} -> Predicts gaps: {gap1, gap2}
  ...
```

### Loop 7: Socratic Assumption Excavation (Plato)

**Method**: Socratic Elenchus (#20)
**Source**: Plato; arXiv:2303.08769 (Chang 2023)
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Use guided questioning to expose hidden contradictions. For the target system,
ask the following 5 questions and pursue each to its logical conclusion:

1. "What does this system assume will NEVER happen?" — List 5+ impossibility assumptions.
   For each, ask: "But what if it DID happen?"
2. "What does this system assume will ALWAYS be true?" — List 5+ invariant assumptions.
   For each, ask: "Under what conditions would this stop being true?"
3. "Where does this system trust input it should not trust?" — Trace every trust boundary.
4. "What happens when two correct components interact incorrectly?" — Examine integration
   points for emergent failures.
5. "Who benefits from this system failing, and how would they cause that failure?" —
   Adversarial stakeholder analysis.

Each question that produces a contradiction or reveals an unhandled case is a gap.

**Output**: Contradictions and unhandled cases from Socratic questioning.

```
[Loop 7] [Socratic Elenchus] -> CONTRADICTIONS:
  Q1 (Never happens): {assumption} — BUT: {scenario} -> GAP: {description}
  Q2 (Always true): {invariant} — BREAKS WHEN: {condition} -> GAP: {description}
  ...
```

### Loop 8: Pre-Mortem Projection (Klein 2007)

**Method**: Pre-Mortem Projection (#27)
**Source**: Gary Klein (HBR 2007), +30% failure mode discovery
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Assume the system has catastrophically failed. It is 6 months from now and everything
has gone wrong. Write 5-7 failure narratives:

For each narrative:
1. Describe the failure in concrete, specific terms. What happened? What broke?
2. Explain the chain of events that led to the failure. Be specific about triggers.
3. Identify which gap (existing or new) would have prevented this failure if addressed.
4. Rate the narrative's plausibility: HIGH (has happened in similar systems),
   MEDIUM (plausible but uncommon), LOW (extreme edge case).

Focus on failures that would be embarrassing, costly, or dangerous — not just
inconvenient. The pre-mortem is most powerful when it surfaces failures that nobody
wants to think about.

**Output**: 5-7 failure narratives with associated gaps.

```
[Loop 8] [Pre-Mortem] -> FAILURE NARRATIVES:
  F1: {narrative title} — Plausibility: {HIGH/MEDIUM/LOW}
     Chain: {trigger} -> {event} -> {event} -> {catastrophe}
     Gap: {description}
  ...
```

### Loop 9: Negative Space + Emergence Detection

**Method**: Negative Space Analysis (#28) + Emergence Detection (#25)
**Source**: Art theory applied to engineering; Complexity Journal 2017, BKB framework
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Two complementary analyses in one loop:

Part A — Negative Space: Examine what is ABSENT from the system.
1. What documentation does NOT exist but should?
2. What tests are NOT written but should be?
3. What error handling is NOT implemented but should be?
4. What monitoring is NOT in place but should be?
5. What user workflows are NOT supported but should be?
The absence of something is often more revealing than its presence.

Part B — Emergence Detection: Look for system-level properties that are invisible
at the component level.
1. What behaviors emerge only when components interact?
2. What properties exist at the system level that no single component provides?
3. What failure modes exist only at scale or under load?
4. What security properties depend on the correct composition of individually secure parts?

**Output**: Structural absences and emergent properties.

```
[Loop 9] [Negative Space + Emergence] ->
  ABSENCES: {list of things that should exist but do not}
  EMERGENT PROPERTIES: {list of system-level behaviors not visible at component level}
```

### Loop 10: Contrastive Gap Analysis (Chia et al. 2023)

**Method**: Contrastive Chain-of-Thought (#4)
**Source**: Chia et al. (2023), arXiv:2311.09277
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Learn from both valid AND invalid examples to reduce false positives.

Step 1: Identify 3-5 similar systems or projects that SUCCEEDED. What did they have
that this system might be missing?

Step 2: Identify 3-5 similar systems or projects that FAILED. What gaps did they have
that this system might share?

Step 3: Contrast. For each gap in the current analysis, ask:
- "Would a successful comparable system have this gap?" If yes, maybe it is not a real gap.
- "Did a failed comparable system have this gap?" If yes, it is almost certainly real.

The contrastive approach prevents two failure modes: false positives (flagging non-gaps)
and false negatives (missing real gaps because they seem normal).

**Output**: Contrastive analysis with validated and invalidated gaps.

```
[Loop 10] [Contrastive Analysis] ->
  VALIDATED (present in failed systems): {gap list}
  INVALIDATED (present in successful systems too): {gap list}
  NEW (present in successful systems, absent here): {gap list}
```

### Loop 11: Analogical Transfer (Cross-Domain)

**Method**: Analogical Transfer (#23)
**Source**: arXiv:2310.01714, ACM CHI 2023
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Transfer knowledge from analogous domains to discover gaps invisible from within.

Step 1: Identify 3 domains that face structurally similar challenges to the target.
(e.g., if analyzing a deployment pipeline, consider: supply chain logistics, surgical
procedures, space mission launch sequences)

Step 2: For each analogous domain, ask:
- "What failures are well-known in this domain?"
- "What safety practices are standard in this domain?"
- "What monitoring and verification is considered essential?"

Step 3: Map findings back. For each insight from an analogous domain, ask:
"Does our target system have an equivalent protection? If not, should it?"

**Output**: Cross-domain insights mapped to potential gaps.

```
[Loop 11] [Analogical Transfer] ->
  Domain: {analogous domain}
  Known failure: {description} -> Maps to: {potential gap in target}
  Standard practice: {description} -> Missing from target: {yes/no}
  ...
```

### Loop 12: TRIZ Contradiction Mapping (Altshuller)

**Method**: TRIZ Contradiction Matrix (#29)
**Source**: Altshuller (2M+ patents analyzed)
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Identify engineering contradictions in the target system — places where improving one
quality degrades another.

Step 1: List all quality pairs that are in tension:
(e.g., Security vs. Usability, Performance vs. Reliability, Flexibility vs. Simplicity)

Step 2: For each contradiction, classify it:
- TECHNICAL CONTRADICTION: Improving parameter A degrades parameter B
- PHYSICAL CONTRADICTION: A component must have property X AND property NOT-X

Step 3: For each contradiction, apply TRIZ inventive principles (see Quick Reference):
- What principle resolves this contradiction?
- Has this contradiction been resolved in the current system?
- If not, the unresolved contradiction is a gap.

**Output**: Contradictions and their resolution status.

```
[Loop 12] [TRIZ Contradiction] ->
  TC1: {param A} vs {param B} — Resolved: {yes/no} — Principle: {TRIZ principle}
  PC1: {component} must be {X} AND {not-X} — Resolved: {yes/no}
  ...
```

### Loop 13: Industry Standards Scan

**Method**: Industry Standards Scan (#31)
**Source**: OWASP, DORA, ISO 27001, NIST CSF, SLSA, CIS Benchmarks
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Benchmark the target against relevant industry standards and frameworks.

For each applicable standard:
1. List the relevant requirements or controls
2. Assess the target's compliance: COMPLIANT, PARTIAL, NON-COMPLIANT, NOT APPLICABLE
3. For PARTIAL and NON-COMPLIANT items, document the specific gap

Standards to consider (select those relevant to the target):
- OWASP Top 10 / ASVS (web security)
- DORA metrics (deployment frequency, lead time, MTTR, change failure rate)
- ISO 27001 (information security management)
- NIST Cybersecurity Framework (identify, protect, detect, respond, recover)
- SLSA (supply chain levels for software artifacts)
- CIS Benchmarks (system hardening)
- SOC 2 Trust Principles (security, availability, processing integrity, confidentiality, privacy)
- WCAG (accessibility)
- GDPR/CCPA (data privacy)

**Output**: Standards compliance gaps.

```
[Loop 13] [Industry Standards] ->
  Standard: {name}
  Control: {ID} {description} — Status: {COMPLIANT/PARTIAL/NON-COMPLIANT}
  Gap: {description of what is missing}
  ...
```

### Loop 14: Failure Mode Enumeration + Handoff Analysis

**Method**: FMEA Criticality Scoring (#30) — discovery phase (scoring in Loop 17)
**Source**: MIL-STD-1629A, ISO 31010
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Systematically enumerate every way the target system can fail. Focus especially on
HANDOFF points — the boundaries between components, teams, or processes.

Part A — Failure Modes:
For each component or subsystem, list:
1. What can go wrong? (failure mode)
2. What is the effect? (local effect, system effect, end-user effect)
3. What is the current detection mechanism? (how would you know?)

Part B — Handoff Analysis:
For each boundary between components:
1. What data crosses this boundary?
2. What assumptions does the receiver make about the sender's output?
3. What happens when those assumptions are violated?
4. Is there a contract (API spec, schema, protocol) or is it implicit?

Every implicit handoff is a potential gap.

**Output**: Failure modes and handoff gaps.

```
[Loop 14] [Failure Modes + Handoffs] ->
  FAILURE MODES:
    FM1: Component: {name} — Mode: {description} — Effect: {description} — Detection: {mechanism}
  HANDOFF GAPS:
    HG1: Boundary: {A -> B} — Assumption: {description} — Contract: {explicit/implicit} — Gap: {description}
  ...
```

### Loop 15: Second-Order Cascade Analysis (Systems Thinking)

**Method**: Second-Order Effects (#24)
**Source**: Systems thinking, consequence scanning
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

For every gap found so far, trace the cascade of consequences to at least 3 orders.

For each significant gap in the gap log:

First-order effect: What happens immediately when this gap is exploited or manifests?
Second-order effect: What happens as a consequence of the first-order effect?
Third-order effect: What happens as a consequence of the second-order effect?
Fourth-order effect (if applicable): Continue the chain.

Look for:
- Amplification: Does the impact grow at each order?
- Convergence: Do multiple gaps cascade into the same failure?
- Feedback loops: Does a later-order effect worsen the original gap?
- Hidden dependencies: Does a gap in component A cascade to component B in non-obvious ways?

**Output**: Cascade chains for the most significant gaps.

```
[Loop 15] [Second-Order Cascade] ->
  Gap: {description}
    1st order: {effect}
    2nd order: {effect}
    3rd order: {effect}
    Amplification: {yes/no} — Convergence with: {other gaps} — Feedback loop: {yes/no}
  ...
```

### Loop 16: STAMP/STPA Control Structure Analysis (Leveson)

**Method**: STAMP/STPA — Systems-Theoretic Process Analysis (#36)
**Source**: Leveson, N. (MIT). "Engineering a Safer World" (2011). Used by NASA, FAA, JAXA.
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

FMEA finds component failures. STAMP finds system-level control breakdowns — a
fundamentally different failure class. Treat safety and correctness as CONTROL
problems, not reliability problems.

Step 1 — MAP CONTROL STRUCTURE: Draw the control hierarchy of the target system.
  - Who/what controls whom/what?
  - What are the control actions? (commands, configs, permissions, API calls)
  - What are the feedback channels? (logs, metrics, alerts, return values)
  - List every controller-controlled process pair.

Step 2 — IDENTIFY CONTROL CONSTRAINTS: For each control action, what constraint
must hold for the system to behave correctly?
  - "Controller X must not issue action A when condition B is true"
  - "Controller X must issue action A within T seconds of event E"
  - "Controller X must receive feedback F before issuing action A again"

Step 3 — FIND UNSAFE CONTROL ACTIONS (UCAs): For each constraint, enumerate
the four types of unsafe control action:
  - NOT PROVIDED: Control action required but not given
  - PROVIDED INCORRECTLY: Control action given but wrong parameters/timing
  - TOO EARLY / TOO LATE: Correct action but wrong timing
  - STOPPED TOO SOON / APPLIED TOO LONG: Correct action but wrong duration

Step 4 — TRACE CAUSAL SCENARIOS: For each UCA, trace WHY it could happen:
  - Flawed control algorithm?
  - Incorrect process model (controller believes X but reality is Y)?
  - Missing or delayed feedback?

**Output**: Control structure gaps that FMEA cannot find.

```
[Loop 16] [STAMP/STPA] -> CONTROL GAPS:
  Controller: {name} -> Controlled: {name}
  Constraint: {description}
  UCA: {type} — {description}
  Causal scenario: {why this could happen}
  Gap: {description}
```

### Loop 17: Swiss Cheese Temporal Defense Analysis (Reason)

**Method**: Swiss Cheese Model + Temporal Analysis (#37)
**Source**: Reason, J. "Human Error" (1990). "Managing the Risks of Organizational Accidents" (1997).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Every system has multiple defense layers. Each layer has holes. Failure occurs when
holes in ALL layers align simultaneously. This loop finds alignment conditions that
point-in-time analysis misses.

Step 1 — LIST DEFENSE LAYERS: Enumerate every defense layer (6-12 layers):
  - Code-level: type checking, input validation, error handling, assertions
  - Testing: unit tests, integration tests, E2E tests, load tests
  - Review: code review, security review, architecture review
  - Deployment: staged rollout, canary deploys, rollback capability
  - Runtime: monitoring, alerting, circuit breakers, rate limiting
  - Organizational: runbooks, incident response, on-call rotation

Step 2 — ENUMERATE HOLES PER LAYER: For each defense layer, list its known
weaknesses. Be specific:
  - "Input validation does not check for Unicode normalization attacks"
  - "Integration tests do not cover the payment -> notification flow"

Step 3 — MODEL ALIGNMENT PROBABILITY: Which holes could align simultaneously?
  - Which holes are in the SAME failure path?
  - Which holes are CORRELATED? (same developer wrote code AND test)
  - Which holes are TIME-DEPENDENT? (only during deploy window or peak load)

Step 4 — IDENTIFY DENSEST ALIGNMENT PATHS: Which failure paths pass through
the most holes? These are the highest-risk scenarios.

**Output**: Defense layer holes and their alignment risk.

```
[Loop 17] [Swiss Cheese] -> DEFENSE ANALYSIS:
  Layer: {name} — Holes: {list}
  ALIGNMENT PATHS (highest risk):
    Path 1: {Layer A hole} + {Layer B hole} + {Layer C hole} = {failure scenario}
    Correlation: {why these holes might align}
```

### Loop 18: Drift Into Failure Trajectory Detection (Dekker)

**Method**: Drift Into Failure (#38)
**Source**: Dekker, S. "Drift into Failure" (2011).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Systems rarely fail suddenly. They drift incrementally under normal operational
pressure. Each small deviation seems reasonable in isolation. Over time, the
operating envelope migrates toward the boundary of safe operation.

Step 1 — IDENTIFY SPEC BOUNDARIES: What are the documented limits, standards,
or design constraints? (10-15 boundaries)
  - Performance budgets, SLA thresholds, resource limits
  - Security policies, compliance requirements
  - Architectural principles, coding standards

Step 2 — DETECT BOUNDARY MIGRATION: For each boundary:
  - Has this boundary been quietly moved, relaxed, or ignored?
  - Are there "temporary" exceptions that became permanent?
  - Has "it works fine" replaced "it meets the spec"?
  - Are workarounds being treated as solutions?

Step 3 — MODEL PRESSURE FUNCTIONS: What pressures drive the drift?
  - Schedule pressure ("ship it, we'll fix it later")
  - Resource pressure ("we can't afford to do it right")
  - Complexity pressure ("nobody fully understands this anymore")
  - Success pressure ("it hasn't failed yet, so it must be fine")

Step 4 — PREDICT TRAJECTORY: If current drift continues, when does the system
cross a critical boundary? What will the trigger event look like?

**Output**: Drift trajectories and predicted boundary crossings.

```
[Loop 18] [Drift Into Failure] -> DRIFT TRAJECTORIES:
  Boundary: {spec/standard/limit}
  Drift direction: {toward/away from boundary}
  Pressure: {what drives the drift}
  Gap: {description of the emerging risk}
```

### Loop 19: Normal Accidents Coupling Analysis (Perrow)

**Method**: Normal Accidents Theory (#39)
**Source**: Perrow, C. "Normal Accidents: Living with High-Risk Technologies" (1984).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Systems with BOTH tight coupling AND interactive complexity will inevitably produce
unpredictable failures. No amount of analysis can predict every failure mode.
The only solution is to reduce coupling or complexity.

Step 1 — SCORE TIGHT COUPLING (1-5):
  - Time-dependent processes (delays cause failures): +1
  - Invariant sequences (steps must happen in exact order): +1
  - Single path to goal (no alternative methods): +1
  - Little slack (buffers, redundancy, or spare resources): +1
  - Limited substitutions (components not interchangeable): +1

Step 2 — SCORE INTERACTIVE COMPLEXITY (1-5):
  - Components serve multiple functions: +1
  - Non-linear feedback loops: +1
  - Indirect information sources (inferred, not direct): +1
  - Limited understanding of some processes: +1
  - Unexpected interactions between components: +1

Step 3 — CLASSIFY:
  - Both < 3: SAFE
  - One >= 3, other < 3: MANAGEABLE
  - Both >= 3: NORMAL ACCIDENT ZONE — inevitable failures

Step 4 — FOR NORMAL ACCIDENT ZONES: Recommend DECOUPLE, SIMPLIFY, or ACCEPT.

**Output**: Coupling/complexity scores and inevitable failure zones.

```
[Loop 19] [Normal Accidents] -> COUPLING ANALYSIS:
  System/Subsystem: {name}
  Tight Coupling: {1-5} — Interactive Complexity: {1-5}
  Classification: {SAFE / MANAGEABLE / NORMAL ACCIDENT ZONE}
  Recommendation: {DECOUPLE / SIMPLIFY / ACCEPT}
```

### Loop 20: Antifragility Assessment (Taleb)

**Method**: Antifragility Analysis (#40)
**Source**: Taleb, N.N. "Antifragile: Things That Gain from Disorder" (2012).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Most analysis asks "what breaks?" Antifragility asks: "Does stress make this
component BETTER or WORSE?" Fragile things break. Robust things resist.
Antifragile things IMPROVE.

Step 1 — CLASSIFY EACH MAJOR COMPONENT:
  For each component, ask:
  - Load 10x? (FRAGILE: breaks. ROBUST: handles. ANTIFRAGILE: auto-scales)
  - Error occurs? (FRAGILE: cascades. ROBUST: contains. ANTIFRAGILE: learns)
  - Requirements change? (FRAGILE: rewrite. ROBUST: config. ANTIFRAGILE: adapts)
  - Dependency fails? (FRAGILE: fails too. ROBUST: degrades. ANTIFRAGILE: routes around)

Step 2 — IDENTIFY HIDDEN FRAGILITY:
  - "Works fine until..." scenarios (threshold fragility)
  - Components with no exposure to small stresses (untested resilience)
  - Optimized systems (optimization removes slack, creating fragility)
  - Single points of failure masked by current low load

Step 3 — FIND MISSING OPTIONALITY:
  - Locked into one vendor, architecture, or deployment strategy?
  - Where could asymmetric payoffs be designed? (small downside, large upside)

Step 4 — BARBELL STRATEGY: For fragile components:
  - SAFE SIDE: conservative baseline (simple, proven, redundant)
  - RISK SIDE: small speculative bets (experiments, canary features)
  - NOTHING IN THE MIDDLE: avoid "medium risk"

**Output**: Fragility map and antifragility recommendations.

```
[Loop 20] [Antifragility] -> FRAGILITY MAP:
  Component: {name}
  Classification: {FRAGILE / ROBUST / ANTIFRAGILE}
  Hidden fragility: {description or NONE}
  Missing optionality: {description or NONE}
  Gap: {description}
```

### Loop 21: Emergent Behavior Deep Analysis (Complex Systems)

**Method**: Emergent Behavior Detection — Full Depth (#41)
**Source**: Holland, J. "Emergence" (1998). Bar-Yam, Y. "Dynamics of Complex Systems" (1997).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Emergence means correctly-functioning components producing system-level behaviors
that no individual component was designed to produce. Every component works as
specified. The failure exists ONLY in their interaction.

Step 1 — MAP COMPONENT INTERACTION GRAPH:
  - List every component and its direct interactions
  - Identify bidirectional interactions (feedback loops)
  - Identify non-linear interactions (output not proportional to input)

Step 2 — IDENTIFY FEEDBACK LOOPS:
  - Is it POSITIVE (amplifying) or NEGATIVE (stabilizing)?
  - What is the loop gain and delay?
  - Positive feedback with delay = oscillation risk
  - Positive feedback without delay = runaway risk

Step 3 — FIND NON-LINEAR AMPLIFICATION POINTS:
  - Threshold effects: "Works fine until X, then catastrophic"
  - Resonance effects: normal frequencies combine destructively
  - Phase transitions: gradual change suddenly produces qualitative shift

Step 4 — TEST EMERGENT SCENARIOS:
  Construct scenarios where NO component is malfunctioning:
  - "A sends normal message to B while C is under load. B slows. A retries.
    C's load increases from A's retries. B slows further. Cascade."

Step 5 — SCALE ANALYSIS:
  - What happens at 10x load / data / users?
  - What new interactions emerge at scale?

**Output**: Emergent behaviors and triggering conditions.

```
[Loop 21] [Emergent Behavior] -> EMERGENCE MAP:
  Feedback loop: {components} — Type: {positive/negative} — Gain: {high/med/low}
  Non-linear point: {component} — Threshold: {condition} — Effect: {description}
  Emergent scenario: {narrative of correct components producing failure}
  Gap: {description}
```

### Loop 22: Dependency Supply Chain Audit

**Method**: Supply Chain Risk Analysis (#44)
**Source**: SLSA Framework (Google), OpenSSF Scorecard, xz-utils/Log4Shell post-mortems.
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Every system stands on a tower of dependencies. What happens when one brick is
pulled? Not just "does it compile" — what happens when a dependency is compromised,
abandoned, relicensed, or silently changed?

Step 1 — MAP DEPENDENCY TREE: List all direct dependencies. For each, note:
  - Last update date (stale if >12 months)
  - Maintainer count (risky if single maintainer)
  - License type (copyleft contamination risk)
  - Transitive depth (how many layers deep)

Step 2 — SINGLE POINTS OF FAILURE: Which dependencies have no alternative?
Which are so deeply embedded that replacing them would require a rewrite?

Step 3 — ATTACK SURFACE: Could a dependency update introduce malicious code?
  - Are updates pinned to exact versions or floating?
  - Is there integrity verification (checksums, signing)?
  - Are pre/post-install scripts reviewed?

Step 4 — ABANDONMENT RISK: Which dependencies show signs of abandonment?
  - No commits in 12+ months
  - Unresolved critical issues
  - Maintainer burnout signals

**Output**: Supply chain risks.

```
[Loop 22] [Supply Chain] ->
  Dependency: {name} — Last update: {date} — Maintainers: {N}
  Risk: {abandonment/compromise/license/depth}
  Gap: {description}
```

### Loop 23: Error Propagation & Recovery Path Analysis

**Method**: Error Path Tracing (#45)
**Source**: Resilience Engineering principles. Allspaw, J. "Fault Injection in Production" (2012).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Trace every error from origin to user-facing output. Does the user see a useful
message or a cryptic stack trace? Does the system RECOVER or stay broken?

Step 1 — MAP ERROR ORIGINS: List every place errors can originate:
  - External API failures, database errors, validation failures
  - Timeout, OOM, permission denied, file not found
  - Business logic violations, invalid state transitions

Step 2 — TRACE PROPAGATION: For each error origin, trace the path:
  - Is the error caught? Where?
  - Is it transformed (wrapped, enriched, or stripped)?
  - Does it reach the user? In what form?
  - Is it logged? With enough context to debug?

Step 3 — FIND DEAD ENDS: Errors that are:
  - Swallowed silently (catch-all with no action)
  - Logged but not acted upon
  - Transformed into generic messages losing all diagnostic value
  - Causing partial state (half the operation completed, other half didn't)

Step 4 — RECOVERY PATHS: After an error, does the system:
  - Retry? (with backoff? with limit?)
  - Degrade gracefully? (some features still work?)
  - Require manual intervention? (restart, data fix?)
  - Self-heal? (automatic recovery without human action)

**Output**: Error propagation gaps and missing recovery paths.

```
[Loop 23] [Error Propagation] ->
  Error origin: {source}
  Propagation: {path through system}
  User sees: {message or behavior}
  Recovery: {automatic/manual/none}
  Gap: {description}
```

### Loop 24: Configuration Entropy Analysis

**Method**: Configuration Space Analysis (#46)
**Source**: Xu, T. et al. "Do Not Blame Users for Misconfigurations" (SOSP 2013). Yin, Z. et al. "An Empirical Study on Configuration Errors" (SOSP 2011).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

How many configuration knobs exist? How many combinations are possible? How many
have been tested? Configuration is the #1 source of production outages.

Step 1 — ENUMERATE CONFIG SURFACE: List every configurable parameter:
  - Environment variables, config files, feature flags
  - Command-line args, database settings, API keys
  - Runtime-adjustable vs. deploy-time vs. build-time

Step 2 — DEFAULT ANALYSIS: For each parameter:
  - Is the default safe for production? (or only for dev?)
  - Is the default documented?
  - What happens if the parameter is MISSING entirely?

Step 3 — COMBINATION RISK: Which config combinations are:
  - Untested? (no test covers this combo)
  - Contradictory? (setting A=true and B=true is invalid but not prevented)
  - Environment-specific? (works in dev, fails in prod)

Step 4 — DRIFT DETECTION: How do configs differ between environments?
  - Is there a single source of truth?
  - Can config changes be audited? (who changed what, when?)
  - Are secrets mixed with non-secrets?

**Output**: Configuration risks and untested combinations.

```
[Loop 24] [Config Entropy] ->
  Parameter: {name} — Default: {value} — Production-safe: {yes/no}
  Missing behavior: {what happens}
  Untested combos: {list}
  Gap: {description}
```

### Loop 25: Data Lifecycle & Retention Audit

**Method**: Data Lifecycle Analysis (#47)
**Source**: GDPR Art. 5(1)(e) storage limitation. NIST SP 800-188 De-Identification. CCPA §1798.105.
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Data enters the system. When does it leave? Does it ever? Is there PII sitting
in logs from 3 years ago?

Step 1 — MAP DATA FLOWS: For each data type in the system:
  - Where does it enter? (user input, API, import, scrape)
  - Where is it stored? (database, cache, logs, temp files, message queues)
  - Where does it exit? (API response, export, logs, analytics)

Step 2 — RETENTION ANALYSIS: For each storage location:
  - Is there a retention policy? (explicit or implicit?)
  - Is data ever deleted? Automatically or manually?
  - Does deletion cascade? (deleting a user deletes their data?)
  - Is "deleted" data actually gone? (soft delete, backups, replicas)

Step 3 — PII AUDIT: Where does personally identifiable information live?
  - Logs (often contain emails, IPs, names in error messages)
  - Caches (session data, user preferences)
  - Analytics (tracking data, user behavior)
  - Temp files (uploads, processing intermediaries)

Step 4 — GROWTH PROJECTION: At current ingestion rate:
  - When does storage capacity become a problem?
  - What is the cost trajectory?
  - Are there unbounded collections growing without limit?

**Output**: Data lifecycle gaps and PII exposure.

```
[Loop 25] [Data Lifecycle] ->
  Data type: {name} — Entry: {source} — Storage: {location}
  Retention: {policy or NONE} — Deletion: {method or NEVER}
  PII exposure: {yes/no — where}
  Gap: {description}
```

### Loop 26: Graceful Degradation Mapping

**Method**: Degradation Mode Analysis (#48)
**Source**: Netflix Hystrix patterns. Nygard, M. "Release It!" (2007, 2018). Circuit breaker pattern (Fowler).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

When component X fails, what STILL works? Most systems are all-or-nothing.
Graceful degradation means the system gets worse, not dead.

Step 1 — LIST DEPENDENCIES: For each feature, list what it depends on:
  - Required dependencies (feature cannot work without)
  - Optional dependencies (feature is degraded but functional without)
  - Unknown (nobody documented whether it's required or optional)

Step 2 — FAILURE SIMULATION: For each dependency, ask:
  - If this is DOWN, what happens to the user?
  - If this is SLOW (10x latency), what happens?
  - If this returns WRONG DATA, what happens?
  - Is there a fallback? (cache, default, alternative service)

Step 3 — CIRCUIT BREAKER INVENTORY:
  - Which external calls have circuit breakers?
  - Which have timeouts?
  - Which have retry logic? (with backoff?)
  - Which have NONE of the above? (these will cascade)

Step 4 — DEGRADATION DESIGN: For each dependency without graceful degradation:
  - What should the degraded experience look like?
  - What's the minimum viable feature set without this dependency?

**Output**: Degradation gaps and missing fallbacks.

```
[Loop 26] [Graceful Degradation] ->
  Feature: {name} — Dependency: {name}
  If down: {behavior} — If slow: {behavior} — If wrong: {behavior}
  Circuit breaker: {yes/no} — Timeout: {yes/no} — Fallback: {yes/no}
  Gap: {description}
```

### Loop 27: Time & Temporal Assumption Audit

**Method**: Temporal Correctness Analysis (#49)
**Source**: Falsehoods Programmers Believe About Time (Zaitsev). Lamport, L. "Time, Clocks, and the Ordering of Events" (1978).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

What assumptions does the system make about time? Every one of them is probably
wrong in some edge case.

Step 1 — FIND TIME ASSUMPTIONS: Search for every time-related operation:
  - Timeouts, TTLs, expiration checks, scheduling, cron
  - Timestamp comparisons, duration calculations
  - "Before", "after", "within", "expires in"

Step 2 — CHALLENGE EACH ASSUMPTION:
  - What if the clock jumps forward? (NTP correction, VM migration)
  - What if the clock jumps backward? (leap second, DST, NTP)
  - What if two clocks disagree? (distributed system, client vs server)
  - What if an operation takes 100x longer than expected?
  - What if a scheduled task fires twice? (cron overlap)

Step 3 — TIMEZONE AUDIT:
  - Where are timestamps stored? (UTC or local?)
  - Where are they displayed? (converted correctly?)
  - Where are they compared? (same timezone?)
  - What happens during DST transitions?

Step 4 — ORDERING ASSUMPTIONS:
  - Does the system assume events arrive in order?
  - What happens with out-of-order events?
  - Are there race conditions around "check time then act"?

**Output**: Temporal assumption gaps.

```
[Loop 27] [Temporal Audit] ->
  Assumption: {what the code assumes about time}
  Location: {file:line}
  Failure scenario: {when this assumption breaks}
  Gap: {description}
```

### Loop 28: Onboarding & First-Run Experience Audit

**Method**: First-Run Walkthrough (#50)
**Source**: Nielsen, J. "Usability Engineering" (1993). Cognitive Walkthrough methodology.
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

What happens when someone uses the system for the FIRST time with ZERO context?
The first-run experience reveals every implicit assumption.

Step 1 — SIMULATE FIRST RUN: Walk through setup as a new user:
  - What prerequisites are needed? (documented or assumed?)
  - What error messages appear with default/empty config?
  - What's the first thing that breaks?

Step 2 — PREREQUISITE AUDIT:
  - Are all required env vars documented?
  - Are all required services/tools listed?
  - Are versions specified? (or just "install Node"?)
  - What if a prerequisite is the wrong version?

Step 3 — ERROR MESSAGE QUALITY:
  - When something is missing, does the error say WHAT is missing?
  - Does it say HOW to fix it?
  - Or does it show a stack trace / cryptic error code?

Step 4 — DOCUMENTATION GAPS:
  - Is there a getting-started guide?
  - Does it match the current code? (or is it stale?)
  - Are there undocumented steps that "everyone knows"?

**Output**: First-run experience gaps.

```
[Loop 28] [First-Run Audit] ->
  Step: {what the new user tries}
  Result: {what actually happens}
  Error quality: {helpful / cryptic / silent}
  Gap: {description}
```

### Loop 29: Rollback & Recovery Completeness

**Method**: Rollback Path Analysis (#51)
**Source**: Allspaw, J. "Web Operations" (2010). Google SRE Book Ch. 8.
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

If you deploy a bad version, can you roll back? COMPLETELY? Including data changes?

Step 1 — DEPLOYMENT INVENTORY: What changes during a deploy?
  - Code (binary, container image, script)
  - Database (schema migrations, data migrations)
  - Configuration (env vars, feature flags)
  - Infrastructure (new services, removed endpoints)
  - External state (third-party webhooks, DNS, CDN)

Step 2 — REVERSIBILITY CHECK: For each change type:
  - Is it reversible? (can you undo it?)
  - Is reversal automatic? (rollback script, blue-green)
  - Does reversal preserve data? (or is data lost?)
  - How long does reversal take?

Step 3 — IRREVERSIBLE OPERATIONS: Identify:
  - Destructive database migrations (DROP TABLE, column removal)
  - External notifications (emails sent, webhooks fired)
  - Financial transactions (charges processed)
  - Data transformations (original data overwritten)

Step 4 — RECOVERY TIME: If the worst happens:
  - What is the actual recovery time? (not the SLA — the real one)
  - What manual steps are required?
  - Who needs to be involved? (single person? entire team?)
  - What data is lost during recovery?

**Output**: Rollback gaps and irreversible operations.

```
[Loop 29] [Rollback Analysis] ->
  Change type: {code/database/config/infrastructure/external}
  Reversible: {yes/no/partial}
  Data preserved: {yes/no}
  Recovery time: {estimate}
  Gap: {description}
```

### Loop 30: Cumulative Evidence Assembly + Bayesian Updating

**Method**: Cumulative Reasoning (#5) + Bayesian Updating (#21)
**Source**: Zhang et al. (2023), TMLR, arXiv:2308.04371; Bayes; Nature Comms 2025
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

This is the final HUNT loop. Assemble all evidence from Loops 1-21 into a cumulative
evidence graph using the Proposer-Verifier-Reporter pattern with Bayesian updating.

Step 1 — PROPOSER: Review the entire gap log. Propose a consolidated list of all
unique gaps found across all previous loops. For each gap, list every loop that
independently discovered it (convergent evidence).

Step 2 — VERIFIER: For each proposed gap, assess the evidence:
- How many independent loops found this gap? (convergence count)
- What is the prior probability this is a real gap? Start at P=0.5 (maximum uncertainty).
- Update with each piece of evidence using Bayesian reasoning:
  - Independent discovery by a second method: P increases
  - Contradicted by another method: P decreases
  - Supported by standards scan: P increases
  - Supported by analogical evidence: P increases slightly
- Assign a posterior probability P(real) to each gap.

Step 3 — REPORTER: Generate the active learning list. What are the gaps with
P(real) between 0.3 and 0.7? These are the uncertain ones that need the most
attention in Phase 3 (VALIDATE).

**Output**: Cumulative evidence summary with Bayesian confidence scores.

```
[Loop 22] [Cumulative Evidence + Bayesian] ->
  CONSOLIDATED GAPS:
    G1: {description} — Found by: Loops {N, N, N} — P(real): {0.XX}
    G2: {description} — Found by: Loops {N, N} — P(real): {0.XX}
  UNCERTAIN (needs validation): {list of gaps with 0.3 < P < 0.7}
  HIGH CONFIDENCE (P > 0.7): {list}
  LOW CONFIDENCE (P < 0.3): {list — consider dropping}
```

---

## Phase 3: VALIDATE (Loops 31-40) — Adversarial Verification

Discovery is the easy part. Validation separates real gaps from noise. Eight adversarial
methods systematically attack every gap found in Phase 2. Gaps that survive are real.
Gaps that do not survive are discarded.

### Loop 31: FMEA Criticality Scoring

**Method**: FMEA Criticality Scoring (#30)
**Source**: MIL-STD-1629A, ISO 31010
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Assign a simple severity label to every gap. Do NOT use RPN tables or numeric scores
in the output — use the labels from the Gap Report Format section:
**Critical**, **High**, **Medium**, or **Low**.

Consider three factors when assigning severity:
- Impact: How bad is it if this gap manifests?
- Likelihood: How likely is it to actually happen?
- Detectability: How hard is it to catch before it causes harm?

When in doubt, rate ONE LEVEL HIGHER than your instinct. See the "Severity Calibration"
section in the Gap Report Format for domain-specific guidance.

**Output**: Severity assignments for all gaps using simple labels.

```
[Loop 31] [Severity Scoring] ->
  GAP-001: {title} — Severity: {Critical/High/Medium/Low} — Rationale: {1 sentence}
  GAP-002: {title} — Severity: {Critical/High/Medium/Low} — Rationale: {1 sentence}
  ...
```

### Loop 32: Chain of Verification (Meta 2023)

**Method**: Chain of Verification (#7)
**Source**: Dhuliawala et al. (Meta 2023), ACL 2024, arXiv:2309.11495
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

For each gap rated High or Critical, generate 3 independent verification questions. These
questions must be answerable WITHOUT reference to the original gap analysis — they
must stand on their own.

For each gap:
1. Verification Question 1: A factual question that, if answered NO, would disprove the gap.
2. Verification Question 2: A question about evidence — "What concrete evidence exists
   that this gap is real?"
3. Verification Question 3: A counterfactual — "What would the system look like if this
   gap did NOT exist?"

Answer each question independently. If 2 of 3 answers support the gap, it survives.
If fewer than 2 support it, downgrade its priority by one level.

This method reduces hallucinated gaps by 50-70%.

**Output**: Verification results for each high-priority gap.

```
[Loop 32] [Chain of Verification] ->
  Gap: {description}
    VQ1: {question} — Answer: {yes/no} — Supports gap: {yes/no}
    VQ2: {question} — Answer: {evidence} — Supports gap: {yes/no}
    VQ3: {question} — Answer: {description} — Supports gap: {yes/no}
    Verdict: {SURVIVES / DOWNGRADED}
  ...
```

### Loop 33: DiVeRSe Step-Aware Verification (Li et al. 2022)

**Method**: DiVeRSe Step-Aware Verification (#8)
**Source**: Li et al. (2022), ACL 2023, arXiv:2206.02336
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

For each high-priority gap, verify each STEP in the reasoning chain that identified it.

For each gap:
1. Reconstruct the reasoning chain that led to this gap being identified. Break it into
   3-5 discrete steps.
2. For each step, ask: "Is this step logically valid? Does it follow from the previous step?"
3. Identify the weakest step in the chain. If the weakest step is invalid, the entire
   gap finding may be invalid.

A gap is only as strong as the weakest step in its reasoning chain. This method prevents
gaps that seem compelling in summary but rest on a single flawed inference.

**Output**: Step-aware verification for each gap.

```
[Loop 33] [Step-Aware Verification] ->
  Gap: {description}
    Step 1: {reasoning step} — Valid: {yes/no}
    Step 2: {reasoning step} — Valid: {yes/no}
    Step 3: {reasoning step} — Valid: {yes/no}
    Weakest step: {N} — Overall validity: {VALID / QUESTIONABLE / INVALID}
  ...
```

### Loop 34: Dialectical Debate (Hegel)

**Method**: Dialectical Synthesis (#19)
**Source**: Hegel; arXiv:2501.14917 (Microsoft Research)
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

For each controversial or uncertain gap, conduct a 3-round dialectical debate:

Round 1 — THESIS: Present the strongest possible argument that this gap is real,
critical, and must be fixed immediately.

Round 2 — ANTITHESIS: Present the strongest possible argument that this gap is
not real, is insignificant, or is already mitigated by existing controls.

Round 3 — SYNTHESIS: Reconcile the thesis and antithesis. What is the nuanced
truth? Is the gap real but less severe than claimed? Is it real but already
partially mitigated? Is it actually a symptom of a deeper gap?

The synthesis must be MORE nuanced than either the thesis or antithesis alone.
If the synthesis simply agrees with one side, the debate was insufficient.

**Output**: Dialectical debate results.

```
[Loop 34] [Dialectical Debate] ->
  Gap: {description}
    THESIS: {argument for reality/severity}
    ANTITHESIS: {argument against reality/severity}
    SYNTHESIS: {nuanced reconciliation}
    Revised assessment: {description of updated understanding}
  ...
```

### Loop 35: Falsification Testing (Popper)

**Method**: Falsificationism (#18)
**Source**: Popper; arXiv:2502.09858, arXiv:2601.02380
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

The bullshit filter. For every gap that has survived to this point, attempt to
DISPROVE it.

For each gap:
1. State the gap as a falsifiable claim: "There exists a gap in X such that Y."
2. Design a falsification experiment: "If we did Z, and the result was W, then
   this gap would be disproved."
3. Mentally execute the experiment. What is the most likely result?
4. If the gap cannot be falsified — if there is NO conceivable experiment that
   could disprove it — then it is not a meaningful gap. It is unfalsifiable and
   must be either reformulated or discarded.

Popper's criterion is ruthless but necessary. A gap that cannot be disproved
cannot be proved either. It is metaphysics, not engineering.

**Output**: Falsification test results.

```
[Loop 35] [Falsification Testing] ->
  Gap: {description}
    Claim: {falsifiable statement}
    Experiment: {falsification test}
    Result: {SURVIVES — could not be disproved / DISPROVED — evidence against /
             UNFALSIFIABLE — reformulate or discard}
  ...
```

### Loop 36: Causal Inference Audit (Pearl)

**Method**: Causal Inference (#22)
**Source**: Pearl's do-calculus; arXiv:2410.16676, NAACL 2025
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Audit every causal claim in the gap log using Pearl's three rungs of causation:

Rung 1 — Association (seeing): "Gaps X and Y co-occur."
This is the weakest form of evidence. Co-occurrence does not imply causation.

Rung 2 — Intervention (doing): "If we fix gap X, gap Y will also be fixed."
This requires understanding the causal mechanism. Ask: "What is the mechanism
by which fixing X would fix Y?"

Rung 3 — Counterfactual (imagining): "If gap X had never existed, gap Y would
never have appeared."
This is the strongest form of evidence. It requires understanding what WOULD have
happened in an alternative world.

For each causal claim in the gap log:
1. What rung does the evidence support?
2. If only Rung 1, the claim needs more investigation before it can be trusted.
3. Build a causal DAG showing the actual dependency structure between gaps.

**Output**: Causal audit results.

```
[Loop 36] [Causal Inference Audit] ->
  Causal claim: {description}
    Evidence level: Rung {1/2/3}
    Mechanism: {description or NONE}
    Causal DAG edge: {Gap A} -> {Gap B} (confidence: {HIGH/MEDIUM/LOW})
  ...
```

### Loop 37: Faithful CoT + Self-Consistency

**Method**: Faithful Chain-of-Thought (#10) + Self-Consistency Decoding (#34)
**Source**: Lyu et al. (2023), arXiv:2301.13379; Wang et al. (ICLR 2023), arXiv:2203.11171
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Two complementary verification methods:

Part A — Faithful CoT: For each high-priority gap, translate the reasoning into
symbolic logic. This prevents post-hoc rationalization.

For each gap:
1. Express the gap claim as a logical proposition: P -> Q
2. Express the evidence as premises: P1, P2, P3
3. Check: Do the premises logically entail the conclusion?
4. If the symbolic chain is broken, the reasoning is unfaithful — the conclusion
   does not actually follow from the evidence.

Part B — Self-Consistency: Re-analyze the top 10 gaps from scratch, 3 independent times.
For each re-analysis, deliberately take a different interpretation of ambiguous evidence.

Count how many of the 3 analyses reach the same conclusion:
- 3/3: Strong consistency — gap is robust
- 2/3: Moderate consistency — gap is likely real but details may vary
- 1/3 or 0/3: Weak consistency — gap finding is fragile, may be an artifact

**Output**: Symbolic logic verification and consistency scores.

```
[Loop 37] [Faithful CoT + Self-Consistency] ->
  Gap: {description}
    Symbolic: {P1 AND P2 -> Q} — Valid: {yes/no}
    Consistency: {3/3, 2/3, 1/3} — Assessment: {ROBUST / LIKELY / FRAGILE}
  ...
```

### Loop 38: Constitutional Rigor Check

**Method**: Constitutional Self-Critique (#11)
**Source**: Bai et al. (Anthropic 2022), arXiv:2212.08073
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Apply all 8 articles of the ATOM Constitution (see Constitution section below) to
every gap that has survived to this point.

For each gap, check ALL 8 articles:

1. EVIDENCE: Is this gap supported by concrete evidence, not speculation?
2. QUANTIFICATION: Does it have numeric evidence (file counts, instance counts, percentages)?
3. FAITHFUL REASONING: Is the reasoning chain logically valid (symbolic check)?
4. ACTIONABILITY: Can this gap be resolved with a specific, implementable solution?
5. UNIQUENESS: Is this gap distinct from all other gaps, or is it a duplicate?
6. CROSS-IMPACT: Has the causal relationship to other gaps been mapped?
7. ADVERSARIAL SURVIVAL: Has this gap survived at least 3 adversarial methods?
8. FALSIFIABILITY: Is the gap claim falsifiable, and has a falsification test been run?

A gap must pass ALL 8 articles to be included in the final report. Gaps that fail
any article must be either remediated (additional analysis) or discarded.

**Output**: Constitutional compliance for each gap.

```
[Loop 38] [Constitutional Rigor Check] ->
  Gap: {description}
    Art 1 EVIDENCE: {PASS/FAIL — reason}
    Art 2 QUANTIFICATION: {PASS/FAIL — reason}
    Art 3 FAITHFUL REASONING: {PASS/FAIL — reason}
    Art 4 ACTIONABILITY: {PASS/FAIL — reason}
    Art 5 UNIQUENESS: {PASS/FAIL — reason}
    Art 6 CROSS-IMPACT: {PASS/FAIL — reason}
    Art 7 ADVERSARIAL SURVIVAL: {PASS/FAIL — reason}
    Art 8 FALSIFIABILITY: {PASS/FAIL — reason}
    Verdict: {CONSTITUTIONAL / REMEDIATE / DISCARD}
  ...
```

### Loop 39: STRIDE Threat Model + Attack Tree Verification

**Method**: STRIDE Threat Modeling + Attack Trees (#42)
**Source**: Howard & Lipner (Microsoft, 2006). Schneier, B. "Attack Trees" (1999).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Verify that security gaps have been SYSTEMATICALLY enumerated, not found ad-hoc.
STRIDE provides exhaustive categories. Attack trees provide combinatorial analysis.

Step 1 — IDENTIFY TRUST BOUNDARIES: List every boundary where trust level changes:
  - Public internet -> API gateway
  - API gateway -> backend service
  - Backend service -> database
  - User input -> processing
  - External API -> internal consumption

Step 2 — STRIDE ENUMERATION: For EACH trust boundary, enumerate all 6 categories:
  - **S**poofing: Can an attacker pretend to be someone/something else?
  - **T**ampering: Can an attacker modify data in transit or at rest?
  - **R**epudiation: Can an actor deny performing an action?
  - **I**nformation Disclosure: Can sensitive data leak?
  - **D**enial of Service: Can availability be attacked?
  - **E**levation of Privilege: Can an attacker gain unauthorized access?
  Rate each: MITIGATED / PARTIALLY MITIGATED / UNMITIGATED

Step 3 — ATTACK TREE DECOMPOSITION: For each UNMITIGATED threat, build an
attack tree with AND/OR nodes. Find the CHEAPEST PATH (lowest cost to attacker).

Step 4 — COMBINATION ANALYSIS: Look for paths combining two individually
low-risk threats into a high-risk breach.

Step 5 — CROSS-REFERENCE: For each UNMITIGATED threat, was it already found
by a HUNT loop? If not, it is a NEW gap discovered by STRIDE.

**Output**: Systematic threat enumeration and attack path analysis.

```
[Loop 39] [STRIDE + Attack Trees] ->
  Trust boundary: {A -> B}
    S: {status} T: {status} R: {status} I: {status} D: {status} E: {status}
  Attack tree: {goal} — Cheapest path: {steps} — Cost: {LOW/MEDIUM/HIGH}
  Combination: {threat A} + {threat B} = {compound threat}
  New gaps (not in HUNT): {list}
```

### Loop 40: Cognitive Bias Audit (Kahneman/Tversky)

**Method**: Cognitive Bias Audit (#43)
**Source**: Kahneman, D. "Thinking, Fast and Slow" (2011). Tversky & Kahneman (1974).
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

This loop audits the DECISIONS that created the system, not the system itself.
Every design choice was made by humans under cognitive constraints. Biased
decisions produce systematic gaps invisible to technical analysis.

Step 1 — IDENTIFY MAJOR DESIGN DECISIONS: List the 10-15 most consequential
choices visible in the target system:
  - Technology, architecture, security model, deployment, data model choices

Step 2 — BIAS SCREENING: For each decision, check 8 biases:
  1. **Anchoring**: Was the first option adopted without exploring alternatives?
  2. **Availability Bias**: Chosen because team was familiar, not because it was best?
  3. **Confirmation Bias**: Was disconfirming evidence sought?
  4. **Planning Fallacy**: Were effort estimates realistic?
  5. **Sunk Cost Fallacy**: Kept because of past investment, not current value?
  6. **Survivorship Bias**: Based only on successful examples?
  7. **Bandwagon Effect**: Chosen because "everyone uses it"?
  8. **Dunning-Kruger**: Was complexity underestimated?

Step 3 — BIAS-LINKED GAPS: For each detected bias, trace the downstream gap:
  "Decision X was likely anchored -> Alternative Y not considered -> Gap Z exists"

Step 4 — META-BIAS CHECK: Apply the bias audit to the ATOM run itself:
  - Is the gap log anchored on early findings?
  - Are certain gap types over-represented (availability bias)?
  - Were HUNT loops biased toward confirming AXIOMS findings?

**Output**: Bias-linked gaps and meta-analysis.

```
[Loop 40] [Cognitive Bias Audit] ->
  Decision: {description}
    Bias: {name} — Evidence: {description}
    Downstream gap: {description}
  META-BIAS (ATOM run):
    {bias risks in the analysis itself}
```

---

## Phase 4: SOLVE (Loops 41-46) — Solution Architecture

For every gap that survived Phase 3, architect a concrete solution. No vague
recommendations. Every solution must be specific, implementable, and testable.

### Loop 41: Solution Spec — New Skills

**Method**: Solution architecture for gaps requiring NEW capabilities
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

For each validated gap that requires a NEW skill, agent, tool, or capability:

1. Skill Name: What is the new skill called?
2. Purpose: What gap does it address? (reference by gap ID)
3. Trigger: How is it invoked?
4. Inputs: What does it need to operate?
5. Outputs: What does it produce?
6. Dependencies: What other skills or systems does it require?
7. Acceptance Criteria: How do you verify it works? (3-5 testable criteria)
8. Estimated Complexity: S/M/L/XL

**Output**: New skill specifications.

```
[Loop 41] [Solution — New Skills] ->
  Skill: {name}
    Addresses gap: {ID}
    Trigger: {invocation method}
    Inputs: {list}
    Outputs: {list}
    Dependencies: {list}
    Acceptance criteria:
      - {criterion 1}
      - {criterion 2}
      - {criterion 3}
    Complexity: {S/M/L/XL}
  ...
```

### Loop 42: Solution Spec — Modified Skills

**Method**: Solution architecture for gaps requiring MODIFICATIONS to existing capabilities
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

For each validated gap that can be addressed by modifying an EXISTING skill or component:

1. Target: What existing skill/component needs modification?
2. Current behavior: What does it do now?
3. Required change: What must change?
4. Gap addressed: Which gap ID does this fix?
5. Breaking changes: Does this modification break any existing behavior?
6. Migration path: If breaking, how do consumers adapt?
7. Acceptance criteria: How do you verify the modification works?

**Output**: Modification specifications.

```
[Loop 42] [Solution — Modified Skills] ->
  Modification: {target skill/component}
    Current: {behavior}
    Change: {description}
    Gap addressed: {ID}
    Breaking: {yes/no}
    Migration: {description or N/A}
    Acceptance criteria:
      - {criterion 1}
      - {criterion 2}
  ...
```

### Loop 43: Solution Spec — Agents, Commands, and Workflows

**Method**: Solution architecture for gaps requiring new agents, commands, or workflows
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

For each validated gap that requires new orchestration — a new agent, command, workflow,
or process:

1. Type: Agent / Command / Workflow / Process
2. Name: What is it called?
3. Gap addressed: Which gap ID does this fix?
4. Responsibility: What does it own?
5. Interactions: What does it communicate with?
6. Trigger conditions: When does it activate?
7. Success criteria: How do you know it worked?
8. Error handling: What happens when it fails?
9. Monitoring: How do you observe its health?

**Output**: Agent/command/workflow specifications.

```
[Loop 43] [Solution — Agents/Commands/Workflows] ->
  Type: {Agent/Command/Workflow/Process}
    Name: {name}
    Gap addressed: {ID}
    Responsibility: {description}
    Interactions: {list of systems/agents}
    Trigger: {conditions}
    Success criteria: {list}
    Error handling: {description}
    Monitoring: {description}
  ...
```

### Loop 44: Graph of Thoughts Solution Branching (Besta et al. 2023)

**Method**: Graph of Thoughts (#6)
**Source**: Besta et al. (2023), AAAI/ICLR 2024, arXiv:2308.09687
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Model the solution space as a directed graph. For each high-priority gap:

1. Generate 3 alternative solution approaches (branches)
2. For each branch, generate 2 sub-approaches (deeper branches)
3. Evaluate each leaf node on: Feasibility, Impact, Cost, Risk
4. Identify merge opportunities — can two solutions address multiple gaps?
5. Identify cycles — does any solution create new gaps?
6. Select the optimal path through the graph

The graph structure prevents tunnel vision. Linear thinking finds one solution.
Graph thinking finds the BEST solution from a space of alternatives.

**Output**: Solution graph with evaluated branches.

```
[Loop 44] [Graph of Thoughts] ->
  Gap: {description}
    Branch A: {approach} -> A1: {sub-approach}, A2: {sub-approach}
    Branch B: {approach} -> B1: {sub-approach}, B2: {sub-approach}
    Branch C: {approach} -> C1: {sub-approach}, C2: {sub-approach}
    Optimal path: {selected approach}
    Merges with: {other gaps this solution also addresses}
    Creates new gaps: {yes/no — description}
  ...
```

### Loop 45: RAP/MCTS + Second-Order Solution Search (Hao et al. 2023)

**Method**: Reasoning via Planning (#12) + Second-Order Effects (#24)
**Source**: Hao et al. (2023), EMNLP, arXiv:2305.14992
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Use MCTS-guided search to explore the solution space more deeply than Graph of Thoughts.

For the top 5 highest-severity gaps:

Step 1 — EXPAND: Generate 5+ possible solution actions (not just 3).
Step 2 — SIMULATE: For each action, mentally simulate the full implementation.
What happens? What side effects occur?
Step 3 — EVALUATE: Score each simulation on:
- Primary impact: How well does it fix the gap?
- Second-order impact: What new problems does it create?
- Third-order impact: What cascade effects does it trigger?
Step 4 — BACKPROPAGATE: Update the value of each action based on simulation results.
Step 5 — SELECT: Choose the action with the highest value after backpropagation.

This method is 33% more effective than standard chain-of-thought for solution search.

**Output**: MCTS search results with second-order analysis.

```
[Loop 45] [RAP/MCTS + Second-Order] ->
  Gap: {description}
    Action 1: {description} — Primary: {score} — 2nd order: {effect} — 3rd order: {effect}
    Action 2: {description} — Primary: {score} — 2nd order: {effect} — 3rd order: {effect}
    ...
    Selected: Action {N} — Rationale: {why}
  ...
```

### Loop 46: Theory of Constraints + Dependency Mapping (Goldratt)

**Method**: Theory of Constraints (#32)
**Source**: Goldratt (1984), The Goal
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Find THE bottleneck. Among all gaps and their proposed solutions, which single gap
constrains the entire system's improvement?

Step 1 — IDENTIFY: Which gap, if left unfixed, would prevent all other fixes from
having their intended effect?

Step 2 — EXPLOIT: How can the bottleneck gap be addressed with maximum efficiency
using existing resources?

Step 3 — SUBORDINATE: How should all other work be organized around fixing the
bottleneck first?

Step 4 — ELEVATE: If existing resources are insufficient, what additional resources
are needed to break the bottleneck?

Step 5 — DEPENDENCY MAP: Create the full dependency graph of solutions. Which solutions
must be implemented before which others? What is the critical path?

**Output**: Bottleneck identification and dependency map.

```
[Loop 46] [Theory of Constraints] ->
  BOTTLENECK: {gap description}
    Why it constrains everything: {explanation}
    Exploit: {efficiency plan}
    Subordinate: {ordering}
    Elevate: {additional resources needed}
  CRITICAL PATH: {Gap A} -> {Gap B} -> {Gap C} -> ... (in implementation order)
  PARALLEL TRACKS: {gaps that can be fixed independently}
```

---

## Phase 5: SYNTHESIZE (Loops 47-49) — Merge, Deduplicate, Report

The consolidation phase. All findings from 30 loops are merged into a single,
actionable report.

### Loop 47: Deduplicate and Merge (CEO Synthesis)

**Method**: CEO-level synthesis
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

You are the CEO. You have 30 loops of analysis in front of you. Your job:

1. DEDUPLICATE: Many loops found the same gap expressed differently. Merge duplicates
   into a single canonical gap. Preserve the strongest evidence from each duplicate.

2. CLUSTER: Group related gaps into logical clusters (e.g., "Authentication Gaps",
   "Observability Gaps", "Data Integrity Gaps").

3. PRIORITIZE: Within each cluster, order by severity (Critical > High > Medium > Low).

4. ASSIGN OWNERSHIP: For each cluster, identify the team or role best suited to fix it.

5. ESTIMATE EFFORT: For each gap, estimate effort as T-shirt size (S/M/L/XL) based
   on the solution specs from Loops 25-30.

**Output**: Deduplicated, clustered, prioritized gap list.

```
[Loop 47] [CEO Synthesis] ->
  Cluster: {name}
    Gap 1: {description} — Severity: {Critical/High/Medium/Low} — Effort: {S/M/L/XL} — Owner: {team/role}
    Gap 2: {description} — Severity: {Critical/High/Medium/Low} — Effort: {S/M/L/XL} — Owner: {team/role}
  ...
```

### Loop 48: MAP-Elites Coverage Report

**Method**: MAP-Elites Coverage Grid (#33)
**Source**: Mouret & Clune (2015), Nature
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Generate the quality-diversity coverage report. Using the Morphological Grid from
Loop 4, fill in every cell with the gaps found (or mark as "No gaps found").

For each cell in the grid (Layer x Quality Attribute):
- Count the number of gaps found
- Note the highest-severity gap
- Mark cells with no gaps as either "VERIFIED CLEAN" (actively investigated, no gaps)
  or "UNEXPLORED" (never investigated — potential blind spot)

Calculate the coverage score:
- Total cells in the grid
- Cells with gaps found
- Cells verified clean
- Cells unexplored
- Coverage = (Cells with gaps + Cells verified clean) / Total cells

A coverage score below 70% indicates the analysis has significant blind spots.

**Output**: MAP-Elites coverage grid and score.

```
[Loop 48] [MAP-Elites Coverage] ->
  See Coverage Grid Template below for format.
  Coverage score: {N}%
  Blind spots: {list of unexplored cells}
```

### Loop 49: Final Prioritized Report

**Method**: Final synthesis
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Generate the final report: `synthesized-gaps.md`

The report must contain:

1. EXECUTIVE SUMMARY: 3-5 sentences. What is the overall state? How many gaps total?
   How many critical?

2. CRITICAL gaps: Detailed findings using the v3 Gap Report Format (see above).

3. HIGH gaps: Detailed findings using the v3 Gap Report Format.

4. MEDIUM gaps: Detailed findings using the v3 Gap Report Format.

5. LOW gaps: Summarized findings.

**IMPORTANT**: Use the v3 Gap Report Format for ALL gaps. Do NOT use FMEA RPN tables,
Bayesian probabilities, or causal DAGs in the gap output. Use simple severity labels
(Critical/High/Medium/Low) and the structured format defined in the "Gap Report Format"
section of this protocol.

7. COVERAGE REPORT: MAP-Elites grid from Loop 48.

8. DEPENDENCY MAP: Critical path from Loop 46.

9. EPISTEMIC HUMILITY: Known unknowns and unexplored areas.

10. METHODOLOGY NOTE: Which loops were run, how many gaps were found, how many survived
    validation, and the protocol version.

**Output**: `memory/synthesized-gaps.md` — the final deliverable.

---

## Phase 6: CACHE (Loop 50) — Knowledge Extraction

### Loop 50: Buffer of Thoughts Template Extraction

**Method**: Buffer of Thoughts (#13)
**Source**: Yang et al. (2024), NeurIPS Spotlight, arXiv:2406.04271
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Extract reusable discovery templates from this run for use in future runs.

For each gap that was successfully discovered:
1. What METHOD found it most effectively?
2. What PATTERN does it represent? (e.g., "missing error handling at trust boundary",
   "no monitoring for cascade failure", "implicit contract between components")
3. Can this pattern be generalized? Write a one-sentence template:
   "Check for {pattern} at {location type} when {condition}."

Store templates in `memory/atom-templates.md` with the following format:

```
## Discovery Templates (from {target} run, {date})

### Template 1: {pattern name}
- Pattern: {generalized description}
- Where to look: {location type}
- When to apply: {condition}
- Source method: {method that found it}
- Example: {concrete example from this run}
```

Templates accumulate across runs. Each new run can use templates from previous runs
to accelerate discovery (the Buffer of Thoughts advantage).

**Output**: Reusable templates written to `memory/atom-templates.md`.

---

## Phase 7: EVOLVE (Loops 51-53) — Self-Improvement

The protocol improves itself. These loops turn ATOM's methods inward.

### Loop 51: Reflexion — Verbal Reinforcement Learning

**Method**: Reflexion (#14)
**Source**: Shinn et al. (NeurIPS 2023), arXiv:2303.11366
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Conduct verbal reinforcement learning on the completed ATOM run.

Step 1 — EXPERIENCE REPLAY: Review the gap log chronologically. For each loop:
- What was attempted?
- What was found?
- What was missed (that a later loop found)?

Step 2 — REFLECTION: Answer these questions:
- Which methods were most productive? (found the most surviving gaps)
- Which methods were least productive? (found gaps that were later invalidated)
- Which methods found UNIQUE gaps? (gaps no other method found)
- Where did the protocol waste effort?
- What types of gaps were hardest to find?

Step 3 — EPISODIC MEMORY UPDATE: Write a reflection summary to
`memory/atom-reflexion.md` for use in future runs:
- "Next time, spend more time on {method} because {reason}"
- "Next time, skip or reduce {method} because {reason}"
- "Next time, add a new check for {pattern} because {reason}"

**Output**: Reflexion summary written to `memory/atom-reflexion.md`.

```
[Loop 51] [Reflexion] ->
  Most productive methods: {list}
  Least productive methods: {list}
  Unique-finding methods: {list}
  Wasted effort: {description}
  Recommendations for next run: {list}
```

### Loop 52: CRITIC Self-Critique — Quantitative Metrics

**Method**: CRITIC Tool-Interactive (#35)
**Source**: Gou et al. (2023), arXiv:2305.11738
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Evaluate the ATOM run using quantitative metrics:

1. DISCOVERY RATE: Total gaps found / Total morphological cells explored
2. SURVIVAL RATE: Gaps surviving validation / Total gaps found
3. FALSE POSITIVE RATE: Gaps invalidated in Phase 3 / Total gaps found
4. COVERAGE SCORE: From MAP-Elites (Loop 48)
5. METHOD EFFICIENCY: For each method, gaps found / time invested
6. CONVERGENCE: Average number of methods that independently found each surviving gap
7. CONSTITUTIONAL COMPLIANCE: Percentage of surviving gaps that pass all 8 articles

Benchmark targets:
- Discovery rate > 0.3 (at least 1 gap per 3 cells explored)
- Survival rate > 0.5 (at least half of found gaps are real)
- False positive rate < 0.3 (less than 30% of found gaps are noise)
- Coverage score > 0.7 (at least 70% of the grid explored)
- Convergence > 2.0 (each real gap found by at least 2 methods on average)
- Constitutional compliance > 0.9 (90%+ of gaps pass all articles)

If any metric falls below its benchmark, diagnose the cause and recommend a fix
for the next run.

**Output**: Quantitative metrics and benchmark comparison.

```
[Loop 52] [CRITIC Metrics] ->
  Discovery rate: {value} — Target: >0.3 — {PASS/FAIL}
  Survival rate: {value} — Target: >0.5 — {PASS/FAIL}
  False positive rate: {value} — Target: <0.3 — {PASS/FAIL}
  Coverage score: {value} — Target: >0.7 — {PASS/FAIL}
  Convergence: {value} — Target: >2.0 — {PASS/FAIL}
  Constitutional compliance: {value} — Target: >0.9 — {PASS/FAIL}
  Diagnosis: {if any metric fails, explain why and recommend fix}
```

### Loop 53: Absolute Zero Self-Play

**Method**: Absolute Zero (#15)
**Source**: Zhao et al. (NeurIPS 2025), arXiv:2505.03335
**Ralph Wiggum Reset**: Clear all context. Read only `memory/gaps.log`.

**Instructions**:

Self-play bootstrapping. The protocol generates adversarial challenges for itself.

Step 1 — GENERATE CHALLENGES: Create 5 scenarios that this ATOM run would have
FAILED to detect:
- "What type of gap would be invisible to ALL 51 methods?"
- "What assumption does the protocol itself make that could be wrong?"
- "What if the gap log itself was corrupted or incomplete?"
- "What if two individually-valid gaps combine to create a third, undetected gap?"
- "What if the target system changes during the analysis?"

Step 2 — ATTEMPT SOLUTIONS: For each challenge, propose a modification to the
ATOM protocol that would catch this failure mode in future runs.

Step 3 — VALIDATE SOLUTIONS: For each proposed modification, ask: "Does this
add enough value to justify the additional complexity?" Only keep modifications
that pass this test.

**Output**: Self-play challenges and protocol improvements.

```
[Loop 53] [Absolute Zero Self-Play] ->
  Challenge 1: {scenario that would defeat the protocol}
    Proposed fix: {modification}
    Worth adding: {yes/no — rationale}
  ...
  Protocol improvements for next version: {list of accepted modifications}
```

---

## The ATOM Constitution

Eight articles that every gap must satisfy before inclusion in the final report.
These are not guidelines — they are hard requirements.

### Article 1: EVIDENCE

Every gap must be supported by concrete, verifiable evidence. Speculation,
intuition, and "it seems like" are not evidence.

**Machine-verifiable test**: The gap entry contains at least one of:
- A specific code reference (file, line, function)
- A specific configuration or documentation reference
- A reproducible test case
- A reference to an industry standard or known vulnerability class

FAIL condition: The gap entry contains only subjective assessment with no
concrete reference.

### Article 2: QUANTIFICATION

Every gap must have quantified severity using BOTH:
- Severity label (Critical/High/Medium/Low) using the calibration from the Gap Report Format section
- Bayesian posterior probability P(real) from cumulative evidence

**Machine-verifiable test**: The gap entry contains:
- Three numeric scores (S, O, D) and their product (RPN)
- A probability value between 0 and 1

FAIL condition: Either the RPN or Bayesian probability is missing.

### Article 3: FAITHFUL REASONING

The reasoning chain that identified this gap must be logically valid.
No post-hoc rationalization. No "it just seems wrong."

**Machine-verifiable test**: The gap entry contains a symbolic logic chain
(P1 AND P2 -> Q) and the chain is valid.

FAIL condition: No symbolic chain exists, or the chain contains a logical fallacy.

### Article 4: ACTIONABILITY

Every gap must have a specific, implementable resolution. "Improve security"
is not actionable. "Add rate limiting to /api/auth endpoint with 10 req/min
per IP" is actionable.

**Machine-verifiable test**: The proposed resolution contains:
- A specific action (add, modify, remove, configure)
- A specific target (component, file, endpoint, process)
- Measurable acceptance criteria

FAIL condition: The resolution is vague or contains no specific target.

### Article 5: UNIQUENESS

Every gap must be distinct from all other gaps in the report. Duplicates
waste attention and inflate severity counts.

**Machine-verifiable test**: No other gap in the report addresses the same
root cause AND the same component AND the same quality attribute.

FAIL condition: Another gap exists with the same root cause, component, and
quality attribute.

### Article 6: CROSS-IMPACT

Every gap must have its causal relationship to other gaps explicitly mapped.
Gaps do not exist in isolation.

**Machine-verifiable test**: The gap entry contains at least one of:
- "Causes: {other gap IDs}"
- "Caused by: {other gap IDs}"
- "Independent of: all other gaps" (with explanation)

FAIL condition: No cross-impact information exists.

### Article 7: ADVERSARIAL SURVIVAL

Every gap must have survived at least 3 adversarial verification methods
from Phase 3 (Loops 17-24).

**Machine-verifiable test**: The gap entry lists at least 3 verification
methods and their outcomes, with at least 3 PASS results.

FAIL condition: Fewer than 3 adversarial methods applied, or fewer than
3 PASS results.

### Article 8: FALSIFIABILITY

Every gap claim must be falsifiable. There must exist a conceivable
experiment or observation that could disprove the gap's existence.

**Machine-verifiable test**: The gap entry contains:
- A falsifiable claim statement
- A described falsification experiment
- The result of the experiment (SURVIVES, not UNFALSIFIABLE)

FAIL condition: The gap is marked UNFALSIFIABLE or no falsification
experiment is described.

---

## Gap Report Format (v3 — Machine-Optimized)

> **Why this format?** Through 120+ auto-research iterations, we proved that the verbose
> FMEA template (RPN tables, Bayesian probabilities, causal DAGs) produces gaps that
> automated evaluation and AI readers cannot parse reliably. The format below scores
> 95-97/100 on the ATOM Quality Index while remaining human-readable.

Every gap in the final report MUST use this exact format. No deviations.

### Heading Format
Use `###` (h3) headings. NOT `##` (h2). NOT `####` (h4). Exactly three hashes.

```
### GAP-{NNN}: {Title}

**Severity**: Critical | High | Medium | Low
**Component**: {file_name.ext}
**Evidence**: {file.ext}:{line} — "{N} files affected" or "{N} instances found"
**Description**: This is a **{layer}** gap affecting **{attribute}**. {What the gap is}.
  You can {test/verify/reproduce} this by {specific method}. {N} instances across {M} files.
**Impact**: {Quantified} — "affects {N}% of {requests/users/endpoints}"
**Recommendation**: Should {fix/implement/add/remove/resolve} by {specific action}.
  {Implementation detail}. This would resolve {N} instances.
**Discovery Method**: {Loop name that found this gap}
```

### Mandatory Keywords (Constitutional Compliance)

Every gap MUST pass all 4 automated checks. Missing ANY keyword = non-compliant gap.

1. **Evidence markers**: Reference specific source files with line numbers (e.g., `auth.ts:42`)
2. **Quantification markers**: Include at least one number — "3 files", "12 instances", "100ms", "25% of endpoints"
3. **Falsifiability markers**: Use at least one of: test, verify, reproduce, confirm, check, prove
4. **Actionability markers**: Use at least one of: fix, resolve, implement, add, remove, should, recommend, must

### MAP-Elites Quality Dimensions

Tag every gap with its primary **layer** and **attribute** using bold text in the description.
Use these EXACT terms — they are scored automatically.

**Layers** (what area of the system):
- **architecture** — structural design, module boundaries, dependency flow
- **security** — auth, injection, access control, secrets management
- **performance** — latency, throughput, resource efficiency, memory
- **reliability** — fault tolerance, crash recovery, uptime
- **data** — storage, encoding, integrity, persistence
- **integration** — API contracts, external dependencies, protocols
- **operations** — deployment, monitoring, logging, configuration
- **user experience** — error messages, onboarding, API ergonomics

**Attributes** (what quality is affected):
- **completeness** — are all cases handled?
- **correctness** — does it do the right thing?
- **consistency** — are patterns uniform?
- **robustness** — does it handle failures gracefully?
- **efficiency** — resource usage, unnecessary work
- **maintainability** — readability, modularity, coupling
- **testability** — can it be tested?
- **documentation** — are contracts documented?

### MAP-Elites Coverage Matrix (Required)

After all gaps, include this matrix mapping gaps to the 8×8 grid:

```
## MAP-Elites Coverage Matrix

| Layer            | completeness | correctness | consistency | robustness | efficiency | maintainability | testability | documentation |
|------------------|-------------|-------------|-------------|------------|------------|-----------------|-------------|---------------|
| architecture     | GAP-xxx     | GAP-xxx     |             | GAP-xxx    |            |                 |             |               |
| security         | GAP-xxx     |             |             | GAP-xxx    |            |                 |             |               |
| performance      |             |             |             |            | GAP-xxx    |                 |             |               |
| reliability      |             | GAP-xxx     |             | GAP-xxx    |            |                 |             |               |
| data             | GAP-xxx     | GAP-xxx     |             |            |            |                 |             |               |
| integration      |             |             | GAP-xxx     |            |            |                 |             |               |
| operations       |             |             |             |            |            | GAP-xxx         |             | GAP-xxx       |
| user experience  | GAP-xxx     |             | GAP-xxx     |            |            |                 |             |               |
```

Aim to cover ALL 8 layers and as many attributes as possible.

### Severity Calibration (Universal)

Do NOT use FMEA RPN tables in the output. Use simple severity labels.

**When in doubt, rate ONE LEVEL HIGHER than your instinct.** Real-world ground truth
consistently rates issues more severely than AI analysis defaults to.

- **Critical**: Data loss, security breach, auth bypass, injection, secrets exposure,
  supervisor/process tree collapse, silent data corruption, permission fail-open
- **High**: Race conditions, missing input validation, unbounded growth, missing rate
  limiting, encoding bugs, missing error handling on critical paths, dead code in
  startup paths, missing fallback/circuit breaker, session management gaps
- **Medium**: Missing telemetry/observability, non-atomic operations, stale caches,
  incomplete error handling, missing pagination, configuration issues, missing
  documentation that causes confusion
- **Low**: Missing type annotations, naming inconsistencies, cosmetic issues, dead
  code that doesn't affect functionality, style-only problems

### Gap Count Guidance

- Target: **25-35 gaps** per analysis
- Too few (<20): You're likely missing things. Re-examine under-covered files.
- Too many (>40): Quality may suffer. Merge related gaps and drop noise.
- Severity distribution should roughly match: ~15% Critical, ~30% High, ~35% Medium, ~20% Low

---

## TRIZ Quick Reference — Top 15 Inventive Principles for Software

| # | Principle | Application |
|---|-----------|-------------|
| 1 | Segmentation | Break monolith into microservices or modules |
| 2 | Taking Out | Extract a problematic component into its own service |
| 3 | Local Quality | Apply different configs per environment or tenant |
| 5 | Merging | Combine related functions to reduce integration points |
| 10 | Prior Action | Pre-compute, cache, warm pools, pre-provisioning |
| 13 | The Other Way Around | Invert control flow (IoC, event-driven, pull vs push) |
| 15 | Dynamization | Feature flags, runtime configuration, hot reloading |
| 17 | Another Dimension | Add caching layer, read replicas, CDN, async queues |
| 22 | Blessing in Disguise | Turn errors into features (graceful degradation) |
| 24 | Intermediary | Add proxy, gateway, adapter, or middleware |
| 25 | Self-Service | Automate manual processes, self-healing infrastructure |
| 28 | Mechanics Substitution | Replace polling with webhooks, cron with event triggers |
| 32 | Color Changes | Add observability (metrics, traces, logs, status pages) |
| 35 | Parameter Changes | Tune timeouts, retries, batch sizes, pool sizes |
| 40 | Composite Structures | Combine patterns (circuit breaker + retry + fallback) |

---

## Domain-Specific Severity Anchors

When analyzing a system, identify its domain and apply the relevant severity anchors.
The universal calibration in the Gap Report Format section applies to ALL domains.
These anchors provide additional guidance for specific technology stacks.

### Elixir/OTP/BEAM Systems
- **Critical**: Singleton GenServer crash with no restart, `:infinity` timeout on GenServer.call,
  unsupervised `Task.start`, missing `handle_info/2` catch-all, ETS table owned by non-supervised
  process, `spawn_link` to non-supervised process, shell command injection, `String.to_atom` on
  untrusted input
- **High**: `persistent_term` misuse (global GC pause), floating-point for financial, dead code
  in supervision tree, `Task.async` without `Task.await`, closure capturing `self()`, silent
  error swallowing (`rescue _ -> :ok`)

### Node.js/TypeScript/NestJS Systems
- **Critical**: SQL/NoSQL injection, JWT secret in code, `eval()` on user input, missing auth
  middleware, exposed API keys, tenant isolation bypass
- **High**: Missing DTO validation, no rate limiting, SSRF, missing CORS/CSP headers, missing
  error boundaries, unhandled promise rejections, N+1 queries

### Python/FastAPI/Django Systems
- **Critical**: `pickle.loads` on untrusted data, SQL injection via f-strings, `exec`/`eval`
  on user input, bare `except:` swallowing security errors, hardcoded secrets
- **High**: Missing input validation, no rate limiting, unbounded queries, missing CSRF,
  global state mutation in async handlers

### React/Frontend Systems
- **Critical**: XSS via `dangerouslySetInnerHTML`, exposed API keys in client bundle, auth
  tokens in localStorage
- **High**: Missing error boundaries, no CSP, clickjacking (no X-Frame-Options), direct
  database access from client, client-side only auth checks

### Severity 7-8 (High) — Rate as S=7 or S=8:
- **`persistent_term` misuse** — update triggers global GC pause across all schedulers
- **Floating-point arithmetic for financial/billing** — precision loss accumulates
- **Dead code in supervision tree startup** — indicates untested/rotting code path
- **Hardcoded subset of supported values** (e.g., 5 of 40 models) — silent data loss for unlisted
- **`Task.async` without matching `Task.await`** — leaked reference, potential memory leak
- **Cron/scheduler with no deduplication** — jobs fire multiple times per interval
- **Closure capturing `self()` in GenServer callback** — potential deadlock on self-call
- **Silent error swallowing** (`rescue _ -> :ok`) — failures invisible to operators
- **No graceful degradation on external dependency failure** — silent skip, data inconsistency

### Severity 5-6 (Moderate) — Rate as S=5 or S=6:
- **Unbounded in-memory list growth** (e.g., activity log capped at 100 but no LRU) — OOM risk under load
- **Module alias to non-existent module** — compile warning but runtime crash on call
- **Documentation/moduledoc contradicts code constants** — developer confusion, wrong assumptions
- **Missing `@impl` annotations** — OTP behaviour contract unclear, silent clause shadowing

### Severity Upgrade Rules:
1. **Singleton process rule**: If the affected process is a singleton GenServer (only one instance
   in the supervision tree), upgrade severity by +2 (minimum S=7).
2. **Supervision gap rule**: If the failing code path is NOT under a supervisor, upgrade by +2.
3. **Data loss rule**: If the failure can lose user data or financial state, minimum S=9.
4. **Silent failure rule**: If the failure produces no log output, error message, or crash report,
   upgrade by +1 (the Detection score D should also be high, but S itself goes up because
   silent failures compound).

---

## Morphological Grid Template

```
                    | Security | Performance | Reliability | Scalability | Maintainability | Observability | Compliance | Data Integrity |
--------------------|----------|-------------|-------------|-------------|-----------------|---------------|------------|----------------|
UI / Frontend       |          |             |             |             |                 |               |            |                |
API / Gateway       |          |             |             |             |                 |               |            |                |
Business Logic      |          |             |             |             |                 |               |            |                |
Data / Storage      |          |             |             |             |                 |               |            |                |
Infrastructure      |          |             |             |             |                 |               |            |                |
External Deps       |          |             |             |             |                 |               |            |                |
CI/CD Pipeline      |          |             |             |             |                 |               |            |                |
Auth / Identity     |          |             |             |             |                 |               |            |                |

Legend:
  [C] = Critical gap found
  [C] = Critical gap found (RPN 100-199)
  [H] = High gap found (RPN 50-99)
  [M] = Medium gap found (RPN 25-49)
  [L] = Low gap found
  [.] = Investigated, no gaps found (verified clean)
  [ ] = Not yet investigated (blind spot)
```

---

## MAP-Elites Coverage Template

```
                    | Showstopper | Critical | High | Medium | Low | Clean | Unexplored | Total |
--------------------|-------------|----------|------|--------|-----|-------|------------|-------|
UI / Frontend       |             |          |      |        |     |       |            |       |
API / Gateway       |             |          |      |        |     |       |            |       |
Business Logic      |             |          |      |        |     |       |            |       |
Data / Storage      |             |          |      |        |     |       |            |       |
Infrastructure      |             |          |      |        |     |       |            |       |
External Deps       |             |          |      |        |     |       |            |       |
CI/CD Pipeline      |             |          |      |        |     |       |            |       |
Auth / Identity     |             |          |      |        |     |       |            |       |
--------------------|-------------|----------|------|--------|-----|-------|------------|-------|
TOTALS              |             |          |      |        |     |       |            |       |

Coverage Score = (Cells with gaps + Cells verified clean) / Total cells = {N}%

Target: >= 70% coverage
Below 70%: Analysis has significant blind spots — consider additional loops
```

---

## Epistemic Humility Template

Every ATOM analysis must end with an honest assessment of what it does NOT know.

### Known Knowns
Gaps confirmed with high confidence (P(real) > 0.7, survived 3+ adversarial methods):
- {list}

### Known Unknowns
Areas investigated but inconclusive (0.3 < P(real) < 0.7, mixed verification results):
- {list}
- Recommended follow-up: {specific investigation for each}

### Unknown Unknowns
Morphological cells never explored, analogous domain gaps not investigated, scenarios
not considered:
- {list of unexplored cells from MAP-Elites}
- {list of analogous domains not consulted}
- This section is inherently incomplete — if we knew what was here, it would be a Known Unknown.

---

## Exit Checklist

Before declaring an ATOM analysis complete, verify ALL of the following:

### Format Compliance (non-negotiable)
- [ ] All gaps use `### GAP-NNN:` format (h3 headings, three hashes)
- [ ] Every gap has `**Severity**: Critical | High | Medium | Low` (simple label, NOT RPN)
- [ ] Every gap has `**Evidence**:` with file:line references and a count
- [ ] Every gap Description contains a number, a test/verify word, and bold **layer** + **attribute**
- [ ] Every gap Recommendation contains fix/implement/add/remove/resolve/should/recommend
- [ ] MAP-Elites 8×8 coverage matrix included at end of report
- [ ] All 8 layers and all 8 attributes appear in gap descriptions

### Analysis Quality
- [ ] All 53 loops executed (or explicitly skipped with documented rationale)
- [ ] 25-35 gaps found (not too few, not too many)
- [ ] Severity distribution roughly matches: ~15% Critical, ~30% High, ~35% Medium, ~20% Low
- [ ] Every source file in scope has been read
- [ ] Gaps span multiple files/modules (not clustered on one file)
- [ ] Discovery Method attributed on every gap

---

## Research Citations

Brief citation list for all 51 methods:

1. Zhou et al. "Self-Discover: Large Language Models Self-Compose Reasoning Structures." NeurIPS 2024. arXiv:2402.03620
2. Zheng et al. "Take a Step Back: Evoking Reasoning via Abstraction." arXiv:2310.06117 (2023)
3. RT-ICA Reverse Thinking. arXiv:2512.10273 (2024)
4. Chia et al. "Contrastive Chain-of-Thought Prompting." arXiv:2311.09277 (2023)
5. Zhang et al. "Cumulative Reasoning with Large Language Models." TMLR. arXiv:2308.04371 (2023)
6. Besta et al. "Graph of Thoughts: Solving Elaborate Problems with Large Language Models." AAAI/ICLR 2024. arXiv:2308.09687
7. Dhuliawala et al. "Chain-of-Verification Reduces Hallucination." Meta AI. ACL 2024. arXiv:2309.11495
8. Li et al. "Making Language Models Better Reasoners with Step-Aware Verifier." ACL 2023. arXiv:2206.02336
9. Du et al. "Improving Factuality and Reasoning in Language Models through Multiagent Debate." ICML 2024. arXiv:2305.14325
10. Lyu et al. "Faithful Chain-of-Thought Reasoning." IJCNLP. arXiv:2301.13379 (2023)
11. Bai et al. "Constitutional AI: Harmlessness from AI Feedback." Anthropic. arXiv:2212.08073 (2022)
12. Hao et al. "Reasoning with Language Model is Planning with World Model." EMNLP. arXiv:2305.14992 (2023)
13. Yang et al. "Buffer of Thoughts: Thought-Augmented Reasoning with Large Language Models." NeurIPS Spotlight. arXiv:2406.04271 (2024)
14. Shinn et al. "Reflexion: Language Agents with Verbal Reinforcement Learning." NeurIPS 2023. arXiv:2303.11366
15. Zhao et al. "Absolute Zero: Reinforced Self-play Reasoning with Zero Data." NeurIPS 2025. arXiv:2505.03335
16. Aristotle. "Metaphysics." First Principles — "the first basis from which a thing is known."
17. Peirce, C.S. "Abduction and Induction." arXiv:2307.10250, arXiv:2601.02771
18. Popper, K. "The Logic of Scientific Discovery." Falsificationism. arXiv:2502.09858, arXiv:2601.02380
19. Hegel, G.W.F. "Phenomenology of Spirit." Dialectical method. arXiv:2501.14917 (Microsoft Research)
20. Plato. "Meno", "Theaetetus." Socratic Elenchus. arXiv:2303.08769 (Chang 2023)
21. Bayes, T. "An Essay towards solving a Problem in the Doctrine of Chances." Nature Comms 2025. arXiv:2503.17523
22. Pearl, J. "Causality: Models, Reasoning, and Inference." do-calculus. arXiv:2410.16676, NAACL 2025
23. Analogical Transfer. arXiv:2310.01714, ACM CHI 2023
24. Second-Order Effects. Systems thinking and consequence scanning frameworks.
25. Emergence Detection. Complexity Journal 2017. BKB framework.
26. Zwicky, F. "Discovery, Invention, Research through the Morphological Approach." (1969)
27. Klein, G. "Performing a Project Premortem." Harvard Business Review (2007)
28. Negative Space Analysis. Art theory applied to engineering gap detection.
29. Altshuller, G. "The Innovation Algorithm: TRIZ." Analysis of 2M+ patents.
30. FMEA. MIL-STD-1629A. ISO 31010. Risk Priority Number methodology.
31. Industry Standards: OWASP, DORA, ISO 27001, NIST CSF, SLSA, CIS Benchmarks.
32. Goldratt, E. "The Goal: A Process of Ongoing Improvement." Theory of Constraints (1984).
33. Mouret & Clune. "Illuminating Search Spaces by Mapping Elites." Nature (2015).
34. Wang et al. "Self-Consistency Improves Chain of Thought Reasoning." ICLR 2023. arXiv:2203.11171
35. Gou et al. "CRITIC: Large Language Models Can Self-Correct with Tool-Interactive Critiquing." arXiv:2305.11738 (2023)

---

## Usage with Claude Code Agent Teams

ATOM maps naturally to Claude Code Agent Teams with 4+ agents:

```
Team Configuration for ATOM Analysis:

Agent 1 — Axiom Agent:
  Runs Loops 1-4 (Phase 1: AXIOMS)
  Establishes first principles, step-back abstractions, reasoning blueprint, morphological grid

Agent 2 — Hunter Agent:
  Runs Loops 5-16 (Phase 2: HUNT)
  Executes all 12 discovery methods in parallel where possible

Agent 3 — Validator Agent:
  Runs Loops 17-24 (Phase 3: VALIDATE)
  Adversarial verification — FMEA scoring, falsification, dialectical debate

Agent 4 — Architect Agent:
  Runs Loops 25-30 (Phase 4: SOLVE)
  Solution specifications, graph of thoughts, dependency mapping

Lead Agent — CEO:
  Runs Loops 31-37 (Phases 5-7: SYNTHESIZE + CACHE + EVOLVE)
  Deduplication, final report, knowledge extraction, self-improvement
```

Shared state: All agents read from and write to `memory/gaps.log`. The gap log
is the ONLY shared memory. This preserves the Ralph Wiggum property — each loop
starts with zero context except what is in the log.

To run: `/atom {target description}` or `/age {target description}`
