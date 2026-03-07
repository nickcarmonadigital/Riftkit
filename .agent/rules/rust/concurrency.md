---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Concurrency

> This file extends [common/patterns.md](../common/patterns.md) with Rust-specific concurrency rules.

## Core Rules

- Lean on the type system: `Send` and `Sync` traits enforce thread safety at compile time.
- Prefer message passing (channels) over shared state when possible.
- Use `Arc<Mutex<T>>` for shared mutable state; keep critical sections small.

## DO: Use Arc + Mutex for Shared State

```rust
use std::sync::{Arc, Mutex};
use std::thread;

let counter = Arc::new(Mutex::new(0));
let handles: Vec<_> = (0..10).map(|_| {
    let counter = Arc::clone(&counter);
    thread::spawn(move || {
        let mut num = counter.lock().unwrap();
        *num += 1;
    })
}).collect();

for h in handles { h.join().unwrap(); }
```

## DO: Use Channels for Message Passing

```rust
use std::sync::mpsc;

let (tx, rx) = mpsc::channel();
thread::spawn(move || {
    tx.send("hello".to_string()).unwrap();
});
let msg = rx.recv().unwrap();
```

## DO: Use Tokio for Async I/O

```rust
use tokio::sync::Semaphore;
use std::sync::Arc;

let sem = Arc::new(Semaphore::new(10)); // limit concurrency
let mut handles = vec![];

for url in urls {
    let permit = sem.clone().acquire_owned().await.unwrap();
    handles.push(tokio::spawn(async move {
        let result = fetch(&url).await;
        drop(permit);
        result
    }));
}
```

## DON'T: Hold Locks Across Await Points

```rust
// BAD - MutexGuard held across .await (causes deadlock with tokio::sync::Mutex)
let mut data = lock.lock().await;
do_async_work(&data).await; // other tasks blocked
*data = new_value;

// GOOD - release lock before awaiting
let snapshot = {
    let data = lock.lock().await;
    data.clone()
};
let result = do_async_work(&snapshot).await;
lock.lock().await.update(result);
```

## DON'T: Use std::sync::Mutex in Async Code

```rust
// BAD - std Mutex blocks the async runtime thread
let data = std::sync::Mutex::new(vec![]);

// GOOD - use tokio's async-aware Mutex
let data = tokio::sync::Mutex::new(vec![]);
```

## Avoiding Deadlocks

- Always acquire multiple locks in a consistent order.
- Keep critical sections as short as possible.
- Use `try_lock()` when deadlock risk exists.
- Prefer `RwLock` when reads vastly outnumber writes.

## Send + Sync Quick Reference

| Type | Send | Sync | Notes |
|------|------|------|-------|
| `Arc<T>` | if T: Send + Sync | if T: Send + Sync | Shared ownership |
| `Mutex<T>` | if T: Send | yes | Provides interior mutability |
| `Rc<T>` | no | no | Single-threaded only |
| `Cell<T>` | if T: Send | no | Single-threaded interior mutability |
