---
name: EU AI Act Compliance
description: Risk classification, conformity assessment, and compliance guidance for AI systems under the EU Artificial Intelligence Act
---

# EU AI Act Compliance Skill

**Purpose**: Structured guidance for classifying AI systems by risk level under the EU AI Act (Regulation 2024/1689), implementing required technical and organizational measures, and preparing conformity assessments. Covers high-risk AI requirements, GPAI model obligations, transparency rules, prohibited practices, and implementation timelines with actionable checklists and documentation templates.

---

## TRIGGER COMMANDS

```text
"Classify my AI system under the EU AI Act"
"EU AI Act compliance requirements for [system]"
"AI Act risk assessment for [product]"
"GPAI model obligations for [model]"
"Using eu_ai_act_compliance skill: [task]"
```

---

> [!WARNING]
> This skill provides **compliance guidance only**. It is NOT legal advice. The EU AI Act carries penalties up to 35M EUR or 7% of global annual turnover (whichever is higher) for prohibited practices. Engage qualified EU regulatory counsel for your specific situation. The Act is still being supplemented by delegated and implementing acts -- requirements may evolve.

---

## AI ACT RISK CLASSIFICATION

### Risk Tiers Overview

| Risk Level | Regulatory Burden | Penalty for Non-Compliance | Examples |
|-----------|-------------------|---------------------------|----------|
| **Unacceptable** | Banned outright | Up to 35M EUR or 7% turnover | Social scoring, real-time biometric ID (with exceptions) |
| **High-Risk** | Full compliance regime | Up to 15M EUR or 3% turnover | Medical devices AI, hiring AI, credit scoring AI |
| **Limited Risk** | Transparency obligations | Up to 7.5M EUR or 1% turnover | Chatbots, emotion recognition, AI-generated content |
| **Minimal Risk** | No mandatory requirements | N/A | Spam filters, game AI, inventory optimization |

### Risk Classification Decision Tree

Use this decision tree to classify your AI system:

```
START: Does your AI system perform any prohibited practice?
  |
  +-- YES --> UNACCEPTABLE RISK (banned, do not deploy in EU)
  |           - Social scoring by governments
  |           - Real-time remote biometric ID in public spaces (law enforcement exceptions exist)
  |           - Emotion recognition in workplace or education
  |           - Biometric categorization by race, religion, sexual orientation
  |           - Untargeted scraping for facial recognition databases
  |           - Exploiting vulnerabilities of age, disability, social situation
  |           - Subliminal manipulation causing harm
  |
  +-- NO --> Is your system listed in Annex III high-risk categories?
      |
      +-- YES --> HIGH-RISK (full compliance required)
      |           See "Annex III Categories" below
      |
      +-- NO --> Is your system a safety component of a product covered
      |          by EU harmonized legislation (Annex I)?
      |   |
      |   +-- YES --> HIGH-RISK (if the product requires third-party conformity assessment)
      |   |
      |   +-- NO --> Does your system interact with natural persons?
      |       |
      |       +-- YES --> LIMITED RISK (transparency obligations)
      |       |           - Must disclose AI interaction to users
      |       |
      |       +-- NO --> Does your system generate or manipulate content?
      |           |
      |           +-- YES --> LIMITED RISK (labeling obligations)
      |           |           - Must label AI-generated content
      |           |
      |           +-- NO --> MINIMAL RISK (no mandatory requirements)
      |                       - Voluntary codes of conduct encouraged
```

### Annex III High-Risk Categories

| # | Category | Examples |
|---|----------|----------|
| 1 | Biometric identification and categorization | Remote biometric ID (non-real-time), biometric categorization |
| 2 | Critical infrastructure management | AI managing electricity, gas, water, transport, digital infrastructure |
| 3 | Education and vocational training | AI determining access to education, evaluating learning outcomes |
| 4 | Employment and worker management | AI for recruitment, screening, hiring decisions, task allocation |
| 5 | Essential services access | AI for credit scoring, insurance pricing, emergency services dispatch |
| 6 | Law enforcement | AI for risk assessment, polygraph, evidence analysis, crime prediction |
| 7 | Migration and border control | AI for visa/asylum processing, border surveillance |
| 8 | Justice and democratic processes | AI assisting judicial decisions, election influence |

