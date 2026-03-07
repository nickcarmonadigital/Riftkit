---
name: Caching Strategies
description: Caching with Redis, Memcached, and CDN covering cache invalidation, write-through, write-behind, and cache-aside patterns
---

# Caching Strategies Skill

**Purpose**: Design and implement caching layers using Redis, Memcached, and CDN to reduce latency, lower database load, and improve throughput with proper invalidation and consistency patterns.

---

## TRIGGER COMMANDS

```text
"Add caching to this service"
"Set up Redis caching"
"Cache invalidation strategy"
"Configure CDN caching"
"Using caching_strategies skill: [task]"
```

---

## Caching Patterns

### Pattern Comparison

| Pattern | Description | Consistency | Complexity | Use Case |
|---------|-------------|-------------|------------|----------|
| Cache-Aside | App manages cache reads/writes | Eventual | Low | General purpose |
| Read-Through | Cache loads from DB on miss | Eventual | Medium | Read-heavy |
| Write-Through | Write to cache + DB synchronously | Strong | Medium | Write consistency critical |
| Write-Behind | Write to cache, async DB write | Eventual | High | High write throughput |
| Refresh-Ahead | Pre-load before expiry | Near-real-time | Medium | Predictable access |

### Cache-Aside (Most Common)

```python
import redis
import json
from typing import Optional

cache = redis.Redis(host="redis", port=6379, decode_responses=True)

def get_user(user_id: str) -> dict:
    # 1. Check cache
    cached = cache.get(f"user:{user_id}")
    if cached:
        return json.loads(cached)

    # 2. Cache miss - load from DB
    user = db.query("SELECT * FROM users WHERE id = %s", user_id)
    if user is None:
        # Cache negative result to prevent cache penetration
        cache.setex(f"user:{user_id}", 60, json.dumps(None))
        return None

    # 3. Populate cache
    cache.setex(f"user:{user_id}", 3600, json.dumps(user))
    return user

def update_user(user_id: str, data: dict):
    # 1. Update DB
    db.execute("UPDATE users SET name = %s WHERE id = %s", data["name"], user_id)

    # 2. Invalidate cache (not update - avoids race conditions)
    cache.delete(f"user:{user_id}")
```

### Write-Through

```python
def update_user_write_through(user_id: str, data: dict):
    # 1. Write to cache
    cache.setex(f"user:{user_id}", 3600, json.dumps(data))

    # 2. Write to DB (synchronous)
    db.execute("UPDATE users SET name = %s WHERE id = %s", data["name"], user_id)
    # If DB write fails, cache is stale - need compensating logic
```

### Write-Behind (Write-Back)

```python
import asyncio

write_buffer = asyncio.Queue()

def update_user_write_behind(user_id: str, data: dict):
    # 1. Write to cache (immediate)
    cache.setex(f"user:{user_id}", 3600, json.dumps(data))

    # 2. Queue DB write (async)
    write_buffer.put_nowait({
        "operation": "UPDATE",
        "table": "users",
        "key": user_id,
        "data": data,
    })

async def flush_writes():
    """Background task that batches and writes to DB."""
    batch = []
    while True:
        try:
            item = await asyncio.wait_for(write_buffer.get(), timeout=1.0)
            batch.append(item)
            if len(batch) >= 100:
                await db.execute_batch(batch)
                batch.clear()
        except asyncio.TimeoutError:
            if batch:
                await db.execute_batch(batch)
                batch.clear()
```

---

## Redis

### Data Structures for Caching

| Structure | Use Case | Example |
|-----------|----------|---------|
| String | Simple key-value | Session data, serialized objects |
| Hash | Object fields | User profile (name, email, role) |
| Sorted Set | Leaderboards, rate limiting | Top products by score |
| List | Recent items, queues | Recent activity feed |
| Set | Unique collections | Online users, tags |
| HyperLogLog | Cardinality estimation | Unique visitors count |

### Redis Configuration

```python
import redis
from redis.backoff import ExponentialBackoff
from redis.retry import Retry

pool = redis.ConnectionPool(
    host="redis",
    port=6379,
    db=0,
    max_connections=50,
    decode_responses=True,
    socket_connect_timeout=5,
    socket_timeout=5,
    retry_on_timeout=True,
    retry=Retry(ExponentialBackoff(), retries=3),
    health_check_interval=30,
)

cache = redis.Redis(connection_pool=pool)
```

