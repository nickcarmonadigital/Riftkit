---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
  - "**/application*.yml"
  - "**/application*.properties"
---
# Java Patterns

> This file extends [common/patterns.md](../common/patterns.md) with Java-specific patterns.

## Repository Pattern

```java
public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findByEmail(String email);
    List<User> findByActiveTrue();

    @Query("SELECT u FROM User u WHERE u.role = :role")
    List<User> findByRole(@Param("role") Role role);
}
```

## Service Layer Pattern

- Services own business logic and transactions.
- Controllers only validate input and delegate to services.
- Services return DTOs (records), not JPA entities, to callers above the service layer.

```java
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public UserDto createUser(CreateUserRequest req) {
        if (userRepo.findByEmail(req.email()).isPresent()) {
            throw new ConflictException("Email already registered: " + req.email());
        }
        var user = User.builder()
            .email(req.email())
            .passwordHash(passwordEncoder.encode(req.password()))
            .build();
        return toDto(userRepo.save(user));
    }

    @Transactional(readOnly = true)
    public UserDto getUser(String id) {
        return userRepo.findById(id)
            .map(this::toDto)
            .orElseThrow(() -> new NotFoundException("User", id));
    }

    private UserDto toDto(User user) {
        return new UserDto(user.getId(), user.getEmail());
    }
}
```

## API Response Format

```java
public record ApiResponse<T>(boolean success, T data, String error) {
    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(true, data, null);
    }
    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, null, message);
    }
}

public record PageResponse<T>(List<T> items, long total, int page, int size) {}
```

## Mapper Pattern

Use **MapStruct** for compile-time safe, zero-reflection mapping between entities and DTOs:

```java
@Mapper(componentModel = "spring")
public interface UserMapper {
    UserDto toDto(User user);
    User toEntity(CreateUserRequest req);
    List<UserDto> toDtoList(List<User> users);
}
```

## Specification Pattern (Dynamic Queries)

```java
public class UserSpecs {
    public static Specification<User> hasRole(Role role) {
        return (root, query, cb) -> cb.equal(root.get("role"), role);
    }

    public static Specification<User> isActive() {
        return (root, query, cb) -> cb.isTrue(root.get("active"));
    }
}

// Usage: composable and readable
var users = userRepo.findAll(hasRole(ADMIN).and(isActive()));
```

## Reference

See `spring-patterns.md` for Spring Boot-specific conventions (injection, transactions, configuration properties).
