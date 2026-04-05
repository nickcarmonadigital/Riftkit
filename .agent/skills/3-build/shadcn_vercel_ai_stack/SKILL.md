---
name: shadcn + Vercel AI Stack
description: The definitive guide to building with shadcn/ui, Vercel AI SDK 6, AI Elements, and v0 — the core stack for modern AI-native web applications
---

# shadcn + Vercel AI Stack

**Purpose**: Build production-grade, AI-native web applications using the shadcn/ui + Vercel AI SDK + AI Elements ecosystem. This is the primary UI/UX stack — everything else is secondary.

---

## TRIGGER COMMANDS

```text
"Build with shadcn and AI SDK"
"Set up AI Elements for [project]"
"Create an AI chat interface"
"Use the Vercel AI stack for [feature]"
"Using shadcn_vercel_ai_stack skill: [target]"
"Add AI Elements to [project]"
```

---

## WHEN TO USE

- Building any new web application (AI-native or not)
- Adding AI chat, completion, or object streaming to an app
- Need production-ready UI components with full ownership
- Building with Next.js + Tailwind CSS
- Want to generate components with v0 and own the code

---

## THE STACK

```
┌─────────────────────────────────────────────────┐
│  v0.app          — AI-powered component generation │
│  AI Elements     — Pre-built AI UI components       │
│  shadcn/ui       — Core component library (you own it) │
│  Radix UI / Base UI — Accessible headless primitives │
│  Tailwind CSS    — Utility-first styling            │
│  AI SDK 6        — Hooks: useChat, useCompletion, useObject │
│  Next.js         — React framework (SSR/SSG/API)    │
└─────────────────────────────────────────────────┘
```

---

## LAYER 1: shadcn/ui (Foundation)

### What It Is
Copy-paste component library built on Radix UI + Tailwind CSS. You **own the code** — no dependency lock-in. 104K+ GitHub stars, 560K+ weekly npm downloads.

### 2026 State (CLI v4)
- **Dual primitives**: Choose Radix UI or Base UI per project (`--base` flag)
- **1,300+ blocks**: Pre-designed accessible blocks (dashboards, forms, login, etc.)
- **Registry directory**: Community registries built into CLI
- **shadcn/skills**: Agent-aware context for AI coding assistants
- **Preset system**: `--preset` flag to pack/share design system configs
- **RTL support**: First-class right-to-left language support
- **Template scaffolding**: Next.js, Vite, Laravel, React Router, Astro, TanStack Start

### Setup
```bash
# Initialize shadcn/ui in your project
npx shadcn@latest init

# Add specific components
npx shadcn@latest add button card dialog input

# Add a block (pre-designed page section)
npx shadcn@latest add login-01

# Use Base UI instead of Radix
npx shadcn@latest init --base base

# Switch with a preset
npx shadcn@latest init --preset my-design-system

# Inspect what's installed
npx shadcn info
```

### Key Components
```
Layout:      card, separator, aspect-ratio, resizable, scroll-area
Navigation:  navigation-menu, tabs, breadcrumb, sidebar, pagination
Forms:       input, textarea, select, checkbox, radio-group, switch, slider, date-picker
Feedback:    alert, toast (sonner), progress, skeleton, badge
Overlay:     dialog, sheet, drawer (vaul), popover, tooltip, hover-card
Data:        table, data-table (TanStack), command (cmdk), combobox
Typography:  All via Tailwind prose classes
```

### Blocks (Pre-Built Page Sections)
```
Authentication:  login-01 through login-05, signup variants
Dashboards:      dashboard-01 through dashboard-07
Sidebars:        sidebar-01 through sidebar-15
Charts:          chart-area, chart-bar, chart-line, chart-pie, chart-radar
Forms:           Multi-step forms, settings pages
```

### Customization
Components install to `@/components/ui/` — edit them directly:
```
src/
  components/
    ui/
      button.tsx        ← full source, edit freely
      card.tsx
      dialog.tsx
      ...
```

