//! Pre-generation hook for the [`aztec`](crate::macros::aztec) macro.
//!
//! An external crate registers a comptime hook against a contract module; `aztec()` invokes every
//! hook registered for the module it is expanding and splices the returned items in, *before* it
//! generates the contract's wrappers/interface/dispatch/ABI. This lets features such as template
//! composition live in their own crate rather than being forked into aztec-nr. Registration must
//! run before `#[aztec]`, so the registering attribute is placed above `#[aztec]` (Noir applies
//! attributes top-to-bottom and shares comptime globals between them).

use crate::utils::cmap::CHashMap;

// A hook is `fn(Module) -> Quoted`, written inline rather than aliased because comptime-only types
// (`Module`, `Quoted`) cannot appear in a type alias.
comptime mut global PRE_GENERATION_HOOKS: CHashMap<Module, [fn(Module) -> Quoted]> = CHashMap::new();

/// Registers a hook to run when `#[aztec]` expands `host`. Call from an attribute above `#[aztec]`.
pub comptime fn register_hook(host: Module, hook: fn(Module) -> Quoted) {
    let existing = PRE_GENERATION_HOOKS.get(host);
    let updated = if existing.is_some() {
        existing.unwrap().push_back(hook)
    } else {
        @[hook]
    };
    PRE_GENERATION_HOOKS.insert(host, updated);
}

/// Invokes every hook registered for `m` and concatenates their output. Called by `aztec()`.
pub(crate) comptime fn run_hooks(m: Module) -> Quoted {
    let hooks = PRE_GENERATION_HOOKS.get(m).unwrap_or(@[]);
    let mut injected_items = quote {};
    for hook in hooks {
        let piece = hook(m);
        injected_items = quote {
            $injected_items
            $piece
        };
    }
    injected_items
}
