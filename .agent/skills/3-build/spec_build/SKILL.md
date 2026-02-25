---
name: Spec Build
description: 12-phase autonomous spec creation workflow - the master loop for building features
---

# Spec Build Skill

**Purpose**: Execute the 12-phase spec build workflow for creating complete, production-ready feature specifications and implementations.

> This is the **master orchestrator skill** that invokes other skills at each phase.

---

## 🎯 TRIGGER COMMANDS

```text
"Build a spec for [feature]"
"Start spec build for [feature]"
"12-phase spec for [feature]"
"Using spec_build skill: [feature name]"
```

---

## 🔄 THE 12-PHASE LOOP

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SPEC BUILD WORKFLOW                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  PHASE 1   Vision & PRD           → idea_to_spec skill                      │
│     ↓                                                                        │
│  PHASE 2   ARA Analysis           → atomic_reverse_architecture skill        │
│     ↓                                                                        │
│  PHASE 3   Schema Design          → documentation_standards skill            │
│     ↓                                                                        │
│  PHASE 4   API Design             → feature_architecture skill               │
│     ↓                                                                        │
│  PHASE 5   Security Review        → security_audit skill                     │
│     ↓                                                                        │
│  PHASE 6   Prompts Design         → ssot skill                               │
│     ↓                                                                        │
│  PHASE 7   Implementation         → code_changelog skill                     │
│     ↓                                                                        │
│  PHASE 8   SOPs & WIs             → documentation_standards skill            │
│     ↓                                                                        │
│  PHASE 9   Deployment Modes       → deployment_modes skill                   │
│     ↓                                                                        │
│  PHASE 10  UI Polish              → ui_polish skill                          │
│     ↓                                                                        │
│  PHASE 11  Walkthrough            → feature_walkthrough skill                │
│     ↓                                                                        │
│  PHASE 12  SSoT Update            → ssot skill                               │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 PHASE DETAILS

### Phase 1: Vision & PRD

**Skill Invoked**: `idea_to_spec`

**Input**: Feature brain dump or structured spec
**Output**: Complete PRD with OVERVIEW, TECHNICAL, SECURITY, BUILD sections
**Gate Condition**: Problem statement is clear and solution is defined

```
[ ] Problem statement defined
[ ] Solution approach documented
[ ] Priority set (P0-P3)
[ ] Success criteria identified
```

---

### Phase 2: ARA Analysis

**Skill Invoked**: `atomic_reverse_architecture`

**Input**: PRD from Phase 1
**Output**: Dependency map, component breakdown, integration points
**Gate Condition**: All dependencies identified and mapped

```
[ ] Existing components identified
[ ] New components required listed
[ ] Integration points mapped
[ ] Data flow documented
```

---

### Phase 3: Schema Design

**Skill Invoked**: `documentation_standards` (Schema section)

**Input**: ARA analysis
**Output**: Database schema document with field definitions
**Gate Condition**: Schema document created with all fields typed

```
[ ] Tables/entities defined
[ ] Field types specified
[ ] Relationships documented
[ ] Constraints listed
```

---

### Phase 4: API Design

**Skill Invoked**: `feature_architecture`

**Input**: Schema from Phase 3
**Output**: API specification with endpoints, request/response schemas
**Gate Condition**: All endpoints documented with auth rules

```
[ ] Endpoints listed
[ ] Request schemas defined
[ ] Response schemas defined
[ ] Auth requirements specified
```

---

### Phase 5: Security Review

**Skill Invoked**: `security_audit`

**Input**: API spec and schema
**Output**: Security checklist and threat assessment
**Gate Condition**: Security checklist passed

```
[ ] Auth requirements verified
[ ] Input validation planned
[ ] Data access controls defined
[ ] Audit logging planned
```

---

### Phase 6: Prompts Design

**Skill Invoked**: `ssot`

**Input**: All previous phase outputs
**Output**: AI prompts registered in SSoT
**Gate Condition**: All prompts documented and registered

```
[ ] System prompts defined
[ ] User prompts documented
[ ] Context requirements listed
[ ] Prompts registered in SSoT
```

---

### Phase 7: Implementation

**Skill Invoked**: `code_changelog`

**Input**: All specs from Phases 1-6
**Output**: Working code implementation
**Gate Condition**: Feature builds and runs without errors

```
[ ] Backend code complete
[ ] Frontend code complete
[ ] Database migrations created
[ ] No build errors
```

---

### Phase 8: SOPs & WIs

**Skill Invoked**: `documentation_standards` (SOP/WI sections)

**Input**: Completed implementation
**Output**: Operational documentation for the feature
**Gate Condition**: At least one SOP created

```
[ ] Main SOP created
[ ] Work Instructions for complex steps
[ ] Troubleshooting section included
```

---

### Phase 9: Deployment Modes

**Skill Invoked**: `deployment_modes`

**Input**: Implementation from Phase 7
**Output**: Feature works in all deployment modes
**Gate Condition**: Cloud, Hybrid, and Sovereign modes supported

```
[ ] Cloud mode verified
[ ] Hybrid mode verified
[ ] Sovereign mode verified
[ ] Fallbacks in place
```

