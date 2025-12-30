# VCVio Core Library

This directory contains the core VCVio library for formally verified cryptography proofs.

## Directory Structure

- `OracleComp/` - Oracle computation monad and semantics
  - `OracleComp.lean` - Core `OracleComp spec α` type (free monad over `OracleQuery`)
  - `OracleSpec.lean` - Oracle specification definitions
  - `DistSemantics/` - Probability distribution semantics (`evalDist`, `probOutput`, `probEvent`)
  - `SimSemantics/` - Simulation semantics (`simulateQ`)
  - `QueryTracking/` - Logging, caching, counting, seeded oracles
  - `Coercions/` - Automatic lifting between oracle specs
  - `Constructions/` - Common constructions (`UniformSelect`, `Replicate`, `GenerateSeed`)
  - `Support.lean` - Support of oracle computations
  - `QueryBound.lean` - Query bound tracking
  - `Traversal.lean` - Traversal utilities
  - `RunIO.lean` - IO execution
- `CryptoFoundations/` - Cryptographic primitives and hardness assumptions
  - `HardnessAssumptions/` - DiffieHellman, LWE, HardRelation
  - `AsymmEncAlg.lean` - Asymmetric encryption algorithms
  - `SymmEncAlg.lean` - Symmetric encryption algorithms
  - `SignatureAlg.lean` - Digital signature algorithms
  - `SigmaAlg.lean` - Sigma protocol definitions
  - `FiatShamir.lean` - Fiat-Shamir transform
  - `Fork.lean` - Forking lemma
  - `SecExp.lean` - Security experiments
  - `Asymptotics/` - Asymptotic security definitions
- `EvalDist/` - Distribution evaluation utilities
- `ProgramLogic/` - Hoare-style reasoning for oracle computations

## Key Types

### OracleComp Monad
```lean
inductive OracleComp (spec : OracleSpec ι) (α : Type)
  | pure : α → OracleComp spec α
  | queryBind : (i : ι) → spec.domain i → (spec.range i → OracleComp spec α) → OracleComp spec α
  | failure : OracleComp spec α
```

### Oracle Specifications
```lean
structure OracleSpec (ι : Type) where
  domain : ι → Type
  range : ι → Type
```

### Probability Notation
- `[= x | comp]` - probability of output `x`
- `[p | comp]` - probability of event `p`
- `[⊥ | comp]` - probability of failure

## Common Operations

- `query i t` - query oracle `i` with input `t`
- `$ᵗ xs` - uniform selection from finite type/list
- `comp₁ >>= comp₂` - sequential composition
- `simulateQ so comp` - simulate computation with oracle implementation

## Style Notes

- All files should have copyright headers and module docstrings
- Line length limit: 100 characters
- Use `fun a ↦ b` syntax
- `autoImplicit` and `relaxedAutoImplicit` are disabled
