---
name: AI Conversational UX
description: Design chat interfaces, AI agent flows, tool approval UX, streaming responses, error handling, and trust patterns for AI-powered products
---

# AI Conversational UX

**Purpose**: Design and build AI-powered conversational interfaces that feel responsive, trustworthy, and useful — covering chat UX, agent task flows, tool/action approval patterns, streaming display, error handling, and transparency mechanics.

---

## TRIGGER COMMANDS

```text
"Design the chat interface for [AI product]"
"Build an AI agent UI with tool approval"
"Make the AI responses feel more responsive"
"Add transparency and trust to our AI features"
"Design the conversation flow for [AI assistant]"
"Using ai_conversational_ux skill: [target]"
```

---

## WHEN TO USE

- Building a chat-based AI product (chatbot, copilot, assistant)
- Adding AI features to an existing product (AI search, AI writing, AI analysis)
- Designing agent workflows where AI takes actions on behalf of users
- Improving the perceived responsiveness of AI features
- Adding trust and transparency to AI-generated content

---

## 1. CHAT INTERFACE PATTERNS

### Message Types

| Type | Visual Treatment | Example |
|---|---|---|
| **User message** | Right-aligned, filled bubble (brand color) | "Summarize this document" |
| **AI message** | Left-aligned, light/outlined bubble | Markdown-rendered response |
| **System message** | Centered, muted text, no bubble | "Conversation started", "Context updated" |
| **Error message** | Left-aligned, red/warning accent | "Couldn't generate response. Try again." |
| **Tool result** | Collapsible card within AI message | Search results, code execution output |
| **Action card** | Interactive card with buttons | "I can update the database. Approve?" |

### Chat Layout Rules
- **Input at bottom**, conversation scrolls up (standard messaging pattern)
- **Auto-scroll to latest message** unless user has scrolled up to read history
- **"Scroll to bottom" button** appears when user is scrolled up and new messages arrive
- **Max message width**: 70-80% of container (not full width — improves readability)
- **Minimum input height**: 48px, expandable to 120px for multi-line
- **Send button**: visible and enabled only when input is non-empty

### Input Area Design
```
[ ] Multi-line expandable textarea (not single-line input)
[ ] Send with Enter (Shift+Enter for newline) — configurable
[ ] File/image upload button if supported
[ ] Character/token count if relevant
[ ] Suggested prompts or quick actions near input
[ ] "Stop generating" button visible during AI response
[ ] Disabled state with loading indicator during generation
```

### Rich Response Rendering
- **Code blocks**: syntax highlighted with copy button and language label
- **Tables**: formatted, scrollable on mobile
- **Lists**: properly formatted bullets/numbers
- **Links**: clickable with preview where possible
- **Images**: rendered inline with lightbox on click
- **Math**: rendered with KaTeX/MathJax if relevant
- **Citations**: numbered references with hover preview or click-to-expand

---

## 2. AI AGENT FLOW DESIGN

### Task Lifecycle

```
User Request → AI Plans → [User Approves Plan] → AI Executes → [Progress Updates] → AI Reports Results → [User Reviews]
```

### Progress Visibility Patterns

| Pattern | Use When | Implementation |
|---|---|---|
| **Step list** | Known steps, sequential | Checklist with current step highlighted |
| **Progress bar** | Estimated completion known | Determinate progress bar |
| **Activity log** | Complex multi-step, unknown duration | Streaming log of actions taken |
| **Status badge** | Background task | "Running", "Completed", "Failed" badge |

### Multi-Step Task UI
```
[ ] Show the plan before execution ("I'll do X, then Y, then Z")
[ ] Allow user to modify/approve the plan
[ ] Show which step is currently executing
[ ] Allow cancellation at any point
[ ] Show intermediate results (don't wait until everything is done)
[ ] Handle partial completion gracefully ("3 of 5 tasks completed")
[ ] Provide retry option for failed steps (not whole task)
```

### Agent Handoff Patterns
- **AI → Human**: "I'm not confident about this. Here's what I found — you decide."
- **Human → AI**: User delegates task with clear scope and constraints
- **AI → AI**: Multi-agent workflows (show which agent is working, not implementation details)

