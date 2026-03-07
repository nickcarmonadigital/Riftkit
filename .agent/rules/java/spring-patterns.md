---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
  - "**/application*.yml"
  - "**/application*.properties"
---
# Spring Boot Patterns

> This file extends [common/patterns.md](../common/patterns.md) with Spring Boot conventions.

## Core Rules

- Use constructor injection exclusively. Never use `@Autowired` on fields.
- Place `@Transactional` on service methods, not on controllers or repositories.
- Use `@ConfigurationProperties` over scattered `@Value` annotations.

## DO: Constructor Injection

```java
// GOOD - constructor injection (implicit @Autowired with single constructor)
@Service
public class OrderService {
    private final OrderRepository orderRepo;
    private final PaymentClient paymentClient;

    public OrderService(OrderRepository orderRepo, PaymentClient paymentClient) {
        this.orderRepo = orderRepo;
        this.paymentClient = paymentClient;
    }
}

// BAD - field injection (untestable, hides dependencies)
@Service
public class OrderService {
    @Autowired private OrderRepository orderRepo;
    @Autowired private PaymentClient paymentClient;
}
```

## DO: @Transactional on Service Layer

```java
// GOOD
@Service
public class TransferService {
    @Transactional
    public void transfer(Long fromId, Long toId, BigDecimal amount) {
        accountRepo.debit(fromId, amount);
        accountRepo.credit(toId, amount);
    }

    @Transactional(readOnly = true)
    public Account getAccount(Long id) {
        return accountRepo.findById(id).orElseThrow();
    }
}

// BAD - @Transactional on controller
@RestController
@Transactional  // wrong layer
public class TransferController { ... }
```

## DO: Use @ConfigurationProperties

```java
@ConfigurationProperties(prefix = "app.storage")
public record StorageProperties(
    String bucket,
    String region,
    Duration uploadTimeout
) {}

// Enable in config class or main app:
@EnableConfigurationProperties(StorageProperties.class)
```

## DON'T: Fat Controllers

```java
// BAD - business logic in controller
@PostMapping("/orders")
public ResponseEntity<?> create(@RequestBody OrderRequest req) {
    if (inventory.check(req.itemId()) < req.quantity()) { ... }
    var order = new Order(...);
    orderRepo.save(order);
    emailService.send(...);
    return ResponseEntity.ok(order);
}

// GOOD - controller delegates to service
@PostMapping("/orders")
public ResponseEntity<OrderDto> create(@Valid @RequestBody OrderRequest req) {
    return ResponseEntity.status(CREATED).body(orderService.create(req));
}
```

## Bean Lifecycle

- `@PostConstruct` for initialization after injection.
- `@PreDestroy` for cleanup (close connections, flush caches).
- Implement `SmartLifecycle` for ordered startup/shutdown of background tasks.

## Profiles

```java
@Configuration
@Profile("!test")  // excluded from tests
public class ProductionCacheConfig { ... }

@Configuration
@Profile("test")
public class TestCacheConfig { ... }
```
