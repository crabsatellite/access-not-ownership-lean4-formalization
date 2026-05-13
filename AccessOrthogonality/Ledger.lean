/-
  AccessOrthogonality/Ledger.lean

  Gap ledger.  Every atomic axiom, every Cat 3 carrier, every
  blocked route, and every closed top-level result is
  recorded as a typed `GapEntry` with three orthogonal
  classifications plus a broken-link dependency list:

    * 6-tier status:    gapOpen / gapPartial / gapBlocked /
                        gapDeadEnd / gapClosed /
                        gapClosedConditional
    * 4-input-category: cat1Mathlib / cat2External /
                        cat3PaperNovel / notInput
    * Cat 3 sub-type:   carrier / hypothesisPredicate /
                        structuralEquation / workingAssumption /
                        conditionalHypothesis / notCat3
    * conditionalOn :   list of `Hyp_*` broken-link predicate
                        names (non-empty iff status is
                        `gapClosedConditional`; see
                        `feedback_gap_ledger_in_lean4` v6 §12)

  Pre-attack discipline.  Scan this ledger before launching
  new attacks.  Re-attempting a `gapBlocked` or `gapDeadEnd`
  route is a context-drift failure mode.

  `attackHistory` is the canonical location for round
  metadata (citation revisions, atomic refactors, prior
  retractions, Cat 3 reductionism check outcomes); docstrings
  and scope fields are kept to current-state content only.
-/

import AccessOrthogonality

namespace AccessOrthogonality.Ledger

/-- 6-tier status tag attached to each gap.  `gapClosedConditional`
    is used when Phase 4 catches a defect breaking a typed-bridge
    chain: the downstream closure is preserved as conditional on a
    named `Hyp_*` broken-link hypothesis (recorded in the entry's
    `conditionalOn` field) pending repair or independent derivation.
    See `feedback_gap_ledger_in_lean4` v6 §12. -/
inductive GapStatus
  | gapOpen
  | gapPartial
  | gapBlocked
  | gapDeadEnd
  | gapClosed
  | gapClosedConditional
  deriving DecidableEq, Repr

/-- 4-input-category tag attached to each gap.  Orthogonal to status.
    (Cat 0 = Lean kernel axioms — `propext` / `Classical.choice` /
    `Quot.sound` — is the always-present system layer and is not
    tracked here per v6 §3.1.) -/
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

/-- Cat 3 paper-novel sub-types per v6 §3.4.  Orthogonal to status
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
  /-- This entry is not Cat 3 paper-novel. -/
  | notCat3
  deriving DecidableEq, Repr

/-- Typed record for a single gap. -/
structure GapEntry where
  /-- Identifier matching the underlying axiom / theorem
      name. -/
  name : String
  /-- 6-tier status. -/
  status : GapStatus
  /-- Input category (orthogonal to status). -/
  inputCategory : InputCategory
  /-- Cat 3 sub-type (orthogonal; `notCat3` unless
      `inputCategory = cat3PaperNovel`). -/
  cat3SubType : Cat3SubType
  /-- Operative paper / obstacle citation. -/
  paperSource : String
  /-- Per-round attack trace (canonical location for round
      metadata).  For Cat 3 entries, MUST include ≥2 reductionism
      check outcomes (Cat 1? Cat 2?) per v6 §5. -/
  attackHistory : List String
  /-- What content the entry carries; what it does NOT claim. -/
  scope : String
  /-- Names of `Hyp_*` broken-link predicates this entry's proof
      depends on.  Invariant: non-empty iff
      `status = gapClosedConditional`.  See v6 §12. -/
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
  attackHistory := [
    "v0.2 (audit R4): re-categorised Cat 3 → Cat 2.  " ++
      "Paper §4.6 explicitly states the factorisation IS " ++
      "welfare-economics-101, not paper-novel structural " ++
      "content.  Substantive contribution of T1 lives in " ++
      "the MWG Prop 5.C.2 cost-min step + four-mechanism " ++
      "enumeration, not in the factorisation."
  ]
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
  status := GapStatus.gapOpen
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
  status := GapStatus.gapOpen
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

/-- (Binding) lemma:independence — credence-good gap " ++
    "(ω,π)-invariance. -/