### Redis Cluster (Production)

```python
from redis.cluster import RedisCluster

cache = RedisCluster(
    startup_nodes=[
        {"host": "redis-1", "port": 6379},
        {"host": "redis-2", "port": 6379},
        {"host": "redis-3", "port": 6379},
    ],
    decode_responses=True,
    skip_full_coverage_check=True,
)
```

### Common Redis Patterns

```python
# Pipeline (batch operations)
pipe = cache.pipeline()
pipe.get("user:1")
pipe.get("user:2")
pipe.get("user:3")
results = pipe.execute()

# Distributed lock
lock = cache.lock("process:daily-report", timeout=300, blocking_timeout=10)
if lock.acquire():
    try:
        run_daily_report()
    finally:
        lock.release()

# Rate limiter (sliding window)
def is_rate_limited(user_id: str, limit: int = 100, window: int = 60) -> bool:
    key = f"ratelimit:{user_id}"
    now = time.time()
    pipe = cache.pipeline()
    pipe.zremrangebyscore(key, 0, now - window)
    pipe.zadd(key, {str(now): now})
    pipe.zcard(key)
    pipe.expire(key, window)
    results = pipe.execute()
    return results[2] > limit
```

---

## Cache Invalidation

### Invalidation Strategies

| Strategy | Consistency | Complexity | Description |
|----------|-------------|------------|-------------|
| TTL-based | Eventual (within TTL) | Low | Set expiry, let it expire |
| Event-driven | Near-real-time | Medium | Invalidate on DB change event |
| Write-through | Strong | Medium | Update cache on every write |
| Version-based | Strong | Medium | Cache key includes version |
| Tag-based | Flexible | Medium | Group keys by tag, invalidate by tag |

### Event-Driven Invalidation

```python
# Using database triggers or CDC (Change Data Capture)
# to invalidate cache on data change

def handle_db_change_event(event):
    """Called by CDC connector (Debezium) on DB change."""
    table = event["source"]["table"]
    operation = event["op"]  # c=create, u=update, d=delete
    key = event["after"]["id"] if event["after"] else event["before"]["id"]

    cache_key = f"{table}:{key}"

    if operation in ("u", "d"):
        cache.delete(cache_key)
        # Also invalidate related caches
        if table == "orders":
            customer_id = (event["after"] or event["before"])["customer_id"]
            cache.delete(f"customer_orders:{customer_id}")
```

### Tag-Based Invalidation

```python
def cache_with_tags(key: str, value: str, tags: list[str], ttl: int = 3600):
    pipe = cache.pipeline()
    pipe.setex(key, ttl, value)
    for tag in tags:
        pipe.sadd(f"tag:{tag}", key)
        pipe.expire(f"tag:{tag}", ttl)
    pipe.execute()

def invalidate_tag(tag: str):
    keys = cache.smembers(f"tag:{tag}")
    if keys:
        pipe = cache.pipeline()
        pipe.delete(*keys)
        pipe.delete(f"tag:{tag}")
        pipe.execute()

# Usage
cache_with_tags("product:123", data, tags=["products", "category:electronics"])
invalidate_tag("category:electronics")  # Invalidates all electronics products
```

---

## Cache Problems and Solutions

### Cache Penetration (Non-Existent Keys)

```
Problem: Repeated queries for keys that don't exist bypass cache every time.

Solution 1: Cache null results with short TTL
Solution 2: Bloom filter to check existence before DB query
```

```python
from pybloomfilter import BloomFilter

bf = BloomFilter(capacity=10_000_000, error_rate=0.01)

def get_product(product_id: str):
    if product_id not in bf:
        return None  # Definitely doesn't exist

    cached = cache.get(f"product:{product_id}")
    if cached:
        return json.loads(cached)

    product = db.query("SELECT * FROM products WHERE id = %s", product_id)
    if product:
        cache.setex(f"product:{product_id}", 3600, json.dumps(product))
        return product

    # Cache null to prevent repeated misses
    cache.setex(f"product:{product_id}", 60, json.dumps(None))
    return None
```

### Cache Stampede (Thundering Herd)

