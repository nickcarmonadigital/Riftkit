# AI Onboarding Context Template

**Purpose**: Provide context to AI assistants when starting new sessions.

---

## 🎯 How to Use This Template

1. Copy this template to your project
2. Fill in the sections with your project info
3. Paste at the start of new AI sessions

---

## PROJECT OVERVIEW

### Basic Info

| Field | Value |
|-------|-------|
| **Project Name** | [Your project name] |
| **Description** | [One-line description] |
| **Tech Stack** | [Frontend: X, Backend: Y, DB: Z] |
| **Status** | [Development / Staging / Production] |

### Architecture

```text
[Your project architecture diagram]

Example:
Frontend (React/Vite) 
    ↓ API calls
Backend (NestJS)
    ↓ Database queries
Database (PostgreSQL/Supabase)
```

---

## CURRENT STATE

### What's Working

- [ ] [Feature 1 - status]
- [ ] [Feature 2 - status]
- [ ] [Feature 3 - status]

### Current Blockers

- [ ] [Issue 1]
- [ ] [Issue 2]

### In Progress

- [ ] [Task 1]
- [ ] [Task 2]

---

## KEY FILES

### Frontend

```text
frontend/src/
├── components/
│   └── [key components]
├── pages/
│   └── [key pages]
└── App.tsx
```

### Backend

```text
backend/src/
├── modules/
│   └── [key modules]
├── prisma/
│   └── schema.prisma
└── main.ts
```

---

## DATABASE SCHEMA

### Key Tables

| Table | Purpose |
|-------|---------|
| `users` | User accounts |
| `[table]` | [Purpose] |
| `[table]` | [Purpose] |

---

## RECENT CHANGES

### Last Session

- [What was done]
- [Files changed]
- [New issues found]

### Pending Tasks

- [ ] [Task 1]
- [ ] [Task 2]

---

## HOW TO HELP

When assisting with this project:

1. **Check existing code** before suggesting new implementations
2. **Follow the project's patterns** for consistency
3. **Update this context** when making significant changes
4. **Reference .agent/skills/** for available workflows

---

## QUICK COMMANDS

```bash
# Start development
cd frontend && npm run dev
cd backend && npm run start:dev

# Run tests
npm test

# Build for production
npm run build
```

---

## SKILLS AVAILABLE

The following `.agent/skills/` are available:

- `idea_to_spec` - Convert ideas to specs
- `bug_troubleshoot` - Structured debugging
- `security_audit` - Security checklist
- `project_context` - Update this file

---

*Last Updated: [DATE]*