def gap_lemma_independence_gap : GapEntry := {
  name := "lemma_independence_gap"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:independence}`: extending Darby-" ++
    "Karni (1973) credence-good framework + Klein-Leffler " ++
    "(1981) reputation-aggregation, the consumer's credence-" ++
    "good gap on per-output quality q(y) is independent of " ++
    "(ω, π) on the credence-good portion of the foundation-" ++
    "model output space."
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
  status := GapStatus.gapOpen
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
  status := GapStatus.gapOpen
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
  status := GapStatus.gapOpen
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
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:longrun}` proof Step 5: \"With " ++
    "`ℓ^* = 0`, the regulator's stage-2 objective is " ++
    "`V_R = λ W^*`, whose maximiser is `m^W`.  By the static " ++
    "characterization (Theorem~\\ref{thm:characterization}), " ++
    "`W^*` does not depend on θ in the OI regime, so `m^W` " ++
    "is θ-invariant.\""
  attackHistory := [
    "v0.2 (audit R1): split out of the composite " ++
      "long_run_step5_policy_invariance axiom; one atomic " ++
      "axiom per paper claim per feedback_lean_axiom_decomposition.md"
  ]
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
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:longrun}` proof Step 5: \"Hence " ++
    "`bmu^*(m^W)` is θ-invariant, and the long-run " ++
    "orthogonality holds.\""
  attackHistory := [
    "v0.2 (audit R1): split out of the composite " ++
      "long_run_step5_policy_invariance axiom; one atomic " ++
      "axiom per paper claim per feedback_lean_axiom_decomposition.md"
  ]
  scope :=
    "Atomic bmu-component: under (M_α)+(M_β), the long-run " ++
    "equilibrium access vector `bmu^*(m^*)` is θ-invariant. " ++
    "Quantified over `IsLongRunEquilibriumOf eq R`.  " ++
    "Distinct from `long_run_step5_mStar_invariance` because " ++
    "bmu-invariance additionally requires the m → bmu(m) " ++
    "map to be well-defined and θ-blind at the selected m."
}

/-! ### Cat 3 paper-novel typed primitives
       (sub-type: carrier) -/

/-- κ_1(η) — capital-share coefficient. -/
def gap_kappa1_carrier : GapEntry := {
  name := "kappa1"
  status := GapStatus.gapOpen
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
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2: κ_2 > 0 " ++
    "proportional to share of consumer expenditure subject " ++
    "to verification rent at baseline."
  attackHistory := []
  scope := "Typed primitive `kappa2 : ℝ`."
}

/-- s_K(η) — Acemoglu-Restrepo capital task share. -/
def gap_sK_carrier : GapEntry := {
  name := "sK"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2; primary " ++
    "reference: Acemoglu and Restrepo (2018, 2022) for " ++
    "task-share apparatus."
  attackHistory := []
  scope :=
    "Typed primitive `sK (η : ℝ) : ℝ`.  Acemoglu-Restrepo " ++
    "capital task share at CES elasticity η."
}

/-- η(ν) — Bertrand-attenuation function. -/
def gap_eta_attenuation_carrier : GapEntry := {
  name := "eta_attenuation"
  status := GapStatus.gapOpen
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
  status := GapStatus.gapOpen
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
  status := GapStatus.gapOpen
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

/-! ### v0.3 §3.4.6 reductionism decomposition of former
       `gap_bestResponseUniqueAtThetaInvariantWelfare` -/

/-- (Characterization) Case-split discriminator: same-isocline. -/
def gap_OnSameIsocline_predicate : GapEntry := {
  name := "OnSameIsocline"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026, `\\label{thm:characterization}` (⇒) Necessity " ++
    "proof Case 1 (\"the two allocations lie on different " ++
    "isoclines of `c^β d^γ`\") vs. Case 2 (\"the two " ++
    "allocations lie on the same isocline\").  Paper-" ++
    "introduced isocline-classifier predicate at the basis " ++
    "of the case-split argument."
  attackHistory := [
    "v0.3 (audit R11): created in §3.4.6 reductionism " ++
      "decomposition of former Cat 3 atomic " ++
      "`bestResponseUniqueAtThetaInvariantWelfare`.  " ++
      "Same-isocline predicate is the paper-stated " ++
      "case-split discriminator; carried as a Cat 3 " ++
      "hypothesisPredicate to expose the case-split " ++
      "structure at the Lean level.",
    "v6 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "Cobb-Douglas isocline classifier at the abstract " ++
      "BestResponseMap level; this is the paper's specific " ++
      "case-split apparatus.",
    "v6 reductionism Cat 2?: CLEAR-NO — the case-split " ++
      "discriminator itself is paper-introduced (paper " ++
      "§4.3 Necessity proof structure); not a free-standing " ++
      "external textbook predicate.  MWG Prop 5.C.2(v) is " ++
      "what gets APPLIED inside Case 2 (recorded as the " ++
      "separate Cat 2 atomic " ++
      "`mwg_cost_min_uniqueness_isocline`)."
  ]
  scope :=
    "Paper §4.3 same-isocline predicate over " ++
    "`(BestResponseMap, OwnershipType, OwnershipType, Regime)`.  " ++
    "Carrier-only Prop at the abstract layer; substantive " ++
    "paper content lives in the two consuming atomics."
}

/-- (Characterization) MWG Prop 5.C.2(v) cost-min uniqueness. -/
def gap_mwg_cost_min_uniqueness_isocline : GapEntry := {
  name := "mwg_cost_min_uniqueness_isocline"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Mas-Colell, Whinston, Green, *Microeconomic Theory*, " ++
    "Oxford University Press 1995, §5.C, Proposition " ++
    "5.C.2(v) (cost-min uniqueness on strictly-convex " ++
    "production sets under strictly positive input prices).  " ++
    "Paper Case 2 of `\\label{thm:characterization}` (⇒) " ++
    "Necessity invokes this directly: \"the cost-minimising " ++
    "point on the isocline is unique given input prices " ++
    "r_c and w_d ... is a single point\"."
  attackHistory := [
    "v0.3 (audit R11): extracted as a separate Cat 2 atomic " ++
      "in the §3.4.6 reductionism decomposition of former " ++
      "Cat 3 atomic `bestResponseUniqueAtThetaInvariantWelfare`.  " ++
      "The textbook content (MWG 5.C.2(v) cost-min uniqueness " ++
      "on strictly-convex isoquants) is now explicitly " ++
      "chained in the Lean signature of the derived theorem, " ++
      "not absorbed into the paper-novel atomic."
  ]
  scope :=
    "`∀ (br : BestResponseMap) (R : Regime) (θ₁ θ₂ : " ++
    "OwnershipType), OnSameIsocline br θ₁ θ₂ R → br.alloc " ++
    "θ₁ R = br.alloc θ₂ R`.  Cobb-Douglas isocline satisfies " ++
    "the strict-concavity-on-level-sets hypothesis of MWG " ++
    "5.C.2(v).  Full Lean derivation deferred to " ++
    "`gap_FOEconomics_Mathlib_BLOCKED` (MWG-style producer-" ++
    "theory cost-min apparatus absent from Mathlib)."
}

