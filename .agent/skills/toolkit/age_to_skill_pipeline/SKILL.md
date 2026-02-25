---
name: AGE-to-Skill Pipeline
description: Converts AGE analysis gap findings into production-ready skills through triage, scoping, authoring, review, and verification.
---

# AGE-to-Skill Pipeline Skill

**Purpose**: Bridges the gap between AGE analysis output (gaps.log, synthesized-gaps.md) and shipped framework skills. This skill defines the full pipeline from gap triage and prioritization, through skill scoping and authoring, to peer review, registry registration, and post-deployment verification that the original gap is actually closed.

## TRIGGER COMMANDS

```text
"Convert gaps to skills"
"AGE implementation pipeline"
"Build skill from gap finding"
"Triage AGE findings"
"Verify gap closure for [skill]"
```

## When to Use
- After an AGE analysis completes and produces synthesized-gaps.md
- When prioritizing which gaps to address first
- When authoring a new SKILL.md from a gap finding
- After deploying new skills to verify the original gap is resolved

---

## PROCESS

### Step 1: Gap Triage

Read `synthesized-gaps.md` and classify every finding:

```markdown
## Gap Triage — [AGE Target Name] — [Date]

### Priority Classification
| # | Gap Finding | Priority | Complexity | Phase | Disposition |
|---|-------------|----------|------------|-------|-------------|
| 1 | [finding] | P0 | S/M/L | [phase] | New Skill |
| 2 | [finding] | P1 | S/M/L | [phase] | Modify Existing |
| 3 | [finding] | P2 | S/M/L | N/A | Won't Fix |
| 4 | [finding] | P3 | S/M/L | [phase] | Defer |
```

Priority definitions:
- **P0**: Framework is broken or misleading without this. Ship this week.
- **P1**: Significant gap that affects workflow quality. Ship this sprint.
- **P2**: Nice to have, improves completeness. Ship when convenient.
- **P3**: Marginal value or very niche. Defer indefinitely.

Disposition options:
- **New Skill**: Gap requires a brand-new SKILL.md
- **Modify Existing**: Gap can be closed by updating an existing skill
- **Documentation Only**: Gap is informational, not procedural
- **Won't Fix**: Gap is out of scope or too niche to justify a skill

### Step 2: Skill Scope Definition

For each gap marked "New Skill", write a 3-sentence scope:

```markdown
## Skill Scope: [Proposed Skill Name]

**Source Gap**: [Gap finding from AGE, verbatim]
**Phase**: [target phase directory]
**Priority**: [P0/P1/P2]

**Scope** (3 sentences max):
1. [What the skill covers — the domain]
2. [What the skill produces — the artifacts/outcomes]
3. [What the skill does NOT cover — explicit boundaries]

**Trigger Commands** (minimum 3):
1. "[primary trigger]"
2. "[secondary trigger]"
3. "[tertiary trigger]"

**Dependencies**: [list of skill IDs this skill requires]
**Estimated Lines**: [80-150]
```

### Step 3: SKILL.md Authoring

Follow this quality checklist while writing:

```markdown
## Authoring Checklist

### Structure (Required)
- [ ] Frontmatter has `name` (Title Case) and `description` (one line)
- [ ] Purpose section: 2-3 sentences explaining why this skill exists
- [ ] Trigger Commands section: minimum 3 commands in code block
- [ ] When to Use section: minimum 3 bullet scenarios
- [ ] Process section: minimum 3 steps with actionable detail
- [ ] Checklist section: minimum 5 items

### Quality (Required)
- [ ] Line count between 80-150
- [ ] Every process step has a template, example, or command
- [ ] No vague instructions ("do the thing") — everything is specific
- [ ] Tables used for structured data (severity rubrics, cadences, etc.)
- [ ] Markdown code blocks used for templates and commands

### Consistency (Required)
- [ ] Follows existing skill format exactly (compare with reference skill)
- [ ] Phase-appropriate content (maintenance = operational, toolkit = meta)
- [ ] No overlap with existing skills (check registry)
- [ ] Dependencies reference real, existing skills
```

### Step 4: Peer Review

Before merging, the skill must pass review:

| Review Criterion | Pass/Fail | Notes |
|-----------------|-----------|-------|
| Addresses the original gap finding | | |
| Follows SKILL.md format exactly | | |
| Line count 80-150 | | |
| No overlap with existing skills | | |
| Trigger commands are natural and discoverable | | |
| Process steps are actionable (not just informational) | | |
| Checklist is a genuine quality gate | | |

### Step 5: Registration and Deployment

After review passes:
1. Create the directory: `.agent/skills/[phase]/[skill_name]/`
2. Write `SKILL.md` to the directory
3. Register in skill registry (invoke `skill_registry` skill)
4. Update any phase playbooks that should reference the new skill

### Step 6: Gap Closure Verification

30 days after deployment, verify the gap is actually closed:

```markdown
## Gap Closure Verification: [Skill Name]

**Original Gap**: [verbatim from AGE]
**Skill Deployed**: [date]
**Verification Date**: [date]

### Verification Questions
- [ ] Does the skill directly address the gap finding? (re-read both)
- [ ] Has the skill been invoked at least once?
- [ ] Would a new AGE analysis still surface this gap?
- [ ] Did the skill require any hotfixes or corrections since deployment?

### Verdict
- [ ] **CLOSED**: Gap is fully addressed
- [ ] **PARTIALLY CLOSED**: Skill helps but gap remains for edge cases
- [ ] **NOT CLOSED**: Skill missed the mark — revision needed
```

---

## CHECKLIST

- [ ] All AGE findings triaged with priority, complexity, and disposition
- [ ] P0 gaps have skill scopes written within 48 hours
- [ ] Skill scopes are exactly 3 sentences (not more, not less)
- [ ] Authored skills pass the quality checklist (structure + quality + consistency)
- [ ] Peer review completed before merge
- [ ] New skills registered in the skill registry
- [ ] Gap closure verification scheduled for 30 days post-deployment
- [ ] Verification results documented and acted upon

---

*Skill Version: 1.0 | Created: February 2026*
