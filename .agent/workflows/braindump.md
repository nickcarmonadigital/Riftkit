---
description: Brain dump any idea and get PRD, SOPs, WIs, and all structured documents automatically
---

# /braindump Workflow

> **THE ENTRY POINT**: Drop your raw ideas here. I'll create all the structured documents.

## What This Does

You brain dump → I analyze → I produce:

| Output | When Created |
|--------|--------------|
| **PRD** (Product Requirements Doc) | New product/feature |
| **Implementation Plan** | Anything requiring code |
| **Architecture Doc** | Complex systems |
| **SOPs** | Repeatable processes |
| **Work Instructions** | Detailed step-by-step tasks |
| **Schema Docs** | Database/data structures |

---

## How to Use

### Option 1: Quick Brain Dump

Just tell me your idea in plain language:

```text
"I want to build a feature that lets users export their data as CSV. 
They should be able to select which fields to include. 
It needs to work with large datasets without timing out."
```

I will ask clarifying questions, then produce the appropriate docs.

### Option 2: Structured Brain Dump

Use this template for more comprehensive input:

```markdown
## BRAIN DUMP

### What I Want (The Vision)
[Describe the end state - what does success look like?]

### Who It's For
[Target user/audience]

### The Problem It Solves
[Why does this need to exist?]

### Must-Haves
- [Requirement 1]
- [Requirement 2]

### Nice-to-Haves
- [Optional feature 1]
- [Optional feature 2]

### Constraints
- [Budget, timeline, tech limitations]

### Related Context
- [Existing systems, previous decisions, etc.]
```

---

## What I'll Produce

### For New Products/Features → PRD

```text
✅ Problem Statement
✅ User Stories
✅ Functional Requirements
✅ Non-Functional Requirements
✅ Success Metrics
✅ Out of Scope
```

### For Code/Implementation → Implementation Plan

```text
✅ Goal Description
✅ Proposed Changes (by file)
✅ Database Schema (if needed)
✅ API Endpoints (if needed)
✅ Verification Plan
```

### For Processes → SOPs + WIs

```text
✅ Full SOP with phases
✅ Work Instructions for complex steps
✅ QA checklists
✅ Troubleshooting guides
```

---

## Step-by-Step Process

### Step 1: Receive Brain Dump

You share your idea (structured or unstructured).

### Step 2: Ask Clarifying Questions

I'll ask 3-5 targeted questions:

- What's the **trigger** for this? (When does it happen?)
- What's the **output**? (What artifact does it produce?)
- Who **executes** this? (Human, AI, or both?)
- What can go **wrong**? (Error states?)
- What **already exists**? (Dependencies?)

### Step 3: Determine Document Types

Based on your answers:

| If it's a... | I create... |
|--------------|-------------|
| Product idea | PRD |
| Feature request | PRD + Implementation Plan |
| Process to standardize | SOP |
| Complex task | Work Instruction |
| Data structure | Schema Document |
| Code change | Implementation Plan |

### Step 4: Produce Artifacts

I'll create the appropriate documents using:

- `sop_standards` skill for SOPs
- `wi_standards` skill for Work Instructions
- `schema_standards` skill for Schemas
- `feature_architecture` skill for Architecture
- `atomic_reverse_architecture` for complex planning

### Step 5: Request Your Review

I'll show you the docs for approval before proceeding to implementation.

---

## PRD Template (What I'll Create)

```markdown
# [PRD-###] [Product/Feature Name]

## Overview
**Author**: [You]
**Date**: [Today]
**Status**: Draft

## Problem Statement
[What problem does this solve?]

## Goals & Success Metrics
| Goal | Metric | Target |
|------|--------|--------|
| [Goal] | [Metric] | [Target] |

## User Stories
- As a [user type], I want [action] so that [benefit]

## Functional Requirements
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-001 | [Requirement] | Must Have |

## Non-Functional Requirements
- Performance: [Targets]
- Security: [Requirements]
- Scalability: [Needs]

## Out of Scope
- [What this does NOT include]

## Technical Considerations
- [Architecture notes, constraints]

## Open Questions
- [Questions needing answers]
```

---

## Example Session

**You**: "I need a way to track all the SOPs in my business and know which ones are outdated"

**Me**: I'll ask:

1. How many SOPs do you have roughly?
2. What makes an SOP "outdated"? (Time-based? Content change?)
3. Who needs to see this tracking? (You only? Team?)
4. Where do SOPs live now? (Markdown files? Google Docs?)
5. Should this alert you or just display status?

**Then I produce**:

- PRD for "SOP Tracker Feature"
- Implementation Plan for building it
- Schema for storing SOP metadata

---

## Skills Used

| Skill | Purpose |
|-------|---------|
| `atomic_reverse_architecture` | Complex planning |
| `sop_standards` | Creating SOPs |
| `wi_standards` | Creating Work Instructions |
| `schema_standards` | Data structures |
| `feature_architecture` | Technical architecture |
| `feature_braindump` | Structuring raw ideas |

---

## Trigger Phrases

Say any of these:

- `/braindump`
- "I have an idea..."
- "I want to build..."
- "I need a way to..."
- "Create a PRD for..."
- "Document this process..."
- "Here's what I'm thinking..."

---

*"Raw ideas go in. Structured documents come out."*
