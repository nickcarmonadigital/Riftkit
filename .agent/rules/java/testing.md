---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
  - "**/src/test/**"
---
# Java Testing

> This file extends [common/testing.md](../common/testing.md) with Java-specific testing patterns.

## Core Rules

- Use JUnit 5 (`@Test` from `org.junit.jupiter.api`). Never use JUnit 4.
- Use AssertJ for assertions (`assertThat`), not JUnit's `assertEquals`.
- Use `@WebMvcTest` for controller tests, `@SpringBootTest` only for integration tests.

## DO: Use AssertJ Assertions

```java
// GOOD - readable, chainable
assertThat(users)
    .hasSize(3)
    .extracting(User::name)
    .contains("Alice", "Bob");

assertThat(result).isPresent().get().satisfies(user -> {
    assertThat(user.email()).endsWith("@example.com");
    assertThat(user.age()).isBetween(18, 65);
});

// BAD - JUnit assertions (poor failure messages)
assertEquals(3, users.size());
assertTrue(result.isPresent());
```

## DO: Use @WebMvcTest for Controller Tests

```java
@WebMvcTest(UserController.class)
class UserControllerTest {
    @Autowired private MockMvc mvc;
    @MockitoBean private UserService userService;

    @Test
    void shouldReturn404WhenUserNotFound() throws Exception {
        when(userService.findById("123"))
            .thenThrow(new NotFoundException("User", "123"));

        mvc.perform(get("/api/users/123"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.code").value("NOT_FOUND"));
    }
}
```

## DO: Use Testcontainers for Database Tests

```java
@SpringBootTest
@Testcontainers
class OrderRepositoryIT {
    @Container
    static PostgreSQLContainer<?> pg = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void dbProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", pg::getJdbcUrl);
        registry.add("spring.datasource.username", pg::getUsername);
        registry.add("spring.datasource.password", pg::getPassword);
    }

    @Autowired private OrderRepository orderRepo;

    @Test
    void shouldPersistOrder() {
        var order = new Order("item-1", 2, BigDecimal.TEN);
        var saved = orderRepo.save(order);
        assertThat(saved.getId()).isNotNull();
    }
}
```

## DO: Follow Test Naming Conventions

```java
// GOOD - describes behavior
@Test void shouldReturnEmptyListWhenNoOrdersExist() { ... }
@Test void shouldThrowWhenAmountIsNegative() { ... }

// BAD - vague names
@Test void test1() { ... }
@Test void testOrders() { ... }
```

## Mockito Best Practices

```java
// GOOD - verify essential interactions, not implementation details
verify(emailService).send(eq("user@example.com"), anyString());

// BAD - over-verification (brittle)
verify(repo, times(1)).findById("123");
verify(mapper, times(1)).toDto(any());
verify(validator, times(1)).validate(any());

// GOOD - use argument captors for complex assertions
var captor = ArgumentCaptor.forClass(Email.class);
verify(emailService).send(captor.capture());
assertThat(captor.getValue().subject()).contains("Welcome");
```

## DON'T: Use @SpringBootTest for Unit Tests

```java
// BAD - boots entire context for a service test
@SpringBootTest
class UserServiceTest { ... }

// GOOD - plain unit test with mocks
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock private UserRepository userRepo;
    @InjectMocks private UserService userService;

    @Test
    void shouldCreateUser() { ... }
}
```

## Test Structure: Arrange-Act-Assert

```java
@Test
void shouldApplyDiscount() {
    // Arrange
    var order = new Order("item-1", 2, new BigDecimal("100.00"));

    // Act
    order.applyDiscount(new BigDecimal("0.10"));

    // Assert
    assertThat(order.total()).isEqualByComparingTo("180.00");
}
```
