---
name: RAG Advanced Patterns
description: Advanced RAG patterns including query routing, re-ranking, hybrid search, recursive retrieval, RAPTOR, CRAG, self-RAG, and production evaluation
---

# RAG Advanced Patterns Skill

**Purpose**: Provide implementation guidance for advanced retrieval-augmented generation patterns that go beyond naive RAG to achieve production-grade accuracy, relevance, and reliability.

---

## TRIGGER COMMANDS

```text
"Improve my RAG pipeline accuracy"
"Implement advanced RAG with re-ranking"
"Set up hybrid search for RAG"
"Evaluate my RAG system with RAGAS"
"Using rag_advanced_patterns skill: [task]"
```

---

## RAG Pattern Taxonomy

### Maturity Levels

| Level | Pattern | Retrieval Quality | Complexity | When to Use |
|-------|---------|------------------|------------|-------------|
| L0 | Naive RAG | Low-Medium | Simple | Prototyping |
| L1 | + Re-ranking | Medium-High | Low | First improvement |
| L2 | + Hybrid Search | High | Medium | Keyword matters |
| L3 | + Query Transform | High | Medium | Ambiguous queries |
| L4 | + Recursive/Agentic | Very High | High | Complex questions |
| L5 | Self-RAG / CRAG | Very High | Very High | Critical accuracy |

### Architecture Overview

```
                    User Query
                        |
                  +-----v------+
                  | Query       |
                  | Processing  |
                  +-----+------+
                        |
          +-------------+-------------+
          |             |             |
    +-----v----+  +----v-----+ +----v-----+
    | Query    |  | Query    | | Query    |
    | Routing  |  | Rewrite  | | Expansion|
    +-----+----+  +----+-----+ +----+-----+
          |             |             |
          +------+------+------+------+
                 |
           +-----v------+
           | Retrieval   |
           | (Hybrid)    |
           +-----+------+
                 |
           +-----v------+
           | Re-Ranking  |
           +-----+------+
                 |
           +-----v------+
           | Context     |
           | Filtering   |
           +-----+------+
                 |
           +-----v------+
           | Generation  |
           | + Citation  |
           +-----+------+
                 |
           +-----v------+
           | Validation  |
           | (Self-RAG)  |
           +-------------+
```

---

## Query Processing Patterns

### Query Rewriting

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)

REWRITE_PROMPT = ChatPromptTemplate.from_messages([
    ("system", """Rewrite the user query to be more specific and effective for
    semantic search. Expand abbreviations, resolve ambiguities, and add context.
    Return ONLY the rewritten query, nothing else."""),
    ("human", "{query}"),
])

def rewrite_query(query: str) -> str:
    """Rewrite query for better retrieval."""
    chain = REWRITE_PROMPT | llm
    result = chain.invoke({"query": query})
    return result.content
```

### Multi-Query Expansion

```python
MULTI_QUERY_PROMPT = ChatPromptTemplate.from_messages([
    ("system", """Generate 3 different versions of the user query to capture
    different perspectives and phrasings. Return one query per line.
    Do NOT number them or add prefixes."""),
    ("human", "{query}"),
])

def expand_query(query: str) -> list[str]:
    """Generate multiple query variants for broader retrieval."""
    chain = MULTI_QUERY_PROMPT | llm
    result = chain.invoke({"query": query})
    variants = [q.strip() for q in result.content.strip().split("\n") if q.strip()]
    return [query] + variants  # Include original

def multi_query_retrieve(queries: list[str], search_fn, k: int = 5) -> list[dict]:
    """Retrieve and deduplicate across multiple queries."""
    seen_ids = set()
    all_results = []

    for q in queries:
        results = search_fn(q, k=k)
        for r in results:
            if r["id"] not in seen_ids:
                seen_ids.add(r["id"])
                all_results.append(r)

    return all_results
```

### Query Routing

```python
from enum import Enum

