//! Registry for external functions that are added to the corresponding global variable when the `#[external(...)]`
//! macro is applied. This registry is then used by the `#[aztec]` macro to generate the functions prefixed with
//! `__aztec_nr_internals___` and the `public_dispatch` function.
//!
//! Note that we need to use this registry approach instead of directly iterating over the functions in the `#[aztec]`
//! macro, because at that point we do not have the information about whether a given external function is private or
//! public. We only see the internal attribute itself, not the "private" or "public" argument.

use crate::utils::cmap::CHashMap;

// Key is a contract module, value is an array of function definitions.
//
// The "own" registries hold functions defined by the module's own `#[external(...)]` attributes.
// The "injected" registries hold functions contributed by macro extensions (see
// `crate::macros::extensions`), keyed by the *host* module they are injected into. The split
// matters because `FunctionDefinition::body` cannot be called on a function from another crate:
// `process_functions` and ABI export generation only ever touch the module's own functions, while
// interface, self-call struct, and dispatch generation operate on own + injected.
comptime mut global PRIVATE_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();
comptime mut global PUBLIC_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();
comptime mut global UTILITY_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();

comptime mut global INJECTED_PRIVATE_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();
comptime mut global INJECTED_PUBLIC_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();
comptime mut global INJECTED_UTILITY_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();

comptime fn add_to_registry(registry: &mut CHashMap<Module, [FunctionDefinition]>, f: FunctionDefinition) {
    add_to_registry_for_module(registry, f.module(), f);
}

comptime fn add_to_registry_for_module(
    registry: &mut CHashMap<Module, [FunctionDefinition]>,
    m: Module,
    f: FunctionDefinition,
) {
    let current_functions = registry.get(m);
    let functions_to_insert = if current_functions.is_some() {
        current_functions.unwrap().push_back(f)
    } else {
        @[f]
    };
    registry.insert(m, functions_to_insert);
}

pub(crate) comptime fn add_private(f: FunctionDefinition) {
    add_to_registry(&mut PRIVATE_REGISTRY, f);
}

pub(crate) comptime fn add_public(f: FunctionDefinition) {
    add_to_registry(&mut PUBLIC_REGISTRY, f);
}

pub(crate) comptime fn add_utility(f: FunctionDefinition) {
    add_to_registry(&mut UTILITY_REGISTRY, f);
}

/// Registers an externally-defined private external function as injected into `host`.
///
/// Used by macro extensions (see `crate::macros::extensions`) so that the injected function appears
/// in the host's generated interface, self-call structs and public dispatch. The extension is
/// responsible for emitting the function's `__aztec_nr_internals__` wrapper and ABI export itself
/// (typically pre-generated in the defining crate), since `process_functions` skips injected
/// functions to avoid calling `FunctionDefinition::body` across crates.
pub comptime fn add_injected_private(host: Module, f: FunctionDefinition) {
    add_to_registry_for_module(&mut INJECTED_PRIVATE_REGISTRY, host, f);
}

/// Registers an externally-defined public external function as injected into `host`. See
/// [`add_injected_private`].
pub comptime fn add_injected_public(host: Module, f: FunctionDefinition) {
    add_to_registry_for_module(&mut INJECTED_PUBLIC_REGISTRY, host, f);
}

/// Registers an externally-defined utility function as injected into `host`. See
/// [`add_injected_private`].
pub comptime fn add_injected_utility(host: Module, f: FunctionDefinition) {
    add_to_registry_for_module(&mut INJECTED_UTILITY_REGISTRY, host, f);
}

/// Returns only the functions registered by the module's own `#[external("private")]` attributes.
/// Used where `FunctionDefinition::body` is called, so injected (possibly cross-crate) functions
/// must be excluded.
pub(crate) comptime fn get_own_private_functions(m: Module) -> [FunctionDefinition] {
    PRIVATE_REGISTRY.get(m).unwrap_or(@[])
}

/// See [`get_own_private_functions`].
pub(crate) comptime fn get_own_public_functions(m: Module) -> [FunctionDefinition] {
    PUBLIC_REGISTRY.get(m).unwrap_or(@[])
}

/// See [`get_own_private_functions`].
pub(crate) comptime fn get_own_utility_functions(m: Module) -> [FunctionDefinition] {
    UTILITY_REGISTRY.get(m).unwrap_or(@[])
}

/// Returns the module's own private external functions plus any injected by macro extensions. Used
/// for interface/dispatch generation, where `FunctionDefinition::body` is not called.
pub(crate) comptime fn get_private_functions(m: Module) -> [FunctionDefinition] {
    get_own_private_functions(m).append(INJECTED_PRIVATE_REGISTRY.get(m).unwrap_or(@[]))
}

/// See [`get_private_functions`].
pub(crate) comptime fn get_public_functions(m: Module) -> [FunctionDefinition] {
    get_own_public_functions(m).append(INJECTED_PUBLIC_REGISTRY.get(m).unwrap_or(@[]))
}

/// See [`get_private_functions`].
pub(crate) comptime fn get_utility_functions(m: Module) -> [FunctionDefinition] {
    get_own_utility_functions(m).append(INJECTED_UTILITY_REGISTRY.get(m).unwrap_or(@[]))
}
