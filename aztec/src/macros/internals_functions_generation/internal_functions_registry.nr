//! Registry for internal functions that are added to the corresponding global variable when the `#[internal(...)]`
//! macro is applied. This registry is then used by the `#[aztec]` macro to transform the internal functions.
//!
//! Note that we need to use this registry approach instead of directly iterating over the functions in the `#[aztec]`
//! macro, because at that point we do not have the information about whether a given internal function is private or
//! public. We only see the internal attribute itself, not the "private" or "public" argument.

use crate::utils::cmap::CHashMap;

// Key is a contract module, value is an array of function definitions. See the docs in
// `external_functions_registry` for the rationale behind the own/injected split.
comptime mut global PRIVATE_INTERNAL_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();
comptime mut global PUBLIC_INTERNAL_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();

comptime mut global INJECTED_PRIVATE_INTERNAL_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();
comptime mut global INJECTED_PUBLIC_INTERNAL_REGISTRY: CHashMap<Module, [FunctionDefinition]> = CHashMap::new();

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
    add_to_registry(&mut PRIVATE_INTERNAL_REGISTRY, f);
}

pub(crate) comptime fn add_public(f: FunctionDefinition) {
    add_to_registry(&mut PUBLIC_INTERNAL_REGISTRY, f);
}

/// Registers an externally-defined private internal function as injected into `host`. See
/// [`crate::macros::internals_functions_generation::external_functions_registry::add_injected_private`].
pub comptime fn add_injected_private(host: Module, f: FunctionDefinition) {
    add_to_registry_for_module(&mut INJECTED_PRIVATE_INTERNAL_REGISTRY, host, f);
}

/// Registers an externally-defined public internal function as injected into `host`. See
/// [`add_injected_private`].
pub comptime fn add_injected_public(host: Module, f: FunctionDefinition) {
    add_to_registry_for_module(&mut INJECTED_PUBLIC_INTERNAL_REGISTRY, host, f);
}

/// Returns only the functions registered by the module's own `#[internal("private")]` attributes.
/// Used where `FunctionDefinition::body` is called.
pub comptime fn get_own_private_functions(m: Module) -> [FunctionDefinition] {
    PRIVATE_INTERNAL_REGISTRY.get(m).unwrap_or(@[])
}

/// See [`get_own_private_functions`].
pub comptime fn get_own_public_functions(m: Module) -> [FunctionDefinition] {
    PUBLIC_INTERNAL_REGISTRY.get(m).unwrap_or(@[])
}

/// Returns the module's own private internal functions plus any injected by macro extensions. Used
/// for `call_internal` struct generation, where `FunctionDefinition::body` is not called.
pub(crate) comptime fn get_private_functions(m: Module) -> [FunctionDefinition] {
    get_own_private_functions(m).append(INJECTED_PRIVATE_INTERNAL_REGISTRY.get(m).unwrap_or(@[]))
}

/// See [`get_private_functions`].
pub(crate) comptime fn get_public_functions(m: Module) -> [FunctionDefinition] {
    get_own_public_functions(m).append(INJECTED_PUBLIC_INTERNAL_REGISTRY.get(m).unwrap_or(@[]))
}
