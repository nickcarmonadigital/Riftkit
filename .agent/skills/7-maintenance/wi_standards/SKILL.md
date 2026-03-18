---
name: Work Instruction Standards
description: Template and guide for creating click-level, granular Work Instructions that support parent SOPs
---

# Work Instruction Standards Skill

**Purpose**: Create granular, click-level Work Instructions (WIs) for complex steps that don't fit in a single SOP row.

> [!CAUTION]
> **APPEND-ONLY RULE**: When updating WIs, ALWAYS ADD new content. Mark outdated sections with `[DEPRECATED]` but NEVER DELETE existing content.

---

## 🎯 TRIGGER COMMANDS

```text
"Create a Work Instruction for [task]"
"This step is too complex, make a WI"
"Document the click-path for [feature]"
"Using wi_standards skill: create [WI name]"
```

---

## 📋 WHEN TO CREATE A WI

| Situation | Create WI? |
|-----------|------------|
| SOP step requires 5+ clicks | ✅ YES |
| Step involves complex UI navigation | ✅ YES |
| Step has multiple decision branches | ✅ YES |
| Step is used across multiple SOPs | ✅ YES |
| Simple single-action step | ❌ NO - keep in SOP |

---

## 📄 MASTER WI TEMPLATE

```markdown
# [WI-DEPT-000] [Action-Oriented Title]

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `[WI-DOMAIN-###]` |
| **Title** | `[Click-level action title, e.g., "How to Export 4K Video"]` |
| **Version** | `v1.0` |
| **Status** | `Draft` / `In Review` / `LOCKED` |
| **Owner (Role)** | `[Role]` |
| **Last Updated** | `[YYYY-MM-DD]` |
| **Estimated Time** | `[X-Y minutes]` |
| **Parent SOP** | `[SOP-DOMAIN-###]` [Parent SOP Title] |

---

## TARGET AUDIENCE

- **Primary**: [Who executes this?]
- **Skill Level**: [Beginner / Intermediate / Advanced]
- **Prerequisites**: [What must they know first?]

---

## 1.0 TL;DR (The One-Minute Summary)

| Item | Description |
|------|-------------|
| **Goal** | [Specific output of this WI] |
| **Trigger** | [Called from Parent SOP Step X.X] |
| **Critical Warning** | [One Action = One Row. Never group clicks.] |
| **Definition of Done** | [Clear end-state] |

---

## 2.0 PREREQUISITES

| Requirement | Details |
|-------------|---------|
| **Parent SOP** | `[SOP-XXX-###]` - You came here from Step X.X |
| **Tools Open** | [What must already be running?] |
| **Data Ready** | [What info do you need?] |

---

## 3.0 THE CLICK-PATH (Step-by-Step)

### Phase 1: [Setup]

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **1.1** | Click **[Menu]** > **[Submenu]**. | Submenu appears. |
| **1.2** | Select **[Option]**. | Option is highlighted. |
| **1.3** | *Note: If button is grayed out, refresh the page.* | |

### Phase 2: [Execution]

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **2.1** | Enter `[value]` in the **[Field Name]** field. | Value accepted. |
| **2.2** | Click **[Button]**. | [Image: screenshot placeholder] |
| **2.3** | Wait for progress bar to complete. | **Check:** "Complete" message shows. |

### Phase 3: [Verification]

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **3.1** | Navigate to **[Location]** to verify output. | Output file exists. |
| **3.2** | Return to Parent SOP Step X.X. | Continue parent process. |

---

## 4.0 QUALITY ASSURANCE (Self-Audit)

- [ ] All UI elements are **Bold**?
- [ ] One action per row (no grouped clicks)?
- [ ] Parent SOP is linked?
- [ ] Verification describes what user SEES?

---

## 5.0 TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| **Button is grayed out** | Refresh page, check permissions |
| **Error popup appears** | [Specific action to resolve] |
| **Can't find menu item** | [Alternative path or check version] |

---

## 6.0 RELATED DOCUMENTS

| Relationship | Document |
|--------------|----------|
| **Parent SOP** | `[SOP-XXX-###]` [Title] |
| **Related WIs** | `[WI-XXX-###]` [Title] |
| **Schema** | `[SCHEMA-XXX-###]` [Data involved] |

---

## 7.0 REVISION HISTORY

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| v1.0 | YYYY-MM-DD | [Role] | Initial release |

---

## [AI METADATA & GOVERNANCE]

| Field | Value |
|-------|-------|
| **System Parent** | [System 0.0 - 5.0] |
| **Executor** | [Role Name] |
| **Upstream Asset** | `[SOP-XXX-###]` Parent SOP |
| **QA Audit Metric** | WI Clarity Score |
```

---

## 💡 WI WRITING TIPS

### The One-Action Rule

```text
❌ WRONG: "Click File, then Save As, then enter filename"
✅ RIGHT: 
   1.1 Click **File**.           | File menu opens.
   1.2 Click **Save As**.        | Save dialog opens.
   1.3 Enter filename in **Name**.| Filename appears.
```

### Bold Everything Clickable

```text
❌ WRONG: "Click the export button"
✅ RIGHT: "Click **Export**."
```

### Include Visual Cues

```text
[Image: Screenshot of Export Settings panel]
*Note: The button is in the top-right corner.*
```

---

## ✅ WI COMPLETION CHECKLIST

- [ ] File named `[WI-DOMAIN-###] Title.md`
- [ ] Parent SOP linked in metadata
- [ ] One action per table row
- [ ] All UI elements are **Bold**
- [ ] Each action has verification (what user sees)
- [ ] Troubleshooting section has 2-3 common issues
- [ ] Revision history started
- [ ] Status set to LOCKED after approval


## Related Skills
- [`sop_standards`](../sop_standards/SKILL.md)