---

## PROHIBITED PRACTICES (Article 5)

### Effective: February 2, 2025

The following AI practices are **banned** in the EU:

| Practice | Description | Why Prohibited |
|----------|------------|----------------|
| **Social scoring** | Classifying persons based on social behavior leading to detrimental treatment | Fundamental rights violation |
| **Subliminal manipulation** | Deploying techniques beyond consciousness to distort behavior causing harm | Autonomy violation |
| **Vulnerability exploitation** | Targeting age, disability, or social situation to distort behavior | Exploitative |
| **Real-time remote biometric ID** | Live facial recognition in public spaces by law enforcement (narrow exceptions) | Mass surveillance risk |
| **Emotion recognition** | Inferring emotions in workplace or educational settings | Privacy and dignity |
| **Biometric categorization** | Categorizing by race, politics, religion, sexual orientation from biometrics | Discrimination risk |
| **Untargeted facial scraping** | Building facial recognition databases from internet/CCTV scraping | Privacy violation |
| **Predictive policing (individual)** | Predicting individual criminal behavior solely from profiling | Presumption of innocence |

### Compliance Check

```markdown
## Prohibited Practices Self-Assessment

For each practice, confirm your AI system does NOT perform it:

| # | Practice | Our System Performs This? | Evidence/Justification |
|---|----------|--------------------------|----------------------|
| 1 | Social scoring | NO | [explain why not] |
| 2 | Subliminal manipulation | NO | [explain why not] |
| 3 | Vulnerability exploitation | NO | [explain why not] |
| 4 | Real-time remote biometric ID | NO | [explain why not] |
| 5 | Emotion recognition (workplace/education) | NO | [explain why not] |
| 6 | Biometric categorization (sensitive categories) | NO | [explain why not] |
| 7 | Untargeted facial scraping | NO | [explain why not] |
| 8 | Individual predictive policing | NO | [explain why not] |

Assessed by: ___________  Date: ___________
```

---

## HIGH-RISK AI REQUIREMENTS (Articles 8-15)

### Requirement 1: Risk Management System (Article 9)

Establish a continuous, iterative risk management process:

```markdown
## AI Risk Management System

### 1.1 Risk Identification
| Risk ID | Description | Likelihood | Impact | Risk Level | Mitigation |
|---------|------------|------------|--------|------------|------------|
| R-001 | Model produces biased outputs for protected groups | Medium | High | HIGH | Bias testing, fairness constraints |
| R-002 | System fails silently without alerting human operator | Low | Critical | HIGH | Health monitoring, fallback mechanism |
| R-003 | Training data contains personal data without consent | Medium | High | HIGH | Data audit, consent verification |

### 1.2 Risk Mitigation Measures
| Risk ID | Mitigation | Implementation | Verification Method | Status |
|---------|-----------|---------------|--------------------| -------|
| R-001 | Demographic parity testing | Pre-deployment bias audit | Automated fairness metrics | |
| R-002 | Circuit breaker + human fallback | Health check endpoint | Integration test | |
| R-003 | Data provenance tracking | Data lineage system | Audit trail review | |

### 1.3 Residual Risk Assessment
| Risk ID | Residual Risk After Mitigation | Acceptable? | Justification |
|---------|-------------------------------|-------------|---------------|

### 1.4 Risk Monitoring (Post-Deployment)
| Metric | Threshold | Monitoring Frequency | Escalation |
|--------|-----------|---------------------|------------|
| Fairness drift | >5% deviation | Weekly | Product owner |
| Error rate | >2% increase | Daily | Engineering lead |
| User complaints | >10/week | Daily | Compliance officer |
```

### Requirement 2: Data Governance (Article 10)

| Obligation | Description | Implementation |
|-----------|------------|----------------|
| Training data quality | Relevant, representative, free of errors | Data quality pipeline, validation checks |
| Bias examination | Examine data for biases, especially for protected groups | Statistical bias analysis per demographic |
| Data provenance | Document origin and processing of all training data | Data lineage tracking system |
| Privacy compliance | GDPR-compliant data processing | DPIA, legal basis documentation |
| Data minimization | Only use data necessary for intended purpose | Data audit, purpose limitation |

