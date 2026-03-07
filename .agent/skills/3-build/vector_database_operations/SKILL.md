---
name: Vector Database Operations
description: Vector DB operations with pgvector, Pinecone, Weaviate, Qdrant, ChromaDB, and Milvus including indexing, search, filtering, and scaling
---

# Vector Database Operations Skill

**Purpose**: Provide practical guidance for selecting, configuring, and operating vector databases for similarity search, RAG, recommendation, and anomaly detection workloads.

---

## TRIGGER COMMANDS

```text
"Set up a vector database"
"Choose between pgvector and Pinecone"
"Optimize vector search performance"
"Implement hybrid search with filtering"
"Using vector_database_operations skill: [task]"
```

---

## Vector Database Selection Matrix

| Database | Type | Max Vectors | Filtering | Hybrid Search | Managed | Open Source | Best For |
|----------|------|-------------|-----------|---------------|---------|-------------|----------|
| pgvector | Extension | 10M+ | SQL | BM25 + vector | Via cloud PG | Yes | Existing Postgres |
| Pinecone | Managed | Billions | Metadata | Sparse-dense | Yes | No | Zero-ops, scale |
| Weaviate | Dedicated | Billions | GraphQL | BM25 + vector | Yes | Yes | Multi-modal |
| Qdrant | Dedicated | Billions | Payload | Sparse vectors | Yes | Yes | Performance |
| ChromaDB | Embedded | Millions | Metadata | No | No | Yes | Prototyping |
| Milvus | Dedicated | Billions | Attribute | Sparse-dense | Yes (Zilliz) | Yes | Large scale |
| Redis VSS | Extension | Millions | Tag-based | Limited | Yes | Yes | Existing Redis |

### Decision Flowchart

```
START: What are your requirements?
  |
  +-- Prototyping / Small data (< 100K vectors)
  |     --> ChromaDB (zero config, in-process)
  |
  +-- Already using PostgreSQL?
  |     +-- < 5M vectors --> pgvector (minimal ops overhead)
  |     +-- > 5M vectors --> Dedicated vector DB
  |
  +-- Need zero ops / fully managed?
  |     --> Pinecone (serverless or pod-based)
  |
  +-- Need maximum performance?
  |     --> Qdrant (best filtering + quantization)
  |
  +-- Multi-modal (text + image + audio)?
  |     --> Weaviate (native multi-modal)
  |
  +-- Massive scale (1B+ vectors)?
        --> Milvus / Zilliz Cloud
```

---

## Index Type Reference

| Index | Build Time | Query Time | Memory | Recall | Best For |
|-------|-----------|------------|--------|--------|----------|
| Flat (brute force) | O(1) | O(n) | Low | 100% | < 10K vectors |
| IVF-Flat | Medium | O(sqrt(n)) | Medium | 95-99% | 10K-1M vectors |
| IVF-PQ | Medium | O(sqrt(n)) | Low | 90-95% | 1M+ memory-constrained |
| HNSW | Slow | O(log(n)) | High | 97-99.9% | General purpose |
| HNSW-PQ | Slow | O(log(n)) | Medium | 95-98% | Large datasets |
| DiskANN | Slow | O(log(n)) | Low (disk) | 95-99% | Disk-based scale |
| ScaNN | Medium | O(log(n)) | Medium | 97-99% | Google ecosystem |

### Distance Metrics

| Metric | Formula | Range | Use Case |
|--------|---------|-------|----------|
| Cosine | 1 - cos(a,b) | [0, 2] | Text embeddings (normalized) |
| L2 (Euclidean) | sqrt(sum((a-b)^2)) | [0, inf) | Image features |
| Inner Product | -dot(a,b) | (-inf, inf) | Recommendation |
| Hamming | popcount(a XOR b) | [0, dims] | Binary hashes |

> **Rule of thumb**: Use cosine similarity for text embeddings. Most embedding models output normalized vectors, making cosine equivalent to inner product.

---

## pgvector Setup and Operations

### Installation and Setup

