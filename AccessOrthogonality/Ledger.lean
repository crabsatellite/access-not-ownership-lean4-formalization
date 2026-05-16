/-
  AccessOrthogonality/Ledger.lean

  Gap ledger.  Every atomic axiom, every Cat 3 carrier, every
  blocked route, and every closed top-level result is
  recorded as a typed `GapEntry` with three orthogonal
  classifications plus a broken-link dependency list:

    * 7-tier status:    gapOpen / gapPartial / gapBlocked /
                        gapDeadEnd / gapClosed /
                        gapClosedConditional / gapDefinitional
    * 4-input-category: cat1Mathlib / cat2External /
                        cat3PaperNovel / notInput
    * Cat 3 sub-type:   carrier / hypothesisPredicate /
                        structuralEquation / workingAssumption /
                        conditionalHypothesis / notCat3
    * conditionalOn :   list of `Hyp_*` broken-link predicate
                        names (non-empty iff status is
                        `gapClosedConditional`)

  Pre-attack discipline.  Scan this ledger before launching
  new attacks.  Re-attempting a `gapBlocked` or `gapDeadEnd`
  route is a context-drift failure mode.

  Docstrings, `scope`, and `paperSource` fields are kept to
  current-state content only.
-/

import AccessOrthogonality

namespace AccessOrthogonality.Ledger

/-- 7-tier status tag attached to each gap.

    * `gapClosedConditional`: used when a defect is found that
      breaks a typed-bridge chain.  The downstream closure is
      preserved as conditional on a named `Hyp_*` broken-link
      hypothesis (recorded in the `conditionalOn` field) pending
      repair or independent derivation.
    * `gapDefinitional`: Cat 3 paper-novel atom that is a starting
      commitment, not a gap to close — covers the three
      definitional sub-types (carrier / hypothesisPredicate /
      structuralEquation).  Distinguished from `gapOpen` (no attack
      / inconclusive) — `gapDefinitional` says "by design
      axiomatic, no Lean derivation expected". -/
inductive GapStatus
  | gapOpen
  | gapPartial
  | gapBlocked
  | gapDeadEnd
  | gapClosed
  | gapClosedConditional
  | gapDefinitional
  deriving DecidableEq, Repr

/-- 4-input-category tag attached to each gap.  Orthogonal to status.
    (Cat 0 = Lean kernel axioms — `propext` / `Classical.choice` /
    `Quot.sound` — is the always-present system layer and is not
    tracked here.) -/
inductive InputCategory
  /-- Mathlib-derivable theorem (no axiom).  Project has zero such. -/
  | cat1Mathlib
  /-- External published; opaque-carrier-bound axiom +
      citation. -/
  | cat2External
  /-- Paper-novel: carrier, hypothesis predicate, structural defining
      equation, working assumption, or conditional hypothesis.
      Refine via the `cat3SubType` field. -/
  | cat3PaperNovel
  /-- Not an atomic input: derived theorem (gapClosed) or genuine
      no-acceptance-possible route (gapBlocked / gapDeadEnd). -/
  | notInput
  deriving DecidableEq, Repr

/-- Cat 3 paper-novel sub-types.  Orthogonal to status
    and input-category; only meaningful when
    `inputCategory = cat3PaperNovel`. -/
inductive Cat3SubType
  /-- Paper-introduced primitive type or typed-primitive value
      (e.g., paper-introduced functions / constants such as κ_1,
      κ_2, s_K, η, m_Bertrand).  Definitional atom; 永不 close. -/
  | carrier
  /-- Paper-introduced scope/regime predicate (e.g.,
      `IsLongRunEquilibriumOf`, `StructurallyDecoupled`).
      Definitional atom; 永不 close. -/
  | hypothesisPredicate
  /-- Paper-stated definitional equation on its primitives
      (e.g., paper Theorem-stated structural equation such as
      `eta_attenuation 0 = 0`, `long_run_step1_profit_zero`,
      `gini_two_channel_partition`).  Definitional atom; 永不
      close — these constitute the paper's commitments to how its
      primitives behave. -/
  | structuralEquation
  /-- Higher-level claim temporarily axiomatized while derivation is
      developed.  必须 close before paper submission. -/
  | workingAssumption
  /-- Paper's conclusion conditional on an external open problem
      (RH, BSD, Hodge, P≠NP).  永不 close; encoded as theorem-
      signature antecedent `theorem T (hRH : RiemannHypothesis) : ...`,
      NOT as an axiom.  Listed here only for completeness; project
      has none. -/
  | conditionalHypothesis
  /-- Framework-paper substantive phenomenological claim awaiting
      EXTERNAL validation (empirical study, cohort data, philosophical-
      foundations debate).  Distinct from `workingAssumption` (must
      close before publication) AND from `definitional atom`
      (stipulative-not-substantive).  Project has none
      (Access-Not-Ownership is a derivational-economics paper, not a
      framework paper publishing phenomenological conjectures). -/
  | phenomenologicalConjecture
  /-- This entry is not Cat 3 paper-novel. -/
  | notCat3
  deriving DecidableEq, Repr

/-- Typed record for a single gap. -/
structure GapEntry where
  /-- Identifier matching the underlying axiom / theorem
      name. -/
  name : String
  /-- 7-tier status. -/
  status : GapStatus
  /-- Input category (orthogonal to status). -/
  inputCategory : InputCategory
  /-- Cat 3 sub-type (orthogonal; `notCat3` unless
      `inputCategory = cat3PaperNovel`). -/
  cat3SubType : Cat3SubType
  /-- Operative paper / obstacle citation. -/
  paperSource : String
  /-- Reserved per-entry trace field; iteration history is
      tracked in git. -/
  attackHistory : List String
  /-- What content the entry carries; what it does NOT claim. -/
  scope : String
  /-- Names of `Hyp_*` broken-link predicates this entry's proof
      depends on.  Invariant: non-empty iff
      `status = gapClosedConditional`. -/
  conditionalOn : List String := []

/-! ### Cat 2 atomic external textbook welfare-economics axiom -/

/-- (Characterization) Welfare factors through allocation. -/
def gap_welfareFactorsThroughAllocation : GapEntry := {
  name := "welfareFactorsThroughAllocation"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Mas-Colell, Whinston, Green, *Microeconomic Theory*, " ++
    "Oxford University Press 1995, §10.D (partial-" ++
    "equilibrium welfare) + §16.F (general-equilibrium " ++
    "welfare theorems): `W = CS + ∑Π - T` is a primitive " ++
    "of the equilibrium allocation; lump-sum transfers " ++
    "are θ-blind under (SC5).  Paper §4.6 \"Tautology " ++
    "critique\" explicitly acknowledges this is welfare-" ++
    "economics-101."
  attackHistory := []
  scope :=
    "Existence of `wOfAlloc : Investment → AccessVector → " ++
    "Regime → ℝ` factorising `W^*` through the best-response " ++
    "allocation.  Does NOT assert specific functional form."
}

/-! ### Cat 3 paper-novel atomic structural equations
       (sub-type: structuralEquation) -/

/-- (Separation) SC1 implements M_α. -/
def gap_SC1_implements_Malpha : GapEntry := {
  name := "SC1_implements_Malpha"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:separation}` proof: \"Under " ++
    "(SC1), marginal-cost access pricing zeros the access-" ++
    "layer net: (p^a_i - MC_i)a_i = 0.  The marginal access-" ++
    "rent ∂Π^A_i / ∂(c_i, d_i) = 0.\""
  attackHistory := []
  scope :=
    "Atomic implementation step: SC1_MCpricing R → " ++
    "MechanismMalpha P R."
}

/-- (Separation) SC3 implements M_β. -/
def gap_SC3_implements_Mbeta : GapEntry := {
  name := "SC3_implements_Mbeta"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:separation}` proof: \"Under " ++
    "(SC3), the financing mechanism F is structured so that " ++
    "F_i is paid out conditional on the firm delivering the " ++
    "prescribed quality target.  Under standard mechanism-" ++
    "design IC conditions, the firm's best response is " ++
    "(c_i, d_i) = (c^F_i, d^F_i) regardless of θ_i.\""
  attackHistory := []
  scope :=
    "Atomic implementation step: SC3_Financing R w_d → " ++
    "MechanismMbeta br R.  The IC standard-conditions " ++
    "hypothesis is folded into the abstract BestResponseMap."
}

