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
```

---

## WHEN TO USE

- Starting a new codebase from scratch
- Creating a new product/app
- NOT for adding features to existing project (use Feature Brain Dump instead)

---

## PRE-PROJECT CHECKLIST

Before writing any code, define:

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

---

## FOLDER STRUCTURE TEMPLATE

```
[project-name]/
├── frontend/
├── backend/
├── .agent/
│   ├── docs/
│   │   └── ai-onboarding-starter.md
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
