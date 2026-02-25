# [WI-GOV-001] How to Write a Gold Standard SOP

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `WI-GOV-001` |
| **Title** | How to Write a Gold Standard SOP |
| **Version** | `v3.0` (Enhanced) |
| **Status** | `LOCKED` |
| **Owner (Role)** | COO |
| **Last Updated** | 2026-01-19 |
| **Estimated Time** | 30-45 minutes |
| **Parent SOP** | `[SOP-GOV-001]` Master SOP Standardization Protocol |

> [!CAUTION]
> **APPEND-ONLY**: When updating this document, ADD new content at the end. Mark outdated info as `[DEPRECATED]` but never delete.

---

## TARGET AUDIENCE

- **Primary**: Operations Managers, Process Owners
- **Secondary**: AI Agents creating SOPs
- **Skill Level**: Intermediate (must understand process documentation)

---

## 1.0 TL;DR (The One-Minute Summary)

| Item | Description |
|------|-------------|
| **Goal** | Produce a machine-readable, delegation-ready SOP using the Gold Standard Tabular format |
| **Trigger** | When a new process is identified as repetitive, critical, or delegatable |
| **Critical Warning** | Do not mix "Action" and "Verification." They must be in separate columns to allow for automated auditing |
| **Definition of Done** | A finalized markdown file saved in the SSoT folder that follows the `[SOP-DEPT-000]` structure exactly |

---

## 2.0 PROCESS FLOW

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   SETUP     │ ──▶│  METADATA   │ ──▶│  PROCEDURE  │ ──▶│  FINALIZE   │
│  Template   │    │   & Scope   │    │   Build     │    │  & Lock     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

---

## 3.0 PREREQUISITES (Pre-Flight Check)

| Requirement | Details |
|-------------|---------|
| **Tools** | Markdown Editor / Notion / VS Code |
| **Permissions** | Access to the SSoT Repository |
| **Inputs Needed** | Raw process notes or recording of the task being performed |
| **Template** | `[SOP-DEPT-000]` Master Template or `.agent/skills/sop_standards/SKILL.md` |

---

## 4.0 THE PROCEDURE (Step-by-Step)

### Phase 1: The Setup

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **1.1** | Open the **Master Template** file (`[SOP-DEPT-000]`) or use the `sop_standards` skill. | You see the blank tabular template. |
| **1.2** | Copy the entire content. | Content is in your clipboard. |
| **1.3** | Create a new file named `[SOP-{DOMAIN}-{NUMBER}] {Title}.md`. | **Check:** ID format matches domain list (e.g., `MKTG`, `DEV`). |
| **1.4** | Paste the template into the new file. | The blank structure is ready for editing. |

### Phase 2: The Metadata & Scope

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **2.1** | Fill in the **[METADATA HEADER]** table. | Status is set to `Draft`. Owner is assigned. |
| **2.2** | Add **Estimated Time** for completing the SOP. | Time range in minutes. |
| **2.3** | Define the **TARGET AUDIENCE** section. | Primary, Secondary, AI Agents listed. |
| **2.4** | Define the **TL;DR** section. | **Check:** "Trigger" and "Definition of Done" are binary (clear Yes/No). |
| **2.5** | Create a **PROCESS FLOW** ASCII diagram. | Visual overview of the phases. |
| **2.6** | List all **Prerequisites**. | Links to tools are clickable. |

### Phase 3: The Procedure Build (The Core)

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **3.1** | Create **Phase Headers** to group steps logically. | e.g., "Phase 1: Preparation". |
| **3.2** | Write the **Action** for Step 1.1. | |
| | • Start with a **Verb**. | |
| | • **Bold** the UI element or Object. | Example: "Click **Export Settings**." |
| **3.3** | Write the **Verification** for Step 1.1. | |
| | • Describe what the user *sees*. | Example: "A popup window appears." |
| **3.4** | **DECISION POINT:** If the process branches, add a Decision Row. | |
| | • Format: "Check [X]. If A, go to 1.5. If B, go to 2.0." | **Check:** Logic covers all scenarios (no dead ends). |
| **3.5** | Repeat for all steps. | The entire process is mapped in the table. |

### Phase 4: Finalization

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **4.1** | Write the **Quality Assurance** checklist. | |
| | • Convert the "Critical Warning" into a Yes/No question. | 3-5 Audit questions listed. |
| **4.2** | Write the **Troubleshooting** section. | |
| | • List the top 2-3 most common errors. | Solutions are actionable. |
| **4.3** | Add **Related Documents** section. | Parent, Children, Related SOPs linked. |
| **4.4** | Add **Revision History** with v1.0 entry. | Initial release documented. |
| **4.5** | Submit to **COO/Reviewer** for review. | Approval received. |
| **4.6** | Change Status to **LOCKED** and save. | **Check:** File is in the correct SSoT folder. |

---

## 5.0 QUALITY ASSURANCE (Self-Audit)

- [ ] Did you use the 3-column table format (Step | Action | Verification)?
- [ ] Are Actions separated from Verifications?
- [ ] Is the filename formatted correctly `[SOP-DOMAIN-###] Title.md`?
- [ ] Is there a Process Flow diagram?
- [ ] Is Estimated Time included?
- [ ] Is Revision History started?

---

## 6.0 TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| **I don't know the Domain Code** | Check `[SOP-GOV-001]` for domain list (MKTG, OPS, DEV, etc.) |
| **The step is too complex for one row** | Create a separate **Work Instruction (WI)** for that step and link it |
| **I can't fit the verification in one cell** | Simplify to "What does the user see?" - one sentence max |

---

## 7.0 RELATED DOCUMENTS

| Relationship | Document |
|--------------|----------|
| **Parent** | `[SOP-GOV-001]` Master SOP Standardization Protocol |
| **Related WI** | `[WI-GOV-002]` How to Write a Work Instruction |
| **Related WI** | `[WI-GOV-003]` How to Write a Schema Document |
| **Skill** | `.agent/skills/sop_standards/SKILL.md` |

---

## 8.0 REVISION HISTORY

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| v1.0 | 2025-12-12 | COO | Initial release |
| v2.0 | 2025-12-12 | COO | Added tabular format |
| v3.0 | 2026-01-19 | AI Agent | Enhanced with append-only rule, process flow diagram, estimated time, target audience, related docs, proper table formatting |

---

## [AI METADATA & GOVERNANCE]

| Field | Value |
|-------|-------|
| **System Parent** | System 0.0 (Factory OS) |
| **Executor** | COO / Operations Manager |
| **Upstream Asset** | `[SOP-GOV-001]` Master SOP Standardization Protocol |
| **QA Audit Metric** | SOP Compliance Rate |
| **AI Executable** | Yes - AI can create SOPs following this guide |
