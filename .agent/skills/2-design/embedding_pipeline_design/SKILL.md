---
name: Embedding Pipeline Design
description: Design embedding pipelines with model selection, chunking strategies, dimension reduction, and batch processing
---

# Embedding Pipeline Design Skill

**Purpose**: Guide the design of production embedding pipelines covering model selection, text chunking, batch processing, and optimization for downstream retrieval and similarity tasks.

---

## TRIGGER COMMANDS

```text
"Choose an embedding model"
"Design a chunking strategy for RAG"
"Set up an embedding pipeline"
"Compare embedding models for my use case"
"Using embedding_pipeline_design skill: [task]"
```

---

## Embedding Model Selection

### Model Comparison Table (2025-2026)

| Model | Dims | Max Tokens | MTEB Avg | Multilingual | Cost (1M tokens) | Latency |
|-------|------|-----------|----------|-------------|-------------------|---------|
| text-embedding-3-large | 3072 | 8191 | 64.6 | Yes | $0.13 | Fast |
| text-embedding-3-small | 1536 | 8191 | 62.3 | Yes | $0.02 | Fast |
| voyage-3-large | 1024 | 32000 | 67.2 | Yes | $0.18 | Fast |
| voyage-3 | 1024 | 32000 | 65.1 | Yes | $0.06 | Fast |
| Cohere embed-v4 | 1024 | 512 | 66.3 | 100+ langs | $0.10 | Fast |
| BGE-M3 | 1024 | 8192 | 65.0 | 100+ langs | Free (local) | Medium |
| E5-Mistral-7B | 4096 | 32768 | 66.6 | Yes | Free (local) | Slow |
| GTE-Qwen2-7B | 3584 | 32768 | 67.1 | Yes | Free (local) | Slow |
| nomic-embed-text-v1.5 | 768 | 8192 | 62.3 | English | Free (local) | Fast |
| all-MiniLM-L6-v2 | 384 | 256 | 56.3 | English | Free (local) | Very Fast |
| mxbai-embed-large | 1024 | 512 | 64.7 | English | Free (local) | Fast |

### Selection Decision Tree

```
START: What are your constraints?
  |
  +-- Need API simplicity + good quality?
  |     +-- Budget-sensitive --> text-embedding-3-small ($0.02/1M)
  |     +-- Quality-focused --> voyage-3-large or text-embedding-3-large
  |
  +-- Need local/self-hosted?
  |     +-- Fast + small footprint --> nomic-embed-text-v1.5
  |     +-- Maximum quality --> GTE-Qwen2-7B or E5-Mistral-7B
  |     +-- Multilingual --> BGE-M3
  |     +-- Minimal resources --> all-MiniLM-L6-v2
  |
  +-- Need multilingual?
  |     +-- API --> Cohere embed-v4
  |     +-- Local --> BGE-M3
  |
  +-- Long documents (>8K tokens)?
        --> voyage-3 (32K) or E5-Mistral-7B (32K)
```

### Matryoshka (Variable Dimension) Embeddings

Some models support truncating dimensions with minimal quality loss:

| Model | Full Dims | 512d Quality | 256d Quality | 128d Quality |
|-------|----------|-------------|-------------|-------------|
| text-embedding-3-large | 3072 (100%) | 97% | 94% | 89% |
| text-embedding-3-small | 1536 (100%) | 96% | 92% | 86% |
| nomic-embed-text-v1.5 | 768 (100%) | 98% | 95% | 90% |

```python
from openai import OpenAI

client = OpenAI()

# Generate with reduced dimensions (saves storage + faster search)
response = client.embeddings.create(
    input="Your text here",
    model="text-embedding-3-large",
    dimensions=512,  # Truncate from 3072 to 512
)
embedding = response.data[0].embedding  # len = 512
```

---

## Chunking Strategies

### Strategy Comparison

| Strategy | Pros | Cons | Best For |
|----------|------|------|----------|
| Fixed size | Simple, predictable | Breaks mid-sentence | Uniform docs |
| Recursive character | Respects structure | Needs separator tuning | General text |
| Sentence-based | Clean boundaries | Short chunks | Dialogue, Q&A |
| Semantic | Best retrieval quality | Slowest, needs model | RAG pipelines |
| Document-aware | Preserves structure | Format-specific | Markdown, HTML, code |
| Sliding window | Overlap prevents loss | Duplicate content | Long documents |

