use aztec::macros::{aztec, AztecConfig};

// Success case for composed-only public contracts.
//
// This host declares no own public external functions. The composed `foo_template`
// contributes public wrappers that require `__aztec_nr_internals__create_public_self`.
// Compilation proves helper generation observes composed public functions.
#[aztec(AztecConfig::new().compose("foo_template"))]
pub contract ComposedPublicOnly {}
