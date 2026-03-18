---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
---
# Java Hooks

> This file extends [common/hooks.md](../common/hooks.md) with Java-specific content.

## PostToolUse Hooks

Configure in `.agent/settings.json`:

- **google-java-format / spotless**: Auto-format `.java` files after edit
- **checkstyle**: Run style checks after editing `.java` files
- **compilation check**: Run `mvn compile -q` or `./gradlew compileJava` after edits to catch errors early

## Stop Hooks

- **`System.out.println` audit**: Check all modified files for `System.out.println` before session ends (use SLF4J `log.*` instead)
- **`e.printStackTrace()` audit**: Warn on bare `printStackTrace()` calls — these bypass structured logging
