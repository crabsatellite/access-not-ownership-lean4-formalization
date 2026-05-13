# Access, Not Ownership — Lean 4 Formalization

Formal verification of the labelled theorems, lemmas, and
corollaries of

> Li, Alex Chengyu. *Access, Not Ownership: An Orthogonality
> Theorem for AI Governance Regimes.* 2026.

**Paper:**
- SSRN abstract id [6733543](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=6733543)
- Zenodo DOI: TODO (to be added after Zenodo deposit)

## Status

The formalization machine-checks the **structural
mathematics** of the paper end-to-end inside Lean 4 +
Mathlib. Every paper-internal deduction is a genuine Lean 4
theorem — **zero `sorry`**.

All axioms are atomic minimal units, classified as one of:

* **Cat 2** — external published textbook results (opaque-
  carrier-bound + precise citation).
* **Cat 3** — paper-novel: typed primitive carriers or
  paper-stated atomic structural equations from Li 2026.
* **Lean kernel** — `propext`, `Classical.choice`,
  `Quot.sound`.

The project has **zero Cat 1 axioms** because the Mathlib
infrastructure for welfare economics, cost-minimisation
theory, CES production, IO credence-good Bertrand analysis,
and the menu-auction game-theoretic apparatus is absent. The
three corresponding `gapBlocked` entries in
[`AccessOrthogonality/Ledger.lean`](AccessOrthogonality/Ledger.lean)
record the deferred Mathlib derivations.

Every axiom is an atomic minimal unit (no composite
bundles). The authoritative current inventory of axiom
names, citations, and per-theorem dependencies is the `lake
env lean AccessOrthogonality/AxiomAudit.lean` output combined
with the `#eval` printout at the bottom of
[`AccessOrthogonality/Ledger.lean`](AccessOrthogonality/Ledger.lean);
see those sources for the live counts and per-axiom
citations.

## File structure

| File | Paper component |
|------|-----------------|
| [`AccessOrthogonality/Basic.lean`](AccessOrthogonality/Basic.lean) | Setup primitives (§3): `OwnershipType`, `AccessVector` (`bmu = (ω,π,ν)`), `Regime` (Definition `\label{def:regime}`), `OwnershipInvariant` (Definition `\label{def:owninv}`), provider profit / welfare scaffolding, six scope conditions `(SC1)–(SC6)` |
| [`AccessOrthogonality/Characterization.lean`](AccessOrthogonality/Characterization.lean) | Theorem `\label{thm:characterization}` (Access-Structure Separation, characterization form) + Proposition `\label{prop:four_mechanisms}` clauses (M_β), (M_γ), (M_δ) |
| [`AccessOrthogonality/Separation.lean`](AccessOrthogonality/Separation.lean) | Corollary `\label{thm:separation}` (constructive form; (SC1)+(SC3) ⇒ ownership-invariant via (M_α)+(M_β)) |
| [`AccessOrthogonality/Gini.lean`](AccessOrthogonality/Gini.lean) | Theorem `\label{thm:gini}` (GE_0 inequality bound) + Corollary `\label{cor:gini}` (Gini under Lerman-Yitzhaki comonotonicity) + monotonicity properties |
| [`AccessOrthogonality/AntiTipping.lean`](AccessOrthogonality/AntiTipping.lean) | Theorem `\label{thm:antitipping}` (anti-tipping under structural decoupling) + closed-form `Λ^eff(ω,π,ν)` (eq:lambda_eff_closed) + single-lever bound `ω > (Λ-1)/[δ + (β+γ)w_p]` (eq:single_lever) |
| [`AccessOrthogonality/Binding.lean`](AccessOrthogonality/Binding.lean) | Theorem `\label{thm:t4_binding}` (verification-binding) + Lemma `\label{lem:independence}` (credence-good gap independence) + Lemma `\label{lem:lizzeri}` (integrated seller-certifier rent, extension of Lizzeri 1999) + Lemma `\label{lem:bertrand}` (Bertrand among independent certifiers) |
| [`AccessOrthogonality/LongRun.lean`](AccessOrthogonality/LongRun.lean) | Theorem `\label{thm:longrun}` (long-run orthogonality under (M_α)+(M_β)) + Proposition `\label{prop:multi_agency}` (multi-agency robustness) |
| [`AccessOrthogonality/AxiomAudit.lean`](AccessOrthogonality/AxiomAudit.lean) | Trust audit: prints `#print axioms` for every paper-level theorem |
| [`AccessOrthogonality/Ledger.lean`](AccessOrthogonality/Ledger.lean) | Typed gap ledger: `GapStatus` × `InputCategory` orthogonal classification, with one `GapEntry` per atomic axiom, blocked route, and closed top-level result |