class QueryRoute(str, Enum):
    VECTOR_SEARCH = "vector"
    KEYWORD_SEARCH = "keyword"
    HYBRID_SEARCH = "hybrid"
    SQL_QUERY = "sql"
    NO_RETRIEVAL = "direct"

ROUTING_PROMPT = ChatPromptTemplate.from_messages([
    ("system", """Classify the query into one of these retrieval strategies:
    - "vector": semantic/conceptual questions (how, why, explain)
    - "keyword": exact term lookup (error codes, specific names, IDs)
    - "hybrid": mixed (technical questions with specific terms)
    - "sql": structured data questions (counts, aggregations, filters)
    - "direct": general knowledge, no retrieval needed

    Return ONLY the strategy name."""),
    ("human", "{query}"),
])

def route_query(query: str) -> QueryRoute:
    """Route query to optimal retrieval strategy."""
    chain = ROUTING_PROMPT | llm
    result = chain.invoke({"query": query})
    route = result.content.strip().lower()
    try:
        return QueryRoute(route)
    except ValueError:
        return QueryRoute.HYBRID_SEARCH  # Safe default
```

### HyDE (Hypothetical Document Embeddings)

```python
HYDE_PROMPT = ChatPromptTemplate.from_messages([
    ("system", """Generate a hypothetical document that would perfectly answer
    the user's question. Write as if this document exists in a knowledge base.
    Be specific and technical. Do not say 'this document' - just write the content."""),
    ("human", "{query}"),
])

def hyde_retrieve(query: str, embed_fn, search_fn, k: int = 10) -> list[dict]:
    """Generate hypothetical answer, embed it, search with it."""
    chain = HYDE_PROMPT | llm
    hypothetical = chain.invoke({"query": query}).content
    hyde_embedding = embed_fn(hypothetical)
    return search_fn(hyde_embedding, k=k)
```

---

## Re-Ranking

### Cross-Encoder Re-Ranking

```python
from sentence_transformers import CrossEncoder

reranker = CrossEncoder("cross-encoder/ms-marco-MiniLM-L-12-v2")

def rerank(query: str, documents: list[dict], top_k: int = 5) -> list[dict]:
    """Re-rank documents using cross-encoder."""
    pairs = [(query, doc["content"]) for doc in documents]
    scores = reranker.predict(pairs)

    for doc, score in zip(documents, scores):
        doc["rerank_score"] = float(score)

    ranked = sorted(documents, key=lambda x: x["rerank_score"], reverse=True)
    return ranked[:top_k]
```

### Cohere Re-Ranking

```python
import cohere

co = cohere.Client(api_key="your-key")

def rerank_cohere(
    query: str,
    documents: list[dict],
    top_k: int = 5,
    model: str = "rerank-v3.5",
) -> list[dict]:
    """Re-rank using Cohere's reranker API."""
    results = co.rerank(
        query=query,
        documents=[d["content"] for d in documents],
        top_n=top_k,
        model=model,
    )

    reranked = []
    for r in results.results:
        doc = documents[r.index].copy()
        doc["rerank_score"] = r.relevance_score
        reranked.append(doc)

    return reranked
```

### Re-Ranker Comparison

| Re-Ranker | Latency (20 docs) | Quality (NDCG@10) | Cost |
|-----------|-------------------|-------------------|------|
| ms-marco-MiniLM-L-12-v2 | ~15ms | 0.39 | Free (local) |
| bge-reranker-v2-m3 | ~25ms | 0.42 | Free (local) |
| Cohere rerank-v3.5 | ~100ms | 0.45 | $2/1K queries |
| Jina reranker-v2 | ~20ms | 0.41 | Free (local) |
| GPT-4o (LLM-as-ranker) | ~2s | 0.47 | ~$0.03/query |

---

## Hybrid Search

### BM25 + Vector Fusion

```python
from rank_bm25 import BM25Okapi
import numpy as np

