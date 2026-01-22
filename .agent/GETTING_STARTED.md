# Getting Started

Get productive with this framework in **5 minutes**.

---

## Step 1: Add to Your Project

Copy the `.agent` folder to your project root:

```bash
# If you cloned this repo
cp -r .agent /path/to/your/project/

# Or just download and drag-drop
```

Your project should look like:

```
your-project/
├── .agent/           ← Add this
│   ├── skills/
│   └── docs/
├── src/
├── package.json
└── ...
```

---

## Step 2: Understand the Structure

### Skills (Reusable Workflows)

Each skill is a step-by-step instruction set:

```
.agent/skills/
├── feature_braindump/SKILL.md    ← Convert ideas to specs
├── bug_troubleshoot/SKILL.md     ← Structured debugging
├── security_audit/SKILL.md       ← Security checklist
└── ... (22 total)
```

### Docs (Templates & References)

Ready-to-use templates:

```
.agent/docs/
├── proposal-template.md          ← Client proposals
├── client-discovery-template.md  ← Intake questions
├── development-workflow.md       ← Dev process guide
└── ... (9 total)
```

---

## Step 3: Use Your First Skill

### Option A: Reference in Prompt

```
"I want to build a notification system. Use the feature_braindump skill 
to help me structure this idea."
```

### Option B: Read the Skill First

1. Open `.agent/skills/feature_braindump/SKILL.md`
2. Read the trigger commands and process
3. Follow the steps with your AI

### Option C: Use Trigger Commands

Each skill has trigger commands. Examples:

| Skill | Trigger |
|-------|---------|
| `feature_braindump` | "I have an idea for..." |
| `bug_troubleshoot` | "I have a bug where..." |
| `security_audit` | "Security audit for [feature]" |
| `project_context` | "Update the project context" |

---

## Step 4: Set Up Your First Session

For best results, start sessions with context:

```
"I'm working on [PROJECT NAME]. Here's the current state:

Tech Stack: React + NestJS + PostgreSQL
Current Feature: Building user dashboard
Status: Basic layout done, need to add charts

Use the project_context skill pattern to help me continue."
```

💡 **Pro Tip**: Create your own `ai-onboarding-template.md` using the template in docs. Paste it at the start of each session.

---

## Most Used Skills

### For Solo Developers

| When... | Use... |
|---------|--------|
| Starting a feature | `feature_braindump` |
| Debugging | `bug_troubleshoot` |
| Before shipping | `security_audit` |
| After building | `feature_walkthrough` |

### For Client Work

| When... | Use... |
|---------|--------|
| First call | `client_discovery` |
| Sending quote | `proposal_generator` |
| Building site | `website_build` |
| Going live | `website_launch` |

### For Content Creators

| When... | Use... |
|---------|--------|
| Researching | `video_research` |
| Writing scripts | `content_creation` |
| Repurposing | `content_cascade` |

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│                    SKILL QUICK REFERENCE                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  BUILDING                          DOCUMENTING                   │
│  ─────────                         ─────────────                 │
│  feature_braindump                 feature_architecture          │
│  new_project                       feature_walkthrough           │
│  project_context                   sop_standards                 │
│  gemini_handoff                    schema_standards              │
│                                                                  │
│  FIXING                            SECURITY                      │
│  ───────                           ─────────                     │
│  bug_troubleshoot                  security_audit                │
│  claude_verification                                             │
│                                                                  │
│  CLIENT WORK                       CONTENT                       │
│  ────────────                      ─────────                     │
│  client_discovery                  content_creation              │
│  proposal_generator                video_research                │
│  website_build                     content_cascade               │
│  website_launch                                                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Next Steps

1. ✅ Explore the [skills-index.md](.agent/skills-index.md) for full list
2. ✅ Try `feature_braindump` on your next idea
3. ✅ Set up `project_context` for your codebase
4. ✅ Run `security_audit` before your next deploy

---

## Tutorials

**🎬 Watch the video tutorials**: [Your YouTube Channel]

Each skill was developed during live coding sessions. Watch how they're used in real projects.

---

## Need Help?

- 📖 Check the skill's SKILL.md for detailed instructions
- 🎥 Watch the tutorial video for that skill
- 💬 Open an issue on GitHub

---

*Happy building! 🚀*