/-- (Characterization) M_γ gradient-alignment opaque carrier. -/
def gap_ProfitWelfareGradientAlign : GapEntry := {
  name := "ProfitWelfareGradientAlign"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026, `\\label{prop:four_mechanisms}` clause (M_γ): " ++
    "\"At the equilibrium, ∇_{(c_i,d_i)} Π_i = ∇_{(c_i,d_i)} W " ++
    "on the investment variables.\"  Paper-introduced " ++
    "equilibrium-condition predicate on the profit and " ++
    "welfare functionals."
  attackHistory := []
  scope :=
    "Opaque Cat 3 hypothesisPredicate over (ProfitFunctional, " ++
    "WelfareFunctional, BestResponseMap, Regime).  The typed " ++
    "carrier for paper M_γ gradient alignment ∇Π = ∇W; does " ++
    "NOT itself assert ownership-invariance — that step is " ++
    "the separate atomic `gradientAlign_implies_ownership_-" ++
    "invariant`."
}

/-- (Characterization) M_γ: gradient alignment ⇒ ownership-invariance. -/
def gap_gradientAlign_implies_ownership_invariant : GapEntry := {
  name := "gradientAlign_implies_ownership_invariant"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{prop:four_mechanisms}` clause (M_γ): " ++
    "\"Then the convex combination (1-θ_i)Π_i + θ_i W has " ++
    "θ_i-invariant FOC.\"  Paper-stated FOC implementation " ++
    "step — gradient alignment forces the convex-combination " ++
    "objective's optimum to be θ-invariant."
  attackHistory := []
  scope :=
    "Atomic paper-stated step: ProfitWelfareGradientAlign P W " ++
    "br R → OwnershipInvariant br R.  Consumed by the derived " ++
    "theorem `prop_four_mechanisms_Mgamma`."
}

/-- (Binding) lemma:independence — credence-good gap
    (ω,π)-invariance. -/
def gap_lemma_independence_gap : GapEntry := {
  name := "lemma_independence_gap"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:independence}` (paper §6.2): the " ++
    "consumer's credence-good gap on per-output quality q(y) " ++
    "is independent of (ω, π) on the credence-good portion " ++
    "of the foundation-model output space."
  attackHistory := []
  scope :=
    "Stated as (ω,π)-invariance of the welfare-difference " ++
    "W_cred(ω,π,ν) - W_cred(ω,π,0).  Does NOT assert " ++
    "anything about the per-output gap on EXPERIENCE-good " ++
    "outputs (where (ω,π) DO help via test-running)."
}

/-- (Binding) Welfare-gap at reference point `(0, 0)`. -/
def gap_welfare_gap_at_reference : GapEntry := {
  name := "welfare_gap_at_reference"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:t4_binding}` proof: \"Setting c " ++
    "equal to the consumer's information-demand differential " ++
    "per unit of ν yields (eq:verification_binding).\""
  attackHistory := []
  scope :=
    "Existence of c > 0 such that W^*(0,0,ν) - W^*(0,0,0) ≥ " ++
    "c · ν, parametrised over the bundled and Bertrand rent " ++
    "values.  Lifted to arbitrary (ω,π) via " ++
    "lemma_independence_gap."
}

/-- (LongRun) Step 1: profit zero under (M_α)+(M_β). -/
def gap_long_run_step1_profit_zero : GapEntry := {
  name := "long_run_step1_profit_zero"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:longrun}` proof Step 1: \"Under " ++
    "(M_α) [SC1] + (M_β) [SC3], provider profit Π_i^*(m) = " ++
    "0 uniformly in m.\""
  attackHistory := []
  scope :=
    "Atomic structural-property: provider profit at " ++
    "equilibrium is identically zero in the OI regime."
}

/-- (LongRun) Step 4: zero-lobbying-effort equilibrium. -/
def gap_long_run_step4_zero_lobbying : GapEntry := {
  name := "long_run_step4_zero_lobbying"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:longrun}` proof Step 4: \"The " ++
    "provider's stage-1 FOC ∂u_i/∂ℓ_i - ℓ_i = 0 gives ℓ_i^* " ++
    "= 0 for all i, for all θ_i ∈ [0,1].\""
  attackHistory := []
  scope :=
    "Atomic statement: under (M_α)+(M_β), the capture-game " ++
    "equilibrium has zero lobbying effort."
}

/-- (LongRun) Step 5a: m^* invariance. -/
def gap_long_run_step5_mStar_invariance : GapEntry := {
  name := "long_run_step5_mStar_invariance"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:longrun}` proof Step 5: \"With " ++
    "`ℓ^* = 0`, the regulator's stage-2 objective is " ++
    "`V_R = λ W^*`, whose maximiser is `m^W`.  By the static " ++
    "characterization (Theorem~\\ref{thm:characterization}), " ++
    "`W^*` does not depend on θ in the OI regime, so `m^W` " ++
    "is θ-invariant.\""
  attackHistory := []
  scope :=
    "Atomic m-component: under (M_α)+(M_β), the long-run " ++
    "equilibrium policy `m^*` is θ-invariant.  Quantified " ++
    "over `IsLongRunEquilibriumOf eq R` to link the " ++
    "abstract `LongRunEquilibrium` carrier to a specific " ++
    "regime `R`.  Companion: `long_run_step5_bmuStar_invariance` " ++
    "for the bmu-component."
}

/-- (LongRun) Step 5b: bmu^*(m^*) invariance. -/
def gap_long_run_step5_bmuStar_invariance : GapEntry := {
  name := "long_run_step5_bmuStar_invariance"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:longrun}` proof Step 5: \"Hence " ++
    "`bmu^*(m^W)` is θ-invariant, and the long-run " ++
    "orthogonality holds.\""
  attackHistory := []
  scope :=
    "Atomic bmu-component: under (M_α)+(M_β), the long-run " ++
    "equilibrium access vector `bmu^*(m^*)` is θ-invariant. " ++
    "Quantified over `IsLongRunEquilibriumOf eq R`.  " ++
    "Distinct from `long_run_step5_mStar_invariance` because " ++
    "bmu-invariance additionally requires the m → bmu(m) " ++
    "map to be well-defined and θ-blind at the selected m."
}

/-! ### Cat 3 paper-novel hypothesis predicates
       (sub-type: hypothesisPredicate) -/

/-- (LongRun) IsLongRunEquilibriumOf — paper §7.3 Step 5
    "(ℓ*, m*) = (0, m^W) Nash" predicate. -/
def gap_IsLongRunEquilibriumOf : GapEntry := {
  name := "IsLongRunEquilibriumOf"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026, `\\label{thm:longrun}` Step 5 \"Equilibrium " ++
    "and orthogonality\": (ℓ*, m*) = (0, m^W) Nash.  Paper-" ++
    "introduced predicate linking the abstract LongRunEquilibrium " ++
    "carrier to a specific regime."
  attackHistory := []
  scope :=
    "OPAQUE Prop carrier `LongRunEquilibrium → Regime → " ++
    "Prop`.  Witness must be supplied by caller."
}

/-- (Basic/SC) SC4_ExAnte — paper §3.2 ex-ante operational bmu predicate. -/
def gap_SC4_ExAnte : GapEntry := {
  name := "SC4_ExAnte"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026 §3.2 (SC4): access-structure components are " ++
    "operationally defined before any welfare claim is made.  " ++
    "Methodological side-condition; paper-introduced predicate."
  attackHistory := []
  scope := "OPAQUE Prop carrier `AccessVector → Prop`."
}

/-- (Basic/SC) SC5_LumpSum — paper §3.3 lump-sum transferability. -/
def gap_SC5_LumpSum : GapEntry := {
  name := "SC5_LumpSum"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026 §3.3 (SC5): lump-sum transferability assumption " ++
    "(second-welfare-theorem precondition).  Paper-introduced " ++
    "predicate."
  attackHistory := []
  scope := "OPAQUE Prop carrier."
}

/-- (Basic/SC) SC6_HD1 — paper §3.4 downstream homogeneity-of-degree-one. -/
def gap_SC6_HD1 : GapEntry := {
  name := "SC6_HD1"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026 §3.4 (SC6): downstream production HD-1 in " ++
    "access `a_j` conditional on `k_j`.  Paper-introduced " ++
    "predicate."
  attackHistory := []
  scope := "OPAQUE Prop carrier."
}

/-! ### Cat 3 paper-novel typed primitives
       (sub-type: carrier) -/

/-- κ_1(η) — capital-share coefficient. -/
def gap_kappa1_carrier : GapEntry := {
  name := "kappa1"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2: κ_1(η) = " ++
    "(1-η) · s_K^{(0)} · s_L^{(0)} · χ where χ is " ++
    "dimensionless rent-to-baseline-rental ratio."
  attackHistory := []
  scope :=
    "Typed primitive `kappa1 (η : ℝ) : ℝ`.  Paper-stated " ++
    "explicit form; carried abstractly because the η < 1 " ++
    "case-split + factor-share calibration is empirical."
}

/-- κ_2 — verification-rent coefficient. -/
def gap_kappa2_carrier : GapEntry := {
  name := "kappa2"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2: κ_2 > 0 " ++
    "proportional to share of consumer expenditure subject " ++
    "to verification rent at baseline."
  attackHistory := []
  scope := "Typed primitive `kappa2 : ℝ`."
}

