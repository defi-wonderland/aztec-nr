use aztec::macros::{aztec, contract_template};

#[contract_template("duplicate_id")]
#[aztec]
pub contract DuplicateTemplateA {
    use aztec::macros::functions::{external, view};

    #[external("public")]
    #[view]
    fn template_a_value() -> u32 {
        1
    }
}
