# ATOM Protocol — Research Foundations & Reference Materials

> Academic companion to SKILL.md. This document provides full bibliographic citations,
> theoretical foundations, and ready-to-use templates for every method in the ATOM protocol.

---

## Tier 1 — AI/ML Research Citations

### 1. Self-Discover
Zhou, P., Pujara, J., Ren, X., Chen, X., Cheng, H., Cho, K., et al. (2024). "Self-Discover: Large Language Models Self-Compose Reasoning Structures." NeurIPS 2024. arXiv:2402.03620. https://arxiv.org/abs/2402.03620

Enables LLMs to autonomously select and compose atomic reasoning modules into task-specific reasoning structures before solving problems. Outperforms CoT by 5-32% on BIG-Bench Hard and MATH.

**ATOM usage:** Discover loop (Phase 1) — model composes a custom reasoning plan for each gap before analysis begins. Module catalog drawn from this paper (see Section 6).

### 2. Step-Back Prompting
Zheng, H. S., Mishra, S., Chen, X., Cheng, H., Chi, E. H., Le, Q. V., & Zhou, D. (2023). "Take a Step Back: Evoking Reasoning via Abstraction in Large Language Models." arXiv:2310.06117. https://arxiv.org/abs/2310.06117

Instructs the model to derive high-level concepts and principles before answering. Improves STEM and knowledge-intensive reasoning by grounding answers in first principles.

**ATOM usage:** Discover loop abstraction phase — before analyzing a gap, identify underlying domain principles and architectural patterns that govern its context.

### 3. RT-ICA (Reverse Thinking with Inverse Chain-of-Thought)
arXiv:2512.10273. https://arxiv.org/abs/2512.10273

Reverses standard CoT direction: reasons backward from a claimed conclusion to check support. Catches logical gaps that forward reasoning misses.

**ATOM usage:** Test loop (Phase 3) falsification — "If this gap did NOT exist, what evidence would we expect?" Catches false positives.

### 4. Contrastive Chain-of-Thought
Chia, Y. K., Chen, G., Tuan, L. A., Poria, S., & Bing, L. (2023). "Contrastive Chain-of-Thought Prompting." arXiv:2311.09277. https://arxiv.org/abs/2311.09277

Augments CoT with both correct and incorrect reasoning examples, teaching distinction between valid and invalid paths. Reduces reasoning errors vs. standard few-shot CoT.

**ATOM usage:** Operate loop (Phase 2) — generates "IS a gap" and "is NOT a gap" chains for each finding, evaluates which is more logically sound.

### 5. Cumulative Reasoning
Zhang, Y., Du, J., Gao, S., & Wen, J. (2023). "Cumulative Reasoning with Large Language Models." TMLR. arXiv:2308.04371. https://arxiv.org/abs/2308.04371

Decomposes problems into atomic propositions, each verified before joining a growing knowledge base. Prevents error propagation through long chains.

**ATOM usage:** Operate loop — each sub-finding verified before contributing to overall severity, preventing hallucinated details from inflating priority scores.

### 6. Graph of Thoughts (GoT)
Besta, M., Blach, N., Kubicek, A., Gerstenberger, R., Gianinazzi, L., Gajber, J., et al. (2023). "Graph of Thoughts: Solving Elaborate Problems with Large Language Models." AAAI 2024. arXiv:2308.09687. https://arxiv.org/abs/2308.09687

Generalizes CoT/ToT into arbitrary directed graphs where thoughts branch, merge, and loop. Models complex reasoning dependencies linear structures cannot capture.

**ATOM usage:** Gap dependency mapping — gaps can depend on, conflict with, or subsume others. Graph identifies root-cause vs. symptom gaps. See Section 7 for notation.

### 7. Chain of Verification (CoVe)
Dhuliawala, S., Komeili, M., Xu, J., Raileanu, R., Li, X., Celikyilmaz, A., & Weston, J. (2023). "Chain-of-Verification Reduces Hallucination in Large Language Models." Meta AI. ACL 2024. arXiv:2309.11495. https://arxiv.org/abs/2309.11495

Model generates answer, generates verification questions, independently answers them, revises based on inconsistencies. Reduces hallucination by up to 50%.

**ATOM usage:** Operate loop — after generating a gap, generates 3-5 verification questions, answers by re-reading source, revises if inconsistencies found.