### Theming
CSS variables in `globals.css`:
```css
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    --primary: 240 5.9% 10%;
    --primary-foreground: 0 0% 98%;
    --secondary: 240 4.8% 95.9%;
    --accent: 240 4.8% 95.9%;
    --destructive: 0 84.2% 60.2%;
    --ring: 240 5.9% 10%;
    --radius: 0.5rem;
  }
  .dark {
    --background: 240 10% 3.9%;
    --foreground: 0 0% 98%;
    /* ... dark variants */
  }
}
```

---

## LAYER 2: Vercel AI SDK 6 (Intelligence)

### What It Is
The standard for building AI-powered applications in TypeScript/React. 20M+ monthly downloads. Model-provider agnostic — works with OpenAI, Anthropic, Google, Ollama, and 50+ providers.

### Core Hooks

**useChat** — Conversational interfaces
```tsx
import { useChat } from "@ai-sdk/react";

export function ChatInterface() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat({
    api: "/api/chat",
  });

  return (
    <div>
      {messages.map((m) => (
        <div key={m.id} className={m.role === "user" ? "text-right" : "text-left"}>
          {m.content}
        </div>
      ))}
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={handleInputChange} />
        <button type="submit" disabled={isLoading}>Send</button>
      </form>
    </div>
  );
}
```

**useCompletion** — Single-turn text completions
```tsx
import { useCompletion } from "@ai-sdk/react";

export function CompletionUI() {
  const { completion, input, handleInputChange, handleSubmit } = useCompletion({
    api: "/api/completion",
  });

  return (
    <div>
      <p>{completion}</p>
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={handleInputChange} />
      </form>
    </div>
  );
}
```

**useObject** — Streaming structured JSON objects
```tsx
import { useObject } from "@ai-sdk/react";
import { z } from "zod";

const recipeSchema = z.object({
  name: z.string(),
  ingredients: z.array(z.string()),
  steps: z.array(z.string()),
});

export function RecipeGenerator() {
  const { object, submit } = useObject({
    api: "/api/recipe",
    schema: recipeSchema,
  });

  return (
    <div>
      <button onClick={() => submit("pasta carbonara")}>Generate</button>
      {object && (
        <div>
          <h2>{object.name}</h2>
          <ul>{object.ingredients?.map((i) => <li key={i}>{i}</li>)}</ul>
        </div>
      )}
    </div>
  );
}
```

### AI SDK 6 New Capabilities

**Agents** — Reusable agent abstraction
```tsx
import { ToolLoopAgent } from "ai";

const agent = new ToolLoopAgent({
  model: anthropic("claude-sonnet-4-20250514"),
  tools: { searchWeb, queryDatabase },
  maxSteps: 20,
});

const result = await agent.call({
  prompt: "Find the top 3 competitors and summarize their pricing",
});
```

**Tool Execution Approval** — Human-in-the-loop
```tsx
const tools = {
  deleteUser: tool({
    description: "Delete a user account",
    parameters: z.object({ userId: z.string() }),
    needsApproval: true, // Requires user confirmation
    execute: async ({ userId }) => { /* ... */ },
  }),
};
```

**Structured Output with Tools** — Multi-step tool loops ending in structured data
```tsx
const result = await generateText({
  model: anthropic("claude-sonnet-4-20250514"),
  tools: { searchWeb },
  output: Output.object({ schema: analysisSchema }),
  prompt: "Analyze competitor pricing",
});
// result.output is typed to analysisSchema
```

**MCP Support** — Model Context Protocol integration with OAuth
```tsx
import { MCPClient } from "ai/mcp";

const mcpClient = new MCPClient({
  transport: httpTransport("https://mcp-server.example.com"),
  auth: { /* OAuth config */ },
});
```

**DevTools** — Debug LLM calls and agent steps
```bash
npx @ai-sdk/devtools
```

### Server-Side API Routes
```tsx
// app/api/chat/route.ts
import { streamText } from "ai";
import { anthropic } from "@ai-sdk/anthropic";

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: anthropic("claude-sonnet-4-20250514"),
    messages,
  });

  return result.toDataStreamResponse();
}
```

