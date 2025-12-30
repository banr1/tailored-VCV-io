# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VCVio is a Lean 4 library for formally verified cryptography proofs in the computational model. It provides:
- Monadic syntax for oracle computations (`OracleComp`) with probabilistic computations (`ProbComp`) as a special case
- Denotational semantics (`evalDist`) for probability distributions and reasoning about probabilities
- Operational semantics (`simulateQ`) for simulating oracle behavior
- Definitions for cryptographic primitives (encryption, signatures, Sigma-protocols, etc.)

## Build Commands

```bash
# Build with cached mathlib artifacts (recommended for first build)
lake exe cache get && lake build

# Build main library and examples
lake build Examples

# Build only the VCVio library
lake build VCVio

# Run the test executable
lake build test && .lake/build/bin/test

# Style linting
./scripts/lint-style.sh

# Full build with linting
./scripts/build-project.sh
```

## Project Structure

- `VCVio/` - Core library
  - `OracleComp/` - Oracle computation monad and semantics
    - `OracleComp.lean` - Core `OracleComp spec α` type (free monad over `OracleQuery`)
    - `OracleSpec.lean` - Oracle specification definitions
    - `DistSemantics/` - Probability distribution semantics (`evalDist`, `probOutput`, `probEvent`)
    - `SimSemantics/` - Simulation semantics (`simulateQ`)
    - `QueryTracking/` - Logging, caching, counting oracles
    - `Coercions/` - Automatic lifting between oracle specs
  - `CryptoFoundations/` - Cryptographic primitives and hardness assumptions
    - `HardnessAssumptions/` - DiffieHellman, LWE, HardRelation
    - Encryption (`SymmEncAlg`, `AsymmEncAlg`), signatures (`SignatureAlg`, `SigmaAlg`)
  - `EvalDist/` - Distribution evaluation utilities
  - `ProgramLogic/` - Hoare-style reasoning for oracle computations
- `Examples/` - Example cryptographic constructions (ElGamal, Regev, OneTimePad, etc.)
- `ToMathlib/` - Code intended for eventual upstreaming to Mathlib
- `LibSodium/` - FFI bindings to libsodium C++ implementations

## Key Concepts

### OracleComp Monad
The central type is `OracleComp spec α` - computations with oracle access:
- `pure x` / `return x` - return a value
- `query i t` - query oracle `i` with input `t`
- `failure` - terminate computation
- `ProbComp α` = `OracleComp unifSpec α` (uniform random selection only)

### Oracle Specifications
- `OracleSpec ι` - indexed family of oracles with domain/range types
- `spec₁ ++ₒ spec₂` - combine oracle specs
- `spec₁ ⊂ₒ spec₂` - subspec relation (enables automatic lifting)

### Probability Notation
- `[= x | comp]` - probability of output `x`
- `[p | comp]` - probability of event `p`
- `[⊥ | comp]` - probability of failure

## Style Guidelines

- Files should have copyright headers and module docstrings
- Line length limit: 100 characters (URLs excepted)
- File length limit: 1500 lines
- Linters enabled: hashCommand, oldObtain, refine, style.cdot, style.dollarSyntax, style.longLine, style.longFile, style.missingEnd, style.setOption
- Use `fun a ↦ b` syntax (pp.unicode.fun enabled)
- `autoImplicit` and `relaxedAutoImplicit` are disabled

## Dependencies

- Lean 4 (v4.24.0-rc1)
- Mathlib4 (v4.24.0-rc1)
