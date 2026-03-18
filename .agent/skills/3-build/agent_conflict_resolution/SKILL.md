---
name: Agent Conflict Resolution
description: Mutex/lock patterns for shared resources, optimistic concurrency, consensus protocols, deadlock detection, and conflict merge strategies for multi-agent systems
triggers:
  - /agent-conflicts
  - /conflict-resolution
  - /agent-deadlock
---

# Agent Conflict Resolution Skill

**Purpose**: Prevent and resolve conflicts when multiple AI agents compete for shared resources — files, databases, APIs, or tool calls — using mutex patterns, optimistic concurrency, consensus protocols, and merge strategies.

---

## WHEN TO USE

- Multiple agents write to the same file, database row, or API endpoint
- Agents produce contradictory outputs that need reconciliation
- Deadlocks or livelocks occur in multi-agent orchestration
- You need deterministic ordering of concurrent agent actions
- Shared state (vector stores, caches, config) is modified by parallel agents

---

## PROCESS

### 1. Identify Shared Resources

Map every resource that more than one agent touches. Classify by contention type:

| Resource Type | Contention Pattern | Recommended Strategy |
|---|---|---|
| Files on disk | Write-write conflict | File-level mutex with lockfiles |
| Database rows | Concurrent updates | Optimistic concurrency (version column) |
| API rate limits | Quota exhaustion | Token bucket with distributed counter |
| Tool calls | Duplicate invocations | Idempotency keys |
| Shared memory/state | Race conditions | Redis SETNX or advisory locks |

### 2. Implement Locking Strategy

**File-level mutex with lockfiles:**

```python
import fcntl, time, os

def acquire_lock(path, timeout=10):
    lockfile = f"{path}.lock"
    fd = open(lockfile, "w")
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            return fd
        except BlockingIOError:
            time.sleep(0.1)
    raise TimeoutError(f"Could not acquire lock on {path}")

def release_lock(fd):
    fcntl.flock(fd, fcntl.LOCK_UN)
    fd.close()
```

**Optimistic concurrency with version column:**

```sql
UPDATE agent_tasks
SET result = 'completed', version = version + 1
WHERE id = 42 AND version = 3;
-- If affected_rows == 0, another agent updated first -> retry
```

### 3. Detect and Break Deadlocks

Build a wait-for graph. If agent A holds resource 1 and waits on resource 2, while agent B holds resource 2 and waits on resource 1, a cycle exists.

```python
def detect_deadlock(wait_for: dict[str, str]) -> list[str]:
    """wait_for maps agent_id -> resource_held_by_agent_id."""
    visited, path = set(), []
    for agent in wait_for:
        if agent in visited:
            continue
        curr, chain = agent, []
        while curr and curr not in visited:
            visited.add(curr)
            chain.append(curr)
            curr = wait_for.get(curr)
        if curr in chain:
            return chain[chain.index(curr):]  # cycle
    return []
```

**Resolution**: Preempt the lowest-priority agent in the cycle and retry its task.

### 4. Merge Conflicting Outputs

When two agents produce competing results for the same task:

- **Last-write-wins**: Simplest, use timestamps. Risk: lost updates.
- **Consensus vote**: Run 3+ agents, take majority answer.
- **Supervisor arbitration**: A supervisor agent reviews both outputs and picks or merges.
- **CRDTs**: For counters or sets, use conflict-free replicated data types.

### 5. Test Conflict Scenarios

```python
import asyncio

async def simulate_conflict(agents, shared_resource):
    """Run agents concurrently against the same resource."""
    tasks = [agent.act(shared_resource) for agent in agents]
    results = await asyncio.gather(*tasks, return_exceptions=True)
    conflicts = [r for r in results if isinstance(r, Exception)]
    assert len(conflicts) == 0, f"Unhandled conflicts: {conflicts}"
```

---

## CHECKLIST

- [ ] All shared resources identified and classified by contention type
- [ ] Locking strategy implemented (mutex, optimistic concurrency, or advisory locks)
- [ ] Lock timeouts configured to prevent indefinite blocking
- [ ] Deadlock detection implemented with wait-for graph or timeout fallback
- [ ] Deadlock resolution policy defined (preempt lowest priority, retry with backoff)
- [ ] Conflict merge strategy chosen (last-write-wins, consensus, supervisor, CRDT)
- [ ] Idempotency keys used for tool calls and API mutations
- [ ] Concurrent conflict scenarios tested with 3+ simultaneous agents
- [ ] Metrics captured: lock wait time, conflict rate, deadlock frequency

---

## Related Skills

- [Agent Communication Protocols](../../3-build/ai_agent_development/SKILL.md)
- [AI Agent Development](../../3-build/ai_agent_development/SKILL.md)

---

*Skill Version: 1.0 | Created: March 2026*
