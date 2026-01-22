---
name: SSoT Structure & Generation
description: How to structure a Single Source of Truth document and auto-generate from onboarding context
---

# SSoT Structure & Generation Skill

**Purpose**: Define the standard structure for Single Source of Truth (SSoT) documents and guide auto-generation from onboarding context.

> [!CAUTION]
> **APPEND-ONLY RULE**: SSoT documents are NEVER pruned. ALWAYS ADD new content at the end of the appropriate section. If a document is superseded, change its status to `DEPRECATED` but keep the full content.

---

## 🎯 TRIGGER COMMANDS

```text
"Create an SSoT for [business]"
"Structure a Single Source of Truth"
"Generate SSoT from context"
"Using ssot_structure skill: [task]"
```

---

## 📋 THE 10-SYSTEM ARCHITECTURE

All business knowledge fits into this structure:

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    SSoT 10-SYSTEM ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   0.0 THE OPERATING SYSTEM (The Factory)                                │
│   ────────────────────────────────────────                              │
│   0.1  SSoT Governance & Structure                                      │
│   0.2  Training & Certification Engine                                  │
│   0.3  Quality Assurance (QA) Engine                                    │
│   0.4  Continuous Improvement (CI) Framework                            │
│   0.5  WFM & Resource Planning                                          │
│   0.6  Operations Management                                            │
│   0.7  AI Intelligence & Context Governance                             │
│   0.8  Automation & Orchestration                                       │
│   0.9  RAG & Vector Memory                                              │
│   0.10 Data Governance                                                  │
│   0.11 Risk & Compliance                                                │
│   0.12 Communication & Escalation                                       │
│                                                                          │
│   1.0 STRATEGY & POSITIONING                                            │
│   ────────────────────────────                                          │
│   1.1  Mission, Vision, & Values                                        │
│   1.2  Business Plan & OKRs                                             │
│   1.3  Market Research & Competitive Analysis                           │
│   1.4  Brand & Messaging                                                │
│   1.5  Legal & Corporate                                                │
│                                                                          │
│   2.0 SALES & MARKETING                                                 │
│   ─────────────────────────                                             │
│   2.1  Go-to-Market Strategy                                            │
│   2.2  Content Marketing                                                │
│   2.3  Sales Enablement                                                 │
│   2.4  CRM & Pipeline                                                   │
│   2.5  Website & Digital Presence                                       │
│                                                                          │
│   3.0 CLIENT DELIVERY (IP & Playbooks)                                  │
│   ──────────────────────────────────                                    │
│   3.1  Methodology (Master)                                             │
│   3.2  Delivery Playbooks                                               │
│   3.3  Client Engagement Framework                                      │
│   3.4  CLIENTS (Active & Archived)                                      │
│   3.5  Deliverables (Client-Facing Masters)                             │
│   3.6  Customer Success & Retention                                     │
│                                                                          │
│   4.0 PRODUCT MODULES (Assets)                                          │
│   ─────────────────────────────                                         │
│   4.1  Templates & Checklists                                           │
│   4.2  Presentation & Workshop Decks                                    │
│   4.3  Tools & Calculators                                              │
│   4.4  Visual Frameworks & Diagrams                                     │
│   4.5  IP Registry                                                      │
│                                                                          │
│   5.0 INTERNAL OPERATIONS                                               │
│   ─────────────────────────                                             │
│   5.1  Finance & Accounting                                             │
│   5.2  Human Resources & Talent                                         │
│   5.3  Knowledge & Collaboration                                        │
│   5.4  IT & Systems                                                     │
│   5.5  Vendor & Partner Management                                      │
│   5.6  Technology Architecture                                          │
│                                                                          │
│   6.0 PRODUCT & SERVICE CATALOG                                         │
│   ─────────────────────────────────                                     │
│   6.1  Product Registry                                                 │
│   6.2  Service Offerings                                                │
│   6.3  Pricing Architecture                                             │
│   6.4  Product Lifecycle Management                                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📝 DOCUMENT NAMING CONVENTION

Every document follows this schema:

```text
[TYPE-DOMAIN-###] Title (vX.X) STATUS
```

### Type Codes

| Type | Full Name | When to Use |
|------|-----------|-------------|
| `SOP` | Standard Operating Procedure | Repeatable process with steps |
| `WI` | Work Instruction | Detailed how-to for specific task |
| `SCHEMA` | Schema | Data structure or taxonomy |
| `TEMPLATE` | Template | Reusable blank document |
| `PLAYBOOK` | Playbook | Multi-SOP collection |
| `REF` | Reference | Lookup table or matrix |
| `SPEC` | Specification | Technical requirements |
| `PROMPT` | Prompt | AI agent instruction |

### Status Values

| Status | Meaning |
|--------|---------|
| `COMPLETED` | Ready for use |
| `DRAFT` | Work in progress |
| `NEED TO STANDARDIZE` | Exists but needs formatting |
| `BLANK` | Placeholder only |
| `DEPRECATED` | No longer used |

**Example**: `[SOP-MKTG-001] Content Calendar (v2.0) COMPLETED`

---

## 👔 OWNERSHIP MODEL

| System | Primary Owner | Scope |
|--------|---------------|-------|
| 0.x Factory OS | COO | Governance, QA, WFM, Operations |
| 0.7 AI Intelligence | CTO/AI Lead | AI context, prompts, agents |
| 1.x Strategy | CEO | Vision, business plan, brand |
| 2.x Sales & Marketing | CRO/CMO | Revenue generation |
| 3.x Client Delivery | COO/CTO | Methodology, clients |
| 4.x Modules | CIO/COO | Templates, tools, assets |
| 5.x Internal Ops | COO/CFO | Finance, HR, IT |
| 6.x Product | CPO/CRO | Products, pricing |

---

## ✅ SSoT CREATION CHECKLIST

When creating or auditing an SSoT:

- [ ] All 6 layers represented (0.x through 6.x)
- [ ] Every section has an owner assigned
- [ ] All documents follow naming convention
- [ ] Status accurately reflects document state
- [ ] No orphan documents (everything categorized)
- [ ] Version numbers incremented appropriately
- [ ] Deprecated items marked and archived
- [ ] New sections identified from gaps