```sql
-- Enable extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create table with vector column
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    embedding vector(1536),  -- OpenAI text-embedding-3-small dimension
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create HNSW index (recommended for most use cases)
CREATE INDEX ON documents
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 200);

-- Alternative: IVF index (faster build, lower recall)
CREATE INDEX ON documents
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);  -- sqrt(num_vectors) as starting point
```

### HNSW Tuning Parameters

| Parameter | Default | Description | Tuning |
|-----------|---------|-------------|--------|
| `m` | 16 | Max connections per node | Higher = better recall, more memory |
| `ef_construction` | 64 | Build-time search width | Higher = better index, slower build |
| `ef_search` | 40 | Query-time search width | Higher = better recall, slower query |

```sql
-- Tune query-time parameter
SET hnsw.ef_search = 100;  -- Increase for better recall

-- Check index build progress
SELECT phase, blocks_done, blocks_total
FROM pg_stat_progress_create_index;
```

### Search Queries

```sql
-- Basic similarity search
SELECT id, content, 1 - (embedding <=> $1::vector) AS similarity
FROM documents
ORDER BY embedding <=> $1::vector
LIMIT 10;

-- Filtered search (metadata + similarity)
SELECT id, content, 1 - (embedding <=> $1::vector) AS similarity
FROM documents
WHERE metadata->>'category' = 'technical'
  AND created_at > NOW() - INTERVAL '30 days'
ORDER BY embedding <=> $1::vector
LIMIT 10;

-- Hybrid search (BM25 + vector) using ts_rank
SELECT id, content,
    0.7 * (1 - (embedding <=> $1::vector)) +
    0.3 * ts_rank(to_tsvector('english', content), plainto_tsquery('english', $2))
    AS combined_score
FROM documents
WHERE to_tsvector('english', content) @@ plainto_tsquery('english', $2)
ORDER BY combined_score DESC
LIMIT 10;
```

### Python Integration

```python
import psycopg
from pgvector.psycopg import register_vector

conn = psycopg.connect("postgresql://user:pass@localhost/mydb")
register_vector(conn)

def upsert_document(conn, doc_id, content, embedding, metadata=None):
    """Insert or update a document with its embedding."""
    conn.execute(
        """
        INSERT INTO documents (id, content, embedding, metadata)
        VALUES (%s, %s, %s::vector, %s::jsonb)
        ON CONFLICT (id) DO UPDATE SET
            content = EXCLUDED.content,
            embedding = EXCLUDED.embedding,
            metadata = EXCLUDED.metadata
        """,
        (doc_id, content, embedding, json.dumps(metadata or {})),
    )
    conn.commit()

def search_similar(conn, query_embedding, limit=10, min_similarity=0.7):
    """Search for similar documents."""
    rows = conn.execute(
        """
        SELECT id, content, metadata,
               1 - (embedding <=> %s::vector) AS similarity
        FROM documents
        WHERE 1 - (embedding <=> %s::vector) > %s
        ORDER BY embedding <=> %s::vector
        LIMIT %s
        """,
        (query_embedding, query_embedding, min_similarity, query_embedding, limit),
    ).fetchall()
    return [
        {"id": r[0], "content": r[1], "metadata": r[2], "similarity": float(r[3])}
        for r in rows
    ]
```

---

## Qdrant Operations

### Setup and Collection Creation

```python
from qdrant_client import QdrantClient
from qdrant_client.models import (
    Distance, VectorParams, PointStruct,
    Filter, FieldCondition, MatchValue, Range,
    OptimizersConfigDiff, HnswConfigDiff,
    QuantizationConfig, ScalarQuantization, ScalarType,
)

client = QdrantClient(host="localhost", port=6333)

# Create collection with quantization
client.create_collection(
    collection_name="documents",
    vectors_config=VectorParams(
        size=1536,
        distance=Distance.COSINE,
        on_disk=False,
    ),
    hnsw_config=HnswConfigDiff(
        m=16,
        ef_construct=200,
        full_scan_threshold=10000,
    ),
    quantization_config=ScalarQuantization(
        scalar=ScalarQuantization(
            type=ScalarType.INT8,
            quantile=0.99,
            always_ram=True,
        )
    ),
    optimizers_config=OptimizersConfigDiff(
        indexing_threshold=20000,
    ),
)
```

