// Poison contract: EXPECTED to fail compilation.
//
// Host defines `_foo_magic()` and also composes `foo_storage`, which migrates the same
// library method from the template. Compose-time dedup should reject the duplicate.

use aztec::macros::{AztecConfig, aztec};

#[aztec(AztecConfig::new().compose("foo_storage"))]
pub contract LibraryMethodHostCollisionHost {
    #[contract_library_method]
    fn _foo_magic() -> u32 {
        99
    }
}
