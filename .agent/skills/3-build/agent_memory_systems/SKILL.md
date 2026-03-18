---
name: "Agent Memory Systems"
description: "Persistent memory for AI agents — short-term, long-term, episodic, and semantic memory with Mem0, Zep, and custom stores"
triggers:
  - "/agent-memory"
  - "/memory-systems"
  - "/persistent-memory"
---

# Agent Memory Systems

## WHEN TO USE
- Agents that need to remember across sessions (not just within one conversation)
- Building long-term knowledge stores for AI agents
- Implementing shared memory between multiple agents
- Managing context window limits with memory retrieval

## PROCESS

### 1. Memory Architecture (4 Types)
| Type | Purpose | Storage | Retrieval |
|------|---------|---------|-----------|
| **Working** | Current task context | In-memory / context window | Direct |
| **Episodic** | Past events and interactions | Event log (Postgres, Redis Streams) | Time-based, filtered |
| **Semantic** | Learned facts and knowledge | Vector store (pgvector, Pinecone, Qdrant) | Similarity search |
| **Procedural** | How to do things | Skill files, prompt templates | Pattern match |

### 2. Memory Providers
| Provider | Type | Best For |
|----------|------|----------|
| Mem0 | All-in-one memory layer | Quick integration, managed memory |
| Zep | Long-term conversation memory | Chat-heavy agents, session continuity |
| LangGraph Checkpointers | Workflow state persistence | Multi-step agent workflows |
| Custom Postgres + pgvector | Full control semantic memory | Production systems, cost control |
| Redis | Working memory + cache | Fast access, TTL-based expiry |

### 3. Memory Write Strategy
- **Auto-extract**: After each agent turn, extract key facts and store
- **Selective**: Only store when explicitly marked as important
- **Summarize**: Periodically compress old memories into summaries
- **Conflict resolution**: When new memory contradicts old, keep both with timestamps

### 4. Memory Retrieval Strategy
- **Recency-weighted**: Recent memories ranked higher
- **Relevance-weighted**: Semantic similarity to current query
- **Hybrid**: Combine recency + relevance scores
- **Scoped**: Filter by agent role, project, time range before searching

### 5. Memory Compaction
Context windows are finite. Manage growth:
- Summarize conversations older than N turns
- Archive episodic memories older than N days
- Deduplicate semantic memories with cosine similarity threshold
- Set hard limits: max N memories per retrieval, max N tokens per memory

### 6. Shared Memory Between Agents
- Central memory store accessible by all agents in fleet
- Write permissions: which agents can write to shared memory?
- Read permissions: which agents can see which memories?
- Conflict: two agents write contradicting facts — timestamp wins, flag for human review

### 7. Memory Evaluation
- Retrieval accuracy: does the right memory come back for the query?
- Staleness: are outdated memories being served?
- Coverage: what percentage of relevant context is captured?
- Cost: storage cost, retrieval latency, embedding cost

## CHECKLIST
- [ ] Memory types identified (which of the 4 does this agent need?)
- [ ] Provider selected and configured
- [ ] Write strategy defined (auto-extract, selective, or summarize)
- [ ] Retrieval strategy defined (recency, relevance, or hybrid)
- [ ] Compaction policy set (summarize, archive, deduplicate)
- [ ] Shared memory access controls defined (if multi-agent)
- [ ] Memory evaluation metrics tracked
- [ ] Backup strategy for memory stores

## Related Skills
- [`ai_agent_development`](../ai_agent_development/SKILL.md)
- [`vector_database_operations`](../vector_database_operations/SKILL.md)
- [`rag_advanced_patterns`](../rag_advanced_patterns/SKILL.md)
