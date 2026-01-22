# [WI-GOV-002] How to Write a Work Instruction

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `WI-GOV-002` |
| **Title** | How to Write a Work Instruction |
| **Version** | `v3.0` (Enhanced Tabular Standard) |
| **Status** | `LOCKED` |
| **Owner (Role)** | COO |
| **Last Updated** | 2026-01-19 |
| **Estimated Time** | 20-30 minutes |
| **Parent SOP** | `[SOP-GOV-001]` Master SOP Standardization Protocol |

> [!CAUTION]
> **APPEND-ONLY**: When updating this document, ADD new content at the end. Mark outdated info as `[DEPRECATED]` but never delete.

---

## TARGET AUDIENCE

- **Primary**: All Process Executors
- **Secondary**: AI Agents creating WIs
- **Skill Level**: Beginner-friendly (this guides you through every step)

---

## 1.0 TL;DR (The One-Minute Summary)

| Item | Description |
|------|-------------|
| **Goal** | Produce a granular, "Click-Level" guide that eliminates ambiguity for complex tasks |
| **Trigger** | When a single step in a Parent SOP is too complex to fit in one table row |
| **Critical Warning** | Do not group multiple clicks into one step. One Action = One Row. |
| **Definition of Done** | A finalized markdown file saved in the SSoT folder, explicitly linked to its Parent SOP |

---

## 2.0 PROCESS FLOW

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   SETUP     │ ──▶│ CLICK-PATH  │ ──▶│  FINALIZE   │
│   Header    │    │   Build     │    │  & Link     │
└─────────────┘    └─────────────┘    └─────────────┘
```

---

## 3.0 PREREQUISITES (Pre-Flight Check)

| Requirement | Details |
|-------------|---------|
| **Parent SOP** | You must have an existing SOP that this WI supports |
| **Experience** | You must have performed the task yourself at least once (to capture specific UI labels) |
| **Template** | Use `.agent/skills/wi_standards/SKILL.md` template |

---

## 4.0 THE PROCEDURE (Step-by-Step)

### Phase 1: The Setup & Header

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **1.1** | Create a new file using the **WI Template** from `wi_standards` skill. | File created. |
| **1.2** | Fill in the **[METADATA HEADER]**. | |
| | • **ID:** `[WI-{DOMAIN}-{NUMBER}]` | |
| | • **Title:** Action-oriented (e.g., "How to Export 4K Video"). | Header is complete. |
| **1.3** | **CRITICAL:** Add a "Parent SOP" link in the Metadata. | |
| | • *Format:* `Parent SOP: [SOP-MKTG-001]...` | **Check:** Link works and points to the correct SOP. |
| **1.4** | Add **Estimated Time** for completing the task. | Time range in minutes. |
| **1.5** | Define **TARGET AUDIENCE** with skill level. | Audience is clear. |

### Phase 2: Writing the Click-Path (The Core)

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **2.1** | Break the task down into **Single Actions**. | |
| | • *Rule:* If you click twice, it is two rows. | Logic is granular. |
| **2.2** | Write the **Action** (Column 2). | |
| | • **Bold** every UI element you touch. | |
| | • *Example:* "Click **File** > **Save As**." | **Check:** All clickable elements are **Bold**. |
| **2.3** | Write the **Verification** (Column 3). | |
| | • Describe the system response. | |
| | • *Example:* "The 'Save As' dialog box opens." | **Check:** User knows they succeeded. |
| **2.4** | **Screenshots:** If a visual is needed, add a placeholder. | |
| | • *Format:* `[Image: Screenshot of Export Settings]` | Image placeholder exists. |
| **2.5** | **Troubleshooting Notes:** If a specific error is common at a step, add a Note. | |
| | • *Example:* "*Note: If button is grayed out, refresh page.*" | Note is visible. |

### Phase 3: Finalization

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **3.1** | Write the **Self-Audit** checklist (Section 5.0). | |
| | • Ask 3 questions that verify the output quality. | Questions are binary (Yes/No). |
| **3.2** | Write the **Troubleshooting** section. | 2-3 common issues documented. |
| **3.3** | Add **Related Documents** section. | Parent SOP linked. |
| **3.4** | Add **Revision History** with v1.0 entry. | History started. |
| **3.5** | Submit to **COO/Reviewer** for review. | Approval received. |
| **3.6** | Change Status to **LOCKED** and save. | File is in SSoT. |

---

## 5.0 QUALITY ASSURANCE (Self-Audit)

- [ ] Did you use the **Bold** formatting for all UI elements?
- [ ] Is there a link to the Parent SOP?
- [ ] Is every step restricted to a single action/click?
- [ ] Does each action have a verification (what user sees)?
- [ ] Is Estimated Time included?
- [ ] Is Revision History started?

---

## 6.0 TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| **The process is too long** | Break it into Phase 1, Phase 2, etc., within the table |
| **I don't have a Parent SOP** | Create the SOP first. WIs cannot exist in a vacuum. |
| **UI element name is unclear** | Take a screenshot and reference the exact text seen |

---

## 7.0 RELATED DOCUMENTS

| Relationship | Document |
|--------------|----------|
| **Parent** | `[SOP-GOV-001]` Master SOP Standardization Protocol |
| **Related WI** | `[WI-GOV-001]` How to Write a Gold Standard SOP |
| **Related WI** | `[WI-GOV-003]` How to Write a Schema Document |
| **Skill** | `.agent/skills/wi_standards/SKILL.md` |

---

## 8.0 REVISION HISTORY

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| v1.0 | 2025-12-12 | COO | Initial release |
| v2.0 | 2025-12-12 | COO | Added Tabular Standard |
| v3.0 | 2026-01-19 | AI Agent | Enhanced with append-only rule, process flow, target audience, fixed table formatting, related docs |

---

## [AI METADATA & GOVERNANCE]

| Field | Value |
|-------|-------|
| **System Parent** | System 0.0 (Factory OS) |
| **Executor** | All Agents |
| **Upstream Asset** | `[SOP-GOV-001]` Master SOP Standardization Protocol |
| **QA Audit Metric** | WI Clarity Score |
| **AI Executable** | Yes - AI can create WIs following this guide |