class HybridSearcher:
    """Combine BM25 keyword search with vector similarity search."""

    def __init__(self, documents: list[dict], embeddings: np.ndarray):
        self.documents = documents
        self.embeddings = embeddings

        # Build BM25 index
        tokenized = [doc["content"].lower().split() for doc in documents]
        self.bm25 = BM25Okapi(tokenized)

    def search(
        self,
        query: str,
        query_embedding: np.ndarray,
        k: int = 10,
        alpha: float = 0.7,  # Weight for vector search (0=BM25 only, 1=vector only)
    ) -> list[dict]:
        """Hybrid search with weighted combination."""
        # BM25 scores
        bm25_scores = self.bm25.get_scores(query.lower().split())
        bm25_scores = bm25_scores / (bm25_scores.max() + 1e-8)  # Normalize

        # Vector similarity scores
        similarities = np.dot(self.embeddings, query_embedding)
        sim_min, sim_max = similarities.min(), similarities.max()
        vector_scores = (similarities - sim_min) / (sim_max - sim_min + 1e-8)

        # Combined scores
        combined = alpha * vector_scores + (1 - alpha) * bm25_scores

        # Get top-k
        top_indices = np.argsort(combined)[::-1][:k]
        results = []
        for idx in top_indices:
            doc = self.documents[idx].copy()
            doc["hybrid_score"] = float(combined[idx])
            doc["vector_score"] = float(vector_scores[idx])
            doc["bm25_score"] = float(bm25_scores[idx])
            results.append(doc)

        return results
```

---

## Advanced Retrieval Patterns

### Recursive Retrieval (Parent-Child)

```python
class ParentChildRetriever:
    """Retrieve child chunks, return parent documents for context."""

    def __init__(self, vector_store, doc_store):
        self.vector_store = vector_store
        self.doc_store = doc_store

    def retrieve(self, query: str, k: int = 5) -> list[dict]:
        """Search small chunks, return larger parent context."""
        # Search fine-grained child chunks
        child_results = self.vector_store.similarity_search(query, k=k * 2)

        # Map to parent documents (deduplicate)
        seen_parents = set()
        parents = []
        for child in child_results:
            parent_id = child.metadata["parent_id"]
            if parent_id not in seen_parents:
                seen_parents.add(parent_id)
                parent_doc = self.doc_store.get(parent_id)
                parents.append({
                    "id": parent_id,
                    "content": parent_doc["content"],
                    "matched_chunk": child.page_content,
                    "score": child.metadata.get("score", 0),
                })

        return parents[:k]
```

### RAPTOR (Recursive Abstractive Processing for Tree-Organized Retrieval)

```python
class RaptorIndex:
    """Build hierarchical summary tree for multi-level retrieval."""

    def __init__(self, llm, embed_fn, vector_store):
        self.llm = llm
        self.embed_fn = embed_fn
        self.vector_store = vector_store

    def build_tree(self, chunks: list[str], cluster_size: int = 10):
        """Build summary tree bottom-up."""
        current_level = chunks
        level = 0

        while len(current_level) > 1:
            # Cluster chunks
            clusters = [
                current_level[i:i + cluster_size]
                for i in range(0, len(current_level), cluster_size)
            ]

            summaries = []
            for cluster in clusters:
                combined = "\n\n---\n\n".join(cluster)
                summary = self.llm.invoke(
                    f"Summarize the following texts concisely:\n\n{combined}"
                ).content

                # Store summary with level metadata
                embedding = self.embed_fn(summary)
                self.vector_store.add(
                    text=summary,
                    embedding=embedding,
                    metadata={"level": level, "children_count": len(cluster)},
                )
                summaries.append(summary)

            # Also store leaf nodes
            if level == 0:
                for chunk in current_level:
                    embedding = self.embed_fn(chunk)
                    self.vector_store.add(
                        text=chunk,
                        embedding=embedding,
                        metadata={"level": 0, "type": "leaf"},
                    )

            current_level = summaries
            level += 1

    def retrieve(self, query: str, k: int = 5) -> list[dict]:
        """Search across all levels of the tree."""
        return self.vector_store.similarity_search(query, k=k)
