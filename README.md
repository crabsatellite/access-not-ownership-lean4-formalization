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
skeleton** of the paper inside Lean 4 + Mathlib. Every
paper-level theorem (`thm_characterization`,
`thm_separation`, `thm_gini`, `cor_gini`, `thm_antitipping`,
`thm_t4_binding`, `thm_longrun`, `prop_multi_agency`) is a
genuine Lean 4 `theorem` with **zero `sorry`**, deriving its
conclusion from explicitly-declared atomic axioms via
kernel-checked Lean proofs.

Every inventory entry is classified by 4-input-category:

* **Cat 1** — Mathlib-derivable helper facts, encoded as
  `theorem`/`lemma := <Mathlib proof>` (status `gapClosed`).
  These are elementary `AccessVector` / `ScalingParameters`
  arithmetic bounds (`muProduct_nonneg`, `muProduct_le_one`,
  `muBottleneck_nonneg`, `Lambda_nonneg`).
* **Cat 2** — external published textbook results (opaque-
  carrier-bound + precise citation; subject to a structured
  classification audit).
* **Cat 3** — paper-novel: typed primitive carriers,
  hypothesis predicates, or paper-stated atomic structural
  equations from Li 2026.
* **Lean kernel** — `propext`, `Classical.choice`,
  `Quot.sound`.

The project has **zero Cat 1 axioms** (the 4 Cat 1 entries
are `theorem`/`lemma` declarations, not `axiom`s) because the
Mathlib infrastructure for welfare economics, cost-
minimisation theory, CES production, IO credence-good
Bertrand analysis, and the menu-auction game-theoretic
apparatus is absent — that is the apparatus that would
require Cat 1 *axioms*. The three corresponding `gapBlocked`
entries in
[`AccessOrthogonality/Ledger.lean`](AccessOrthogonality/Ledger.lean)
record the deferred Mathlib derivations.

The authoritative current inventory of axiom names,
citations, and per-theorem dependencies is the `lake env
lean AccessOrthogonality/AxiomAudit.lean` output combined
with the `#eval` printout at the bottom of
[`AccessOrthogonality/Ledger.lean`](AccessOrthogonality/Ledger.lean);
see those sources for the live counts and per-axiom
citations.

### Honest scope

The Lean encoding sits at the **abstract carrier layer** —
it formalises the *compositional structure* of the paper
proofs (which atomic axioms compose to which top-level
theorem, with kernel-checked proofs of every composition)
but does NOT re-derive the underlying economics from first
principles. Specifically:

1. **Cat 2 axioms are opaque carriers** of the cited
   external textbook results (MWG 1995 §5.D / §10.D / §16.F;
   Lizzeri 1999 RAND 30(2) Prop 1). Their Lean encoding
   asserts the paper-claim type signature; the underlying
   textbook proofs are NOT formalised in this project (they
   sit at the `gapBlocked` Mathlib-derivation deferral).
2. **Cat 3 axioms are paper-stipulative atoms** — primitive
   types, hypothesis predicates, structural defining
   equations — that are paper-introduced commitments, not
   Lean-derivable claims. These have status `gapDefinitional`
   (never expected to close by Lean derivation).
3. **Hypothesis predicates are encoded as OPAQUE Props.**
   HA-7, `IsLongRunEquilibriumOf`, `SC4`-`SC6`, and
   `OnSameIsocline` are opaque axioms; downstream theorems
   propagate them as explicit hypotheses (e.g., `thm_gini`,
   `cor_gini` take `hHA7` as a parameter). This avoids
   vacuous `def := True` or LEM-tautology encodings.
4. **Mechanism enumeration (richer-carrier encoding).**
   Paper Proposition `prop:four_mechanisms` distinguishes
   (M_α), (M_β), (M_γ), (M_δ) by their MECHANISM (rent-zero
   margin / regulator-pinning / FOC alignment / external-
   constraint-binding). The Lean encoding makes the three
   non-(M_α) mechanism predicates genuinely distinct types:
   * `MechanismMbeta` predicates on `R.financingMechanism`
     (the regime designates a unique self-funded allocation);
     `prop_four_mechanisms_Mbeta` is a genuine FOC-free Lean
     derivation depending on no axioms.
   * `MechanismMdelta` predicates on `R.externalConstraints`
     (the external-constraint set is a singleton);
     `prop_four_mechanisms_Mdelta` is a genuine FOC-free Lean
     derivation depending on no axioms.
   * `MechanismMgamma` is the opaque Cat 3 carrier
     `ProfitWelfareGradientAlign P W br R` — it depends on
     the profit and welfare functionals `P`, `W` (unlike
     M_β / M_δ, which depend only on the regime). Its ⇒
     ownership-invariance step is the paper's FOC argument,
     encoded as the Cat 3 structural-equation axiom
     `gradientAlign_implies_ownership_invariant` (parallel to
     `SC1_implements_Malpha` / `SC3_implements_Mbeta`), since
     Lean does not model the producer-theory gradient
     apparatus (`gap_FOEconomics_Mathlib_BLOCKED`).
   (M_α) — "rent-zero margin" — is the `MechanismMalpha` def
   consumed as the load-bearing hypothesis of
   `\label{thm:longrun}`; its standalone ⇒
   ownership-invariance step also routes through the FOC
   apparatus, so like M_γ it is not given a free-standing
   FOC-free derivation. The four mechanisms are now four
   genuinely distinct types, no longer one shape stated
   three times.
