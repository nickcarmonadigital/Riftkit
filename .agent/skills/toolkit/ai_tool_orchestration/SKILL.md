---
name: AI Tool Orchestration
description: When and how to use Claude Code, Cursor, Copilot, and Gemini together for maximum productivity
---

# AI Tool Orchestration Skill

> **PURPOSE**: Pick the right AI tool for each task and chain them together into efficient workflows that save time and money.

## When to Use

- Starting a new project and choosing which AI tools to set up
- Wondering whether to use Claude Code, Cursor, Copilot, or Gemini for a task
- Building a multi-step workflow that involves research, planning, and coding
- Wanting to reduce AI costs without reducing quality
- Setting up MCP servers and tool extensions

---

## The Right Tool for the Right Job

Each AI tool has a sweet spot. Using the wrong tool for a task wastes time and money.

### Claude Code (CLI Agent)

| Strength | Example |
|----------|---------|
| Multi-file changes | "Add authentication to every controller" |
| Complex builds | "Build the entire CRUD module with tests" |
| Codebase-wide refactors | "Rename all instances of userId to accountId" |
| Debugging across files | "Find why the API returns 500 on /dashboard" |
| Git operations | "Review my changes and create a commit" |
| Running commands | "Run tests and fix any failures" |

**When to use**: You know what you want built and need an agent to execute across your whole codebase. Best for tasks that touch 3+ files.

**When NOT to use**: Quick one-line fixes, visual exploration of unfamiliar code, brainstorming.

### Cursor (IDE with AI)

| Strength | Example |
|----------|---------|
| Visual editing | Seeing inline diffs before accepting changes |
| Quick fixes | "Fix this TypeScript error" (Cmd+K on the line) |
| Code exploration | Reading unfamiliar code with AI explanations |
| Tab completions | Autocomplete that understands your codebase |
| Composer mode | Multi-file edits with visual diff review |
| Chat with codebase | "How does the auth flow work in this project?" |

**When to use**: You are actively reading and editing code and want AI assistance inline. Best for interactive, visual development.

**When NOT to use**: Large automated refactors, running shell commands, tasks that do not need visual review.

### GitHub Copilot (Inline Completions)

| Strength | Example |
|----------|---------|
| Boilerplate generation | Type a function name, get the body |
| Pattern completion | Write one test, Copilot writes the rest |
| Comment-to-code | Write a comment, get the implementation |
| Repetitive code | Filling in similar CRUD methods |
| Small completions | Finishing a line you started typing |

**When to use**: You are writing code line by line and want smart autocomplete. Best as a passive background assistant.

**When NOT to use**: Anything requiring reasoning about architecture, multi-file awareness, or complex logic.

### Gemini (Research and Long Context)

| Strength | Example |
|----------|---------|
| Brainstorming | "Give me 10 approaches to implement real-time sync" |
| Long document analysis | Upload a 200-page spec and ask questions |
| Research | "Compare WebSocket vs SSE vs polling for my use case" |
| Architecture planning | "Design the data model for a multi-tenant SaaS" |
| Learning new concepts | "Explain event sourcing like I am a beginner" |
| Code review discussion | Paste code and discuss tradeoffs |

**When to use**: You need to think, plan, or research before building. Gemini's large context window handles massive inputs.

**When NOT to use**: Writing production code, making file changes, running commands.

---

## Decision Tree

```
What do I need to do?

THINK / PLAN / RESEARCH
  → Use Gemini (brainstorm, architecture, research)
  → Use Claude chat (complex reasoning, strategy)

BUILD / CODE / EXECUTE
  How many files?
    1 file, small change → Cursor (Cmd+K) or Copilot
    1 file, complex logic → Cursor (Chat) or Claude Code
    3+ files → Claude Code
    10+ files refactor → Claude Code

EXPLORE / UNDERSTAND
  → Cursor (Chat with codebase)
  → Gemini (paste code, ask questions)

WRITE BOILERPLATE
  → Copilot (inline completions)
  → Claude Code (generate entire module)

DEBUG
  → Cursor (visual, interactive debugging)
  → Claude Code (cross-file root cause analysis)

REVIEW
  → Claude Code ("review my staged changes")
  → Cursor (inline diff review)
```

---

## Multi-AI Workflow Patterns

### Pattern 1: Research > Spec > Build

```
Step 1: GEMINI - Research and brainstorm
  "Compare 5 approaches to implement real-time notifications.
   Consider WebSockets, SSE, polling, Mercure, and Firebase."

  Output: Comparison table with pros/cons

Step 2: CLAUDE CHAT - Create technical specification
  "Based on this research [paste Gemini output], write a
   technical spec for implementing WebSocket notifications
   in a NestJS + React app."

  Output: Detailed spec with data models, API contracts, sequence diagrams

Step 3: CLAUDE CODE - Build it
  "Implement the notification system from this spec: [paste spec]"

  Output: Working code across multiple files
```

### Pattern 2: Explore > Fix > Verify

```
Step 1: CURSOR - Explore the codebase
  Chat: "How does the payment flow work? Walk me through
   the code path from checkout button to payment confirmation."

Step 2: CURSOR or CLAUDE CODE - Fix the bug
  Small fix: Cursor Cmd+K on the file
  Cross-file fix: Claude Code with the bug description

Step 3: CLAUDE CODE - Verify
  "Run the payment tests and fix any failures"
```

### Pattern 3: Generate > Review > Refine