### 8. DiVeRSe
Li, Y., Lin, Z., Zhang, S., Fu, Q., Chen, B., Lou, J., & Chen, W. (2022). "Making Language Models Better Reasoners with Step-Aware Verifier." ACL 2023. arXiv:2206.02336. https://arxiv.org/abs/2206.02336

Generates diverse reasoning paths, uses step-aware verifier to score each at every intermediate step. Catches errors early in chains.

**ATOM usage:** Merge loop (Phase 4) — when perspectives conflict, step verification identifies which reasoning path has the earliest error.

### 9. Multi-Agent Debate
Du, Y., Li, S., Torralba, A., Tenenbaum, J. B., & Mordatch, I. (2023). "Improving Factuality and Reasoning in Language Models through Multiagent Debate." ICML 2024. arXiv:2305.14325. https://arxiv.org/abs/2305.14325

Multiple LLM instances debate across rounds, converging on more accurate answers through iterative argumentation.

**ATOM usage:** Merge loop dialectical synthesis — gap argued FOR and AGAINST by reasoning personas, judge synthesizes verdict.

### 10. Faithful Chain-of-Thought
Lyu, Q., Havaldar, S., Stein, A., Zhang, L., Rao, D., Wong, E., Apidianaki, M., & Callison-Burch, C. (2023). "Faithful Chain-of-Thought Reasoning." IJCNLP-AACL 2023. arXiv:2301.13379. https://arxiv.org/abs/2301.13379

Decomposes reasoning into symbolic translation then deterministic solving. Ensures faithfulness to stated logic rather than pattern-matching intuitions.

**ATOM usage:** Test loop — gap claims translated to symbolic logic (P => Q) and evaluated for validity. See Section 8 for examples.

### 11. Constitutional AI (CAI)
Bai, Y., Kadavath, S., Kundu, S., Askell, A., et al. (2022). "Constitutional AI: Harmlessness from AI Feedback." Anthropic. arXiv:2212.08073. https://arxiv.org/abs/2212.08073

Establishes explicit principles for self-evaluation and revision, enabling scalable self-alignment without per-output human feedback.

**ATOM usage:** Quality gates as constitutional layer — every finding must satisfy principles (evidence-based, actionable, non-duplicative, correctly scoped) before passing to final report.

### 12. RAP (Reasoning via Planning)
Hao, S., Gu, Y., Ma, H., Hong, J., Wang, Z., Wang, D., & Hu, Z. (2023). "Reasoning with Language Model is Planning with World Model." EMNLP 2023. arXiv:2305.14992. https://arxiv.org/abs/2305.14992

Repurposes LLM as world model + reasoning agent, using MCTS to explore reasoning space. Outperforms CoT on math and plan generation.

**ATOM usage:** Discover loop — evaluates expected information gain of each method per gap type, selects optimal analysis plan.

### 13. Buffer of Thoughts (BoT)
Yang, L., Yu, Z., Zhang, T., Cao, S., Xu, M., Gonzalez, J. E., & Cui, B. (2024). "Buffer of Thoughts: Thought-Augmented Reasoning with Large Language Models." NeurIPS 2024 Spotlight. arXiv:2406.04271. https://arxiv.org/abs/2406.04271

Maintains library of reusable thought templates from previous reasoning. Retrieves and instantiates relevant templates, improving accuracy while reducing tokens 2-5x.

**ATOM usage:** Buffer of proven gap-analysis patterns from previous audits, instantiated with codebase-specific details for speed and consistency.

### 14. Reflexion
Shinn, N., Cassano, F., Gopinath, A., Narasimhan, K., & Yao, S. (2023). "Reflexion: Language Agents with Verbal Reinforcement Learning." NeurIPS 2023. arXiv:2303.11366. https://arxiv.org/abs/2303.11366

Converts feedback into verbal self-reflections stored in episodic memory. Agent conditions on reflections to avoid repeating mistakes.

**ATOM usage:** Post-audit reflections — which gaps confirmed vs. rejected, which methods most valuable, which severities recalibrated. Feeds into next Discover phase.

### 15. Absolute Zero
Zhao, A., et al. (2025). "Absolute Zero: Reinforced Self-play Reasoning with Zero Data." NeurIPS 2025 Spotlight. arXiv:2505.03335. https://arxiv.org/abs/2505.03335

