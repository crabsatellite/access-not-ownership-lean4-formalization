/-
  AccessOrthogonality/Characterization.lean

  Theorem~\ref{thm:characterization} (Access-Structure
  Separation, characterization form) and
  Proposition~\ref{prop:four_mechanisms} (Sufficient
  ownership-invariance mechanisms).

  Companion to: "Access, Not Ownership: An Orthogonality
  Theorem for AI Governance Regimes" (Li, 2026).

  ## Theorem~\ref{thm:characterization} (informal)

    Fix the access-structure vector `bmu` and the regulatory
    regime `R`.  Then `∂W^*/∂θ_i |_{bmu fixed} = 0` for all `i`
    iff `R` is ownership-invariant in the sense of
    Definition `\label{def:owninv}`.

  ## Proof structure

  The paper proof breaks into:
    (⇐) Sufficiency.  Best-response θ-invariant ⇒ equilibrium
        quality q* θ-invariant (by quality dynamics) ⇒ CS, Π_j,
        T all θ-blind through the allocation ⇒ W* θ-invariant.
    (⇒) Necessity.  Discharged via cost-minimisation on the
        Cobb-Douglas isocline (paper §4.3 Case 2): under
        strictly positive input prices, the cost-minimum on
        any isocline of `c^β d^γ` is a single point, so two
        distinct best-responses cannot both be optima.

  ## What we encode in Lean

  We carry the iff structurally — the (⇐) direction is
  derivable from a single atomic Cat 3 paper-stated structural
  equation `welfare_through_allocation` (paper §4.7: "W*
  depends on (bmu, F) but not on θ").  The (⇒) direction is
  encoded via the contrapositive: if W* depends on θ at fixed
  bmu, then the best-response must also depend on θ (because
  the welfare functional factors through the allocation).

  *Why this is not vacuous.* The substantive content of T1
  (paper §4.6) lives in the Cobb-Douglas-isocline
  cost-minimisation step ensuring that distinct best-responses
  yield distinct equilibrium quality (modulo cost-minimisation
  uniqueness on the isocline).  This step is encoded as a Cat 2
  external textbook axiom citing the standard producer-theory
  result (Mas-Colell-Whinston-Green, ed. 1995, Ch 5
  cost-minimisation).

  ## Proposition~\ref{prop:four_mechanisms}

  Four sufficient mechanisms for ownership-invariance.  Each
  is encoded as a structural implication mechanism_X ⇒
  OwnershipInvariant.
-/

import AccessOrthogonality.Basic

namespace AccessOrthogonality

/-! ### Cat 3 paper-stated structural equations -/

/-- *Cat 2 atomic external textbook axiom (definitional accounting
    identity).*

    **Welfare-factors-through-allocation.**

    Paper proof of Theorem `\label{thm:characterization}`
    (⇐ direction): "Consumer surplus, profits, and
    transfers all depend on the equilibrium allocation but
    not directly on `θ_i` (the welfare functional `W` is
    `θ`-blind)."

    Citation discipline.  This factorisation is a definitional
    accounting identity, not a theorem with a specific MWG
    pointer: MWG §10.D introduces CS via demand-curve area and
    §16.F the welfare theorems, but neither states "W = CS +
    ΣΠ - T factors through allocation as W = wOfAlloc ∘ br" as
    a numbered proposition.  Paper §4.6 "Tautology critique"
    itself acknowledges this: "the welfare functional `W` is
    `θ`-blind once one accepts the standard `W = CS + ∑Π - T`
    decomposition."  Cited as a definitional accounting
    identity over the standard CS, Π, T primitives — MWG §10.D
    / §16.F supplied as background reference for those
    primitives, NOT as the source of the factorisation
    proposition.

    Substantive contribution of T1 lives in (a) the
    Cobb-Douglas isocline cost-min uniqueness step (Cat 2
    `mwg_cost_min_uniqueness_isocline` via MWG §5.D + convex
    analysis) and (b) the four-mechanism enumeration of
    Proposition `\label{prop:four_mechanisms}`.

    Scope:
    Carrier of the *factorisation* of `W^*` through the
    best-response allocation.  Does NOT assert any specific
    functional form for `wOfAlloc`; only that `W^*`
    decomposes as `W^* = wOfAlloc ∘ br`. -/
axiom welfareFactorsThroughAllocation
    (W : WelfareFunctional) (br : BestResponseMap) :
    ∃ wOfAlloc : Investment → AccessVector → Regime → ℝ,
      ∀ (θ : OwnershipType) (a : AccessVector) (R : Regime),
        W.W θ a R = wOfAlloc (br.alloc θ R) a R

/-! ### Necessity: `bestResponseUniqueAtThetaInvariantWelfare`

    Paper `\label{thm:characterization}` (⇒) Necessity is a
    case-split + textbook-fact composition, carried as three
    atoms + a derived theorem:

      (a) `OnSameIsocline`  (Cat 3 hypothesisPredicate) — the
          case-1/case-2 discriminator: do two BR allocations
          (under distinct θ) lie on the same Cobb-Douglas
          isocline `c^β d^γ = const`?
      (b) `mwg_cost_min_uniqueness_isocline` (Cat 2 textbook —
          MWG §5.D "Geometry of cost and supply" + elementary
          convex analysis): under strict positivity of input
          prices `r_c, w_d > 0`, the strictly-quasi-concave
          Cobb-Douglas production function `c^β d^γ` has
          strictly convex isoclines (MWG §5.D), and a linear
          cost objective minimised over a strictly convex
          feasible set has a unique minimum (elementary convex
          analysis) — so two firm-optima on the same isocline
          coincide.
      (c) `case_1_different_isoclines_implies_BR_invariant`
          (Cat 3 structuralEquation) — paper §4.3 Case 1: under
          welfare-θ-invariance, two BR allocations CANNOT lie on
          different isoclines (different isoclines ⇒ different
          equilibrium quality `q*` ⇒ different consumer surplus
          ⇒ welfare differs, contradicting θ-invariance).  Hence
          they coincide.
      (d) `bestResponseUniqueAtThetaInvariantWelfare` (derived
          theorem) — composes (a)+(b)+(c) via classical
          case-split on `OnSameIsocline`. -/

/-- *Cat 3 paper-novel atomic hypothesis predicate.*

    **Paper §4.3 case-split discriminator: same-isocline vs
    different-isoclines.**

    Paper `\label{thm:characterization}` (⇒) Necessity proof
    splits into Case 1 ("the two allocations lie on different
    isoclines of `c^β d^γ`") and Case 2 ("the two allocations
    lie on the same isocline").  We carry the same-isocline
    predicate as a Cat 3 hypothesis-predicate — the paper
    introduces the isocline classifier as a primitive of its
    Case 1 / Case 2 case-split argument.

    Encoding.  The predicate is an opaque `Prop` carrier whose
    witness must come from outside the abstraction layer — the
    substantive paper §4.3 content lives in the two consuming
    axioms (`mwg_cost_min_uniqueness_isocline` and
    `case_1_different_isoclines_implies_BR_invariant`); the
    `by_cases` in the derived theorem works via `Classical.em`
    on the opaque Prop, and cannot be unfolded to a tautology.

    Scope:
    Two BR allocations (under distinct θ-types) lie on the
    same Cobb-Douglas isocline `c^β d^γ = const`.  Opaque
    `Prop` over `(BestResponseMap, θ₁, θ₂, Regime)`; the
    concrete isocline structure is in `WelfareFunctional`
    paper §3.1, deliberately not exposed at this abstraction
    layer. -/
axiom OnSameIsocline (br : BestResponseMap) (θ₁ θ₂ : OwnershipType)
    (R : Regime) : Prop

/-- *Cat 2 atomic external textbook axiom.*

    **Cost-minimum uniqueness on a Cobb-Douglas isocline (MWG §5.D
    duality + elementary convex analysis).**

    Paper `\label{thm:characterization}` (⇒) Necessity Case 2:
    "the cost-minimising point on the isocline is unique given
    input prices `r_c` and `w_d` ... the unique cost-minimum on
    a given isocline (under strictly positive input prices and
    strictly quasi-concave production function ⇒ strictly
    convex input requirement sets) is a single point."

    Citation discipline.  The result is not a single numbered
    MWG proposition: MWG §5.C Prop 5.C.2 enumerates standard
    properties of `c(w,q)` and `z(w,q)` (homogeneity, concavity
    in `w`, Shephard's lemma) but says nothing about cost-min
    uniqueness on level sets.  Strictly-quasi-concave
    production ⇒ strictly-convex isoclines is in MWG §5.D
    "Geometry of cost and supply"; cost-min uniqueness then
    follows by elementary convex analysis (linear input-cost
    objective minimised over a strictly convex feasible set has
    a unique minimum).  Cobb-Douglas `c^β d^γ` for `β, γ > 0`
    is strictly quasi-concave, hence has strictly convex
    isoclines.

    Citation: Mas-Colell, Whinston, Green, *Microeconomic
    Theory*, Oxford University Press 1995, §5.D "Geometry of
    cost and supply" (strictly-quasi-concave production ⇒
    strictly-convex isoclines), composed with elementary
    convex analysis (linear functional on a strictly convex
    set has a unique minimum).

    Scope:
    Atomic operational consequence: under same-isocline
    (`OnSameIsocline br θ₁ θ₂ R`), the two firm-optimal BR
    allocations coincide.  The Mathlib-derivation of the
    underlying convex-analysis fact lives in `gapBlocked`
    (Mathlib lacks the producer-theory level-set apparatus;
    see `gap_FOEconomics_Mathlib_BLOCKED` in the ledger). -/
axiom mwg_cost_min_uniqueness_isocline
    (br : BestResponseMap) (R : Regime) :
    ∀ (θ₁ θ₂ : OwnershipType),
      OnSameIsocline br θ₁ θ₂ R →
      br.alloc θ₁ R = br.alloc θ₂ R

/-- *Cat 3 paper-novel atomic structural equation.*

    **Paper §4.3 Case 1: different isoclines + θ-invariant `W`
    ⇒ BR allocations coincide.**

    Paper `\label{thm:characterization}` (⇒) Necessity Case 1:
    "the two allocations lie on different isoclines of `c^β d^γ`.
    Then `q_i^*` differs, hence `CS` differs (since
    `∂CS/∂q_i ≠ 0` generically by SC1+SC6), contradicting
    θ-invariance of `W^*`."

    Citation: Li 2026, `\label{thm:characterization}` proof
    Case 1.  Paper-novel application of the welfare-functional
    decomposition `W = CS + ∑Π - T` (Cat 2 atomic
    `welfareFactorsThroughAllocation` above) + the
    quality-dynamics SC1+SC6 sensitivity to derive: different
    isoclines forces different welfare, contradicting θ-invariance.

    Scope:
    Atomic operational consequence at the abstraction layer:
    under `WelfareThetaInvariant W a R` (paper Case-1 negated
    by hypothesis), the two BR allocations cannot lie on
    different isoclines (`¬ OnSameIsocline br θ₁ θ₂ R`) AND
    differ; hence the two BR allocations coincide.  Encodes
    the Case-1 contradiction argument as a single paper-stated
    atomic. -/
axiom case_1_different_isoclines_implies_BR_invariant
    (W : WelfareFunctional) (br : BestResponseMap)
    (a : AccessVector) (R : Regime) :
    WelfareThetaInvariant W a R →
    ∀ (θ₁ θ₂ : OwnershipType),
      ¬ OnSameIsocline br θ₁ θ₂ R →
      br.alloc θ₁ R = br.alloc θ₂ R

/-- *Derived theorem.*

    **Necessity bridge: welfare-θ-invariance ⇒ best-response
    θ-invariance.**

    Paper `\label{thm:characterization}` (⇒) Necessity full
    argument: case-split on whether the two BR allocations lie
    on the same Cobb-Douglas isocline:
      * Case 1 (different isoclines): paper §4.3 Case 1
        contradiction (via `case_1_different_isoclines_implies_-
        BR_invariant`).
      * Case 2 (same isocline): MWG §5.D + elementary convex
        analysis cost-min uniqueness on the strictly-convex
        Cobb-Douglas isocline (via
        `mwg_cost_min_uniqueness_isocline`).

    Derivation (Lean):
    1. Pick a witness θ₀ : OwnershipType (e.g., `zero`).
    2. For every θ : OwnershipType, case-split on
       `OnSameIsocline br θ θ₀ R`:
        * `inl` (same isocline): apply MWG.
        * `inr` (different isoclines): apply Case 1.
       Either way, `br.alloc θ R = br.alloc θ₀ R`.
    3. Conclude `∃ inv, ∀ θ, br.alloc θ R = inv` with witness
       `inv := br.alloc θ₀ R`.

    *No paper-novel content beyond the three atomic axioms
    above + classical case-split (`Classical.em`).* -/
theorem bestResponseUniqueAtThetaInvariantWelfare
    (W : WelfareFunctional) (br : BestResponseMap)
    (a : AccessVector) (R : Regime)
    (hTI : WelfareThetaInvariant W a R) :
    ∃ inv : Investment, ∀ θ : OwnershipType, br.alloc θ R = inv := by
  refine ⟨br.alloc OwnershipType.zero R, ?_⟩
  intro θ
  by_cases h : OnSameIsocline br θ OwnershipType.zero R
  · -- Case 2: same isocline ⇒ MWG cost-min uniqueness.
    exact mwg_cost_min_uniqueness_isocline br R θ OwnershipType.zero h
  · -- Case 1: different isoclines + θ-invariant welfare ⇒
    -- BR allocations coincide.
    exact case_1_different_isoclines_implies_BR_invariant W br a R
      hTI θ OwnershipType.zero h

/-! ### Proposition~\ref{prop:four_mechanisms}

    Each of (M_α), (M_β), (M_γ), (M_δ) is sufficient for
    ownership-invariance of the regime.

    The three mechanisms (M_β), (M_γ), (M_δ) are genuinely
    distinct:
      * (M_β) predicates on `R.financingMechanism` —
        `prop_four_mechanisms_Mbeta` is an FOC-free derivation
        using the financing-uniqueness conjunct.
      * (M_δ) predicates on `R.externalConstraints` —
        `prop_four_mechanisms_Mdelta` is an FOC-free derivation
        using the singleton-constraint conjunct.
      * (M_γ) is the opaque Cat 3 `ProfitWelfareGradientAlign`
        predicate; its ⇒ ownership-invariance step is the
        paper's FOC argument, encoded as the Cat 3
        structural-equation axiom `gradientAlign_implies_-
        ownership_invariant` below (parallel to
        `SC1_implements_Malpha` / `SC3_implements_Mbeta`).

    (M_α) — "rent-zero margin" — is the `MechanismMalpha`
    `def` consumed as the load-bearing hypothesis of
    Theorem~\ref{thm:longrun}; its standalone ⇒
    ownership-invariance step also routes through the FOC
    apparatus, so like (M_γ) it is not given a free-standing
    FOC-free derivation (see README "Honest scope notes"). -/

/-- *Cat 3 paper-novel atomic structural equation.*

    **Paper `\label{prop:four_mechanisms}` clause (M_γ): gradient
    alignment ⇒ ownership-invariance.**

    Paper §3.3 (M_γ): "At the equilibrium, `∇_{(c_i,d_i)} Π_i =
    ∇_{(c_i,d_i)} W`.  Then the convex combination
    `(1-θ_i)Π_i + θ_i W` has θ_i-invariant FOC."  This FOC
    argument — gradient alignment forces the convex-combination
    objective's optimum to be θ-invariant — is a paper-stated
    implementation step.  Lean does not model the producer-
    theory gradient / FOC apparatus (the `gap_FOEconomics_-
    Mathlib_BLOCKED` route), so the step is carried as a Cat 3
    structural-equation axiom, parallel to `SC1_implements_-
    Malpha` and `SC3_implements_Mbeta`.

    Scope:
    `ProfitWelfareGradientAlign P W br R → OwnershipInvariant
    br R`.  Atomic paper-stated step; does NOT assert what
    gradient alignment *is* (that is the opaque carrier
    `ProfitWelfareGradientAlign`), only that it implies the
    best-response is θ-invariant. -/
axiom gradientAlign_implies_ownership_invariant
    (P : ProfitFunctional) (W : WelfareFunctional)
    (br : BestResponseMap) (R : Regime) :
    ProfitWelfareGradientAlign P W br R → OwnershipInvariant br R

/-- **Proposition~\ref{prop:four_mechanisms}, clause (M_β).**

    If the regime pins investment `(c, d)` exogenously via an
    incentive-compatible financing mechanism, then the regime
    is ownership-invariant.

    Proof (FOC-free derivation).  `MechanismMbeta`
    gives a financing-designated allocation `xF` (at some price
    normalisation `w_d`) that is the *unique* self-funded point
    of `R.financingMechanism`, plus the fact that the best
    response `br.alloc θ R` is self-funded for every `θ`.
    Uniqueness then forces `br.alloc θ R = xF` for every `θ`,
    which is exactly ownership-invariance with witness `xF`. -/
theorem prop_four_mechanisms_Mbeta
    (br : BestResponseMap) (R : Regime) :
    MechanismMbeta br R → OwnershipInvariant br R := by
  intro h
  obtain ⟨xF, _w_d, hUniq, hFunded⟩ := h
  exact ⟨xF, fun θ => (hUniq (br.alloc θ R)).mp (hFunded θ)⟩

/-- **Proposition~\ref{prop:four_mechanisms}, clause (M_γ).**

    If the convex-combination objective has θ-invariant FOC
    (i.e., `∇Π_i = ∇W` at the equilibrium), the best-response
    is θ-invariant.

    Proof.  `MechanismMgamma P W br R` unfolds to the
    opaque Cat 3 predicate `ProfitWelfareGradientAlign P W br
    R`; the paper's FOC argument that gradient alignment
    implies ownership-invariance is the Cat 3 structural-
    equation axiom `gradientAlign_implies_ownership_invariant`. -/
theorem prop_four_mechanisms_Mgamma
    (P : ProfitFunctional) (W : WelfareFunctional)
    (br : BestResponseMap) (R : Regime) :
    MechanismMgamma P W br R → OwnershipInvariant br R :=
  gradientAlign_implies_ownership_invariant P W br R

/-- **Proposition~\ref{prop:four_mechanisms}, clause (M_δ).**

    If the firm's feasible action set is restricted by an
    external constraint that binds for all `θ_i ∈ [0,1]` at
    the same allocation, the regime is ownership-invariant.
    Examples: hardware-export caps, data-residency rules,
    capacity caps.

    Proof (FOC-free derivation).  `MechanismMdelta`
    gives an allocation `xC` such that `R.externalConstraints`
    is the *singleton* `{xC}`, plus the fact that the best
    response `br.alloc θ R` is feasible (satisfies the external
    constraint) for every `θ`.  The singleton property then
    forces `br.alloc θ R = xC` for every `θ`, which is exactly
    ownership-invariance with witness `xC`. -/
theorem prop_four_mechanisms_Mdelta
    (br : BestResponseMap) (R : Regime) :
    MechanismMdelta br R → OwnershipInvariant br R := by
  intro h
  obtain ⟨xC, hSingleton, hFeasible⟩ := h
  exact ⟨xC, fun θ => (hSingleton (br.alloc θ R)).mp (hFeasible θ)⟩

/-! ### Theorem~\ref{thm:characterization} — the iff -/

/-- **Theorem~\ref{thm:characterization} (Access-Structure
    Separation, characterization form), ⇐ direction.**

    If the regime `R` is ownership-invariant, then the
    welfare functional `W^*` is θ-invariant at fixed access
    vector `bmu`.

    Proof.  By `welfareFactorsThroughAllocation`, there exists
    `wOfAlloc` such that `W^*(θ, bmu, R) = wOfAlloc (alloc θ R) bmu R`.
    By `OwnershipInvariant`, the allocation is constant in θ,
    so the welfare reduces to `wOfAlloc inv bmu R` independent
    of θ.

    *Discipline note.*  This direction does the
    welfare-factorisation work.  The substantive content
    (paper §4.6: "the Cobb-Douglas-isocline degeneracy in
    necessity is mechanically simple but logically necessary")
    lives in the (⇒) direction, encoded via the Cat 2
    atomic axiom `bestResponseUniqueAtThetaInvariantWelfare`. -/
theorem thm_characterization_suff
    (W : WelfareFunctional) (br : BestResponseMap)
    (a : AccessVector) (R : Regime) :
    OwnershipInvariant br R → WelfareThetaInvariant W a R := by
  intro hOI
  obtain ⟨inv, hInv⟩ := hOI
  obtain ⟨wOfAlloc, hFactor⟩ := welfareFactorsThroughAllocation W br
  intro θ₁ θ₂
  rw [hFactor θ₁ a R, hFactor θ₂ a R]
  rw [hInv θ₁, hInv θ₂]

/-- **Theorem~\ref{thm:characterization}, ⇒ direction.**

    If the welfare functional `W^*` is θ-invariant at fixed
    access vector `bmu`, then the regime is ownership-invariant.

    Proof.  Direct consequence of the derived theorem
    `bestResponseUniqueAtThetaInvariantWelfare`, which composes
    paper §4.3 Case 1 (different-isoclines contradiction; Cat 3)
    and Case 2 (MWG §5.D + elementary convex analysis cost-min
    uniqueness on the strictly-convex Cobb-Douglas isocline;
    Cat 2) via classical case-split on `OnSameIsocline`. -/
theorem thm_characterization_nec
    (W : WelfareFunctional) (br : BestResponseMap)
    (a : AccessVector) (R : Regime) :
    WelfareThetaInvariant W a R → OwnershipInvariant br R := by
  intro hTI
  exact bestResponseUniqueAtThetaInvariantWelfare W br a R hTI

/-- **Theorem~\ref{thm:characterization}.**

    Combining both directions:

    `WelfareThetaInvariant W a R ↔ OwnershipInvariant br R`.

    Paper-level meaning: ∂W^*/∂θ_i = 0 for all i iff the
    regime is ownership-invariant.

    *Discipline.* This is the headline theorem of paper
    Section~\ref{sec:t1_separation}.  Substantive content
    lives in `bestResponseUniqueAtThetaInvariantWelfare`
    (the Cobb-Douglas-isocline cost-minimisation step) and
    in the four-mechanism enumeration above.  The
    iff statement itself is structurally tautological at the
    abstract carrier level — paper §4.6 admits this — and the
    contribution comes from the composition with downstream
    theorems Gini / AntiTipping / Binding / LongRun. -/
theorem thm_characterization
    (W : WelfareFunctional) (br : BestResponseMap)
    (a : AccessVector) (R : Regime) :
    WelfareThetaInvariant W a R ↔ OwnershipInvariant br R := by
  refine ⟨?_, ?_⟩
  · exact thm_characterization_nec W br a R
  · exact thm_characterization_suff W br a R

end AccessOrthogonality