### Requirement 3: Technical Documentation (Article 11)

Required documentation (before placing on market):

```markdown
## AI System Technical Documentation (Annex IV)

### A. General Description
- **System name**: [name]
- **Version**: [version]
- **Intended purpose**: [detailed description of what the system does]
- **Intended users**: [who will use the system]
- **Intended deployment context**: [geographic, sectoral, functional scope]
- **Hardware requirements**: [compute, memory, storage]
- **Software dependencies**: [frameworks, libraries, external services]

### B. Development Process
- **Design specifications**: [architecture description]
- **Development methodology**: [agile, waterfall, etc.]
- **Design choices and rationale**: [key decisions and why]
- **Validation and testing procedures**: [testing strategy]
- **Data used**: [training, validation, testing data descriptions]
- **Training approach**: [methodology, hyperparameters, optimization]

### C. Monitoring and Performance
- **Performance metrics**: [accuracy, precision, recall, F1, fairness metrics]
- **Known limitations**: [what the system cannot do, edge cases]
- **Foreseeable misuse**: [ways the system could be misused]
- **Risk mitigation measures**: [reference risk management system]
- **Human oversight measures**: [how humans monitor/control the system]
- **Expected lifetime**: [maintenance and support period]

### D. Applicable Standards
- **Harmonized standards applied**: [list]
- **Common specifications applied**: [list]
- **Cybersecurity measures**: [reference to security documentation]
```

### Requirement 4: Record-Keeping (Article 12)

```markdown
## Automatic Logging Requirements

The AI system must automatically log:

| Event | Data Captured | Retention |
|-------|--------------|-----------|
| System startup/shutdown | Timestamp, version, config hash | Duration of system lifecycle + 5 years |
| Input data processing | Input hash (not raw data), timestamp | As above |
| Output/decision generation | Output, confidence score, decision path | As above |
| Human override events | Override action, original decision, user ID | As above |
| Error/anomaly events | Error type, context, severity | As above |
| Performance metrics | Accuracy, latency, throughput | As above |

### Implementation Pattern

```typescript
interface AISystemLog {
  eventId: string;          // Unique event identifier
  timestamp: string;        // ISO 8601 UTC
  eventType: 'INPUT' | 'OUTPUT' | 'OVERRIDE' | 'ERROR' | 'METRIC' | 'LIFECYCLE';
  systemVersion: string;    // AI system version
  inputHash?: string;       // SHA-256 hash of input (not raw data for privacy)
  output?: any;             // System output/decision
  confidence?: number;      // Confidence score if applicable
  humanOverride?: {
    userId: string;
    originalDecision: any;
    overrideDecision: any;
    reason: string;
  };
  metadata?: Record<string, any>;
}
```
```

### Requirement 5: Transparency and Information (Article 13)

High-risk AI must provide clear information to deployers:

- Intended purpose and limitations
- Level of accuracy, robustness, and cybersecurity
- Known risks and foreseeable misuse scenarios
- Human oversight measures and how to invoke them
- Expected input data specifications
- Interpretability of outputs (what confidence scores mean)

### Requirement 6: Human Oversight (Article 14)

Design the AI system to enable effective human oversight:

| Oversight Pattern | Description | When to Use |
|-------------------|------------|-------------|
| **Human-in-the-loop (HITL)** | Human approves every AI decision before execution | High-stakes individual decisions (medical diagnosis, judicial) |
| **Human-on-the-loop (HOTL)** | Human monitors AI decisions, can intervene | Batch processing, moderate risk (hiring screening) |
| **Human-in-command (HIC)** | Human sets parameters, AI operates within bounds, human can override | Continuous systems (infrastructure management) |

```markdown
## Human Oversight Design

### Oversight Model: [HITL / HOTL / HIC]

**Justification**: [why this model fits the risk level]

### Oversight Capabilities
- [ ] Human operator can understand AI system outputs
- [ ] Operator can interpret outputs correctly (training provided)
- [ ] Operator can decide not to use or override the AI decision
- [ ] Operator can intervene or halt the system at any time
- [ ] System provides sufficient information for operator to make informed decisions
- [ ] System flags low-confidence decisions for human review

### Escalation Thresholds
| Condition | Action | Response Time |
|-----------|--------|---------------|
| Confidence < 70% | Route to human reviewer | Real-time |
| Protected group affected | Mandatory human review | Before execution |
| Anomaly detected | Alert + human review | < 1 hour |
| System degradation | Failover to manual process | Immediate |
```