```

### CRAG (Corrective RAG)

```python
class CorrectiveRAG:
    """Evaluate retrieval quality and correct if needed."""

    def __init__(self, llm, retriever, web_search_fn):
        self.llm = llm
        self.retriever = retriever
        self.web_search = web_search_fn

    def evaluate_relevance(self, query: str, document: str) -> str:
        """Grade document relevance: RELEVANT, PARTIAL, or IRRELEVANT."""
        prompt = f"""Grade how relevant this document is to the query.
        Query: {query}
        Document: {document}

        Return exactly one of: RELEVANT, PARTIAL, IRRELEVANT"""

        result = self.llm.invoke(prompt)
        grade = result.content.strip().upper()
        if grade not in ("RELEVANT", "PARTIAL", "IRRELEVANT"):
            return "PARTIAL"
        return grade

    def retrieve_and_correct(self, query: str, k: int = 5) -> dict:
        """Retrieve, evaluate, and correct if needed."""
        docs = self.retriever.search(query, k=k)

        # Grade each document
        graded = []
        for doc in docs:
            grade = self.evaluate_relevance(query, doc["content"])
            doc["grade"] = grade
            graded.append(doc)

        relevant = [d for d in graded if d["grade"] == "RELEVANT"]
        partial = [d for d in graded if d["grade"] == "PARTIAL"]

        # Decision logic
        if len(relevant) >= 2:
            return {"action": "generate", "documents": relevant}
        elif relevant or partial:
            # Supplement with web search
            web_results = self.web_search(query, k=3)
            combined = relevant + partial + web_results
            return {"action": "generate_with_web", "documents": combined}
        else:
            # Full web search fallback
            web_results = self.web_search(query, k=5)
            return {"action": "web_fallback", "documents": web_results}
```

### Self-RAG

```python
class SelfRAG:
    """Self-reflective RAG with retrieval and generation evaluation."""

    def __init__(self, llm, retriever):
        self.llm = llm
        self.retriever = retriever

    def should_retrieve(self, query: str) -> bool:
        """Decide if retrieval is needed."""
        prompt = f"""Does this query require external knowledge to answer accurately?
        Query: {query}
        Answer YES or NO only."""
        result = self.llm.invoke(prompt)
        return "YES" in result.content.upper()

    def is_supported(self, response: str, documents: list[str]) -> bool:
        """Check if response is supported by retrieved documents."""
        context = "\n\n".join(documents)
        prompt = f"""Is the following response fully supported by the provided context?

        Context: {context}

        Response: {response}

        Answer YES if fully supported, NO if it contains unsupported claims."""
        result = self.llm.invoke(prompt)
        return "YES" in result.content.upper()

    def is_useful(self, query: str, response: str) -> bool:
        """Check if response actually answers the query."""
        prompt = f"""Does this response adequately answer the query?
        Query: {query}
        Response: {response}
        Answer YES or NO only."""
        result = self.llm.invoke(prompt)
        return "YES" in result.content.upper()

    def generate(self, query: str, max_attempts: int = 3) -> dict:
        """Generate with self-reflection loop."""
        if not self.should_retrieve(query):
            response = self.llm.invoke(query).content
            return {"response": response, "retrieval": False, "attempts": 1}

        documents = self.retriever.search(query, k=5)
        doc_texts = [d["content"] for d in documents]

        for attempt in range(max_attempts):
            context = "\n\n".join(doc_texts)
            prompt = f"""Answer the question using ONLY the provided context.
            If the context is insufficient, say so.

            Context: {context}

            Question: {query}"""

            response = self.llm.invoke(prompt).content

            if self.is_supported(response, doc_texts) and self.is_useful(query, response):
                return {
                    "response": response,
                    "documents": documents,
                    "retrieval": True,
                    "attempts": attempt + 1,
                }

        return {
            "response": response,
            "documents": documents,
            "retrieval": True,
            "attempts": max_attempts,
            "warning": "Response may not be fully grounded",
        }