/-- (Characterization) Paper Case 1 contradiction. -/
def gap_case_1_different_isoclines_implies_BR_invariant : GapEntry := {
  name := "case_1_different_isoclines_implies_BR_invariant"
  status := GapStatus.gapOpen
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
  attackHistory := [
    "v0.3 (audit R11): created in the §3.4.6 reductionism " ++
      "decomposition of former Cat 3 atomic " ++
      "`bestResponseUniqueAtThetaInvariantWelfare`.  Case 1 " ++
      "contradiction is the paper-novel half of the " ++
      "Necessity argument (Case 2 reduces to MWG 5.C.2(v) " ++
      "via `mwg_cost_min_uniqueness_isocline`).",
    "v6 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "welfare-functional decomposition or quality-dynamics " ++
      "apparatus at this abstraction.",
    "v6 reductionism Cat 2?: CLEAR-NO — the Case 1 " ++
      "contradiction is paper-specific; MWG 5.C.2(v) covers " ++
      "Case 2 only.  No external textbook directly states " ++
      "\"different isoclines + θ-invariant welfare → BR " ++
      "coincides\" at this level of abstraction."
  ]
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
    "full argument.  v0.3 derived theorem composing Case 1 " ++
    "(Cat 3 `case_1_different_isoclines_implies_BR_invariant`) " ++
    "and Case 2 (Cat 2 `mwg_cost_min_uniqueness_isocline` " ++
    "via the same-isocline `OnSameIsocline` discriminator) " ++
    "by classical case-split."
  attackHistory := [
    "v0.2 (audit R7): re-categorised Cat 2 → Cat 3 (former " ++
      "single-atomic composite).  Future-decomposition note " ++
      "flagged.",
    "v0.3 (audit R11): §3.4.6 reductionism decomposition " ++
      "executed.  Former single Cat 3 atomic → 3 atomics " ++
      "(`OnSameIsocline` Cat 3 hypothesisPredicate + " ++
      "`mwg_cost_min_uniqueness_isocline` Cat 2 + " ++
      "`case_1_different_isoclines_implies_BR_invariant` " ++
      "Cat 3 structuralEquation) + this derived theorem.  " ++
      "Cat 3 count effect: 1 → 2 (+1).  Cat 2 count effect: " ++
      "0 → 1 (+1).  Total Cat 2 + Cat 3 count: +2."
  ]
  scope :=
    "Necessity direction of Theorem~\\ref{thm:characterization}: " ++
    "if welfare is θ-invariant, then the best-response is " ++
    "θ-invariant.  Derived theorem composing the 3 atomics " ++
    "via classical case-split on `OnSameIsocline`."
}

/-- (Gini) κ_1 positivity for η < 1. -/
def gap_kappa1_pos : GapEntry := {
  name := "kappa1_pos"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Acemoglu and Restrepo, \"The Race Between Man and " ++
    "Machine,\" *American Economic Review* 108(6), 2018, " ++
    "pp. 1488–1542, Section IV (factor-share CES envelope " ++
    "at η < 1); Acemoglu and Restrepo, \"Tasks, Automation, " ++
    "and the Rise in U.S. Wage Inequality,\" *Econometrica* " ++
    "90(5), 2022, pp. 1973–2016, Theorem 2."
  attackHistory := []
  scope := "0 < κ_1(η) whenever η < 1 (gross complements)."
}

/-- (Gini) κ_2 positivity. -/
def gap_kappa2_pos : GapEntry := {
  name := "kappa2_pos"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Lizzeri, Alessandro, \"Information Revelation and " ++
    "Certification Intermediaries,\" *RAND Journal of " ++
    "Economics* 30(2), 1999, pp. 214–231, Proposition 1 " ++
    "(rent-extraction by monopoly seller-certifier)."
  attackHistory := []
  scope := "0 < κ_2."
}

/-- (Gini) s_K(η) non-negativity. -/
def gap_sK_nonneg : GapEntry := {
  name := "sK_nonneg"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Standard CES accounting; capital task share is a share " ++
    "of total income.  Acemoglu and Restrepo (2018, 2022) " ++
    "for the task-share apparatus."
  attackHistory := []
  scope := "0 ≤ s_K(η)."
}

/-- (Gini) Capital-share channel contribution. -/
def gap_capital_share_channel_contribution : GapEntry := {
  name := "capital_share_channel_contribution"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 capital-share " ++
    "channel: composition of Acemoglu-Restrepo (2018) AER " ++
    "108(6) task-share dynamics under CES + Korinek-Vipra " ++
    "(2025) returns-to-scale apparatus, yielding the bound " ++
    "form `κ_1 · s_K · (1-μ)`."
  attackHistory := [
    "v0.2 (audit R3): re-categorised Cat 2 → Cat 3.  " ++
      "Textbook references (Acemoglu-Restrepo 2018, " ++
      "Korinek-Vipra 2025) supply ingredients but do not " ++
      "directly yield the bound — the composition is " ++
      "paper-novel."
  ]
  scope :=
    "Existence of capital-channel contribution capContrib ≤ " ++
    "κ_1(0) · s_K(0) · (1 - μ_product).  η = 0 parameter " ++
    "slot for baseline elasticity."
}

/-- (Gini) Verification-rent channel contribution. -/
def gap_verification_rent_channel_contribution : GapEntry := {
  name := "verification_rent_channel_contribution"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 verification-" ++
    "rent channel: composition of Lemma `\\label{lem:lizzeri}` " ++
    "integrated-seller-certifier rent (paper-novel extension " ++
    "of Lizzeri 1999) + Lemma `\\label{lem:bertrand}` " ++
    "Bertrand-saturation + κ_2-scaling apparatus."
  attackHistory := [
    "v0.2 (audit R3): re-categorised Cat 2 → Cat 3.  " ++
      "Underlying integrated-seller-certifier setup is " ++
      "paper-novel (Lizzeri 1999 treats SEPARATE " ++
      "intermediary); composition with Bertrand and " ++
      "κ_2-scaling is also paper-novel."
  ]
  scope :=
    "Existence of verification-channel contribution " ++
    "verifContrib ≤ κ_2 · (1 - ν)."
}