### Requirement 7: Accuracy, Robustness, and Cybersecurity (Article 15)

```markdown
## Performance and Security Requirements

### Accuracy
| Metric | Target | Measured | Method | Frequency |
|--------|--------|----------|--------|-----------|
| Overall accuracy | >95% | [value] | Holdout test set | Monthly |
| Per-group accuracy (fairness) | <5% gap between groups | [value] | Stratified evaluation | Monthly |
| False positive rate | <2% | [value] | Holdout test set | Monthly |
| False negative rate | <1% | [value] | Holdout test set | Monthly |

### Robustness
| Test | Description | Result |
|------|------------|--------|
| Adversarial input testing | Test with perturbed/adversarial inputs | PASS/FAIL |
| Out-of-distribution detection | System identifies inputs outside training distribution | PASS/FAIL |
| Graceful degradation | System fails safely when inputs are unexpected | PASS/FAIL |
| Feedback loop resilience | System does not amplify errors over time | PASS/FAIL |

### Cybersecurity
| Control | Implementation | Verification |
|---------|---------------|--------------|
| Model integrity | Signed model artifacts, hash verification | CI/CD pipeline check |
| Data pipeline security | Encrypted data at rest and in transit | TLS + AES-256 verification |
| Access control | RBAC for model access and modification | Integration tests |
| Adversarial ML defense | Input validation, rate limiting, anomaly detection | Red team testing |
| Supply chain security | SBOM for ML dependencies, vulnerability scanning | SCA pipeline |
```

---

## GENERAL-PURPOSE AI (GPAI) MODEL OBLIGATIONS (Article 53)

### Effective: August 2, 2025

Obligations for providers of GPAI models (e.g., foundation models, LLMs):

| Obligation | Description | Applicability |
|-----------|------------|---------------|
| Technical documentation | Detailed model card with architecture, training process, evaluation | All GPAI |
| Copyright compliance | Policy for EU copyright law, including opt-out mechanisms | All GPAI |
| Training data summary | Sufficiently detailed summary of training data | All GPAI |
| Downstream provider info | Provide information enabling downstream compliance | All GPAI |
| Systemic risk assessment | Evaluate systemic risks if model has high-impact capabilities | GPAI with systemic risk (>10^25 FLOPs threshold) |
| Adversarial testing | Red-teaming and adversarial testing | GPAI with systemic risk |
| Incident reporting | Report serious incidents to AI Office | GPAI with systemic risk |
| Cybersecurity protection | Adequate cybersecurity for model and infrastructure | GPAI with systemic risk |

### GPAI Model Documentation Template

```markdown
## GPAI Model Card (Article 53 Compliance)

### Model Identity
- **Model name**: [name]
- **Version**: [version]
- **Provider**: [organization]
- **Release date**: [date]
- **Model type**: [transformer, diffusion, etc.]

### Training
- **Training data summary**: [description of data sources, volume, preprocessing]
- **Training compute**: [FLOPs estimate -- determines systemic risk threshold]
- **Training methodology**: [self-supervised, RLHF, etc.]
- **Fine-tuning approach**: [if applicable]

### Capabilities and Limitations
- **Intended tasks**: [list of supported use cases]
- **Known limitations**: [failure modes, biases, edge cases]
- **Languages supported**: [list]
- **Modalities**: [text, image, audio, etc.]

### Evaluation
- **Benchmarks**: [list of evaluations performed with results]
- **Bias evaluation**: [fairness testing results across demographics]
- **Safety evaluation**: [harmful content testing, refusal rates]

### Copyright Compliance
- **Copyright policy**: [how copyright is handled in training data]
- **Opt-out mechanism**: [how rights holders can opt out]
- **Training data rights**: [licensing, fair use, etc.]

### Downstream Use
- **Integration guidance**: [how to use the model compliantly]
- **Prohibited uses**: [uses that would create high-risk or prohibited systems]
- **Responsibility allocation**: [what the provider vs. deployer is responsible for]
```

