---
name: AI Agent Development
description: Build AI agents with LangChain, LangGraph, CrewAI, AutoGen, and custom frameworks including ReAct, tool use, memory, and multi-agent orchestration
---

# AI Agent Development Skill

**Purpose**: Provide comprehensive patterns for building production-grade AI agents with tool use, memory, multi-agent orchestration, and safety guardrails.

---

## TRIGGER COMMANDS

```text
"Build an AI agent"
"Set up a multi-agent system"
"Implement ReAct agent with tools"
"Design agent memory and tool use"
"Using ai_agent_development skill: [task]"
```

---

## Framework Selection Matrix

| Framework | Agent Type | Multi-Agent | Tool Calling | Memory | Streaming | Complexity |
|-----------|-----------|-------------|-------------|--------|-----------|------------|
| LangGraph | Graph-based | Yes | Native | Built-in | Yes | Medium-High |
| LangChain | Chain-based | Via LangGraph | Native | Built-in | Yes | Medium |
| CrewAI | Role-based | Yes (core) | Via tools | Shared | Limited | Low-Medium |
| AutoGen | Conversation | Yes (core) | Code exec | Chat history | Yes | Medium |
| Semantic Kernel | Plugin-based | Experimental | Plugins | Built-in | Yes | Medium |
| Custom (Python) | Any | Manual | Manual | Manual | Manual | High |

### When to Use What

```
START: What kind of agent system?
  |
  +-- Single agent with tools
  |     +-- Simple, linear workflow --> LangChain AgentExecutor
  |     +-- Complex, branching logic --> LangGraph
  |     +-- Minimal dependencies --> Custom ReAct loop
  |
  +-- Multi-agent collaboration
  |     +-- Role-based teams --> CrewAI
  |     +-- Conversational agents --> AutoGen
  |     +-- Complex workflows with state --> LangGraph
  |
  +-- Production system
        +-- Need observability, tracing --> LangGraph + LangSmith
        +-- Enterprise integration --> Semantic Kernel
        +-- Maximum control --> Custom framework
```

---

## Core Agent Patterns

### ReAct Pattern (Reasoning + Acting)

```
Thought: I need to find the current weather in Tokyo
Action: weather_tool(location="Tokyo")
Observation: Temperature: 18C, Humidity: 65%, Clear skies
Thought: I now have the weather information
Action: FINISH
Answer: The current weather in Tokyo is 18C with clear skies and 65% humidity.
```

### Agent Architecture

```
+--------------------------------------------------+
|                   Agent Loop                      |
|                                                   |
|  +--------+    +---------+    +----------------+  |
|  | Observe | -> | Think   | -> | Act            |  |
|  | (input) |    | (reason)|    | (tool/respond) |  |
|  +--------+    +---------+    +----------------+  |
|       ^                              |             |
|       |          +--------+          |             |
|       +----------| Memory |<---------+             |
|                  +--------+                        |
+--------------------------------------------------+
         |                       |
    +----v----+            +----v----+
    | Tools   |            | Output  |
    | - search|            | - text  |
    | - code  |            | - action|
    | - API   |            | - data  |
    +---------+            +---------+
```

---

## LangGraph Agent Implementation

### Basic ReAct Agent

```python
from typing import Annotated, TypedDict, Sequence
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_core.tools import tool
from langchain_openai import ChatOpenAI
from langgraph.graph import StateGraph, END
from langgraph.prebuilt import ToolNode
from langgraph.graph.message import add_messages

class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], add_messages]

@tool
def search_web(query: str) -> str:
    """Search the web for current information."""
    # Implementation with your preferred search API
    return f"Search results for: {query}"

@tool
def calculate(expression: str) -> str:
    """Evaluate a mathematical expression safely."""
    allowed_chars = set("0123456789+-*/.() ")
    if not all(c in allowed_chars for c in expression):
        return "Error: Invalid characters in expression"
    try:
        result = eval(expression)  # Safe due to character whitelist
        return str(result)
    except Exception as e:
        return f"Error: {e}"

@tool
def read_file(path: str) -> str:
    """Read contents of a file."""
    try:
        with open(path) as f:
            return f.read()[:5000]
    except FileNotFoundError:
        return f"File not found: {path}"

# Build the graph
tools = [search_web, calculate, read_file]
model = ChatOpenAI(model="gpt-4o", temperature=0).bind_tools(tools)

def should_continue(state: AgentState) -> str:
    last_message = state["messages"][-1]
    if last_message.tool_calls:
        return "tools"
    return END

def call_model(state: AgentState) -> dict:
    response = model.invoke(state["messages"])
    return {"messages": [response]}

# Construct graph
graph = StateGraph(AgentState)
graph.add_node("agent", call_model)
graph.add_node("tools", ToolNode(tools))
graph.set_entry_point("agent")
graph.add_conditional_edges("agent", should_continue, {"tools": "tools", END: END})
graph.add_edge("tools", "agent")

app = graph.compile()

# Run
result = app.invoke({
    "messages": [HumanMessage(content="What is 42 * 17 + 3?")]
})
```