---

## LAYER 3: AI Elements (AI-Native UI)

### What It Is
20+ production-ready React components specifically for AI interfaces. Built on shadcn/ui. Replaces the old ChatSDK. Full ownership — components install into your codebase.

### Setup
```bash
# Install all AI Elements
npx ai-elements@latest

# Install specific components
npx ai-elements@latest add conversation
npx ai-elements@latest add message
npx ai-elements@latest add prompt-input

# Or via shadcn CLI
npx shadcn@latest add https://elements.ai-sdk.dev/api/registry/all.json
```

Components install to `@/components/ai-elements/`.

### Core Components

**Conversation** — Container for chat interfaces
```tsx
import { Conversation, ConversationContent, ConversationEmptyState } from "@/components/ai-elements/conversation";

<Conversation>
  <ConversationContent>
    {messages.length === 0 ? (
      <ConversationEmptyState>Start a conversation</ConversationEmptyState>
    ) : (
      messages.map((msg) => /* render messages */)
    )}
  </ConversationContent>
</Conversation>
```

**Message** — Individual message display with streaming support
```tsx
import { Message, MessageContent, MessageResponse } from "@/components/ai-elements/message";

<Message from={message.role}>
  <MessageContent>
    <MessageResponse>{message.content}</MessageResponse>
  </MessageContent>
</Message>
```

**PromptInput** — AI-aware input with submit handling
```tsx
import { PromptInput, PromptInputTextarea, PromptInputSubmit } from "@/components/ai-elements/prompt-input";

<PromptInput onSubmit={handleSubmit}>
  <PromptInputTextarea value={input} onChange={handleInputChange} />
  <PromptInputSubmit />
</PromptInput>
```

**Code Block** — Syntax-highlighted code with copy
```tsx
import { CodeBlock } from "@/components/ai-elements/code-block";

<CodeBlock language="typescript" code={codeString} />
```

**Reasoning** — Expandable reasoning/thinking display
```tsx
import { Reasoning } from "@/components/ai-elements/reasoning";

<Reasoning content={reasoningText} />
```

### Full Integration Example
```tsx
"use client";

import { useChat } from "@ai-sdk/react";
import {
  Conversation,
  ConversationContent,
  ConversationEmptyState,
} from "@/components/ai-elements/conversation";
import { Message, MessageContent, MessageResponse } from "@/components/ai-elements/message";
import {
  PromptInput,
  PromptInputTextarea,
  PromptInputSubmit,
} from "@/components/ai-elements/prompt-input";

export default function Chat() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat();

  return (
    <Conversation>
      <ConversationContent>
        {messages.length === 0 ? (
          <ConversationEmptyState>
            Ask me anything to get started.
          </ConversationEmptyState>
        ) : (
          messages.map((message) => (
            <Message key={message.id} from={message.role}>
              <MessageContent>
                <MessageResponse>{message.content}</MessageResponse>
              </MessageContent>
            </Message>
          ))
        )}
      </ConversationContent>
      <PromptInput onSubmit={handleSubmit}>
        <PromptInputTextarea
          value={input}
          onChange={handleInputChange}
          placeholder="Type a message..."
        />
        <PromptInputSubmit disabled={isLoading} />
      </PromptInput>
    </Conversation>
  );
}
```

---

## LAYER 4: v0 (AI Component Generation)

### What It Is
AI agent by Vercel that generates production-ready React code using Next.js + Tailwind CSS + shadcn/ui. Located at v0.app.

### Workflow
1. Describe what you want in natural language
2. v0 generates working React components with shadcn/ui
3. Copy into your project — code is yours
4. Customize as needed

### Key Capabilities (2026)
- **Natural language → code**: Describe UI, get React + Tailwind + shadcn
- **Wireframe → code**: Upload mockups/wireframes, get working components
- **Design system support**: Custom registries for consistent component generation
- **Git integration**: Direct push/PR to repos
- **VS Code-style editor**: Built-in code editor with preview
- **Database connectivity**: Connect to data sources
- **Agentic workflows**: Multi-step autonomous building
- **Error self-repair**: Auto-diagnoses and fixes code errors