LLMs improve reasoning through pure self-play without human-curated data. Generates own tasks, solves, verifies, reinforces.

**ATOM usage:** Aspirational end-state — self-improving audit that generates test cases, discovers gap categories, and refines methods through self-play.

### 16. Self-Consistency
Wang, X., Wei, J., Schuurmans, D., Le, Q., Chi, E., Narang, S., et al. (2022). "Self-Consistency Improves Chain of Thought Reasoning in Language Models." ICLR 2023. arXiv:2203.11171. https://arxiv.org/abs/2203.11171

Samples multiple diverse reasoning paths, selects most consistent answer via majority voting. Significantly improves over single-path CoT.

**ATOM usage:** Test loop severity calibration — 3 independent severity assessments, majority vote for stable, reproducible scores.

### 17. CRITIC
Gou, Z., Shao, Z., Gong, Y., Shen, Y., Yang, Y., Duan, N., & Chen, W. (2023). "CRITIC: Large Language Models Can Self-Correct with Tool-Interactive Critiquing." arXiv:2305.11738. https://arxiv.org/abs/2305.11738

LLMs verify outputs by interacting with external tools (code interpreters, search). Iteratively refines responses based on tool feedback.

**ATOM usage:** Test loop tool-interactive verification — gap claims checked by actually reading referenced files and verifying claimed conditions.

---

## Tier 2 — Philosophical Foundations Citations

### 18. First Principles Reasoning
**Classical:** Aristotle. *Metaphysics*, Book I (c. 350 BCE).
**Modern:** Musk engineering methodology — decompose to fundamental truths, reason up.

**ATOM usage:** Discover loop first phase — strips assumptions about conventions, asks "What fundamental requirements must this system satisfy?"

### 19. Abductive Reasoning
**Classical:** Peirce, C. S. (1903). *Lectures on Pragmatism*. Harvard University.
**Modern:** Pan et al. (2023). "Logic-LM." arXiv:2307.10250. Bao et al. (2025). "Abductive Reasoning in LLMs." arXiv:2601.02771.

**ATOM usage:** When multiple explanations exist (intentional design vs. oversight vs. debt), selects most probable given all evidence.

### 20. Falsificationism
**Classical:** Popper, K. (1959). *The Logic of Scientific Discovery*. Routledge.
**Modern:** Gao & Zhang (2025). arXiv:2502.09858. Li & Chen (2025). arXiv:2601.02380.

**ATOM usage:** Test loop core — every gap subjected to active falsification. Gaps that cannot survive are demoted. Single most important QC mechanism.

### 21. Dialectical Synthesis
**Classical:** Hegel, G. W. F. (1807). *Phenomenology of Spirit*.
**Modern:** Microsoft Research (2025). "Dialectical Reasoning in Multi-Agent Systems." arXiv:2501.14917.

**ATOM usage:** Merge loop core — gap argued FOR (thesis) and AGAINST (antithesis), synthesis resolves. See Section 9.

### 22. Socratic Elenchus
**Classical:** Plato. *Meno* and *Theaetetus* (c. 380 BCE).
**Modern:** Chang, E. Y. (2023). "Prompting Large Language Models with the Socratic Method." arXiv:2303.08769.

**ATOM usage:** Discover loop — challenges initial hypotheses via recursive questioning. See Section 10.

### 23. Bayesian Updating
**Classical:** Bayes, T. (1763). "An Essay towards Solving a Problem in the Doctrine of Chances." *Phil. Trans. Royal Society*, 53, 370-418.
**Modern:** Nature Communications (2025). Feng & Zhang (2025). arXiv:2503.17523.

**ATOM usage:** Gap confidence as Bayesian priors updated through each phase. See Section 11.

### 24. Causal Inference
**Classical:** Pearl, J. (2009). *Causality* (2nd ed.). Cambridge University Press.
**Modern:** Zhang & Li (2024). arXiv:2410.16676. NAACL 2025 Workshop on Causal Inference and NLP.

**ATOM usage:** Determines causal vs. correlational gap relationships using Pearl's ladder. See Section 12.

### 25. Analogical Transfer
**Classical:** Gentner, D. (1983). "Structure-Mapping: A Theoretical Framework for Analogy." *Cognitive Science*, 7(2), 155-170.
**Modern:** Hu & Lee (2023). arXiv:2310.01714. ACM CHI 2023 Workshop on Analogy-Based Design.