---

## 3. TOOL & ACTION APPROVAL UX

When AI agents take actions (modify data, send messages, make API calls), users need control.

### Trust Levels

| Level | User Experience | Example Actions |
|---|---|---|
| **Auto-execute** | AI acts silently, results shown | Read data, search, calculate |
| **Notify** | AI acts, then notifies user | Save draft, organize files |
| **Confirm** | AI proposes, user approves before execution | Send email, modify database |
| **Manual** | AI suggests, user must perform the action | Delete account, financial transaction |

### Approval UI Design
```
┌─────────────────────────────────────────┐
│ 🔧 AI wants to: Update customer record  │
│                                          │
│ Changes:                                 │
│ • Email: old@mail.com → new@mail.com    │
│ • Status: Active → Premium              │
│                                          │
│ [Show Details ▼]                         │
│                                          │
│      [Deny]              [Approve ✓]     │
└─────────────────────────────────────────┘
```

### Approval UX Rules
- **Show what will happen** before asking for approval (diff view for data changes)
- **Approve/Deny buttons** must be visually distinct (not two similar buttons)
- **Undo window** after approval (5-10 seconds) for reversible actions
- **Batch approvals** for repetitive similar actions ("Approve all 5 similar changes?")
- **Default deny** for destructive actions (user must actively approve)
- **Never auto-approve** actions that modify user data or send communications

---

## 4. STREAMING & LOADING UX

### Streaming Text Display
- **Token-by-token rendering** — show text as it's generated
- **Smooth scrolling** — auto-scroll as text appears, not in jumps
- **Cursor/caret** — blinking cursor at generation point (optional, adds "typing" feel)
- **Markdown rendering** — render markdown progressively (tricky: render complete blocks, buffer incomplete ones)

### Loading State Patterns

| Duration | Pattern | Example |
|---|---|---|
| **<500ms** | No indicator | Instant-feeling responses |
| **500ms-2s** | Typing indicator (dots) | Simple completions |
| **2s-10s** | Skeleton + "Thinking..." | Complex generation |
| **10s-30s** | Progress step list | Multi-step agent tasks |
| **>30s** | Background task + notification | Large batch operations |

### Typing Indicator Rules
- Show within 200ms of user sending message (immediate feedback)
- Animate: three-dot bounce or pulsing ellipsis
- Replace with actual content as streaming begins
- If generation takes >10s, upgrade to "Still working on this..." message

### Stop Generation
```
[ ] "Stop" button visible throughout AI generation
[ ] Clicking stop immediately halts generation
[ ] Partial response is preserved (not discarded)
[ ] User can regenerate after stopping
[ ] Stop button replaces Send button during generation
```

---

## 5. ERROR & FALLBACK HANDLING

### Error Types & Responses

| Error | User-Facing Message | Action |
|---|---|---|
| **Rate limited** | "I'm getting a lot of requests. Trying again in a moment..." | Auto-retry with backoff |
| **Context too long** | "This conversation is getting long. Starting fresh will help." | Offer to start new thread |
| **API timeout** | "Took too long to respond. Want me to try again?" | Retry button |
| **Model error** | "Something went wrong on my end. Trying again..." | Auto-retry once, then retry button |
| **Content filter** | "I can't help with that specific request. Can you rephrase?" | Suggest alternative phrasing |
| **Network error** | "Lost connection. Your message is saved — I'll send when reconnected." | Queue and retry |

### Graceful Degradation
```
Primary model unavailable → Fallback to secondary model → Show "limited mode" indicator
Streaming fails mid-response → Preserve partial response + retry button
Tool execution fails → Show what succeeded, offer retry for what failed
Context window exceeded → Summarize earlier conversation, continue
```

### Error UX Rules
- **Never show raw error codes** to users (500, 429, etc.)
- **Never blame the user** ("You sent too many requests" → "Getting a lot of requests right now")
- **Auto-retry once** silently for transient errors (network, timeout)
- **Preserve user input** — never lose what the user typed on error
- **Offer alternatives** — "Can't do X, but I can do Y"

---

## 6. TRANSPARENCY & TRUST

