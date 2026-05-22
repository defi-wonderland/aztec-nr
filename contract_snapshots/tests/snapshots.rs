use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::time::{SystemTime, UNIX_EPOCH};

fn manifest_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
}

/// `contract_snapshots/` -> standalone aztec-nr repo root.
fn repo_root() -> PathBuf {
    manifest_dir().parent().unwrap().to_path_buf()
}

/// Resolves the nargo binary to invoke. Checks the `NARGO` environment
/// variable first; falls back to `nargo` on PATH (as installed by aztec-up).
fn nargo_path() -> PathBuf {
    std::env::var("NARGO")
        .map(PathBuf::from)
        .unwrap_or_else(|_| PathBuf::from("nargo"))
}

fn nargo(dir: &Path) -> Command {
    let mut cmd = Command::new(nargo_path());
    cmd.current_dir(dir);
    cmd
}

fn copy_dir_all(src: &Path, dst: &Path) {
    fs::create_dir_all(dst).unwrap_or_else(|e| panic!("failed to create {}: {e}", dst.display()));
    for entry in
        fs::read_dir(src).unwrap_or_else(|e| panic!("failed to read {}: {e}", src.display()))
    {
        let entry = entry.unwrap();
        let ty = entry.file_type().unwrap();
        let from = entry.path();
        let to = dst.join(entry.file_name());
        if ty.is_dir() {
            copy_dir_all(&from, &to);
        } else {
            fs::copy(&from, &to).unwrap_or_else(|e| {
                panic!("failed to copy {} to {}: {e}", from.display(), to.display())
            });
        }
    }
}

/// Nargo always walks ancestors looking for a workspace. In this standalone
/// aztec-nr repo, snapshot test programs live under the root workspace but are
/// intentionally not workspace members because most are supposed to fail.
/// Copy each case to /tmp and rewrite local path dependencies to absolute repo
/// paths so nargo compiles the case package itself instead of the parent
/// workspace.
fn isolated_case_dir(name: &str, dir: &Path) -> PathBuf {
    let nonce = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    let tmp = std::env::temp_dir().join(format!(
        "aztec-nr-contract-snapshot-{}-{nonce}",
        name.replace('/', "_")
    ));
    if tmp.exists() {
        fs::remove_dir_all(&tmp).unwrap();
    }
    copy_dir_all(dir, &tmp);

    let manifest = tmp.join("Nargo.toml");
    let repo = repo_root();
    let mut toml = fs::read_to_string(&manifest).unwrap();
    toml = toml
        .replace(
            "../../../../aztec",
            &repo.join("aztec").display().to_string(),
        )
        .replace(
            "../../../../composition_tests/fixtures",
            &repo
                .join("composition_tests/fixtures")
                .display()
                .to_string(),
        );
    fs::write(&manifest, toml).unwrap();
    tmp
}

/// Scrubs nargo stderr before snapshotting:
///
/// 1. Drops non-deterministic git dependency cache output emitted on fresh CI
///    runners (`Cloning into ...`, `Updating files: ...`) and lock-wait lines.
/// 2. Replaces the absolute repo prefix with `<repo>` so call-stack lines
///    pointing into `aztec/src/macros/...` are stable across machines.
fn scrub_stderr(s: String) -> String {
    let prefix = format!("{}/", repo_root().display());
    s.lines()
        .filter(|l| {
            !l.contains("Waiting for lock")
                && !l.contains("Cloning into '")
                && !l.contains("Updating files:")
        })
        .map(|l| l.replace(&prefix, "<repo>/"))
        .collect::<Vec<_>>()
        .join("\n")
}

/// Asserts `nargo compile` fails for `dir` and snapshots scrubbed stderr.
fn run_compile_failure(name: &str, dir: PathBuf) {
    let tmp = isolated_case_dir(name, &dir);
    let out = nargo(&tmp)
        .args(["compile", "--silence-warnings"])
        .output()
        .unwrap_or_else(|e| panic!("could not invoke nargo at {:?}: {e}", nargo_path()));
    assert!(
        !out.status.success(),
        "{name} unexpectedly compiled successfully"
    );
    let stderr = scrub_stderr(String::from_utf8(out.stderr).expect("nargo stderr should be utf-8"));
    insta::with_settings!({ snapshot_path => format!("snapshots/compile_failure/{name}") }, {
        insta::assert_snapshot!("stderr", stderr);
    });
    let _ = fs::remove_dir_all(tmp);
}

/// Asserts `nargo compile` succeeds for `dir` and snapshots stderr (typically
/// empty, but captures any warnings nargo emits despite `--silence-warnings`).
fn run_compile_success(name: &str, dir: PathBuf) {
    let tmp = isolated_case_dir(name, &dir);
    let out = nargo(&tmp)
        .args(["compile", "--silence-warnings"])
        .output()
        .unwrap_or_else(|e| panic!("could not invoke nargo at {:?}: {e}", nargo_path()));
    if !out.status.success() {
        panic!(
            "{name} unexpectedly failed to compile:\n--- stderr ---\n{}",
            String::from_utf8_lossy(&out.stderr)
        );
    }
    let stderr = scrub_stderr(String::from_utf8(out.stderr).expect("nargo stderr should be utf-8"));
    insta::with_settings!({ snapshot_path => format!("snapshots/compile_success/{name}") }, {
        insta::assert_snapshot!("stderr", stderr);
    });
    let _ = fs::remove_dir_all(tmp);
}

include!(concat!(env!("OUT_DIR"), "/tests.rs"));
