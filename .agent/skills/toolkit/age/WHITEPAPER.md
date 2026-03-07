# ATOM: Axiomatic Thinking for Omnidirectional Meta-analysis

## A 37-Loop Multi-Method Reasoning Protocol for Systematic Discovery

---

**Authors:** N. Carmona et al.

**Date:** March 2026

**Version:** 1.0

**Status:** Methodology Paper (Pre-Empirical)

---

## Table of Contents

1. [Abstract](#1-abstract)
2. [Introduction and Motivation](#2-introduction-and-motivation)
3. [Related Work](#3-related-work)
4. [Problem Statement](#4-problem-statement)
5. [The ATOM Protocol](#5-the-atom-protocol)
6. [Method Selection Rationale](#6-method-selection-rationale)
7. [The Evolution Story](#7-the-evolution-story)
8. [The ATOM Constitution](#8-the-atom-constitution)
9. [Self-Improvement Mechanism](#9-self-improvement-mechanism)
10. [Experimental Design](#10-experimental-design)
11. [Limitations and Future Work](#11-limitations-and-future-work)
12. [Conclusion](#12-conclusion)
13. [References](#13-references)

---

## 1. Abstract

Modern AI assistants excel at building what is explicitly requested but fundamentally
lack the capacity for systematic discovery of what is missing. This paper presents
ATOM (Axiomatic Thinking for Omnidirectional Meta-analysis), a 37-loop,
35-method reasoning protocol designed to treat gap discovery as a meta-reasoning
problem: the systematic analysis OF analysis itself. ATOM integrates methods
from three distinct research domains: AI and machine learning research (15 methods),
philosophical reasoning traditions (10 methods), and engineering analysis
frameworks (10 methods). The protocol is organized into seven sequential phases:
AXIOMS (foundational decomposition), HUNT (multi-method discovery), VALIDATE
(adversarial verification), SOLVE (solution specification), SYNTHESIZE
(deduplication and ranking), CACHE (cross-run template extraction), and EVOLVE
(self-improvement through reflection and self-play).

Key innovations of the ATOM protocol include: (1) the placement of First
Principles decomposition as the foundational Loop 1, ensuring all subsequent
analysis proceeds from irreducible truths rather than inherited assumptions;
(2) a multi-method adversarial verification phase employing eight distinct
methods to eliminate false positives; (3) a self-improvement mechanism
combining Reflexion, CRITIC, and Absolute Zero to enable quality improvement
across successive runs without gradient updates; and (4) an eight-article
epistemic constitution providing machine-verifiable quality gates for every
gap claim. The protocol treats each reasoning method as addressing a specific
failure mode of analysis, such that the combination provides coverage that no
single method can achieve. We present the complete protocol specification,
formal problem definition, method selection rationale, and proposed
experimental design for empirical validation. Expected improvements include
higher gap coverage relative to single-method approaches, a substantially
lower false positive rate through adversarial verification, and monotonically
improving quality across successive runs through the self-improvement
mechanism.

---

## 2. Introduction and Motivation

### 2.1 The Blind Spot Problem

There exists a fundamental asymmetry in how AI systems assist with complex
work. Given an explicit instruction, a well-configured language model can
produce code, documentation, architecture, and strategy of remarkable quality.
The problem is not in what the model builds. The problem is in what the model
does not know to build.

This is the blind spot problem: AI systems construct what is asked for but
lack a systematic methodology for discovering what should have been asked for
in the first place. The consequences of this asymmetry are severe. In software
engineering, undiscovered gaps in security, scalability, and error handling
account for a disproportionate share of production incidents. In business
strategy, the gaps that are never identified are precisely the ones that
enable competitors to gain decisive advantages. In scientific research,
unknown unknowns represent the boundary between incremental progress and
paradigm-shifting discovery.

The blind spot problem is not unique to AI. Human analysts, auditors, and
reviewers suffer from the same fundamental limitation. However, AI systems
amplify the problem because their outputs carry an implicit authority that
discourages further questioning. When a language model produces a
comprehensive-looking analysis, the human recipient is less likely to ask
"what did this analysis miss?" than they would be when reviewing a human
colleague's work.

### 2.2 Why Current Approaches Fail

Several approaches to gap discovery exist in current practice, and each
suffers from characteristic failure modes.

**Checklists** are the most common approach. A domain expert compiles a list
of items to verify, and the analyst works through them sequentially. Checklists
suffer from two fundamental limitations. First, they cannot discover novel
gaps that fall outside the checklist author's experience. A security checklist
written in 2020 will not include attack vectors discovered in 2024. Second,
checklists create anchoring bias: the analyst's attention is drawn to
checklist items and away from phenomena that do not fit any checklist category.

**Single-method analysis** applies one reasoning framework (such as FMEA, or
red teaming, or Socratic questioning) to the target. Each method has specific
blind spots. FMEA excels at identifying failure modes in known components but
cannot discover missing components. Red teaming excels at adversarial
scenarios but tends to overlook non-adversarial gaps such as usability or
documentation. Socratic questioning excels at excavating hidden assumptions
but provides no mechanism for quantifying severity.

**Manual expert audits** combine domain expertise with professional judgment.
They are expensive, inconsistent across auditors, non-reproducible, and
fundamentally limited by the auditor's individual experience and cognitive
biases. Two auditors reviewing the same system routinely produce divergent
findings, not because one is wrong, but because each is limited by their own
particular blind spots.

**LLM-based review** asks a language model to "find gaps" in a given target.
This approach suffers from confirmation bias (the model tends to validate the
overall structure while suggesting minor additions), hallucinated gaps (the
model invents plausible-sounding but non-existent problems), and the absence
of any verification mechanism to distinguish real gaps from fabricated ones.

### 2.3 The Thesis

This paper proposes that combining proven reasoning methods from three
distinct research domains --- AI/ML research, philosophical reasoning
traditions, and engineering analysis frameworks --- creates a discovery engine
that systematically exceeds the coverage of any single method. The key insight
is that each reasoning method addresses a different failure mode of analysis.
First Principles decomposition addresses the failure to question assumptions.
Falsification addresses the failure to test claims. Causal inference addresses
the failure to distinguish correlation from causation. By composing methods
that address orthogonal failure modes, the protocol achieves coverage that no
individual method can provide.

A second critical insight, which we term the "Ralph Wiggum Protocol," is that
certain analysis loops must operate with zero prior context to prevent
anchoring bias. When an analyst has already identified several gaps, subsequent
analysis is unconsciously shaped by those findings. By running specific loops
without access to previous results, the protocol ensures that each method
operates from a fresh cognitive starting point.

A third insight is that First Principles decomposition, in the Aristotelian
sense of identifying "the first basis from which a thing is known," must serve
as the foundation of the entire protocol rather than appearing as one method
among many. All subsequent analysis proceeds from the irreducible truths
established in the first loop.

The remainder of this paper presents the complete ATOM protocol, its
theoretical foundations, the rationale for method selection, the story of its
evolution from a simpler predecessor, and a proposed experimental design for
empirical validation.

---

## 3. Related Work

The ATOM protocol draws on five streams of research. This section surveys each
stream, identifies the key contributions that inform ATOM's design, and
explains how ATOM extends beyond the current state of each field.

### 3.1 LLM Reasoning Enhancement

The past three years have seen an explosion of work on enhancing the reasoning
capabilities of large language models through structured prompting and
multi-step inference.

**Chain-of-Thought prompting** (Wei et al. 2022) demonstrated that eliciting
intermediate reasoning steps dramatically improves performance on arithmetic,
commonsense, and symbolic reasoning tasks. The key insight --- that models
reason better when forced to show their work --- is foundational to ATOM's
design. However, Chain-of-Thought provides no mechanism for verifying the
quality of intermediate steps, nor does it guard against post-hoc
rationalization, where the model generates plausible-sounding reasoning that
does not actually support the conclusion.

**Tree of Thoughts** (Yao et al. 2023) extended Chain-of-Thought by allowing
the model to explore multiple reasoning paths simultaneously, using search
algorithms (BFS, DFS) to navigate the tree of possibilities. Tree of Thoughts
addresses the single-path limitation of Chain-of-Thought but is subsumed by
the more general Graph of Thoughts framework that ATOM employs.

**Graph of Thoughts** (Besta et al. 2023) generalized Tree of Thoughts by
representing the reasoning process as an arbitrary directed graph, enabling
operations such as merging parallel reasoning paths and looping back to
refine earlier conclusions. ATOM uses Graph of Thoughts in its solution
generation phase (Loop 27), where solution candidates are represented as graph
nodes and can be merged, refined, or abandoned based on evaluation.

**Self-Consistency** (Wang et al. 2022) demonstrated that sampling multiple
reasoning paths and selecting the answer via majority vote substantially
improves reliability. ATOM incorporates Self-Consistency in its validation
phase (Loop 24), where multiple independently generated assessments of a gap's
validity are compared for agreement.

**Self-Discover** (Zhou et al. 2024) introduced a meta-reasoning step in
which the model selects its own reasoning structure from a library of
available methods before applying that structure to the task. This is directly
incorporated as ATOM's Loop 3, where the protocol constructs a task-adaptive
reasoning blueprint rather than applying a fixed method sequence.

ATOM goes beyond this body of work by combining multiple reasoning enhancement
methods into a phased architecture where each method serves a specific
function. Rather than treating reasoning enhancement as a standalone
technique, ATOM positions these methods within a systematic discovery
framework where they interact and reinforce each other.

### 3.2 Adversarial Evaluation and Red Teaming

A parallel stream of research has focused on using adversarial techniques to
evaluate and improve the quality of AI-generated outputs.

**Multi-Agent Debate** (Du et al. 2023) showed that having multiple LLM
instances debate a question and challenge each other's reasoning produces more
accurate and better-calibrated answers than single-agent generation. The
mechanism is straightforward: each agent's biases and blind spots are
partially compensated by the other agents' different perspectives. ATOM
incorporates Multi-Agent Debate as part of its dialectical verification
process (Loop 20).

**Constitutional AI** (Bai et al. 2022) introduced the concept of training
AI systems according to a set of explicit principles (a "constitution") that
the system uses to evaluate and revise its own outputs. ATOM adapts this
concept through its eight-article ATOM Constitution (Section 8), which
provides machine-verifiable quality gates for every gap claim.

**Chain of Verification** (Dhuliawala et al. 2023) proposed a method where
the model first generates an answer, then generates verification questions
about that answer, answers those questions independently, and finally revises
the original answer based on the verification results. ATOM employs Chain of
Verification in Loop 18, applying it specifically to gap claims: each claimed
gap generates verification questions that are answered without reference to
the original gap claim.

**Red teaming approaches** in AI safety (Perez et al. 2022; Ganguli et al.
2022) have explored using adversarial prompting to discover failure modes in
AI systems. While these approaches focus on finding failures in AI models
themselves, ATOM generalizes the adversarial principle to gap discovery in
arbitrary targets: the gaps themselves are "red teamed" through multiple
verification methods to ensure they represent genuine findings rather than
false positives.

ATOM goes beyond existing adversarial evaluation work by employing eight
distinct verification methods in Phase 3, creating a verification gauntlet
that is substantially more rigorous than any single adversarial technique. The
design philosophy is that redundancy in verification is a feature: if a gap
claim cannot survive scrutiny from multiple independent angles, it should not
be reported.

### 3.3 Philosophical Reasoning in AI

A growing body of work has explored incorporating philosophical reasoning
traditions into AI systems, motivated by the observation that many reasoning
challenges confronting modern AI were identified and addressed by philosophers
centuries or millennia ago.

**Socratic questioning in LLMs** (Chang 2023) demonstrated that structured
Socratic dialogue can elicit deeper reasoning from language models, forcing
them to examine assumptions, consider alternative viewpoints, and qualify
their claims. ATOM incorporates Socratic questioning as Loop 9, specifically
targeting the excavation of hidden assumptions in both the analysis target
and in the protocol's own intermediate findings.

**Dialectical approaches** (Microsoft Research 2025) have explored using
Hegelian dialectics --- the thesis-antithesis-synthesis triad --- as a
framework for improving AI reasoning through structured opposition. ATOM
employs a full dialectical process in Loop 20, where gap claims serve as
theses, counter-arguments serve as antitheses, and the resolution produces
a synthesis that is more nuanced and accurate than either starting position.

**Abductive reasoning for NLP** has been explored in various contexts,
including natural language inference (Bhagavatula et al. 2020) and
commonsense reasoning (Qiao et al. 2023). Abductive reasoning --- inference
to the best explanation --- is critical for gap discovery because it enables
reasoning from observed symptoms (missing documentation, inconsistent
behavior) to underlying root causes (architectural gaps, design flaws). ATOM
uses abductive reasoning in Loop 7.

**Causal reasoning in LLMs** has been studied through the lens of Pearl's
causal hierarchy (Kiciman et al. 2023; Jin et al. 2024), which distinguishes
three levels of causal reasoning: association (observing correlations),
intervention (predicting effects of actions), and counterfactual (reasoning
about what would have happened under different conditions). ATOM incorporates
causal inference in Loop 22 to distinguish gaps that are root causes from
those that are merely symptoms of deeper issues.

ATOM goes beyond existing work on philosophical reasoning in AI by
incorporating ten distinct philosophical methods as formal protocol
components rather than optional add-ons. These methods are not merely
inspirational analogies; they are operationalized into specific loop
specifications with defined inputs, outputs, and success criteria.

### 3.4 Systems Thinking and Engineering Frameworks

Engineering disciplines have developed rigorous frameworks for systematic
analysis over decades of application in safety-critical industries.

**Failure Mode and Effects Analysis (FMEA)** originated in the US military
in the 1940s and has since become a standard tool in aerospace, automotive,
medical device, and software engineering. FMEA provides a structured method
for identifying potential failure modes, assessing their severity, occurrence
probability, and detectability, and computing a Risk Priority Number (RPN)
for prioritization. ATOM uses FMEA scoring in Loop 17 to quantify gap
severity.

**TRIZ (Theory of Inventive Problem Solving)**, developed by Genrich
Altshuller from analysis of over 40,000 patents, provides systematic methods
for resolving contradictions in engineering design. ATOM uses TRIZ in Loop 12
to express gaps as contradictions (e.g., "the system must be both highly
secure and easy to use") and to identify inventive resolution principles.

**Morphological analysis**, developed by Fritz Zwicky for astrophysics
research and later applied to engineering design, provides a method for
exhaustively enumerating the space of possible configurations by
systematically varying independent parameters. ATOM uses morphological
analysis in Loop 4 to construct a coverage grid that prevents category
blindness --- the failure to discover gaps in categories the analyst has not
considered.

**Theory of Constraints (TOC)**, developed by Eliyahu Goldratt, identifies
the single constraint that limits the throughput of an entire system. ATOM
uses TOC in Loop 30 to identify bottleneck gaps --- the gaps whose resolution
would have the greatest cascading positive effect on the overall system.

**Pre-mortem analysis** (Klein 2007) inverts the typical risk assessment by
asking participants to imagine that a project has already failed and to work
backward to identify the causes. ATOM uses pre-mortem in Loop 13 to discover
gaps by imagining future failure and reasoning about what must have been
missing.

ATOM goes beyond traditional engineering frameworks by applying them to gap
discovery rather than to their original domains (product design, manufacturing,
project management). The key insight is that the analytical rigor these
frameworks provide is domain-general: the same systematic approach that
identifies failure modes in a jet engine can identify gaps in a software
architecture, a business strategy, or a scientific methodology.

### 3.5 Self-Improving AI Systems

A recent stream of research has explored AI systems that improve their own
performance across successive interactions without gradient-based training.

**Reflexion** (Shinn et al. 2023) introduced "verbal reinforcement learning,"
where an agent reflects on its failures, generates natural language feedback,
and uses that feedback to improve subsequent attempts. Reflexion demonstrated
that explicit self-reflection can substitute for traditional reward signals in
improving task performance. ATOM incorporates Reflexion as Loop 35, where the
protocol reflects on its own performance after each complete run.

**Absolute Zero** (Zhao et al. 2025) proposed a self-play framework in which
a model generates its own training challenges at the frontier of its
capability, then learns from attempting to solve them. The "Goldilocks
difficulty" principle ensures challenges are neither too easy (no learning)
nor too hard (no signal). ATOM incorporates Absolute Zero as Loop 37, where
the protocol generates progressively harder gap discovery challenges for
self-improvement.

**Buffer of Thoughts** (Yang et al. 2024) introduced the concept of a
reusable "thought library" --- a collection of high-level reasoning templates
distilled from successful problem-solving episodes. ATOM incorporates Buffer
of Thoughts as Loop 34, where successful discovery patterns are extracted into
reusable templates that accelerate future runs.

**CRITIC** (Gou et al. 2024) proposed a framework in which models interact
with external tools to verify and refine their outputs, using quantitative
metrics rather than qualitative self-assessment. ATOM incorporates CRITIC in
Loop 36, where quantitative metrics (gap count, false positive rate, coverage
delta) are computed to assess protocol performance.

ATOM goes beyond existing self-improvement work by combining three
complementary self-improvement mechanisms: qualitative reflection (Reflexion),
quantitative assessment (CRITIC), and capability expansion (Absolute Zero).
The combination ensures that the protocol improves along multiple dimensions
simultaneously: it learns from mistakes (Reflexion), tracks its performance
objectively (CRITIC), and pushes its own capability frontier (Absolute Zero).

### 3.6 Synthesis

No prior work combines all five research streams into a unified framework.
Chain-of-Thought and its descendants enhance reasoning but do not verify
it. Adversarial evaluation verifies but does not systematically discover.
Philosophical reasoning provides deep analysis but lacks quantification.
Engineering frameworks provide rigor but are domain-specific in their
traditional formulations. Self-improvement mechanisms operate on individual
capabilities but have not been applied to multi-method protocols.

ATOM is, to our knowledge, the first framework that integrates AI/ML
reasoning enhancement, adversarial verification, philosophical reasoning,
engineering analysis, and self-improvement into a single systematic discovery
protocol. The contribution is not any individual method --- each is drawn from
existing literature --- but the composition, sequencing, and interaction of
35 methods across 37 loops in a seven-phase architecture designed
specifically for the gap discovery problem.

---

## 4. Problem Statement

### 4.1 Formal Definition of "Gap"

We define a **gap** as a capability, knowledge element, process component,
or structural property that satisfies at least one of the following
conditions:

**(a) Required but absent.** The element is demanded by the domain's
standards, best practices, axioms, or logical requirements, but does not
exist in the target system. Example: a web application that handles
authentication but has no rate limiting on login attempts.

**(b) Present but insufficient.** The element exists in the target system
but does not meet the depth, breadth, or quality required by the domain's
standards or the system's own stated goals. Example: a disaster recovery
plan that specifies backup frequency but does not define recovery time
objectives.

**(c) Assumed but unfalsifiable.** The element is implicitly assumed to be
true or adequate, but the assumption cannot be tested, measured, or
disproven. Example: "our users will always have a stable internet
connection" embedded as an unstated assumption in a real-time collaboration
system.

This three-part definition is deliberately broad. A gap discovery protocol
that only identifies missing components (condition a) will miss the equally
important categories of insufficient implementations (condition b) and
hidden assumptions (condition c). The philosophical influence of Popper's
falsificationism is explicit in condition (c): if a claim about system
adequacy cannot in principle be disproven, it is not a finding but a
structural assumption that must be surfaced and acknowledged.

### 4.2 Why Gap Discovery Is Hard

Gap discovery is a fundamentally difficult problem for five reasons:

**Unknown unknowns.** The most dangerous gaps are those the analyst does
not know to look for. By definition, these gaps fall outside the analyst's
existing categories of understanding. A security analyst who has never
encountered a timing side-channel attack will not think to check for one.
A business strategist who has never considered regulatory risk in a
particular jurisdiction will not identify it as a gap. The challenge is
not finding gaps in known categories but discovering categories that the
analyst does not yet possess.

**Confirmation bias.** Human and AI analysts alike tend to validate existing
structures rather than challenge them. When presented with a well-organized
system, the natural tendency is to confirm that it is well-organized rather
than to search for what it is missing. This bias is amplified in AI systems,
which are trained on human-generated text that disproportionately confirms
and validates.

**Anchoring.** The first gap identified shapes all subsequent analysis. If
the first finding is a security gap, subsequent analysis tends to discover
more security gaps at the expense of other categories. This effect is
well-documented in cognitive psychology (Tversky and Kahneman 1974) and
applies equally to AI-generated analysis.

**Category blindness.** Analysts can only discover gaps in categories they
know about. A developer auditing a system for technical gaps may not think
to look for business model gaps, compliance gaps, or user experience gaps.
The categories of analysis constrain the space of discoverable gaps.

**False positives.** Language models have a well-documented tendency to
generate plausible-sounding but incorrect claims (Ji et al. 2023). In the
context of gap discovery, this manifests as hallucinated gaps --- problems
that sound real but do not actually exist. False positives are particularly
damaging because they consume attention and resources that should be
directed toward genuine gaps, and they erode trust in the discovery process
itself.

### 4.3 Requirements for a Complete Gap Discovery System

Based on the above analysis, we identify six requirements that a complete
gap discovery system must satisfy:

1. **Multi-method.** No single reasoning method covers all blind spots.
   The system must employ multiple methods that address different failure
   modes.

2. **Adversarial.** Gap claims must survive adversarial challenge to be
   credible. The system must include mechanisms that actively attempt to
   disprove each finding.

3. **Quantified.** Severity and confidence must be expressed as numeric
   values, not verbal qualifiers. "High severity" is meaningless without
   a scale; a Risk Priority Number of 512 is actionable.

4. **Causal.** The system must distinguish root causes from symptoms.
   Reporting ten gaps that all stem from one underlying issue is less
   useful than identifying the one root cause and its ten manifestations.

5. **Self-improving.** The system must learn from previous runs. A
   gap discovery protocol that makes the same mistakes on its tenth run
   as on its first is fundamentally limited.

6. **Falsifiable.** Every gap claim must be disprovable. If a claim cannot
   in principle be shown to be false, it is not a finding but an opinion.

The ATOM protocol is designed to satisfy all six requirements
simultaneously.

---

## 5. The ATOM Protocol

### 5.1 Design Philosophy

Five principles guide the design of the ATOM protocol.

**The Ralph Wiggum Protocol: Zero-Context Prevention of Anchoring Bias.**
Named for the Simpsons character whose observations, uncontaminated by
context or expectation, occasionally reveal truths that more informed
characters miss, this principle requires that specific analysis loops
operate without access to the findings of previous loops. The mechanism
is simple: when a loop is designated as "zero-context," it receives only
the original target description and the axioms from Phase 1, not the gaps
discovered in earlier loops. This prevents anchoring bias, where early
findings shape (and constrain) subsequent analysis. The designated
zero-context loops in ATOM are Loops 6, 8, and 11, which employ RT-ICA
(reverse-thinking), Socratic questioning, and contrastive analysis
respectively. These three methods were selected for zero-context operation
because they are most susceptible to anchoring: reverse-thinking is biased
by knowing what has already been found, Socratic questioning follows the
path of existing findings, and contrastive analysis compares against known
gaps rather than discovering new ones.

**First Principles as Foundation.** Aristotle defined a first principle
as "the first basis from which a thing is known" (Metaphysics 1013a).
In the ATOM protocol, First Principles decomposition is not one method
among many; it is the foundational Loop 1 from which all subsequent
analysis proceeds. The rationale is that gap discovery must begin from
irreducible truths about the target domain, not from inherited assumptions,
popular frameworks, or the analyst's prior experience. By establishing
the axioms first, the protocol ensures that every subsequent finding can
be traced back to a foundational truth, and gaps that cannot be so traced
are flagged for additional scrutiny.

**Multi-Method Insurance.** Each of the 35 methods in ATOM addresses a
specific failure mode of reasoning. First Principles addresses the failure
to question assumptions. Abductive reasoning addresses the failure to
identify root causes. Falsification addresses the failure to test claims.
FMEA addresses the failure to quantify severity. The combination is
analogous to a diversified investment portfolio: individual methods may
fail on specific targets, but the portfolio as a whole provides consistent
coverage. The composition ratio --- 15 AI/ML methods, 10 philosophical
methods, 10 engineering methods --- was determined iteratively through
the protocol's evolution (Section 7) and reflects the empirical finding
that all three domains contribute unique and non-redundant discovery
capabilities.

**Adversarial Verification.** The ATOM protocol treats verification as
a first-class concern, allocating eight of its 37 loops (22%) to the sole
purpose of challenging, testing, and attempting to disprove its own
findings. This allocation reflects the conviction that false positives are
more damaging than false negatives in gap discovery. A missed gap can be
discovered in the next run; a hallucinated gap consumes resources,
damages credibility, and may lead to unnecessary system changes that
introduce new problems. The eight verification methods in Phase 3 are
designed to be mutually reinforcing: FMEA quantifies severity, Chain of
Verification decomposes claims, DiVeRSe verifies step-by-step, Dialectical
Debate challenges conclusions, Falsification tests disprovability, Causal
Inference distinguishes causes from correlations, Faithful CoT prevents
rationalization, and Self-Consistency checks for agreement across
independent assessments.

**Self-Improvement.** The protocol is designed to improve with each run.
Three mechanisms --- Reflexion (qualitative reflection), CRITIC
(quantitative assessment), and Absolute Zero (capability expansion) ---
operate in the final phase to extract lessons, measure performance, and
generate training challenges. The expectation is that the protocol's first
run on a given target will be its weakest, with subsequent runs showing
monotonic improvement in coverage and precision.

### 5.2 Architecture Overview

ATOM consists of seven phases, 37 loops, and 35 distinct reasoning methods.
The architecture follows a funnel shape: wide discovery, narrow verification,
focused solution.

```
PHASE 1: AXIOMS  [Loops 1-4]   Foundation    4 methods
    |
    v
PHASE 2: HUNT    [Loops 5-16]  Discovery    12 methods
    |
    v
PHASE 3: VALIDATE [Loops 17-24] Verification  8 methods
    |
    v
PHASE 4: SOLVE   [Loops 25-30] Solution      6 methods
    |
    v
PHASE 5: SYNTHESIZE [Loops 31-33] Synthesis   3 methods
    |
    v
PHASE 6: CACHE   [Loop 34]     Learning      1 method
    |
    v
PHASE 7: EVOLVE  [Loops 35-37] Evolution     3 methods
```

**Why this ordering.** The seven phases proceed from the general to the
specific, from the abstract to the concrete. Phase 1 establishes the
foundational truths from which all analysis proceeds. Phase 2 casts the
widest possible net for gap discovery, employing 12 methods that each
address a different type of blind spot. Phase 3 narrows the findings by
subjecting each gap claim to eight verification methods, eliminating false
positives and quantifying severity. Phase 4 generates solution
specifications for verified gaps. Phase 5 deduplicates, ranks, and
synthesizes the findings into a final report. Phase 6 extracts reusable
templates for future runs. Phase 7 reflects on protocol performance and
generates self-improvement signals.

The funnel shape is deliberate. Phases 1 and 2 are designed to
over-discover: it is better to generate false positives in the discovery
phase than to miss genuine gaps. Phase 3 is designed to ruthlessly
eliminate false positives. Phases 4 and 5 focus attention on the
high-confidence findings that survived verification. This structure ensures
that the protocol's outputs are both comprehensive (high recall from Phases
1-2) and credible (high precision from Phase 3).

### 5.3 Phase 1: AXIOMS (Loops 1-4)

Phase 1 establishes the foundational elements from which all subsequent
analysis proceeds. It produces four outputs: an Axiom Set, a Principle Set,
a Reasoning Blueprint, and a Coverage Grid.

**Loop 1: First Principles Decomposition.**
First Principles decomposition is the foundation of the entire ATOM
protocol. This loop receives the target description and decomposes it into
its irreducible components --- the "first basis from which a thing is
known," in Aristotle's formulation. The process involves three steps:
(1) identifying every assumption embedded in the target description,
(2) questioning each assumption by asking "is this actually true, or is
it inherited from convention?", and (3) reconstructing the target from
only those truths that survive questioning. The output is the Axiom Set:
a list of irreducible truths about the target domain that all subsequent
analysis must respect.

The placement of First Principles as Loop 1 is one of ATOM's most
significant design decisions. In the protocol's predecessor (AGE v1.0),
First Principles appeared as one method among many, buried in the middle
of the analysis. This placement meant that earlier loops had already
established findings based on unquestioned assumptions, and those findings
anchored subsequent analysis. By moving First Principles to Loop 1, ATOM
ensures that no analysis proceeds from unexamined assumptions.

**Loop 2: Step-Back Prompting.**
Step-Back Prompting (Zheng et al. 2024) abstracts the target to a higher
level before detailed analysis begins. Instead of immediately diving into
the specifics of a particular system, Step-Back asks: "What general
principles govern this type of system?" This abstraction step prevents
premature specificity --- the tendency to focus on implementation details
before understanding the domain's fundamental requirements. The output is
the Principle Set: a list of high-level principles that any system of this
type must satisfy.

**Loop 3: Self-Discover.**
Self-Discover (Zhou et al. 2024) allows the protocol to construct a
task-adaptive reasoning blueprint by selecting from a library of available
reasoning structures. Rather than applying a fixed method sequence to every
target, Self-Discover examines the target's characteristics and selects the
reasoning structures most likely to be productive. The output is the
Reasoning Blueprint: a customized plan for how the subsequent discovery
loops should approach this particular target. This adaptation mechanism
means that ATOM's behavior varies across targets, allocating more attention
to the discovery methods most relevant to each target's domain and
characteristics.

**Loop 4: Morphological Analysis.**
Morphological Analysis (Zwicky 1969) exhaustively enumerates the space of
possible configurations by identifying the independent parameters of the
target system and systematically varying each one. The purpose in ATOM is
to prevent category blindness: by constructing an explicit coverage grid,
the protocol ensures that subsequent discovery loops examine every region
of the possibility space, not just the regions that happen to be salient
to the analyst. The output is the Coverage Grid: a matrix of independent
parameters and their possible values that defines the complete space in
which gaps may exist.

### 5.4 Phase 2: HUNT (Loops 5-16)

Phase 2 is the primary discovery phase, employing 12 methods that each
address a different type of blind spot. The methods are sequenced to
alternate between analytical perspectives, ensuring that no single
perspective dominates the discovery process.

**Loop 5: Cumulative Reasoning (CR).**
Cumulative Reasoning (Zhang et al. 2023) builds gap hypotheses
incrementally, with each reasoning step adding a single element of
evidence. Unlike methods that attempt to identify gaps in a single pass,
CR constructs gap claims piece by piece, ensuring that each element is
supported before the next is added. This incremental approach is
particularly effective for complex gaps that involve multiple interacting
factors, where a single-pass analysis might miss the interaction effects.

**Loop 6: RT-ICA (Reverse-Thinking Independent Context Analysis).**
RT-ICA is the original innovation from ATOM's predecessor protocol
(AGE v1.0). It operates by inverting the target: instead of asking "what
is missing from this system?", RT-ICA asks "if I were building a system
to do the OPPOSITE of what this system does, what would I need?" The
resulting anti-system is then compared to the original to identify
capabilities, processes, and safeguards that exist in the anti-system but
not in the original. RT-ICA is designated as a zero-context loop: it
receives only the target description and the Phase 1 axioms, not the
findings from Loop 5. This zero-context designation prevents RT-ICA from
being anchored by the cumulative reasoning findings.

**Loop 7: Abductive Reasoning.**
Abductive reasoning --- inference to the best explanation --- is the
philosophical method most closely aligned with diagnostic problem-solving.
Given an observation (a symptom, an anomaly, an inconsistency), abductive
reasoning generates hypotheses about the underlying cause and evaluates
them for plausibility, explanatory power, and parsimony. In ATOM, abductive
reasoning is applied to the target system's observable characteristics:
Where are the inconsistencies? What symptoms suggest underlying gaps? What
is the simplest explanation for each observed anomaly? The output of this
loop is a set of root-cause hypotheses, each linked to the observable
symptoms that motivated it.

**Loop 8: Socratic Method.**
The Socratic Method (Chang 2023) excavates hidden assumptions through
recursive questioning. Starting from each axiom established in Loop 1,
the Socratic loop asks a sequence of progressively deeper questions:
"Why is this true?", "What would happen if it were false?", "Who benefits
from this assumption?", "What alternative assumptions are equally
plausible?" This recursive questioning continues until the assumption is
either confirmed as genuinely irreducible or revealed as a convention
masquerading as a truth. The Socratic loop is designated as zero-context:
it operates only from the axioms, without knowledge of gaps discovered in
Loops 5-7. This prevents the questioning from being guided toward already-
discovered gaps.

**Loop 9: Analogical Transfer.**
Analogical reasoning identifies structural similarities between the target
system and systems in other domains, then transfers insights across
domains. For a software security architecture, analogical transfer might
examine physical security systems, biological immune systems, or financial
fraud detection systems to identify protective mechanisms that have
analogs in the software domain. The value of analogical transfer lies in
its ability to import concepts from domains that the analyst might not
otherwise consider, breaking through category blindness by reframing the
target in unfamiliar terms.

**Loop 10: Bayesian Reasoning.**
Bayesian Reasoning treats gap discovery as a probabilistic inference
problem. Each potential gap has a prior probability of being genuine
(based on domain statistics and the findings of earlier loops), and each
new piece of evidence updates that probability. Bayesian reasoning is
particularly valuable for handling uncertain or ambiguous findings: rather
than making a binary decision about whether a gap exists, it maintains a
probability distribution that is refined as evidence accumulates. The
output is a set of gap hypotheses with associated posterior probabilities,
which feed into the FMEA scoring in Phase 3.

**Loop 11: Contrastive Examples.**
Contrastive analysis learns what NOT to flag by examining cases where
something appears to be a gap but is actually a deliberate design choice,
a domain convention, or an irrelevant concern. By constructing explicit
examples of non-gaps, the protocol trains its discrimination between
genuine findings and false positives. Loop 11 is designated as
zero-context: it receives only the target description and axioms, ensuring
that its contrastive examples are generated independently of earlier
findings. This independence is crucial because contrastive examples
generated with knowledge of prior findings tend to be biased toward
confirming those findings.

**Loop 12: TRIZ.**
TRIZ (Altshuller 1996) expresses gaps as contradictions and applies
inventive resolution principles. A contradiction exists when the target
system has two requirements that appear to be mutually exclusive: "the
system must be both highly performant and fully auditable," or "the
interface must be both comprehensive and simple." TRIZ provides 40
inventive principles for resolving such contradictions, drawn from
analysis of tens of thousands of patents. In ATOM, TRIZ serves a dual
purpose: it discovers gaps that manifest as unresolved contradictions, and
it suggests resolution strategies that feed into the solution generation
phase.

**Loop 13: Pre-Mortem Analysis.**
Pre-mortem analysis (Klein 2007) inverts the typical risk assessment by
imagining that the target system has already failed catastrophically and
working backward to identify what must have gone wrong. This future-
retrospective perspective is psychologically powerful because it bypasses
the optimism bias that characterizes prospective analysis. Instead of
asking "could this system fail?", pre-mortem asks "this system HAS failed
--- why?" The shift from possibility to certainty reliably surfaces risks
and gaps that prospective analysis overlooks.

**Loop 14: Epistemic Humility Assessment.**
Epistemic Humility (Crompton 2023) explicitly categorizes findings into
three classes: Known Knowns (verified facts about the target), Known
Unknowns (identified questions that lack answers), and Unknown Unknowns
(areas where the analyst acknowledges they may lack the categories to even
formulate questions). The primary value of this loop is in the third
category: by explicitly acknowledging the existence of unknown unknowns
and attempting to characterize the boundaries of the analyst's knowledge,
the protocol surfaces meta-gaps --- gaps in the gap discovery process
itself.

**Loop 15: Constraint Analysis.**
Constraint Analysis identifies dependencies and bottlenecks within the
target system. Every system operates under constraints --- resource limits,
regulatory requirements, technical dependencies, organizational
capacities --- and gaps frequently hide at the intersection of multiple
constraints. Constraint Analysis maps these dependencies and identifies
points where constraints interact in ways that create hidden requirements
or undocumented limitations.

**Loop 16: Cross-Domain Pattern Matching.**
The final discovery loop applies patterns from adjacent domains to the
target. If the target is a software system, patterns from hardware
engineering, operations research, and organizational design are applied.
If the target is a business strategy, patterns from military strategy,
game theory, and evolutionary biology are applied. The value lies in
importing well-understood patterns from mature domains to discover gaps in
less mature domains.

### 5.5 Phase 3: VALIDATE (Loops 17-24)

Phase 3 subjects every gap claim from Phase 2 to eight verification
methods. The design philosophy is that overkill is the point: false
positives destroy credibility, consume resources, and erode trust in the
discovery process. A gap claim that cannot survive eight distinct
challenges should not be reported.

The eight verification methods are designed to be mutually reinforcing.
Each method tests a different dimension of gap validity, and the
combination creates a verification gauntlet that is substantially more
rigorous than any individual method.

**Loop 17: FMEA Scoring.**
Failure Mode and Effects Analysis scoring assigns three numeric values to
each gap claim: Severity (1-10, the impact if the gap is exploited or
leads to failure), Occurrence (1-10, the likelihood that the gap will
manifest), and Detection (1-10, the difficulty of discovering the gap
through normal operations, where 10 = very difficult to detect). The
product of these three values yields the Risk Priority Number (RPN, range
1-1000), which provides a quantified severity metric that enables
objective prioritization. FMEA scoring transforms qualitative assessments
("this seems important") into quantitative rankings that support
data-driven decision-making.

The Occurrence rating is informed by the Bayesian posterior probability
computed in Loop 10. The Detection rating is inversely related to the
number of discovery loops that independently identified the gap: a gap
found by multiple methods is easier to detect (lower Detection score)
than one found by only a single method.

**Loop 18: Chain of Verification (CoVe).**
Chain of Verification (Dhuliawala et al. 2023) decomposes each gap claim
into a set of independent verification questions. For a gap claim "the
system lacks rate limiting on API endpoints," CoVe might generate the
verification questions: "Does the system expose API endpoints?", "Is there
any rate limiting mechanism present?", "Could rate limiting be handled
at a different layer (e.g., API gateway)?", "Does the domain require rate
limiting?" Each verification question is answered independently, without
reference to the original gap claim. If the answers to the verification
questions do not support the original claim, the gap is flagged for
removal or downgrading.

**Loop 19: DiVeRSe (Diverse Verifier on Reasoning Steps).**
DiVeRSe (Li et al. 2023) applies step-level verification to the
reasoning chain that led to each gap claim. Rather than evaluating only
the final conclusion ("this is a gap"), DiVeRSe examines each intermediate
reasoning step for validity. If any step in the reasoning chain is
unsupported or logically invalid, the entire chain is flagged. This
method is particularly effective at catching post-hoc rationalization,
where the model generates a plausible-sounding reasoning chain that does
not actually support the conclusion.

**Loop 20: Dialectical Debate.**
Dialectical Debate implements the Hegelian triad of thesis, antithesis,
and synthesis. Each gap claim serves as the thesis. A counter-argument
is generated as the antithesis: "This is not actually a gap because..."
The thesis and antithesis are then synthesized into a more nuanced
conclusion that accounts for both perspectives. This process is informed
by Multi-Agent Debate (Du et al. 2023), where multiple LLM instances
take opposing positions and argue to resolution. The synthesis may confirm
the gap (with additional nuance), reject the gap (with explanation),
or reframe the gap (as a different, more precise finding).

**Loop 21: Falsification.**
Falsification implements Karl Popper's criterion of scientific demarcation:
a claim is scientific (and therefore credible) only if it is falsifiable
--- that is, if there exists a possible observation that would disprove
it. Each gap claim is subjected to the question: "What evidence would
prove this gap does NOT exist?" If no such evidence can be specified, the
gap claim is unfalsifiable and is reclassified as a "structural
assumption" rather than a finding. This distinction is critical:
unfalsifiable claims ("the system may not scale under extreme load") are
opinions, not findings. Falsifiable claims ("the system does not implement
connection pooling, which is required for handling more than 100
concurrent database connections") can be verified and acted upon.

Falsification serves as what we term the "ultimate bullshit filter." It
is the single most effective method for eliminating hallucinated gaps,
because hallucinated gaps almost always fail the falsifiability test. A
gap that was invented by the model rather than discovered through analysis
typically lacks the specificity required to specify what evidence would
disprove it.

**Loop 22: Causal Inference.**
Causal Inference applies Pearl's three-rung causal hierarchy (Pearl 2009)
to distinguish root causes from symptoms. Rung 1 (Association) asks: "Is
this gap correlated with other gaps?" Rung 2 (Intervention) asks: "If we
fixed this gap, would other gaps resolve as well?" Rung 3 (Counterfactual)
asks: "If this gap had never existed, would the system behave differently?"
Gaps that pass the Rung 2 and Rung 3 tests are flagged as root causes;
gaps that are correlated with other gaps but do not have causal power over
them are flagged as symptoms. This distinction is operationally critical:
fixing a root cause resolves multiple symptoms, while fixing a symptom
leaves the root cause intact.

The causal analysis produces a Directed Acyclic Graph (DAG) of gap
relationships, where edges represent causal influence. This DAG is used
in Phase 5 to deduplicate findings (removing symptoms when the root cause
is reported) and to prioritize (root causes receive higher priority than
symptoms).

**Loop 23: Faithful Chain-of-Thought.**
Faithful Chain-of-Thought (Lyu et al. 2023) translates the reasoning
behind each gap claim into symbolic logic and verifies the logical
validity of the argument. Unlike standard Chain-of-Thought, which relies
on natural language reasoning that can be subtly invalid, Faithful CoT
requires each reasoning step to be expressible as a logical proposition,
and each transition between steps to be a valid logical inference. This
translation from natural language to symbolic logic prevents post-hoc
rationalization: a reasoning chain that sounds plausible but is logically
invalid will be caught when the symbolic translation fails to produce
valid inferences.

**Loop 24: Self-Consistency.**
Self-Consistency (Wang et al. 2022) generates multiple independent
assessments of each gap claim and checks for agreement. Each assessment
is generated from a different starting point (different prompt formulation,
different reasoning path) to ensure independence. If the assessments
converge on the same conclusion, the gap claim is confirmed. If they
diverge, the gap claim is flagged for manual review or downgraded in
confidence. Self-Consistency serves as the final check in the verification
gauntlet: a gap claim that has survived seven prior verification methods
but fails Self-Consistency is likely a borderline case that requires
human judgment.

**The Validation Gauntlet.** Together, these eight methods form a
verification gauntlet through which every gap claim must pass. A gap that
survives all eight is designated "high-confidence" and receives its final
RPN score. A gap that fails one or two methods is designated
"medium-confidence" and is reported with caveats. A gap that fails three
or more methods is rejected. The specific thresholds (one-two vs. three-
plus failures) were determined through iterative development and represent
a balance between recall (reporting genuine gaps) and precision (avoiding
false positives).

### 5.6 Phase 4: SOLVE (Loops 25-30)

Phase 4 generates solution specifications for verified gaps. The output
is not an implementation but a specification: a detailed description of
what must be built, modified, or established to resolve each gap.

**Loop 25: Solution Specification Templates.**
Each verified gap receives a solution specification using one of three
templates, depending on its nature:

- **New Capability Template:** For gaps requiring new features, skills,
  modules, or processes. Specifies: capability name, purpose, inputs,
  outputs, dependencies, acceptance criteria, estimated complexity.

- **Modification Template:** For gaps requiring changes to existing
  components. Specifies: component to modify, current behavior, required
  behavior, migration strategy, backward compatibility considerations.

- **Infrastructure Template:** For gaps requiring new supporting
  structures (monitoring, documentation, processes, policies). Specifies:
  infrastructure type, scope, integration points, maintenance
  requirements, ownership.

**Loop 26: Cumulative Reasoning for Solutions.**
Cumulative Reasoning (Zhang et al. 2023) is applied again, this time to
solution generation. Solutions are built incrementally, with each element
justified by evidence from the gap analysis. This incremental approach
prevents solution specifications from including unnecessary components
(gold-plating) or omitting critical elements (incomplete solutions).

**Loop 27: Graph of Thoughts.**
Graph of Thoughts (Besta et al. 2023) represents solution candidates as
nodes in a directed graph. Candidate solutions can be merged (combining
the best elements of two approaches), refined (adding detail to a
promising approach), or abandoned (discarding approaches that fail
evaluation). The graph structure allows the protocol to explore multiple
solution strategies simultaneously and converge on the strongest option
through a combination of generation, evaluation, and synthesis.

**Loop 28: RAP/MCTS (Reasoning via Planning).**
Reasoning via Planning (Hao et al. 2023) treats solution search as a
planning problem and applies Monte Carlo Tree Search (MCTS) to navigate
the space of possible solutions. Each node in the search tree represents
a partial solution, and the tree is expanded by generating next steps and
evaluating them using a value function based on the gap's FMEA scores.
RAP/MCTS is particularly effective for complex gaps where the solution
space is large and the interactions between solution components are
non-obvious.

**Loop 29: Second-Order Effects Analysis.**
Every proposed solution is analyzed for second-order effects: unintended
consequences that might create new gaps or exacerbate existing ones. The
analysis considers: "If we implement this solution, what else changes?
Does this solution conflict with any other solution? Does this solution
create new dependencies? Could this solution be worse than the problem
it addresses?" Solutions with severe negative second-order effects are
revised or flagged with warnings.

**Loop 30: Theory of Constraints.**
Theory of Constraints (Goldratt 1990) identifies the single constraint
that limits the overall throughput of the target system. Among all
verified gaps, the TOC analysis identifies the "bottleneck gap" --- the
gap whose resolution would have the greatest cascading positive effect
on the overall system. This gap is flagged as the highest-priority item,
regardless of its individual RPN score, because resolving it unlocks
improvement across multiple dimensions simultaneously.

### 5.7 Phase 5: SYNTHESIZE (Loops 31-33)

Phase 5 synthesizes all findings into a coherent final report. The
three loops in this phase handle deduplication, coverage reporting, and
epistemic calibration.

**Loop 31: CEO Synthesis.**
The CEO Synthesis loop performs deduplication and merge operations using
the causal DAG constructed in Loop 22. Gaps that share a common root
cause are merged into a single finding with the root cause as the primary
gap and the symptoms listed as manifestations. The deduplication process
also identifies gaps that were discovered independently by multiple
methods in Phase 2, flagging these as high-confidence findings (the
convergence of independent methods on the same finding is strong evidence
of validity). The output is a deduplicated gap list with causal
relationships preserved.

The name "CEO Synthesis" is inherited from the protocol's predecessor
(AGE v1.0), where a "CEO persona" was responsible for synthesizing the
findings of multiple analyst personas. In ATOM, the CEO Synthesis is
implemented as a formal deduplication and merge operation rather than a
persona-based approach.

**Loop 32: MAP-Elites Quality-Diversity Reporting.**
MAP-Elites (Mouret and Clune 2015) provides a quality-diversity framework
for coverage reporting. The coverage grid constructed in Loop 4
(Morphological Analysis) defines the behavioral dimensions, and MAP-Elites
populates each cell with the highest-quality finding that covers that
region of the possibility space. The output is a coverage map that shows
which regions of the gap space are well-covered, which are sparsely
covered, and which remain unexplored. This map provides a visual summary
of the protocol's coverage and highlights areas that may benefit from
additional analysis in future runs.

**Loop 33: Epistemic Humility Report.**
The final synthesis loop classifies all findings and non-findings into
three categories:

- **Known Knowns:** Verified gaps with high-confidence scores, supported
  by multiple methods, surviving the validation gauntlet.

- **Known Unknowns:** Questions identified during analysis that could not
  be definitively answered with available information. These represent
  areas where additional investigation, domain expertise, or empirical
  testing is needed.

- **Unknown Unknowns:** Regions of the coverage grid (from Loop 32) that
  remain empty, plus any meta-gaps identified during the analysis (e.g.,
  domain categories that the protocol may lack the expertise to evaluate).

The Epistemic Humility Report is critical for maintaining trust. By
explicitly acknowledging what the protocol does not know, it prevents the
false confidence that would arise from presenting only the gaps that were
found. The report communicates: "We found these gaps (Known Knowns), we
identified these open questions (Known Unknowns), and we acknowledge that
these areas may contain undiscovered gaps beyond our current analytical
reach (Unknown Unknowns)."

The final report is sorted by a composite score:
`Composite = RPN x P(real) x Constraint_Position`
where RPN is the FMEA Risk Priority Number, P(real) is the Bayesian
posterior probability from Loop 10 (updated through validation), and
Constraint_Position is a multiplier (1.5x for bottleneck gaps identified
by TOC, 1.0x for all others).

### 5.8 Phase 6: CACHE (Loop 34)

Phase 6 consists of a single loop that extracts reusable knowledge from
the current run for use in future runs.

**Loop 34: Buffer of Thoughts.**
Buffer of Thoughts (Yang et al. 2024) distills the current run's
discoveries into reusable templates. Each template captures a discovery
pattern: a generalized version of a specific finding that can be applied
to future targets. The template format is:

```
Template ID: [unique identifier]
Domain Type: [category of target where this pattern applies]
Pattern: "For [domain type], always check [specific pattern]"
Source: [the specific finding that generated this template]
Confidence: [how reliably this pattern produces valid findings]
Run Count: [number of runs that have validated this template]
```

For example, if the current run discovers that a web application lacks
CSRF protection, the Buffer of Thoughts loop might extract the template:
"For web applications handling state-changing operations, always check for
cross-site request forgery protection on all form submissions and API
endpoints."

Templates accumulate across runs. When ATOM is run on a new target, the
Buffer of Thoughts library is consulted during Phase 2, and relevant
templates are retrieved and applied alongside the standard discovery
methods. Templates that consistently produce valid findings have their
confidence scores increased; templates that produce false positives have
their confidence scores decreased or are retired.

The Buffer of Thoughts mechanism transforms ATOM from a stateless protocol
(each run independent of all others) into a stateful one (each run builds
on the accumulated knowledge of all previous runs). This accumulated
knowledge represents the protocol's "experience" --- a growing library
of patterns that accelerates discovery and reduces false positives on
familiar target types.

### 5.9 Phase 7: EVOLVE (Loops 35-37)

Phase 7 is the self-improvement phase. Three complementary mechanisms
operate to improve the protocol's performance across runs.

**Loop 35: Reflexion.**
Reflexion (Shinn et al. 2023) implements verbal reinforcement learning
without gradient updates. After the run is complete, the protocol reflects
on its own performance by asking a structured set of questions:

- "Which loops produced the most valuable findings?"
- "Which loops produced the most false positives?"
- "What types of gaps were discovered by only a single method?"
- "What categories of the coverage grid remain empty?"
- "If I could run only 10 of the 37 loops, which would I choose for
  this target?"
- "What did I miss that I should look for next time?"

The reflections are stored in a persistent memory file
(`memory/atom-reflexions.md`) and are prepended to the protocol context
in subsequent runs. This mechanism allows the protocol to learn from its
own mistakes and successes qualitatively, without requiring any
modification to the protocol's structure.

**Loop 36: CRITIC.**
CRITIC (Gou et al. 2024) provides quantitative self-assessment by
computing performance metrics for the current run:

- **Gap Count:** Total gaps discovered, verified, and rejected.
- **False Positive Rate:** Proportion of discovered gaps that were
  rejected during validation.
- **Coverage Score:** Proportion of the coverage grid (from Loop 4)
  that has at least one finding.
- **Method Efficiency:** For each of the 35 methods, the number of
  unique gaps it contributed (not discovered by any other method).
- **Severity Distribution:** Histogram of RPN scores across verified
  gaps.
- **Convergence Rate:** How many loops contributed to the same gap
  (higher convergence = higher confidence in the finding).

These metrics are stored alongside the Reflexion output and are used
to track the protocol's performance trajectory across runs. A declining
false positive rate and increasing coverage score across runs would
provide empirical evidence that the self-improvement mechanism is
working.

**Loop 37: Absolute Zero.**
Absolute Zero (Zhao et al. 2025) generates progressively harder gap
discovery challenges for the protocol to attempt in future runs. The
mechanism operates in three steps:

1. **Challenge Generation:** Based on the current run's performance,
   generate three types of challenges:
   - **Subtle gaps:** Gaps that require deep domain expertise to identify,
     at the frontier of the protocol's current capability.
   - **Emergent gaps:** Gaps that arise from the interaction of multiple
     components, invisible when components are analyzed individually.
   - **Causal confounds:** Scenarios where the apparent root cause is
     actually a symptom, and the real root cause is non-obvious.

2. **Difficulty Calibration (Goldilocks Principle):** Each challenge is
   calibrated to be at the frontier of the protocol's capability ---
   difficult enough to require improvement but not so difficult that no
   progress is possible.

3. **Self-Play:** The protocol attempts to solve its own challenges. The
   results inform the next run's Reflexion (Loop 35) and contribute new
   templates to the Buffer of Thoughts (Loop 34).

The Absolute Zero mechanism pushes the protocol's capability frontier
outward. While Reflexion prevents repeated mistakes (learning from
failure) and CRITIC tracks performance (measurement), Absolute Zero
actively creates the conditions for growth by generating challenges
beyond the protocol's current comfort zone.

---

## 6. Method Selection Rationale

### 6.1 Why These 35 Methods

The selection of ATOM's 35 methods was not arbitrary. Each method was
chosen because it addresses a specific failure mode of reasoning that is
not adequately addressed by any other method in the protocol. The
selection process involved surveying over 50 candidate methods from the
AI/ML, philosophical, and engineering literature, evaluating each against
five criteria: (1) Does it address a unique failure mode? (2) Is it
operationalizable as a protocol loop? (3) Has it been empirically
validated in its source domain? (4) Does it compose well with the other
selected methods? (5) Can it be performed by current-generation language
models?

### 6.2 Methods Considered and Rejected

Several well-known reasoning methods were evaluated and ultimately
excluded from the protocol.

**Tree of Thoughts** (Yao et al. 2023) was excluded because it is
subsumed by Graph of Thoughts (Besta et al. 2023), which provides the
same tree-based exploration capability plus additional operations (merging,
looping) that are critical for the solution generation phase. Including
both would create redundancy without coverage benefit.

**Standard Chain of Thought** (Wei et al. 2022) was excluded because it
is subsumed by Faithful Chain-of-Thought (Lyu et al. 2023), which
provides the same step-by-step reasoning with the addition of symbolic
logic translation that prevents post-hoc rationalization. Standard CoT
without the symbolic verification component is insufficient for ATOM's
adversarial verification requirements.

**ReAct** (Yao et al. 2022) was excluded because it is primarily a
tool-use framework (interleaving reasoning with actions) rather than a
reasoning enhancement method. ATOM does not interact with external tools
during its core analysis loops; tool interaction is handled at a different
architectural layer.

**Scratchpad Prompting** (Nye et al. 2021) was excluded because it
provides no verification component. While scratchpad reasoning can improve
intermediate step quality, it does not include any mechanism for validating
the correctness of those steps, which is a hard requirement for ATOM's
verification phase.

**Self-Ask** (Press et al. 2022) was excluded because it is limited to
question decomposition. While question decomposition is valuable, the
Socratic Method (Loop 8) provides a more comprehensive and philosophically
grounded version of the same capability, with the additional benefit of
recursive depth.

**Program of Thoughts** (Chen et al. 2023) was excluded because it
focuses on mathematical and computational reasoning, which is only
relevant for a subset of ATOM's target domains. The protocol must be
domain-general.

### 6.3 The Three Tiers

ATOM's 35 methods are organized into three tiers based on their
intellectual origin.

**Tier 1: AI/ML Research Methods (15 methods).** These methods represent
cutting-edge reasoning research from the machine learning community. Each
has been published at major venues (NeurIPS, ICML, ICLR, ACL) and has
empirical validation on benchmark tasks. The 15 methods are:

1. Self-Discover (Zhou et al. 2024) --- task-adaptive reasoning blueprint
2. Cumulative Reasoning (Zhang et al. 2023) --- incremental evidence
3. RT-ICA --- reverse-thinking independent context analysis
4. Contrastive Examples --- learning what NOT to flag
5. Graph of Thoughts (Besta et al. 2023) --- graph-based solution search
6. RAP/MCTS (Hao et al. 2023) --- planning-based solution search
7. Chain of Verification (Dhuliawala et al. 2023) --- decomposed verification
8. DiVeRSe (Li et al. 2023) --- step-level verification
9. Multi-Agent Debate (Du et al. 2023) --- adversarial debate
10. Faithful CoT (Lyu et al. 2023) --- symbolic logic verification
11. Self-Consistency (Wang et al. 2022) --- agreement verification
12. MAP-Elites (Mouret and Clune 2015) --- quality-diversity coverage
13. Buffer of Thoughts (Yang et al. 2024) --- template library
14. Reflexion (Shinn et al. 2023) --- verbal reinforcement learning
15. CRITIC (Gou et al. 2024) --- quantitative self-assessment

**Tier 2: Philosophical Reasoning Methods (10 methods).** These methods
represent 2,500 years of reasoning foundations, developed and refined by
philosophers from Aristotle to Popper. They were proven effective for
rigorous analysis long before AI existed. The 10 methods are:

1. First Principles (Aristotle) --- irreducible truth decomposition
2. Step-Back Prompting (Zheng et al. 2024) --- abstraction before analysis
3. Abductive Reasoning (Peirce) --- inference to best explanation
4. Socratic Method (Socrates/Plato) --- recursive questioning
5. Analogical Reasoning (Gentner 1983) --- cross-domain transfer
6. Bayesian Reasoning (Bayes/Laplace) --- probabilistic inference
7. Dialectics (Hegel) --- thesis-antithesis-synthesis
8. Falsificationism (Popper 1963) --- disprovability criterion
9. Causal Inference (Pearl 2009) --- causal hierarchy analysis
10. Epistemic Humility (Crompton 2023) --- known/unknown classification

**Tier 3: Engineering Analysis Methods (10 methods).** These methods are
battle-tested in safety-critical industries including aerospace,
automotive, medical devices, and nuclear engineering. Their effectiveness
is validated not by academic benchmarks but by decades of operational use
in environments where failures have catastrophic consequences. The 10
methods are:

1. Morphological Analysis (Zwicky 1969) --- exhaustive space enumeration
2. FMEA (US Military 1949) --- failure mode quantification
3. TRIZ (Altshuller 1996) --- contradiction-based invention
4. Pre-Mortem (Klein 2007) --- prospective hindsight
5. Constraint Analysis --- dependency mapping
6. Second-Order Effects --- consequence analysis
7. Theory of Constraints (Goldratt 1990) --- bottleneck identification
8. Cross-Domain Pattern Matching --- pattern transfer
9. Solution Specification --- structured solution templates
10. CEO Synthesis --- deduplication and causal merge

### 6.4 Method Interactions and Synergies

The methods in ATOM do not operate in isolation. Several pairs and groups
of methods have synergistic interactions that amplify their individual
effectiveness.

**Abductive Reasoning + Causal Inference.** Abductive reasoning (Loop 7)
generates root-cause hypotheses from observed symptoms. Causal Inference
(Loop 22) tests those hypotheses using Pearl's three-rung framework. The
combination transforms "this might be the root cause" into "this IS the
root cause, and here is the causal mechanism." Without abductive reasoning,
causal inference has no hypotheses to test. Without causal inference,
abductive reasoning produces untested hypotheses.

**Socratic Method + Falsification.** The Socratic Method (Loop 8) excavates
hidden assumptions through recursive questioning: "Why is this true?",
"What would happen if it were false?" Falsification (Loop 21) tests
whether the resulting claims are disprovable. The combination transforms
assumptions into testable hypotheses: the Socratic Method surfaces the
assumption, and Falsification determines whether it can be empirically
evaluated. Assumptions that survive both the Socratic gauntlet and the
Falsification test are genuinely irreducible; those that fail either are
exposed as conventions or opinions.

**Morphological Analysis + MAP-Elites.** Morphological Analysis (Loop 4)
constructs the coverage grid by exhaustively enumerating the possibility
space. MAP-Elites (Loop 32) populates that grid with the best finding in
each cell and reports coverage. The combination provides a complete picture
of what has been discovered and what remains unexplored, directly informing
future runs about where to focus additional effort.

**Multi-Agent Debate + Dialectics.** Multi-Agent Debate (part of Loop 20)
provides the mechanism (multiple agents arguing different positions), while
Dialectics (also Loop 20) provides the structure (thesis-antithesis-
synthesis). The combination produces structured adversarial evaluation that
converges on a synthesis rather than simply picking a winner.

**Buffer of Thoughts + Reflexion.** Buffer of Thoughts (Loop 34) captures
what was learned (reusable templates). Reflexion (Loop 35) captures what
went wrong (self-critiques). The combination provides both positive
knowledge ("patterns that worked") and negative knowledge ("mistakes to
avoid"), which together accelerate future runs along both dimensions.

**Cumulative Reasoning + Bayesian Updating.** Cumulative Reasoning (Loops
5 and 26) builds evidence incrementally. Bayesian Reasoning (Loop 10)
updates probability estimates as evidence accumulates. The combination
ensures that confidence in gap claims grows organically with supporting
evidence, rather than being assigned arbitrarily.

**FMEA + Theory of Constraints.** FMEA (Loop 17) quantifies the severity
of individual gaps. Theory of Constraints (Loop 30) identifies which gap
is the system-level bottleneck. The combination distinguishes between gaps
that are individually severe and gaps that are systemically critical. A
gap with a modest RPN score might be the bottleneck whose resolution
unlocks improvement across the entire system.

### 6.5 Redundancy by Design

ATOM's 35 methods include deliberate overlaps in coverage. Multiple
discovery methods may identify the same gap; multiple verification methods
test the same claim from different angles. This redundancy is a feature,
not a design flaw.

The rationale is analogous to defense in depth in security engineering:
if any single layer fails, the other layers provide backup. In ATOM, if
a particular discovery method has a blind spot for a certain type of gap,
other methods are likely to catch it. If a particular verification method
fails to identify a false positive, other verification methods are likely
to flag it.

The cost of redundancy is computational: running 37 loops is more
expensive than running 10. The benefit is robustness: the protocol's
outputs are insensitive to the failure of any individual method. Section
10 proposes ablation experiments to quantify this tradeoff and identify
the minimum set of methods that preserves coverage.

### 6.6 The Organizing Principle

The organizing principle for method selection is that each method
addresses a different failure mode of reasoning:

| Failure Mode | Method(s) |
|---|---|
| Unexamined assumptions | First Principles, Socratic Method |
| Premature specificity | Step-Back Prompting |
| Fixed reasoning structure | Self-Discover |
| Category blindness | Morphological Analysis, Cross-Domain |
| Single-path reasoning | Graph of Thoughts, RAP/MCTS |
| Anchoring bias | RT-ICA (zero-context), Contrastive |
| Missing root causes | Abductive Reasoning, Causal Inference |
| Unresolved contradictions | TRIZ |
| Optimism bias | Pre-Mortem |
| Unquantified severity | FMEA |
| Post-hoc rationalization | Faithful CoT, DiVeRSe |
| Unchallenged conclusions | Dialectical Debate, Falsification |
| Confirmation bias | Multi-Agent Debate, CoVe |
| Single-assessment reliance | Self-Consistency |
| No cross-run learning | Buffer of Thoughts, Reflexion |
| Capability plateau | Absolute Zero, CRITIC |

This table demonstrates that ATOM's method selection is systematic rather
than arbitrary: each method was selected because it addresses a specific
vulnerability in the reasoning process, and the combination covers the
full space of known reasoning failure modes.

---

## 7. The Evolution Story

### 7.1 v1.0: AGE --- The Beginning

ATOM did not emerge fully formed. It evolved through four distinct
iterations, each driven by the discovery of specific blind spots in the
previous version.

The protocol's ancestor was AGE (Autonomous Growth Engine), a 25-loop gap
analysis protocol built on a simple architecture. AGE employed three
analyst personas --- the Architect, the Detective, and the Builder --- each
responsible for discovering gaps from a different perspective. The
Architect examined structural completeness. The Detective searched for
hidden vulnerabilities. The Builder evaluated implementability. A fourth
persona, the CEO, synthesized the findings of the three analysts into a
deduplicated, prioritized report.

AGE's sole research-backed method was RT-ICA (Reverse-Thinking Independent
Context Analysis), which discovered gaps by inverting the target system.
The remaining loops were straightforward analysis steps: examine security,
check documentation, evaluate scalability, and so on. The loop structure
was linear: each loop received the findings of all previous loops, with
no mechanism to prevent anchoring.

AGE was effective for basic gap finding. Applied to a software framework,
it consistently identified 20-30 gaps across security, performance,
documentation, and architecture. However, it suffered from three
fundamental weaknesses that limited its utility for rigorous analysis:

First, there was no falsification or adversarial testing. Every gap
identified by AGE was reported as a finding, with no mechanism to
distinguish genuine gaps from hallucinated ones. A plausible-sounding gap
that the model invented was indistinguishable from a genuine gap supported
by evidence. This meant that AGE's outputs required extensive manual
review to filter out false positives.

Second, there was no self-improvement. AGE's tenth run on the same target
was no better than its first. Each run started from scratch, with no
mechanism to learn from previous successes or failures. Patterns that
were discovered once had to be rediscovered in every subsequent run.

Third, the linear loop structure created severe anchoring effects. The
Architect's findings shaped the Detective's analysis, which in turn
shaped the Builder's. If the Architect happened to focus on security
gaps, the entire run became security-dominated, with other categories
receiving inadequate attention.

Despite these limitations, AGE demonstrated the core thesis: a structured,
multi-perspective approach to gap discovery reliably outperformed
single-method approaches. This validation motivated the subsequent
evolution.

### 7.2 User Feedback Round 1: "There Is More We Can Do"

The first major evolution was triggered by user feedback: "I believe there
is more that we can do here." This simple observation launched a research
phase that surveyed 37 reasoning methods from the AI/ML literature.

The survey identified a critical insight: the AI/ML community had
developed a rich toolkit of reasoning enhancement methods, but these
methods were typically applied in isolation to benchmark tasks. No one had
combined them into a systematic protocol for open-ended discovery.

Eighteen methods were selected from the survey and incorporated into the
protocol, expanding the architecture from 25 to 30 loops. The key
additions were:

- **Self-Discover** (Zhou et al. 2024): Task-adaptive reasoning blueprint
  construction. This method addressed the rigidity of AGE's fixed loop
  structure by allowing the protocol to customize its approach for each
  target.

- **Graph of Thoughts** (Besta et al. 2023): Graph-based reasoning with
  merge and loop operations. This replaced AGE's linear solution
  generation with a more flexible exploration of the solution space.

- **Chain of Verification** (Dhuliawala et al. 2023): Decomposed
  verification questions. This was the first adversarial element
  introduced to the protocol, addressing AGE's complete lack of
  verification.

- **Multi-Agent Debate** (Du et al. 2023): Adversarial debate between
  multiple LLM instances. This further strengthened the verification
  capability by introducing genuine adversarial dynamics.

- **RAP/MCTS** (Hao et al. 2023): Planning-based reasoning with Monte
  Carlo Tree Search. This provided a more systematic approach to
  navigating the solution space for complex gaps.

- **Buffer of Thoughts** (Yang et al. 2024): Reusable template library.
  This was the first self-improvement element, addressing AGE's inability
  to learn across runs.

The expanded protocol showed measurable improvement: higher gap counts,
more diverse findings across categories, and the first tentative
verification of gap claims. However, the architecture still lacked a
philosophical foundation. The methods were powerful tools, but they were
applied mechanistically rather than being grounded in a coherent
analytical framework.

### 7.3 User Feedback Round 2: "First Principles Should Be Foundational"

The second evolution was triggered by more specific user feedback: "First
Principles should be foundational, not just another loop." And: "Add more
AI/ML research methods."

This feedback exposed a structural problem. First Principles decomposition
had been included in AGE as one loop among many, buried in the middle of
the Architect's analysis sequence. By the time First Principles was
applied, the protocol had already generated numerous findings based on
unexamined assumptions. Moving First Principles to Loop 1 required
restructuring the entire protocol: all subsequent loops now had to build
on the axiom set established by First Principles rather than on inherited
domain conventions.

The restructuring had a profound effect. With First Principles as the
foundation, the protocol's findings became more rigorous: every gap claim
could be traced back to a specific axiom, and gaps that could not be so
traced were immediately suspect. The practice of grounding analysis in
irreducible truths, which Aristotle articulated as "the first basis from
which a thing is known," proved to be a remarkably effective organizing
principle for a 21st-century AI protocol.

Additional AI/ML methods were incorporated during this phase, expanding
the architecture to 32 loops. The key additions included Self-Consistency
(Wang et al. 2022) for agreement verification and DiVeRSe (Li et al.
2023) for step-level verification. These additions strengthened the
verification phase but did not yet constitute the comprehensive validation
gauntlet that would emerge in the next iteration.

### 7.4 User Feedback Round 3: "I Want You to Discover New Science"

The third and most transformative evolution was triggered by an ambitious
user directive: "I want you to be AGI, discover new science." While AGI
remains beyond the scope of any current system, this directive motivated
the most comprehensive expansion of the protocol.

A second research phase surveyed over 50 methods across all domains ---
not just AI/ML, but philosophy, engineering, cognitive science, and
systems theory. The survey revealed that many of the reasoning challenges
confronting the protocol had been identified and addressed by philosophers
centuries or millennia earlier.

**Philosophical foundations were added:**

- **Abductive Reasoning** (Peirce): Inference to the best explanation.
  This addressed the protocol's inability to reason from symptoms to
  root causes, a capability that diagnostic reasoning has provided since
  the 19th century.

- **Falsificationism** (Popper 1963): The disprovability criterion. This
  became the protocol's most powerful anti-hallucination tool, providing a
  principled method for distinguishing genuine findings from fabricated
  ones.

- **Dialectics** (Hegel): Thesis-antithesis-synthesis. This formalized
  the adversarial debate process, providing a philosophical framework for
  resolving contradictions rather than simply picking winners.

- **Socratic Method** (Socrates/Plato): Recursive questioning. This
  provided a structured approach to assumption excavation that went far
  deeper than First Principles alone.

- **Bayesian Reasoning** (Bayes/Laplace): Probabilistic inference. This
  replaced the protocol's binary gap/not-gap classification with a
  continuous probability distribution that could be updated as evidence
  accumulated.

- **Causal Inference** (Pearl 2009): The three-rung causal hierarchy.
  This enabled the protocol to distinguish root causes from symptoms,
  a distinction that is operationally critical for prioritization.

- **Analogical Reasoning** (Gentner 1983): Cross-domain transfer. This
  addressed category blindness by importing insights from unfamiliar
  domains.

**Engineering frameworks were strengthened:**

- **TRIZ** (Altshuller 1996): Contradiction-based inventive problem
  solving. This provided a systematic approach to gaps that manifest as
  unresolved contradictions.

- **FMEA** was elevated from a simple severity scale to a full RPN
  computation with three independent dimensions (Severity, Occurrence,
  Detection).

- **Morphological Analysis** (Zwicky 1969): Exhaustive space enumeration.
  This addressed category blindness at the structural level by
  constructing an explicit coverage grid.

- **Pre-Mortem** (Klein 2007): Prospective hindsight. This addressed
  optimism bias by reframing risk assessment as post-failure analysis.

**Self-improvement mechanisms were added:**

- **Reflexion** (Shinn et al. 2023): Verbal reinforcement learning. This
  enabled the protocol to learn from its own failures without gradient
  updates.

- **CRITIC** (Gou et al. 2024): Quantitative self-assessment. This
  provided objective metrics for tracking performance improvement across
  runs.

- **Absolute Zero** (Zhao et al. 2025): Self-play for capability
  expansion. This enabled the protocol to actively push its own
  capability frontier by generating progressively harder challenges.

The final architecture emerged from this third expansion: 37 loops, 35
methods, seven phases. The protocol had evolved from a simple multi-
persona gap finder into a comprehensive multi-method reasoning framework
that integrated the best of three distinct intellectual traditions.

### 7.5 The Naming

The protocol's evolution warranted a new name. AGE (Autonomous Growth
Engine) reflected the original vision of automated gap analysis. ATOM
(Axiomatic Thinking for Omnidirectional Meta-analysis) reflects the
mature protocol's philosophy and methodology.

Each word was chosen deliberately:

- **Axiomatic:** The protocol starts from first principles --- axioms
  that are self-evidently true. This reflects the foundational role of
  Loop 1 (First Principles decomposition) and the Aristotelian
  philosophical tradition that grounds the entire framework.

- **Thinking:** ATOM is a reasoning protocol, not a checklist. It does
  not enumerate items to check; it reasons about the target from multiple
  angles, synthesizes findings, and evolves its own methodology. The word
  "thinking" distinguishes it from static analysis frameworks.

- **Omnidirectional:** The protocol attacks the target from 35 directions
  simultaneously. No single angle is privileged; the combination of
  perspectives is the source of the protocol's power. This reflects the
  multi-method design philosophy and the deliberate inclusion of methods
  from three distinct intellectual traditions.

- **Meta-analysis:** ATOM performs analysis OF analysis. Its target is
  not a system but the analysis of a system. It discovers gaps not by
  examining the system directly but by examining the space of possible
  analyses of that system and identifying which analyses are missing. This
  meta-cognitive orientation distinguishes ATOM from conventional analysis
  frameworks.

The name also carries a cultural reference. Atom is the protagonist of
Osamu Tezuka's *Astro Boy* (known as *Pluto* in Naoki Urasawa's 2003
reimagining) --- an artificial being that transcends its original
programming to develop genuine understanding and moral reasoning. The
parallel is intentional: ATOM the protocol aspires to transcend the
limitations of its component methods by combining them into something
greater than the sum of its parts.

---

## 8. The ATOM Constitution

### 8.1 Why a Constitution

Inspired by Constitutional AI (Bai et al. 2022), the ATOM Constitution
provides a set of explicit principles that govern the quality of every
gap claim produced by the protocol. The Constitution serves two purposes.

First, it provides machine-verifiable quality gates. Each of the eight
articles specifies a concrete test that a gap claim must pass. This
transforms quality assessment from a subjective judgment ("is this finding
good?") into an objective evaluation ("does this finding satisfy all eight
articles?").

Second, it provides transparency and auditability. Any consumer of ATOM's
output can evaluate each finding against the Constitution and independently
verify that it meets the stated quality standards. This transparency is
critical for building trust in the protocol's outputs, particularly in
high-stakes domains where gap findings inform significant resource
allocation decisions.

### 8.2 The Eight Articles

**Article I: EVIDENCE.** Every gap claim must cite specific, reproducible
evidence from the target system. Acceptable evidence includes: code
references (file, function, line number), documentation quotes,
configuration values, architectural diagram references, and behavioral
observations with reproduction steps. Unacceptable evidence includes:
general impressions, arguments from authority, and claims based on the
analyst's "experience" without specific supporting observations.

*Test:* Does the gap claim include at least one specific, verifiable
reference to the target system?

**Article II: QUANTIFICATION.** Every gap claim must include a numeric
severity assessment using the FMEA Risk Priority Number (RPN = Severity
x Occurrence x Detection, each on a 1-10 scale) and a Bayesian posterior
probability P(real) indicating the protocol's confidence that the gap is
genuine. Verbal severity qualifiers ("high," "critical," "important") are
insufficient without accompanying numeric values.

*Test:* Does the gap claim include an RPN score with component values and
a P(real) probability?

**Article III: FAITHFUL REASONING.** The reasoning chain supporting each
gap claim must be translatable into symbolic logic without loss of meaning.
Each intermediate step must be a valid logical inference from the
preceding steps. This article prevents post-hoc rationalization: if the
reasoning sounds plausible in natural language but fails when translated
to symbolic logic, the claim is rejected.

*Test:* Can the reasoning chain be expressed as a sequence of valid
logical propositions and inferences?

**Article IV: ACTIONABILITY.** Every gap claim must be accompanied by a
concrete solution specification using one of the three templates defined
in Loop 25 (New Capability, Modification, or Infrastructure). A gap
without a solution specification is an observation, not a finding.

*Test:* Does the gap claim include a solution specification with defined
inputs, outputs, dependencies, and acceptance criteria?

**Article V: UNIQUENESS.** No two gap claims in the final report may
describe the same underlying issue. Duplicate and near-duplicate findings
must be merged during CEO Synthesis (Loop 31), with the causal DAG
used to determine which formulation is the primary finding and which are
manifestations.

*Test:* Is this gap claim semantically distinct from all other gap claims
in the report?

**Article VI: CROSS-IMPACT.** Every gap claim must specify its causal
relationships with other gaps in the report. These relationships are
expressed as edges in the causal DAG constructed during Loop 22. A gap
with no causal connections (no upstream causes, no downstream effects)
is either a standalone finding (legitimate) or insufficiently analyzed
(concerning). Standalone findings must be explicitly justified as
independent.

*Test:* Does the gap claim specify its position in the causal DAG (edges
in, edges out, or explicit justification of independence)?

**Article VII: ADVERSARIAL SURVIVAL.** Every gap claim must document
which verification methods it survived during Phase 3. A gap that was
not subjected to verification, or that failed verification but was
reported anyway, violates this article. The surviving verification
methods serve as a confidence indicator: a gap that survived all eight
methods is more credible than one that survived five.

*Test:* Does the gap claim list the verification methods applied and the
result of each?

**Article VIII: FALSIFIABILITY.** Every gap claim must specify what
evidence would disprove it. If no such evidence can be specified, the
claim is unfalsifiable and must be reclassified as a "structural
assumption" rather than a gap. This article implements Karl Popper's
criterion of scientific demarcation: a claim that cannot be disproven is
not a scientific finding.

*Test:* Does the gap claim specify at least one conceivable observation
that would disprove it?

### 8.3 Article VIII Deep Dive: Why Popper Matters

Article VIII deserves special attention because it represents the single
most important quality control mechanism in the ATOM Constitution.

Karl Popper argued in *The Logic of Scientific Discovery* (1963) that the
defining characteristic of a scientific claim is not that it can be proven
true but that it can be proven false. A claim that is consistent with
every possible observation tells us nothing, because there is no
conceivable state of affairs that would count as evidence against it.

In the context of gap discovery, unfalsifiable claims are a particularly
insidious form of false positive. Consider the claim: "The system may
not handle edge cases well." This claim is unfalsifiable because there is
no finite amount of testing that could prove the system handles ALL edge
cases well. It sounds like a finding, and it might even be true, but it
cannot be acted upon because there is no way to verify whether it has
been resolved.

Compare this with the falsifiable claim: "The system does not validate
email addresses on the registration form, allowing entries like 'abc' or
'@.com' to be stored in the database." This claim specifies what would
disprove it (demonstrating that the system does validate email addresses),
it is actionable (add email validation), and it can be verified
(test the registration form with invalid inputs).

By requiring falsifiability, Article VIII forces ATOM's gap claims to be
specific, testable, and actionable. It prevents the protocol from
generating vague, opinion-based "findings" that sound authoritative but
provide no basis for action. It is, in the vocabulary of the protocol's
development team, the "ultimate bullshit filter."

Claims that fail Article VIII are not discarded but reclassified. They
are reported as "structural assumptions" in the Epistemic Humility Report
(Loop 33), under the "Known Unknowns" category. This reclassification
acknowledges their potential importance while clearly distinguishing them
from verified, actionable findings.

---

## 9. Self-Improvement Mechanism

### 9.1 Overview

ATOM's self-improvement mechanism consists of three complementary
subsystems, each operating in a different dimension of improvement. The
combination is designed to ensure that the protocol improves across runs
in coverage, precision, and capability simultaneously.

The three subsystems are:

1. **Buffer of Thoughts (Loop 34):** Pattern accumulation --- what
   worked, expressed as reusable templates.
2. **Reflexion (Loop 35):** Qualitative reflection --- what went wrong,
   expressed as natural language lessons.
3. **CRITIC (Loop 36):** Quantitative assessment --- how well did the
   protocol perform, expressed as numeric metrics.
4. **Absolute Zero (Loop 37):** Capability expansion --- generating
   harder challenges to push the frontier.

### 9.2 Buffer of Thoughts: Template Library

Buffer of Thoughts (Yang et al. 2024) operates in Loop 34 to extract
reusable discovery templates from the current run. The extraction process
identifies patterns at three levels of abstraction:

**Domain-Level Templates.** Generalized patterns that apply to an entire
domain. Example: "For web applications, always check for OWASP Top 10
vulnerabilities, focusing on injection, broken authentication, and
sensitive data exposure."

**Component-Level Templates.** Patterns that apply to specific component
types within a domain. Example: "For database access layers, always check
for connection pooling, query parameterization, and transaction isolation
level."

**Interaction-Level Templates.** Patterns that apply to the interaction
between components. Example: "For microservice architectures, always check
for circuit breaker implementation, retry logic with exponential backoff,
and distributed tracing across service boundaries."

Templates are stored with metadata that tracks their provenance (which
run and which gap generated them), their confidence (how many runs have
validated them), and their domain applicability (which types of targets
they are relevant to). On subsequent runs, the template retrieval
mechanism selects templates whose domain tags match the current target
and provides them to Phase 2's discovery loops as additional input.

The expected benefit is faster convergence: instead of rediscovering the
same patterns on every run, the protocol builds on accumulated knowledge.
The risk is template bias, where the protocol over-relies on historical
patterns and under-invests in novel discovery. This risk is mitigated by
the zero-context loops (Loops 6, 8, 11), which operate without template
input and therefore remain unbiased by historical patterns.

### 9.3 Reflexion: Verbal Reinforcement Learning

Reflexion (Shinn et al. 2023) operates in Loop 35 to generate qualitative
self-assessments of the current run. The reflection process is structured
around six questions:

1. "Which discovery loops produced the highest-quality findings (highest
   RPN, highest P(real), most unique contributions)?"
2. "Which discovery loops produced the most false positives (findings
   rejected during validation)?"
3. "What types of gaps were discovered by only a single method, suggesting
   that coverage in that area is thin?"
4. "What regions of the coverage grid (from Loop 4) remain empty after
   this run?"
5. "If this run could be repeated with only 15 of the 37 loops, which
   loops would be selected for this target?"
6. "What specific patterns or domain knowledge would have made this run
   more effective?"

The reflections are stored in `memory/atom-reflexions.md` and are
prepended to the protocol context in subsequent runs. The prepending
mechanism ensures that the protocol "remembers" its previous self-
assessments without requiring any modification to its structure or
parameters.

The expected benefit is fewer repeated mistakes: if the protocol
identifies that a particular loop consistently produces false positives
on a particular type of target, subsequent runs can deprioritize that
loop or apply additional scrutiny to its findings. The risk is reflection
bias, where the protocol's self-assessment is inaccurate (it blames the
wrong loop or misidentifies the cause of false positives). This risk is
mitigated by CRITIC (Loop 36), which provides quantitative metrics that
can be compared against the qualitative reflections for consistency.

### 9.4 CRITIC: Quantitative Self-Assessment

CRITIC (Gou et al. 2024) operates in Loop 36 to compute quantitative
performance metrics. These metrics provide an objective complement to
Reflexion's qualitative assessments.

The metrics computed are:

- **Total Gap Count:** The number of gaps discovered (pre-validation),
  verified (post-validation), and rejected.
- **False Positive Rate (FPR):** The proportion of discovered gaps
  rejected during Phase 3 validation. A declining FPR across runs
  indicates improving precision.
- **Coverage Score:** The proportion of the coverage grid (from Loop 4)
  with at least one verified finding. An increasing coverage score
  indicates improving recall.
- **Method Efficiency Matrix:** For each of the 35 methods, the number
  of unique gaps it contributed (found by this method and no other).
  Methods with zero unique contributions may be candidates for removal
  in future protocol versions.
- **Severity Distribution:** A histogram of RPN scores across verified
  gaps. A shift toward higher-severity findings across runs would
  indicate that the protocol is becoming better at identifying important
  gaps.
- **Convergence Index:** The average number of methods that
  independently identified each verified gap. A higher convergence index
  indicates stronger agreement among methods and higher confidence in
  findings.

These metrics are stored alongside the Reflexion output and are tracked
across runs to produce a performance trajectory. The trajectory enables
data-driven decisions about protocol evolution: methods that consistently
contribute unique findings are retained; methods that consistently produce
false positives are candidates for modification or replacement.

### 9.5 Absolute Zero: Self-Play for Capability Expansion

Absolute Zero (Zhao et al. 2025) operates in Loop 37 to generate
training challenges that push the protocol's capability frontier. While
Reflexion learns from past mistakes and CRITIC measures current
performance, Absolute Zero actively creates the conditions for future
improvement.

The challenge generation process produces three types of challenges:

**Subtle Gaps.** Gaps that require deep domain expertise or multi-step
reasoning to identify. These challenges are at the frontier of the
protocol's current capability: the protocol might identify them with
additional effort but would not reliably discover them in its current
configuration. Example: "Generate a system description where the gap is
a timing side-channel vulnerability that only manifests under specific
concurrent access patterns."

**Emergent Gaps.** Gaps that arise from the interaction of multiple
components and are invisible when components are analyzed individually.
These challenges test the protocol's ability to reason about system-level
properties rather than component-level properties. Example: "Generate a
microservice architecture where the gap only becomes apparent when
considering the interaction between the authentication service, the rate
limiter, and the logging service."

**Causal Confounds.** Scenarios where the apparent root cause is actually
a symptom, and the real root cause is non-obvious. These challenges test
the protocol's causal reasoning capability (Loops 7 and 22). Example:
"Generate a system where fixing the apparent performance bottleneck
actually degrades performance because the real bottleneck is elsewhere."

Each challenge is calibrated according to the Goldilocks Principle: it
must be difficult enough to require improvement from the protocol but not
so difficult that no progress is possible. The calibration is based on
the current run's performance metrics from CRITIC: challenges are
generated at a difficulty level slightly above the protocol's demonstrated
capability.

The protocol then attempts to solve its own challenges. Successful
solutions contribute new templates to Buffer of Thoughts. Failures
contribute new reflections to Reflexion. The cycle of challenge
generation, attempted solution, and learning accelerates the protocol's
improvement trajectory.

### 9.6 Expected Convergence

Based on the architecture of the self-improvement mechanism, we expect
the following convergence trajectory:

**Run 1 (Baseline):** No templates, no reflexions, no challenges. The
protocol operates from its default configuration. Performance is
determined entirely by the quality of the 35 methods and their
sequencing.

**Run 2:** Templates from Run 1 are available for retrieval. Reflexions
from Run 1 inform discovery priorities. CRITIC metrics from Run 1
establish baseline performance. Expected improvement: faster discovery
(templates accelerate familiar patterns), fewer false positives
(reflexions highlight problematic loops).

**Run 3:** Template library has grown with contributions from Runs 1
and 2. Reflexions have accumulated two runs of lessons. Absolute Zero
challenges from Run 2 inform Run 3's focus areas. Expected improvement:
broader coverage (challenges push into underexplored areas), more
accurate severity assessment (FMEA calibration improves with experience).

**Run 4+:** Compound improvement continues with diminishing returns. The
template library stabilizes as the most important domain patterns are
captured. Reflexions become more nuanced as the protocol's self-model
improves. Absolute Zero challenges become increasingly subtle as obvious
capability gaps are addressed.

**Theoretical steady state:** Template library stabilizes, false positive
rate reaches a floor determined by LLM capability limitations, coverage
score plateaus at a ceiling determined by the target's inherent
complexity. The protocol reaches a point where additional runs yield
minimal improvement and the primary value comes from applying the
accumulated template library to new targets.

---

## 10. Experimental Design

### 10.1 Overview

This paper presents ATOM as a methodology. Empirical validation of its
effectiveness remains future work. In this section, we propose a rigorous
experimental design for that validation, including hypotheses, metrics,
controls, and benchmark targets.

### 10.2 Hypothesis 1: ATOM Finds More Valid Gaps Than Single-Method Approaches

**Hypothesis:** ATOM's multi-method architecture discovers more valid
gaps than any individual method or simple combination of methods.

**Experiment:** Run ATOM on each benchmark target and compare the results
against four baselines:
- AGE v1.0 (25-loop predecessor with no verification)
- Manual expert audit (domain expert with checklist)
- Single-method LLM review (GPT-4/Claude asked to "find gaps")
- Two-method combination (best-performing pair of methods from ATOM)

**Metrics:**
- Gap count (total verified gaps discovered)
- Precision (valid gaps / total reported gaps)
- Recall (found gaps / true gaps, where "true gaps" are determined by
  union of all methods plus expert panel review)
- F1 score (harmonic mean of precision and recall)

**Expected result:** ATOM achieves the highest recall (most gaps found)
with competitive precision (low false positive rate). The single-method
LLM review is expected to have high recall but low precision (many
hallucinated gaps). The manual audit is expected to have high precision
but low recall (few false positives but many missed gaps).

### 10.3 Hypothesis 2: Multi-Method Verification Reduces False Positives

**Hypothesis:** Phase 3's eight verification methods substantially
reduce the false positive rate compared to no verification or single-
method verification.

**Experiment:** Ablation study comparing five conditions:
- Full ATOM (all 8 verification methods)
- ATOM minus Phase 3 (no verification)
- ATOM with only FMEA verification
- ATOM with only Falsification verification
- ATOM with only Dialectical Debate verification

**Metrics:**
- False positive rate (rejected gaps / initial gaps from Phase 2)
- True positive rate (gaps correctly verified / actual gaps)
- Verification cost (computation time in Phase 3 / total computation)

**Expected result:** Full ATOM achieves the lowest false positive rate,
with each verification method contributing unique value. The "no
verification" condition is expected to have a false positive rate 40-60%
higher than full ATOM. Single-method verification is expected to fall
between these extremes, with Falsification contributing the most to
false positive reduction and FMEA contributing the most to severity
accuracy.

### 10.4 Hypothesis 3: Self-Improvement Increases Quality Across Runs

**Hypothesis:** ATOM's self-improvement mechanism (Buffer of Thoughts,
Reflexion, CRITIC, Absolute Zero) produces monotonically improving
quality across successive runs on the same target.

**Experiment:** Run ATOM five times on each benchmark target, with the
self-improvement mechanism active (templates, reflexions, and metrics
accumulated across runs). Compare against a control condition where each
run starts from scratch (no accumulated state).

**Metrics:**
- Gap quality score (expert-rated quality of gap descriptions and
  solutions on a 1-10 scale)
- Coverage score (proportion of coverage grid with verified findings)
- Efficiency (verified gaps per discovery loop)
- False positive rate trajectory (FPR across runs 1-5)

**Expected result:** With self-improvement active, gap quality score
and coverage score increase monotonically across runs 1-5, with
diminishing returns after run 3. False positive rate decreases
monotonically. Without self-improvement (control), performance is
approximately constant across runs, with random variation.

### 10.5 Hypothesis 4: Philosophical Methods Find Gaps AI/ML Methods Miss

**Hypothesis:** Tier 2 (philosophical) methods discover gap categories
that Tier 1 (AI/ML) methods alone cannot discover.

**Experiment:** Ablation study comparing three conditions:
- Full ATOM (all three tiers)
- ATOM without Tier 2 (AI/ML + Engineering only)
- ATOM without Tier 1 (Philosophy + Engineering only)

**Metrics:**
- Gap category distribution (proportion of gaps in each category:
  technical, architectural, process, assumption-based, causal, strategic)
- Unique gaps per method (gaps found by only one method)
- Gap depth score (expert-rated depth of analysis on a 1-10 scale)

**Expected result:** Tier 2 methods uniquely contribute assumption-based
gaps (discovered by Socratic Method and First Principles), causal gaps
(discovered by Causal Inference and Abductive Reasoning), and epistemic
gaps (discovered by Epistemic Humility and Falsification). These gap
categories are underrepresented or absent when Tier 2 methods are
removed.

### 10.6 Proposed Benchmark Targets

To ensure generalizability, the experimental design includes four
benchmark targets spanning different domains:

**Target 1: Software Framework (Meta-Analysis).** ATOM is applied to
its own implementation framework. This meta-analysis tests the protocol's
ability to discover gaps in a system it understands deeply, providing a
baseline for maximum coverage. The framework is a natural benchmark
because ground truth gaps are known to the development team.

**Target 2: Security Architecture.** A production-grade security
architecture for a financial services application. This target is
high-stakes, standard-heavy (PCI-DSS, SOC 2, OWASP), and has well-
defined completeness criteria. It tests the protocol's performance in a
domain with extensive formal requirements.

**Target 3: Business Strategy.** A go-to-market strategy for an early-
stage technology company. This target is abstract, has few formal
standards, and requires reasoning about competitive dynamics, market
positioning, and organizational capabilities. It tests the protocol's
performance in a domain where engineering frameworks are less applicable
and philosophical reasoning is more critical.

**Target 4: Scientific Methodology.** A research methodology for a
multi-disciplinary study combining machine learning and behavioral
science. This target involves cross-domain reasoning, emergence,
methodological rigor, and statistical validity. It tests the protocol's
performance in a domain where causal reasoning and falsification are
paramount.

### 10.7 Control Conditions and Statistical Considerations

**Randomization:** The order in which benchmark targets are processed is
randomized across experimental sessions to control for ordering effects.

**Independence:** Each experimental condition is run independently, with
no shared state between conditions (separate template libraries,
separate reflexion histories).

**Inter-rater reliability:** For metrics requiring expert judgment (gap
quality score, depth score), three domain experts independently rate each
finding. Cohen's kappa is computed to ensure inter-rater reliability
above 0.7.

**Statistical significance:** Each condition is replicated a minimum of
three times per benchmark target. Results are compared using paired
t-tests (for pairwise comparisons) or ANOVA (for multi-condition
comparisons) with Bonferroni correction for multiple comparisons. A
significance threshold of p < 0.05 is used.

**Effect size:** In addition to statistical significance, Cohen's d is
reported for all comparisons to quantify the practical magnitude of
observed differences.

---

## 11. Limitations and Future Work

### 11.1 Current Limitations

**Computational cost.** Running 37 loops with 35 distinct methods is
computationally expensive. Each loop requires one or more LLM inference
calls, and the total cost of a complete ATOM run scales linearly with the
number of loops and the complexity of the target. For large targets
(entire codebases, comprehensive business strategies), a single run may
require hundreds of inference calls. Mitigation: Self-Discover (Loop 3)
can be used to select the most relevant subset of methods for each target,
reducing the number of active loops while preserving coverage for the
most important methods. Future work should investigate optimal method
selection strategies.

**LLM capability bounds.** Current language models have well-documented
limitations in causal reasoning (Kiciman et al. 2023), particularly at
Rungs 2 and 3 of Pearl's causal hierarchy (intervention and
counterfactual reasoning). ATOM's causal inference loop (Loop 22) is
therefore limited by the underlying model's causal reasoning capability.
As models improve, the protocol's causal analysis will improve
correspondingly.

**Empirical validation needed.** This paper presents the ATOM protocol
as a methodology. The experimental design in Section 10 has not yet been
executed. The claims about expected improvements (higher coverage, lower
false positive rate, self-improvement across runs) are based on
theoretical analysis and informal observation, not rigorous empirical
measurement. Formal empirical validation is the most critical piece of
future work.

**Anchoring within loops.** The Ralph Wiggum Protocol (zero-context
loops) prevents anchoring BETWEEN loops but does not eliminate anchoring
WITHIN loops. A single loop that generates multiple findings may still
exhibit anchoring effects, where the first finding within that loop
influences subsequent findings. Mitigation: Self-Consistency (Loop 24)
provides a partial check by requiring agreement across independently
generated assessments, but a complete solution would require generating
each finding in a separate inference call.

**Domain expertise.** ATOM is domain-general by design, but domain
expertise improves results. The protocol applied to a software system by
a software-savvy LLM will produce better results than the same protocol
applied to a medical device by the same model. ATOM does not substitute
for domain expertise; it provides a structured methodology that amplifies
whatever domain knowledge the underlying model possesses.

**Template degradation.** Buffer of Thoughts templates that are valid for
one version of a system may become outdated as the system evolves. The
template library does not currently include a mechanism for automatically
retiring outdated templates, beyond the confidence score degradation that
occurs when templates produce false positives.

### 11.2 Future Work

**Fine-tuned models for each loop type.** Different loops in the ATOM
protocol require different reasoning capabilities: abductive reasoning,
causal inference, adversarial argumentation, quantitative scoring. Future
work could explore fine-tuning specialized models for each loop type,
potentially improving the quality of each loop's output.

**Tool-integrated CRITIC.** The current CRITIC implementation (Loop 36)
relies on the LLM's self-assessment. Future work could integrate CRITIC
with external tools such as static code analyzers, test runners,
documentation coverage tools, and compliance scanners. These tools would
provide ground-truth validation of gap claims that the LLM alone cannot
verify.

**Cross-framework learning.** Currently, templates and reflexions are
specific to the target on which they were generated. Future work could
explore transfer learning across targets: do templates generated from
analyzing a web application improve performance on analyzing a mobile
application? The answer may depend on the level of abstraction at which
templates are expressed.

**Human-in-the-loop validation studies.** Future work should investigate
how human experts interact with ATOM's outputs. Do experts find the
Epistemic Humility Report (Known Knowns/Known Unknowns/Unknown Unknowns)
useful? Does the FMEA scoring align with expert severity assessments? Do
the causal DAGs accurately represent expert understanding of root causes?
These questions require controlled studies with domain experts.

**Formal verification of Constitution compliance.** The eight articles
of the ATOM Constitution are currently enforced through LLM self-
evaluation. Future work could develop formal verification methods that
guarantee Constitution compliance through automated checking, removing
the dependence on the LLM's self-assessment capabilities.

**Multi-LLM ensemble.** Different language models have different
strengths: some excel at logical reasoning, others at creative generation,
others at domain-specific knowledge. Future work could explore running
different loops on different models, selecting each model for its
alignment with the loop's requirements.

**Adversarial robustness testing.** Future work should investigate
whether ATOM's findings can be adversarially manipulated by carefully
crafted target descriptions. If a target system description is designed
to mislead the protocol into missing certain gaps or hallucinating
others, does ATOM's multi-method architecture provide robustness against
such manipulation?

---

## 12. Conclusion

ATOM (Axiomatic Thinking for Omnidirectional Meta-analysis) represents a
new approach to systematic gap discovery. By integrating 35 methods from
three distinct intellectual traditions --- AI/ML research, philosophical
reasoning, and engineering analysis --- into a seven-phase, 37-loop
protocol, ATOM addresses the fundamental blind spot problem: the
inability of AI systems to systematically discover what is missing rather
than merely building what is requested.

The key contributions of this work are:

**First, the multi-tradition integration.** ATOM is, to our knowledge,
the first framework that formally combines AI/ML reasoning enhancement,
philosophical reasoning traditions, and engineering analysis methods into
a unified discovery protocol. Each tradition contributes capabilities
that the others lack: AI/ML methods provide cutting-edge reasoning
enhancement, philosophical methods provide deep analytical foundations
tested over millennia, and engineering methods provide quantitative rigor
battle-tested in safety-critical industries.

**Second, the foundational role of First Principles.** By placing First
Principles decomposition as Loop 1, ATOM ensures that all subsequent
analysis proceeds from irreducible truths rather than inherited
assumptions. This Aristotelian foundation transforms gap discovery from
a search through checklists into a reasoning process grounded in axioms.

**Third, the eight-method adversarial verification phase.** ATOM's
Phase 3 subjects every gap claim to eight distinct verification methods,
creating a gauntlet that eliminates false positives with high confidence.
The allocation of eight of 37 loops (22% of the protocol) to verification
reflects the conviction that credibility --- reporting only genuine
findings --- is more important than completeness.

**Fourth, the ATOM Constitution.** The eight-article Constitution
provides machine-verifiable quality gates for every gap claim. Article
VIII (Falsifiability) is particularly important: by requiring that every
finding specify what evidence would disprove it, the Constitution
implements Popper's criterion of scientific demarcation as a practical
quality filter.

**Fifth, the three-mechanism self-improvement system.** Buffer of
Thoughts (pattern accumulation), Reflexion (qualitative learning), CRITIC
(quantitative measurement), and Absolute Zero (capability expansion)
enable the protocol to improve across successive runs without gradient
updates. The combination of four complementary improvement mechanisms is
designed to ensure improvement along multiple dimensions simultaneously.

**Sixth, formal epistemic humility.** The Known Knowns / Known Unknowns /
Unknown Unknowns reporting framework (Loop 33) explicitly acknowledges
the limits of the protocol's analysis. This prevents the false confidence
that would arise from presenting only findings while suppressing
uncertainty.

The broader vision of ATOM extends beyond its immediate application to
software and business gap analysis. The protocol treats gap discovery as
a domain-general reasoning problem: the systematic identification of
what is missing from any structured body of knowledge or practice. The
same methodology that discovers missing features in a codebase can
discover missing considerations in a business strategy, missing controls
in a security architecture, or missing variables in a scientific model.

From "what is missing in this codebase" to "what is missing in this
theory," ATOM provides a structured, reproducible, self-improving
methodology for the most fundamental question in any analytical
endeavor: not "what is here?" but "what should be here that is not?"

ATOM is not merely a tool. It is a methodology for structured thinking
--- a formalization of the analytical process that humans perform
intuitively but inconsistently. By making this process explicit,
reproducible, and self-improving, ATOM aspires to transform gap discovery
from an art dependent on individual expertise into a science grounded in
multi-method reasoning and empirical self-assessment.

---

## 13. References

Altshuller, G. S. (1996). "And Suddenly the Inventor Appeared: TRIZ, the
Theory of Inventive Problem Solving." Technical Innovation Center.
ISBN 978-0964074026.

Bai, Y., Kadavath, S., Kundu, S., Askell, A., Kernion, J., Jones, A.,
Chen, A., Goldie, A., Mirhoseini, A., McKinnon, C., Chen, C., Olsson,
C., Olah, C., Hernandez, D., Drain, D., Ganguli, D., Li, D., Tran-
Johnson, E., Perez, E., Kerr, J., Mueller, J., Ladish, J., Landau, J.,
Ndousse, K., Lukosuite, K., Lovitt, L., Sellitto, M., Elhage, N.,
Schiefer, N., Mercado, N., DasSarma, N., Lasenby, R., Larson, R., Ringer,
S., Johnston, S., Kravec, S., El Showk, S., Fort, S., Lanham, T., Telleen-
Lawton, T., Conerly, T., Henighan, T., Hume, T., Bowman, S. R., Hatfield-
Dodds, Z., Mann, B., Amodei, D., Joseph, N., McCandlish, S., Brown, T.,
& Kaplan, J. (2022). "Constitutional AI: Harmlessness from AI Feedback."
arXiv:2212.08073.

Besta, M., Blach, N., Kubicek, A., Gerstenberger, R., Gianinazzi, L.,
Gajber, J., Lehmann, T., Nyczyk, M., Pyrzynski, R., Buhler, T., & Hoefler,
T. (2023). "Graph of Thoughts: Solving Elaborate Problems with Large
Language Models." Proceedings of the AAAI Conference on Artificial
Intelligence. arXiv:2308.09687.

Bhagavatula, C., Bras, R. L., Malaviya, C., Sakaguchi, K., Holtzman, A.,
Rashkin, H., Downey, D., Yih, W., & Choi, Y. (2020). "Abductive
Commonsense Reasoning." Proceedings of ICLR 2020. arXiv:1908.05739.

Chang, E. Y. (2023). "Prompting Large Language Models with the Socratic
Method." Proceedings of the IEEE International Conference on Big Data.
arXiv:2303.08769.

Chen, W., Ma, X., Wang, X., & Cohen, W. W. (2023). "Program of Thoughts
Prompting: Disentangling Computation from Reasoning for Numerical
Reasoning Tasks." Transactions on Machine Learning Research.
arXiv:2211.12588.

Crompton, S. (2023). "Epistemic Humility in Artificial Intelligence:
A Framework for Responsible AI." AI and Ethics, 3(4), 1127-1141.

Dhuliawala, S., Komeili, M., Xu, J., Raileanu, R., Li, X., Celikyilmaz,
A., & Weston, J. (2023). "Chain-of-Verification Reduces Hallucination
in Large Language Models." arXiv:2309.11495.

Du, Y., Li, S., Torralba, A., Tenenbaum, J. B., & Mordatch, I. (2023).
"Improving Factuality and Reasoning in Language Models through Multiagent
Debate." Proceedings of the 41st International Conference on Machine
Learning. arXiv:2305.14325.

Ganguli, D., Lovitt, L., Kernion, J., Askell, A., Bai, Y., Kadavath, S.,
Mann, B., Perez, E., Schiefer, N., Ndousse, K., Jones, A., Bowman, S.,
Chen, A., Conerly, T., DasSarma, N., Drain, D., Elhage, N., El-Showk,
S., Fort, S., Hatfield-Dodds, Z., Henighan, T., Hernandez, D., Hume, T.,
Jacobson, J., Johnston, S., Kravec, S., Olsson, C., Ringer, S., Tran-
Johnson, E., Amodei, D., Brown, T., Joseph, N., McCandlish, S., Olah, C.,
Kaplan, J., & Clark, J. (2022). "Red Teaming Language Models to Reduce
Harms: Methods, Scaling Behaviors, and Lessons Learned." arXiv:2209.07858.

Gentner, D. (1983). "Structure-Mapping: A Theoretical Framework for
Analogy." Cognitive Science, 7(2), 155-170.

Goldratt, E. M. (1990). "Theory of Constraints." North River Press.
ISBN 978-0884271666.

Gou, Z., Shao, Z., Gong, Y., Shen, Y., Yang, Y., Huang, M., Duan, N.,
& Chen, W. (2024). "CRITIC: Large Language Models Can Self-Correct with
Tool-Interactive Critiquing." Proceedings of ICLR 2024.
arXiv:2305.11738.

Hao, S., Gu, Y., Ma, H., Hong, J. J., Wang, Z., Wang, D. Z., & Hu, Z.
(2023). "Reasoning with Language Model is Planning with World Model."
Proceedings of EMNLP 2023. arXiv:2305.14992.

Ji, Z., Lee, N., Frieske, R., Yu, T., Su, D., Xu, Y., Ishii, E., Bang,
Y. J., Madotto, A., & Fung, P. (2023). "Survey of Hallucination in
Natural Language Generation." ACM Computing Surveys, 55(12), 1-38.

Jin, Z., Liu, J., Lyu, Z., Peng, S., Gerstenberg, T., Mihalcea, R., &
Scholkopf, B. (2024). "Can Large Language Models Infer Causation from
Correlation?" Proceedings of ICLR 2024. arXiv:2306.05836.

Kiciman, E., Ness, R., Sharma, A., & Tan, C. (2023). "Causal Reasoning
and Large Language Models: Opening a New Frontier for Causality."
arXiv:2305.00050.

Klein, G. (2007). "Performing a Project Premortem." Harvard Business
Review, 85(9), 18-19.

Li, Y., Lin, Z., Zhang, S., Fu, Q., Chen, B., Lou, J., & Chen, W.
(2023). "Making Language Models Better Reasoners with Step-Aware Verifier."
Proceedings of ACL 2023. arXiv:2206.02336.

Lyu, Q., Havaldar, S., Stein, A., Zhang, L., Rao, D., Wong, E.,
Apidianaki, M., & Callison-Burch, C. (2023). "Faithful Chain-of-Thought
Reasoning." Proceedings of IJCNLP-AACL 2023. arXiv:2301.13379.

Microsoft Research. (2025). "Dialectical Reasoning with Large Language
Models." Technical Report MSR-TR-2025-01.

Mouret, J.-B., & Clune, J. (2015). "Illuminating Search Spaces by
Mapping Elites." arXiv:1504.04909.

Nye, M., Andreassen, A. J., Gur-Ari, G., Michalewski, H., Austin, J.,
Biber, D., Dohan, D., Lewkowycz, A., Bosma, M., Luan, D., Sutton, C.,
& Odena, A. (2021). "Show Your Work: Scratchpads for Intermediate
Computation with Language Models." arXiv:2112.00114.

Pearl, J. (2009). "Causality: Models, Reasoning, and Inference." Second
Edition. Cambridge University Press. ISBN 978-0521895606.

Perez, E., Huang, S., Song, F., Cai, T., Ring, R., Aslanides, J.,
Glaese, A., McAleese, N., & Irving, G. (2022). "Red Teaming Language
Models with Language Models." Proceedings of EMNLP 2022.
arXiv:2202.03286.

Popper, K. R. (1963). "Conjectures and Refutations: The Growth of
Scientific Knowledge." Routledge. ISBN 978-0415285940.

Press, O., Zhang, M., Min, S., Schmidt, L., Smith, N. A., & Lewis, M.
(2022). "Measuring and Narrowing the Compositionality Gap in Language
Models." Findings of EMNLP 2023. arXiv:2210.03350.

Qiao, S., Ou, Y., Zhang, N., Chen, X., Yao, Y., Deng, S., Tan, C.,
Huang, F., & Chen, H. (2023). "Reasoning with Language Model Prompting:
A Survey." Proceedings of ACL 2023. arXiv:2212.09597.

Shinn, N., Cassano, F., Gopinath, A., Narasimhan, K., & Yao, S. (2023).
"Reflexion: Language Agents with Verbal Reinforcement Learning."
Advances in Neural Information Processing Systems (NeurIPS) 2023.
arXiv:2303.11366.

Tversky, A., & Kahneman, D. (1974). "Judgment Under Uncertainty:
Heuristics and Biases." Science, 185(4157), 1124-1131.

Wang, X., Wei, J., Schuurmans, D., Le, Q., Chi, E., Narang, S., Chowdhery,
A., & Zhou, D. (2022). "Self-Consistency Improves Chain of Thought
Reasoning in Language Models." Proceedings of ICLR 2023.
arXiv:2203.11171.

Wei, J., Wang, X., Schuurmans, D., Bosma, M., Ichter, B., Xia, F., Chi,
E., Le, Q., & Zhou, D. (2022). "Chain-of-Thought Prompting Elicits
Reasoning in Large Language Models." Advances in Neural Information
Processing Systems (NeurIPS) 2022. arXiv:2201.11903.

Yang, L., Yu, Z., Zhang, T., Cao, S., Xu, M., Gonzalez, J. E., & Cui, B.
(2024). "Buffer of Thoughts: Thought-Augmented Reasoning with Large
Language Models." Advances in Neural Information Processing Systems
(NeurIPS) 2024. arXiv:2406.04271.

Yao, S., Yu, D., Zhao, J., Shafran, I., Griffiths, T. L., Cao, Y., &
Narasimhan, K. (2023). "Tree of Thoughts: Deliberate Problem Solving
with Large Language Models." Advances in Neural Information Processing
Systems (NeurIPS) 2023. arXiv:2305.10601.

Yao, S., Zhao, J., Yu, D., Du, N., Shafran, I., Narasimhan, K., & Cao,
Y. (2022). "ReAct: Synergizing Reasoning and Acting in Language Models."
Proceedings of ICLR 2023. arXiv:2210.03629.

Zhang, Y., Du, Y., Huang, O., Zhuang, S., Wu, J., Shu, D., & Tang, J.
(2023). "Cumulative Reasoning with Large Language Models."
arXiv:2308.04371.

Zhao, Z., Fan, Y., Pang, T., Du, C., Liu, Q., & Lin, M. (2025).
"Absolute Zero: Reinforced Self-Play Reasoning with Zero Data."
arXiv:2505.03335.

Zheng, H. S., Mishra, S., Chen, X., Cheng, H.-T., Chi, E. H., Le, Q. V.,
& Zhou, D. (2024). "Take a Step Back: Evoking Reasoning via Abstraction
in Large Language Models." Proceedings of ICLR 2024. arXiv:2310.06117.

Zhou, P., Pujara, J., Ren, X., Chen, X., Cheng, H.-T., Le, Q. V., Chi,
E. H., Zhou, D., Mishra, S., & Zheng, H. S. (2024). "Self-Discover:
Large Language Models Self-Compose Reasoning Structures." arXiv:2402.03620.

Zwicky, F. (1969). "Discovery, Invention, Research Through the
Morphological Approach." Macmillan. ISBN 978-0802010247.

---

*End of paper.*
