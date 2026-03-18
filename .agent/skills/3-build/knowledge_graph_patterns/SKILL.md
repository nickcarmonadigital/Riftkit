---
name: Knowledge Graph Patterns
description: Graph database design, ontology modeling (RDF/OWL), GraphRAG retrieval, and graph-enhanced LLM pipelines using Neo4j, Neptune, and ArangoDB
triggers:
  - /knowledge-graph
  - /graph-rag
  - /ontology
---

# Knowledge Graph Patterns

## WHEN TO USE

- Building a knowledge graph from unstructured text or structured data sources
- Implementing GraphRAG to augment LLM retrieval with relational context
- Designing ontologies (RDF/OWL) for domain modeling or linked data
- Querying graph databases with Cypher or SPARQL for multi-hop reasoning
- Generating graph embeddings for downstream ML tasks (node classification, link prediction)

---

## PROCESS

1. **Select a graph database** based on workload shape:

   | Engine | Query Language | Best For |
   |--------|---------------|----------|
   | Neo4j | Cypher | General-purpose, mature ecosystem, APOC plugins |
   | Amazon Neptune | Gremlin / SPARQL | Managed AWS, RDF + property graph dual mode |
   | ArangoDB | AQL | Multi-model (doc + graph + search in one engine) |

2. **Design the ontology** — define node labels, relationship types, and property schemas:

   ```cypher
   // Neo4j schema example
   CREATE CONSTRAINT FOR (p:Person) REQUIRE p.id IS UNIQUE;
   CREATE CONSTRAINT FOR (o:Organization) REQUIRE o.id IS UNIQUE;
   CREATE INDEX FOR (d:Document) ON (d.published_at);
   ```

   For RDF/OWL ontologies, define classes and predicates in Turtle:
   ```turtle
   @prefix ex: <http://example.org/ontology#> .
   ex:Person a owl:Class .
   ex:worksFor a owl:ObjectProperty ;
       rdfs:domain ex:Person ;
       rdfs:range ex:Organization .
   ```

3. **Extract entities and relations from text** using an LLM or spaCy pipeline:

   ```python
   from langchain_experimental.graph_transformers import LLMGraphTransformer
   from langchain_openai import ChatOpenAI

   llm = ChatOpenAI(model="gpt-4o", temperature=0)
   transformer = LLMGraphTransformer(llm=llm)
   graph_documents = transformer.convert_to_graph_documents(documents)
   ```

4. **Load into the graph database**:

   ```python
   from langchain_community.graphs import Neo4jGraph

   graph = Neo4jGraph(url="bolt://localhost:7687", username="neo4j", password="password")
   graph.add_graph_documents(graph_documents, baseEntityLabel=True, include_source=True)
   ```

5. **Implement GraphRAG retrieval** — use Microsoft's GraphRAG or LangChain's graph chains:

   ```python
   from langchain.chains import GraphCypherQAChain

   chain = GraphCypherQAChain.from_llm(
       llm=llm,
       graph=graph,
       verbose=True,
       validate_cypher=True,
   )
   result = chain.invoke({"query": "Who are the founders of companies in the healthcare sector?"})
   ```

6. **Generate graph embeddings** for ML tasks:

   ```python
   # Node2Vec for graph embeddings
   from graspologic.embed import node2vec_embed
   import networkx as nx

   G = nx.from_pandas_edgelist(edges_df, "source", "target")
   embeddings, nodes = node2vec_embed(G, dimensions=128, walk_length=30, num_walks=200)
   ```

7. **Query with multi-hop Cypher** for complex reasoning:

   ```cypher
   // Find 2nd-degree connections through shared organizations
   MATCH (p1:Person)-[:WORKS_FOR]->(org:Organization)<-[:WORKS_FOR]-(p2:Person)
   WHERE p1.name = "Alice" AND p1 <> p2
   RETURN p2.name, org.name, count(*) AS shared_orgs
   ORDER BY shared_orgs DESC LIMIT 10
   ```

---

## CHECKLIST

- [ ] Graph database selected and provisioned (Neo4j/Neptune/ArangoDB)
- [ ] Ontology defined — node labels, relationship types, constraints, and indexes
- [ ] Entity and relation extraction pipeline tested on sample documents
- [ ] Knowledge graph loaded and queryable via Cypher or SPARQL
- [ ] GraphRAG chain validated — returns contextually grounded answers
- [ ] Graph embeddings generated if needed for downstream ML
- [ ] Query performance profiled (`EXPLAIN`/`PROFILE` in Cypher)
- [ ] Incremental ingestion pipeline handles new documents without full reload

---

## Related Skills

- `rag_advanced_patterns` — hybrid search, re-ranking, CRAG for retrieval augmentation
- `vector_database_operations` — vector stores that complement graph-based retrieval