/-- s_K(η) — capital task share. -/
def gap_sK_carrier : GapEntry := {
  name := "sK"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2."
  attackHistory := []
  scope :=
    "Typed primitive `sK (η : ℝ) : ℝ`.  Capital task share " ++
    "at CES elasticity η."
}

/-- η(ν) — Bertrand-attenuation function. -/
def gap_eta_attenuation_carrier : GapEntry := {
  name := "eta_attenuation"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{thm:antitipping}` Appendix A.3 Step 3: " ++
    "η(ν) := 1 - c_R / (K(ν) · m_{bundled,ν}) where K(ν) = " ++
    "⌈K_max · ν⌉."
  attackHistory := []
  scope :=
    "Typed primitive `eta_attenuation (ν : ℝ) : ℝ`.  " ++
    "Boundary `η(0) = 0` recorded separately as " ++
    "`eta_attenuation_at_zero`."
}

/-- η(0) = 0 boundary. -/
def gap_eta_attenuation_at_zero : GapEntry := {
  name := "eta_attenuation_at_zero"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:antitipping}` Appendix A.3 Step 3: " ++
    "\"η(0) = 0 (no attenuation in bundled regime).\""
  attackHistory := []
  scope :=
    "Atomic structural equation `eta_attenuation 0 = 0` " ++
    "for the bundled-regime boundary."
}

/-- η(ν) ∈ [0,1] unit-interval bound. -/
def gap_eta_attenuation_unit_interval : GapEntry := {
  name := "eta_attenuation_unit_interval"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:antitipping}` Appendix A.3 Step 3: " ++
    "\"η_max = 1 - c_R / (K_max · m_{bundled,ν}); η → 1 as " ++
    "K(ν) grows.\""
  attackHistory := []
  scope :=
    "Atomic boundedness `0 ≤ η(ν) ≤ 1` for the Bertrand-" ++
    "attenuation function."
}

/-! ### Cat 2 atomic external textbook axioms + remaining
       Cat 3 paper-novel structural equations
       (mixed-citation section) -/

/-! ### Decomposition of
       `gap_bestResponseUniqueAtThetaInvariantWelfare` -/

/-- (Characterization) Case-split discriminator: same-isocline. -/
def gap_OnSameIsocline_predicate : GapEntry := {
  name := "OnSameIsocline"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026, `\\label{thm:characterization}` (⇒) Necessity " ++
    "proof Case 1 (\"the two allocations lie on different " ++
    "isoclines of `c^β d^γ`\") vs. Case 2 (\"the two " ++
    "allocations lie on the same isocline\").  Paper-" ++
    "introduced isocline-classifier predicate at the basis " ++
    "of the case-split argument."
  attackHistory := []
  scope :=
    "Paper §4.3 same-isocline predicate over " ++
    "`(BestResponseMap, OwnershipType, OwnershipType, Regime)`.  " ++
    "Carrier-only Prop at the abstract layer; substantive " ++
    "paper content lives in the two consuming atomics."
}

/-- (Characterization) Cost-min uniqueness on Cobb-Douglas isocline (MWG §5.D + convex analysis). -/
def gap_mwg_cost_min_uniqueness_isocline : GapEntry := {
  name := "mwg_cost_min_uniqueness_isocline"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Mas-Colell, Whinston, Green, *Microeconomic Theory*, " ++
    "Oxford University Press 1995, §5.D \"Geometry of cost " ++
    "and supply\" (strictly-quasi-concave production ⇒ " ++
    "strictly-convex isoclines), composed with elementary " ++
    "convex analysis (linear functional on a strictly convex " ++
    "set has a unique minimum).  Paper Case 2 of " ++
    "`\\label{thm:characterization}` (⇒) Necessity invokes " ++
    "this directly: \"the cost-minimising point on the " ++
    "isocline is unique given input prices r_c and w_d ... " ++
    "is a single point\"."
  attackHistory := []
  scope :=
    "`∀ (br : BestResponseMap) (R : Regime) (θ₁ θ₂ : " ++
    "OwnershipType), OnSameIsocline br θ₁ θ₂ R → br.alloc " ++
    "θ₁ R = br.alloc θ₂ R`.  Cobb-Douglas `c^β d^γ` is " ++
    "strictly quasi-concave (β,γ > 0), hence has strictly " ++
    "convex isoclines (MWG §5.D), and the cost-min on a " ++
    "strictly convex set under linear input cost is unique " ++
    "(elementary convex analysis).  Full Lean derivation " ++
    "deferred to `gap_FOEconomics_Mathlib_BLOCKED` (Mathlib " ++
    "lacks the producer-theory level-set apparatus)."
}

/-- (Characterization) Paper Case 1 contradiction. -/
def gap_case_1_different_isoclines_implies_BR_invariant : GapEntry := {
  name := "case_1_different_isoclines_implies_BR_invariant"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:characterization}` (⇒) Necessity " ++
    "Case 1: \"the two allocations lie on different isoclines " ++
    "of `c^β d^γ`.  Then `q_i^*` differs, hence `CS` differs " ++
    "(since `∂CS/∂q_i ≠ 0` generically by SC1+SC6), " ++
    "contradicting θ-invariance of `W^*`.\"  Paper-novel " ++
    "application of the welfare-functional decomposition " ++
    "`W = CS + ∑Π - T` + the SC1+SC6 quality-sensitivity to " ++
    "force the different-isoclines contradiction."
  attackHistory := []
  scope :=
    "`∀ (W : WelfareFunctional) (br : BestResponseMap) (a : " ++
    "AccessVector) (R : Regime), WelfareThetaInvariant W a R " ++
    "→ ∀ (θ₁ θ₂ : OwnershipType), ¬ OnSameIsocline br θ₁ θ₂ " ++
    "R → br.alloc θ₁ R = br.alloc θ₂ R`.  Atomic Case 1 " ++
    "contradiction step."
}

/-- (Characterization) Derived necessity bridge (former Cat 3 atomic). -/
def gap_bestResponseUniqueAtThetaInvariantWelfare_CLOSED : GapEntry := {
  name := "bestResponseUniqueAtThetaInvariantWelfare"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:characterization}` (⇒) Necessity " ++
    "full argument.  Derived theorem composing Case 1 " ++
    "(Cat 3 `case_1_different_isoclines_implies_BR_invariant`) " ++
    "and Case 2 (Cat 2 `mwg_cost_min_uniqueness_isocline` " ++
    "via the same-isocline `OnSameIsocline` discriminator) " ++
    "by classical case-split."
  attackHistory := []
  scope :=
    "Necessity direction of Theorem~\\ref{thm:characterization}: " ++
    "if welfare is θ-invariant, then the best-response is " ++
    "θ-invariant.  Derived theorem composing the 3 atomics " ++
    "via classical case-split on `OnSameIsocline`."
}

/-- (Gini) κ_1 positivity for η < 1. -/
def gap_kappa1_pos : GapEntry := {
  name := "kappa1_pos"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 closed-form " ++
    "parametrization `κ_1(η) = (1-η)·s_K^(0)·s_L^(0)·χ` with " ++
    "`κ_1 > 0` for `η < 1` (gross-complements case)."
  attackHistory := []
  scope := "0 < κ_1(η) whenever η < 1 (gross complements)."
}

/-- (Gini) κ_2 positivity. -/
def gap_kappa2_pos : GapEntry := {
  name := "kappa2_pos"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2: `κ_2 > 0`, " ++
    "the GE_0-inequality coefficient proportional to the " ++
    "share of consumer expenditure subject to verification " ++
    "rent at baseline."
  attackHistory := []
  scope := "0 < κ_2."
}

/-- (Gini) s_K(η) non-negativity. -/
def gap_sK_nonneg : GapEntry := {
  name := "sK_nonneg"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2: definitional " ++
    "non-negativity of `sK` as a share-of-mass primitive " ++
    "(factor shares ∈ [0,1])."
  attackHistory := []
  scope := "0 ≤ s_K(η)."
}

/-- (Gini) Capital-share channel contribution. -/
def gap_capital_share_channel_contribution : GapEntry := {
  name := "capital_share_channel_contribution"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 capital-share " ++
    "channel bound `κ_1·s_K·(1-μ)`."
  attackHistory := []
  scope :=
    "Existence of non-negative capital-channel contribution " ++
    "`capContrib ∈ [0, κ_1(0)·s_K(0)·(1-μ_product)]`.  " ++
    "η = 0 parameter slot for baseline elasticity."
}

/-- (Gini) Verification-rent channel contribution. -/
def gap_verification_rent_channel_contribution : GapEntry := {
  name := "verification_rent_channel_contribution"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 verification-" ++
    "rent channel bound `κ_2·(1-ν)`, composed from Lemma " ++
    "`\\label{lem:lizzeri}` (integrated rent) + Lemma " ++
    "`\\label{lem:bertrand}` (saturation) + κ_2-scaling."
  attackHistory := []
  scope :=
    "Existence of non-negative verification-channel contribution " ++
    "`verifContrib ∈ [0, κ_2·(1-ν)]`."
}

/-! ### Decomposition of `gap_gini_two_channel_partition` -/

/-- (Gini) HA-7 channels-not-anti-correlated predicate. -/
def gap_HA7_channels_not_anti_correlated : GapEntry := {
  name := "HA7_channels_not_anti_correlated"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 working " ++
    "assumption HA-7: \"the capital-rent and verification-" ++
    "rent channels are not anti-correlated in the income " ++
    "distribution\".  Paper-stated working-assumption " ++
    "predicate (regime-condition on the income-rank " ++
    "correlation between the two channels)."
  attackHistory := []
  scope :=
    "HA-7 carrier — paper-introduced working-assumption " ++
    "predicate over `(InequalityFunctional, OwnershipType, " ++
    "AccessVector, Regime)`.  OPAQUE Prop carrier; witness " ++
    "must be supplied by caller of downstream theorems."
}