### Chunk Size Guidelines

| Use Case | Chunk Size | Overlap | Rationale |
|----------|-----------|---------|-----------|
| FAQ / Q&A | 200-500 tokens | 0 | One answer per chunk |
| Technical docs | 500-1000 tokens | 100-200 | Balance context + precision |
| Legal / contracts | 1000-1500 tokens | 200-300 | Preserve clause context |
| Code | Function/class level | 0 | Natural boundaries |
| Chat logs | Per message or turn | 0 | Natural boundaries |
| Research papers | 500-800 tokens | 100 | Section-aware splitting |

### Implementation Examples

**Recursive Character Splitting (LangChain)**:

```python
from langchain_text_splitters import RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separators=["\n\n", "\n", ". ", " ", ""],
    length_function=len,
)

chunks = splitter.split_text(document_text)
```

**Semantic Chunking**:

```python
from langchain_experimental.text_splitter import SemanticChunker
from langchain_openai import OpenAIEmbeddings

embeddings = OpenAIEmbeddings(model="text-embedding-3-small")

chunker = SemanticChunker(
    embeddings,
    breakpoint_threshold_type="percentile",
    breakpoint_threshold_amount=95,
)

chunks = chunker.split_text(document_text)
```

**Document-Aware Splitting (Markdown)**:

```python
from langchain_text_splitters import MarkdownHeaderTextSplitter

headers_to_split_on = [
    ("#", "h1"),
    ("##", "h2"),
    ("###", "h3"),
]

splitter = MarkdownHeaderTextSplitter(
    headers_to_split_on=headers_to_split_on,
    strip_headers=False,
)

chunks = splitter.split_text(markdown_text)
# Each chunk includes header metadata for filtering
```

**Code-Aware Splitting**:

```python
from langchain_text_splitters import Language, RecursiveCharacterTextSplitter

python_splitter = RecursiveCharacterTextSplitter.from_language(
    language=Language.PYTHON,
    chunk_size=1000,
    chunk_overlap=100,
)

chunks = python_splitter.split_text(python_code)
```

### Chunk Enrichment

Add context to chunks to improve retrieval:

```python
def enrich_chunk(chunk: str, doc_title: str, section: str, index: int) -> str:
    """Prepend contextual information to a chunk."""
    prefix = f"Document: {doc_title}\nSection: {section}\nChunk {index + 1}\n\n"
    return prefix + chunk

def add_summary_context(chunks: list[str], summarizer) -> list[str]:
    """Add document summary to each chunk."""
    full_text = " ".join(chunks)
    summary = summarizer(full_text[:3000])

    return [
        f"Document Summary: {summary}\n\n---\n\n{chunk}"
        for chunk in chunks
    ]
```

---

## Batch Processing Pipeline

### Production Pipeline Architecture

```
+----------+    +----------+    +----------+    +----------+
| Document |    | Chunking |    | Embedding|    | Vector   |
| Loader   | -> | Engine   | -> | Service  | -> | Database |
+----------+    +----------+    +----------+    +----------+
     |               |               |               |
  PDF/HTML/MD    Split + Enrich   Batch API      Upsert
  extraction     with metadata    with retry     with index
```

### Batch Embedding with Rate Limiting

```python
import asyncio
import time
from openai import AsyncOpenAI

client = AsyncOpenAI()

async def embed_batch(
    texts: list[str],
    model: str = "text-embedding-3-small",
    batch_size: int = 100,
    max_concurrent: int = 5,
    dimensions: int = None,
) -> list[list[float]]:
    """Embed texts in batches with concurrency control."""
    semaphore = asyncio.Semaphore(max_concurrent)
    all_embeddings = [None] * len(texts)

    async def process_batch(start_idx: int, batch: list[str]):
        async with semaphore:
            kwargs = {"input": batch, "model": model}
            if dimensions:
                kwargs["dimensions"] = dimensions

            for attempt in range(3):
                try:
                    response = await client.embeddings.create(**kwargs)
                    for j, item in enumerate(response.data):
                        all_embeddings[start_idx + j] = item.embedding
                    return
                except Exception as e:
                    if attempt == 2:
                        raise
                    await asyncio.sleep(2 ** attempt)

    tasks = []
    for i in range(0, len(texts), batch_size):
        batch = texts[i:i + batch_size]
        tasks.append(process_batch(i, batch))

    await asyncio.gather(*tasks)
    return all_embeddings
```

