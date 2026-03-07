---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Ownership & Borrowing

> This file extends [common/patterns.md](../common/patterns.md) with Rust-specific ownership rules.

## Core Rules

- Every value has exactly one owner. When the owner goes out of scope, the value is dropped.
- Prefer borrowing (`&T` / `&mut T`) over cloning. Clone only when ownership transfer is impossible.
- Never hold a mutable and immutable borrow simultaneously.

## DO: Borrow Instead of Clone

```rust
// GOOD - borrows the string
fn greet(name: &str) {
    println!("Hello, {name}");
}

// BAD - unnecessary clone
fn greet_bad(name: String) {
    println!("Hello, {name}");
}
```

## DO: Use References in Structs with Lifetimes

```rust
// GOOD - zero-copy parsing
struct Request<'a> {
    path: &'a str,
    headers: Vec<(&'a str, &'a str)>,
}

// OK when ownership is needed (e.g., storing beyond input lifetime)
struct OwnedRequest {
    path: String,
    headers: Vec<(String, String)>,
}
```

## DON'T: Fight the Borrow Checker with Excessive Cloning

```rust
// BAD - clone to silence borrow checker
let data = shared_data.clone();
process(&data);

// GOOD - restructure to avoid the conflict
let result = {
    let data = &shared_data;
    process(data)
};
shared_data.update(result);
```

## Lifetime Elision

Let the compiler infer lifetimes when possible. Only annotate when:
- Multiple input lifetimes exist and the compiler can't infer the output lifetime
- Struct fields hold references

```rust
// Elision works - one input reference
fn first_word(s: &str) -> &str { ... }

// Annotation needed - two input lifetimes
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str { ... }
```

## Common Borrow Checker Errors

| Error | Fix |
|-------|-----|
| "cannot borrow as mutable, already borrowed as immutable" | Restructure to separate mutable and immutable scopes |
| "does not live long enough" | Extend the lifetime or switch to owned data |
| "cannot move out of borrowed content" | Use `.clone()`, `.to_owned()`, or restructure |

## Prefer `&str` Over `&String`

```rust
// GOOD - accepts &str, &String, and string slices
fn process(input: &str) { ... }

// BAD - forces callers to have a String
fn process_bad(input: &String) { ... }
```