### Stateful Agent with Memory

```python
from langgraph.checkpoint.memory import MemorySaver
from langgraph.graph import StateGraph, END
from langchain_core.messages import SystemMessage

class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], add_messages]
    context: dict  # Persistent context across turns

SYSTEM_PROMPT = """You are a helpful research assistant. You have access to
search and calculation tools. Always cite your sources. If you are unsure
about something, say so rather than making up information."""

def call_model(state: AgentState) -> dict:
    system = SystemMessage(content=SYSTEM_PROMPT)
    messages = [system] + list(state["messages"])
    response = model.invoke(messages)
    return {"messages": [response]}

# Build graph with checkpointing
graph = StateGraph(AgentState)
graph.add_node("agent", call_model)
graph.add_node("tools", ToolNode(tools))
graph.set_entry_point("agent")
graph.add_conditional_edges("agent", should_continue, {"tools": "tools", END: END})
graph.add_edge("tools", "agent")

memory = MemorySaver()
app = graph.compile(checkpointer=memory)

# Conversation with persistent memory
config = {"configurable": {"thread_id": "user-123"}}

# Turn 1
result = app.invoke(
    {"messages": [HumanMessage(content="Search for latest AI news")]},
    config,
)

# Turn 2 (remembers context)
result = app.invoke(
    {"messages": [HumanMessage(content="Summarize what you found")]},
    config,
)
```

### Multi-Agent Supervisor Pattern

```python
from langgraph.graph import StateGraph, END
from langchain_core.messages import HumanMessage

class TeamState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], add_messages]
    next_agent: str

def create_agent(model, tools, system_prompt):
    """Create a specialized agent node."""
    agent_model = model.bind_tools(tools)

    def agent_node(state: TeamState) -> dict:
        system = SystemMessage(content=system_prompt)
        messages = [system] + list(state["messages"])
        response = agent_model.invoke(messages)
        return {"messages": [response]}

    return agent_node

# Create specialized agents
researcher = create_agent(
    model, [search_web],
    "You are a research specialist. Find accurate information."
)
analyst = create_agent(
    model, [calculate, read_file],
    "You are a data analyst. Analyze data and compute results."
)

def supervisor(state: TeamState) -> dict:
    """Route tasks to the appropriate specialist."""
    system = SystemMessage(content="""You are a supervisor managing a team:
    - 'researcher': for finding information
    - 'analyst': for data analysis and calculations
    - 'FINISH': when the task is complete

    Based on the conversation, decide who should act next.""")

    messages = [system] + list(state["messages"])
    response = model.invoke(messages)

    # Parse the routing decision from the response
    content = response.content.lower()
    if "researcher" in content:
        next_agent = "researcher"
    elif "analyst" in content:
        next_agent = "analyst"
    else:
        next_agent = "FINISH"

    return {"messages": [response], "next_agent": next_agent}

def route_supervisor(state: TeamState) -> str:
    return state.get("next_agent", "FINISH")

# Build supervisor graph
graph = StateGraph(TeamState)
graph.add_node("supervisor", supervisor)
graph.add_node("researcher", researcher)
graph.add_node("analyst", analyst)
graph.set_entry_point("supervisor")

graph.add_conditional_edges("supervisor", route_supervisor, {
    "researcher": "researcher",
    "analyst": "analyst",
    "FINISH": END,
})
graph.add_edge("researcher", "supervisor")
graph.add_edge("analyst", "supervisor")

team = graph.compile()
```

---

## CrewAI Multi-Agent Setup