### Batch Upsert

```python
def batch_upsert(client, collection, points, batch_size=100):
    """Upsert points in batches."""
    for i in range(0, len(points), batch_size):
        batch = points[i:i + batch_size]
        client.upsert(
            collection_name=collection,
            points=[
                PointStruct(
                    id=p["id"],
                    vector=p["embedding"],
                    payload=p["metadata"],
                )
                for p in batch
            ],
        )
```

### Filtered Search

```python
results = client.search(
    collection_name="documents",
    query_vector=query_embedding,
    query_filter=Filter(
        must=[
            FieldCondition(key="category", match=MatchValue(value="technical")),
            FieldCondition(key="year", range=Range(gte=2024)),
        ],
        must_not=[
            FieldCondition(key="status", match=MatchValue(value="archived")),
        ],
    ),
    limit=10,
    with_payload=True,
    score_threshold=0.7,
)
```

---

## Pinecone Operations

### Setup and Index Creation

```python
from pinecone import Pinecone, ServerlessSpec

pc = Pinecone(api_key="your-api-key")

# Create serverless index
pc.create_index(
    name="documents",
    dimension=1536,
    metric="cosine",
    spec=ServerlessSpec(cloud="aws", region="us-east-1"),
)

index = pc.Index("documents")
```

### Upsert and Query

```python
# Batch upsert with metadata
vectors = [
    {
        "id": f"doc-{i}",
        "values": embedding,
        "metadata": {
            "category": "technical",
            "source": "arxiv",
            "year": 2025,
            "text": content[:1000],  # Store truncated text
        },
    }
    for i, (embedding, content) in enumerate(zip(embeddings, contents))
]

# Upsert in batches of 100
for i in range(0, len(vectors), 100):
    index.upsert(vectors=vectors[i:i + 100])

# Query with metadata filter
results = index.query(
    vector=query_embedding,
    top_k=10,
    include_metadata=True,
    filter={
        "category": {"$eq": "technical"},
        "year": {"$gte": 2024},
    },
)
```

---

## ChromaDB (Prototyping)

```python
import chromadb

client = chromadb.PersistentClient(path="./chroma_db")

collection = client.get_or_create_collection(
    name="documents",
    metadata={"hnsw:space": "cosine"},
)

# Add documents (auto-embeds if embedding function set)
collection.add(
    ids=["doc-1", "doc-2"],
    documents=["First document text", "Second document text"],
    embeddings=[embedding_1, embedding_2],
    metadatas=[{"source": "web"}, {"source": "pdf"}],
)

# Query
results = collection.query(
    query_embeddings=[query_embedding],
    n_results=5,
    where={"source": "web"},
    include=["documents", "metadatas", "distances"],
)
```

---

## Performance Optimization

### Indexing Best Practices

| Data Size | Recommended Index | HNSW m | ef_construction | Expected Recall |
|-----------|------------------|--------|-----------------|----------------|
| < 10K | Flat (no index) | - | - | 100% |
| 10K-100K | HNSW | 16 | 100 | 98%+ |
| 100K-1M | HNSW + quantization | 16 | 200 | 97%+ |
| 1M-10M | HNSW + PQ | 32 | 256 | 95%+ |
| 10M+ | Sharded HNSW | 32 | 256 | 95%+ |

### Memory Estimation

```
Memory per vector (HNSW, no quantization):
  = (dimensions * 4 bytes) + (m * 2 * 8 bytes) + overhead
  = (1536 * 4) + (16 * 2 * 8) + 64
  = 6,144 + 256 + 64
  = ~6.4 KB per vector

1M vectors = ~6.4 GB RAM
10M vectors = ~64 GB RAM

With INT8 scalar quantization:
  = (dimensions * 1 byte) + (m * 2 * 8 bytes) + overhead
  = 1,536 + 256 + 64
  = ~1.8 KB per vector

1M vectors = ~1.8 GB RAM (72% reduction)
```

