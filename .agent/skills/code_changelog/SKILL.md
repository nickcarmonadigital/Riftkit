---
name: Code Changelog
description: Document every code change with version info for team onboarding and audit trail
---

# Code Changelog Skill

## Purpose

Create a persistent audit trail of all code changes so that:

1. New team members can understand evolution of any file
2. AI agents have context for why code looks the way it does
3. Debugging is easier with change history
4. No knowledge is lost between sessions

---

## When to Use

**Trigger**: After completing any code change (new file, modification, refactor)

**Not Required For**:

- Documentation files (.md)
- Config files with trivial changes
- Formatting-only changes

---

## Output Options

### Option A: In-Code Comments (Small Changes)

Add a changelog block at the end of the file:

```typescript
/**
 * CHANGELOG
 * ─────────
 * 2026-01-20 | Initial creation - CRM contact service with CRUD operations
 * 2026-01-21 | Added soft delete functionality per GDPR requirements
 * 2026-01-22 | Fixed N+1 query issue in getContactsWithCompany()
 */
```

### Option B: Separate Changelog File (Recommended)

Create `CHANGELOG.md` in the module/component directory:

```
backend/
├── src/
│   ├── crm/
│   │   ├── CHANGELOG.md        ← Module-level changelog
│   │   ├── crm.controller.ts
│   │   ├── crm.service.ts
│   │   └── ...
frontend/
├── src/
│   ├── features/
│   │   ├── dashboard/
│   │   │   ├── CHANGELOG.md    ← Feature-level changelog
│   │   │   └── ...
```

### Option C: Central Dev Log (For Sessions)

Create `.agent/docs/dev-log.md` for session-based logging:

```markdown
# Development Log

## 2026-01-20

### Session: Context Layer Refactor
**Files Changed**:
- `backend/src/onboarding/onboarding.service.ts`
- `backend/src/context/context.service.ts`

**What Was Done**:
- Refactored to single-tenant architecture
- Hardcoded 62 questions into service
- Removed multi-tenancy feature flags

**Why**:
- Single-tenant MVP faster to ship
- Multi-tenancy adds complexity without users

**Breaking Changes**:
- `tenant_id` field removed from context tables

---
```

---

## Changelog Entry Format

```text
DATE | AUTHOR | CHANGE SUMMARY
────────────────────────────────
Details of what changed and why.
Files affected: [list]
Breaking changes: [yes/no + details]
Related: [ticket/issue/PR]
```

### Example Entry

```markdown
## 2026-01-20 | @agent | CRM Lead Scoring Implementation

### Summary
Added AI-powered lead scoring to CRM module. Scores are calculated based on:
- Company size (from Context Layer)
- Engagement frequency
- Budget signals

### Files Changed
| File | Change Type | Description |
|------|-------------|-------------|
| `crm.service.ts` | Modified | Added `calculateLeadScore()` method |
| `lead-scoring.service.ts` | New | AI scoring logic |
| `crm.entity.ts` | Modified | Added `score` field (integer 0-100) |

### Breaking Changes
- Database migration required: `ALTER TABLE contacts ADD COLUMN score INTEGER DEFAULT 0`

### Dependencies Added
- `@langchain/openai` for AI scoring
- `zod` for score validation

### Test Coverage
- Unit tests: `lead-scoring.service.spec.ts`
- E2E: Manual testing in dev environment
```

---

## Integration with SSoT

When making significant changes, update:

1. **CHANGELOG.md** in the affected module
2. **dev-log.md** for session context
3. **ssot-master-index.md** if architecture changes

---

## Automation Reminder

After completing any code task, the AI agent should:

```text
✅ BEFORE MOVING ON:
[ ] Did I document what was changed?
[ ] Did I explain WHY it was changed?
[ ] Did I note any breaking changes?
[ ] Did I update the dev-log if this was a significant session?
```

---

## Quick Templates

### New File Template Header

```typescript
/**
 * @file crm.service.ts
 * @created 2026-01-20
 * @description Handles CRM operations including contacts, companies, deals
 * @changelog See CHANGELOG.md in this directory
 */
```

### Modification Comment

```typescript
// 2026-01-21: Added rate limiting to prevent API abuse (max 100 req/min)
```

### Session End Template

```markdown
## Session End: [Date]

### Completed
- [x] Task 1
- [x] Task 2

### Deferred
- [ ] Task 3 (blocked by X)

### For Next Session
- Start with: [specific file/task]
- Context needed: [key info to remember]
```

---

*"No knowledge lost. Every change documented. Anyone can understand the evolution."*
