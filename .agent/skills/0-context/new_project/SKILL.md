---
name: New Project Setup
description: Template and checklist for starting a brand new project from scratch
---

# New Project Setup Skill

Use this when starting a **completely new project** (not adding features to existing project).

---

## 🎯 TRIGGER COMMANDS

Use any of these phrases to activate this skill:

```
"I want to start a new project"
"New project: [project name]"
"Create a new [type] project"
"Starting fresh with [project idea]"
"Set up a new codebase for [project]"
"Initialize new project"
"Using new_project skill: [project idea]"
"Pick a blueprint for [project]"
```

---

## WHEN TO USE

- Starting a new codebase from scratch
- Creating a new product/app
- NOT for adding features to existing project (use Feature Brain Dump instead)

---

## PRE-PROJECT CHECKLIST

Before writing any code, define:

### 0. Blueprint Selection (Optional)

Check `.agent/blueprints/` for a matching starter template:

- `01-web-and-apps`
- `02-games`
- `03-trading-and-finance`
- `04-web3-and-blockchain`
- `05-ai-and-ml`
- `06-hardware-and-iot`
- `07-automation-and-devops`
- `08-plugins-and-extensions`
- `09-data-and-analytics`

If one matches, copy its specific startup checklist into your `.agent/docs/0-context/project-context.md`.

### 1. Product Definition

```
Project Name: [name]
One-line Description: [what it does in one sentence]
Problem: [what pain point it solves]
Target User: [who uses this]
```

### 2. Tech Stack Decisions

```
Frontend: [React/Vue/Next.js/etc]
Backend: [NestJS/Express/etc]
Database: [Supabase/PostgreSQL/etc]
Auth: [Supabase Auth/Auth0/etc]
Hosting: [Vercel/Railway/etc]
```

### 3. Architecture Decisions

```
Multi-tenant or Single-user: [choose one]
Auth Strategy: [JWT/Session/etc]
API Style: [REST/GraphQL]
```

### 4. Core Features (MVP)

```
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]
```

---

## PROJECT INITIALIZATION

### Step 1: Create Repository

```bash
mkdir [project-name]
cd [project-name]
git init
```

### Step 2: Initialize Frontend

```bash
npx create-vite@latest frontend --template react-ts
```

### Step 3: Initialize Backend

```bash
npx @nestjs/cli new backend
```

### Step 4: Setup AI Framework

```bash
mkdir -p .agent/skills .agent/docs
```

### Step 5: Create Project Context

Copy this framework's `.agent` folder and fill in your project details.
If you selected a blueprint, copy its specific templates into `.agent/docs/0-context/`.

---

## FOLDER STRUCTURE TEMPLATE

```
[project-name]/
├── frontend/
├── backend/
├── .agent/
│   ├── docs/
│   │   ├── 0-context/
│   │   │   └── ai-onboarding-starter-template.md
│   │   ├── 1-brainstorm/
│   │   ├── 2-design/
│   │   ├── 3-build/
│   │   ├── 4-secure/
│   │   ├── 5-ship/
│   │   ├── 6-handoff/
│   │   ├── 7-maintenance/
│   │   ├── toolkit/
│   │   └── reports/
│   └── skills/
├── .env.example
├── README.md
└── CHANGELOG.md
```

---

## BRAIN DUMP TO GEMINI

When brain dumping a new project idea to Gemini, include:

```
I want to build [PROJECT NAME].

PROBLEM: [What problem does it solve]
USERS: [Who uses it]
FEATURES: [List main features]
LIKE: [Similar to X product but with Y difference]
TECH PREFERENCES: [Any tech stack preferences]
```

Gemini will help structure into PRD and tech spec.
