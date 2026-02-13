---
name: Document Reorganization
description: Analyze and restructure documents for clarity without deleting content - the final step after appending new sections
---

# Document Reorganization Skill

> **The Golden Rule:** NEVER DELETE CONTENT. Only relocate, group together, and improve structure.

## 🎯 TRIGGER COMMANDS

- `/reorganize [document]` - Reorganize a specific document
- `/cleanup-doc [document]` - Same as above
- `/structure-check [document]` - Analyze structure without making changes (dry run)
- "This document is getting messy, reorganize it"
- "Group scattered sections in this document"

---

## When to Use This Skill

Use this skill as the **FINAL STEP** after:

1. ✅ You've finished adding new features/sections to a document
2. ✅ You've appended multiple updates over time
3. ✅ Related content is scattered (feature at top, related addition at bottom)
4. ✅ The document structure has drifted from logical organization
5. ✅ You want to prepare a document for external review

**DO NOT USE** if you want to delete content - that requires manual approval.

---

## The Process

### Phase 1: Document Analysis (Read-Only)

Before making ANY changes, analyze the entire document:

1. **Structure Inventory**
   - List all H1, H2, H3 headings with line numbers
   - Identify the document's logical hierarchy
   - Note any orphaned sections (content without clear parent)

2. **Content Mapping**
   - Identify topics/features mentioned in multiple places
   - Map which sections discuss the same subject
   - Find "additions" at the bottom that belong elsewhere

3. **Duplication Check**
   - Note any duplicate information (for consolidation, NOT deletion)
   - Identify conflicting information (needs resolution, not deletion)

4. **Flow Analysis**
   - Does the document follow a logical progression?
   - Are prerequisites explained before they're referenced?
   - Is there a clear beginning, middle, and end?

### Phase 2: Create Reorganization Plan

**CRITICAL:** Create a plan BEFORE making changes.

```markdown
## Reorganization Plan

### Proposed Structure Changes
| Content | Current Location | New Location | Reason |
|---------|-----------------|--------------|--------|
| Feature X details | L450-L500 | Under "Feature X" (L50) | Same topic |
| Implementation notes | L600-L620 | After "Architecture" (L150) | Logical flow |

### Content Verification
✅ All content will be preserved
✅ No deletions proposed
✅ Only structural reorganization
```

### Phase 3: Execute Reorganization

| Rule | Description |
|------|-------------|
| **NEVER DELETE** | No content is removed, only moved |
| **PRESERVE CONTEXT** | Keep surrounding context that provides meaning |
| **MAINTAIN LINKS** | Update any internal cross-references |
| **GROUP BY TOPIC** | Related content should be adjacent |
| **RESPECT HIERARCHY** | Maintain heading levels (H1 > H2 > H3) |

### Phase 4: Verification

After reorganization, verify:

- [ ] Same number of sections before and after
- [ ] Word count preserved (± 5% for formatting)
- [ ] No orphaned sections
- [ ] No accidental duplications
- [ ] Internal links still work

---

## Reorganization Patterns

### Pattern 1: Topic Consolidation

**Before:**

```
## Feature A (Line 50)
- Basic description

## Feature B (Line 150)
...

## More About Feature A (Line 450)  ← Added later
- Additional details
```

**After:**

```
## Feature A (Line 50)
- Basic description  
- Additional details  ← Moved here

## Feature B (Line 150)
...
```

### Pattern 2: Hierarchy Correction

**Before:**

```
# Main Document
## Section 1
### Subsection 1.1
## Random Addition  ← Should be under Section 1
## Section 2
```

**After:**

```
# Main Document
## Section 1
### Subsection 1.1
### Random Addition  ← Now properly nested
## Section 2
```

---

## ⚠️ Critical Rules

1. **NEVER DELETE CONTENT** - Even if redundant, consolidate instead
2. **ASK BEFORE MAJOR RESTRUCTURING** - If changing >30% of structure
3. **PRESERVE MEANING** - Move entire logical blocks, not fragments

---

## Output Summary

After reorganizing, provide:

```markdown
## Reorganization Complete

### Changes Made
1. Moved "Section X" → under "Parent Section"
2. Consolidated "Feature A" references
3. Fixed heading hierarchy

### Content Verification  
✅ No content deleted
✅ Line count preserved
✅ All headings accounted for
```

---

*Use this skill as the final step after appending new content to documents.*