/-- (Gini) Channel-exhaustion structural step under HA-7. -/
def gap_channels_exhaust_under_HA7 : GapEntry := {
  name := "channels_exhaust_under_HA7"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 \"Combining " ++
    "the channels\": under HA-7, the GE_0 deviation " ++
    "decomposes additively as the sum of (i) the capital-" ++
    "share-channel contribution and (ii) the verification-" ++
    "rent-channel contribution.  Paper-novel CHANNEL-" ++
    "EXHAUSTION step that consumes HA-7 to discharge the " ++
    "no-other-channel-reverses-the-direction requirement."
  attackHistory := []
  scope :=
    "Given `HA7_channels_not_anti_correlated I θ a R`, for " ++
    "any `capContrib ≤ κ_1·s_K·(1-μ)` and `verifContrib ≤ " ++
    "κ_2·(1-ν)`, the GE_0 deviation is at most `capContrib " ++
    "+ verifContrib`.  Atomic structural step consuming " ++
    "HA-7 explicitly."
}

/-- (Gini) Derived two-channel partition (former Cat 3 atomic). -/
def gap_gini_two_channel_partition_CLOSED : GapEntry := {
  name := "gini_two_channel_partition"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2.  Derived " ++
    "theorem composing `HA7_channels_not_anti_-" ++
    "correlated` (Cat 3 hypothesisPredicate) with " ++
    "`channels_exhaust_under_HA7` (Cat 3 structuralEquation)."
  attackHistory := []
  scope :=
    "Atomic partition statement: given bounds on the " ++
    "capital-share channel (≤ κ_1·s_K·(1-μ)) and the " ++
    "verification-rent channel (≤ κ_2·(1-ν)), the GE_0 " ++
    "deviation is bounded by their sum.  Derived theorem " ++
    "composing the 2 atomics; HA-7 supplied as an explicit " ++
    "hypothesis parameter `hHA7`."
}

/-- (Gini) Lerman-Yitzhaki comonotonicity translation. -/
def gap_lerman_yitzhaki_comonotonicity_translation : GapEntry := {
  name := "lerman_yitzhaki_comonotonicity_translation"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{cor:gini}` + Appendix A.2 Gini-" ++
    "translation atomic step: under comonotonicity, the " ++
    "Gini bound takes the same form as the GE_0 bound to " ++
    "first order in factor shares."
  attackHistory := []
  scope :=
    "Under comonotonicity, the Gini bound takes the same " ++
    "form as the GE_0 bound to first order in factor shares."
}

/-! ### Decomposition of `gap_lemma_lizzeri_bundled_rent` -/

/-- (Binding) Lizzeri 1999 Prop 1 — separate-certifier rent. -/
def gap_lizzeri_1999_separate_certifier_rent : GapEntry := {
  name := "lizzeri_1999_separate_certifier_rent"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Lizzeri, Alessandro, \"Information Revelation and " ++
    "Certification Intermediaries,\" *RAND Journal of " ++
    "Economics* 30(2), 1999, pp. 214–231, Proposition 1 " ++
    "(monopoly certifier with rational consumer expectations " ++
    "optimally discloses only whether quality is above or " ++
    "below the purchase-supporting threshold; extracts " ++
    "positive information-rent surplus `m_separate > 0`)."
  attackHistory := []
  scope :=
    "`∃ m_separate : ℝ, 0 < m_separate` for the " ++
    "SEPARATE-seller-and-intermediary configuration of " ++
    "Lizzeri 1999.  Full Lean derivation deferred to " ++
    "`gap_CredenceGoodIO_Mathlib_BLOCKED` (Lizzeri 1999 " ++
    "Prop 1 + credence-good information-revelation " ++
    "apparatus absent from Mathlib)."
}

/-- (Binding) Paper-novel integrated-extension via lem:independence. -/
def gap_bundled_extension_via_independence : GapEntry := {
  name := "bundled_extension_via_independence"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:lizzeri}` + Remark " ++
    "`\\label{rem:lizzeri_extension}`: the result extends the " ++
    "paper's separate-certifier base case to the integrated " ++
    "seller-certifier configuration; the integrated case " ++
    "requires Lemma~`\\label{lem:independence}` to rule out " ++
    "the alternative micro-foundation in which an integrated " ++
    "provider commits not to certify favorably and the " ++
    "configuration collapses to seller-side disclosure under " ++
    "adverse-selection signalling."
  attackHistory := []
  scope :=
    "`∀ (m_separate : ℝ), 0 < m_separate → ∃ m_bundled : ℝ, " ++
    "0 < m_bundled`.  Atomic step: positive separate-" ++
    "certifier rent extends to positive bundled rent under " ++
    "the integrated-seller-certifier configuration of " ++
    "Lemma~\\ref{lem:independence}."
}

/-- (Binding) Lemma~\ref{lem:lizzeri} — derived bundled rent (former Cat 3 atomic). -/
def gap_lemma_lizzeri_bundled_rent_CLOSED : GapEntry := {
  name := "lemma_lizzeri_bundled_rent"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{lem:lizzeri}` + Remark " ++
    "`\\label{rem:lizzeri_extension}`.  Derived theorem " ++
    "composing `lizzeri_1999_separate_certifier_rent` (Cat 2 " ++
    "base) with `bundled_extension_via_independence` (Cat 3 " ++
    "paper-novel)."
  attackHistory := []
  scope :=
    "`∃ m_bundled : ℝ, 0 < m_bundled` (integrated seller-" ++
    "certifier configuration).  Derived theorem composing " ++
    "the 2 atomics."
}

/-- (Binding) Lemma~\ref{lem:bertrand} — `mBertrand` carrier. -/
def gap_mBertrand_carrier : GapEntry := {
  name := "mBertrand"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{lem:bertrand}`: m_Bertrand(ν) := " ++
    "c_R / K(ν), the Bertrand-equilibrium rent function."
  attackHistory := []
  scope :=
    "Typed primitive `mBertrand : ℝ → ℝ`.  Non-negativity, " ++
    "monotonicity, and bundled-bound at saturation recorded " ++
    "in separate atomic axioms."
}

/-- (Binding) Lemma~\ref{lem:bertrand} — non-negativity. -/
def gap_mBertrand_nonneg : GapEntry := {
  name := "mBertrand_nonneg"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:bertrand}`: definitional " ++
    "non-negativity of `c_R / K(ν)` (positive numerator " ++
    "over positive count); paper-introduced primitive `mBertrand`."
  attackHistory := []
  scope :=
    "0 ≤ mBertrand ν for all ν.  Atomic non-negativity."
}

/-- (Binding) Lemma~\ref{lem:bertrand} — monotonicity. -/
def gap_mBertrand_monotone : GapEntry := {
  name := "mBertrand_monotone"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:bertrand}`: monotonicity of " ++
    "`c_R / K(ν)` follows from K(ν) monotone non-decreasing " ++
    "(paper Assumption \\ref{ass:reputation}: K(ν) = " ++
    "⌈K_max·ν⌉) — pure arithmetic on a paper-introduced " ++
    "primitive."
  attackHistory := []
  scope :=
    "ν₁ ≤ ν₂ on [0,1] ⇒ mBertrand ν₂ ≤ mBertrand ν₁.  " ++
    "Atomic monotonicity."
}

