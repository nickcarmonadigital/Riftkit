---
name: SSoT Update Protocol
description: Ensure the Single Source of Truth (SSoT) Master Index is updated after every significant change
---

# SSoT Update Protocol Skill

**Purpose**: Automatically update the SSoT Master Index after any feature, workflow, or document change to maintain a living, accurate business governance record.

> [!CAUTION]
> **APPEND-ONLY RULE**: When updating the SSoT, ALWAYS ADD new content. Mark outdated sections with `[DEPRECATED]` but NEVER DELETE existing content. The SSoT is a historical record.

---

## 🎯 TRIGGER COMMANDS

```text
"Update the SSoT"
"Add this to the master index"
"Register this document in SSoT"
"Using ssot_update skill: add [item]"
```

---

## 📋 WHEN TO UPDATE THE SSoT

| Event | SSoT Action |
|-------|-------------|
| **New SOP created** | Add to appropriate section (0.1-5.0) |
| **New Schema created** | Add to 0.1 (SSoT Governance) |
| **New Feature implemented** | Add to Feature Registry |
| **New Training module** | Add to 0.2 (Training & Certification) |
| **New QA checklist** | Add to 0.3 (QA Engine) |
| **Process changed** | Update relevant section, add revision note |
| **Document deprecated** | Mark as `[DEPRECATED]` with date |

---

## 📄 SSoT UPDATE TEMPLATE

When adding a new item to the SSoT, use this format:

```markdown
* **[Section #] [Item Name]**
  * `[ASSET-ID] [Document Title] [STATUS]`
  * Related: [Link to related docs if applicable]
```

### Status Tags

| Tag | Meaning |
|-----|---------|
| `COMPLETED` | Document is finalized and locked |
| `IN_PROGRESS` | Document exists but needs work |
| `NEED TO STANDARDIZE` | Raw content needs formatting |
| `BLANK` | Placeholder, no content yet |
| `[DEPRECATED]` | Superseded, kept for history |

---

## ✅ SSoT UPDATE CHECKLIST

Before completing an SSoT update:

- [ ] Added item to correct section (0.0-5.0, 1.0-5.0)?
- [ ] Used proper asset ID format (`[SOP-XXX-###]`, `[SCHEMA-XXX-###]`)?
- [ ] Set correct status tag?
- [ ] Added cross-reference to related documents?
- [ ] Updated "Last Updated" date at top of SSoT?

---

## 📁 SSoT LOCATION

The SSoT Master Index lives at:

```text
.agent/docs/7-maintenance/ssot-master-index.md
```

---

## 💡 AI AGENT REMINDER

After completing ANY task that creates or modifies documentation:

1. **Check**: Does this affect the SSoT?
2. **Add**: Register new items in appropriate section
3. **Link**: Cross-reference related documents
4. **Date**: Update "Last Updated" field

**A task is NOT complete until the SSoT reflects the change.**
