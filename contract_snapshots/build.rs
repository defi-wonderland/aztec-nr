use std::env;
use std::fs::{self, File};
use std::io::Write;
use std::path::{Path, PathBuf};

fn main() {
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    let dest = out_dir.join("tests.rs");
    let mut f = File::create(&dest).unwrap();

    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:rerun-if-changed=test_programs");

    write_dir_scanned_module(
        &mut f,
        &manifest_dir,
        "compile_failure",
        "run_compile_failure",
    );
    write_dir_scanned_module(
        &mut f,
        &manifest_dir,
        "compile_success",
        "run_compile_success",
    );
}

fn write_dir_scanned_module(f: &mut File, manifest_dir: &Path, module: &str, helper: &str) {
    let test_dir = manifest_dir.join(format!("test_programs/{module}"));
    let mut cases: Vec<(String, PathBuf)> = fs::read_dir(&test_dir)
        .unwrap_or_else(|e| {
            panic!("could not read {}: {e}", test_dir.display());
        })
        .filter_map(Result::ok)
        .filter(|e| e.path().is_dir() && e.path().join("Nargo.toml").exists())
        .map(|e| (e.file_name().into_string().unwrap(), e.path()))
        .collect();
    cases.sort_by(|a, b| a.0.cmp(&b.0));

    writeln!(f, "mod {module} {{").unwrap();
    for (name, path) in cases {
        if name.contains('-') {
            panic!("{module} case '{name}' must use '_' instead of '-'");
        }
        writeln!(
            f,
            "    #[test]\n    fn test_{name}() {{\n        super::{helper}(\"{name}\", std::path::PathBuf::from(r\"{path}\"));\n    }}",
            name = name,
            path = path.display()
        )
        .unwrap();
    }
    writeln!(f, "}}").unwrap();
}
