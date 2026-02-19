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

### Skills (100 Reusable Workflows)

Each skill is a step-by-step instruction set:

```
.agent/skills/
├── idea_to_spec/SKILL.md         ← Convert ideas to specs
├── bug_troubleshoot/SKILL.md     ← Structured debugging
├── security_audit/SKILL.md       ← Security checklist
├── git_workflow/SKILL.md         ← Branch, commit, PR workflow
├── auth_implementation/SKILL.md  ← JWT, RBAC, OAuth patterns
└── ... (100 total)
```

### Docs (67 Templates & References)

Ready-to-use templates and reference guides:

```
.agent/docs/
├── 0-context/full-stack-developer-foundation.md  ← WHY everything matters
├── 0-context/enterprise-development-guide.md     ← Enterprise patterns
├── proposal-template.md                          ← Client proposals
├── development-workflow.md                       ← Dev process guide
└── ... (67 total)
```

---

## Step 3: Use Your First Skill

### Option A: Reference in Prompt

```
"I want to build a notification system. Use the idea_to_spec skill
to help me structure this idea."
```

### Option B: Read the Skill First

1. Open `.agent/skills/idea_to_spec/SKILL.md`
2. Read the trigger commands and process
3. Follow the steps with your AI

### Option C: Use Trigger Commands

Each skill has trigger commands. Examples:

| Skill | Trigger |
|-------|---------|
| `idea_to_spec` | "I have an idea for..." |
| `bug_troubleshoot` | "I have a bug where..." |
| `security_audit` | "Security audit for [feature]" |
| `git_workflow` | "Create a PR for..." |
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

### For Professional Developers

| When... | Use... |
|---------|--------|
| First day on a codebase | `codebase_navigation` |
| Starting a feature | `idea_to_spec` → `feature_architecture` |
| Writing code | `api_design`, `auth_implementation`, `error_handling` |
| Debugging | `bug_troubleshoot` |
| Committing / PRs | `git_workflow`, `code_review_response` |
| Before shipping | `security_audit`, `e2e_testing` |
| Setting up environments | `environment_setup`, `docker_development` |
| Database changes | `db_migrations`, `database_optimization` |
| After building | `feature_walkthrough`, `api_reference` |
| Improving code | `refactoring`, `observability` |

### For Solo Developers

| When... | Use... |
|---------|--------|
| Starting a feature | `idea_to_spec` |
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
│  idea_to_spec                      feature_architecture          │
│  new_project                       feature_walkthrough           │
│  api_design                        api_reference                 │
│  auth_implementation               sop_standards                 │
│  error_handling                    schema_standards              │
│                                                                  │
│  FIXING & QUALITY                  SECURITY & TESTING            │
│  ─────────────────                 ───────────────────           │
│  bug_troubleshoot                  security_audit                │
│  refactoring                       e2e_testing                   │
│  code_review_response              unit_testing                  │
│                                                                  │
│  DEVOPS                            CONTENT                       │
│  ───────                           ─────────                     │
│  git_workflow                      content_creation              │
│  docker_development                video_research                │
│  environment_setup                 content_cascade               │
│  db_migrations                                                   │
│  infrastructure_as_code                                          │
│                                                                  │
│  CLIENT WORK                       OBSERVABILITY                 │
│  ────────────                      ──────────────                │
│  client_discovery                  observability                 │
│  proposal_generator                database_optimization         │
│  website_build                     error_tracking                │
│  website_launch                    health_checks                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Next Steps

1. ✅ Read [full-stack-developer-foundation.md](./docs/0-context/full-stack-developer-foundation.md) to understand the WHY
2. ✅ Explore the [skills-index.md](./skills-index.md) for the full list of 100 skills
3. ✅ Try `idea_to_spec` on your next feature idea
4. ✅ Set up `project_context` for your codebase
5. ✅ Use `codebase_navigation` when joining an existing project
6. ✅ Run `security_audit` before your next deploy

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