/-- (Gini) Shorrocks 1982 additive decomposition (atomic). -/
def gap_shorrocks_additive_decomposition_atomic : GapEntry := {
  name := "shorrocks_additive_decomposition_atomic"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Shorrocks, A. F., \"Inequality Decomposition by Factor " ++
    "Components,\" *Econometrica* 50(1), 1982, pp. 193–211 " ++
    "(canonical factor-source decomposition theorem for " ++
    "inequality indices; specifically Theorem 1 — mean log " ++
    "deviation `GE_0` is the unique additively-decomposable " ++
    "inequality index)."
  attackHistory := [
    "v0.2 (audit R3): renamed from `shorrocks_additive_decomposition` " ++
      "and decomposed.  Original axiom bundled Shorrocks " ++
      "1982 decomposability (Cat 2) with the paper-novel " ++
      "two-channel partition under HA-7 (Cat 3); split into " ++
      "atomic Cat 2 + atomic Cat 3 axiom " ++
      "`gini_two_channel_partition`."
  ]
  scope :=
    "Atomic textbook fact (Shorrocks 1982 Thm 1) that GE_0 " ++
    "admits factor-source additive decomposition.  Does NOT " ++
    "assert that the two paper-stated channels exhaust the " ++
    "decomposition — that paper-novel partition lives in " ++
    "`gini_two_channel_partition`."
}

/-! ### v0.3 §3.4.6 reductionism decomposition of former
       `gap_gini_two_channel_partition` -/

/-- (Gini) HA-7 channels-not-anti-correlated predicate. -/
def gap_HA7_channels_not_anti_correlated : GapEntry := {
  name := "HA7_channels_not_anti_correlated"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026, `\\label{thm:gini}` Appendix A.2 working " ++
    "assumption HA-7: \"the capital-rent and verification-" ++
    "rent channels are not anti-correlated in the income " ++
    "distribution\".  Paper-stated working-assumption " ++
    "predicate (regime-condition on the income-rank " ++
    "correlation between the two channels)."
  attackHistory := [
    "v0.3 (audit R11): extracted as a Cat 3 hypothesis-" ++
      "predicate in the §3.4.6 reductionism decomposition " ++
      "of former Cat 3 atomic `gini_two_channel_partition`.  " ++
      "HA-7 is the paper's explicit named working assumption; " ++
      "carrying it as a Prop exposes the discipline at the " ++
      "Lean level.",
    "v6 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "income-rank-correlation apparatus on inequality " ++
      "indices.",
    "v6 reductionism Cat 2?: CLEAR-NO — HA-7 is paper-" ++
      "specific working assumption; not a free-standing " ++
      "external theorem."
  ]
  scope :=
    "HA-7 carrier — paper-introduced working-assumption " ++
    "predicate over `(InequalityFunctional, OwnershipType, " ++
    "AccessVector, Regime)`.  Carrier-only Prop at our " ++
    "abstraction layer; substantive paper content lives in " ++
    "the consuming axiom `channels_exhaust_under_HA7`."
}

/-- (Gini) Channel-exhaustion structural step under HA-7. -/
def gap_channels_exhaust_under_HA7 : GapEntry := {
  name := "channels_exhaust_under_HA7"
  status := GapStatus.gapOpen
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
  attackHistory := [
    "v0.3 (audit R11): created in the §3.4.6 reductionism " ++
      "decomposition of former Cat 3 atomic " ++
      "`gini_two_channel_partition`.  Now explicitly " ++
      "consumes the HA-7 hypothesisPredicate; channel-" ++
      "exhaustion is the paper-novel structural step.",
    "v6 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "factor-source decomposition exhaustiveness for " ++
      "GE_0 at this abstraction.",
    "v6 reductionism Cat 2?: CLEAR-NO — the EXHAUSTIVENESS " ++
      "of the two-channel partition is paper-specific.  " ++
      "Shorrocks 1982 (Cat 2 atomic " ++
      "`shorrocks_additive_decomposition_atomic`) gives " ++
      "additive-decomposability of GE_0 along ANY factor-" ++
      "source partition; the paper's claim that CAPITAL-" ++
      "SHARE + VERIFICATION-RENT specifically exhaust the " ++
      "decomposition under HA-7 is paper-novel."
  ]
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
    "Li 2026, `\\label{thm:gini}` Appendix A.2.  v0.3 " ++
    "derived theorem composing `HA7_channels_not_anti_-" ++
    "correlated` (Cat 3 hypothesisPredicate) with " ++
    "`channels_exhaust_under_HA7` (Cat 3 structuralEquation)."
  attackHistory := [
    "v0.2 (audit R3): created as a single Cat 3 atomic " ++
      "absorbing both HA-7 + channel-exhaustion.",
    "v0.3 (audit R11): §3.4.6 reductionism decomposition " ++
      "executed.  Former single Cat 3 atomic → 2 atomics " ++
      "(`HA7_channels_not_anti_correlated` Cat 3 " ++
      "hypothesisPredicate + `channels_exhaust_under_HA7` " ++
      "Cat 3 structuralEquation) + this derived theorem.  " ++
      "Cat 3 count effect: 1 → 2 (+1; both atomic but each " ++
      "is a strictly smaller paper-stated step).  Cat 2 " ++
      "count effect: 0 (unchanged)."
  ]
  scope :=
    "Atomic partition statement: given bounds on the " ++
    "capital-share channel (≤ κ_1·s_K·(1-μ)) and the " ++
    "verification-rent channel (≤ κ_2·(1-ν)), the GE_0 " ++
    "deviation is bounded by their sum.  Derived theorem " ++
    "composing the 2 atomics; HA-7 discharged at the " ++
    "abstraction layer as `True` (paper-stated working-" ++
    "assumption Prop)."
}

