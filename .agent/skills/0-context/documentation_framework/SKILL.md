---
name: Documentation Framework
description: Reference for all document types needed in software development
---

# Documentation Framework Skill

Reference guide for all document types across the software development lifecycle.

> [!CAUTION]
> **APPEND-ONLY RULE**: Never delete content from documentation. When information changes, ADD updates at the end of the relevant section. Mark outdated information with `[OUTDATED]` or `[DEPRECATED]` but preserve the original text for historical context.

---

## 🎯 TRIGGER COMMANDS

Use any of these phrases to activate this skill:

```
"What docs do I need for [project/feature]?"
"Create a PRD for [feature]"
"Write a tech spec for [system]"
"Generate API docs for [module]"
"Make a security checklist for [feature]"
"Write a runbook for [common issues]"
"What documentation should I create?"
"Using documentation_framework skill: [request]"
```

---

## DOCUMENT CATEGORIES

### 📋 PRE-PROJECT (Before Code)

| Document | What It Contains | When to Create |
|----------|------------------|----------------|
| **PRD** | Problem, solution, success metrics, user stories | First - defines WHAT |
| **Tech Spec** | Architecture, tech stack, trade-offs | After PRD - defines HOW |
| **System Design** | DB schema, API contracts, data flow | With tech spec |
| **UI Wireframes** | Layouts, user flows, components | Parallel with tech spec |
| **Security Model** | Threats, vulnerabilities, mitigations | Before implementation |
| **API Contract** | Endpoints, schemas, auth rules | Before backend work |

### 🚧 DURING PROJECT (While Building)

| Document | Purpose | Update Frequency |
|----------|---------|------------------|
| **Implementation Plan** | Task checklist, status | Every session |
| **ADRs** | Why we chose X over Y | When making decisions |
| **Migration Scripts** | DB changes + rollback | Before deploy |
| **Test Plan** | Coverage, gaps, test data | Before merging |

### 📦 POST-FEATURE (After Shipping)

| Document | Purpose | When Created |
|----------|---------|--------------|
| **Walkthrough** | What was built, how to use | After complete | **Use `feature_walkthrough` skill** |
| **API Docs** | Endpoint reference | After stable |
| **Changelog** | What changed each version | Every release |
| **Runbook** | Debug common issues | After incidents |

### 🔐 SECURITY (Ongoing)

| Document | Purpose |
|----------|---------|
| **Security Checklist** | Auth, encryption, validation |
| **Access Control Matrix** | Who can access what |
| **Audit Log Spec** | What to track, retention |
| **Data Classification** | PII, sensitive, public handling |

---

## MINIMUM VIABLE DOCS (Solo/Small Team)

**Must Have:**

1. PRD - What you're building
2. Implementation Plan - Track progress
3. API Contract - Know endpoints
4. Security Checklist - Don't get hacked
5. Changelog - What shipped

---

## QUICK REFERENCE

| I Need To... | Ask For... |
|--------------|------------|
| Start a new feature | PRD + Tech Spec |
| Build something | Implementation Plan |
| Fix something broken | Runbook + Error Logs |
| Check security | Security Checklist |
| Know what changed | Changelog + Walkthrough |

---

## ASK FOR DOCUMENT CREATION

You can request any of these documents:

```
"Create a PRD for [feature]"
"Write a tech spec for [system]"
"Generate API docs for [module]"
"Make a security checklist for [feature]"
"Write a runbook for [common issues]"
```
