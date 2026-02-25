---
name: Skill Lifecycle Manager
description: Manages skill versioning, deprecation, sunsetting, compatibility matrices, and health metrics across framework versions.
---

# Skill Lifecycle Manager Skill

**Purpose**: Skills are not static -- they evolve, become outdated, and eventually need retirement. This skill defines the lifecycle management process: semantic versioning for skills, deprecation notices with migration guides, sunset timelines, compatibility tracking across framework versions, and health metrics to identify skills that need attention.

## TRIGGER COMMANDS

```text
"Deprecate skill [name]"
"Skill version history"
"Sunset schedule"
"Skill health report"
"Bump skill version [name]"
"Skill compatibility check"
```

## When to Use
- A skill needs updating and the change should be versioned
- A skill is being replaced by a better alternative
- Planning skill sunsetting and communicating migration paths
- Reviewing overall skill health across the framework
- Releasing a new framework version and checking skill compatibility

---

## PROCESS

### Step 1: Skill Versioning (Semver)

Apply semantic versioning to every skill:

```
MAJOR.MINOR (e.g., 1.0, 1.1, 2.0)

MAJOR: Breaking change — process steps removed, renamed, or restructured
       such that users following the old version would produce wrong results.
MINOR: Non-breaking addition — new steps added, templates expanded,
       examples updated, but existing process still works as documented.
```

Version bump process:
```markdown
## Version Bump: [Skill Name]

**Current Version**: [X.Y]
**New Version**: [X.Y+1 or X+1.0]
**Bump Type**: [MAJOR / MINOR]
**Reason**: [1 sentence explaining what changed]

### Changes
- [Change 1]
- [Change 2]

### Migration Required (MAJOR only)
- [Step users must take to adapt to the new version]
```

Update the version in the skill's frontmatter footer:
```
*Skill Version: [X.Y] | Created: [Month Year] | Updated: [Month Year]*
```

### Step 2: Deprecation Process

When a skill should no longer be the recommended approach:

```markdown
## Deprecation Notice: [Skill Name]

**Deprecated**: [YYYY-MM-DD]
**Reason**: [Why this skill is being deprecated]
**Replacement**: [Name of replacement skill, or "None — capability removed"]
**Sunset Date**: [YYYY-MM-DD, typically 90 days after deprecation]

### Migration Guide
1. [Step to migrate from deprecated skill to replacement]
2. [Step 2]
3. [Step 3]

### What Happens at Sunset
- Skill directory will be removed from the framework
- Registry entry will be marked as "sunset"
- Any skills depending on this one will be updated
```

Add a deprecation banner to the top of the deprecated SKILL.md:
```markdown
> [!WARNING]
> **DEPRECATED**: This skill is deprecated as of [date] and will be removed
> on [sunset date]. Use [replacement skill] instead.
> See migration guide: [link or inline steps]
```

### Step 3: Sunset Timeline

Standard timeline for skill retirement:

| Phase | Duration | Actions |
|-------|----------|---------|
| **Active** | Indefinite | Normal use, maintained, updated |
| **Deprecated** | Day 0 | Deprecation notice added, replacement announced |
| **Grace Period** | 90 days | Both old and new skills available, migration support |
| **Sunset** | Day 90 | Skill removed, registry marked "sunset" |
| **Archived** | Permanent | Skill content preserved in `_archive/` for reference |

Exceptions:
- **Security-critical deprecations**: Grace period reduced to 30 days
- **No replacement available**: Extend grace period to 180 days
- **Zero usage in last 90 days**: Can sunset immediately (no grace period)

### Step 4: Skill Compatibility Matrix

Track compatibility across framework versions:

```markdown
## Skill Compatibility Matrix — Framework v[X.Y]

| Skill | v1.0 | v1.1 | v2.0 | Notes |
|-------|------|------|------|-------|
| [skill_name] | OK | OK | BREAKING | [migration note] |
| [skill_name] | OK | OK | OK | |
| [skill_name] | OK | DEPRECATED | REMOVED | Replaced by [skill] |
```

Compatibility check process:
1. List all skills in the registry
2. For each skill, verify it references only existing skills as dependencies
3. Check for broken references (skills that reference removed skills)
4. Flag any skills with outdated templates or commands

### Step 5: Skill Health Metrics

Track health indicators for every skill:

```markdown
## Skill Health Report — [YYYY-MM]

| Skill | Version | Age (days) | Last Modified | Usage (30d) | Quality Score | Health |
|-------|---------|-----------|---------------|-------------|---------------|--------|
| [name] | [ver] | [days] | [date] | [count] | [0-100] | [status] |
```

Health status determination:

| Indicator | Healthy | At Risk | Critical |
|-----------|---------|---------|----------|
| **Age without update** | < 90 days | 90-180 days | > 180 days |
| **Usage (30 days)** | > 5 invocations | 1-5 invocations | 0 invocations |
| **Quality score** | > 70 | 50-70 | < 50 |
| **Dependency health** | All deps healthy | Some deps at risk | Deps deprecated/removed |

Actions by health status:
- **Healthy**: No action, continue normal maintenance
- **At Risk**: Schedule review, investigate low usage or staleness
- **Critical**: Immediate review -- deprecate, rewrite, or promote usage

### Step 6: Lifecycle Dashboard

Maintain a summary dashboard:

```markdown
## Skill Lifecycle Dashboard

**Framework Version**: [X.Y]
**Total Skills**: [N]
**Last Updated**: [YYYY-MM-DD]

### Status Summary
| Status | Count | Percentage |
|--------|-------|------------|
| Active | [N] | [%] |
| Deprecated (in grace period) | [N] | [%] |
| Sunset (archived) | [N] | [%] |

### Upcoming Sunsets
| Skill | Deprecated Date | Sunset Date | Replacement |
|-------|----------------|-------------|-------------|
| [name] | [date] | [date] | [replacement] |

### Health Summary
| Health | Count | Skills |
|--------|-------|--------|
| Healthy | [N] | [names] |
| At Risk | [N] | [names] |
| Critical | [N] | [names] |
```

---

## CHECKLIST

- [ ] All skills have version numbers in their footer
- [ ] Version bump process followed for every skill change
- [ ] Deprecated skills have deprecation banner, reason, and replacement
- [ ] Migration guides provided for all deprecated skills
- [ ] Sunset timeline followed (90-day grace period standard)
- [ ] Sunset skills archived in `_archive/` directory
- [ ] Compatibility matrix updated with each framework release
- [ ] Health metrics computed monthly
- [ ] Critical-health skills have remediation plans
- [ ] Lifecycle dashboard current and accessible

---

*Skill Version: 1.0 | Created: February 2026*
