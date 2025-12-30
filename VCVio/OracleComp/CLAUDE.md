# OracleComp - Oracle Computation Monad

Core monad for computations with oracle access.

## Structure

- `OracleComp.lean` - Core `OracleComp spec α` type (free monad over `OracleQuery`)
- `OracleSpec.lean` - Oracle specification definitions (`OracleSpec ι`)
- `DistSemantics/` - Probability distribution semantics
  - `EvalDist.lean` - `evalDist` function mapping computations to distributions
  - `Monad.lean` - Monadic composition laws
  - `Simulate.lean` - Distribution semantics for simulation
  - `Alternative.lean` - Alternative monad semantics
  - `ActiveOracles.lean` - Active oracle tracking
- `SimSemantics/` - Operational simulation semantics
  - `SimulateQ.lean` - `simulateQ` for oracle implementation
  - `StateT.lean`, `WriterT.lean` - Monad transformer support
  - `Constructions.lean`, `Append.lean` - Simulation constructions
- `Coercions/` - Automatic lifting between oracle specs
  - `SubSpec.lean` - Subspec relation (`spec₁ ⊂ₒ spec₂`)
  - `Append.lean` - Append coercions
  - `SimOracle.lean` - Simulation oracle coercions
- `QueryTracking/` - Query observation utilities
  - `LoggingOracle.lean` - Query logging
  - `CachingOracle.lean` - Result caching
  - `CountingOracle.lean` - Query counting
  - `SeededOracle.lean` - Deterministic seeding
- `Constructions/` - Common constructions
  - `UniformSelect.lean` - `$ᵗ` uniform selection
  - `Replicate.lean` - Repeated computations
  - `GenerateSeed.lean` - Random seed generation
- `Support.lean` - Support of computations
- `QueryBound.lean` - Query complexity bounds
- `Traversal.lean` - Recursive traversal
- `RunIO.lean` - IO execution

## Key Types

```lean
-- Core computation type
inductive OracleComp (spec : OracleSpec ι) (α : Type)
  | pure : α → OracleComp spec α
  | queryBind : (i : ι) → spec.domain i → (spec.range i → OracleComp spec α) → OracleComp spec α
  | failure : OracleComp spec α

-- Oracle query
inductive OracleQuery (spec : OracleSpec ι) : Type → Type
  | query (i : ι) (t : spec.domain i) : OracleQuery spec (spec.range i)

-- Probabilistic computation (uniform randomness only)
abbrev ProbComp α := OracleComp unifSpec α
```

## Notation

- `query i t` - query oracle `i` with input `t`
- `$ᵗ xs` - uniform selection from finite type/list
- `[= x | oa]` - probability of output `x`
- `[p | oa]` - probability of event `p`
- `[⊥ | oa]` - probability of failure
