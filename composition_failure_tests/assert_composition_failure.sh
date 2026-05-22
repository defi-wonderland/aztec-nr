#!/usr/bin/env bash
# Contracts in failure_contracts/ are expected to FAIL compilation.
# Each package may contain an expected_error.txt with a substring the error must contain.
# Usage: ./assert_composition_failure.sh [nargo_binary]

if [ -z "${1:-}" ] && [ -z "${NARGO:-}" ] && [ -x "$HOME/.nargo/bin/nargo" ]; then
    NARGO="$HOME/.nargo/bin/nargo"
else
    NARGO=${1:-${NARGO:-"nargo"}}
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

total_tests=0
passed_tests=0

test_compilation_failure() {
    local contract_dir=$1
    local pkg_name
    pkg_name=$(basename "$contract_dir")
    local expected_error=""
    ((total_tests++))

    if [ -f "$contract_dir/expected_error.txt" ]; then
        expected_error=$(cat "$contract_dir/expected_error.txt")
    fi

    echo "Testing: $pkg_name"

    local tmp_dir
    tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/aztec-nr-composition-failure-${pkg_name}.XXXXXX")
    cp -R "$contract_dir/." "$tmp_dir/"
    python3 - "$tmp_dir/Nargo.toml" "$REPO_ROOT" <<'PY'
import pathlib, sys
manifest = pathlib.Path(sys.argv[1])
repo = pathlib.Path(sys.argv[2])
toml = manifest.read_text()
toml = toml.replace("../../../aztec", str(repo / "aztec"))
toml = toml.replace("../../../composition_tests/fixtures", str(repo / "composition_tests/fixtures"))
manifest.write_text(toml)
PY

    local output
    output=$(cd "$tmp_dir" && "$NARGO" check 2>&1)
    local exit_code=$?
    rm -rf "$tmp_dir"

    if [ $exit_code -eq 126 ] || [ $exit_code -eq 127 ]; then
        echo -e "${RED}❌ FAIL: unable to execute nargo at $NARGO${NC}"
        echo "  Got: $(echo "$output" | tail -3)"
        return 1
    fi

    if [ $exit_code -eq 0 ]; then
        echo -e "${RED}❌ FAIL: compiled successfully when it should have failed${NC}"
        return 1
    fi

    if [ -n "$expected_error" ] && ! echo "$output" | grep -qF -- "$expected_error"; then
        echo -e "${RED}❌ FAIL: compiled with wrong error. Expected substring: '$expected_error'${NC}"
        echo "  Got: $(echo "$output" | tail -3)"
        return 1
    fi

    echo -e "${GREEN}✓ PASS${NC}"
    ((passed_tests++))
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
FAILURE_CONTRACTS_DIR="$SCRIPT_DIR/failure_contracts"

for contract in "$FAILURE_CONTRACTS_DIR"/*/; do
    [ -d "$contract" ] && test_compilation_failure "$contract"
done

echo ""
echo "Results: $passed_tests/$total_tests passed"
[ "$total_tests" -eq "$passed_tests" ] || exit 1
