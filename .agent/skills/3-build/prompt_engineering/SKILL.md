---
name: Prompt Engineering
description: Designing effective LLM prompts and building RAG (Retrieval Augmented Generation) systems
---

# Prompt Engineering Skill

**Purpose**: Systematic workflow for designing effective prompts for LLMs, building RAG pipelines, and implementing production-grade AI features with proper evaluation and cost management.

---

## 🎯 TRIGGER COMMANDS

```text
"Design prompts for [use case]"
"Prompt engineering for [task]"
"Build a RAG system for [data source]"
"Improve this prompt: [paste prompt]"
"Set up vector search for [content type]"
"Using prompt_engineering skill: [task]"
```

---

## 📝 Prompt Design Fundamentals

### The 5 Components of an Effective Prompt

| Component | Purpose | Example |
|-----------|---------|---------|
| **Role / System** | Define who the LLM is | "You are a senior tax accountant..." |
| **Instructions** | What to do, step by step | "Analyze the following receipt and extract..." |
| **Output format** | Exact structure expected | "Return JSON with fields: amount, category, date" |
| **Examples** | Show, do not just tell | Input/output pairs demonstrating the task |
| **Constraints** | Boundaries and rules | "Never make up information. Say 'I don't know' if unsure." |

### System Prompt Best Practices

```text
You are a [specific role] specializing in [domain].

Your task is to [clear action verb] based on the user's input.

Rules:
- Always respond in [format: JSON / markdown / plain text]
- If you are unsure about something, say "I'm not certain" instead of guessing
- Do not include information not present in the provided context
- Keep responses under [N] sentences/tokens unless asked for more detail

Output format:
{
  "field1": "description",
  "field2": "description",
  "confidence": "high | medium | low"
}
```

> [!WARNING]
> Never put sensitive information (API keys, internal URLs, proprietary logic) in system prompts. Users can extract system prompts through prompt injection. Treat system prompts as public.

---

## 🧠 Prompt Patterns

| Pattern | Description | Best For |
|---------|-------------|----------|
| **Zero-shot** | No examples, just instructions | Simple tasks the model already knows |
| **One-shot** | Single example provided | Tasks needing format clarification |
| **Few-shot** | 3-5 examples provided | Classification, extraction, formatting |
| **Chain-of-Thought (CoT)** | "Think step by step" | Math, logic, reasoning |
| **Tree-of-Thought** | Explore multiple reasoning paths | Complex planning, strategy |
| **ReAct** | Reason + Act (use tools) | Agents, multi-step tasks |
| **Self-Consistency** | Run multiple times, pick majority | High-stakes reasoning |

### Few-Shot Prompt Template

```text
Classify the following customer support messages into categories.

Categories: billing, technical, account, general

Examples:
---
Message: "I was charged twice for my subscription this month"
Category: billing

Message: "The app crashes when I try to upload a photo"
Category: technical

Message: "How do I change my email address?"
Category: account
---

Now classify this message:
Message: "{user_message}"
Category:
```

### Chain-of-Thought Prompt

```text
You are a financial analyst. Analyze the following quarterly results.

Think through this step by step:
1. First, calculate the revenue growth rate quarter-over-quarter
2. Then, analyze the profit margin changes
3. Next, compare against industry benchmarks
4. Finally, provide your assessment

Show your reasoning for each step before giving your final answer.

Data:
{quarterly_data}
```

---

## 🔧 Output Structuring

### JSON Mode

```python
from openai import OpenAI

client = OpenAI()

response = client.chat.completions.create(
    model="gpt-4o",
    response_format={"type": "json_object"},
    messages=[
        {
            "role": "system",
            "content": """Extract product information from the description.
Return JSON with this exact schema:
{
  "name": "string",
  "price": number,
  "currency": "string (ISO 4217)",
  "features": ["string"],
  "category": "string"
}"""
        },
        {"role": "user", "content": product_description}
    ],
)

import json
result = json.loads(response.choices[0].message.content)
```

### Tool Use / Function Calling

```python
tools = [
    {
        "type": "function",
        "function": {
            "name": "search_database",
            "description": "Search the product database by query",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {"type": "string", "description": "Search query"},
                    "category": {"type": "string", "enum": ["electronics", "clothing", "food"]},
                    "max_results": {"type": "integer", "default": 5},
                },
                "required": ["query"],
            },
        },
    }
]

response = client.chat.completions.create(
    model="gpt-4o",
    messages=messages,
    tools=tools,
    tool_choice="auto",
)

# Check if model wants to call a tool
if response.choices[0].message.tool_calls:
    tool_call = response.choices[0].message.tool_calls[0]
    args = json.loads(tool_call.function.arguments)
    # Execute the function and return results to the model
```

