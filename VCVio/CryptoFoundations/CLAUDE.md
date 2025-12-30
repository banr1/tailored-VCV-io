# CryptoFoundations - Cryptographic Primitives

Definitions for cryptographic primitives, security experiments, and hardness assumptions.

## Structure

- `HardnessAssumptions/` - Computational hardness assumptions
  - `DiffieHellman.lean` - DDH, CDH assumptions
  - `LWE.lean` - Learning With Errors
  - `HardRelation.lean` - Generic hard relation framework
  - `HardHomogeneousSpace.lean` - Hard homogeneous spaces
- `AsymmEncAlg.lean` - Asymmetric encryption (IND-CPA, IND-CCA)
- `SymmEncAlg.lean` - Symmetric encryption
- `SignatureAlg.lean` - Digital signatures (EUF-CMA)
- `SigmaAlg.lean` - Sigma protocols (3-round public-coin proofs)
- `FiatShamir.lean` - Fiat-Shamir transform (interactive → non-interactive)
- `Fork.lean` - Forking lemma for rewinding proofs
- `SecExp.lean` - Security experiment framework
- `KeyEncapMech.lean` - Key encapsulation mechanisms
- `Asymptotics/` - Asymptotic security definitions

## Key Types

```lean
-- Security experiment
structure SecExp (spec : OracleSpec ι) (α β : Type) extends OracleAlg spec where
  inp_gen : OracleComp spec α
  main : α → OracleComp spec β
  isValid : α → β → Bool

-- Advantage computation
def ProbComp.advantage (p : ProbComp Unit) : ℝ := |1 / 2 - ([= () | p]).toReal|
```

## Security Notions

- **IND-CPA** - Indistinguishability under chosen plaintext attack
- **IND-CCA** - Indistinguishability under chosen ciphertext attack
- **EUF-CMA** - Existential unforgeability under chosen message attack
- **DDH/CDH** - Decisional/Computational Diffie-Hellman
- **LWE** - Learning With Errors

## Usage Pattern

Security proofs typically:
1. Define a `SecExp` with adversary access
2. Show advantage is negligible via game hopping
3. Reduce to underlying hardness assumptions
