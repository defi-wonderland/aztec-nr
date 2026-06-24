//! Generic extension hook for the [`crate::macros::aztec`] macro.
//!
//! This lets code *outside* aztec-nr participate in contract code generation without editing the
//! `aztec()` macro itself. An external crate registers a comptime callback against a contract
//! module; `aztec()` invokes every callback registered for the module it is expanding and splices
//! the returned contract items into the contract.
//!
//! ## Motivation
//!
//! Features such as contract template composition, mixins, or auto-generated standard interfaces
//! all want to *inject extra functions* into a host contract at compile time. Doing this used to
//! require forking aztec-nr to add bespoke fields to [`crate::macros::AztecConfig`] and bespoke
//! logic to `aztec()`. With this hook, such features can live in their own crate that depends on
//! aztec-nr and registers itself here, leaving `aztec()` and `AztecConfig` untouched.
//!
//! ## How it works
//!
//! Noir applies attributes top-to-bottom, and a `comptime mut global` written by one attribute is
//! visible to a later attribute on the same item. So an extension is supplied as a marker attribute
//! placed **above** `#[aztec]`:
//!
//! ```noir
//! #[my_extension::compose("some-template")]   // calls register_extension(m, ...) during its expansion
//! #[aztec]
//! pub contract Foo { ... }
//! ```
//!
//! The marker attribute records whatever data it needs (e.g. in its own crate-local global) and
//! calls [`register_extension`]. When `#[aztec]` then expands `Foo`, it calls every registered
//! callback via [`run_extensions`].
//!
//! ## Injecting functions that participate in dispatch / interfaces / ABI
//!
//! A callback that only wants to *append* items returns them as `Quoted`. A callback that wants its
//! injected functions to appear in the generated public dispatch, contract interface and ABI
//! exports must additionally register their `FunctionDefinition`s through the injected-function
//! registries in [`crate::macros::internals_functions_generation`]. `aztec()` invokes callbacks
//! before it processes functions and builds those artifacts, so registrations made from within a
//! callback are picked up.
//!
//! Because Noir cannot call `FunctionDefinition::body` on a function defined in another crate, an
//! injecting extension should pre-generate the `__aztec_nr_internals__` wrappers and ABI export
//! structs from *within the defining crate* (where the body is available) and return that
//! pre-generated `Quoted` from its callback. See the injected-function registry split in
//! [`crate::macros::internals_functions_generation::external_functions_registry`].

use crate::utils::cmap::CHashMap;

// A macro extension callback receives the host contract `Module` being expanded by `#[aztec]` and
// returns extra contract items (`Quoted`) to splice into the generated contract. It is written
// inline as `fn(Module) -> Quoted` rather than aliased, because comptime-only types (`Module`,
// `Quoted`) cannot appear in a (non-comptime) type alias.
comptime mut global MACRO_EXTENSIONS: CHashMap<Module, [fn(Module) -> Quoted]> = CHashMap::new();

/// Registers a macro extension callback to run when `#[aztec]` expands `host`.
///
/// Call this from a marker attribute placed **above** `#[aztec]` on the contract module (see the
/// module-level docs for ordering rationale). Callbacks run in registration order.
///
/// Registering the same callback more than once for a module will run it more than once; callers
/// that may be applied repeatedly should guard against duplicate registration themselves.
pub comptime fn register_extension(host: Module, ext: fn(Module) -> Quoted) {
    let existing = MACRO_EXTENSIONS.get(host);
    let updated = if existing.is_some() {
        existing.unwrap().push_back(ext)
    } else {
        @[ext]
    };
    MACRO_EXTENSIONS.insert(host, updated);
}

/// Invokes every extension registered for `m` and concatenates their output.
///
/// Called by `aztec()` before it processes the contract's own functions so that any functions an
/// extension injects into the registries are visible to interface, dispatch and ABI generation.
pub(crate) comptime fn run_extensions(m: Module) -> Quoted {
    let extensions = MACRO_EXTENSIONS.get(m).unwrap_or(@[]);
    let mut injected_items = quote {};
    for ext in extensions {
        let piece = ext(m);
        injected_items = quote {
            $injected_items
            $piece
        };
    }
    injected_items
}