---

## TRANSPARENCY OBLIGATIONS (Articles 50, 52)

### AI-Generated Content Labeling

| Content Type | Obligation | Implementation |
|-------------|-----------|----------------|
| **Chatbot / conversational AI** | Disclose to user they are interacting with AI | Clear disclosure before or at start of interaction |
| **AI-generated text** | Machine-readable label on AI-generated text | Metadata tagging (C2PA, watermarking) |
| **AI-generated images** | Machine-readable label on synthetic images | C2PA provenance, steganographic watermark |
| **AI-generated audio** | Machine-readable label on synthetic audio | Audio watermarking, metadata |
| **AI-generated video** | Machine-readable label, deepfake disclosure | C2PA, visible disclosure for realistic content |
| **Emotion recognition** | Inform persons subject to emotion recognition | Clear notice before processing |
| **Biometric categorization** | Inform persons subject to categorization | Clear notice before processing |

### Implementation Pattern

```typescript
// Chatbot transparency disclosure
const AI_DISCLOSURE = `You are interacting with an AI assistant.
A human agent is available upon request.`;

app.use('/api/chat', (req, res, next) => {
  // Include disclosure in first message of every conversation
  if (req.body.isNewConversation) {
    res.locals.systemDisclosure = AI_DISCLOSURE;
  }
  next();
});

// AI-generated content labeling (metadata approach)
interface AIContentMetadata {
  aiGenerated: true;
  generationModel: string;
  generationDate: string;
  provider: string;
  contentType: 'text' | 'image' | 'audio' | 'video';
  // C2PA manifest reference if available
  c2paManifest?: string;
}
```

---

## CONFORMITY ASSESSMENT (Article 43)

### Assessment Routes

| AI System Type | Assessment Method | Assessor |
|---------------|-------------------|---------|
| High-risk (Annex III, most categories) | Internal conformity assessment | Self-assessment by provider |
| High-risk (biometric ID, critical infrastructure) | Third-party conformity assessment | Notified Body |
| High-risk (covered by existing EU product legislation) | Follows existing product legislation procedure | Varies |
| GPAI with systemic risk | Evaluation by AI Office | European AI Office |

### Internal Conformity Assessment Steps

```markdown
## Conformity Assessment Checklist

### Pre-Assessment
- [ ] AI system classified by risk level (decision tree completed)
- [ ] Quality management system established (Article 17)
- [ ] Technical documentation complete (Annex IV)
- [ ] Risk management system operational (Article 9)

### Assessment
- [ ] Verify compliance with each applicable requirement (Articles 8-15)
- [ ] Review test results for accuracy, robustness, cybersecurity
- [ ] Verify human oversight design and implementation
- [ ] Review data governance documentation
- [ ] Verify record-keeping (automatic logging) implementation
- [ ] Review transparency and information provisions
- [ ] Verify post-market monitoring plan

### Post-Assessment
- [ ] EU Declaration of Conformity drafted (Article 47)
- [ ] CE marking affixed (Article 48) if applicable
- [ ] AI system registered in EU database (Article 49)
- [ ] Post-market monitoring system activated
- [ ] Serious incident reporting process established
```

---

## EU DATABASE REGISTRATION (Article 49)

High-risk AI systems must be registered before placing on market:

```markdown
## EU AI Database Registration Information

| Field | Value |
|-------|-------|
| Provider name | [legal entity name] |
| Provider address | [registered office] |
| Authorized representative (if non-EU) | [name and address] |
| AI system name | [commercial name] |
| AI system version | [version] |
| AI system status | [on market / withdrawn / recalled] |
| Intended purpose | [description] |
| Risk classification | [high-risk category from Annex III] |
| Member states of deployment | [list] |
| Conformity assessment | [internal / third-party, reference number] |
| Declaration of Conformity | [document reference] |
| URL for instructions of use | [link] |
```

---

## BIAS TESTING AND FAIRNESS ASSESSMENT

### Fairness Metrics

