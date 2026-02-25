# ARA Gap Analysis: AI Development Workflow Framework

**Date**: 2026-01-29
**Scope**: `WORKFLOWS_README.md` & Core Workflows
**Methodology**: Atomic Reverse Architecture (ARA)

## 1. Vision vs. Reality Check

**Vision**: A complete, end-to-end lifecycle for professional software engineering.
**Reality**: The framework is *procedurally* complete but lacks depth in specific **knowledge domains** that a Senior Architect or CISO would enforce.

---

## 2. Identified Knowledge Gaps (The "Missing Atoms")

### 🏗️ Software Architecture (The "Decision" Gap)

* **Missing**: **Architecture Decision Records (ADRs)**.
  * *Observation*: `/2-design` produces a "Plan", but doesn't explicitly force the documentation of *decisions* (e.g., "Why we chose Postgres over Mongo").
  * *Impact*: Knowledge is lost. Future maintainers won't know *why* the system works this way.
  * *Fix*: Add an **ADR** step in Phase 2, or a dedicated `toolkit/adr.md` workflow.

* **Missing**: **Domain-Driven Design (DDD) Mapping**.
  * *Observation*: `/1-brainstorm` creates "User Stories", but lacks a "Bounded Context" or "Ubiquitous Language" map.
  * *Impact*: "Spaghetti patterns" where code boundaries don't match business boundaries.

### 🛡️ Cyber Security (The "Shift Left" Gap)

* **Missing**: **Threat Modeling**.
  * *Observation*: Security is currently in Phase 4 (`/4-secure`) and Phase 5 (`/5-ship`). This is "Reactive".
  * *Impact*: Architectural flaws (e.g., "we shouldn't store this PII at all") are found too late.
  * *Fix*: **Shift Security Left**. Add a "Threat Model" step to Phase 2 (`/2-design`) using STRIDE or PASTA.

* **Missing**: **Supply Chain policies**.
  * *Observation*: `npm audit` is present, but no mention of *Dependency Pinning* or *SBOM (Software Bill of Materials)* generation.

### 🔧 Software Engineering / Full Stack (The "Ops" Gap)

* **Missing**: **Infrastructure as Code (IaC)**.
  * *Observation*: `/5-ship` mentions Docker, but lacks provisions for the *infrastructure* (AWS/Azure resources, Networking, IAM roles).
  * *Impact*: "It runs in Docker" but "Where does the Docker container run?" is manual.
  * *Fix*: Add Terraform/Pulumi/Bicep patterns to `/5-ship`.

* **Missing**: **Observability Strategy**.
  * *Observation*: `/7-maintenance` mentions "Logs", but there is no step to **design** the Observability (Metrics, Tracing, Alerts) upfront.
  * *Impact*: Debugging in production is hard because telemetry wasn't thought of during Design.

---

## 3. Comparison with "Senior" Roles

| Role | What's Covered in Framework | What's Missing |
|------|-----------------------------|----------------|
| **Architect** | Decomposition, Flow, Tech Stack | Trade-off Analysis (ADR), Bounded Contexts, Data Consistency Models (CAP theorem decisions) |
| **Engineer** | TDD, Implementation, Git Flow | Contract Testing (API), Performance/Load Testing, Database Indexing Strategy |
| **SecOps** | Vulnerability Scanning, OWASP | Threat Modeling, IAM Principle of Least Privilege Design, Compliance (SOC2/GDPR) Hooks |

## 4. Recommendations

1. **Update `/2-design`**: Include a "Threat Modeling" and "ADR" section.
2. **Update `/5-ship`**: Expand "Containerization" to include "Infrastructure Provisioning (IaC)".
3. **New Toolkit Workflow**: Consider `/ops` or `/observability` for setting up monitoring and logging *before* launch.