### Batch Processing Pipeline

```python
import asyncio
from concurrent.futures import ThreadPoolExecutor

async def ingest_documents(
    documents: list[dict],
    embed_fn,
    db_client,
    batch_size: int = 100,
    max_concurrent: int = 4,
):
    """Parallel document ingestion pipeline."""
    semaphore = asyncio.Semaphore(max_concurrent)

    async def process_batch(batch):
        async with semaphore:
            texts = [d["content"] for d in batch]
            embeddings = await asyncio.to_thread(embed_fn, texts)

            points = [
                {
                    "id": d["id"],
                    "embedding": emb,
                    "metadata": d.get("metadata", {}),
                }
                for d, emb in zip(batch, embeddings)
            ]
            await asyncio.to_thread(batch_upsert, db_client, "documents", points)

    batches = [
        documents[i:i + batch_size]
        for i in range(0, len(documents), batch_size)
    ]

    await asyncio.gather(*[process_batch(b) for b in batches])
```

---

## Hybrid Search Implementation

### Reciprocal Rank Fusion (RRF)

```python
def reciprocal_rank_fusion(
    result_lists: list[list[dict]],
    k: int = 60,
    limit: int = 10,
) -> list[dict]:
    """Combine multiple ranked lists using RRF."""
    scores = {}

    for results in result_lists:
        for rank, result in enumerate(results):
            doc_id = result["id"]
            if doc_id not in scores:
                scores[doc_id] = {"doc": result, "score": 0}
            scores[doc_id]["score"] += 1 / (k + rank + 1)

    ranked = sorted(scores.values(), key=lambda x: x["score"], reverse=True)
    return [item["doc"] | {"rrf_score": item["score"]} for item in ranked[:limit]]

# Usage: combine vector search + keyword search
vector_results = vector_search(query_embedding, limit=20)
keyword_results = keyword_search(query_text, limit=20)
combined = reciprocal_rank_fusion([vector_results, keyword_results])
```

---

## Monitoring and Maintenance

### Key Metrics

| Metric | Healthy Range | Action if Out of Range |
|--------|--------------|----------------------|
| Query latency p50 | < 10ms | Check index, increase ef_search |
| Query latency p99 | < 100ms | Add replicas, optimize filters |
| Recall@10 | > 95% | Increase HNSW m/ef, rebuild index |
| Index build time | < 1hr per 1M | Increase RAM, parallel build |
| Memory usage | < 80% capacity | Add nodes or enable quantization |
| Insert throughput | > 1K/sec | Batch inserts, async pipeline |

### Health Check Script

```python
def check_vector_db_health(client, collection: str) -> dict:
    """Check vector database health metrics."""
    info = client.get_collection(collection)
    return {
        "collection": collection,
        "vector_count": info.points_count,
        "indexed": info.indexed_vectors_count,
        "index_healthy": info.indexed_vectors_count >= info.points_count * 0.99,
        "status": info.status,
    }
```

---

## EXIT CHECKLIST

- [ ] Vector database selected based on scale, existing infra, and requirements
- [ ] Index type and parameters configured for target recall/latency
- [ ] Distance metric matches embedding model output (cosine for normalized)
- [ ] Batch ingestion pipeline implemented and tested
- [ ] Filtered search working with metadata constraints
- [ ] Hybrid search configured if keyword matching needed
- [ ] Memory usage estimated and capacity planned
- [ ] Monitoring and alerting configured for latency and recall

---

## Cross-References

- `2-design/embedding_pipeline_design` -- Choosing embeddings and chunking
- `3-build/rag_advanced_patterns` -- Using vector DBs in RAG pipelines
- `3-build/ai_agent_development` -- Vector DB as agent memory store

---

*Skill Version: 1.0 | Created: March 2026*
