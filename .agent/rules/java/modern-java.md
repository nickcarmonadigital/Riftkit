---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
---
# Modern Java (17+)

> This file extends [common/coding-style.md](../common/coding-style.md) with modern Java features.

## Core Rules

- Use Java 17+ features: records, sealed classes, pattern matching, text blocks, switch expressions.
- Prefer records over manual POJOs for immutable data carriers.
- Use `var` for local variables when the type is obvious from the right-hand side.

## DO: Use Records for Data Carriers

```java
// GOOD - record: immutable, equals/hashCode/toString generated
public record UserDto(String name, String email, int age) {}

// BAD - manual POJO with boilerplate
public class UserDto {
    private final String name;
    private final String email;
    private final int age;
    // constructor, getters, equals, hashCode, toString...
}
```

## DO: Use Sealed Classes for Restricted Hierarchies

```java
public sealed interface Shape
    permits Circle, Rectangle, Triangle {
}

public record Circle(double radius) implements Shape {}
public record Rectangle(double w, double h) implements Shape {}
public record Triangle(double a, double b, double c) implements Shape {}
```

## DO: Use Pattern Matching

```java
// GOOD - pattern matching for instanceof (Java 16+)
if (shape instanceof Circle c) {
    return Math.PI * c.radius() * c.radius();
}

// GOOD - pattern matching in switch (Java 21+)
double area = switch (shape) {
    case Circle c -> Math.PI * c.radius() * c.radius();
    case Rectangle r -> r.w() * r.h();
    case Triangle t -> heronsFormula(t);
};
```

## DO: Use Switch Expressions

```java
// GOOD - switch expression with arrow syntax
String label = switch (status) {
    case ACTIVE -> "Active";
    case INACTIVE -> "Inactive";
    case PENDING -> "Pending";
};

// BAD - old switch with fall-through risk
String label;
switch (status) {
    case ACTIVE: label = "Active"; break;
    case INACTIVE: label = "Inactive"; break;
    // missing break = silent bug
}
```

## DO: Use Text Blocks

```java
// GOOD
String query = """
        SELECT u.name, u.email
        FROM users u
        WHERE u.active = true
        ORDER BY u.name
        """;

// BAD
String query = "SELECT u.name, u.email\n" +
    "FROM users u\n" +
    "WHERE u.active = true\n" +
    "ORDER BY u.name";
```

## var Usage

```java
// GOOD - type is obvious from RHS
var users = new ArrayList<User>();
var response = client.send(request, HttpResponse.BodyHandlers.ofString());

// BAD - type not obvious, hurts readability
var result = process(data);  // what type is result?
var x = getConfig();         // unclear
```
