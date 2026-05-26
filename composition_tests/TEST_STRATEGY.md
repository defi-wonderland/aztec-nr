# Composition test strategy

Map of composition test coverage. Updated when tests are added or removed.

Run:

```bash
scripts/test.sh              # compile + happy-path + failure poison tests
scripts/test.sh composition  # happy-path only
scripts/test.sh failure      # compile-failure poison only
```

## Tree

```
composition testing
├── harness
│   ├── scripts/test.sh
│   │   ├── aztec compile --workspace --force   (all composition host packages)
│   │   ├── aztec test --package <host>         (per happy-path package)
│   │   └── composition_failure_tests/assert_composition_failure.sh
│   └── composition_tests/fixtures/             (shared template library; not a test crate)
│
├── happy-path (runtime: aztec test)
│   ├── composition_host_contract
│   │   └── storage / events / internals / library-method migration (foo_storage)
│   │       ├── foo_storage_externals_are_exposed_on_host
│   │       ├── composed_internal_drives_host_storage
│   │       ├── composed_external_mutates_host_storage
│   │       ├── library_method_constant_is_migrated
│   │       └── composed_function_calling_library_method_works
│   │
│   ├── composition_multi_contract
│   │   └── direct multi-template compose (foo + bar)
│   │       ├── can_expose_two_direct_templates_in_one_host
│   │       └── composed_internal_helpers_from_multiple_templates_are_callable
│   │
│   ├── composition_transitive_contract
│   │   └── transitive flattening (host → mid → foo/bar)
│   │       ├── transitive_root_template_is_available
│   │       └── transitive_composition_of_templates_is_flattened
│   │
│   ├── composition_diamond_transitive_contract
│   │   └── diamond transitive merge (shared leaf deduped)
│   │       └── transitive_diamond_same_leaf_is_merged_once
│   │
│   └── composition_override_contract
│       └── virtual override happy path
│           └── virtual_template_function_is_overridden_by_host
│
├── compile-failure poison (nargo check; expected_error.txt substring match)
│   ├── collision_no_override
│   ├── transitive_diamond_leaf_collision
│   ├── transitive_diamond_leaf_collision_reverse
│   ├── override_transitive_collision_without_override
│   ├── override_transitive_partial_override
│   ├── override_transitive_missing_direct_compose
│   ├── override_mid_template_local_fee_bps
│   ├── internal_override_non_virtual
│   ├── missing_storage_var
│   ├── storage_shape_mismatch
│   ├── event_collision_across_templates
│   ├── event_host_redeclares
│   ├── library_method_template_collision
│   ├── library_method_host_collision
│   ├── host_global_scope_resolved_limit
│   └── duplicate_template_id
│
└── fixture templates (building blocks; exercised indirectly)
    ├── foo_template / bar_template
    ├── mid_template
    ├── foo_storage_template
    ├── library_method_collision_template
    ├── foo_collision_template
    ├── virtual_template / virtual_mid_template
    ├── virtual_mid_override_chain_template
    ├── internal_override_template / internal_override_non_virtual_template
    ├── foo_event_collision_template
    ├── foo_raw_global_template
    └── transitive_diamond_*
```

## Coverage matrix

| Feature | Happy-path | Poison | Status |
|--------|------------|--------|--------|
| Direct `.compose("template")` | host, multi | — | tested |
| Transitive flattening | transitive | — | tested |
| Diamond shared-leaf dedup | diamond_transitive | — | tested |
| Storage field declaration | host | missing_storage_var, storage_shape_mismatch | tested |
| Event auto-replay | host | event_collision_across_templates, event_host_redeclares | tested |
| Library method migration | host | — | tested |
| Library method template-vs-template collision | — | library_method_template_collision | tested |
| Library method host-vs-template collision | — | library_method_host_collision | tested |
| Composed internal call | host, multi | — | tested |
| Public external template-vs-template collision | — | collision_no_override | tested |
| | | transitive_diamond_leaf_collision, transitive_diamond_leaf_collision_reverse | tested |
| Host-vs-template public external collision | — | override_transitive_collision_without_override | tested |
| | | override_transitive_partial_override | tested |
| | | override_mid_template_local_fee_bps | tested |
| Internal template-vs-template collision | — | — | non tested |
| Private external template-vs-template collision | — | — | non tested |
| Utility external template-vs-template collision | — | — | non tested |
| `override_template` happy path | override | — | tested |
| `override_template` validation errors | — | override_transitive_missing_direct_compose | tested |
| `override_internal_template` rejection | — | internal_override_non_virtual | tested |
| `override_internal_template` happy path | — | — | non tested |
| Raw global symbol in composed body | — | host_global_scope_resolved_limit | tested |
| Duplicate `contract_template` id | — | duplicate_template_id | tested |
| Template composes template (fixture registration) | fixtures compile | — | tested |
| Composed private external on host | — | — | non tested |
| Dispatch-layer public selector collision (`dispatch.nr`) | — | — | non tested |
| Template id hash collision (distinct ids, same key) | — | — | non tested (infeasible) |
