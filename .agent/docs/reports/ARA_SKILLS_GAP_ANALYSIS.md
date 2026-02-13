# 🧪 ARA Gap Analysis: Skills Framework

Using the **Atomic Reverse Architecture** methodology, I have analyzed the current `skills/README.md` ecosystem to identify what is missing.

## 🟢 Phase 1: The "Vision State" Check
>
> *Vision: A complete, autonomous engineering lifecycle.*

**Status**: We have good coverage of "Planning" and "Coding".
**Critical Gap**: We are weak on **"Operating"** and **"Scaling"**. The framework assumes the code works once deployed, but lacks the skills to keep it running or modify it safely at scale.

## 🔴 Phase 2 & 3: Atomic Gaps (Reverse Mapping)

I asked: *"For a premium software project to survive 2+ years, what MUST be true?"*

### 1. The "Blind Pilot" Gap (Observability)

* **Condition**: When production breaks, we must know *why* immediately.
* **Current State**: We have a `/debug` workflow, but no **Skill** to actually set up Logging, Tracing, or Metrics code (OpenTelemetry, Sentry, Datadog).
* **Missing Atom**: `[development/observability]` (Implementing the "Golden Signals").

### 2. The "It Works on My Machine" Gap (DevOps/IaC)

* **Condition**: The deployment must be reproducible and not manual.
* **Current State**: We have `Deployment Modes` (Design) and `Website Launch` (Checklist), but no skill for **Infrastructure as Code**.
* **Missing Atom**: `[operations/infrastructure_as_code]` (Terraform/Docker/Pulumi setup).

### 3. The "Data Loss" Gap (Migrations)

* **Condition**: The database schema must evolve without losing user data.
* **Current State**: We have `Schema Standards` (Design), but no skill for managing **Migrations** safely.
* **Missing Atom**: `[data/db_migrations]` (Safe schema evolution strategies).

### 4. The "Regression" Gap (E2E Testing)

* **Condition**: New features must not break critical user flows.
* **Current State**: `Spec Build` covers TDD (Unit Tests), but we lack **End-to-End (E2E)** validation.
* **Missing Atom**: `[quality/e2e_testing]` (Playwright/Cypress setup).

### 5. The "API Chaos" Gap (Integration)

* **Condition**: External clients need to know how to use our API.
* **Current State**: We design APIs in `Feature Architecture`, but we don't document them for consumers.
* **Missing Atom**: `[documentation/api_reference]` (Swagger/OpenAPI generation).

---

## 🛠️ Recommendations

To complete the framework, we should add these 5 skills:

1. **`development/observability`**: "How to install eyes and ears in your code."
2. **`operations/infrastructure_as_code`**: "How to define servers as software."
3. **`data/db_migrations`**: "How to change the engine while driving."
4. **`quality/e2e_testing`**: "How to simulate real users."
5. **`documentation/api_reference`**: "How to write a manual for your robots."
