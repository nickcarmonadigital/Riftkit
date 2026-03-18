---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
---
# Java Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with Java-specific content.

## Standards

- Target **Java 17+**. Use records, sealed classes, pattern matching, text blocks, and switch expressions.
- Follow **Google Java Style Guide** or enforce with **Checkstyle**.
- Use **google-java-format** or **Spotless** for automated formatting.

## Immutability

Prefer immutable data carriers:

```java
// GOOD - record: immutable, equals/hashCode/toString generated
public record UserDto(String id, String name, String email) {}

// GOOD - unmodifiable collections
List<String> tags = List.copyOf(inputTags);
Map<String, String> config = Map.copyOf(inputMap);

// BAD - mutable field exposed directly
public class UserDto {
    public List<String> roles = new ArrayList<>();  // mutable, leaks state
}
```

## Naming Conventions

```java
// Classes: PascalCase
public class OrderService { ... }

// Methods and variables: camelCase
public Optional<User> findByEmail(String emailAddress) { ... }

// Constants: UPPER_SNAKE_CASE
public static final int MAX_RETRY_ATTEMPTS = 3;

// Packages: lowercase, dot-separated
package com.example.order.service;
```

## Logging

- Use **SLF4J** (`LoggerFactory`) — never `System.out.println` or `e.printStackTrace()`.
- Declare logger as a `private static final` field.

```java
// GOOD
private static final Logger log = LoggerFactory.getLogger(OrderService.class);

log.info("Order created: orderId={}, userId={}", order.id(), userId);
log.error("Failed to process order: orderId={}", orderId, ex);

// BAD
System.out.println("Order created: " + order.id());
e.printStackTrace();
```

## Null Handling

Prefer `Optional` over returning `null` from query methods:

```java
// GOOD
public Optional<User> findById(String id) { ... }

// GOOD - annotate params/returns when null is truly not allowed
public User getById(@NonNull String id) { ... }

// BAD - silent null returns
public User findById(String id) { return null; }  // forces callers to null-check
```

## Reference

See `modern-java.md` for Java 17+ feature usage (records, sealed classes, pattern matching, text blocks, switch expressions).
