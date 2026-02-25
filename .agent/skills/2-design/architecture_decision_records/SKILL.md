---
name: Architecture Decision Records
description: Capture architectural decisions using MADR v3.0 format with full lifecycle management and ADR index
---

# Architecture Decision Records Skill

**Purpose**: Implements structured capture of architectural decisions using the MADR (Markdown Architectural Decision Records) v3.0 format. Every significant technical choice gets a durable, searchable record of context, options considered, outcome, and consequences -- preventing "why did we do this?" questions months later.

## TRIGGER COMMANDS

```text
"Record architectural decision"
"Create ADR for [decision]"
"Document why we chose [X] over [Y]"
```

## When to Use
- Choosing between competing technologies, frameworks, or patterns
- Selecting a database, message broker, auth provider, or hosting model
- Making a design choice that constrains future options
- Reversing or superseding a prior architectural decision

---

## PROCESS

### Step 1: Determine if an ADR Is Warranted

Use this decision filter -- an ADR is needed when ANY of these are true:

- The decision is hard to reverse (one-way door)
- Multiple viable options exist and the team debated them
- The decision affects more than one module or service
- Future developers will ask "why not [alternative]?"
- Compliance or security requires a decision audit trail

### Step 2: Assign ADR Number and File

ADR numbering is sequential. Check the ADR index for the next available number.

**Path**: `.agent/docs/2-design/adr/ADR-NNNN-kebab-case-title.md`
**Index**: `.agent/docs/2-design/adr/INDEX.md`

### Step 3: Fill the MADR v3.0 Template

```markdown
# ADR-NNNN: [Decision Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-XXXX]

## Date
YYYY-MM-DD

## Context
[What is the issue? What forces are at play? Include technical constraints,
business requirements, team capabilities, and timeline pressure.]

## Decision Drivers
- [Driver 1: e.g., "Must support 10K concurrent connections"]
- [Driver 2: e.g., "Team has no Go experience"]
- [Driver 3: e.g., "Budget limits exclude managed services over $500/mo"]

## Considered Options
1. **[Option A]** -- [one-line summary]
2. **[Option B]** -- [one-line summary]
3. **[Option C]** -- [one-line summary]

## Decision Outcome
**Chosen option**: "[Option B]" because [1-2 sentence justification].

### Consequences
- **Good**: [positive outcome]
- **Bad**: [accepted tradeoff]
- **Neutral**: [side effect neither good nor bad]

## Pros and Cons of the Options

### Option A
- Good: [pro]
- Bad: [con]

### Option B (chosen)
- Good: [pro]
- Good: [pro]
- Bad: [con]

### Option C
- Good: [pro]
- Bad: [con]
- Bad: [con]

## Links
- [Related ADR-XXXX](./ADR-XXXX-title.md)
- [Phase 1 PRD section](../1-brainstorm/prd.md#section)
```

### Step 4: Update the ADR Index

Maintain the index file with every ADR:

```markdown
# ADR Index

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| ADR-0001 | Use PostgreSQL over MongoDB | Accepted | 2026-01-15 |
| ADR-0002 | JWT over session-based auth | Accepted | 2026-01-20 |
| ADR-0003 | Monorepo over polyrepo | Superseded by ADR-0007 | 2026-02-01 |
```

### Step 5: Lifecycle Management

ADRs follow a strict status lifecycle:

```
Proposed --> Accepted --> [Deprecated | Superseded by ADR-XXXX]
```

- **Never delete** an ADR. Deprecated/superseded records remain for historical context.
- When superseding, update BOTH the old ADR status AND add a forward link.
- ADRs marked "Accepted" in the design-handoff become "Must Not Change Without ADR" locked decisions.

---

## OUTPUT

**ADR files**: `.agent/docs/2-design/adr/ADR-NNNN-*.md`
**Index**: `.agent/docs/2-design/adr/INDEX.md`

---

## CHECKLIST

- [ ] Decision filter confirms ADR is warranted
- [ ] ADR number assigned sequentially
- [ ] Context section explains the forces at play
- [ ] At least 2 options considered with pros/cons
- [ ] Decision outcome states the chosen option and justification
- [ ] Consequences list good, bad, and neutral outcomes
- [ ] ADR Index updated with new entry
- [ ] Superseded ADRs have forward links
- [ ] ADR committed to version control

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P0*
