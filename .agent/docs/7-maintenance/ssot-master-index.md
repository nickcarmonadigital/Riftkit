# SSoT Master Index

> **Single Source of Truth** — The central registry for all project documentation, assets, and decisions.

**Last Updated**: [YYYY-MM-DD]
**Owner**: [Project Lead]
**Review Cadence**: Monthly

---

## How to Use This Index

1. **Every document, schema, SOP, and decision** gets an entry here
2. **Status values**: `PLANNED` → `IN_PROGRESS` → `COMPLETED` → `DEPRECATED`
3. **Never delete entries** — mark as `DEPRECATED` with a date and replacement reference
4. **Update this index** every time you create, complete, or deprecate a document
5. **Cross-reference** using the Asset ID in other documents

---

## Maintenance Procedures

| Task | Cadence | Owner | Process |
|------|---------|-------|---------|
| Review index for accuracy | Monthly | Project Lead | Compare index against actual files, fix discrepancies |
| Archive deprecated items | Quarterly | Project Lead | Move deprecated items to archive section |
| Verify all links work | Monthly | Any team member | Click each reference, fix broken links |
| Add new project sections | As needed | Developer | Use template below when starting new features |

### Version Control Strategy

- This file is committed to Git alongside code
- Changes to this file require a PR (reviewed by project lead)
- Use conventional commit: `docs: update SSoT index — add [feature] entries`
- Conflicts resolved by the project lead

---

## 0.0 Governance & Standards

### 0.1 Governance

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `GOV-001` | Project Conventions | COMPLETED | Lead | [Date] |
| `GOV-002` | Code Style Guide (ESLint/Prettier config) | COMPLETED | Lead | [Date] |
| `GOV-003` | Git Workflow & Branch Strategy | COMPLETED | Lead | [Date] |
| `GOV-004` | PR Review Guidelines | COMPLETED | Lead | [Date] |

### 0.2 Standards & Schemas

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `SCHEMA-001` | Database Schema Standards | COMPLETED | Lead | [Date] |
| `SCHEMA-002` | API Response Format Standard | COMPLETED | Lead | [Date] |
| `SCHEMA-003` | Error Code Catalog | COMPLETED | Lead | [Date] |

### 0.3 SOPs & Work Instructions

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `SOP-001` | Deployment Process | COMPLETED | DevOps | [Date] |
| `SOP-002` | Incident Response Procedure | COMPLETED | Lead | [Date] |
| `SOP-003` | New Developer Onboarding | COMPLETED | Lead | [Date] |
| `WI-001` | How to Run Database Migrations | COMPLETED | Backend | [Date] |
| `WI-002` | How to Set Up Local Dev Environment | COMPLETED | Backend | [Date] |

### 0.4 Security & Compliance

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `SEC-001` | Security Audit Report | COMPLETED | Security | [Date] |
| `SEC-002` | Dependency Audit Report | COMPLETED | DevOps | [Date] |
| `SEC-003` | Privacy Policy | COMPLETED | Legal | [Date] |
| `SEC-004` | Terms of Service | COMPLETED | Legal | [Date] |

---

## 1.0 [Project Name] (Example)

### 1.1 Architecture & Design

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `ARCH-001` | System Architecture Document | COMPLETED | Lead | [Date] |
| `ARCH-002` | ARA Analysis — Core Platform | COMPLETED | Lead | [Date] |
| `ARCH-003` | Tech Stack Decision Record | COMPLETED | Lead | [Date] |

### 1.2 Features

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `FEAT-001` | User Authentication (Login/Signup/Reset) | COMPLETED | Backend | [Date] |
| `FEAT-002` | Dashboard Analytics | IN_PROGRESS | Frontend | [Date] |
| `FEAT-003` | Payment Integration (Stripe) | PLANNED | Backend | [Date] |
| `FEAT-004` | Admin Panel | PLANNED | Full-Stack | [Date] |

### 1.3 API Documentation

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `API-001` | REST API Reference (OpenAPI/Swagger) | COMPLETED | Backend | [Date] |
| `API-002` | WebSocket Events Reference | IN_PROGRESS | Backend | [Date] |

### 1.4 Testing

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `TEST-001` | Unit Test Coverage Report | COMPLETED | QA | [Date] |
| `TEST-002` | Integration Test Suite | COMPLETED | QA | [Date] |
| `TEST-003` | E2E Test Playbook | IN_PROGRESS | QA | [Date] |

### 1.5 Deployment & Infrastructure

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `INFRA-001` | CI/CD Pipeline Configuration | COMPLETED | DevOps | [Date] |
| `INFRA-002` | Environment Configuration Guide | COMPLETED | DevOps | [Date] |
| `INFRA-003` | Disaster Recovery Runbook | COMPLETED | DevOps | [Date] |

---

## Adding a New Project Section

Copy and paste this template when starting a new project or major feature:

```markdown
## [N].0 [Project/Feature Name]

### [N].1 Architecture & Design

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `ARCH-[NNN]` | [Title] | PLANNED | [Owner] | [Date] |

### [N].2 Features

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `FEAT-[NNN]` | [Title] | PLANNED | [Owner] | [Date] |

### [N].3 Documentation

| Asset ID | Title | Status | Owner | Last Updated |
|----------|-------|--------|-------|-------------|
| `DOC-[NNN]` | [Title] | PLANNED | [Owner] | [Date] |
```

---

## Deprecated / Archived Items

| Asset ID | Title | Deprecated Date | Replaced By | Reason |
|----------|-------|----------------|-------------|--------|
| *(Move deprecated items here)* | | | | |

---

## Related Skills

- **`ssot_structure`**: Defines the 10-System SSoT architecture and naming conventions
- **`ssot_update`**: Process for updating this index after completing work
- **`documentation_standards`**: Standards for creating SOPs, WIs, and Schemas referenced here
