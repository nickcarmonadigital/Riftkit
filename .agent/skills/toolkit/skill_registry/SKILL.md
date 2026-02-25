---
name: Skill Registry
description: Central registry for all framework skills with metadata, search, usage auditing, and quality scoring.
---

# Skill Registry Skill

**Purpose**: The framework's catalog of itself. This skill maintains a central manifest of every skill in the framework with metadata (name, phase, version, status, triggers, dependencies), provides discovery commands, tracks usage, and scores skill quality. Without a registry, the framework cannot know what it contains or whether skills are being used.

## TRIGGER COMMANDS

```text
"Search for skill about [topic]"
"Audit skill usage"
"List all skills in [phase]"
"Skill registry status"
"Register new skill [name]"
"Skill quality report"
```

## When to Use
- Discovering which skill handles a specific task or topic
- Auditing the framework to find unused or low-quality skills
- After creating a new skill (must register it)
- Reviewing framework coverage (which phases have gaps)
- Generating framework documentation or indexes

---

## PROCESS

### Step 1: Registry Manifest Structure

Maintain the registry at `.agent/skills/REGISTRY.json`:

```json
{
  "version": "1.0",
  "last_updated": "YYYY-MM-DD",
  "total_skills": 0,
  "skills": [
    {
      "id": "phase-skillname",
      "name": "Human Readable Name",
      "phase": "0-context",
      "directory": "0-context/skill_name/",
      "version": "1.0",
      "priority": "P0",
      "status": "active",
      "trigger_commands": ["trigger 1", "trigger 2"],
      "dependencies": ["other-skill-id"],
      "created": "YYYY-MM-DD",
      "last_modified": "YYYY-MM-DD",
      "quality_score": null,
      "usage_count": 0
    }
  ]
}
```

Status values: `active`, `draft`, `deprecated`, `sunset`

### Step 2: Skill Discovery (Search)

When a user asks to find a skill, search by:

1. **Keyword match**: Search skill names, descriptions, and trigger commands
2. **Phase filter**: List all skills within a specific phase
3. **Dependency graph**: Show which skills depend on a given skill
4. **Status filter**: Find all deprecated skills, all draft skills, etc.

Search result format:
```markdown
## Skill Search Results for "[query]"

| # | Skill | Phase | Status | Triggers |
|---|-------|-------|--------|----------|
| 1 | [name] | [phase] | [status] | [primary trigger] |
| 2 | [name] | [phase] | [status] | [primary trigger] |

**Total matches**: [N] of [total] skills
```

### Step 3: Skill Registration

When a new skill is created, register it:

1. Verify `SKILL.md` exists and has valid frontmatter (name, description)
2. Verify skill has trigger commands defined
3. Verify skill has a checklist section
4. Add entry to `REGISTRY.json`
5. Validate dependencies reference existing skills

Registration checklist:
```markdown
## New Skill Registration: [Name]

- [ ] SKILL.md exists at correct path
- [ ] Frontmatter has `name` and `description`
- [ ] Trigger commands section present (minimum 2 triggers)
- [ ] Process section has at least 2 steps
- [ ] Checklist section present (minimum 3 items)
- [ ] Dependencies reference valid skill IDs
- [ ] No duplicate skill ID in registry
- [ ] Registry JSON updated and valid
```

### Step 4: Usage Auditing

Track which skills are invoked and how often:

```markdown
## Skill Usage Audit — [YYYY-MM]

### Most Used (Top 10)
| Rank | Skill | Phase | Invocations | Trend |
|------|-------|-------|-------------|-------|
| 1 | [name] | [phase] | [count] | [up/down/stable] |

### Never Used (Attention Required)
| Skill | Phase | Created | Days Since Creation |
|-------|-------|---------|---------------------|
| [name] | [phase] | [date] | [days] |

### Recommendations
- Skills unused for 90+ days: Review for deprecation
- Skills with declining usage: Investigate — superseded or poorly discovered?
- High-usage skills: Prioritize for quality improvements
```

### Step 5: Quality Scoring

Score each skill on a 0-100 scale:

| Criterion | Weight | Scoring |
|-----------|--------|---------|
| **Completeness** | 25% | Has all required sections (frontmatter, triggers, process, checklist) |
| **Depth** | 25% | Process steps have templates, examples, and actionable detail |
| **Line Count** | 15% | 80-150 lines = full marks; <50 or >300 = penalty |
| **Freshness** | 15% | Modified within last 90 days = full marks |
| **Usage** | 20% | Invoked at least once in last 30 days = full marks |

Quality tiers:
- **90-100**: Exemplary -- reference skill
- **70-89**: Good -- meets standards
- **50-69**: Needs improvement -- schedule revision
- **0-49**: At risk -- consider rewrite or deprecation

### Step 6: Framework Coverage Report

```markdown
## Framework Coverage Report

| Phase | Skills | Active | Draft | Deprecated | Coverage |
|-------|--------|--------|-------|------------|----------|
| 0-Context | [n] | [n] | [n] | [n] | [assessment] |
| 1-Brainstorm | [n] | [n] | [n] | [n] | [assessment] |
| ... | ... | ... | ... | ... | ... |
| Toolkit | [n] | [n] | [n] | [n] | [assessment] |

**Total**: [N] skills | **Active**: [N] | **Average Quality**: [score]
```

---

## CHECKLIST

- [ ] REGISTRY.json exists and is valid JSON
- [ ] All existing skills have entries in the registry
- [ ] Every registry entry has all required fields populated
- [ ] No orphaned entries (registry points to nonexistent SKILL.md files)
- [ ] No unregistered skills (SKILL.md files missing from registry)
- [ ] Quality scores computed for all active skills
- [ ] Usage data being tracked (even if counts are zero initially)
- [ ] Coverage report shows no phase with zero skills

---

*Skill Version: 1.0 | Created: February 2026*
