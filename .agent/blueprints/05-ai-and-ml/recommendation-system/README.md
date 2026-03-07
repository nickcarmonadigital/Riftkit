# Blueprint: Recommendation System

Building recommendation engines: collaborative filtering, content-based filtering, hybrid approaches, real-time personalization, and ranking models for products, content, or users.

## Recommended Tech Stacks

| Stack | Best For |
|-------|----------|
| LightFM + Redis | Hybrid filtering, cold-start handling, medium scale |
| Surprise + scikit-learn | Prototyping, classical CF algorithms, research |
| TensorFlow Recommenders (TFRS) | Deep learning recommenders, two-tower models |
| Implicit + Annoy/FAISS | Implicit feedback (clicks/views), large-scale ANN retrieval |
| Recbole | Academic benchmarking, 70+ algorithms, standardized evaluation |
| AWS Personalize | Managed service, quick deployment, no ML expertise needed |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define recommendation context (what, to whom, when, why)
- **prd_generator** -- Document item catalog, user signals, business constraints
- **competitive_analysis** -- Benchmark existing recommendation quality, study Netflix/Spotify/Amazon patterns

Key scoping questions:
- What are you recommending? (Products, content, users, actions)
- What signals do you have? (Explicit ratings, implicit clicks/views/purchases, both)
- Cold-start problem: How do you recommend for new users/items with no history?
- Real-time or batch? (Pre-computed daily vs updated on each interaction)
- Business constraints: diversity, freshness, fairness, inventory limits

### Phase 2: Architecture
- **schema_design** -- User profiles, item features, interaction events, recommendation logs
- **api_design** -- Recommendation API, feedback ingestion, A/B experiment framework

Architecture patterns:
- **Two-stage**: Candidate generation (fast, broad) -> Ranking (accurate, narrow) -> Business rules filter
- **Batch**: Precompute recommendations offline -> Store in Redis/DB -> Serve from cache
- **Real-time**: User event -> Update features -> Retrieve candidates -> Rank -> Serve
- **Hybrid**: Multiple signal sources (CF + content + popularity) -> Ensemble/cascade

### Phase 3: Implementation
- **tdd_workflow** -- Test feature engineering, model output format, API response schema
- **error_handling** -- Fallback to popularity-based when personalization fails, handle missing features
- **code_review** -- Review for data leakage in offline evaluation, feature computation correctness

### Phase 4: Testing and Security
- **integration_testing** -- End-to-end: user event -> recommendation update -> API response
- **security_audit** -- User data privacy, recommendation manipulation prevention
- **load_testing** -- Recommendation latency under concurrent load, cache hit rates

### Phase 5: Deployment
- **ci_cd_pipeline** -- Model retraining schedule, A/B test framework, gradual rollout
- **deployment_patterns** -- Feature store + model serving, Redis caching layer
- **monitoring_setup** -- CTR, engagement lift, coverage, diversity, latency

## Key Domain-Specific Concerns

### Algorithm Selection

| Approach | Data Needed | Cold Start | Scalability | Best For |
|----------|------------|------------|-------------|----------|
| Popularity-based | Minimal | No problem | Excellent | Baseline, fallback |
| Content-based | Item features | Users only | Good | Similar items, cold items |
| User-based CF | User-item interactions | Items only | Poor (large user base) | Small communities |
| Item-based CF | User-item interactions | Users only | Good | E-commerce, "bought also bought" |
| Matrix Factorization (ALS/SVD) | User-item interactions | Neither | Good | Medium-scale, explicit ratings |
| Two-Tower Neural | Interactions + features | Both (with features) | Excellent | Large-scale, mixed signals |
| LLM-based | Text descriptions + interactions | Both | Moderate | Content-rich domains |

### Feature Engineering
- **User features**: Demographics, aggregated behavior (avg rating, genre preferences, recency)
- **Item features**: Category, tags, text embeddings, popularity score, freshness
- **Interaction features**: Time since last interaction, interaction count, session context
- **Context features**: Time of day, device, location, current page/query
- Recompute features on a schedule that matches your freshness SLA

### Offline Evaluation
- Split by time, not random: train on past, evaluate on future (temporal split)
- Metrics for ranking: NDCG@K, MAP@K, Hit Rate@K, MRR
- Metrics for rating prediction: RMSE, MAE (less useful than ranking metrics)
- Beyond accuracy: coverage (% of items recommended), diversity (intra-list distance), novelty
- Always compare against baselines: most-popular, random, previous model

### Online Evaluation (A/B Testing)
- Primary metric: business KPI (revenue, engagement, retention), not model accuracy
- Run for at least 2 weeks to capture weekly patterns
- Use interleaving for faster signal: mix recommendations from A and B in one list
- Track guardrail metrics: page load time, bounce rate, user complaints
- Segment results by user cohort (new vs returning, high vs low activity)

### Cold-Start Strategies
- **New users**: Start with popularity, then content-based from onboarding preferences, transition to CF after 5-10 interactions
- **New items**: Content-based similarity to existing items, boost in exploration slots
- **Exploration vs exploitation**: Reserve 10-20% of recommendation slots for exploration (epsilon-greedy or Thompson sampling)

### Production Considerations
- Cache recommendations in Redis with TTL matching your freshness SLA
- Implement fallback chain: personalized -> segment-based -> popularity -> curated
- Apply business rules post-ranking: remove already purchased, enforce diversity, boost promotions
- Log everything: what was recommended, what was shown, what was clicked (for offline eval)
- Retrain on a schedule: daily for fast-moving catalogs, weekly for stable ones

## Getting Started

1. **Audit your data** -- What user signals and item features do you have?
2. **Build a popularity baseline** -- "Most popular items" is a surprisingly strong baseline
3. **Implement content-based** -- Use item features to find similar items (no user history needed)
4. **Add collaborative filtering** -- Matrix factorization or item-based CF with interaction data
5. **Build the two-stage pipeline** -- Candidate retrieval (fast) + ranking (accurate)
6. **Set up offline evaluation** -- Temporal train/test split, NDCG@10 as primary metric
7. **Add real-time features** -- Recent user interactions for session-based personalization
8. **Implement A/B testing** -- Framework for comparing models in production
9. **Apply business rules** -- Diversity, freshness, inventory, promotion boosting
10. **Deploy with monitoring** -- CTR tracking, coverage dashboard, latency alerts

## Project Structure

```
src/
  data/
    interactions.py         # User-item interaction processing
    features.py             # Feature engineering (user, item, context)
    catalog.py              # Item catalog management
    splits.py               # Temporal train/test splitting
  models/
    popularity.py           # Popularity baseline
    content_based.py        # Content-based filtering
    collaborative.py        # Collaborative filtering (ALS, SVD)
    two_tower.py            # Neural two-tower model
    ranker.py               # Second-stage ranking model
    ensemble.py             # Multi-model blending
  retrieval/
    candidate_gen.py        # Fast candidate generation
    ann_index.py            # Approximate nearest neighbor (FAISS/Annoy)
    filters.py              # Business rule filtering
  serving/
    api.py                  # Recommendation API endpoint
    cache.py                # Redis caching layer
    fallback.py             # Fallback chain logic
  evaluation/
    offline.py              # NDCG, MAP, coverage, diversity metrics
    ab_test.py              # A/B test analysis
    logging.py              # Recommendation event logging
  features/
    feature_store.py        # Feature computation and storage
    real_time.py            # Real-time feature updates
config/
  models.yaml               # Model hyperparameters
  features.yaml             # Feature definitions
  business_rules.yaml       # Diversity, freshness, boost rules
```