### AI Disclosure
- **Label AI-generated content** clearly: "AI-generated", not trying to pass as human
- **Show confidence** when relevant: "I'm fairly confident" vs "I'm not sure about this"
- **Cite sources** when making factual claims (numbered references, expandable)
- **Admit limitations** proactively: "I don't have access to real-time data for this"

### Trust-Building Patterns

| Pattern | Implementation |
|---|---|
| **Source attribution** | "[1] Based on docs.example.com" with link |
| **Confidence indicator** | Subtle indicator for high/medium/low confidence |
| **Reasoning visibility** | "Show reasoning" expandable section |
| **Edit AI output** | User can edit AI-generated content before using it |
| **Feedback mechanism** | Thumbs up/down on every AI response |
| **Version transparency** | "Powered by [model name]" in settings or footer |

### What NOT to Do
- Don't pretend AI is human (no fake "typing slowly to seem human")
- Don't hide that content is AI-generated
- Don't present uncertain information as definitive
- Don't use AI-generated content without user review for external-facing actions
- Don't collect conversation data without clear consent and purpose

### Checklist
```
[ ] AI-generated content clearly labeled
[ ] Sources cited for factual claims
[ ] Confidence level communicated when relevant
[ ] User can provide feedback on every AI response
[ ] "Show reasoning" option for complex outputs
[ ] User can edit AI output before it's used/shared
[ ] Privacy policy covers AI data usage
[ ] Model/version information accessible
```

---

## 7. CONVERSATION MANAGEMENT

### Thread & History
- **Conversation list** — sidebar or dedicated page showing past conversations
- **Thread titles** — auto-generated from first message, editable by user
- **Search history** — search across past conversations
- **Delete conversations** — user controls their data
- **Export** — download conversation as text/markdown/PDF

### Context Management
- **Context indicator** — show how much context the AI has ("remembers last 50 messages")
- **"New conversation" button** prominently placed
- **Pin/bookmark** important messages within a conversation
- **Branch conversations** — fork from any message to explore a different direction (advanced)

### Multi-Turn Patterns
```
[ ] Conversation persists across page refreshes (saved to backend)
[ ] User can scroll back through full history
[ ] AI maintains context of previous messages in the thread
[ ] "New conversation" starts fresh context
[ ] Long conversations show "context limit" warning before it becomes an issue
[ ] Previous conversations loadable from history
```

---

## 8. ACCESSIBILITY IN AI UX

### Screen Reader Support
- **aria-live="polite"** on the message container for new messages
- **aria-label** on send button, stop button, and all action buttons
- **Role="log"** on the conversation container
- **Announce streaming completion** — "Response complete" after generation finishes
- **Code blocks** should be navigable and have "Copy code" button accessible

### Keyboard Navigation
```
[ ] Tab navigates: input → send → message actions → conversation list
[ ] Enter sends message (Shift+Enter for newline)
[ ] Escape stops generation (same as clicking Stop)
[ ] Arrow keys navigate conversation history (in read mode)
[ ] Focus trapped in approval dialogs until resolved
[ ] All interactive elements reachable without mouse
```

### Motion & Animation
- **Respect prefers-reduced-motion** — disable streaming animation, typing indicators
- **Alternative to animation** — show complete messages instead of streaming for users who need it
- **No auto-playing media** in AI responses without user action

---

## EXIT CRITERIA

```
[ ] Chat interface follows standard messaging patterns (input bottom, messages scroll up)
[ ] Message types visually distinct (user, AI, system, error, tool result)
[ ] Rich responses render properly (code blocks, tables, lists, citations)
[ ] Agent tasks show plan → approval → progress → results flow
[ ] Tool/action approval shows what will happen before user approves
[ ] Streaming text renders smoothly with stop generation button
[ ] Loading states appropriate for expected duration
[ ] Errors are user-friendly with auto-retry and recovery options
[ ] AI content labeled, sources cited, confidence communicated
[ ] Conversation history persists and is searchable
[ ] Screen reader: aria-live on messages, keyboard navigable
[ ] Reduced motion preference respected
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: AI product design patterns + conversational UX research*
