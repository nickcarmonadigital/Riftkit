---
description: Plan a feature from vision docs using first principles decomposition
---

# /plan Workflow

> Use when you have a vision/requirement and need to break it into implementable tasks

## Input Required

- Vision document or feature description
- Implementation plan (if exists)

---

## Step 1: Read Planning Skills

// turbo

```bash
view_file .agent/skills/atomic_reverse_architecture/SKILL.md
view_file .agent/skills/idea_to_spec/SKILL.md
```

---

## Step 2: First Principles Decomposition (ARA)

Using atomic_reverse_architecture skill:

1. **Define the End State**: What does "done" look like?
2. **Reverse Engineer**: What components are needed?
3. **Identify Gaps**: What's missing between now and done?
4. **Atomic Tasks**: Break into smallest implementable units

---

## Step 3: Threat Modeling (Shift Left)

**Security is not an afterthought.** Identify risks now.

1. **Data Flow Analysis**: Where does sensitive data go?
2. **Trust Boundaries**: Where does data cross from "untrusted" to "trusted"?
3. **STRIDE Check**:
    - **S**poofing (Can I pretend to be someone else?)
    - **T**ampering (Can I change data?)
    - **R**epudiation (Can I deny I did it?)
    - **I**nformation Disclosure (Can I see things I shouldn't?)
    - **D**enial of Service (Can I crash it?)
    - **E**levation of Privilege (Can I become admin?)

---

## Step 4: Architecture Decision Records (ADR)

**Don't just choose. Document WHY.**

For every major decision (Database choice, Framework, Auth provider):

1. **Title**: [Short title]
2. **Context**: What is the problem/constraint?
3. **Decision**: We chose [Option A]
4. **Consequences**: Implication (Good & Bad)

> *Example: "We chose JWT over Sessions because we need stateless scaling, accepting the trade-off of harder revocation."*

---

## Step 5: Idea to Spec (if unstructured input)

If starting from unstructured ideas:

1. Capture all requirements/ideas
2. Group by category
3. Identify dependencies
4. Prioritize by value/complexity

---

## Step 6: Create/Update Implementation Plan

Output: `.agent/docs/0-context/implementation-plan.md` or brain artifact

Include:

- [ ] Goal description
- [ ] **Mermaid.js System Diagram** (Visual Flow)
- [ ] **University Heist Analysis** (Big O & Concurrency Risk)
- [ ] Proposed changes by component
- [ ] File-by-file breakdown
- [ ] Verification plan (TDD approach)
- [ ] **Threat Model** (STRIDE Findings)
- [ ] **ADRs** (Key Decisions Documented)
- [ ] User review items

---

## Step 7: Identify Skills Needed for Build

Based on the plan, check which skills will be needed:

| Task Type | Skills to Use |
|-----------|---------------|
| Database changes | schema_standards |
| New API endpoints | feature_architecture |
| Frontend pages | website_build |
| Security-sensitive | security_audit |
| Complex feature | feature_architecture |

---

## Step 8: Get User Approval

**STOP HERE** - Present plan to user for approval before /build

---

## Exit Checklist

- [ ] Vision analyzed and understood
- [ ] Tasks broken into atomic units
- [ ] Implementation plan created/updated
- [ ] Dependencies identified
- [ ] Skills needed for build identified
- [ ] User approval received
