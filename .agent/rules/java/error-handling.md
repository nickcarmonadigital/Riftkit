---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
---
# Java Error Handling

> This file extends [common/patterns.md](../common/patterns.md) with Java-specific error handling.

## Core Rules

- Use unchecked exceptions for programming errors. Use checked exceptions only for recoverable external failures.
- Never catch `Exception` or `Throwable` in business logic.
- Use `@ControllerAdvice` for centralized REST error handling.

## DO: Build a Custom Exception Hierarchy

```java
// Base exception for your domain
public abstract class AppException extends RuntimeException {
    private final String code;

    protected AppException(String code, String message) {
        super(message);
        this.code = code;
    }

    protected AppException(String code, String message, Throwable cause) {
        super(message, cause);
        this.code = code;
    }

    public String getCode() { return code; }
}

public class NotFoundException extends AppException {
    public NotFoundException(String entity, Object id) {
        super("NOT_FOUND", "%s not found: %s".formatted(entity, id));
    }
}

public class ConflictException extends AppException {
    public ConflictException(String message) {
        super("CONFLICT", message);
    }
}
```

## DO: Use @ControllerAdvice

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(NotFoundException ex) {
        return ResponseEntity.status(404)
            .body(new ErrorResponse(ex.getCode(), ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        var errors = ex.getFieldErrors().stream()
            .map(f -> f.getField() + ": " + f.getDefaultMessage())
            .toList();
        return ResponseEntity.badRequest()
            .body(new ErrorResponse("VALIDATION_ERROR", errors.toString()));
    }
}

public record ErrorResponse(String code, String message) {}
```

## DON'T: Catch Exception/Throwable

```java
// BAD - swallows everything including NPE, OOM
try {
    process(data);
} catch (Exception e) {
    log.error("failed", e);
}

// GOOD - catch specific exceptions
try {
    process(data);
} catch (IOException e) {
    throw new ProcessingException("I/O failure during processing", e);
}
```

## DON'T: Use Exceptions for Flow Control

```java
// BAD
try {
    return map.get(key).toString();
} catch (NullPointerException e) {
    return "default";
}

// GOOD
var value = map.get(key);
return value != null ? value.toString() : "default";
```

## DON'T: Swallow Exceptions

```java
// BAD - silent failure
try { resource.close(); } catch (IOException e) { }

// GOOD - at minimum log it
try {
    resource.close();
} catch (IOException e) {
    log.warn("failed to close resource", e);
}
```

## Checked Exception Wrapping

When a checked exception crosses a layer boundary, wrap it:

```java
public User findUser(String id) {
    try {
        return dao.query(id);
    } catch (SQLException e) {
        throw new DataAccessException("Failed to find user " + id, e);
    }
}
```