**ATOM usage:** Maps gaps from one component to structurally similar components. See Section 13.

### 26. Second-Order Effects
**Source:** Meadows, D. (2008). *Thinking in Systems*. Chelsea Green. Also: Doteveryone (2019) consequence scanning.

**ATOM usage:** After primary gaps, traces cascading failures: "If exploited, what cascading effects?" Transforms static severity to dynamic impact.

### 27. Emergence Detection
**Source:** Holland, J. H. (1998). *Emergence*. Addison-Wesley. *Complexity* Journal (2017), BKB framework.

**ATOM usage:** Merge loop — checks whether individually minor gaps create emergent risk that no single gap represents.

---

## Tier 3 — Engineering Frameworks Citations

### 28. Morphological Analysis
Zwicky, F. (1969). *Discovery, Invention, Research through the Morphological Approach*. Macmillan.

**ATOM usage:** Discover loop — constructs matrix of system dimensions x component types, checks each cell for gaps.

### 29. Pre-Mortem Analysis
Klein, G. (2007). "Performing a Project Premortem." *Harvard Business Review*, 85(9), 18-19.

**ATOM usage:** Test loop — "Assume critical production incident occurred. What was root cause?" Generates hypotheses from failure-backward perspective.

### 30. Negative Space Analysis
Derived from art theory (space around subjects) and engineering fault analysis (studying what is absent).

**ATOM usage:** Analyzes what is NOT present: missing tests, absent error handling, undocumented APIs, missing security headers.

### 31. TRIZ
Altshuller, G. (1984). *Creativity as an Exact Science*. Gordon and Breach.

**ATOM usage:** When gap resolution involves contradictions (security vs. performance), consults TRIZ matrix for proven strategies. See Section 4.

### 32. FMEA
MIL-STD-1629A (1980). ISO 31010:2019.

**ATOM usage:** Every gap receives RPN = Severity x Likelihood x Detectability. See Section 5.

### 33. Industry Standards
OWASP Top 10 (2021), DORA (2023), ISO 27001:2022, NIST CSF 2.0, SLSA v1.0, CIS Benchmarks.

**ATOM usage:** Baseline expectations — a gap is only a gap if it deviates from established standards.

### 34. Theory of Constraints
Goldratt, E. M. (1984). *The Goal*. North River Press.

**ATOM usage:** Merge loop prioritization — identifies which gap resolution yields greatest system-level improvement.

### 35. MAP-Elites
Mouret, J.-B. & Clune, J. (2015). "Illuminating search spaces by mapping elites." arXiv:1504.04909.

**ATOM usage:** Remediation diversity — recommendations span different approaches, costs, and complexity tiers.

### 36-37. Self-Consistency & CRITIC
Cross-reference Tier 1 entries #16 and #17. In Tier 3 context: engineering verification (multiple passes must converge) and tool-assisted checking (claims verified against actual files).

---

## Section 4: TRIZ 40 Inventive Principles — Software Applications

