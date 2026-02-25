---
name: Feature Walkthrough (Mandatory)
description: ALWAYS create a walkthrough after completing any feature or workflow - explains how it works in plain language
---

# Feature Walkthrough Skill

**Purpose**: After completing ANY feature, workflow, or significant change, you MUST create a walkthrough document that explains how it works in plain, easy-to-understand language.

> [!CAUTION]
> **MANDATORY**: This is NOT optional. Every completed feature MUST have a walkthrough. If you finish implementing something and don't create a walkthrough, your work is incomplete.

---

## 🎯 TRIGGER COMMANDS

```text
"Create a walkthrough for [feature]"
"Document how [feature] works"
"Explain the [workflow] flow"
"Using feature_walkthrough skill: document [feature]"
"Write a user guide for [feature]"
```

---

## 📋 WHEN TO CREATE A WALKTHROUGH

Create a walkthrough when:

| Event | Walkthrough Required? |
|-------|----------------------|
| **New feature implemented** | ✅ YES - Always |
| **Existing feature modified** | ✅ YES - Update existing walkthrough |
| **New API endpoints added** | ✅ YES - Document how to use them |
| **New workflow created** | ✅ YES - Step-by-step guide |
| **Bug fixed (complex)** | ✅ YES - Explain what changed |
| **Database schema changed** | ✅ YES - Document impact |
| **Minor refactoring** | ⚠️ Optional - Only if behavior changed |

---

## 📄 OUTPUT LOCATION

**Path**: `.agent/docs/6-handoff/feature_walkthrough/[feature-name]-walkthrough.md`

**Naming**: Use kebab-case feature names, e.g.:

- `onboarding-wizard-walkthrough.md`
- `rlm-integration-walkthrough.md`
- `crm-contacts-api-walkthrough.md`
- `authentication-flow-walkthrough.md`

---

## 📝 WALKTHROUGH TEMPLATE

Use this template for ALL walkthroughs:

```markdown
# [Feature Name] Walkthrough

**Last Updated**: [Date]  
**Status**: Working / In Progress / Needs Testing  
**Related Files**: [link to main files]

---

## 🎯 What This Does

[2-3 sentences in PLAIN ENGLISH explaining what this feature does and why it exists. 
Write like you're explaining to someone who just joined the team.]

---

## 🚀 How to Use It

### Step 1: [Action Name]

[Explain what the user/developer needs to do first]

**Example**:
```

[Show actual code or UI interaction]

```

### Step 2: [Action Name]

[Continue with next steps...]

---

## 🔄 The Flow (Visual)

```text
[Create an ASCII diagram showing the flow]

User Action → Component → API → Database → Response
     ↓
  Frontend          Backend
```

---

## 📍 Key Files

| File | Purpose |
|------|---------|
| `path/to/file.ts` | [What this file does] |
| `path/to/file.tsx` | [What this file does] |

---

## 🎮 Try It Yourself

1. [Step to test the feature]
2. [What you should see]
3. [How to verify it worked]

---

## ⚠️ Common Issues

### Issue: [Problem Description]

**Symptoms**: [What you'll see when this happens]

**Solution**: [How to fix it]

---

## 📚 Related Walkthroughs

- [Link to related walkthrough 1]
- [Link to related walkthrough 2]

```

---

## 💡 WRITING TIPS

### DO:

1. **Write in plain English** - No jargon without explanation
2. **Use examples** - Show actual code/commands
3. **Include visuals** - ASCII diagrams, screenshots references
4. **Add "Try It" sections** - Let readers verify themselves
5. **Link to code** - Reference actual file paths
6. **Update when things change** - Keep it current

### DON'T:

1. **Don't assume knowledge** - Explain acronyms and concepts
2. **Don't skip steps** - Every action matters
3. **Don't just describe** - Show how to DO things
4. **Don't forget errors** - Document what can go wrong
5. **Don't delete old content** - Mark as `[OUTDATED]` instead

---

## ✅ WALKTHROUGH CHECKLIST

Before marking a walkthrough complete:

- [ ] Plain English explanation of what it does
- [ ] Step-by-step usage guide with examples
- [ ] Visual flow diagram (ASCII or mermaid)
- [ ] Key files listed with purposes
- [ ] "Try It Yourself" section included
- [ ] Common issues documented
- [ ] Saved to `.agent/docs/6-handoff/feature_walkthrough/`
- [ ] Related walkthroughs linked

---

## 🔗 INTEGRATION WITH OTHER SKILLS

| Skill | How It Integrates |
|-------|-------------------|
| `feature_architecture` | Architecture doc → Walkthrough explains HOW to use it |
| `feature_walkthrough` | Add walkthrough link to project context after creating |
| `documentation_standards` | Walkthrough is the "Post-Feature" documentation |
| `idea_to_spec` | Gemini spec → Implementation → Walkthrough |

---

## 📋 EXAMPLE WALKTHROUGHS

See existing walkthroughs for reference:

```text
.agent/docs/6-handoff/feature_walkthrough/
├── onboarding-context-layer-walkthrough.md
├── rlm-integration-walkthrough.md
└── [your new walkthrough here]
```

---

## 🚨 REMINDER FOR AI AGENTS

> **After finishing ANY implementation task:**
>
> 1. ✅ Code complete
> 2. ✅ Tests passing (if applicable)
> 3. ✅ **CREATE WALKTHROUGH** ← Don't skip this!
> 4. ✅ Update project context
> 5. ✅ Notify user of completion

**The feature is NOT done until the walkthrough exists!**