```python
from crewai import Agent, Task, Crew, Process
from crewai_tools import SerperDevTool, ScrapeWebsiteTool

search_tool = SerperDevTool()
scrape_tool = ScrapeWebsiteTool()

# Define agents with roles
researcher = Agent(
    role="Senior Research Analyst",
    goal="Find comprehensive and accurate information on given topics",
    backstory="You are an experienced research analyst with expertise in "
              "finding and synthesizing information from multiple sources.",
    tools=[search_tool, scrape_tool],
    llm="gpt-4o",
    verbose=True,
    max_iter=5,
    allow_delegation=True,
)

writer = Agent(
    role="Technical Writer",
    goal="Create clear, well-structured technical documents",
    backstory="You are a skilled technical writer who excels at turning "
              "complex research into readable, actionable content.",
    llm="gpt-4o",
    verbose=True,
    max_iter=3,
)

reviewer = Agent(
    role="Quality Reviewer",
    goal="Ensure accuracy, completeness, and clarity of deliverables",
    backstory="You are a meticulous reviewer who catches errors and "
              "suggests improvements to ensure high-quality output.",
    llm="gpt-4o",
    verbose=True,
    max_iter=3,
)

# Define tasks
research_task = Task(
    description="Research the topic: {topic}. Find at least 5 authoritative "
                "sources and summarize key findings.",
    expected_output="A structured research brief with sources and key findings.",
    agent=researcher,
)

writing_task = Task(
    description="Using the research findings, write a comprehensive technical "
                "document about {topic}.",
    expected_output="A well-structured technical document with sections, "
                    "examples, and citations.",
    agent=writer,
    context=[research_task],
)

review_task = Task(
    description="Review the technical document for accuracy, completeness, "
                "and clarity. Suggest specific improvements.",
    expected_output="A review report with specific feedback and a final "
                    "approval or revision request.",
    agent=reviewer,
    context=[writing_task],
)

# Create and run crew
crew = Crew(
    agents=[researcher, writer, reviewer],
    tasks=[research_task, writing_task, review_task],
    process=Process.sequential,
    verbose=True,
)

result = crew.kickoff(inputs={"topic": "RAG optimization techniques"})
```

---

## Memory Systems

### Memory Type Comparison

| Memory Type | Scope | Persistence | Use Case | Implementation |
|------------|-------|-------------|----------|----------------|
| Conversation | Single thread | Session | Chat context | Message list |
| Summary | Single thread | Session | Long conversations | LLM summarization |
| Entity | Cross-thread | Persistent | User facts | Key-value store |
| Episodic | Cross-thread | Persistent | Past interactions | Vector DB |
| Semantic | Global | Persistent | Knowledge base | Vector DB |
| Procedural | Global | Persistent | Learned skills | Code/config |

### Vector-Based Long-Term Memory

```python
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma

class AgentMemory:
    """Long-term memory using vector similarity search."""

    def __init__(self, collection_name: str = "agent_memory"):
        self.embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
        self.store = Chroma(
            collection_name=collection_name,
            embedding_function=self.embeddings,
            persist_directory="./memory_db",
        )

    def remember(self, content: str, metadata: dict = None):
        """Store a memory."""
        self.store.add_texts(
            texts=[content],
            metadatas=[metadata or {}],
        )

    def recall(self, query: str, k: int = 5) -> list[str]:
        """Retrieve relevant memories."""
        docs = self.store.similarity_search(query, k=k)
        return [doc.page_content for doc in docs]

    def forget(self, content: str):
        """Remove a specific memory."""
        results = self.store.similarity_search(content, k=1)
        if results:
            self.store.delete(ids=[results[0].metadata.get("id")])
```

---

## Tool Design Best Practices

### Tool Definition Pattern

```python
from langchain_core.tools import tool
from pydantic import BaseModel, Field

class SearchInput(BaseModel):
    """Input schema for search tool."""
    query: str = Field(description="The search query string")
    max_results: int = Field(default=5, description="Maximum results to return")
    date_range: str = Field(
        default="any",
        description="Filter by date: 'today', 'week', 'month', 'year', 'any'"
    )

@tool(args_schema=SearchInput)
def search_web(query: str, max_results: int = 5, date_range: str = "any") -> str:
    """Search the web for current information on a topic.

    Use this tool when you need up-to-date information that may not
    be in your training data. Returns titles, URLs, and snippets.
    """
    # Implementation here
    pass
```

### Tool Categories

| Category | Examples | Safety Level |
|----------|----------|-------------|
| Read-only | Search, file read, API GET | Low risk |
| Write (local) | File write, DB insert | Medium risk |
| External write | Email send, API POST | High risk |
| Code execution | Python eval, shell exec | Critical risk |
| System | Process management, config | Critical risk |

> **Guardrail**: Always implement confirmation for high-risk and critical-risk tools. Never auto-execute code from untrusted sources.

---

## Error Handling and Resilience