## Building

Requires Lean 4 toolchain `v4.30.0-rc2` (managed via `elan`).

```bash
# Install elan + Lean toolchain if not already
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh

# Get Mathlib cache (MUST run before `lake build` to avoid rebuilding Mathlib)
lake exe cache get

# Build
lake build

# Run axiom audit
lake env lean AccessOrthogonality/AxiomAudit.lean
```

## Trust verification

For an independent trust check, after `lake build`:

```bash
# Count of `sorry` (expect 0)
grep -rn '\bsorry\b' AccessOrthogonality/

# Print axiom dependencies of every paper-level theorem
lake env lean AccessOrthogonality/AxiomAudit.lean

# Print live gap-ledger inventory (status counts, input-category counts)
# — this is the authoritative inventory of atomic axioms, blocked
# routes, and closed top-level results
lake env lean AccessOrthogonality/Ledger.lean
```

## Audit history

The formalization has been built fresh from the paper text
following the Einstein-test template. The `attackHistory`
field of each `GapEntry` in
[`AccessOrthogonality/Ledger.lean`](AccessOrthogonality/Ledger.lean)
is the canonical location for round metadata (citation
revisions, atomic refactors, prior retractions); release-
level milestones are recorded in commit history and git
tags.

## Honest scope notes

A few places where the Lean encoding is structurally
narrower than the paper narrative; these are honest about
what the formalisation does and does not capture:

1. **Theorem `\label{thm:characterization}` iff.** The
   paper's §4.6 "Tautology critique" acknowledges that the
   iff statement at the carrier level is structurally
   tautological once the welfare functional is assumed to
   factor through the equilibrium allocation
   (`welfareFactorsThroughAllocation` Cat 3 atomic). The
   substantive content lives in:
   * the Cobb-Douglas-isocline cost-minimisation step
     (Cat 2 atomic `bestResponseUniqueAtThetaInvariantWelfare`,
     citing Mas-Colell-Whinston-Green Prop 5.C.2);
   * the four-mechanism enumeration (M_α through M_δ);
   * the long-run robustness asymmetry of
     Theorem `\label{thm:longrun}` distinguishing
     (M_α)+(M_β) from (M_γ).

   The Lean formalisation captures all three pieces, but
   each individual piece's content is what the paper §4.6
   already concedes: producer-theory + welfare-economics-
    standard composition. The composition is the
   contribution.

2. **Proposition `\label{prop:four_mechanisms}` clauses (M_β),
   (M_γ), (M_δ).** These are encoded as direct
   definitional unfoldings because each clause is
   *operationally* defined as "the best-response is
   θ-invariant" in different guises. The substantive
   content of the proposition is the *enumeration* itself
   plus Remark `\label{rem:exhaustiveness}` acknowledging
   the four are not provably exhaustive, neither of which
   are Lean-encodable as propositions.

3. **Theorem `\label{thm:antitipping}` four-lemma argument.**
   The paper §A.3 Lemmas 1–4 are qualitative motivation;
   the actual mathematical claim is `Λ^eff < 1 ⇒ no
   tipping`, which by Step 5–6 is encoded by the
   `single_lever_bound` theorem. The Lean encoding folds
   the four lemmas into the `StructurallyDecoupled`
   hypothesis without separate Cat 3 axioms because the
   axioms would have trivial conclusions (the qualitative
   content is absorbed into the structural-decoupling
   precondition).

4. **Theorem `\label{thm:longrun}` long-run-specific
   content.** The Lean encoding splits the long-run result
   into two theorems:
   * `thm_longrun`: welfare θ-invariance at fixed `bmu`,
     which composes the long-run Cat 3 atomics with the
     static `thm_separation_welfare_invariant`. The
     conclusion is *the same propositional type* as the
     static theorem because the welfare functional `W^*`
     does not change form between the static and long-run
     analyses.
   * `thm_longrun_policy_invariance`: the long-run-specific
     content — the equilibrium policy `m^*` and the
     resulting `bmu^*(m^*)` are themselves θ-invariant.
     This is what distinguishes the long-run from the
     static result.

5. **Proposition `\label{prop:multi_agency}`.** The
   multi-agency reduction is encoded by directly applying
   `thm_longrun` at the binding un-captured regulator
   `R_{k^*}`. The paper's intersection-as-binding-
   constraint formalism is structurally captured by the
   fact that the relevant single-regulator hypothesis
   suffices for the conclusion.

## License

[MIT](LICENSE) (c) 2026 Alex Li.
