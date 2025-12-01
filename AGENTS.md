# Repository Guidelines

## Project Structure & Module Organization
- `VCVio/`: core framework for oracle-based crypto proofs; subfolders cover crypto foundations, operational semantics, and evaluation tools under the same namespace.
- `Examples/`: worked protocols (OTP, Regev, HHS variants, etc.) that show intended usage; mirror patterns here when adding new constructions.
- `ToMathlib/`: upstream candidates and shared utilities; keep dependencies minimal and names aligned with mathlib conventions.
- `LibSodium/`: FFI wrappers plus `c/libsodium.cpp` backing file (e.g., `SHA2.lean`, `MyAddTest.lean`); keep external code here and register new objects in `lakefile.lean` if needed.
- `scripts/`: build/lint utilities (`build-project.sh`, `lint-style.sh`, reviewers). Root `*.lean` files re-export modules; run `scripts/update-lib.sh` after adding files to keep them in sync. Toolchain is pinned by `lean-toolchain` and `lakefile.lean` to Lean `v4.24.0-rc1` and mathlib `v4.24.0-rc1`.

## Build, Test, and Development Commands
- `lake exe cache get && lake build` — fetch mathlib cache and build default targets (`VCVio`, `Examples`).
- `lake build Examples` — quick rebuild used by `scripts/build-project.sh`.
- `lake exe test` — runs the `Test` demo (random dice + `LibSodium` FFI) to sanity-check executables.
- `scripts/lint-style.sh` — Lean style lint (docstrings, headers, ≤100 cols, casing); adjust `scripts/style-exceptions.txt` only when unavoidable.
- Python helpers in `scripts/` rely on `pip install -r scripts/requirements.txt` if you need them.

## Coding Style & Naming Conventions
- Follow mathlib Lean style: 2-space indent, `snake_case` for defs/lemmas, PascalCase namespaces matching folder paths, module docstring at top.
- `autoImplicit` is disabled; declare binder types explicitly. Prefer small, named lemmas over long tactic blocks; keep lines ≤100 chars to satisfy linters.
- Place protocol- or primitive-specific lemmas under the matching `VCVio/...` area and reserve `Examples/` for illustrative constructions.

## Testing Guidelines
- Compilation is proof checking: run `lake build` before pushing. Use `lake exe test` when touching `LibSodium` or `Test.lean` to ensure the FFI path still works.
- For new executable demos, add a `lean_exe` entry in `lakefile.lean` and place the entrypoint as a root-level `*.lean`; keep IO randomness encapsulated via `OracleComp`.

## Commit & Pull Request Guidelines
- Prefer concise, present-tense messages; history shows short prefixes like `chore: bump ...` and `add ...`. Use `feat:`, `fix:`, `chore:`, etc., for clarity.
- PRs should include a brief scope summary, linked issues, notes on new assumptions/crypto primitives, and the commands you ran (`lake build`, `scripts/lint-style.sh`, optional `lake exe test`).
- Mention any FFI/C++ changes or cache updates so reviewers know to rebuild external objects.***