| Metric | Definition | When to Use |
|--------|-----------|-------------|
| **Demographic parity** | Equal positive prediction rates across groups | When equal outcomes are the goal |
| **Equalized odds** | Equal TPR and FPR across groups | When accuracy parity matters |
| **Predictive parity** | Equal precision across groups | When positive predictions must be equally reliable |
| **Individual fairness** | Similar individuals get similar predictions | When individual treatment matters |
| **Counterfactual fairness** | Prediction unchanged if protected attribute changed | When causal fairness is required |

### Bias Testing Template

```markdown
## AI Fairness Assessment Report

**System**: [name]
**Assessment Date**: [date]
**Protected Attributes Tested**: [gender, ethnicity, age, disability, etc.]

### Dataset Demographics
| Group | Training Set % | Test Set % | Population % |
|-------|---------------|------------|-------------|

### Performance by Group
| Group | Accuracy | TPR | FPR | Precision | Selection Rate |
|-------|----------|-----|-----|-----------|---------------|

### Fairness Metrics
| Metric | Groups Compared | Value | Threshold | Status |
|--------|----------------|-------|-----------|--------|
| Demographic parity ratio | [A vs B] | [0-1] | >0.8 | PASS/FAIL |
| Equalized odds difference | [A vs B] | [0-1] | <0.1 | PASS/FAIL |
| Predictive parity ratio | [A vs B] | [0-1] | >0.8 | PASS/FAIL |

### Bias Mitigation Actions
| Finding | Mitigation | Implementation Status |
|---------|-----------|---------------------|

### Intersectional Analysis
[Evaluate fairness across combinations of protected attributes]
```

---

## IMPLEMENTATION TIMELINE

| Date | Milestone | What Applies |
|------|-----------|-------------|
| **August 1, 2024** | AI Act entered into force | Clock starts |
| **February 2, 2025** | Prohibited practices banned | Article 5 prohibitions enforced |
| **August 2, 2025** | GPAI obligations apply | Articles 51-55 (GPAI model rules) |
| **August 2, 2025** | Governance structure operational | AI Office, AI Board, advisory forum |
| **August 2, 2026** | High-risk AI (Annex III) obligations apply | Full compliance for Annex III systems |
| **August 2, 2027** | High-risk AI (Annex I products) obligations apply | AI in products under existing EU legislation |

### Compliance Roadmap Template

```markdown
## AI Act Compliance Roadmap

### Phase 1: Assessment (Now - 3 months)
- [ ] Inventory all AI systems
- [ ] Classify each system by risk level
- [ ] Identify prohibited practices (immediate compliance needed)
- [ ] Identify GPAI models (August 2025 deadline)
- [ ] Gap analysis against applicable requirements

### Phase 2: Design (3-6 months)
- [ ] Establish quality management system
- [ ] Design risk management framework
- [ ] Design data governance framework
- [ ] Plan human oversight mechanisms
- [ ] Design logging and record-keeping architecture

### Phase 3: Implementation (6-12 months)
- [ ] Implement technical documentation
- [ ] Build automated logging
- [ ] Implement human oversight interfaces
- [ ] Deploy bias testing pipeline
- [ ] Implement transparency mechanisms

### Phase 4: Assessment and Registration (12-15 months)
- [ ] Conduct internal conformity assessment
- [ ] Engage notified body if required
- [ ] Register in EU database
- [ ] Draft EU Declaration of Conformity
- [ ] Establish post-market monitoring

### Phase 5: Ongoing Compliance (Continuous)
- [ ] Monitor for regulatory updates and delegated acts
- [ ] Run periodic bias and fairness assessments
- [ ] Update technical documentation with each version
- [ ] Report serious incidents within required timelines
- [ ] Annual risk management review
```

---

## AI ACT COMPLIANCE CHECKLIST AND RISK CLASSIFICATION REPORT

