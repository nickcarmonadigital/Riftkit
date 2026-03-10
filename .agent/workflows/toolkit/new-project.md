---
description: Start a brand new project from scratch with proper structure and documentation
---

# /new-project Workflow

> Use when starting a completely new project (not a feature within existing project)

## Pre-Flight Checks

- [ ] Project name defined?
- [ ] Tech stack decided?
- [ ] Domain/hosting planned?

---

## Step 1: Read Skills

// turbo

```bash
view_file .agent/skills/0-context/new_project/SKILL.md
view_file .agent/skills/0-context/ssot_structure/SKILL.md
```

---

## Step 2: Create Project Structure

Based on new_project skill:

- [ ] Create project folder
- [ ] Initialize with appropriate framework (Next.js, NestJS, etc.)
- [ ] Set up `.agent/` folder structure
- [ ] Create initial `README.md`

---

## Step 3: Initialize Documentation

- [ ] Create `.agent/docs/` folder
- [ ] Create `ai-onboarding-starter.md` (project context)
- [ ] Create `ssot-master-index.md` (if needed for this project)
- [ ] Create `implementation-plan.md` skeleton

---

## Step 4: Set Up Version Control

// turbo

```bash
git init
git add -A
git commit -m "chore: Initial project setup"
```

---

## Step 5: Create Development Environment

- [ ] Create `.env.example` with required variables
- [ ] Set up `.gitignore`
- [ ] Install dependencies
- [ ] Verify project runs locally

---

## Exit Checklist

- [ ] Project folder created with proper structure
- [ ] `.agent/` folder initialized
- [ ] Git repository initialized
- [ ] README.md exists
- [ ] Project runs locally
- [ ] Ready for /plan workflow
