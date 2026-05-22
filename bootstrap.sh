#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

export RAYON_NUM_THREADS=${RAYON_NUM_THREADS:-16}
export HARDWARE_CONCURRENCY=${HARDWARE_CONCURRENCY:-16}
if [ -x "$HOME/.nargo/bin/nargo" ]; then
  export PATH="$HOME/.nargo/bin:$PATH"
fi
export NARGO=${NARGO:-nargo}

function echo_stderr {
  echo "$@" >&2
}

function require_cmd {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

function nargo_cmd {
  require_cmd "$NARGO"
  "$NARGO" "$@"
}

function build {
  # Being a library, aztec-nr does not technically need to be built. But we can still run nargo check to find any type
  # errors and prevent warnings.
  echo_stderr "Checking aztec-nr for warnings..."
  nargo_cmd check --deny-warnings

  # We also check that no docstring links are broken.
  nargo_cmd doc --check
}

composition_packages=(
  composition_multi_contract
  composition_transitive_contract
  composition_host_contract
  composition_override_contract
  composition_diamond_transitive_contract
)

function compile_composition_contracts {
  for package in "${composition_packages[@]}"; do
    nargo_cmd compile --package "$package" --silence-warnings
  done
}

function check_composition_tests {
  # These tests make TXE oracle calls at runtime. In this standalone repo CI we
  # compile them to catch regressions without depending on an external TXE/PXE
  # service being available.
  for package in "${composition_packages[@]}"; do
    nargo_cmd test --package "$package" --no-run --silence-warnings
  done
}

function contract_snapshot_tests {
  require_cmd cargo
  cargo test --manifest-path contract_snapshots/Cargo.toml --test snapshots -- --test-threads=1
}

function test {
  build
  compile_composition_contracts
  check_composition_tests
  contract_snapshot_tests
}

function format {
  nargo_cmd fmt
}

function release {
  release_git_push "master" "$REF_NAME"
}

function release_git_push {
  local branch_name=$1
  local tag_name=$2
  local mirrored_repo_url="https://github.com/AztecProtocol/aztec-nr.git"

  # Clean up our release directory.
  rm -rf release-out && mkdir release-out

  # Copy our git files to our release directory.
  git archive HEAD -- . | tar -x -C release-out

  cd release-out

  # Update Nargo.toml files to reference noir-protocol-circuits from the monorepo tag.
  local monorepo_url="https://github.com/AztecProtocol/aztec-packages"
  local monorepo_protocol_circuits_path="noir-projects/noir-protocol-circuits"

  # Find all Nargo.toml files that reference noir-protocol-circuits.
  local nargo_files
  nargo_files="$(find . -name 'Nargo.toml' | xargs grep --files-with-matches 'noir-protocol-circuits' || true)"

  # Replace relative paths with git references.
  for nargo_file in $nargo_files; do
    sed --regexp-extended --in-place \
      "s;path\s*=\s*\".*noir-protocol-circuits(.*)\";git=\"$monorepo_url\", tag=\"$tag_name\", directory=\"$monorepo_protocol_circuits_path\1\";" \
      "$nargo_file"
  done

  # CI needs to authenticate from GITHUB_TOKEN.
  gh auth setup-git &>/dev/null || true

  git init &>/dev/null
  git remote add origin "$mirrored_repo_url" &>/dev/null
  git fetch origin --quiet

  # Checkout the existing branch or create it if it doesn't exist.
  if git ls-remote --heads origin "$branch_name" | grep -q "$branch_name"; then
    git branch -f "$branch_name" origin/"$branch_name"
    git symbolic-ref HEAD refs/heads/"$branch_name"
    git reset --soft origin/"$branch_name"
  else
    git checkout -b "$branch_name"
  fi

  if git rev-parse "$tag_name" >/dev/null 2>&1; then
    echo "Tag $tag_name already exists. Skipping release."
  else
    git add .
    git commit -m "Release $tag_name." >/dev/null
    git tag -a "$tag_name" -m "Release $tag_name."
    git push origin "$branch_name" --quiet
    git push origin --quiet "$tag_name" --tags

    echo "Release complete ($tag_name) on branch $branch_name."
  fi
}

cmd=${1:-}
if [ $# -gt 0 ]; then
  shift
fi

case "$cmd" in
  "")
    build
    ;;
  "build")
    build
    ;;
  "compile-composition-contracts")
    compile_composition_contracts
    ;;
  "check-composition-tests")
    check_composition_tests
    ;;
  "test-contract-snapshots")
    contract_snapshot_tests
    ;;
  "test")
    test
    ;;
  "format")
    format
    ;;
  "release")
    release
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    exit 1
    ;;
esac
