---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
---
# Java Concurrency

> This file extends [common/performance.md](../common/performance.md) with Java-specific concurrency patterns.

## Core Rules

- Use virtual threads (Java 21+) for I/O-bound work. Use platform threads only for CPU-bound work.
- Prefer `ConcurrentHashMap` and `CopyOnWriteArrayList` over `synchronized` collections.
- Never synchronize on a public field or `this`. Use a private lock object.

## DO: Use Virtual Threads (Java 21+)

```java
// GOOD - virtual threads for I/O-bound tasks
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    List<Future<Response>> futures = urls.stream()
        .map(url -> executor.submit(() -> httpClient.send(url)))
        .toList();

    for (var future : futures) {
        process(future.get());
    }
}

// BAD - fixed thread pool for I/O work (wastes threads waiting on I/O)
var pool = Executors.newFixedThreadPool(10);
```

## DO: Use CompletableFuture for Async Pipelines

```java
CompletableFuture<OrderDto> result = CompletableFuture
    .supplyAsync(() -> orderRepo.findById(id))
    .thenApply(order -> enrichWithPayment(order))
    .thenApply(OrderMapper::toDto)
    .exceptionally(ex -> {
        log.error("Order pipeline failed", ex);
        throw new ProcessingException("Failed to load order", ex);
    });
```

## DO: Use Concurrent Collections

```java
// GOOD
private final ConcurrentHashMap<String, Session> sessions = new ConcurrentHashMap<>();

// Atomic compute operations
sessions.computeIfAbsent(userId, id -> createSession(id));
sessions.compute(userId, (id, existing) -> existing != null ? existing.refresh() : createSession(id));

// BAD - manual synchronization around HashMap
private final Map<String, Session> sessions = new HashMap<>();
synchronized (sessions) { ... }
```

## DON'T: Synchronize on Public or Mutable Objects

```java
// BAD
public synchronized void update() { ... }          // locks on 'this'
synchronized (somePublicField) { ... }              // external code can deadlock

// GOOD - private lock object
private final Object lock = new Object();
public void update() {
    synchronized (lock) { ... }
}
```

## DON'T: Use Thread.stop() or Thread.suspend()

```java
// BAD - deprecated, unsafe
thread.stop();

// GOOD - cooperative cancellation
private volatile boolean running = true;

public void run() {
    while (running) {
        doWork();
    }
}

public void shutdown() {
    running = false;
}
```

## @Async in Spring

```java
@Configuration
@EnableAsync
public class AsyncConfig {
    @Bean
    public Executor taskExecutor() {
        // Use virtual threads in Spring Boot 3.2+
        return Executors.newVirtualThreadPerTaskExecutor();
    }
}

@Service
public class NotificationService {
    @Async
    public CompletableFuture<Void> sendEmail(String to, String body) {
        emailClient.send(to, body);
        return CompletableFuture.completedFuture(null);
    }
}
```

## Thread Safety Checklist

- Immutable objects are always thread-safe (use records).
- Share data via concurrent collections or message queues, not raw shared variables.
- Document thread-safety guarantees on public classes (thread-safe, not thread-safe, conditionally thread-safe).