```
Step 1: CLAUDE CODE - Generate the initial implementation
  "Build a REST API for managing invoices with CRUD endpoints"

Step 2: CURSOR - Review the generated code visually
  Read through the files, understand the structure

Step 3: CURSOR - Make targeted adjustments
  Cmd+K: "Add pagination to the list endpoint"
  Cmd+K: "Add input validation to the create endpoint"
```

---

## Context Window Management

AI tools have a limited context window. What you include in your prompts matters.

### What to Include

| Include | Why |
|---------|-----|
| Relevant file contents | The AI needs to see the code it is modifying |
| Error messages (full) | Partial errors lead to wrong fixes |
| Data models / schemas | The AI needs to understand your data structure |
| The specific task | Be clear about what you want done |

### What to Summarize or Omit

| Omit / Summarize | Why |
|------------------|-----|
| Unrelated files | Wastes tokens, confuses the AI |
| Entire codebase | Too large, include only relevant parts |
| Long conversation history | Start fresh when switching topics |
| Package lock files | Huge, irrelevant to most tasks |

### Tips

- Start new conversations when switching to a new task
- If an AI is struggling, the context is probably wrong -- rephrase, do not repeat
- For Claude Code, let it search your codebase rather than pasting everything manually
- For Cursor, use @file and @folder references to point at specific code

---

## Prompt Engineering Tips Per Tool

### Claude Code

```
GOOD: "In the auth module, add rate limiting to the login endpoint.
       Limit to 5 attempts per IP per 15 minutes. Use the existing
       Redis connection from CacheModule."

BAD:  "Add rate limiting"
```

- Be specific about files, modules, and existing infrastructure
- Mention constraints ("use the existing X", "do not modify Y")
- Let it search your codebase -- do not paste code unless needed

### Cursor

```
GOOD (Cmd+K): "Refactor this function to use early returns
               instead of nested if/else"

GOOD (Chat):  "Explain how @src/auth/jwt.strategy.ts validates
               tokens and where it could fail"
```

- Use @file references to point at code
- For Cmd+K, select the exact code you want changed
- Use Chat for understanding, Cmd+K for editing

### Copilot

```
GOOD: Write a descriptive function name and let Copilot complete it
      function calculateMonthlyRecurringRevenue(subscriptions: Subscription[]): number {
      // Copilot will likely complete this correctly

GOOD: Write a comment describing what you want
      // Filter active subscriptions and sum their monthly amounts
      // Copilot completes the implementation
```

- Write clear function names and comments -- Copilot uses them as context
- Accept suggestions with Tab, reject with Esc
- Write one example, Copilot will generate the pattern for the rest

### Gemini

```
GOOD: "I am building a multi-tenant SaaS with NestJS and PostgreSQL.
       Compare row-level security vs schema-per-tenant vs
       shared-schema-with-tenant-id. My expected scale is 50 tenants
       with 10K users each. I need strong data isolation."
```

- Provide full context -- Gemini handles long inputs well
- Ask for comparisons, tradeoffs, and recommendations
- Use it for decisions before writing code, not for writing code itself

---

## Cost Optimization Across Tools

| Tool | Cost Model | Optimization |
|------|-----------|-------------|
| Claude Code | Per-token (Opus or Sonnet) | Use Sonnet for routine tasks, Opus for complex reasoning |
| Cursor | $20/month subscription | Worth it if you code daily, cancel if not |
| Copilot | $10/month (individual) | Cheapest AI tool, good passive value |
| Gemini | Free tier available | Use free tier for brainstorming, pay for API use |
| Claude Chat | Per-token or $20/month Pro | Pro plan is better value for frequent use |

### Monthly Budget Guide

| Usage Level | Recommended Setup | Monthly Cost |
|-------------|-------------------|-------------|
| **Hobby** | Copilot + Gemini Free | $10 |
| **Solo dev** | Claude Code + Cursor + Gemini Free | $40-60 |
| **Professional** | All four tools | $50-80 |
| **Team** | Claude Code + Cursor (per seat) + Copilot (per seat) | $50-80/person |

---

## MCP Servers and Tool Extensions

MCP (Model Context Protocol) lets AI tools connect to external services and data sources.

### What MCP Does

```
Without MCP:  Copy data from Notion → Paste into Claude → Ask question
With MCP:     Claude reads Notion directly → Answers in context
```

### Common MCP Integrations

| MCP Server | What It Does |
|------------|-------------|
| Filesystem | Read/write files beyond the working directory |
| GitHub | Read issues, PRs, repo contents |
| Notion | Search and read Notion pages |
| Postgres | Query your database directly |
| Slack | Read channels and messages |
| Browser | Fetch and read web pages |

### Setting Up MCP (Claude Code)

MCP servers are configured in your Claude Code settings. Once connected, Claude Code can use them as tools during your session.

```json
// Example: .claude/settings.json MCP config
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@anthropic/claude-mcp-notion"],
      "env": { "NOTION_API_KEY": "your-key" }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/claude-mcp-postgres"],
      "env": { "DATABASE_URL": "your-connection-string" }
    }
  }
}
```

> Only connect MCP servers you trust. They give the AI direct access to external systems.

---

## Skill Complete When

- [ ] Each AI tool's sweet spot is understood (when to use, when not to)
- [ ] Decision tree used to pick the right tool for each task
- [ ] At least one multi-AI workflow pattern adopted (research > spec > build)
- [ ] Context window management practiced (include relevant, omit noise)
- [ ] Prompt style adjusted per tool (specific for Claude Code, visual for Cursor)
- [ ] Monthly AI cost tracked and within budget
- [ ] MCP servers configured for frequently accessed data sources

*Skill Version: 1.0 | Created: February 2026*