/-- (Gini) Lerman-Yitzhaki comonotonicity translation. -/
def gap_lerman_yitzhaki_comonotonicity_translation : GapEntry := {
  name := "lerman_yitzhaki_comonotonicity_translation"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{cor:gini}` + Appendix A.2 " ++
    "Translation-to-Gini composition: Li's composition of " ++
    "Lerman-Yitzhaki (1985) *RESt* 67(1):151-156 Gini " ++
    "decomposition formula `G = Σ s_k G_k R_k` (Cat 2 " ++
    "textbook ingredient) with the GE_0-bound form of " ++
    "`thm_gini`, plus first-order factor-share " ++
    "linearisation to match coefficients."
  attackHistory := [
    "v0.2 (audit R3+R7): re-categorised Cat 2 → Cat 3.  " ++
      "Lerman-Yitzhaki 1985 supplies the Gini decomposition " ++
      "theorem; the transcription from GE_0 bound to Gini " ++
      "bound with coefficient match to first order is " ++
      "paper-novel composition."
  ]
  scope :=
    "Under comonotonicity, the Gini bound takes the same " ++
    "form as the GE_0 bound to first order in factor shares."
}

/-! ### v0.3 §3.4.6 reductionism decomposition of former
       `gap_lemma_lizzeri_bundled_rent` -/

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
  attackHistory := [
    "v0.3 (audit R11): extracted as a separate Cat 2 atomic " ++
      "in the §3.4.6 reductionism decomposition of former " ++
      "Cat 3 atomic `lemma_lizzeri_bundled_rent`.  Base " ++
      "Lizzeri 1999 Prop 1 (separate-intermediary case) is " ++
      "the EXTERNAL textbook fact on which paper Lemma " ++
      "`\\label{lem:lizzeri}` builds; the integrated " ++
      "extension is the paper-novel direction (recorded as " ++
      "`gap_bundled_extension_via_independence`)."
  ]
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
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:lizzeri}` + Remark " ++
    "`\\label{rem:lizzeri_extension}`: \"The result is an " ++
    "extension of \\citet{lizzeri1999information} to the " ++
    "integrated seller-certifier configuration ... the " ++
    "integrated case requires Lemma~\\ref{lem:independence} " ++
    "to rule out the alternative micro-foundation in which " ++
    "an integrated provider commits not to certify favorably " ++
    "and the configuration collapses to seller-side " ++
    "disclosure under signalling à la Akerlof (1970).\""
  attackHistory := [
    "v0.3 (audit R11): created in the §3.4.6 reductionism " ++
      "decomposition of former Cat 3 atomic " ++
      "`lemma_lizzeri_bundled_rent`.  Bundled extension is " ++
      "the paper-novel direction (Remark " ++
      "`\\label{rem:lizzeri_extension}`); the base " ++
      "separate-certifier rent fact is now the Cat 2 atomic " ++
      "`lizzeri_1999_separate_certifier_rent`.",
    "v6 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "credence-good seller-certifier IO apparatus.",
    "v6 reductionism Cat 2?: CLEAR-NO — paper Remark " ++
      "`\\label{rem:lizzeri_extension}` is explicit that " ++
      "the integrated case is NOT in Lizzeri 1999 (\"Lizzeri " ++
      "(1999) treats an independent monopolist certifier " ++
      "facing a separate seller\") and the extension goes " ++
      "via Lemma~\\ref{lem:independence}.  Albano-Lizzeri " ++
      "(2001) covers a related but DISTINCT setup; not the " ++
      "operative source.  Conclusion: paper-novel."
  ]
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
    "`\\label{rem:lizzeri_extension}`.  v0.3 derived theorem " ++
    "composing `lizzeri_1999_separate_certifier_rent` (Cat 2 " ++
    "base) with `bundled_extension_via_independence` (Cat 3 " ++
    "paper-novel)."
  attackHistory := [
    "v0.2 (audit R2): re-categorised Cat 2 → Cat 3 after " ++
      "verifying Lizzeri 1999 treats SEPARATE intermediary, " ++
      "not integrated seller-certifier; original atomic " ++
      "absorbed both directions.",
    "v0.3 (audit R11): §3.4.6 reductionism decomposition " ++
      "executed.  Former single Cat 3 atomic → 2 atomics " ++
      "(`lizzeri_1999_separate_certifier_rent` Cat 2 + " ++
      "`bundled_extension_via_independence` Cat 3 " ++
      "structuralEquation) + this derived theorem.  Cat 3 " ++
      "count effect: -1 + 1 = 0 (net 0; same count but " ++
      "now properly chained through external textbook " ++
      "base).  Cat 2 count effect: 0 → 1 (+1)."
  ]
  scope :=
    "`∃ m_bundled : ℝ, 0 < m_bundled` (integrated seller-" ++
    "certifier configuration).  Derived theorem composing " ++
    "the 2 atomics."
}

/-- (Binding) Lemma~\ref{lem:bertrand} — `mBertrand` carrier. -/
def gap_mBertrand_carrier : GapEntry := {
  name := "mBertrand"
  status := GapStatus.gapOpen
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
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Tirole, Jean, *The Theory of Industrial Organization*, " ++
    "MIT Press 1988, Chapter 5 (Bertrand price competition " ++
    "with K ≥ 2 symmetric firms; the per-certifier rent " ++
    "c_R / K(ν) at the symmetric equilibrium is non-negative " ++
    "by construction)."
  attackHistory := [
    "v0.2 (audit R2): citation re-anchored from " ++
      "fabricated 'Fauré-Grimaud, Peyrache 2009 The " ++
      "Collapse of a Rating Industry under Competition' " ++
      "(verified non-existent; the actual 2009 RAND " ++
      "paper is Faure-Grimaud-Peyrache-Quesada, \"The " ++
      "Ownership of Ratings,\" RAND 40(2):234–257, which " ++
      "argues competition REDUCES information — the " ++
      "opposite direction of the Bertrand-collapse claim) " ++
      "to Tirole 1988 Ch. 5 (canonical Bertrand-with-K-firms " ++
      "textbook reference)."
  ]
  scope :=
    "0 ≤ mBertrand ν for all ν.  Atomic non-negativity."
}