### Using v0 with shadcn
Every component on ui.shadcn.com is editable in v0:
```
1. Go to ui.shadcn.com, find a component
2. Click "Open in v0"
3. Customize in natural language: "Make this button group vertical with icons"
4. Copy the result into your project
```

### Custom Design System in v0
```
1. Create a custom shadcn/ui registry
2. Register it in v0 settings
3. v0 generates components using YOUR design tokens
4. Consistent output across all generations
```

### Pricing
| Tier       | Price        | Credits              |
|------------|-------------|----------------------|
| Free       | $0          | $5 credits/month     |
| Premium    | $20/month   | Expanded credits     |
| Team       | $30/user/mo | Team collaboration   |
| Business   | $100/user/mo| Advanced features    |
| Enterprise | Custom      | Custom deployment    |

---

## PROJECT SETUP (Complete)

### 1. Initialize Next.js + shadcn
```bash
npx create-next-app@latest my-app --typescript --tailwind --eslint --app --src-dir
cd my-app
npx shadcn@latest init
```

### 2. Install AI SDK 6
```bash
pnpm add ai @ai-sdk/react @ai-sdk/anthropic
# Or for OpenAI:
# pnpm add ai @ai-sdk/react @ai-sdk/openai
```

### 3. Install AI Elements
```bash
npx ai-elements@latest
```

### 4. Add Core shadcn Components
```bash
npx shadcn@latest add button card input dialog sheet sidebar sonner
```

### 5. Set Environment Variables
```env
# .env.local
ANTHROPIC_API_KEY=sk-ant-...
# Or: OPENAI_API_KEY=sk-...
# Optional: AI_GATEWAY_API_KEY=...
```

### 6. Create API Route
```tsx
// app/api/chat/route.ts
import { streamText } from "ai";
import { anthropic } from "@ai-sdk/anthropic";

export async function POST(req: Request) {
  const { messages } = await req.json();
  const result = streamText({
    model: anthropic("claude-sonnet-4-20250514"),
    messages,
  });
  return result.toDataStreamResponse();
}
```

### 7. Build Your First AI Page
```tsx
// app/page.tsx
"use client";
import { useChat } from "@ai-sdk/react";
import { Conversation, ConversationContent } from "@/components/ai-elements/conversation";
import { Message, MessageContent, MessageResponse } from "@/components/ai-elements/message";
import { PromptInput, PromptInputTextarea, PromptInputSubmit } from "@/components/ai-elements/prompt-input";

export default function Home() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat();

  return (
    <main className="flex min-h-screen flex-col items-center p-4">
      <Conversation className="w-full max-w-2xl">
        <ConversationContent>
          {messages.map((m) => (
            <Message key={m.id} from={m.role}>
              <MessageContent>
                <MessageResponse>{m.content}</MessageResponse>
              </MessageContent>
            </Message>
          ))}
        </ConversationContent>
        <PromptInput onSubmit={handleSubmit}>
          <PromptInputTextarea value={input} onChange={handleInputChange} />
          <PromptInputSubmit disabled={isLoading} />
        </PromptInput>
      </Conversation>
    </main>
  );
}
```

---

## COMPANION LIBRARIES

These pair perfectly with the shadcn + Vercel AI stack:

| Library          | Purpose                     | Install                    |
|------------------|-----------------------------|----------------------------|
| **Lucide React** | Icons (shadcn default)      | `pnpm add lucide-react`    |
| **Sonner**       | Toast notifications         | `npx shadcn add sonner`    |
| **cmdk**         | Command palette (⌘K)        | `npx shadcn add command`   |
| **Vaul**         | Mobile drawer               | `npx shadcn add drawer`    |
| **Motion**       | Animations (Framer Motion)  | `pnpm add motion`          |
| **Zod**          | Schema validation           | `pnpm add zod`             |
| **TanStack Table** | Data tables               | `npx shadcn add data-table`|
| **TanStack Query** | Server state              | `pnpm add @tanstack/react-query` |
| **Recharts**     | Charts                      | `npx shadcn add chart`     |
| **React Hook Form** | Form management          | `pnpm add react-hook-form @hookform/resolvers` |
| **Supabase**     | Auth + Database + Realtime  | `pnpm add @supabase/supabase-js` |
| **Stripe**       | Payments                    | `pnpm add stripe @stripe/stripe-js` |
| **Resend**       | Email                       | `pnpm add resend`          |