---

## 🏗️ RAG Architecture

### Pipeline Overview

```text
Document Ingestion → Chunking → Embedding → Vector Store
                                                   ↓
User Query → Embedding → Similarity Search → Context Injection → LLM → Response
```

### Full RAG Pipeline (LangChain)

```python
from langchain_community.document_loaders import DirectoryLoader, TextLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_community.vectorstores import PGVector
from langchain.chains import RetrievalQA
from langchain.prompts import PromptTemplate

# 1. Load documents
loader = DirectoryLoader("./docs", glob="**/*.md", loader_cls=TextLoader)
documents = loader.load()

# 2. Chunk documents
splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separators=["\n\n", "\n", ". ", " ", ""],
)
chunks = splitter.split_documents(documents)

# 3. Create embeddings and store in vector database
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
vectorstore = PGVector.from_documents(
    documents=chunks,
    embedding=embeddings,
    connection_string="postgresql://user:pass@localhost:5432/mydb",
    collection_name="my_docs",
)

# 4. Create retrieval chain
retriever = vectorstore.as_retriever(
    search_type="similarity",
    search_kwargs={"k": 5},
)

prompt_template = PromptTemplate.from_template("""
You are a helpful assistant. Answer the question based ONLY on the following context.
If the answer is not in the context, say "I don't have enough information to answer that."

Context:
{context}

Question: {question}

Answer:""")

qa_chain = RetrievalQA.from_chain_type(
    llm=ChatOpenAI(model="gpt-4o", temperature=0),
    chain_type="stuff",
    retriever=retriever,
    chain_type_kwargs={"prompt": prompt_template},
    return_source_documents=True,
)

# 5. Query
result = qa_chain.invoke({"query": "How do I configure authentication?"})
print(result["result"])
print("Sources:", [doc.metadata["source"] for doc in result["source_documents"]])
```

---

## 📐 Chunking Strategies

| Strategy | Description | Best For |
|----------|-------------|----------|
| **Fixed size** | Split every N characters/tokens | Simple, predictable chunk sizes |
| **Sentence-based** | Split on sentence boundaries | Natural language documents |
| **Paragraph-based** | Split on double newlines | Well-structured articles |
| **Semantic** | Split when topic changes (using embeddings) | Mixed-topic documents |
| **Recursive** | Try larger separators first, fall back to smaller | General purpose (recommended) |
| **Parent-child** | Small chunks for retrieval, return parent for context | When context around match matters |

```python
# Recursive (recommended default)
from langchain.text_splitter import RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,      # Target chunk size in characters
    chunk_overlap=200,    # Overlap between chunks (preserves context)
    separators=["\n\n", "\n", ". ", " ", ""],  # Try in order
)
```

> [!TIP]
> **Chunk overlap is critical.** Without overlap, sentences that span chunk boundaries get split, losing context. Use 10-20% overlap (e.g., 200 overlap for 1000-char chunks).

---

## 🗄️ Vector Database Comparison

| Database | Type | Hosting | Best For |
|----------|------|---------|----------|
| **pgvector** | PostgreSQL extension | Self-hosted | Already using PostgreSQL, simplicity |
| **Pinecone** | Managed cloud | Cloud only | Zero-ops, auto-scaling |
| **Weaviate** | Open source | Self-hosted / Cloud | Hybrid search, multi-modal |
| **Qdrant** | Open source | Self-hosted / Cloud | High performance, filtering |
| **Chroma** | Open source | Embedded / Self-hosted | Prototyping, small datasets |
| **Milvus** | Open source | Self-hosted / Cloud | Large scale, billion-vector datasets |

### Embedding Models

| Model | Dimensions | Cost | Quality |
|-------|-----------|------|---------|
| **text-embedding-3-small** (OpenAI) | 1536 | $0.02/1M tokens | Good |
| **text-embedding-3-large** (OpenAI) | 3072 | $0.13/1M tokens | Best (OpenAI) |
| **embed-v4** (Cohere) | 1024 | $0.10/1M tokens | Excellent |
| **all-MiniLM-L6-v2** (open) | 384 | Free (self-hosted) | Good for prototypes |
| **bge-large-en-v1.5** (open) | 1024 | Free (self-hosted) | Best open-source |

---

## 🔍 Retrieval Strategies