/-- (Binding) Lemma~\ref{lem:bertrand} — monotonicity. -/
def gap_mBertrand_monotone : GapEntry := {
  name := "mBertrand_monotone"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Tirole 1988, *Theory of Industrial Organization*, MIT " ++
    "Press, Ch. 5 §5.7 (entry under fixed cost; per-firm " ++
    "rent at the symmetric Bertrand equilibrium scales " ++
    "inversely in the number of competitors)."
  attackHistory := [
    "v0.2 (audit R2): citation re-anchored from fabricated " ++
      "Fauré-Grimaud-Peyrache 2009 \"Collapse\" reference " ++
      "to Tirole 1988 Ch. 5 §5.7 (textbook Bertrand-with-K-firms)."
  ]
  scope :=
    "ν₁ ≤ ν₂ on [0,1] ⇒ mBertrand ν₂ ≤ mBertrand ν₁.  " ++
    "Atomic monotonicity."
}

/-- (Binding) Lemma~\ref{lem:bertrand} — bundled bound. -/
def gap_mBertrand_one_le_bundled : GapEntry := {
  name := "mBertrand_one_le_bundled"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:bertrand}` saturation-vs-bundled " ++
    "comparison: paper-novel claim that the saturated-Bertrand " ++
    "rent ceiling `mBertrand 1 = c_R/K_max` is dominated by " ++
    "the integrated-seller-certifier rent `m_bundled` of " ++
    "Lemma `\\label{lem:lizzeri}`.  The textbook ingredients " ++
    "(Tirole 1988 Ch. 5 Bertrand, Lizzeri 1999 Prop 1 " ++
    "separate-intermediary case) do not directly establish " ++
    "the inequality on the integrated-configuration."
  attackHistory := [
    "v0.2 (audit R2): re-categorised Cat 2 → Cat 3.  " ++
      "Textbook references (Tirole 1988, Lizzeri 1999) " ++
      "supply ingredients but do not directly bound the " ++
      "integrated-vs-saturated rent comparison."
  ]
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
    "Mas-Colell-Whinston-Green cost-minimisation framework " ++
    "(Prop 5.C.2 et seq.).  Building this is a substantial " ++
    "separate project."
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
    "bestResponseUniqueAtThetaInvariantWelfare (the MWG " ++
    "Prop 5.C.2 atomic carrier of cost-minimisation " ++
    "uniqueness on Cobb-Douglas isoclines)."
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
    "Exogenous-choice mechanism: ∃ x, ∀ θ, alloc θ = x ⇒ " ++
    "ownership-invariant.  Direct definitional unfolding."
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
    "Gradient-alignment mechanism: ∇Π = ∇W (operationalised " ++
    "as alloc θ = x for all θ) ⇒ ownership-invariant."
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
    "Constraint-set-invariance mechanism: binding " ++
    "constraint pinning (c,d) regardless of θ ⇒ ownership-" ++
    "invariant."
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
    "(1-μ) + κ_2·(1-ν).  Composes capital-share-channel, " ++
    "verification-rent-channel, and Shorrocks 1982 " ++
    "additive-decomposition atomic axioms."
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
    "Composes lemma_lizzeri_bundled_rent, " ++
    "lemma_bertrand_collapse, welfare_gap_at_reference, " ++
    "lemma_independence_gap."
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
    "function bounded by bundled rent.  Restatement of " ++
    "lemma_bertrand_collapse atomic axiom."
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
    "policy m^* and resulting bmu^*(m^*).  Direct from " ++
    "long_run_step5_policy_invariance atomic axiom."
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

/-! ### Aggregated ledger inventory -/

/-- All gap entries in canonical order. -/
def allGaps : List GapEntry := [
  -- Cat 2 external textbook (welfare-economics factorisation)
  gap_welfareFactorsThroughAllocation,
  -- Cat 3 paper-novel atomic structural equations (separation +
  -- binding + long-run)
  gap_SC1_implements_Malpha,
  gap_SC3_implements_Mbeta,
  gap_lemma_independence_gap,
  gap_welfare_gap_at_reference,
  gap_long_run_step1_profit_zero,
  gap_long_run_step4_zero_lobbying,
  gap_long_run_step5_mStar_invariance,
  gap_long_run_step5_bmuStar_invariance,
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
  -- v0.3 §3.4.6 reductionism decomposition:
  -- bestResponseUniqueAtThetaInvariantWelfare → 3 atomics + 1 derived theorem
  gap_OnSameIsocline_predicate,
  gap_mwg_cost_min_uniqueness_isocline,
  gap_case_1_different_isoclines_implies_BR_invariant,
  gap_bestResponseUniqueAtThetaInvariantWelfare_CLOSED,
  gap_kappa1_pos,
  gap_kappa2_pos,
  gap_sK_nonneg,
  gap_capital_share_channel_contribution,
  gap_verification_rent_channel_contribution,
  gap_shorrocks_additive_decomposition_atomic,
  -- v0.3 §3.4.6 reductionism decomposition:
  -- gini_two_channel_partition → 2 atomics + 1 derived theorem
  gap_HA7_channels_not_anti_correlated,
  gap_channels_exhaust_under_HA7,
  gap_gini_two_channel_partition_CLOSED,
  gap_lerman_yitzhaki_comonotonicity_translation,
  -- v0.3 §3.4.6 reductionism decomposition:
  -- lemma_lizzeri_bundled_rent → 2 atomics + 1 derived theorem
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
  gap_prop_multi_agency_CLOSED
]

/-- Status-keyed counts:
    `(open, partial, blocked, deadEnd, closed, closedConditional)`. -/
def gapCounts : Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : GapStatus) : Nat :=
    (allGaps.filter (fun g => g.status = s)).length
  ( countWhere GapStatus.gapOpen
  , countWhere GapStatus.gapPartial
  , countWhere GapStatus.gapBlocked
  , countWhere GapStatus.gapDeadEnd
  , countWhere GapStatus.gapClosed
  , countWhere GapStatus.gapClosedConditional )

/-- InputCategory-keyed counts: `(cat1Mathlib, cat2External, cat3PaperNovel, notInput)`. -/
def inputCategoryCounts : Nat × Nat × Nat × Nat :=
  let countWhere (c : InputCategory) : Nat :=
    (allGaps.filter (fun g => g.inputCategory = c)).length
  ( countWhere InputCategory.cat1Mathlib
  , countWhere InputCategory.cat2External
  , countWhere InputCategory.cat3PaperNovel
  , countWhere InputCategory.notInput )

/-- Cat3SubType-keyed counts:
    `(carrier, hypothesisPredicate, structuralEquation, workingAssumption, conditionalHypothesis, notCat3)`. -/
def cat3SubTypeCounts : Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : Cat3SubType) : Nat :=
    (allGaps.filter (fun g => g.cat3SubType = s)).length
  ( countWhere Cat3SubType.carrier
  , countWhere Cat3SubType.hypothesisPredicate
  , countWhere Cat3SubType.structuralEquation
  , countWhere Cat3SubType.workingAssumption
  , countWhere Cat3SubType.conditionalHypothesis
  , countWhere Cat3SubType.notCat3 )

#eval s!"AccessOrthogonality gap-ledger inventory (status):    open={(gapCounts).1} partial={(gapCounts).2.1} blocked={(gapCounts).2.2.1} deadEnd={(gapCounts).2.2.2.1} closed={(gapCounts).2.2.2.2.1} closedConditional={(gapCounts).2.2.2.2.2}"

#eval s!"AccessOrthogonality gap-ledger inventory (input):     cat1Mathlib={(inputCategoryCounts).1} cat2External={(inputCategoryCounts).2.1} cat3PaperNovel={(inputCategoryCounts).2.2.1} notInput={(inputCategoryCounts).2.2.2}"

#eval s!"AccessOrthogonality gap-ledger inventory (Cat 3 sub): carrier={(cat3SubTypeCounts).1} hypothesisPredicate={(cat3SubTypeCounts).2.1} structuralEquation={(cat3SubTypeCounts).2.2.1} workingAssumption={(cat3SubTypeCounts).2.2.2.1} conditionalHypothesis={(cat3SubTypeCounts).2.2.2.2.1} notCat3={(cat3SubTypeCounts).2.2.2.2.2}"

#eval s!"Total entries: {allGaps.length}"

/-! ### Inventory summary

  The live status / input-category / Cat 3 sub-type counts are
  printed by the `#eval` calls above (run
  `lake env lean AccessOrthogonality/Ledger.lean` to see them).
  Axiom names by category:

    Cat 2 propositional (external published textbook —
    Mas-Colell-Whinston-Green + Acemoglu-Restrepo + Lizzeri +
    Shorrocks + Tirole):
      welfareFactorsThroughAllocation,
      mwg_cost_min_uniqueness_isocline
        (MWG 5.C.2(v); v0.3 §3.4.6 extracted from former
        `bestResponseUniqueAtThetaInvariantWelfare` atomic),
      kappa1_pos, kappa2_pos, sK_nonneg,
      shorrocks_additive_decomposition_atomic,
      lizzeri_1999_separate_certifier_rent
        (Lizzeri 1999 Prop 1; v0.3 §3.4.6 extracted from
        former `lemma_lizzeri_bundled_rent` atomic),
      mBertrand_nonneg, mBertrand_monotone

    Cat 3 carrier axioms (Li 2026 paper-introduced primitives,
    sub-type: carrier):
      kappa1, kappa2, sK, eta_attenuation, mBertrand

    Cat 3 hypothesis predicates (Li 2026 paper-introduced
    scope/regime predicates, sub-type: hypothesisPredicate;
    added v0.3 §3.4.6):
      OnSameIsocline
        (paper §4.3 Case 1/Case 2 case-split discriminator),
      HA7_channels_not_anti_correlated
        (paper Appendix A.2 HA-7 working assumption)

    Cat 3 structural defining equations (Li 2026 paper-stated
    atomic equations on the carriers, sub-type:
    structuralEquation):
      SC1_implements_Malpha, SC3_implements_Mbeta,
      lemma_independence_gap, welfare_gap_at_reference,
      case_1_different_isoclines_implies_BR_invariant
        (paper §4.3 Case 1 contradiction atomic; v0.3 §3.4.6
        extracted from former `bestResponseUniqueAtTheta-
        InvariantWelfare` atomic),
      bundled_extension_via_independence
        (integrated-seller-certifier extension via
        `lem:independence`; v0.3 §3.4.6 extracted from
        former `lemma_lizzeri_bundled_rent` atomic),
      channels_exhaust_under_HA7
        (paper Appendix A.2 channel-exhaustion under HA-7;
        v0.3 §3.4.6 extracted from former
        `gini_two_channel_partition` atomic),
      mBertrand_one_le_bundled
        (saturated-Bertrand-vs-bundled rent bound),
      capital_share_channel_contribution
        (Acemoglu-Restrepo × Korinek-Vipra composition),
      verification_rent_channel_contribution
        (Lizzeri-extension × Bertrand × κ_2 composition),
      lerman_yitzhaki_comonotonicity_translation
        (Lerman-Yitzhaki 1985 × GE_0-bound × first-order
        factor-share linearisation composition),
      long_run_step1_profit_zero,
      long_run_step4_zero_lobbying,
      long_run_step5_mStar_invariance,
      long_run_step5_bmuStar_invariance,
      eta_attenuation_at_zero,
      eta_attenuation_unit_interval

    Derived theorems closing the v0.3 §3.4.6 decompositions
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
  like RH/BSD/Hodge/P≠NP).

  v0.3 §3.4.6 reductionism round (v6 mandatory ≥2-round
  hostile reductionism per Cat 3) outcomes:

    Target 1 — `bestResponseUniqueAtThetaInvariantWelfare`:
      Round 1 Cat 1? CLEAR-NO (no Mathlib welfare/cost-min
        apparatus at this abstraction).
      Round 2 Cat 2? PARTIAL — MWG Prop 5.C.2(v) is the
        textbook fact applied in Case 2; extracted as
        separate Cat 2 atomic (`mwg_cost_min_uniqueness_-
        isocline`).  Case 1 contradiction is paper-novel.
      Decomposition: 1 Cat 3 atomic →
        + Cat 3 hypothesisPredicate (OnSameIsocline)
        + Cat 2 atomic (mwg_cost_min_uniqueness_isocline)
        + Cat 3 structural (case_1_different_isoclines_-
          implies_BR_invariant)
        + derived theorem (bestResponseUniqueAtTheta-
          InvariantWelfare).
      Net effect: Cat 3 +1, Cat 2 +1.

    Target 2 — `lemma_lizzeri_bundled_rent`:
      Round 1 Cat 1? CLEAR-NO (no Mathlib credence-good IO
        apparatus).
      Round 2 Cat 2? PARTIAL — Lizzeri 1999 Prop 1 (separate
        intermediary) is the textbook base; extracted as
        separate Cat 2 atomic.  Bundled extension via
        `lem:independence` is paper-novel (Remark
        `\\label{rem:lizzeri_extension}`).
      Decomposition: 1 Cat 3 atomic →
        + Cat 2 atomic (lizzeri_1999_separate_certifier_rent)
        + Cat 3 structural (bundled_extension_via_independence)
        + derived theorem (lemma_lizzeri_bundled_rent).
      Net effect: Cat 3 +0, Cat 2 +1.

    Target 3 — `gini_two_channel_partition`:
      Round 1 Cat 1? CLEAR-NO (no Mathlib factor-source
        decomposition for GE_0 at this abstraction).
      Round 2 Cat 2? CLEAR-NO — HA-7 is paper-specific
        working assumption; Shorrocks 1982 (Cat 2 atomic)
        gives additive decomposability of GE_0 along ANY
        factor-source partition, but the paper's claim that
        capital-share + verification-rent specifically
        EXHAUST the decomposition under HA-7 is paper-novel.
      Decomposition: 1 Cat 3 atomic →
        + Cat 3 hypothesisPredicate (HA7_channels_not_anti_-
          correlated)
        + Cat 3 structural (channels_exhaust_under_HA7)
        + derived theorem (gini_two_channel_partition).
      Net effect: Cat 3 +1, Cat 2 +0.

  Cat 3 / Cat 2+Cat 3 ratio (v6 §3.4.6 reductionism guard):
  24 Cat 3 / (9 Cat 2 + 24 Cat 3) = 24 / 33 ≈ 72.7% (> 50%
  threshold; improved from v0.2.0's 75.9%).  The threshold
  reductionism round has executed once and reduced the ratio
  by 3.2 percentage points by extracting two external textbook
  facts (MWG Prop 5.C.2(v) cost-min uniqueness on isoclines;
  Lizzeri 1999 Prop 1 separate-certifier rent) as proper Cat 2
  atomic axioms while preserving paper-fidelity by retaining
  the paper-novel Case 1 / integrated-extension / HA-7 +
  channel-exhaustion content as smaller Cat 3 atomics.

  Driver of remaining >50%: the paper's three independent
  theorem clusters (characterization, gini bound, antitipping,
  t4 binding, longrun) each contribute several paper-stated
  atomic structural equations on paper-introduced primitives
  (κ_1, κ_2, s_K, η, m_Bertrand) + paper-introduced regime/
  scope predicates (OnSameIsocline, HA-7).  Every remaining
  Cat 3 entry has been through ≥2 reductionism check rounds
  (Cat 1? Cat 2?) per the `attackHistory` field; the >50%
  over-threshold reflects the paper's genuine novelty over
  standard welfare economics, not reaching-for-axiom-too-fast.

  Remaining decomposition candidates (for future v0.4+ rounds
  if abstraction layer is enriched):

    * Cat 3 `lerman_yitzhaki_comonotonicity_translation`:
      could decompose into Cat 2 atomic for Lerman-Yitzhaki
      1985 Gini decomposition formula + Cat 3 atomic for the
      first-order factor-share linearisation step.  Deferred:
      requires building Lerman-Yitzhaki rank-correlation
      apparatus at our abstraction layer.
    * Cat 3 `capital_share_channel_contribution` /
      `verification_rent_channel_contribution`: each could
      decompose into a Cat 2 base (Acemoglu-Restrepo CES
      envelope + Tirole Bertrand rent) + Cat 3 paper-novel
      compositional step.  Deferred: requires CES production-
      function apparatus.
    * Cat 3 `mBertrand_one_le_bundled`: could decompose into
      Cat 2 Tirole Bertrand-saturation rent + Cat 3 paper-
      novel integrated-vs-saturated comparison.  Deferred:
      requires Tirole Bertrand-with-fixed-cost apparatus.

  Lean kernel (Cat 0; not declared here): propext,
  Classical.choice, Quot.sound.
-/

end AccessOrthogonality.Ledger