---

### Phase 10: UI Integration & Polish (CRITICAL)

**Skill Invoked**: `ui_polish`

**Input**: Working implementation
**Output**: Feature is VISIBLE and ACCESSIBLE in the UI
**Gate Condition**: User can navigate to feature from sidebar/settings

> **CRITICAL REQUIREMENT**: A feature is NOT complete until users can access it from the UI.
> Every spec build MUST make the feature visible somewhere in the application.

```
[ ] Feature is ACCESSIBLE via UI (route, sidebar, or settings tab)
[ ] Route added to App.tsx (if applicable)
[ ] Sidebar link added (if applicable)
[ ] Settings tab entry (if configuration feature)
[ ] feature-access-guide.md updated with navigation path
[ ] Desktop layout polished
[ ] Mobile responsive
[ ] Loading states present
[ ] Error states handled
[ ] Tooltips/help text added
```

**UI Integration Options**:

| Type | Where to Add | Example |
|------|-------------|---------|
| New Page | `App.tsx` routes + sidebar | `/feature-name` |
| Settings Feature | `SettingsPage.tsx` tabs | AI Brains selector |
| Modal/Panel | Existing page component | SME Request Modal |
| Dashboard Widget | Dashboard page | Analytics cards |

---

### Phase 11: Walkthrough

**Skill Invoked**: `feature_walkthrough`

**Input**: Completed, polished feature
**Output**: User-facing documentation and guide
**Gate Condition**: Complete walkthrough document created

```
[ ] Feature overview written
[ ] Step-by-step instructions
[ ] Screenshots/examples included
[ ] Linked in feature registry
```

---

### Phase 12: SSoT Update

**Skill Invoked**: `ssot`

**Input**: All documentation from previous phases
**Output**: SSoT Master Index updated
**Gate Condition**: All new documents registered in SSoT

```
[ ] New docs added to SSoT
[ ] Feature Registry updated
[ ] Master Vision linked
[ ] Status set to COMPLETED
```

---

## 🚦 EXIT CONDITIONS

The spec build workflow is **COMPLETE** when:

- [ ] All 12 phases have gate conditions met
- [ ] Feature is fully implemented and working
- [ ] **CRITICAL: Feature is VISIBLE in the UI** (route, sidebar, or settings)
- [ ] **feature-access-guide.md** updated with navigation instructions
- [ ] Documentation is complete (PRD, Schema, API, SOP, Walkthrough)
- [ ] SSoT Master Index reflects all changes
- [ ] No outstanding bugs or issues

> **MANDATORY**: Never mark a spec build as complete unless users can access the feature from the UI.

---

## ⚠️ ERROR HANDLING

### Phase Failure

If any phase fails:

1. **Document the failure** - What went wrong, why
2. **Retry once** - With adjustments based on failure
3. **Escalate if retry fails** - Ask user for guidance
4. **Don't skip phases** - Each phase gates the next

### Common Blockers

| Blocker | Resolution |
|---------|------------|
| Unclear requirements | Return to Phase 1, refine PRD |
| Schema conflicts | Return to Phase 3, resolve data model |
| Security concern | Return to Phase 5, address threat |
| Build errors | Stay in Phase 7, fix code |
| UI bugs | Stay in Phase 10, polish |

---

## 📊 PROGRESS TRACKING

For each spec build, maintain a status tracker:

```markdown
## [Feature Name] Spec Build Status

| Phase | Status | Notes |
|-------|--------|-------|
| 1. Vision & PRD | ✅ Complete | |
| 2. ARA Analysis | ✅ Complete | |
| 3. Schema Design | ✅ Complete | |
| 4. API Design | 🔄 In Progress | 3/5 endpoints done |
| 5. Security Review | ⏳ Pending | |
| 6. Prompts Design | ⏳ Pending | |
| 7. Implementation | ⏳ Pending | |
| 8. SOPs & WIs | ⏳ Pending | |
| 9. Deployment Modes | ⏳ Pending | |
| 10. UI Polish | ⏳ Pending | |
| 11. Walkthrough | ⏳ Pending | |
| 12. SSoT Update | ⏳ Pending | |
```

---

## 💡 BEST PRACTICES

1. **Don't rush phases** - Quality > Speed
2. **Gate rigorously** - Each phase must fully complete before next
3. **Document as you go** - Don't leave docs for the end
4. **Test incrementally** - Verify each phase's output
5. **Update SSoT continuously** - Not just at Phase 12

---

## 📚 RELATED SKILLS

| Skill | Used In Phase |
|-------|---------------|
| `idea_to_spec` | Phase 1 |
| `atomic_reverse_architecture` | Phase 2 |
| `documentation_standards` | Phases 3, 8 |
| `feature_architecture` | Phase 4 |
| `security_audit` | Phase 5 |
| `ssot` | Phases 6, 12 |
| `code_changelog` | Phase 7 |
| `deployment_modes` | Phase 9 |
| `ui_polish` | Phase 10 |
| `feature_walkthrough` | Phase 11 |

---

*Skill Version: 1.0 | Created: January 26, 2026*