| # | Principle | Software Application |
|---|-----------|---------------------|
| 1 | Segmentation | Decompose monoliths into microservices |
| 2 | Taking out | Extract cross-cutting concerns into middleware |
| 3 | Local quality | Environment-specific configs; feature flags per region |
| 4 | Asymmetry | Read vs. write optimized stores; asymmetric encryption |
| 5 | Merging | Combine related endpoints; merge redundant services |
| 6 | Universality | Generic handlers; polymorphic interfaces |
| 7 | Nested doll | Layered architecture; middleware chains; decorator pattern |
| 8 | Anti-weight | Caching to offset computation; CDNs to offset latency |
| 9 | Preliminary anti-action | Input validation before processing; circuit breakers |
| 10 | Preliminary action | Prefetching; warm pools; connection pooling |
| 11 | Beforehand cushioning | Graceful degradation; fallback services; retry with backoff |
| 12 | Equipotentiality | Load balancing; horizontal scaling; consistent hashing |
| 13 | The other way round | Event-driven instead of polling; push instead of pull |
| 14 | Spheroidality | Fuzzy matching; approximate algorithms |
| 15 | Dynamics | Auto-scaling; dynamic config; adaptive rate limiting |
| 16 | Partial/excessive action | Feature flags (partial rollout); over-provisioning |
| 17 | Another dimension | Caching layer; read replicas; CQRS |
| 18 | Mechanical vibration | Health checks; heartbeats; periodic GC |
| 19 | Periodic action | Cron jobs; batch processing; maintenance windows |
| 20 | Continuity of useful action | Connection keep-alive; persistent workers; streaming |
| 21 | Skipping | Fast-path optimization; short-circuit evaluation |
| 22 | Blessing in disguise | Chaos engineering; error budgets |
| 23 | Feedback | Monitoring/alerting; A/B testing; canary deployments |
| 24 | Intermediary | API gateways; message queues; proxy pattern |
| 25 | Self-service | Self-healing systems; auto-remediation |
| 26 | Copying | Replication; mirroring; blue-green deployments |
| 27 | Cheap short-living | Ephemeral containers; serverless; disposable environments |
| 28 | Mechanics substitution | Webhooks over polling; async over sync |
| 29 | Pneumatics/hydraulics | Backpressure; flow control; buffer management |
| 30 | Flexible shells | Thin API layers; adapter pattern; anti-corruption layers |
| 31 | Porous materials | Rate limiting; content-based routing |
| 32 | Color changes | Log levels; semantic versioning; status indicators |
| 33 | Homogeneity | Consistent tech stack; uniform standards; monorepo |
| 34 | Discarding/recovering | Immutable infrastructure; rollback; snapshots |
| 35 | Parameter changes | Dynamic configuration; env vars; feature toggles |
| 36 | Phase transitions | State machines; workflow engines; saga pattern |
| 37 | Thermal expansion | Auto-scaling on load; elastic resources |
| 38 | Strong oxidants | Aggressive caching; precomputation; materialized views |
| 39 | Inert atmosphere | Sandboxing; containerization; network segmentation |
| 40 | Composite materials | Polyglot persistence; hybrid cloud |

---

## Section 5: FMEA Scale Definitions

### Severity (1-10)
| Score | Level | Description |
|-------|-------|-------------|
| 1 | None | No discernible effect |
| 2 | Very minor | Degradation noticed only by experts |
| 3 | Minor | Small reduction; easy workaround |
| 4 | Very low | Noticeable degradation; workaround available |
| 5 | Low | Reduced functionality; user dissatisfied |
| 6 | Moderate | Subsystem inoperable; significant impact |
| 7 | High | Primary function severely affected |
| 8 | Very high | System inoperable, no security breach |
| 9 | Critical | Inoperable with potential security breach |
| 10 | Catastrophic | Complete failure; data loss or breach |

### Likelihood (1-10)
| Score | Level | Description |
|-------|-------|-------------|
| 1 | Eliminated | Cannot be triggered (formal proof) |
| 2 | Remote | Theoretically possible, never observed |
| 3 | Very low | Isolated occurrence in similar systems |
| 4 | Low | Occasional occurrence in similar systems |
| 5 | Moderate | Expected to occur occasionally |
| 6 | Moderately high | Expected to occur frequently |
| 7 | High | Repeated occurrences expected |
| 8 | Very high | Almost certain to manifest |
| 9 | Extremely high | Already manifested in testing |
| 10 | Certain | Actively being exploited or failing |

### Detectability (1-10)
| Score | Level | Description |
|-------|-------|-------------|
| 1 | Almost certain | Automated detection, proven reliability |
| 2 | Very high | Automated detection likely to catch |
| 3 | High | Standard code review catches it |
| 4 | Moderately high | Focused code review catches it |
| 5 | Moderate | Dedicated testing catches it |
| 6 | Low | Specialized security audit needed |
| 7 | Very low | Expert manual analysis required |
| 8 | Remote | Only under specific runtime conditions |
| 9 | Very remote | Production load or edge-case inputs needed |
| 10 | Undetectable | Only found via incident occurrence |

**RPN** = Severity x Likelihood x Detectability (range 1-1000).
Thresholds: >200 Critical, >100 High, >50 Medium, <=50 Low.

---

## Section 6: Self-Discover Reasoning Module Catalog