### Retry with Fallback Pattern

```python
import time
from typing import Callable

def resilient_agent_step(
    fn: Callable,
    max_retries: int = 3,
    fallback_model: str = None,
) -> dict:
    """Execute an agent step with retries and fallback."""
    last_error = None

    for attempt in range(max_retries):
        try:
            return fn()
        except Exception as e:
            last_error = e
            wait = 2 ** attempt
            time.sleep(wait)

    if fallback_model:
        # Retry with a different model
        try:
            return fn(model_override=fallback_model)
        except Exception as e:
            last_error = e

    return {
        "error": str(last_error),
        "status": "failed",
        "attempts": max_retries,
    }
```

### Max Iterations Guard

```python
MAX_AGENT_ITERATIONS = 15
COST_LIMIT_USD = 1.0

def run_agent_with_guards(agent, input_msg, max_iter=MAX_AGENT_ITERATIONS):
    """Run agent with iteration and cost limits."""
    iterations = 0
    total_tokens = 0

    for step in agent.stream({"messages": [HumanMessage(content=input_msg)]}):
        iterations += 1

        # Track token usage
        if hasattr(step, "usage_metadata"):
            total_tokens += step.usage_metadata.get("total_tokens", 0)

        # Guard: max iterations
        if iterations >= max_iter:
            return {
                "result": "Agent stopped: max iterations reached",
                "iterations": iterations,
            }

        # Guard: cost limit (rough estimate)
        estimated_cost = total_tokens * 0.00001  # Adjust per model
        if estimated_cost > COST_LIMIT_USD:
            return {
                "result": "Agent stopped: cost limit reached",
                "estimated_cost": estimated_cost,
            }

    return {"result": step, "iterations": iterations}
```

---

## Testing Agents

### Unit Testing Tools

```python
import pytest

def test_search_tool_returns_results():
    result = search_web.invoke({"query": "test query"})
    assert isinstance(result, str)
    assert len(result) > 0

def test_calculate_tool_valid():
    result = calculate.invoke({"expression": "2 + 2"})
    assert result == "4"

def test_calculate_tool_rejects_injection():
    result = calculate.invoke({"expression": "__import__('os').system('ls')"})
    assert "Error" in result
```

### Integration Testing Agents

```python
def test_agent_answers_math():
    result = app.invoke({
        "messages": [HumanMessage(content="What is 15 * 7?")]
    })
    final = result["messages"][-1].content
    assert "105" in final

def test_agent_uses_search():
    result = app.invoke({
        "messages": [HumanMessage(content="Search for Python 3.12 features")]
    })
    messages = result["messages"]
    tool_calls = [m for m in messages if hasattr(m, "tool_calls") and m.tool_calls]
    assert len(tool_calls) > 0
```

---

## Production Deployment Checklist

### Pre-Launch

- [ ] All tools tested independently with edge cases
- [ ] Max iteration and cost limits configured
- [ ] Retry logic with fallback models in place
- [ ] Input validation on all user-facing endpoints
- [ ] Prompt injection defenses active (see `4-secure/ai_safety_guardrails`)
- [ ] Rate limiting configured per user/API key

### Observability

- [ ] LangSmith or equivalent tracing enabled
- [ ] Token usage tracked per request
- [ ] Error rates monitored with alerting
- [ ] Tool call success/failure rates logged
- [ ] Agent iteration counts tracked (watch for loops)

### Safety

- [ ] High-risk tools require confirmation
- [ ] No arbitrary code execution without sandboxing
- [ ] PII detection on inputs and outputs
- [ ] Output content filtering enabled
- [ ] Agent cannot modify its own system prompt or tools

---

## EXIT CHECKLIST

- [ ] Agent architecture pattern selected (ReAct, supervisor, hierarchical)
- [ ] Framework chosen based on requirements
- [ ] Tools implemented with proper schemas and safety levels
- [ ] Memory system configured (conversation, long-term, or both)
- [ ] Error handling with retries, fallbacks, and iteration limits
- [ ] Multi-agent orchestration tested (if applicable)
- [ ] Observability and tracing configured
- [ ] Safety guardrails in place for production

---

## Cross-References

- `4-secure/ai_safety_guardrails` -- Prompt injection defense and output filtering
- `3-build/rag_advanced_patterns` -- RAG as an agent tool
- `3-build/vector_database_operations` -- Vector DB for agent memory
- `2-design/embedding_pipeline_design` -- Embeddings for semantic memory

---

*Skill Version: 1.0 | Created: March 2026*
