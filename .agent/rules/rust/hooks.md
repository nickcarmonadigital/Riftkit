---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Hooks

> This file extends [common/hooks.md](../common/hooks.md) with Rust-specific content.

## PostToolUse Hooks

Configure in `.agent/settings.json`:

- **rustfmt**: Auto-format `.rs` files after edit (`cargo fmt`)
- **clippy**: Run `cargo clippy -- -D warnings` after editing `.rs` files — treat all warnings as errors
- **build check**: Run `cargo check` after edits to catch type errors without a full compile

## Stop Hooks

- **`unwrap()` audit**: Warn on bare `.unwrap()` calls in non-test code before session ends (prefer `.expect("reason")` or proper error propagation)
- **`todo!()`/`unimplemented!()` audit**: Flag any `todo!()` or `unimplemented!()` left in edited files
