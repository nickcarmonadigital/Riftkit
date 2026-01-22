# Skills Index

Complete list of all available skills in this framework.

## Quick Reference

| # | Skill | Trigger Example |
|---|-------|-----------------|
| 1 | `bug_troubleshoot` | "Bug: [description]" |
| 2 | `claude_verification` | "Review this code: [paste]" |
| 3 | `documentation_framework` | "What docs do I need for [project]?" |
| 4 | `feature_architecture` | "Document the [feature] architecture" |
| 5 | `feature_braindump` | "Brain dump: [your idea]" |
| 6 | `feature_walkthrough` | "Create a walkthrough for [feature]" |
| 7 | `gemini_handoff` | "Here's the spec from Gemini: [paste]" |
| 8 | `new_project` | "I want to start a new project" |
| 9 | `project_context` | "Update the project context" |
| 10 | `schema_standards` | "Create a schema for [table]" |
| 11 | `security_audit` | "Security audit for [feature]" |
| 12 | `sop_standards` | "Create an SOP for [process]" |
| 13 | `wi_standards` | "Create a Work Instruction for [task]" |
| 14 | `ssot_structure` | "Create an SSoT for [business]" |
| 15 | `ssot_update` | "Update the SSoT" |
| 16 | `content_creation` | "Write a script for [topic]" |
| 17 | `video_research` | "Research viral hooks for [niche]" |
| 18 | `content_cascade` | "Extract shorts from [video]" |
| 19 | `website_build` | "Build a website for [client]" |
| 20 | `website_launch` | "Website launch checklist" |
| 21 | `client_discovery` | "Prepare for discovery call" |
| 22 | `proposal_generator` | "Create a proposal for [client]" |

## Skills by Category

### Development

```
.agent/skills/
├── bug_troubleshoot/     - Bug reporting template
├── claude_verification/  - Code review with Claude
├── feature_braindump/    - Ideas → specs
├── feature_architecture/ - Architecture docs
├── feature_walkthrough/  - Post-build walkthroughs
├── gemini_handoff/       - Brain dump → structured spec
├── new_project/          - Project setup
└── project_context/      - Living context doc
```

### Documentation

```
.agent/skills/
├── documentation_framework/ - Doc types reference
├── sop_standards/           - SOP template
├── wi_standards/            - Work instruction template
├── schema_standards/        - Database schema docs
├── ssot_structure/          - SSoT structure
└── ssot_update/             - SSoT update protocol
```

### Security

```
.agent/skills/
└── security_audit/       - Security checklist (OWASP)
```

### Content

```
.agent/skills/
├── content_creation/     - Scripts and hooks
├── video_research/       - Viral content analysis
└── content_cascade/      - 1 video → 30 shorts
```

### Client Work

```
.agent/skills/
├── website_build/        - Anti-AI-slop design
├── website_launch/       - Go-live checklist
├── client_discovery/     - Client intake
└── proposal_generator/   - Quick proposals
```

## How to Use

1. Read the skill's `SKILL.md` file
2. Use one of the trigger commands
3. Follow the process steps
4. Complete the checklist

## Adding New Skills

Create: `.agent/skills/[your-skill]/SKILL.md`

Required sections:

- YAML frontmatter (name, description)
- Trigger commands
- When to use
- Step-by-step process
- Completion checklist