| Strategy | Description | When to Use |
|----------|-------------|-------------|
| **Similarity search** | Cosine similarity between query and chunk embeddings | Default, works well for most cases |
| **Hybrid search** | Combine vector similarity + BM25 keyword search | When exact terms matter (names, codes) |
| **Re-ranking** | Retrieve N, re-rank with cross-encoder to top K | When initial retrieval has noise |
| **Contextual compression** | LLM extracts relevant sentences from chunks | When chunks contain irrelevant info |
| **Parent-child** | Retrieve on small chunks, return parent document | When surrounding context matters |
| **Multi-query** | Generate multiple query variations, merge results | When user query is ambiguous |

```python
# Hybrid search with pgvector
from langchain_community.vectorstores import PGVector
from langchain.retrievers import EnsembleRetriever
from langchain_community.retrievers import BM25Retriever

# Vector retriever
vector_retriever = vectorstore.as_retriever(search_kwargs={"k": 5})

# Keyword retriever
bm25_retriever = BM25Retriever.from_documents(chunks, k=5)

# Combine: 70% vector, 30% keyword
ensemble_retriever = EnsembleRetriever(
    retrievers=[vector_retriever, bm25_retriever],
    weights=[0.7, 0.3],
)
```

---

## 🛡️ Prompt Injection Defense

| Defense | Method | Effectiveness |
|---------|--------|---------------|
| **Input sanitization** | Strip control characters, escape special tokens | Basic but necessary |
| **System prompt isolation** | Separate system instructions from user content with delimiters | Medium -- helps but not bulletproof |
| **Output validation** | Parse LLM output, reject unexpected formats | High for structured outputs |
| **Guardrails** | Pre/post-processing checks on input and output | High when combined |
| **Dual-LLM pattern** | Separate "privileged" and "quarantined" LLM calls | Highest -- prevents escalation |

```python
import re

def sanitize_input(user_input: str) -> str:
    """Basic input sanitization for LLM prompts."""
    # Remove potential injection patterns
    cleaned = user_input.strip()
    # Limit length
    cleaned = cleaned[:4000]
    # Remove control characters
    cleaned = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]', '', cleaned)
    return cleaned

def validate_output(response: str, expected_format: str = "json") -> dict | None:
    """Validate LLM output matches expected format."""
    if expected_format == "json":
        try:
            parsed = json.loads(response)
            # Verify expected keys exist
            required_keys = {"answer", "confidence"}
            if not required_keys.issubset(parsed.keys()):
                return None
            return parsed
        except json.JSONDecodeError:
            return None
    return None
```

---

## 📊 Evaluation

### RAG Evaluation with RAGAS

```python
from ragas import evaluate
from ragas.metrics import (
    faithfulness,
    answer_relevancy,
    context_precision,
    context_recall,
)
from datasets import Dataset

# Prepare evaluation dataset
eval_data = {
    "question": ["How do I reset my password?", "What are the pricing tiers?"],
    "answer": [rag_answer_1, rag_answer_2],
    "contexts": [retrieved_contexts_1, retrieved_contexts_2],
    "ground_truth": ["Go to Settings > Security > Reset Password", "Free, Pro ($10), Enterprise ($50)"],
}

dataset = Dataset.from_dict(eval_data)

results = evaluate(
    dataset,
    metrics=[faithfulness, answer_relevancy, context_precision, context_recall],
)

print(results)
# {'faithfulness': 0.92, 'answer_relevancy': 0.88, 'context_precision': 0.85, ...}
```

### LLM-as-Judge Pattern

```python
JUDGE_PROMPT = """You are evaluating the quality of an AI assistant's response.

Question: {question}
Reference Answer: {reference}
AI Response: {response}

Rate the response on these criteria (1-5 each):
1. Accuracy: Does it match the reference answer?
2. Completeness: Does it cover all key points?
3. Clarity: Is it easy to understand?

Return JSON:
{{"accuracy": N, "completeness": N, "clarity": N, "reasoning": "..."}}
"""

async def judge_response(question, reference, response):
    result = await client.chat.completions.create(
        model="gpt-4o",
        response_format={"type": "json_object"},
        messages=[
            {"role": "system", "content": "You are an impartial evaluator."},
            {"role": "user", "content": JUDGE_PROMPT.format(
                question=question, reference=reference, response=response
            )},
        ],
    )
    return json.loads(result.choices[0].message.content)
```

---

## 💰 Cost Optimization

