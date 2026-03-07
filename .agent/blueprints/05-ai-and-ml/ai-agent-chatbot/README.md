# Blueprint: AI Agent / Chatbot

Building conversational AI agents and chatbots powered by LLMs with tool use, persistent memory, multi-turn dialogue, and structured output.

## Recommended Tech Stacks

| Stack | Best For |
|-------|----------|
| LangChain + OpenAI/Anthropic | Rapid prototyping, complex chains, broad ecosystem |
| Vercel AI SDK + Next.js | Full-stack chat UIs with streaming, React Server Components |
| Claude Code SDK / Anthropic SDK | Tool-use-heavy agents, agentic coding, computer use |
| AutoGen / CrewAI | Multi-agent collaboration, role-based agent teams |
| Custom (direct API) | Maximum control, minimal dependencies, production optimization |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define agent persona, capabilities, tool access, guardrails
- **prd_generator** -- Document conversation flows, user intents, edge cases
- **competitive_analysis** -- Evaluate existing solutions (ChatGPT, custom agents, Dialogflow)
- **prioritization_frameworks** -- Rank capabilities for MVP (core chat vs tools vs memory)

### Phase 2: Architecture
- **api_design** -- Define chat API contract (streaming vs batch, message format)
- **schema_design** -- Conversation storage, user sessions, memory schema
- **auth_architecture** -- User authentication, API key management, rate limiting

Key architecture decisions:
- **Stateless vs stateful**: Stateless (pass full history each call) is simpler but hits context limits. Stateful (server-side session with summarization) scales better.
- **Tool execution model**: Sequential (agent decides one tool at a time) vs parallel (agent batches tool calls). Parallel is faster but harder to debug.
- **Memory tiers**: Short-term (conversation buffer), medium-term (session summary), long-term (vector store retrieval). Decide which tiers you need upfront.

### Phase 3: Implementation
- **tdd_workflow** -- Test tool calling, response parsing, edge cases
- **error_handling** -- Graceful degradation when LLM fails, tool errors, context overflow
- **validation_patterns** -- Input sanitization, output validation, structured output parsing

### Phase 4: Testing and Security
- **security_audit** -- Prompt injection defense, tool access control, PII handling
- **integration_testing** -- End-to-end conversation flows, tool call verification
- **load_testing** -- Concurrent session handling, LLM API rate limits

### Phase 5: Deployment
- **ci_cd_pipeline** -- Model version pinning, A/B testing different prompts
- **monitoring_setup** -- Token usage, latency percentiles, conversation quality metrics
- **deployment_patterns** -- WebSocket for streaming, queue-based for async tools

## Key Domain-Specific Concerns

### Prompt Engineering
- System prompts should be version-controlled and tested like code
- Use structured output (JSON mode, tool_use) over free-text parsing
- Keep system prompts focused -- split complex behaviors into separate tools
- Test prompts against adversarial inputs before shipping

### Tool Use / Function Calling
- Define tools with precise descriptions and parameter schemas
- Validate tool inputs before execution -- the LLM can hallucinate parameters
- Implement timeouts and circuit breakers for external tool calls
- Log every tool call and result for debugging and audit trails

### Memory and Context Management
- Implement sliding window + summarization for long conversations
- Use vector similarity search for retrieving relevant past interactions
- Store conversation history in a database, not just in-memory
- Set hard limits on context window usage -- leave room for the response

### Guardrails and Safety
- Content filtering on both input and output
- Tool access scoping -- limit which tools each user role can trigger
- Rate limit per user to prevent abuse
- Never expose raw LLM errors to end users

### Streaming
- Use Server-Sent Events (SSE) or WebSocket for real-time token streaming
- Handle partial tool calls in streaming mode (buffer until complete)
- Implement client-side markdown rendering for streamed content
- Add typing indicators and cancellation support

## Getting Started

1. **Define the agent's purpose** -- What does it do? What tools does it need?
2. **Choose an LLM provider** -- Claude for tool use, GPT-4 for broad tasks, open-source for cost
3. **Design the message schema** -- `{ role, content, tool_calls, tool_results }`
4. **Build the conversation loop** -- User message -> LLM -> (optional tool calls) -> response
5. **Add tool definitions** -- Start with 2-3 core tools, expand after validation
6. **Implement memory** -- Session storage, conversation summarization
7. **Add streaming** -- SSE endpoint for real-time responses
8. **Build the UI** -- Chat interface with message history, tool call visibility
9. **Add guardrails** -- Input validation, output filtering, rate limiting
10. **Deploy with monitoring** -- Token usage dashboards, error tracking, conversation analytics

## Project Structure

```
src/
  agent/
    agent.ts              # Core agent loop
    tools/                # Tool definitions and handlers
      search.ts
      calculator.ts
      [tool].ts
    memory/
      conversation.ts     # Short-term buffer
      summary.ts          # Summarization logic
      vector-store.ts     # Long-term retrieval
    prompts/
      system.md           # System prompt (version controlled)
      templates/          # Dynamic prompt templates
  api/
    routes/
      chat.ts             # POST /chat (batch)
      stream.ts           # GET /chat/stream (SSE)
    middleware/
      auth.ts
      rate-limit.ts
  db/
    schema.prisma         # Conversations, messages, sessions
    migrations/
  ui/
    components/
      ChatWindow.tsx
      MessageBubble.tsx
      ToolCallCard.tsx
```