/-- (Binding) Lemma~\ref{lem:bertrand} — bundled bound. -/
def gap_mBertrand_one_le_bundled : GapEntry := {
  name := "mBertrand_one_le_bundled"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:bertrand}` saturation-vs-bundled " ++
    "comparison: paper-novel claim that the saturated-Bertrand " ++
    "rent ceiling `mBertrand 1 = c_R/K_max` is dominated by " ++
    "the integrated-seller-certifier rent `m_bundled` of " ++
    "Lemma `\\label{lem:lizzeri}`."
  attackHistory := []
  scope :=
    "mBertrand 1 ≤ m_bundled for any positive bundled-rent. " ++
    "Atomic bound at the saturation point."
}

/-! ### gapBlocked — Mathlib derivations deferred -/

/-- Full FO-encoding of welfare economics + producer theory. -/
def gap_FOEconomics_Mathlib_BLOCKED : GapEntry := {
  name := "FOEconomics_Mathlib_encoding"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Mathlib does not contain a formalisation of welfare " ++
    "economics, CES production functions, or the " ++
    "Mas-Colell-Whinston-Green producer-theory level-set " ++
    "/ cost-minimisation framework (MWG §5.C / §5.D " ++
    "duality + envelope apparatus).  Building this is a " ++
    "substantial separate project."
  attackHistory := []
  scope :=
    "Full Lean proofs of cost-minimisation uniqueness on " ++
    "Cobb-Douglas isoclines, CES envelope facts, and " ++
    "factor-source decomposition theorems as theorems " ++
    "against a concrete welfare-economics framework.  " ++
    "Deferred; the corresponding Cat 2 axioms remain " ++
    "atomic external-published axioms."
}

/-- Full FO-encoding of credence-good IO + Bertrand
    equilibrium analysis. -/
def gap_CredenceGoodIO_Mathlib_BLOCKED : GapEntry := {
  name := "CredenceGoodIO_Mathlib_encoding"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Mathlib does not contain a formalisation of " ++
    "industrial-organization auction/Bertrand equilibrium " ++
    "analysis or the Darby-Karni credence-good framework. " ++
    "Building this is a substantial separate project."
  attackHistory := []
  scope :=
    "Full Lean proofs of Lizzeri 1999 Proposition 1, " ++
    "Fauré-Grimaud-Peyrache 2009 Bertrand-collapse, and " ++
    "Klein-Leffler 1981 reputation-aggregation as theorems " ++
    "against a concrete IO framework.  Deferred; the " ++
    "corresponding Cat 2 axioms remain atomic external-" ++
    "published axioms."
}

/-- Full FO-encoding of capture games (menu-auction
    tradition). -/
def gap_CaptureGame_Mathlib_BLOCKED : GapEntry := {
  name := "CaptureGame_Mathlib_encoding"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Mathlib does not contain a formalisation of the " ++
    "menu-auction game-theoretic apparatus (Bernheim-" ++
    "Whinston 1986, Grossman-Helpman 1994), the regulatory-" ++
    "capture Peltzman-Becker pressure-group function, or " ++
    "the Laffont-Tirole 1991 multi-regulator analysis."
  attackHistory := []
  scope :=
    "Full Lean proofs of the capture-game equilibrium and " ++
    "the regulator-optimum-is-welfare-max step from paper " ++
    "§7.3 against a concrete game-theoretic framework. " ++
    "Deferred; the corresponding Cat 3 axioms remain atomic " ++
    "paper-novel structural equations."
}

/-! ### gapClosed entries — top-level theorems proven
       without `sorry` -/

/-- Theorem~\ref{thm:characterization}, ⇐ direction. -/
def gap_thm_characterization_suff_CLOSED : GapEntry := {
  name := "thm_characterization_suff"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{thm:characterization}` (⇐)"
  attackHistory := []
  scope :=
    "Sufficiency direction: ownership-invariant ⇒ welfare " ++
    "θ-invariant.  Composes welfareFactorsThroughAllocation " ++
    "with the rewrite using ownership-invariance equation."
}

/-- Theorem~\ref{thm:characterization}, ⇒ direction. -/
def gap_thm_characterization_nec_CLOSED : GapEntry := {
  name := "thm_characterization_nec"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{thm:characterization}` (⇒)"
  attackHistory := []
  scope :=
    "Necessity direction: welfare θ-invariant ⇒ ownership-" ++
    "invariant.  One-line application of " ++
    "bestResponseUniqueAtThetaInvariantWelfare (composes " ++
    "Cat 2 mwg_cost_min_uniqueness_isocline citing MWG §5.D + " ++
    "elementary convex analysis + Cat 3 case_1_different_-" ++
    "isoclines_implies_BR_invariant via OnSameIsocline " ++
    "case-split)."
}

/-- Theorem~\ref{thm:characterization}, iff form. -/
def gap_thm_characterization_CLOSED : GapEntry := {
  name := "thm_characterization"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{thm:characterization}`"
  attackHistory := []
  scope :=
    "Headline iff theorem composing both directions.  " ++
    "Combined statement WelfareThetaInvariant ↔ " ++
    "OwnershipInvariant."
}

/-- Proposition~\ref{prop:four_mechanisms}, M_β. -/
def gap_prop_four_mechanisms_Mbeta_CLOSED : GapEntry := {
  name := "prop_four_mechanisms_Mbeta"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{prop:four_mechanisms}` clause (M_β)"
  attackHistory := []
  scope :=
    "Exogenous-choice mechanism: the regime's financing " ++
    "mechanism designates a unique self-funded allocation `xF` " ++
    "and `br.alloc θ R` is self-funded ∀θ ⇒ ownership-" ++
    "invariant.  FOC-free Lean derivation; M_β " ++
    "genuinely distinct from M_γ / M_δ (predicates on " ++
    "`R.financingMechanism`)."
}

/-- Proposition~\ref{prop:four_mechanisms}, M_γ. -/
def gap_prop_four_mechanisms_Mgamma_CLOSED : GapEntry := {
  name := "prop_four_mechanisms_Mgamma"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{prop:four_mechanisms}` clause (M_γ)"
  attackHistory := []
  scope :=
    "Gradient-alignment mechanism: ProfitWelfareGradientAlign " ++
    "P W br R ⇒ ownership-invariant.  Derived via the Cat 3 " ++
    "axiom `gradientAlign_implies_ownership_invariant`.  M_γ " ++
    "genuinely distinct from M_β / M_δ (depends on the profit " ++
    "and welfare functionals P, W)."
}

/-- Proposition~\ref{prop:four_mechanisms}, M_δ. -/
def gap_prop_four_mechanisms_Mdelta_CLOSED : GapEntry := {
  name := "prop_four_mechanisms_Mdelta"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{prop:four_mechanisms}` clause (M_δ)"
  attackHistory := []
  scope :=
    "Constraint-set-invariance mechanism: the regime's " ++
    "external-constraint set is the singleton {xC} and " ++
    "`br.alloc θ R` is feasible ∀θ ⇒ ownership-invariant.  " ++
    "FOC-free Lean derivation; M_δ genuinely distinct " ++
    "from M_β / M_γ (predicates on `R.externalConstraints`)."
}

/-- Corollary~\ref{thm:separation}, structural form. -/
def gap_thm_separation_CLOSED : GapEntry := {
  name := "thm_separation"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{thm:separation}`"
  attackHistory := []
  scope :=
    "Constructive corollary: (SC1)–(SC6) ⇒ ownership-" ++
    "invariant.  Composes SC3_implements_Mbeta with " ++
    "prop_four_mechanisms_Mbeta."
}

/-- Corollary~\ref{thm:separation}, welfare-θ-invariance form. -/
def gap_thm_separation_welfare_invariant_CLOSED : GapEntry := {
  name := "thm_separation_welfare_invariant"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:separation}` composed with " ++
    "`\\label{thm:characterization}` (⇐)"
  attackHistory := []
  scope :=
    "(SC1)–(SC6) ⇒ welfare θ-invariant at fixed bmu.  " ++
    "Direct composition of thm_separation with " ++
    "thm_characterization_suff."
}

/-- Theorem~\ref{thm:gini}, GE_0 bound. -/
def gap_thm_gini_CLOSED : GapEntry := {
  name := "thm_gini"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{thm:gini}`"
  attackHistory := []
  scope :=
    "GE_0^*(θ,a,R) - GE_0^*(θ,baseline,R) ≤ κ_1(0)·s_K(0)·" ++
    "(1-μ) + κ_2·(1-ν).  Composes capital_share_channel_-" ++
    "contribution + verification_rent_channel_contribution + " ++
    "channels_exhaust_under_HA7 (under HA-7 hypothesis " ++
    "propagated as parameter)."
}

/-- Theorem~\ref{thm:gini}, θ-independence. -/
def gap_thm_gini_theta_invariance_CLOSED : GapEntry := {
  name := "thm_gini_theta_invariance"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 " ++
    "\"Independence of θ\""
  attackHistory := []
  scope :=
    "The bound is a function of (a, η) alone, contains no θ. " ++
    "Pure reflexivity proof."
}

