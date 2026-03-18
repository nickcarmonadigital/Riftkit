---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Testing

> This file extends [common/testing.md](../common/testing.md) with Rust-specific testing patterns.

## Core Rules

- Co-locate unit tests in the same file as the code under test using a `#[cfg(test)]` module.
- Use integration tests in `tests/` for public API surface testing.
- Use `cargo test` for all test runs. Use `cargo nextest` for faster parallel execution in CI.

## DO: Co-located Unit Tests

```rust
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn adds_positive_numbers() {
        assert_eq!(add(2, 3), 5);
    }

    #[test]
    fn adds_negative_numbers() {
        assert_eq!(add(-2, -3), -5);
    }
}
```

## DO: Test Error Paths Explicitly

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn returns_err_on_invalid_port() {
        let result = parse_port("not-a-number");
        assert!(result.is_err());
    }

    #[test]
    fn returns_err_on_port_out_of_range() {
        let result = parse_port("99999");
        assert!(result.is_err());
    }

    #[test]
    #[should_panic(expected = "called on empty stack")]
    fn panics_when_popping_empty_stack() {
        let mut s: Stack<i32> = Stack::new();
        s.pop();  // should panic
    }
}
```

## DO: Integration Tests for Public API

```
tests/
  api_test.rs     # Tests via public interface only
  fixtures/       # Shared test data
```

```rust
// tests/api_test.rs
use my_crate::UserStore;

#[test]
fn can_insert_and_retrieve_user() {
    let store = UserStore::in_memory();
    let id = store.insert("alice@example.com").unwrap();
    let user = store.get(id).unwrap();
    assert_eq!(user.email, "alice@example.com");
}
```

## DO: Use Test Fixtures and Builders

```rust
#[cfg(test)]
mod tests {
    fn make_user(email: &str) -> User {
        User {
            id: UserId::new(),
            email: email.to_string(),
            active: true,
        }
    }

    #[test]
    fn inactive_users_are_filtered() {
        let mut user = make_user("test@example.com");
        user.active = false;
        assert!(!user.is_eligible_for_notifications());
    }
}
```

## DO: Use `unwrap()` Freely in Tests

```rust
#[test]
fn parses_valid_config() {
    // unwrap is acceptable in tests — a panic is a clear test failure
    let config = Config::from_str(TEST_CONFIG_TOML).unwrap();
    assert_eq!(config.port, 8080);
}
```

## Async Testing

Use `#[tokio::test]` (or `#[async_std::test]`) for async code:

```rust
#[tokio::test]
async fn fetches_user_from_db() {
    let db = setup_test_db().await;
    let user = db.find_user("user-1").await.unwrap();
    assert_eq!(user.name, "Alice");
}
```

## Property-Based Testing

Use **proptest** or **quickcheck** for invariant testing:

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn encode_decode_roundtrip(s in "\\PC*") {
        let encoded = encode(&s);
        let decoded = decode(&encoded).unwrap();
        prop_assert_eq!(s, decoded);
    }
}
```

## Agent Support

- Use **tdd-guide** agent for test-driven development coaching.
