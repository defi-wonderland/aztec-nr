//! Generic extension hook for the [`aztec`](crate::macros::aztec) macro.
//!
//! An external crate registers a comptime callback against a contract module; `aztec()` invokes
//! every callback registered for the module it is expanding and splices the returned items in. This
//! lets features such as template composition live in their own crate rather than being forked into
//! aztec-nr. Registration must run before `#[aztec]`, so the registering attribute is placed above
//! `#[aztec]` (Noir applies attributes top-to-bottom and shares comptime globals between them).

use crate::utils::cmap::CHashMap;

// `fn(Module) -> Quoted` is written inline rather than aliased because comptime-only types
// (`Module`, `Quoted`) cannot appear in a type alias.
comptime mut global MACRO_EXTENSIONS: CHashMap<Module, [fn(Module) -> Quoted]> = CHashMap::new();

/// Registers a callback to run when `#[aztec]` expands `host`. Call from an attribute above `#[aztec]`.
pub comptime fn register_extension(host: Module, ext: fn(Module) -> Quoted) {
    let existing = MACRO_EXTENSIONS.get(host);
    let updated = if existing.is_some() {
        existing.unwrap().push_back(ext)
    } else {
        @[ext]
    };
    MACRO_EXTENSIONS.insert(host, updated);
}

/// Invokes every extension registered for `m` and concatenates their output. Called by `aztec()`.
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