| Strategy | Savings | Implementation |
|----------|---------|---------------|
| **Model routing** | 50-80% | Use cheap model for simple queries, expensive for complex |
| **Semantic caching** | 30-60% | Cache responses for similar queries (vector similarity) |
| **Prompt compression** | 20-40% | Remove redundant tokens, abbreviate system prompts |
| **Batching** | 10-30% | Batch multiple requests when latency is not critical |
| **Streaming** | 0% cost, better UX | Stream responses for perceived speed improvement |

### Model Routing Example

```python
# Simple router: classify query complexity, choose model
async def route_query(query: str) -> str:
    # Use a cheap model to classify complexity
    classification = await client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{
            "role": "system",
            "content": "Classify this query as 'simple' or 'complex'. Simple = factual lookup, greetings, basic Q&A. Complex = reasoning, analysis, multi-step."
        }, {
            "role": "user",
            "content": query
        }],
        max_tokens=10,
    )

    complexity = classification.choices[0].message.content.strip().lower()

    if "simple" in complexity:
        return "gpt-4o-mini"     # ~$0.15/1M input tokens
    else:
        return "gpt-4o"          # ~$2.50/1M input tokens
```

### Semantic Caching

```python
import hashlib
import numpy as np

class SemanticCache:
    def __init__(self, vectorstore, similarity_threshold=0.95):
        self.vectorstore = vectorstore
        self.threshold = similarity_threshold
        self.cache = {}

    async def get_or_generate(self, query: str, generate_fn):
        # Check for semantically similar cached query
        results = self.vectorstore.similarity_search_with_score(query, k=1)

        if results and results[0][1] >= self.threshold:
            cache_key = results[0][0].metadata.get("cache_key")
            if cache_key and cache_key in self.cache:
                return self.cache[cache_key]  # Cache hit

        # Cache miss: generate response
        response = await generate_fn(query)

        # Store in cache
        cache_key = hashlib.md5(query.encode()).hexdigest()
        self.cache[cache_key] = response
        self.vectorstore.add_texts([query], metadatas=[{"cache_key": cache_key}])

        return response
```

---

## 🤖 Agent Patterns

| Pattern | Description | Use Case |
|---------|-------------|----------|
| **Tool use** | LLM decides which tools to call | Search, calculation, API calls |
| **ReAct** | Reason about what to do, then act | Multi-step tasks with tools |
| **Plan-and-execute** | Create plan first, then execute steps | Complex multi-step workflows |
| **Multi-agent** | Multiple specialized agents collaborate | Large systems, different domains |
| **Reflection** | Agent reviews its own output, self-corrects | High-quality outputs, code generation |

> [!TIP]
> Start with simple tool use. Only add complexity (ReAct, multi-agent) when simpler patterns fail. Each layer of agent orchestration adds latency, cost, and unpredictability.

---

## ❌ Common Mistakes

| Mistake | Why It Fails | Fix |
|---------|-------------|-----|
| **Vague instructions** | LLM guesses intent, inconsistent output | Be explicit: "Extract X, format as Y" |
| **No output format** | Responses vary in structure | Specify JSON schema or exact format |
| **No examples** | Model does not know your expectations | Add 2-3 few-shot examples |
| **Prompt too long** | Wastes context window, buries key info | Move static instructions to system prompt, compress |
| **No edge case testing** | Fails on unusual inputs | Test with empty input, adversarial input, long input |
| **Ignoring temperature** | Creative when you need precise, or vice versa | Temperature 0 for extraction, 0.7+ for creative |
| **No guardrails** | Prompt injection, hallucination | Input sanitization, output validation, grounding |

---

## ✅ EXIT CHECKLIST

- [ ] Prompts tested on 20+ diverse inputs including edge cases
- [ ] Output format consistent across all test inputs
- [ ] Few-shot examples included for non-trivial tasks
- [ ] System prompt defines role, constraints, and output format
- [ ] RAG retrieval returns relevant context (precision > 0.8)
- [ ] RAG responses are faithful to context (faithfulness > 0.9)
- [ ] Guardrails prevent prompt injection on adversarial inputs
- [ ] Output validation rejects malformed responses
- [ ] Cost per query estimated and within budget
- [ ] Semantic caching configured for repeated query patterns
- [ ] Model routing set up (cheap for simple, expensive for complex)
- [ ] Evaluation metrics tracked (RAGAS or LLM-as-judge)
- [ ] Temperature and max_tokens tuned for the task
- [ ] Error handling for API failures, timeouts, rate limits

---

*Skill Version: 1.0 | Created: February 2026*
