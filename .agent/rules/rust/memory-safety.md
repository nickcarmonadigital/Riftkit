---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Memory Safety

> This file extends [common/security.md](../common/security.md) with Rust-specific memory safety rules.

## Core Rules

- Minimize `unsafe` blocks. Every `unsafe` block must have a `// SAFETY:` comment explaining the invariant.
- Encapsulate unsafe code behind safe abstractions.
- Never use `unsafe` to bypass the borrow checker out of convenience.

## DO: Document and Encapsulate Unsafe

```rust
/// Returns a slice of the buffer without bounds checking.
///
/// # Safety
/// `offset + len` must not exceed `self.buf.len()`.
pub unsafe fn slice_unchecked(&self, offset: usize, len: usize) -> &[u8] {
    // SAFETY: caller guarantees offset + len <= buf.len()
    std::slice::from_raw_parts(self.buf.as_ptr().add(offset), len)
}

// Public safe wrapper
pub fn slice(&self, offset: usize, len: usize) -> Option<&[u8]> {
    if offset + len <= self.buf.len() {
        // SAFETY: bounds checked above
        Some(unsafe { self.slice_unchecked(offset, len) })
    } else {
        None
    }
}
```

## DON'T: Use Unsafe Casually

```rust
// BAD - unsafe to skip bounds check for "performance"
let val = unsafe { *slice.get_unchecked(i) };

// GOOD - let the compiler optimize bounds checks
let val = slice[i];
// or if you need Option:
let val = slice.get(i);
```

## FFI Safety

When calling C code through FFI:

```rust
// GOOD - wrap FFI in a safe abstraction
mod ffi {
    extern "C" { fn c_init(flags: u32) -> i32; }
}

pub fn init(flags: u32) -> Result<(), InitError> {
    // SAFETY: c_init is thread-safe and flags is a valid bitmask
    let ret = unsafe { ffi::c_init(flags) };
    if ret == 0 { Ok(()) } else { Err(InitError(ret)) }
}
```

- Always check return codes from C functions.
- Ensure C strings are null-terminated: use `CString` / `CStr`.
- Pin data that C code holds pointers to (prevent moves).

## Interior Mutability

| Type | Thread-safe | Use case |
|------|-------------|----------|
| `Cell<T>` | No | Copy types, single-threaded |
| `RefCell<T>` | No | Runtime borrow checking, single-threaded |
| `Mutex<T>` | Yes | Multi-threaded mutable access |
| `RwLock<T>` | Yes | Multi-threaded, read-heavy workloads |
| `OnceCell<T>` | Depends | Lazy initialization |

```rust
// GOOD - RefCell for single-threaded interior mutability
use std::cell::RefCell;

struct Cache {
    data: RefCell<HashMap<String, String>>,
}

impl Cache {
    fn get_or_insert(&self, key: &str) -> String {
        let mut data = self.data.borrow_mut();
        data.entry(key.to_string())
            .or_insert_with(|| expensive_compute(key))
            .clone()
    }
}
```

## Raw Pointer Rules

- Dereferencing raw pointers (`*const T`, `*mut T`) requires `unsafe`.
- Creating raw pointers is safe; only dereferencing is unsafe.
- Never create references from raw pointers without ensuring validity and aliasing rules.
- Prefer `NonNull<T>` over `*mut T` for non-null invariants.
