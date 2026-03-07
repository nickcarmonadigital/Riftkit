# Blueprint: RAG Application

Building Retrieval-Augmented Generation applications: document ingestion, chunking, embedding, vector storage, retrieval, and LLM-powered generation with source attribution.

## Recommended Tech Stacks

| Stack | Best For |
|-------|----------|
| LangChain + Pinecone/Weaviate + OpenAI | Full-featured RAG, broad integrations, rapid prototyping |
| LlamaIndex + Qdrant | Document-heavy RAG, structured data, advanced retrieval |
| Vercel AI SDK + pgvector | Full-stack RAG with PostgreSQL, no separate vector DB |
| Haystack + Elasticsearch | Enterprise search + RAG, BM25 hybrid retrieval |
| Custom (embeddings API + pgvector) | Maximum control, minimal dependencies, simple use cases |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define knowledge base scope, query types, accuracy requirements
- **prd_generator** -- Document source formats, update frequency, user access patterns
- **competitive_analysis** -- Evaluate vs full-text search, fine-tuning, or knowledge graphs

When RAG is the right choice:
- You need the LLM to answer using specific, up-to-date documents
- The knowledge base changes frequently (fine-tuning would be stale)
- You need source attribution (citations, page numbers)
- The domain is too large to fit in a single context window

### Phase 2: Architecture
- **schema_design** -- Document metadata schema, chunk storage, vector index configuration
- **api_design** -- Query API, document ingestion API, feedback/relevance API

Architecture patterns:
- **Naive RAG**: Query -> Embed -> Vector search -> Stuff into prompt -> Generate
- **Advanced RAG**: Query rewriting -> Hybrid search (vector + BM25) -> Reranking -> Generate
- **Agentic RAG**: Agent decides when to retrieve, what to query, iterates until satisfied
- **Graph RAG**: Knowledge graph + vector search for multi-hop reasoning

### Phase 3: Implementation
- **tdd_workflow** -- Test chunking logic, retrieval accuracy, response quality
- **error_handling** -- No results found, context window overflow, malformed documents
- **validation_patterns** -- Source document validation, embedding dimension checks

### Phase 4: Testing and Security
- **integration_testing** -- End-to-end: upload doc -> query -> verify answer cites source
- **security_audit** -- Document access control, prompt injection via documents, PII in chunks
- **load_testing** -- Concurrent queries, large document ingestion, vector search latency

### Phase 5: Deployment
- **ci_cd_pipeline** -- Document reindexing pipeline, embedding model versioning
- **deployment_patterns** -- Vector DB scaling, caching frequent queries, async ingestion
- **monitoring_setup** -- Retrieval relevance, answer quality, query latency, index freshness

## Key Domain-Specific Concerns

### Document Processing and Chunking
- Parse documents to structured text first: PDF (PyMuPDF/unstructured), DOCX, HTML, Markdown
- Chunk by semantic boundaries, not fixed character counts
- Recommended chunk sizes: 256-512 tokens for precise retrieval, 512-1024 for more context
- Overlap chunks by 10-20% to avoid splitting relevant passages
- Preserve metadata: source file, page number, section heading, last modified date
- Handle tables and images separately -- embed table text, describe images with vision models

### Chunking Strategy Guide

| Strategy | Pros | Cons | Best For |
|----------|------|------|----------|
| Fixed-size | Simple, predictable | Splits mid-sentence | Quick prototype |
| Recursive text split | Respects paragraph/sentence boundaries | May create uneven chunks | General documents |
| Semantic chunking | Groups related content | Slower, needs embedding | High-quality retrieval |
| Document-structure | Uses headings/sections | Requires structured docs | Technical documentation |
| Parent-child | Small chunks for search, large for context | Complex to implement | Long documents |

### Embedding Models

| Model | Dimensions | Quality | Speed | Cost |
|-------|-----------|---------|-------|------|
| OpenAI text-embedding-3-large | 3072 | Excellent | Fast | $0.13/1M tokens |
| OpenAI text-embedding-3-small | 1536 | Good | Fast | $0.02/1M tokens |
| Cohere embed-v3 | 1024 | Excellent | Fast | $0.10/1M tokens |
| BGE-large-en-v1.5 | 1024 | Good | Self-host | Free |
| GTE-Qwen2 | 1536 | Excellent | Self-host | Free |

### Retrieval Optimization
- Start with vector similarity search, then add BM25 keyword search (hybrid)
- Use a reranker (Cohere Rerank, cross-encoder) to reorder top-K results -- massive quality boost
- Implement query rewriting: expand abbreviations, add synonyms, decompose complex queries
- Retrieve more candidates (top-20) then rerank to top-5 for the prompt
- Add metadata filters: date range, document type, access level
- Cache embeddings for frequent queries

### Generation Quality
- Include source citations in the system prompt instructions
- Use the "closed-book" pattern: instruct the model to answer ONLY from provided context
- Structure retrieved chunks clearly in the prompt: numbered sources with metadata
- Implement answer grounding checks: does the answer actually come from the retrieved content?
- Handle "I don't know" gracefully -- better than hallucinating an answer

### Evaluation (RAG-specific)
- **Retrieval metrics**: Recall@K, MRR, NDCG -- are the right documents being found?
- **Generation metrics**: Faithfulness (no hallucination), relevance, completeness
- Use RAGAS or custom LLM-as-judge evaluations
- Build a golden test set: 50-100 question/answer/source-document triples
- Test adversarial queries: questions with no answer in the corpus, ambiguous queries

## Getting Started

1. **Define the knowledge base** -- What documents? How often do they change?
2. **Choose vector storage** -- pgvector (simple), Pinecone (managed), Qdrant (self-hosted)
3. **Set up document ingestion** -- Parse, chunk, embed, store pipeline
4. **Implement basic retrieval** -- Vector similarity search with top-K results
5. **Build the generation prompt** -- System prompt with retrieved context and citation instructions
6. **Add hybrid search** -- Combine vector + BM25 for better recall
7. **Add reranking** -- Cross-encoder or Cohere Rerank on top-K candidates
8. **Build evaluation set** -- Golden Q&A pairs for automated testing
9. **Add feedback loop** -- User thumbs up/down, track retrieval relevance
10. **Deploy with monitoring** -- Query latency, retrieval quality, generation faithfulness

## Project Structure

```
src/
  ingestion/
    parsers/
      pdf.py                # PDF text extraction
      html.py               # HTML cleaning
      docx.py               # Word document parsing
    chunker.py              # Chunking strategies
    embedder.py             # Embedding generation
    pipeline.py             # Full ingestion pipeline
  retrieval/
    vector_search.py        # Vector similarity search
    bm25_search.py          # Keyword search
    hybrid.py               # Combined retrieval
    reranker.py             # Cross-encoder reranking
    query_rewrite.py        # Query expansion/rewriting
  generation/
    prompt_builder.py       # Construct prompt with context
    generator.py            # LLM generation with citations
    grounding.py            # Answer grounding validation
  api/
    routes/
      query.py              # POST /query -- ask a question
      ingest.py             # POST /ingest -- add documents
      feedback.py           # POST /feedback -- user relevance feedback
    middleware/
      auth.py
  evaluation/
    eval_retrieval.py       # Retrieval metrics (recall, MRR)
    eval_generation.py      # Generation quality (faithfulness, relevance)
    golden_set.jsonl        # Test Q&A pairs
  db/
    schema.prisma           # Documents, chunks, feedback tables
    vector_ops.py           # pgvector operations
config/
  chunking.yaml             # Chunk size, overlap, strategy
  models.yaml               # Embedding model, LLM config
  sources.yaml              # Document sources and schedules
```
