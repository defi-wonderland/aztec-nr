#!/usr/bin/env bash
# Contracts in failure_contracts/ are expected to FAIL compilation due to macro enforcement.
# Usage: ./assert_macro_compilation_failure.sh

REPO=$(git rev-parse --show-toplevel)
NARGO=${NARGO:-"$REPO/noir/noir-repo/target/release/nargo"}

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

total_tests=0
passed_tests=0

test_compilation_failure() {
    local contract_dir=$1
    local pkg_name=$(basename "$contract_dir")
    ((total_tests++))

    echo "Testing compilation failure for: $pkg_name"

    if $NARGO compile --package "$pkg_name" 2>/dev/null; then
        echo -e "${RED}❌ Test failed: Compilation succeeded when it should have failed for $pkg_name${NC}"
        return 1
    else
        echo -e "${GREEN}✓ Test passed: Compilation failed as expected for $pkg_name${NC}"
        ((passed_tests++))
        return 0
    fi
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FAILURE_CONTRACTS_DIR="$SCRIPT_DIR/failure_contracts"

# Run nargo from this workspace root so it uses the correct workspace context
cd "$SCRIPT_DIR"

for contract in "$FAILURE_CONTRACTS_DIR"/*; do
    if [ -d "$contract" ]; then
        test_compilation_failure "$contract"
    fi
done

echo -e "\nTest Summary:"
echo -e "Total tests: $total_tests"
echo -e "Passed tests: $passed_tests"
echo -e "Failed tests: $((total_tests - passed_tests))"

[ "$total_tests" -eq "$passed_tests" ] || exit 1