---

## WHEN TO USE WHAT

| Need                        | Use This                                |
|-----------------------------|-----------------------------------------|
| Standard UI components      | shadcn/ui components                    |
| Pre-built page sections      | shadcn/ui blocks (login, dashboard, etc.) |
| AI chat interface            | AI Elements + useChat                   |
| Text completion UI           | AI Elements + useCompletion             |
| Streaming JSON display       | useObject + custom rendering            |
| Generate new components      | v0.app → copy into project              |
| Customize existing shadcn    | Open in v0 → edit → paste back          |
| Multi-step AI agent          | AI SDK 6 ToolLoopAgent                  |
| Tool approval flows          | AI SDK 6 needsApproval                  |
| Debug AI calls               | `npx @ai-sdk/devtools`                  |
| Code display in AI responses | AI Elements CodeBlock                   |
| Reasoning/thinking display   | AI Elements Reasoning                   |

---

## DESIGN SYSTEM SETUP

### Recommended Fonts
```
Heading: Geist Sans (Vercel's font) or Inter
Body: Geist Sans or Inter
Mono: Geist Mono or JetBrains Mono
```

### Recommended Color Approach
Use shadcn's CSS variable system:
```
1. Pick a primary hue
2. Generate shades using shadcn's theme generator (ui.shadcn.com/themes)
3. Set CSS variables in globals.css
4. All components automatically use your theme
```

### Premium Polish Additions
```
Background:     Subtle gradient or grain texture
Shadows:        Use shadcn's built-in shadow utilities
Animations:     Motion (Framer Motion) for page transitions + hover effects
Typography:     Tighten heading letter-spacing (-2%), reduce line-height (110-120%)
Dark mode:      Built into shadcn — toggle with next-themes
```

---

## COMMON PATTERNS

### Dashboard with AI Assistant
```
shadcn sidebar + shadcn data-table + AI Elements chat panel
```

### SaaS Landing Page
```
shadcn blocks (hero, features, pricing) + Motion animations + Lucide icons
```

### AI Chatbot Product
```
AI Elements (conversation + message + prompt-input) + useChat + shadcn card/dialog
```

### Internal Tool with AI
```
shadcn forms + TanStack Table + AI SDK useObject for structured generation
```

---

## EXIT CRITERIA

```
[ ] Next.js + Tailwind + shadcn/ui initialized
[ ] AI SDK 6 installed with chosen provider
[ ] AI Elements installed for AI interfaces
[ ] API route created for AI streaming
[ ] useChat/useCompletion/useObject hook integrated
[ ] shadcn theme customized (colors, fonts, radius)
[ ] Core shadcn components added (button, card, input, dialog)
[ ] Companion libraries installed as needed (icons, toasts, charts)
[ ] Dark mode working via next-themes
[ ] Components are in project codebase (not node_modules)
```

---

## SOURCES

- [Vercel AI Elements](https://github.com/vercel/ai-elements)
- [AI SDK 6 Blog](https://vercel.com/blog/ai-sdk-6)
- [AI SDK UI Docs](https://ai-sdk.dev/docs/ai-sdk-ui)
- [shadcn/ui Changelog](https://ui.shadcn.com/docs/changelog)
- [v0 Docs](https://v0.app/docs)
- [shadcn/ui Registry](https://ui.shadcn.com/docs/directory)

---

*Version: 1.0 | Created: 2026-04-05 | Source: Official Vercel, shadcn/ui, and AI SDK documentation*