/-- Corollary~\ref{cor:gini}, Gini translation. -/
def gap_cor_gini_CLOSED : GapEntry := {
  name := "cor_gini"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{cor:gini}`"
  attackHistory := []
  scope :=
    "Gini coefficient bound under Lerman-Yitzhaki " ++
    "comonotonicity.  Direct application of " ++
    "lerman_yitzhaki_comonotonicity_translation to thm_gini."
}

/-- Theorem~\ref{thm:gini}, mu-monotonicity. -/
def gap_thm_gini_bound_mono_mu_CLOSED : GapEntry := {
  name := "thm_gini_bound_mono_mu"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:gini}` \"The bound is monotone " ++
    "decreasing in each of μ and ν separately\""
  attackHistory := []
  scope :=
    "Bound monotone non-increasing in μ_product at fixed ν. " ++
    "Pure real-arithmetic proof (linarith)."
}

/-- Theorem~\ref{thm:gini}, nu-monotonicity. -/
def gap_thm_gini_bound_mono_nu_CLOSED : GapEntry := {
  name := "thm_gini_bound_mono_nu"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:gini}` \"The bound is monotone " ++
    "decreasing in each of μ and ν separately\""
  attackHistory := []
  scope :=
    "Bound monotone non-increasing in ν at fixed μ.  Pure " ++
    "real-arithmetic proof (linarith)."
}

/-- Theorem~\ref{thm:antitipping}, single-lever bound. -/
def gap_single_lever_bound_CLOSED : GapEntry := {
  name := "single_lever_bound"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:antitipping}` Appendix A.3 " ++
    "Step 7 (eq:single_lever)"
  attackHistory := []
  scope :=
    "ω > (Λ-1) / [δ + (β+γ)w_p] ⇒ Λ^eff(ω,π,ν) < 1.  Pure " ++
    "real-arithmetic proof.  Uses (1-π) ≤ 1, (1-η(ν)) ≤ 1 " ++
    "bound on residual-rent share."
}

/-- Theorem~\ref{thm:antitipping}, boundary check. -/
def gap_lambdaEff_at_zero_CLOSED : GapEntry := {
  name := "lambdaEff_at_zero"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:antitipping}` Appendix A.3 " ++
    "Step 6 boundary check"
  attackHistory := []
  scope :=
    "Λ^eff(0,0,0) = Λ recovers Korinek-Vipra tipping " ++
    "threshold.  Pure ring-arithmetic proof using " ++
    "eta_attenuation_at_zero and rent-share-weights-sum-" ++
    "to-one."
}

/-- Theorem~\ref{thm:antitipping}, main statement. -/
def gap_thm_antitipping_CLOSED : GapEntry := {
  name := "thm_antitipping"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{thm:antitipping}`"
  attackHistory := []
  scope :=
    "Structural-decoupling + single-lever bound ⇒ " ++
    "Λ^eff < 1.  Composes single_lever_bound with " ++
    "structurally-decoupled hypothesis."
}

/-- Theorem~\ref{thm:t4_binding}, verification-binding. -/
def gap_thm_t4_binding_CLOSED : GapEntry := {
  name := "thm_t4_binding"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{thm:t4_binding}`"
  attackHistory := []
  scope :=
    "∃ c > 0, ∀ (ω,π,ν), c·ν ≤ W_cred(ω,π,ν) - W_cred(ω,π,0). " ++
    "Composes Cat 2 lizzeri_1999_separate_certifier_rent + " ++
    "Cat 3 bundled_extension_via_independence (= derived " ++
    "lemma_lizzeri_bundled_rent) + Cat 3 mBertrand + " ++
    "Cat 3 mBertrand_one_le_bundled (= lem_bertrand " ++
    "ingredients) + Cat 3 lemma_independence_gap + Cat 3 " ++
    "welfare_gap_at_reference."
}

/-- Theorem~\ref{thm:t4_binding}, boundary case. -/
def gap_thm_t4_binding_at_boundary_CLOSED : GapEntry := {
  name := "thm_t4_binding_at_boundary"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:t4_binding}` Appendix A.4 " ++
    "(boundary case (ω,π) = (1,1))"
  attackHistory := []
  scope :=
    "Verification-binding survives at the boundary (ω,π) = " ++
    "(1,1).  Specialisation of thm_t4_binding."
}

/-- Lemma~\ref{lem:independence}. -/
def gap_lem_independence_CLOSED : GapEntry := {
  name := "lem_independence"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{lem:independence}`"
  attackHistory := []
  scope :=
    "(ω,π)-invariance of credence-good gap.  Restatement of " ++
    "lemma_independence_gap atomic axiom."
}

/-- Lemma~\ref{lem:lizzeri}. -/
def gap_lem_lizzeri_CLOSED : GapEntry := {
  name := "lem_lizzeri"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{lem:lizzeri}`"
  attackHistory := []
  scope :=
    "Restatement of lemma_lizzeri_bundled_rent atomic axiom."
}

/-- Lemma~\ref{lem:bertrand}. -/
def gap_lem_bertrand_CLOSED : GapEntry := {
  name := "lem_bertrand"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{lem:bertrand}`"
  attackHistory := []
  scope :=
    "Bertrand collapse: monotone non-increasing rent " ++
    "function bounded by bundled rent.  Composes Cat 3 " ++
    "atomics mBertrand (carrier) + mBertrand_nonneg + " ++
    "mBertrand_monotone + mBertrand_one_le_bundled."
}

/-- Theorem~\ref{thm:longrun}, long-run welfare-θ-invariance. -/
def gap_thm_longrun_CLOSED : GapEntry := {
  name := "thm_longrun"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{thm:longrun}`"
  attackHistory := []
  scope :=
    "Welfare θ-invariance survives the capture-game embedding " ++
    "under (M_α)+(M_β).  Composes long_run_step1_profit_zero, " ++
    "long_run_step4_zero_lobbying with the static " ++
    "thm_separation_welfare_invariant."
}

/-- Theorem~\ref{thm:longrun}, equilibrium-policy invariance. -/
def gap_thm_longrun_policy_invariance_CLOSED : GapEntry := {
  name := "thm_longrun_policy_invariance"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:longrun}` Step 5 " ++
    "(equilibrium-policy θ-invariance content)"
  attackHistory := []
  scope :=
    "Long-run-specific θ-invariance of the equilibrium " ++
    "policy m^* and resulting bmu^*(m^*).  Composes the two " ++
    "atomic axioms long_run_step5_mStar_invariance + " ++
    "long_run_step5_bmuStar_invariance under " ++
    "IsLongRunEquilibriumOf hypothesis."
}

/-- Proposition~\ref{prop:multi_agency}. -/
def gap_prop_multi_agency_CLOSED : GapEntry := {
  name := "prop_multi_agency"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Li 2026, `\\label{prop:multi_agency}`"
  attackHistory := []
  scope :=
    "Multi-agency robustness reduces to single-regulator " ++
    "thm_longrun at the binding un-captured regulator " ++
    "R_{k^*}."
}

/-! ### Cat 1 Mathlib-derivable helper lemmas

       Every labelled Lean declaration has a Ledger entry.  These 4
       structural helper `lemma`s are genuine Cat 1 (Mathlib-derivable)
       facts — proven via `mul_nonneg`, `mul_le_mul`, `le_min`,
       `linarith` from Mathlib + the paper's AccessVector /
       ScalingParameters carrier bounds.  Cat 1 is encoded as
       `theorem`/`lemma := <Mathlib proof>` with status `gapClosed`.
       The README "zero Cat 1 axioms" claim remains true — these are
       Cat 1 *theorems*, not axioms; the welfare-economics apparatus
       that WOULD need Cat 1 axioms is still absent (the 3 gapBlocked
       entries). -/

/-- Cat 1: `0 ≤ ω·π·ν` via Mathlib `mul_nonneg`. -/
def gap_muProduct_nonneg_CAT1 : GapEntry := {
  name := "muProduct_nonneg"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026 §3.2 AccessVector `μ = ω·π·ν` product reduction; " ++
    "non-negativity follows from Mathlib `mul_nonneg` applied " ++
    "to the AccessVector component bounds `hOmegaLo / hPiLo / " ++
    "hNuLo`."
  attackHistory := []
  scope :=
    "Lean lemma `AccessVector.muProduct_nonneg` (Basic.lean) — " ++
    "Cat 1 Mathlib-derivable; `0 ≤ a.muProduct`."
}

/-- Cat 1: `ω·π·ν ≤ 1` via Mathlib `mul_le_mul`. -/
def gap_muProduct_le_one_CAT1 : GapEntry := {
  name := "muProduct_le_one"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026 §3.2 AccessVector `μ = ω·π·ν` product reduction; " ++
    "upper bound `≤ 1` follows from Mathlib `mul_le_mul` applied " ++
    "to the AccessVector component upper bounds `hOmegaHi / " ++
    "hPiHi / hNuHi`."
  attackHistory := []
  scope :=
    "Lean lemma `AccessVector.muProduct_le_one` (Basic.lean) — " ++
    "Cat 1 Mathlib-derivable; `a.muProduct ≤ 1`."
}