### Local Embedding with Sentence Transformers

```python
from sentence_transformers import SentenceTransformer
import numpy as np

model = SentenceTransformer("BAAI/bge-large-en-v1.5")

def embed_local(
    texts: list[str],
    batch_size: int = 32,
    normalize: bool = True,
    show_progress: bool = True,
) -> np.ndarray:
    """Embed texts locally with sentence-transformers."""
    embeddings = model.encode(
        texts,
        batch_size=batch_size,
        normalize_embeddings=normalize,
        show_progress_bar=show_progress,
        convert_to_numpy=True,
    )
    return embeddings
```

---

## Dimension Reduction

### When to Reduce Dimensions

| Scenario | Recommendation |
|----------|---------------|
| Storage-constrained | Use Matryoshka truncation first |
| Millions of vectors | PCA or Matryoshka to 256-512d |
| Latency-sensitive search | Reduce to 256-512d |
| High-quality required | Keep full dimensions |
| Prototype/testing | Use smaller model instead |

### PCA Reduction

```python
from sklearn.decomposition import PCA
import numpy as np

def reduce_dimensions(
    embeddings: np.ndarray,
    target_dims: int = 256,
    fit_sample: int = 10000,
) -> tuple[np.ndarray, PCA]:
    """Reduce embedding dimensions with PCA."""
    # Fit on a sample for efficiency
    if len(embeddings) > fit_sample:
        sample_idx = np.random.choice(len(embeddings), fit_sample, replace=False)
        fit_data = embeddings[sample_idx]
    else:
        fit_data = embeddings

    pca = PCA(n_components=target_dims)
    pca.fit(fit_data)

    reduced = pca.transform(embeddings)

    # Normalize after reduction
    norms = np.linalg.norm(reduced, axis=1, keepdims=True)
    reduced = reduced / norms

    explained = sum(pca.explained_variance_ratio_)
    print(f"Explained variance: {explained:.2%} with {target_dims} dims")

    return reduced, pca
```

---

## Evaluation

### Retrieval Quality Metrics

```python
def evaluate_retrieval(
    queries: list[str],
    ground_truth: list[list[str]],
    search_fn,
    k: int = 10,
) -> dict:
    """Evaluate retrieval quality."""
    hits_at_k = 0
    mrr_sum = 0
    ndcg_sum = 0

    for query, relevant_ids in zip(queries, ground_truth):
        results = search_fn(query, k=k)
        result_ids = [r["id"] for r in results]

        # Hit@K
        if any(rid in relevant_ids for rid in result_ids):
            hits_at_k += 1

        # MRR
        for rank, rid in enumerate(result_ids, 1):
            if rid in relevant_ids:
                mrr_sum += 1 / rank
                break

    n = len(queries)
    return {
        "hit_rate@k": hits_at_k / n,
        "mrr@k": mrr_sum / n,
    }
```

---

## EXIT CHECKLIST

- [ ] Embedding model selected based on quality, cost, and latency requirements
- [ ] Chunking strategy chosen and tested on representative documents
- [ ] Chunk sizes validated (not too small for context, not too large for precision)
- [ ] Batch processing pipeline implemented with rate limiting and retries
- [ ] Dimension reduction evaluated if storage/latency constrained
- [ ] Retrieval quality measured with hit rate and MRR on test queries
- [ ] Pipeline handles all input document formats (PDF, HTML, Markdown, code)
- [ ] Embedding model versioning strategy defined for future upgrades

---

## Cross-References

- `3-build/vector_database_operations` -- Storing and searching embeddings
- `3-build/rag_advanced_patterns` -- Using embeddings in RAG systems
- `3-build/lora_finetuning_workflow` -- Fine-tuning embedding models

---

*Skill Version: 1.0 | Created: March 2026*