| Module | Description |
|--------|-------------|
| Critical Thinking | Evaluate arguments, identify assumptions, assess evidence |
| Creative Thinking | Novel perspectives, unconventional connections |
| Decomposition | Break complex problems into sub-problems |
| Abstraction | Identify high-level patterns and principles |
| Analogical Reasoning | Map solutions from similar domains |
| Causal Analysis | Trace cause-effect relationships |
| Counterfactual Thinking | "What if" scenarios and alternative outcomes |
| Constraint Satisfaction | Identify and resolve competing requirements |
| Pattern Recognition | Detect recurring structures and anti-patterns |
| Risk Assessment | Evaluate probability and impact of failures |
| Systems Thinking | Analyze interactions and emergent behaviors |
| Temporal Reasoning | Sequencing, timing, lifecycle effects |
| Adversarial Thinking | Attacker perspective for exploitable weaknesses |
| Stakeholder Analysis | Impact on different user/developer populations |
| Comparative Analysis | Evaluate against benchmarks and standards |

Model selects 2-5 modules per gap based on nature and complexity.

---

## Section 7: Graph of Thoughts Notation Guide

### Node Types
```
[G-001]    Gap node (square brackets)
(E-001)    Evidence node (parentheses)
{D-001}    Decision node (curly braces)
<M-001>    Method node (angle brackets)
```

### Edge Types
```
[G-001] --> [G-002]     Causal dependency (G-001 causes G-002)
[G-001] --- [G-002]     Correlation (co-occur, no causal link)
[G-001] ==> [G-002]     Subsumption (G-001 includes G-002)
[G-001] <-> [G-002]     Conflict (mutually exclusive)
(E-001) --> [G-001]     Evidence supports gap
(E-001) --x [G-001]     Evidence falsifies gap
```

### Operations
```
[G-001] + [G-002] => [G-003]     Merge two gaps into one
[G-001] / => [G-001a] [G-001b]   Split one gap into two
[G-001] --> <M-001> --> [G-001']  Method refines gap (prime = refined)
```

### Example
```
(E-001: no rate limiter) --> [G-001: Missing Rate Limiting]
(E-002: no auth on /admin) --> [G-002: Missing Authentication]
[G-001] --> [G-003: API Abuse Risk]
[G-002] --> [G-003: API Abuse Risk]
[G-001] + [G-002] ==> [G-004: Insufficient API Security]
```

---

## Section 8: Faithful CoT Symbolic Logic Examples

### Example 1: Missing Input Validation
```
P = "endpoint accepts raw user input"
Q = "no validation middleware applied"
R = "injection attack possible"
Claim: (P AND Q) => R
Verify: P [check handler], Q [check middleware], R [check ORM protection]
```

### Example 2: Authentication Bypass
```
P = "route /admin exists"
Q = "no auth guard on /admin"
R = "unauthenticated admin access possible"
Claim: (P AND Q) => R
Verify: P [check router], Q [check guards/middleware], R [check proxy filters]
```

### Example 3: Data Loss Risk
```
P = "system stores persistent data"
Q = "no automated backup exists"
S = "no replication configured"
R = "data loss risk present"
Claim: (P AND Q AND S) => R
Verify: All three must be TRUE for claim to hold.
```

---

## Section 9: Dialectical Debate Protocol Template

### Round 1: Thesis (FOR the gap)
```
POSITION: Gap [ID] IS a real, significant finding.
ARGUMENT:
1. Evidence: [cite specific files, lines, configurations]
2. Standard violated: [cite industry standard]
3. Impact if unaddressed: [concrete failure scenario]
4. Prevalence: [how widespread in codebase]
SEVERITY CLAIM: [Showstopper / Critical / High / Medium / Low]
CONFIDENCE: [0.0 - 1.0]
```

### Round 2: Antithesis (AGAINST the gap)
```
POSITION: Gap [ID] is NOT real, or is overstated.
COUNTER-ARGUMENTS:
1. Mitigating factor: [existing mechanism that partially addresses this]
2. Context dismissal: [why standard doesn't apply here]
3. Cost-benefit: [cost of fix outweighs risk]
4. Alternative explanation: [pattern is intentional]
REVISED SEVERITY: [Lower than thesis]
CONFIDENCE: [0.0 - 1.0]
```

### Round 3: Synthesis (Resolution)
```
RESOLUTION:
Thesis strengths: [which arguments held up]
Antithesis strengths: [which counters held up]
FINDING:
- Real gap? [YES / NO / PARTIAL]
- Revised description: [incorporating both sides]
- Final severity: [calibrated between thesis and antithesis]
- Final confidence: [weighted by argument strength]
- Key caveat: [remaining uncertainty]
```

