/-
  AccessOrthogonality/Characterization.lean

  Theorem~\ref{thm:characterization} (Access-Structure
  Separation, characterization form) and
  Proposition~\ref{prop:four_mechanisms} (Sufficient
  ownership-invariance mechanisms).

  Companion to: "Access, Not Ownership: An Orthogonality
  Theorem for AI Governance Regimes" (Li, 2026).

  ## Theorem~\ref{thm:characterization} (informal)

    On a differentiable local equilibrium branch, the chain-rule
    identity dW/dtheta = (dW/dq)(dq/dtheta), together with a
    nonzero reduced-welfare marginal and unique branch
    identification, makes welfare orthogonality equivalent to
    first-order quality and input invariance.

  ## What we encode in Lean

  The local chain-rule algebra and branch identification are
  explicit theorem hypotheses.  The stronger global sufficient
  direction used by the constructive corollary remains encoded by
  welfare factorisation through a globally invariant allocation.

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

    The journal-version characterization adds explicit local
    chain-rule, nonzero-marginal, and branch-identification
    hypotheses.  The stronger global sufficient direction here
    is consumed by the constructive corollary.

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

/-! ### Local characterization

    The journal version states a local identification theorem.
    Write dW_dTheta for the ownership derivative of equilibrium
    welfare, dW_dq for the reduced-welfare marginal, and
    dq_dTheta for the ownership derivative of equilibrium quality.
    The chain-rule identity

      dW_dTheta = dW_dq * dq_dTheta

    plus dW_dq nonzero makes welfare orthogonality equivalent to
    quality invariance.  A separate branch-identification hypothesis
    connects quality invariance to the two input derivatives.

    The former global necessity argument based on different
    Cobb-Douglas isoclines is intentionally not retained: a change in
    consumer surplus can be offset by other welfare components. -/

/-- **Local welfare--quality characterization.**

    This theorem encodes the chain-rule core of paper
    Theorem~\ref{thm:characterization}.  It is axiom-free because the
    economic content is exposed as explicit hypotheses. -/
theorem local_welfare_quality_characterization
    (dW_dTheta dW_dq dq_dTheta : ℝ)
    (hChain : dW_dTheta = dW_dq * dq_dTheta)
    (hMarginal : dW_dq ≠ 0) :
    dW_dTheta = 0 ↔ dq_dTheta = 0 := by
  constructor
  · intro hOrth
    rw [hChain] at hOrth
    exact (mul_eq_zero.mp hOrth).resolve_left hMarginal
  · intro hQuality
    rw [hChain, hQuality, mul_zero]



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

    *Discipline note.*  This direction performs only the
    welfare-factorisation step.  The local iff theorem below
    separately exposes its identification hypotheses. -/
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

/-- **Theorem~\ref{thm:characterization}, local form.**

    The reduced-welfare chain rule and nonzero welfare marginal
    identify quality invariance.  The explicit branch hypothesis
    identifies zero quality derivative with zero derivatives of both
    cost-minimizing inputs. -/
theorem thm_characterization
    (dW_dTheta dW_dq dq_dTheta dc_dTheta dd_dTheta : ℝ)
    (hChain : dW_dTheta = dW_dq * dq_dTheta)
    (hMarginal : dW_dq ≠ 0)
    (hBranch :
      dq_dTheta = 0 ↔ dc_dTheta = 0 ∧ dd_dTheta = 0) :
    dW_dTheta = 0 ↔ dc_dTheta = 0 ∧ dd_dTheta = 0 := by
  exact
    (local_welfare_quality_characterization
      dW_dTheta dW_dq dq_dTheta hChain hMarginal).trans hBranch



end AccessOrthogonality
