mod compile_failure {
    #[test]
    fn test_allow_phase_change_on_non_external_fn() {
        super::run_compile_failure("allow_phase_change_on_non_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/allow_phase_change_on_non_external_fn"));
    }
    #[test]
    fn test_allow_phase_change_on_utility_fn() {
        super::run_compile_failure("allow_phase_change_on_utility_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/allow_phase_change_on_utility_fn"));
    }
    #[test]
    fn test_authorization_selector_collision() {
        super::run_compile_failure("authorization_selector_collision", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/authorization_selector_collision"));
    }
    #[test]
    fn test_authorize_once_from_wrong_type() {
        super::run_compile_failure("authorize_once_from_wrong_type", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/authorize_once_from_wrong_type"));
    }
    #[test]
    fn test_authorize_once_missing_from_param() {
        super::run_compile_failure("authorize_once_missing_from_param", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/authorize_once_missing_from_param"));
    }
    #[test]
    fn test_authorize_once_missing_nonce_param() {
        super::run_compile_failure("authorize_once_missing_nonce_param", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/authorize_once_missing_nonce_param"));
    }
    #[test]
    fn test_authorize_once_nonce_wrong_type() {
        super::run_compile_failure("authorize_once_nonce_wrong_type", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/authorize_once_nonce_wrong_type"));
    }
    #[test]
    fn test_authorize_once_on_non_external_fn() {
        super::run_compile_failure("authorize_once_on_non_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/authorize_once_on_non_external_fn"));
    }
    #[test]
    fn test_authorize_once_on_utility_fn() {
        super::run_compile_failure("authorize_once_on_utility_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/authorize_once_on_utility_fn"));
    }
    #[test]
    fn test_aztec_macro_too_many_args() {
        super::run_compile_failure("aztec_macro_too_many_args", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/aztec_macro_too_many_args"));
    }
    #[test]
    fn test_bob_token() {
        super::run_compile_failure("bob_token", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/bob_token"));
    }
    #[test]
    fn test_collision_no_override() {
        super::run_compile_failure("collision_no_override", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/collision_no_override"));
    }
    #[test]
    fn test_duplicate_storage() {
        super::run_compile_failure("duplicate_storage", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/duplicate_storage"));
    }
    #[test]
    fn test_event_collision_across_templates() {
        super::run_compile_failure("event_collision_across_templates", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/event_collision_across_templates"));
    }
    #[test]
    fn test_event_host_redeclares() {
        super::run_compile_failure("event_host_redeclares", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/event_host_redeclares"));
    }
    #[test]
    fn test_event_selector_collision() {
        super::run_compile_failure("event_selector_collision", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/event_selector_collision"));
    }
    #[test]
    fn test_external_and_internal_together() {
        super::run_compile_failure("external_and_internal_together", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/external_and_internal_together"));
    }
    #[test]
    fn test_host_global_scope_resolved_limit() {
        super::run_compile_failure("host_global_scope_resolved_limit", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/host_global_scope_resolved_limit"));
    }
    #[test]
    fn test_incorrect_storage_struct_name() {
        super::run_compile_failure("incorrect_storage_struct_name", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/incorrect_storage_struct_name"));
    }
    #[test]
    fn test_initializer_on_non_external_fn() {
        super::run_compile_failure("initializer_on_non_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/initializer_on_non_external_fn"));
    }
    #[test]
    fn test_initializer_on_utility_fn() {
        super::run_compile_failure("initializer_on_utility_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/initializer_on_utility_fn"));
    }
    #[test]
    fn test_internal_override_non_virtual() {
        super::run_compile_failure("internal_override_non_virtual", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/internal_override_non_virtual"));
    }
    #[test]
    fn test_invalid_event() {
        super::run_compile_failure("invalid_event", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/invalid_event"));
    }
    #[test]
    fn test_invalid_external_function_type() {
        super::run_compile_failure("invalid_external_function_type", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/invalid_external_function_type"));
    }
    #[test]
    fn test_invalid_internal_function_type() {
        super::run_compile_failure("invalid_internal_function_type", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/invalid_internal_function_type"));
    }
    #[test]
    fn test_invalid_note() {
        super::run_compile_failure("invalid_note", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/invalid_note"));
    }
    #[test]
    fn test_marked_private_unconstrained() {
        super::run_compile_failure("marked_private_unconstrained", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/marked_private_unconstrained"));
    }
    #[test]
    fn test_marked_public_unconstrained() {
        super::run_compile_failure("marked_public_unconstrained", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/marked_public_unconstrained"));
    }
    #[test]
    fn test_missing_storage_var() {
        super::run_compile_failure("missing_storage_var", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/missing_storage_var"));
    }
    #[test]
    fn test_noinitcheck_on_non_external_fn() {
        super::run_compile_failure("noinitcheck_on_non_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/noinitcheck_on_non_external_fn"));
    }
    #[test]
    fn test_noinitcheck_on_utility_fn() {
        super::run_compile_failure("noinitcheck_on_utility_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/noinitcheck_on_utility_fn"));
    }
    #[test]
    fn test_noinitcheck_without_initializer() {
        super::run_compile_failure("noinitcheck_without_initializer", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/noinitcheck_without_initializer"));
    }
    #[test]
    fn test_non_deserializable() {
        super::run_compile_failure("non_deserializable", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/non_deserializable"));
    }
    #[test]
    fn test_non_serializable() {
        super::run_compile_failure("non_serializable", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/non_serializable"));
    }
    #[test]
    fn test_only_self_on_non_external_fn() {
        super::run_compile_failure("only_self_on_non_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/only_self_on_non_external_fn"));
    }
    #[test]
    fn test_only_self_on_utility_fn() {
        super::run_compile_failure("only_self_on_utility_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/only_self_on_utility_fn"));
    }
    #[test]
    fn test_override_mid_template_local_fee_bps() {
        super::run_compile_failure("override_mid_template_local_fee_bps", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/override_mid_template_local_fee_bps"));
    }
    #[test]
    fn test_override_transitive_collision_without_override() {
        super::run_compile_failure("override_transitive_collision_without_override", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/override_transitive_collision_without_override"));
    }
    #[test]
    fn test_override_transitive_missing_direct_compose() {
        super::run_compile_failure("override_transitive_missing_direct_compose", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/override_transitive_missing_direct_compose"));
    }
    #[test]
    fn test_override_transitive_partial_override() {
        super::run_compile_failure("override_transitive_partial_override", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/override_transitive_partial_override"));
    }
    #[test]
    fn test_panic_on_direct_private_external_fn_call() {
        super::run_compile_failure("panic_on_direct_private_external_fn_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_direct_private_external_fn_call"));
    }
    #[test]
    fn test_panic_on_direct_private_internal_fn_call() {
        super::run_compile_failure("panic_on_direct_private_internal_fn_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_direct_private_internal_fn_call"));
    }
    #[test]
    fn test_panic_on_direct_public_external_fn_call() {
        super::run_compile_failure("panic_on_direct_public_external_fn_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_direct_public_external_fn_call"));
    }
    #[test]
    fn test_panic_on_direct_public_internal_fn_call() {
        super::run_compile_failure("panic_on_direct_public_internal_fn_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_direct_public_internal_fn_call"));
    }
    #[test]
    fn test_panic_on_direct_utility_external_fn_call() {
        super::run_compile_failure("panic_on_direct_utility_external_fn_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_direct_utility_external_fn_call"));
    }
    #[test]
    fn test_panic_on_incorrectly_performed_private_call() {
        super::run_compile_failure("panic_on_incorrectly_performed_private_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_incorrectly_performed_private_call"));
    }
    #[test]
    fn test_panic_on_incorrectly_performed_private_static_call() {
        super::run_compile_failure("panic_on_incorrectly_performed_private_static_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_incorrectly_performed_private_static_call"));
    }
    #[test]
    fn test_panic_on_incorrectly_performed_public_call() {
        super::run_compile_failure("panic_on_incorrectly_performed_public_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_incorrectly_performed_public_call"));
    }
    #[test]
    fn test_panic_on_incorrectly_performed_public_static_call() {
        super::run_compile_failure("panic_on_incorrectly_performed_public_static_call", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_incorrectly_performed_public_static_call"));
    }
    #[test]
    fn test_panic_on_non_state_var_in_storage() {
        super::run_compile_failure("panic_on_non_state_var_in_storage", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_non_state_var_in_storage"));
    }
    #[test]
    fn test_panic_on_owned_state_var_in_storage() {
        super::run_compile_failure("panic_on_owned_state_var_in_storage", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/panic_on_owned_state_var_in_storage"));
    }
    #[test]
    fn test_pub_private_external_fn() {
        super::run_compile_failure("pub_private_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/pub_private_external_fn"));
    }
    #[test]
    fn test_pub_public_external_fn() {
        super::run_compile_failure("pub_public_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/pub_public_external_fn"));
    }
    #[test]
    fn test_pub_utility_external_fn() {
        super::run_compile_failure("pub_utility_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/pub_utility_external_fn"));
    }
    #[test]
    fn test_public_allow_phase_change() {
        super::run_compile_failure("public_allow_phase_change", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/public_allow_phase_change"));
    }
    #[test]
    fn test_public_function_selector_collision() {
        super::run_compile_failure("public_function_selector_collision", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/public_function_selector_collision"));
    }
    #[test]
    fn test_reserved_emit_public_init_nullifier() {
        super::run_compile_failure("reserved_emit_public_init_nullifier", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/reserved_emit_public_init_nullifier"));
    }
    #[test]
    fn test_reserved_public_dispatch() {
        super::run_compile_failure("reserved_public_dispatch", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/reserved_public_dispatch"));
    }
    #[test]
    fn test_storage_shape_mismatch() {
        super::run_compile_failure("storage_shape_mismatch", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/storage_shape_mismatch"));
    }
    #[test]
    fn test_transitive_diamond_leaf_collision() {
        super::run_compile_failure("transitive_diamond_leaf_collision", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/transitive_diamond_leaf_collision"));
    }
    #[test]
    fn test_transitive_diamond_leaf_collision_reverse() {
        super::run_compile_failure("transitive_diamond_leaf_collision_reverse", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/transitive_diamond_leaf_collision_reverse"));
    }
    #[test]
    fn test_unmacroified_function_in_contract() {
        super::run_compile_failure("unmacroified_function_in_contract", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/unmacroified_function_in_contract"));
    }
    #[test]
    fn test_user_defined_offchain_receive() {
        super::run_compile_failure("user_defined_offchain_receive", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/user_defined_offchain_receive"));
    }
    #[test]
    fn test_utility_not_unconstrained() {
        super::run_compile_failure("utility_not_unconstrained", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/utility_not_unconstrained"));
    }
    #[test]
    fn test_view_on_non_external_fn() {
        super::run_compile_failure("view_on_non_external_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/view_on_non_external_fn"));
    }
    #[test]
    fn test_view_on_utility_fn() {
        super::run_compile_failure("view_on_utility_fn", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_failure/view_on_utility_fn"));
    }
}
mod compile_success {
    #[test]
    fn test_authorize_once_before_external() {
        super::run_compile_success("authorize_once_before_external", std::path::PathBuf::from(r"/tmp/aztec-nr-work.wsnD4O/contract_snapshots/test_programs/compile_success/authorize_once_before_external"));
    }
}