---

## Section 10: Socratic Questioning Chain Template

```
Q1: CLARIFICATION — "What exactly do you mean by [gap claim]?"
    -> If vague: "State this more precisely."
    -> If clear: proceed to Q2.

Q2: EVIDENCE — "What evidence supports this?"
    -> If indirect: "Is there direct evidence?"
    -> If single source: "Is there corroboration?"
    -> If none: DEMOTE confidence significantly.

Q3: COUNTER — "What would someone who disagrees say?"
    -> If strong counter: "Can you refute it?"
    -> If no counter: gap likely valid.

Q4: IMPLICATION — "If real, what follows?"
    -> Severe consequences: elevate severity.
    -> Trivial consequences: demote severity.

Q5: META — "Why does this matter? What is the deeper issue?"
    -> Often reveals shared root cause across surface gaps.
```

---

## Section 11: Bayesian Confidence Calibration Guide

### Initial Priors
| Evidence Level | P(real) |
|---------------|---------|
| Direct code evidence (file:line) | 0.85 - 0.95 |
| Configuration/manifest evidence | 0.75 - 0.85 |
| Inferred from architecture | 0.50 - 0.70 |
| Inferred by analogy | 0.30 - 0.50 |
| Speculative / no evidence | 0.10 - 0.30 |

### Update Heuristics
```
Strong confirming evidence:    P += 0.15 (cap 0.99)
Weak confirming evidence:      P += 0.05
Neutral evidence:              unchanged
Weak disconfirming evidence:   P -= 0.10
Strong disconfirming evidence: P -= 0.25 (floor 0.01)
```

Calibration target: gaps with P > 0.8 confirmed 80%+ by human review.
Minimum reporting threshold: P >= 0.6.

---

## Section 12: Pearl's Causal Ladder Worked Example

**Scenario:** "Missing error handling in payment service correlates with checkout failures."

### Rung 1: Association (Seeing)
```
Observe: No try-catch around Stripe API calls.
Observe: 3.2% checkout failure rate (above 1% benchmark).
P(failure | no handling) > P(failure | handling). Association exists.
```

### Rung 2: Intervention (Doing)
```
If we ADD error handling, would failures decrease?
- Stripe returns: card_declined, expired_card, processing_error, network_error
- Without handling: any error -> unhandled exception -> 500 to client
- With handling: card errors -> 400 with guidance; transient -> retry
- Estimate: 3.2% -> ~1.1%
```

### Rung 3: Counterfactual (Imagining)
```
If handling HAD existed from start, would 3.2% have occurred?
- Stripe baseline: 0.8% declines + 0.3% transient = ~0.85% with handling
- Gap CAUSES 2.35% excess failures (3.2% - 0.85%)
- Causal link CONFIRMED. Priority: HIGH.
```

---

## Section 13: Analogical Mapping Template

```
ANALOGICAL MAPPING

Source domain:  [component where gap was found]
Target domain:  [component being checked]

Structural alignment:
  Source A  <-->  Target A'
  Source B  <-->  Target B'
  Source R(A,B) <--> Target R(A',B')

Gap in source:       [description]
Analogous hypothesis: [predicted gap in target]

Confidence:
  Structural similarity:  [High / Medium / Low]
  Functional similarity:  [High / Medium / Low]
  Context similarity:     [High / Medium / Low]
  Transfer confidence:    [0.0 - 1.0]

Verification needed:  [specific checks]
Disanalogies:         [ways target differs]
```

### Worked Example
```
Source: UserController (missing validation on POST /users)
Target: OrderController (same CRUD pattern)

Alignment:
  UserController.create()  <-->  OrderController.create()
  UserDTO                  <-->  OrderDTO
  No ValidationPipe        <-->  No ValidationPipe (?)

Hypothesis: POST /orders also lacks schema validation.
Transfer confidence: 0.75 (same pattern, same framework)
Verify: Check OrderController.create() for ValidationPipe or manual validation.
Disanalogy: Orders may have payment gateway validation that implicitly validates fields.
```

---

*End of ATOM Protocol Research Foundations. Update as new methods are integrated or papers superseded.*