```
Problem: Popular key expires, N concurrent requests all hit DB simultaneously.

Solution 1: Distributed lock (only one request rebuilds cache)
Solution 2: Probabilistic early recomputation
Solution 3: Background refresh before expiry
```

```python
def get_with_stampede_protection(key: str, ttl: int, loader):
    cached = cache.get(key)
    if cached:
        return json.loads(cached)

    # Acquire lock - only one request rebuilds
    lock = cache.lock(f"lock:{key}", timeout=30, blocking_timeout=5)
    try:
        if lock.acquire():
            # Double-check after lock
            cached = cache.get(key)
            if cached:
                return json.loads(cached)

            value = loader()
            cache.setex(key, ttl, json.dumps(value))
            return value
    finally:
        try:
            lock.release()
        except Exception:
            pass

    # Lock not acquired - wait and retry
    time.sleep(0.5)
    return get_with_stampede_protection(key, ttl, loader)
```

### Cache Avalanche

```
Problem: Many keys expire at the same time, causing massive DB load spike.

Solution: Add random jitter to TTL values.
```

```python
import random

def cache_set_with_jitter(key: str, value: str, base_ttl: int = 3600):
    jitter = random.randint(0, base_ttl // 10)  # +/- 10% jitter
    cache.setex(key, base_ttl + jitter, value)
```

---

## CDN Caching

### Cache-Control Headers

```
# Immutable assets (hashed filenames)
Cache-Control: public, max-age=31536000, immutable

# API responses (short cache, revalidation)
Cache-Control: public, max-age=60, s-maxage=300, stale-while-revalidate=60

# Private user data
Cache-Control: private, no-cache, no-store

# Static pages
Cache-Control: public, max-age=3600, stale-while-revalidate=86400
```

### CDN Configuration (CloudFront)

```hcl
resource "aws_cloudfront_distribution" "api" {
  origin {
    domain_name = aws_lb.api.dns_name
    origin_id   = "api-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api-origin"

    cache_policy_id          = aws_cloudfront_cache_policy.api.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.api.id

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }
}

resource "aws_cloudfront_cache_policy" "api" {
  name        = "api-cache-policy"
  min_ttl     = 0
  max_ttl     = 86400
  default_ttl = 60

  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Authorization", "Accept"]
      }
    }
    query_strings_config {
      query_string_behavior = "whitelist"
      query_strings {
        items = ["page", "limit", "sort"]
      }
    }
    cookies_config {
      cookie_behavior = "none"
    }
  }
}
```

---

## Multi-Layer Caching Architecture

```
Client ──> [Browser Cache] ──> [CDN] ──> [API Gateway Cache] ──> [App Cache (Redis)] ──> [DB]
           L1: 0ms              L2: ~10ms   L3: ~5ms              L4: ~1ms               L5: ~10ms

Each layer reduces load on the next:
  - Browser: Immutable assets, short-lived API responses
  - CDN: Static content, public API responses
  - Gateway: Rate-limited cache, per-route TTL
  - App (Redis): Business objects, session data, computed results
  - DB: Query cache (PostgreSQL), materialized views
```

---

## Cross-References

- `3-build/api_gateway_patterns` - Gateway-level proxy cache
- `3-build/kafka_event_streaming` - Event-driven cache invalidation via CDC
- `toolkit/green_software_practices` - Caching reduces compute energy

---

## EXIT CHECKLIST

- [ ] Caching pattern selected (cache-aside, write-through, etc.)
- [ ] TTL values set with jitter to prevent cache avalanche
- [ ] Cache penetration handled (null caching or bloom filter)
- [ ] Cache stampede protection (distributed lock or early recompute)
- [ ] Invalidation strategy defined (TTL, event-driven, or tag-based)
- [ ] Redis connection pool configured with retry and health checks
- [ ] Cache hit rate monitored (target > 90% for hot paths)
- [ ] Cache-Control headers set for CDN and browser caching
- [ ] Serialization format chosen (JSON for debug, MessagePack for perf)
- [ ] Graceful degradation when cache is unavailable (fall back to DB)
- [ ] Memory limits configured to prevent OOM (maxmemory-policy)
- [ ] Cache warming strategy for cold starts

---

*Skill Version: 1.0 | Created: March 2026*