5. **Theorem proofs use `Classical.choice`** (visible in
   `#print axioms` output): `obtain` on existentials,
   `by_cases` on opaque Props, etc. These are not
   kernel-pure but are paper-faithful (the paper proofs use
   classical reasoning).

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

## Audit trail

The formalization has been built directly from the paper
text. Per-entry iteration history lives in git commit
history; the `attackHistory` field of each `GapEntry` in
[`AccessOrthogonality/Ledger.lean`](AccessOrthogonality/Ledger.lean)
is reserved for trace notes and is empty in shipped
revisions.

## Honest scope notes

A few places where the Lean encoding is structurally
narrower than the paper narrative; these are honest about
what the formalisation does and does not capture:

1. **Theorem `\label{thm:characterization}` iff.** The
   paper's §4.6 "Tautology critique" acknowledges that the
   iff statement at the carrier level is structurally
   tautological once the welfare functional is assumed to
   factor through the equilibrium allocation
   (`welfareFactorsThroughAllocation` Cat 2 atomic). The
   substantive content lives in:
   * the Cobb-Douglas-isocline cost-minimisation derived
     theorem `bestResponseUniqueAtThetaInvariantWelfare`,
     which composes three atomics:
     `OnSameIsocline` (Cat 3 hypothesisPredicate; opaque
     case-split discriminator), `mwg_cost_min_uniqueness_-
     isocline` (Cat 2 citing MWG 1995 §5.D + elementary
     convex analysis: cost-min uniqueness on Cobb-Douglas
     isoclines comes from the §5.D level-set apparatus, not
     from any single MWG proposition), and
     `case_1_different_isoclines_implies_BR_invariant`
     (Cat 3 paper-novel Case 1 contradiction);
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
   (M_γ), (M_δ).** Under the richer-carrier encoding
   (see point 4 below), these are **three genuinely distinct
   types**:
   `MechanismMbeta` predicates on `R.financingMechanism`,
   `MechanismMdelta` on `R.externalConstraints`, and
   `MechanismMgamma` on the opaque Cat 3 carrier
   `ProfitWelfareGradientAlign` (which depends on the profit
   and welfare functionals). `prop_four_mechanisms_Mbeta` and
   `prop_four_mechanisms_Mdelta` are genuine FOC-free Lean
   derivations depending on no project axioms;
   `prop_four_mechanisms_Mgamma` routes through the Cat 3
   structural-equation axiom `gradientAlign_implies_ownership_-
   invariant` (the paper's M_γ FOC argument). The substantive
   content of the proposition — the *enumeration* itself plus
   Remark `\label{rem:exhaustiveness}` acknowledging the four
   are not provably exhaustive — is not Lean-encodable as a
   proposition, but the four clauses are now distinct
   propositions rather than aliases.

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

6. **Assumptions `\label{ass:credence}`, `\label{ass:scope}`,
   `\label{ass:reputation}`.** The three credence-good
   assumptions that the paper states as preconditions of
   `\label{lem:independence}`, `\label{lem:lizzeri}`,
   `\label{lem:bertrand}`, and `\label{thm:t4_binding}` are
   *folded into the Cat 3 axiom statements themselves* rather
   than surfaced as separate opaque hypothesis predicates.
   That is, `lemma_independence_gap`, the Lizzeri/Bertrand
   atomics, and `welfare_gap_at_reference` each encode
   "under Assumptions credence–reputation, X holds" as a
   single paper-stipulated Cat 3 structural-equation atom.
   This is the standard Cat-3 structural-equation encoding
   pattern (the assumptions are *cited* in every consuming
   axiom's docstring + the corresponding `gap_*` ledger
   entry, not silently dropped). It is a deliberate
   asymmetry with the treatment of HA-7 / SC4 / SC5 / SC6 /
   `IsLongRunEquilibriumOf`, which are surfaced as opaque
   axiom predicates passed as explicit theorem-hypothesis
   parameters. The three credence-good assumptions are
   load-bearing *preconditions of the cited certification-
   intermediary economics* (Darby-Karni 1973, Klein-Leffler
   1981), not paper-novel scope predicates the regulator
   chooses — so folding them into the structural-equation
   atoms (rather than surfacing them as separately-
   dischargeable hypotheses) is the faithful encoding: there
   is no Lean-side party who could supply or withhold an
   `Ass_Credence` witness, the way a caller supplies an
   `hHA7` or `hEqOf` witness. The current prose-fold is
   honest scope, not a silent antecedent drop.

## License

[MIT](LICENSE) (c) 2026 Alex Li.