```markdown
# EU AI Act Compliance Report

**Organization**: [name]
**AI System**: [name and version]
**Report Date**: [date]
**Prepared By**: [name and role]

## 1. Risk Classification

| Question | Answer |
|----------|--------|
| Does the system perform any prohibited practice (Article 5)? | YES/NO |
| Is the system listed in Annex III high-risk categories? | YES/NO |
| Is the system a safety component under Annex I legislation? | YES/NO |
| Does the system interact with natural persons? | YES/NO |
| Does the system generate synthetic content? | YES/NO |
| Is the system a GPAI model? | YES/NO |
| GPAI training compute (FLOPs)? | [value or N/A] |

**Determined Risk Level**: [Unacceptable / High / Limited / Minimal]
**Applicable Articles**: [list]

## 2. Compliance Status by Requirement

### Prohibited Practices (Article 5) -- All AI Systems
| Check | Status |
|-------|--------|
| No social scoring | COMPLIANT / N-A |
| No subliminal manipulation | COMPLIANT / N-A |
| No vulnerability exploitation | COMPLIANT / N-A |
| No prohibited biometric practices | COMPLIANT / N-A |

### High-Risk Requirements (Articles 8-15) -- If Applicable
| Requirement | Article | Status | Evidence | Gap |
|-------------|---------|--------|----------|-----|
| Risk management system | Art. 9 | | [ref] | |
| Data governance | Art. 10 | | [ref] | |
| Technical documentation | Art. 11 | | [ref] | |
| Record-keeping (logging) | Art. 12 | | [ref] | |
| Transparency to deployers | Art. 13 | | [ref] | |
| Human oversight | Art. 14 | | [ref] | |
| Accuracy and robustness | Art. 15 | | [ref] | |
| Quality management system | Art. 17 | | [ref] | |
| Conformity assessment | Art. 43 | | [ref] | |
| EU database registration | Art. 49 | | [ref] | |

### GPAI Obligations (Articles 51-55) -- If Applicable
| Obligation | Status | Evidence |
|-----------|--------|----------|
| Technical documentation | | [ref] |
| Copyright compliance | | [ref] |
| Training data summary | | [ref] |
| Downstream provider info | | [ref] |
| Systemic risk assessment | | [ref] |

### Transparency (Article 50) -- Limited Risk and Above
| Obligation | Status | Implementation |
|-----------|--------|----------------|
| AI interaction disclosure | | [method] |
| Content labeling | | [method] |
| Emotion recognition notice | | [method] |

## 3. Gaps and Remediation Plan

| # | Requirement | Gap Description | Remediation | Priority | Target Date | Owner |
|---|-----------|----------------|-------------|----------|-------------|-------|

## 4. Bias and Fairness Summary

| Protected Attribute | Fairness Metric | Value | Threshold | Status |
|--------------------|----------------|-------|-----------|--------|

## 5. Attestation

I certify that this assessment accurately reflects the compliance posture
of the AI system described above as of the report date.

Signature: ___________________  Date: ___________
Name: _______________________  Title: ___________
```

---

## CHECKLIST

- [ ] AI system inventoried and classified by risk level (decision tree completed)
- [ ] Prohibited practices assessment completed (Article 5)
- [ ] If high-risk: risk management system established and documented (Article 9)
- [ ] If high-risk: data governance framework in place (Article 10)
- [ ] If high-risk: technical documentation complete per Annex IV (Article 11)
- [ ] If high-risk: automatic logging/record-keeping implemented (Article 12)
- [ ] If high-risk: transparency information provided to deployers (Article 13)
- [ ] If high-risk: human oversight design implemented (HITL/HOTL/HIC) (Article 14)
- [ ] If high-risk: accuracy, robustness, and cybersecurity verified (Article 15)
- [ ] If high-risk: conformity assessment completed (Article 43)
- [ ] If high-risk: registered in EU database (Article 49)
- [ ] If GPAI: technical documentation and model card published (Article 53)
- [ ] If GPAI: copyright compliance policy documented (Article 53)
- [ ] If GPAI: training data summary available (Article 53)
- [ ] If limited risk: AI interaction disclosure implemented (Article 50)
- [ ] If limited risk: AI-generated content labeled (Article 50)
- [ ] Bias testing performed across protected attributes
- [ ] Fairness metrics within acceptable thresholds
- [ ] Post-market monitoring plan established
- [ ] Serious incident reporting process documented
- [ ] Compliance roadmap aligned with implementation timeline
- [ ] Legal counsel engaged for jurisdiction-specific guidance

---

*Skill Version: 1.0 | Created: March 2026*