```

---

## Citation and Grounding

```python
CITATION_PROMPT = """Answer the question using the provided sources.
Cite sources inline using [1], [2], etc.
Only use information from the provided sources.

Sources:
{sources}

Question: {query}

Provide your answer with inline citations:"""

def generate_with_citations(
    query: str,
    documents: list[dict],
    llm,
) -> dict:
    """Generate answer with source citations."""
    sources = "\n\n".join(
        f"[{i+1}] {doc['content']}"
        for i, doc in enumerate(documents)
    )

    response = llm.invoke(
        CITATION_PROMPT.format(sources=sources, query=query)
    ).content

    # Extract cited source indices
    import re
    cited = set(int(m) for m in re.findall(r'\[(\d+)\]', response))
    cited_docs = [documents[i-1] for i in cited if 0 < i <= len(documents)]

    return {
        "answer": response,
        "cited_sources": cited_docs,
        "total_sources": len(documents),
        "citation_count": len(cited),
    }
```

---

## Evaluation with RAGAS

```python
from ragas import evaluate
from ragas.metrics import (
    faithfulness,
    answer_relevancy,
    context_precision,
    context_recall,
)
from datasets import Dataset

def evaluate_rag(
    questions: list[str],
    answers: list[str],
    contexts: list[list[str]],
    ground_truths: list[str],
) -> dict:
    """Evaluate RAG pipeline with RAGAS metrics."""
    dataset = Dataset.from_dict({
        "question": questions,
        "answer": answers,
        "contexts": contexts,
        "ground_truth": ground_truths,
    })

    results = evaluate(
        dataset,
        metrics=[
            faithfulness,       # Is answer grounded in context?
            answer_relevancy,   # Does answer address the question?
            context_precision,  # Are relevant docs ranked higher?
            context_recall,     # Are all relevant docs retrieved?
        ],
    )

    return results

# Interpret results
# faithfulness > 0.8: Good grounding
# answer_relevancy > 0.8: Good answers
# context_precision > 0.7: Good ranking
# context_recall > 0.7: Good coverage
```

### RAGAS Metric Reference

| Metric | Measures | Good Score | Needs Ground Truth |
|--------|----------|-----------|-------------------|
| Faithfulness | Grounding in context | > 0.85 | No |
| Answer Relevancy | Answers the question | > 0.80 | No |
| Context Precision | Relevant docs ranked high | > 0.75 | Yes |
| Context Recall | All relevant docs found | > 0.70 | Yes |
| Answer Correctness | Factual accuracy | > 0.75 | Yes |
| Answer Similarity | Semantic match to reference | > 0.80 | Yes |

---

## Production Optimization

| Optimization | Impact | Effort |
|-------------|--------|--------|
| Add re-ranking | +10-20% relevance | Low |
| Hybrid search (BM25 + vector) | +5-15% recall | Medium |
| Query rewriting | +5-10% for ambiguous queries | Low |
| Parent-child retrieval | +10-15% context quality | Medium |
| Chunk size tuning | +5-15% precision | Low |
| Embedding model upgrade | +5-10% overall | Low |
| CRAG / Self-RAG | +15-25% accuracy | High |
| RAPTOR summaries | +10-20% for broad queries | High |

---

## EXIT CHECKLIST

- [ ] RAG maturity level identified and target level set
- [ ] Query processing pipeline configured (rewrite, expand, route)
- [ ] Retrieval strategy implemented (vector, hybrid, or agentic)
- [ ] Re-ranking integrated with appropriate model
- [ ] Citation/grounding mechanism in place
- [ ] Evaluation framework running (RAGAS or equivalent)
- [ ] Faithfulness score > 0.85, relevancy > 0.80
- [ ] Production optimizations applied based on bottleneck analysis

---

## Cross-References

- `2-design/embedding_pipeline_design` -- Embedding model and chunking choices
- `3-build/vector_database_operations` -- Vector DB setup for retrieval
- `3-build/ai_agent_development` -- Agentic RAG patterns
- `4-secure/ai_safety_guardrails` -- Preventing hallucination and injection

---

*Skill Version: 1.0 | Created: March 2026*
