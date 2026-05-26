// Poison contract: EXPECTED to fail compilation.
//
// Composing two templates that both expose non-virtual `foo_value()` triggers inject-time
// selector collision. Virtual override resolves host-vs-template conflicts, not
// template-vs-template duplicates of the same selector.

use aztec::macros::{AztecConfig, aztec};

#[aztec(AztecConfig::new().compose("foo_template").compose("foo_collision"))]
pub contract CollisionHost {
    use aztec::macros::functions::{external, view};
}
