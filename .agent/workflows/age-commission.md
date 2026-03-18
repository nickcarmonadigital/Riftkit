---
description: Commission an ATOM (Axiomatic Thinking for Omnidirectional Meta-analysis) study on a topic.
---

# WORKFLOW: Commission ATOM Analysis

**Purpose**: Launch a 53-loop, 51-method deep-dive discovery analysis on any complex topic using the ATOM protocol.

## 1. Prerequisites

- [ ] Define the [Topic] clearly (e.g., "AI Agent Security Architecture", "E-commerce Platform Gaps").
- [ ] Ensure `memory/gaps.log` is empty (or back up the previous run).
- [ ] Check for previous ATOM runs on this topic:
  - [ ] Read `memory/atom-templates.md` (Buffer of Thoughts from prior runs)
  - [ ] Read `memory/atom-reflexions.md` (Reflexion lessons from prior runs)
  - [ ] If found, these will be prepended to the analysis context for faster convergence.

## 2. Commissioning

Run the following prompt:

```
Using the ATOM protocol (age skill): Commission a 53-loop study on [Topic].

Execute all 7 phases:
- Phase 1 (AXIOMS): First Principles decomposition, Step-Back abstraction, Self-Discover module selection, Morphological space enumeration
- Phase 2 (HUNT): 12 discovery methods including RT-ICA, Abductive, Socratic, Pre-Mortem, Negative Space, Contrastive, Analogical, TRIZ, Standards, Failure Modes, Second-Order Cascade, Cumulative Evidence + Bayesian
- Phase 3 (VALIDATE): FMEA scoring, Chain of Verification, DiVeRSe, Dialectical Debate, Falsification, Causal Inference, Faithful CoT, Constitutional check
- Phase 4 (SOLVE): Solution specs, Graph of Thoughts branching, RAP/MCTS search, Theory of Constraints
- Phase 5 (SYNTHESIZE): Deduplicate, MAP-Elites coverage, Final prioritized report
- Phase 6 (CACHE): Extract reusable templates to memory/atom-templates.md
- Phase 7 (EVOLVE): Reflexion, CRITIC self-critique, Absolute Zero self-play

All gaps must satisfy the 8-article ATOM Constitution.
Output: synthesized-gaps.md, maturity-scorecard.md, causal-model.md, epistemic-map.md
```

## 3. Agent Team Configuration

For Claude Code Agent Teams, create a team with 5+ agents:

```
Create an agent team for an ATOM analysis:
- 1 Axiom agent: First Principles decomposition, Step-Back abstraction, Morphological enumeration
- 2-3 Hunter agents: Run discovery loops 5-16 in parallel (split by method type)
- 1 Validator agent: Run all 8 verification methods in Phase 3
- 1 Solver/CEO agent: Solution specs, synthesis, deduplication, final report
```

## 4. Review & Outputs

- [ ] Watch findings accumulate in `memory/gaps.log`.
- [ ] Review enhanced gap log entries (FMEA scores, Bayesian confidence, causal structure).
- [ ] Review final outputs:
  - `synthesized-gaps.md` — Prioritized gap report with solutions
  - `maturity-scorecard.md` — Overall maturity assessment
  - `causal-model.md` — Causal DAG of gap relationships
  - `epistemic-map.md` — Known Knowns / Known Unknowns / Unknown Unknowns
- [ ] Review MAP-Elites coverage grid for blind spots.
- [ ] Review Epistemic Humility report for documented uncertainty.
- [ ] Decide which gaps to address using the ATOM-to-Skill Pipeline.

## 5. Post-Run

- [ ] Verify `memory/atom-templates.md` was updated (Phase 6 CACHE).
- [ ] Verify `memory/atom-reflexions.md` was updated (Phase 7 EVOLVE).
- [ ] If running again on same topic, previous templates and reflexions will automatically improve the next run.

## 6. Quality Gates

Every gap in the final report must satisfy:
- [ ] All 8 Constitutional Articles (Evidence, Quantification, Faithful Reasoning, Actionability, Uniqueness, Cross-Impact, Adversarial Survival, Falsifiability)
- [ ] FMEA RPN score calculated (Severity x Likelihood x (10-Detectability))
- [ ] Bayesian P(real) confidence level assigned
- [ ] Causal structure documented (Pearl's three rungs)
- [ ] Falsification experiment designed
- [ ] At least one adversarial challenge survived (Dialectical Debate or DiVeRSe)
