---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Error Handling

> This file extends [common/patterns.md](../common/patterns.md) with Rust-specific error handling.

## Core Rules

- Use `Result<T, E>` for recoverable errors. Reserve `panic!` for unrecoverable bugs.
- Use the `?` operator to propagate errors up the call stack.
- Libraries: use `thiserror` for typed error enums. Applications: use `anyhow` for ergonomic error chains.

## DO: Use thiserror for Libraries

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum DbError {
    #[error("connection failed: {0}")]
    Connection(#[from] std::io::Error),
    #[error("query failed: {query}")]
    Query { query: String, source: sqlx::Error },
    #[error("record not found: {0}")]
    NotFound(String),
}
```

## DO: Use anyhow for Applications

```rust
use anyhow::{Context, Result};

fn load_config(path: &str) -> Result<Config> {
    let content = std::fs::read_to_string(path)
        .with_context(|| format!("failed to read config from {path}"))?;
    let config: Config = toml::from_str(&content)
        .context("failed to parse config")?;
    Ok(config)
}
```

## DO: Use the ? Operator

```rust
// GOOD - concise propagation
fn read_username() -> Result<String, io::Error> {
    let mut s = String::new();
    File::open("username.txt")?.read_to_string(&mut s)?;
    Ok(s)
}

// BAD - manual match chains
fn read_username_bad() -> Result<String, io::Error> {
    let f = match File::open("username.txt") {
        Ok(f) => f,
        Err(e) => return Err(e),
    };
    // ... more nesting
}
```

## DON'T: Panic in Library Code

```rust
// BAD - panics on invalid input
pub fn parse_port(s: &str) -> u16 {
    s.parse().unwrap() // panics on bad input
}

// GOOD - returns Result
pub fn parse_port(s: &str) -> Result<u16, ParseIntError> {
    s.parse()
}
```

## When unwrap/expect Is Acceptable

- Tests (`#[test]` functions)
- Provably infallible operations (e.g., compiling a known-good regex at startup)
- Always prefer `expect("reason")` over bare `unwrap()`

```rust
// OK - static regex, compile-time guaranteed valid
let re = Regex::new(r"^\d{4}-\d{2}-\d{2}$").expect("date regex is valid");
```

## Error Conversion Pattern

Implement `From<SourceError>` for your error type (or use `#[from]` with thiserror):

```rust
impl From<io::Error> for AppError {
    fn from(err: io::Error) -> Self {
        AppError::Io(err)
    }
}
```
