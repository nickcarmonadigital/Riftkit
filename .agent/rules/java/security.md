---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
  - "**/application*.yml"
  - "**/application*.properties"
---
# Java Security

> This file extends [common/security.md](../common/security.md) with Java-specific content.

## Secret Management

```java
// NEVER: Hardcoded secrets
String apiKey = "sk-proj-xxxxx";
String dbPassword = "supersecret";

// ALWAYS: Externalize via environment variables or config server
@ConfigurationProperties(prefix = "app")
public record AppProperties(
    String apiKey,        // from APP_API_KEY env var or vault
    String dbPassword     // from APP_DB_PASSWORD env var or vault
) {}

// Validate at startup — fail fast if required secrets are missing
@PostConstruct
void validateSecrets() {
    if (apiKey == null || apiKey.isBlank()) {
        throw new IllegalStateException("APP_API_KEY is not configured");
    }
}
```

## Input Validation

Use Bean Validation (`jakarta.validation`) on all inbound request objects:

```java
public record CreateUserRequest(
    @NotBlank @Email String email,
    @NotBlank @Size(min = 8, max = 128) String password,
    @NotNull @Min(0) @Max(150) Integer age
) {}

// Enable in controller
@PostMapping("/users")
public ResponseEntity<UserDto> create(@Valid @RequestBody CreateUserRequest req) {
    return ResponseEntity.status(CREATED).body(userService.createUser(req));
}
```

## SQL Injection Prevention

Always use parameterized queries. Never concatenate user input into SQL:

```java
// BAD - SQL injection vulnerability
String sql = "SELECT * FROM users WHERE name = '" + name + "'";

// GOOD - parameterized (JPA/JPQL)
@Query("SELECT u FROM User u WHERE u.name = :name")
List<User> findByName(@Param("name") String name);

// GOOD - parameterized (JDBC)
jdbcTemplate.query(
    "SELECT * FROM users WHERE name = ?",
    (rs, n) -> mapUser(rs),
    name
);
```

## Password Handling

```java
// NEVER store plaintext passwords
// ALWAYS use BCrypt or Argon2

@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder(12);  // cost factor 12+
}

// Usage
String hash = passwordEncoder.encode(rawPassword);
boolean matches = passwordEncoder.matches(rawPassword, storedHash);
```

## Security Headers

Configure Spring Security with sensible defaults:

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    return http
        .headers(h -> h
            .contentSecurityPolicy(csp -> csp.policyDirectives("default-src 'self'"))
            .frameOptions(fo -> fo.deny())
        )
        .csrf(csrf -> csrf.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()))
        .sessionManagement(sm -> sm.sessionCreationPolicy(STATELESS))
        .build();
}
```

## Dependency Scanning

- Run **OWASP Dependency-Check** in CI: `mvn dependency-check:check` or Gradle equivalent.
- Use **Dependabot** or **Renovate** for automated dependency updates.
- Never ignore high/critical CVEs without a documented exception.

## Agent Support

- Use **security-reviewer** skill for comprehensive security audits.
- See skill: `springboot-security` for Spring Security configuration patterns.