/-- Cat 1: `0 ≤ min(ω,π,ν)` via Mathlib `le_min`. -/
def gap_muBottleneck_nonneg_CAT1 : GapEntry := {
  name := "muBottleneck_nonneg"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026 §3.2 AccessVector `μ = min(ω,π,ν)` bottleneck " ++
    "reduction; non-negativity follows from Mathlib `le_min` " ++
    "applied to the AccessVector component lower bounds."
  attackHistory := []
  scope :=
    "Lean lemma `AccessVector.muBottleneck_nonneg` (Basic.lean) — " ++
    "Cat 1 Mathlib-derivable; `0 ≤ a.muBottleneck`."
}

/-- Cat 1: `0 ≤ Λ = β+γ+δ` via Mathlib `linarith`. -/
def gap_Lambda_nonneg_CAT1 : GapEntry := {
  name := "Lambda_nonneg"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026 §3.1 + Korinek-Vipra returns-to-scale: " ++
    "`Λ = β + γ + δ`; non-negativity follows from Mathlib " ++
    "`linarith` applied to the ScalingParameters non-negativity " ++
    "fields `hBeta / hGamma / hDelta`."
  attackHistory := []
  scope :=
    "Lean lemma `ScalingParameters.Lambda_nonneg` " ++
    "(AntiTipping.lean) — Cat 1 Mathlib-derivable; `0 ≤ sp.Lambda`."
}

/-! ### gapClosed auxiliary helper theorems

       Every labelled Lean declaration has a Ledger entry.  These 3
       one-line wrapper theorems are recorded for completeness. -/

/-- Auxiliary: (SC1) ⇒ (M_α) one-line wrapper. -/
def gap_sc1_yields_Malpha_CLOSED : GapEntry := {
  name := "sc1_yields_Malpha"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:separation}` proof §4.7 — " ++
    "auxiliary cross-reference helper."
  attackHistory := []
  scope :=
    "Top-level Lean theorem `sc1_yields_Malpha` (Separation.lean) — " ++
    "one-line application of the Cat 3 atomic " ++
    "`SC1_implements_Malpha`.  Recorded for ledger completeness."
}

/-- Auxiliary: (SC3) ⇒ (M_β) one-line wrapper. -/
def gap_sc3_yields_Mbeta_CLOSED : GapEntry := {
  name := "sc3_yields_Mbeta"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:separation}` proof §4.7 — " ++
    "auxiliary cross-reference helper."
  attackHistory := []
  scope :=
    "Top-level Lean theorem `sc3_yields_Mbeta` (Separation.lean) — " ++
    "one-line application of the Cat 3 atomic " ++
    "`SC3_implements_Mbeta`.  Recorded for ledger completeness."
}

