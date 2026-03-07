---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Idiomatic Patterns

> This file extends [common/coding-style.md](../common/coding-style.md) with Rust-specific idioms.

## Core Rules

- Run `cargo clippy` and fix all warnings before committing.
- Use `cargo fmt` (rustfmt) for consistent formatting.
- Prefer iterator chains over manual loops. Prefer pattern matching over if-else chains.

## DO: Use Iterator Chains

```rust
// GOOD
let names: Vec<String> = users
    .iter()
    .filter(|u| u.active)
    .map(|u| u.name.clone())
    .collect();

// BAD - manual loop for a simple transform
let mut names = Vec::new();
for u in &users {
    if u.active {
        names.push(u.name.clone());
    }
}
```

## DO: Use Pattern Matching

```rust
// GOOD - exhaustive match
match command {
    Command::Start { port } => start_server(port),
    Command::Stop => stop_server(),
    Command::Status => print_status(),
}

// GOOD - if let for single-variant checks
if let Some(user) = find_user(id) {
    greet(&user);
}

// BAD - nested if/else
if command.is_start() {
    start_server(command.port().unwrap());
} else if command.is_stop() { ... }
```

## DO: Derive Common Traits

```rust
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct UserId(String);

// Derive serde traits for serialization
#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct Config {
    pub host: String,
    pub port: u16,
}
```

## DO: Use the Type System for Correctness

```rust
// GOOD - newtype prevents mixing up IDs
struct UserId(u64);
struct OrderId(u64);

fn get_order(user: UserId, order: OrderId) -> Order { ... }

// BAD - bare u64s are interchangeable
fn get_order(user_id: u64, order_id: u64) -> Order { ... }
```

## Trait Design

- Keep traits small and focused (1-3 methods).
- Provide default implementations where sensible.
- Use associated types over generic parameters when there's one logical choice.

```rust
// GOOD - associated type (one output per impl)
trait Parser {
    type Output;
    fn parse(&self, input: &str) -> Result<Self::Output, ParseError>;
}

// Use generic param when multiple impls per type make sense
trait Convert<T> {
    fn convert(&self) -> T;
}
```

## Module Organization

```
src/
  lib.rs          # Public API, re-exports
  error.rs        # Error types
  config.rs       # Configuration
  domain/
    mod.rs        # Domain re-exports
    user.rs
    order.rs
  infra/
    mod.rs
    db.rs
    http.rs
```

- Re-export public types from `lib.rs` so users don't navigate deep paths.
- Keep `mod.rs` files thin -- just `pub mod` and `pub use` statements.

## Builder Pattern

```rust
#[derive(Default)]
pub struct RequestBuilder {
    url: String,
    timeout: Option<Duration>,
    headers: Vec<(String, String)>,
}

impl RequestBuilder {
    pub fn url(mut self, url: impl Into<String>) -> Self {
        self.url = url.into();
        self
    }
    pub fn timeout(mut self, d: Duration) -> Self {
        self.timeout = Some(d);
        self
    }
    pub fn build(self) -> Result<Request, BuildError> { ... }
}
```