/-- Auxiliary: Λ^eff at bundled equilibrium equals Λ. -/
def gap_lambda_eff_at_bundled_equals_Lambda_CLOSED : GapEntry := {
  name := "lambda_eff_at_bundled_equals_Lambda"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:antitipping}` Appendix A.3 Step 6 " ++
    "boundary check — auxiliary cross-reference helper."
  attackHistory := []
  scope :=
    "Top-level Lean theorem `lambda_eff_at_bundled_equals_Lambda` " ++
    "(AntiTipping.lean) — auxiliary boundary check.  Recorded " ++
    "for ledger completeness."
}

/-! ### gapDeadEnd — archived deleted phantom -/

/-- Archived deleted phantom theorem `ha2_iff_acknowledged`. -/
def gap_ha2_iff_acknowledged_DELETED : GapEntry := {
  name := "ha2_iff_acknowledged"
  status := GapStatus.gapDeadEnd
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, §4.6 \"Tautology critique\" discipline note " ++
    "(was previously encoded as a degenerate `theorem`)."
  attackHistory := []
  scope :=
    "Archive-only entry for the deleted phantom theorem " ++
    "`ha2_iff_acknowledged`.  Status gapDeadEnd: degenerate " ++
    "`Iff.rfl` encoding carries zero content; not to be " ++
    "re-attempted."
}

/-! ### Aggregated ledger inventory -/

/-- All gap entries in canonical order. -/
def allGaps : List GapEntry := [
  -- Cat 2 external textbook (welfare-economics factorisation)
  gap_welfareFactorsThroughAllocation,
  -- Cat 3 paper-novel atomic structural equations (separation +
  -- binding + long-run)
  gap_SC1_implements_Malpha,
  gap_SC3_implements_Mbeta,
  -- M_γ richer-carrier: gradient-alignment carrier + FOC step
  gap_ProfitWelfareGradientAlign,
  gap_gradientAlign_implies_ownership_invariant,
  gap_lemma_independence_gap,
  gap_welfare_gap_at_reference,
  gap_long_run_step1_profit_zero,
  gap_long_run_step4_zero_lobbying,
  gap_long_run_step5_mStar_invariance,
  gap_long_run_step5_bmuStar_invariance,
  -- Cat 3 paper-novel hypothesis predicates
  gap_IsLongRunEquilibriumOf,
  gap_SC4_ExAnte,
  gap_SC5_LumpSum,
  gap_SC6_HD1,
  -- Cat 3 paper-novel typed primitives (carriers) + paper-stated
  -- atomic structural equations on η
  gap_kappa1_carrier,
  gap_kappa2_carrier,
  gap_sK_carrier,
  gap_eta_attenuation_carrier,
  gap_eta_attenuation_at_zero,
  gap_eta_attenuation_unit_interval,
  -- Cat 2 external textbook + Cat 3 paper-novel structural
  -- equations (mixed: Gini bound channels + Lizzeri/Bertrand
  -- binding apparatus)
  -- Decomposition of bestResponseUniqueAtThetaInvariantWelfare:
  -- 3 atomics + 1 derived theorem
  gap_OnSameIsocline_predicate,
  gap_mwg_cost_min_uniqueness_isocline,
  gap_case_1_different_isoclines_implies_BR_invariant,
  gap_bestResponseUniqueAtThetaInvariantWelfare_CLOSED,
  gap_kappa1_pos,
  gap_kappa2_pos,
  gap_sK_nonneg,
  gap_capital_share_channel_contribution,
  gap_verification_rent_channel_contribution,
  -- Decomposition of gini_two_channel_partition:
  -- 2 atomics + 1 derived theorem
  gap_HA7_channels_not_anti_correlated,
  gap_channels_exhaust_under_HA7,
  gap_gini_two_channel_partition_CLOSED,
  gap_lerman_yitzhaki_comonotonicity_translation,
  -- Decomposition of lemma_lizzeri_bundled_rent:
  -- 2 atomics + 1 derived theorem
  gap_lizzeri_1999_separate_certifier_rent,
  gap_bundled_extension_via_independence,
  gap_lemma_lizzeri_bundled_rent_CLOSED,
  -- mBertrand carrier + atomic facts
  gap_mBertrand_carrier,
  gap_mBertrand_nonneg,
  gap_mBertrand_monotone,
  gap_mBertrand_one_le_bundled,
  -- gapBlocked
  gap_FOEconomics_Mathlib_BLOCKED,
  gap_CredenceGoodIO_Mathlib_BLOCKED,
  gap_CaptureGame_Mathlib_BLOCKED,
  -- gapClosed top-level results
  gap_thm_characterization_suff_CLOSED,
  gap_thm_characterization_nec_CLOSED,
  gap_thm_characterization_CLOSED,
  gap_prop_four_mechanisms_Mbeta_CLOSED,
  gap_prop_four_mechanisms_Mgamma_CLOSED,
  gap_prop_four_mechanisms_Mdelta_CLOSED,
  gap_thm_separation_CLOSED,
  gap_thm_separation_welfare_invariant_CLOSED,
  gap_thm_gini_CLOSED,
  gap_thm_gini_theta_invariance_CLOSED,
  gap_cor_gini_CLOSED,
  gap_thm_gini_bound_mono_mu_CLOSED,
  gap_thm_gini_bound_mono_nu_CLOSED,
  gap_single_lever_bound_CLOSED,
  gap_lambdaEff_at_zero_CLOSED,
  gap_thm_antitipping_CLOSED,
  gap_thm_t4_binding_CLOSED,
  gap_thm_t4_binding_at_boundary_CLOSED,
  gap_lem_independence_CLOSED,
  gap_lem_lizzeri_CLOSED,
  gap_lem_bertrand_CLOSED,
  gap_thm_longrun_CLOSED,
  gap_thm_longrun_policy_invariance_CLOSED,
  gap_prop_multi_agency_CLOSED,
  -- Auxiliary helper theorems
  gap_sc1_yields_Malpha_CLOSED,
  gap_sc3_yields_Mbeta_CLOSED,
  gap_lambda_eff_at_bundled_equals_Lambda_CLOSED,
  -- Archived deleted phantom
  gap_ha2_iff_acknowledged_DELETED,
  -- Cat 1 Mathlib-derivable helper lemmas
  gap_muProduct_nonneg_CAT1,
  gap_muProduct_le_one_CAT1,
  gap_muBottleneck_nonneg_CAT1,
  gap_Lambda_nonneg_CAT1
]

/-- Status-keyed counts:
    `(open, partial, blocked, deadEnd, closed, closedConditional, definitional)`. -/
def gapCounts : Nat × Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : GapStatus) : Nat :=
    (allGaps.filter (fun g => g.status = s)).length
  ( countWhere GapStatus.gapOpen
  , countWhere GapStatus.gapPartial
  , countWhere GapStatus.gapBlocked
  , countWhere GapStatus.gapDeadEnd
  , countWhere GapStatus.gapClosed
  , countWhere GapStatus.gapClosedConditional
  , countWhere GapStatus.gapDefinitional )

/-- InputCategory-keyed counts: `(cat1Mathlib, cat2External, cat3PaperNovel, notInput)`. -/
def inputCategoryCounts : Nat × Nat × Nat × Nat :=
  let countWhere (c : InputCategory) : Nat :=
    (allGaps.filter (fun g => g.inputCategory = c)).length
  ( countWhere InputCategory.cat1Mathlib
  , countWhere InputCategory.cat2External
  , countWhere InputCategory.cat3PaperNovel
  , countWhere InputCategory.notInput )

/-- Cat3SubType-keyed counts:
    `(carrier, hypothesisPredicate, structuralEquation, workingAssumption, conditionalHypothesis, phenomenologicalConjecture, notCat3)`. -/
def cat3SubTypeCounts : Nat × Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : Cat3SubType) : Nat :=
    (allGaps.filter (fun g => g.cat3SubType = s)).length
  ( countWhere Cat3SubType.carrier
  , countWhere Cat3SubType.hypothesisPredicate
  , countWhere Cat3SubType.structuralEquation
  , countWhere Cat3SubType.workingAssumption
  , countWhere Cat3SubType.conditionalHypothesis
  , countWhere Cat3SubType.phenomenologicalConjecture
  , countWhere Cat3SubType.notCat3 )

#eval s!"AccessOrthogonality gap-ledger inventory (status):    open={(gapCounts).1} partial={(gapCounts).2.1} blocked={(gapCounts).2.2.1} deadEnd={(gapCounts).2.2.2.1} closed={(gapCounts).2.2.2.2.1} closedConditional={(gapCounts).2.2.2.2.2.1} definitional={(gapCounts).2.2.2.2.2.2}"

#eval s!"AccessOrthogonality gap-ledger inventory (input):     cat1Mathlib={(inputCategoryCounts).1} cat2External={(inputCategoryCounts).2.1} cat3PaperNovel={(inputCategoryCounts).2.2.1} notInput={(inputCategoryCounts).2.2.2}"

#eval s!"AccessOrthogonality gap-ledger inventory (Cat 3 sub): carrier={(cat3SubTypeCounts).1} hypothesisPredicate={(cat3SubTypeCounts).2.1} structuralEquation={(cat3SubTypeCounts).2.2.1} workingAssumption={(cat3SubTypeCounts).2.2.2.1} conditionalHypothesis={(cat3SubTypeCounts).2.2.2.2.1} phenomenologicalConjecture={(cat3SubTypeCounts).2.2.2.2.2.1} notCat3={(cat3SubTypeCounts).2.2.2.2.2.2}"

#eval s!"Total entries: {allGaps.length}"

/-! ### Inventory summary

  The live status / input-category / Cat 3 sub-type counts are
  printed by the `#eval` calls above (run
  `lake env lean AccessOrthogonality/Ledger.lean` to see them).
  The `#eval` output is AUTHORITATIVE; the prose below names
  entries, not counts, to avoid count-drift.

  Axiom names by category:

    Cat 2 propositional (genuinely external published):
      welfareFactorsThroughAllocation
        (definitional accounting identity; MWG 1995 §10.D
        / §16.F supplied as background reference for
        primitives, NOT as source of the factorization),
      mwg_cost_min_uniqueness_isocline
        (MWG 1995 §5.D + elementary convex analysis),
      lizzeri_1999_separate_certifier_rent
        (Lizzeri 1999 RAND 30(2) Prop 1)

    Cat 3 carrier axioms (Li 2026 paper-introduced primitives,
    sub-type: carrier):
      kappa1, kappa2, sK, eta_attenuation, mBertrand,
      ProfitWelfareGradientAlign

    Cat 3 hypothesis predicates (Li 2026 paper-introduced
    scope/regime predicates, sub-type: hypothesisPredicate):
      OnSameIsocline
        (paper §4.3 Case 1/Case 2 case-split discriminator),
      HA7_channels_not_anti_correlated
        (paper Appendix A.2 HA-7 working assumption),
      IsLongRunEquilibriumOf
        (paper §7.3 Step 5 long-run equilibrium-of-regime
        predicate),
      SC4_ExAnte
        (paper §3.2 ex-ante operational bmu predicate),
      SC5_LumpSum
        (paper §3.3 lump-sum transferability),
      SC6_HD1
        (paper §3.4 downstream HD-1 predicate)

    Cat 3 structural defining equations (Li 2026 paper-stated
    atomic equations on the carriers, sub-type:
    structuralEquation):
      SC1_implements_Malpha, SC3_implements_Mbeta,
      gradientAlign_implies_ownership_invariant
        (paper §3.3 (M_γ) FOC implementation step),
      lemma_independence_gap, welfare_gap_at_reference,
      case_1_different_isoclines_implies_BR_invariant
        (paper §4.3 Case 1 contradiction atomic),
      bundled_extension_via_independence
        (integrated-seller-certifier extension via
        `lem:independence`),
      channels_exhaust_under_HA7
        (paper Appendix A.2 channel-exhaustion under HA-7),
      mBertrand_one_le_bundled
        (saturated-Bertrand-vs-bundled rent bound),
      capital_share_channel_contribution
        (paper Appendix A.2 capital-share channel bound),
      verification_rent_channel_contribution
        (paper Appendix A.2 verification-rent channel bound),
      lerman_yitzhaki_comonotonicity_translation
        (paper cor:gini Gini-translation atomic step),
      long_run_step1_profit_zero,
      long_run_step4_zero_lobbying,
      long_run_step5_mStar_invariance,
      long_run_step5_bmuStar_invariance,
      eta_attenuation_at_zero,
      eta_attenuation_unit_interval

    Derived theorems closing the decompositions
    (gapClosed; not Cat 1/2/3 inputs):
      bestResponseUniqueAtThetaInvariantWelfare
        (composes OnSameIsocline + mwg_cost_min_uniqueness_-
        isocline + case_1_different_isoclines_implies_BR_-
        invariant via classical case-split),
      lemma_lizzeri_bundled_rent
        (composes lizzeri_1999_separate_certifier_rent +
        bundled_extension_via_independence),
      gini_two_channel_partition
        (composes HA7_channels_not_anti_correlated +
        channels_exhaust_under_HA7)

  Cat 3 sub-types not used in this project: `workingAssumption`
  (every axiom in this formalisation is a definitional atom —
  carrier, hypothesis predicate, or paper-stated structural
  equation — not a temporarily-axiomatized higher-level claim
  with a close target), `conditionalHypothesis` (paper
  conclusions are not conditional on external open problems
  like RH/BSD/Hodge/P≠NP), `phenomenologicalConjecture`
  (Access-Not-Ownership is a derivational-economics paper, not
  a framework paper publishing phenomenological conjectures).

  Cat 3 ratio.  The Cat 3 share of inputs (live count via
  `#eval inputCategoryCounts`) is high because the paper is
  genuinely novel: its theorem clusters (characterization,
  Gini bound, anti-tipping, verification-binding, long-run)
  each contribute several paper-stated atomic structural
  equations on paper-introduced primitives (κ_1, κ_2, s_K, η,
  m_Bertrand) plus paper-introduced regime/scope predicates
  (OnSameIsocline, HA-7, IsLongRunEquilibriumOf, SC4–SC6).
  Every Cat 3 entry is a definitional atom — a carrier, a
  hypothesis predicate, or a paper-stated structural equation
  — not a temporarily-axiomatized higher-level claim.

  Lean kernel (Cat 0; not declared here): propext,
  Classical.choice, Quot.sound.
-/

end AccessOrthogonality.Ledger
