/-
  AccessOrthogonality/Ledger.lean

  Gap ledger.  Every atomic axiom, every Cat 3 carrier, every
  blocked route, and every closed top-level result is
  recorded as a typed `GapEntry` with TWO orthogonal
  classifications:

    * 5-tier status:    gapOpen / gapPartial / gapBlocked /
                        gapDeadEnd / gapClosed
    * 3-input-category: cat1Mathlib / cat2External /
                        cat3PaperNovel / notInput

  Pre-attack discipline.  Scan this ledger before launching
  new attacks.  Re-attempting a `gapBlocked` or `gapDeadEnd`
  route is a context-drift failure mode.

  `attackHistory` is the canonical location for round
  metadata (citation revisions, atomic refactors, prior
  retractions); docstrings and scope fields are kept to
  current-state content only.
-/

import AccessOrthogonality

namespace AccessOrthogonality.Ledger

/-- 5-tier status tag attached to each gap. -/
inductive GapStatus
  | gapOpen
  | gapPartial
  | gapBlocked
  | gapDeadEnd
  | gapClosed
  deriving DecidableEq, Repr

/-- 3-input-category tag attached to each gap.  Orthogonal to
    status. -/
inductive InputCategory
  /-- Mathlib-derivable theorem (no axiom). -/
  | cat1Mathlib
  /-- External published; opaque-carrier-bound axiom +
      citation. -/
  | cat2External
  /-- Paper-novel: carrier or paper-stated atomic defining
      equation. -/
  | cat3PaperNovel
  /-- Not an atomic input: derived theorem (gapClosed) or
      blocked Mathlib-derivation route (gapBlocked). -/
  | notInput
  deriving DecidableEq, Repr

/-- Typed record for a single gap. -/
structure GapEntry where
  /-- Identifier matching the underlying axiom / theorem
      name. -/
  name : String
  /-- 5-tier status (orthogonal to inputCategory). -/
  status : GapStatus
  /-- Input category (orthogonal to status). -/
  inputCategory : InputCategory
  /-- Operative paper / obstacle citation. -/
  paperSource : String
  /-- Per-round attack trace. -/
  attackHistory : List String
  /-- What content the entry carries; what it does NOT claim. -/
  scope : String

/-! ### Cat 3 paper-novel atomic structural equations -/

/-- (Characterization) Welfare factors through allocation. -/
def gap_welfareFactorsThroughAllocation : GapEntry := {
  name := "welfareFactorsThroughAllocation"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  paperSource :=
    "Li 2026, `\\label{thm:characterization}` proof " ++
    "(⇐ direction): \"Consumer surplus, profits, and " ++
    "transfers all depend on the equilibrium allocation but " ++
    "not directly on θ_i (the welfare functional W is " ++
    "θ-blind).\""
  attackHistory := []
  scope :=
    "Existence of `wOfAlloc : Investment → AccessVector → " ++
    "Regime → ℝ` factorising `W^*` through the best-response " ++
    "allocation.  Does NOT assert specific functional form."
}

/-- (Separation) SC1 implements M_α. -/
def gap_SC1_implements_Malpha : GapEntry := {
  name := "SC1_implements_Malpha"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
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

/-! ### Cat 3 paper-novel typed primitives (carriers) -/

/-- κ_1(η) — capital-share coefficient. -/
def gap_kappa1_carrier : GapEntry := {
  name := "kappa1"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
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
  paperSource :=
    "Li 2026, `\\label{thm:antitipping}` Appendix A.3 Step 3: " ++
    "\"η_max = 1 - c_R / (K_max · m_{bundled,ν}); η → 1 as " ++
    "K(ν) grows.\""
  attackHistory := []
  scope :=
    "Atomic boundedness `0 ≤ η(ν) ≤ 1` for the Bertrand-" ++
    "attenuation function."
}

/-! ### Cat 2 atomic external textbook axioms -/

/-- (Characterization) Cobb-Douglas isocline cost-min uniqueness. -/
def gap_bestResponseUniqueAtThetaInvariantWelfare : GapEntry := {
  name := "bestResponseUniqueAtThetaInvariantWelfare"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  paperSource :=
    "Mas-Colell, Whinston, Green, *Microeconomic Theory*, " ++
    "Oxford University Press 1995, Proposition 5.C.2 " ++
    "(unique cost-minimising input bundle on convex isoquant " ++
    "at strictly positive input prices)."
  attackHistory := []
  scope :=
    "Necessity direction of Theorem~\\ref{thm:characterization}: " ++
    "if welfare is θ-invariant, then the best-response is " ++
    "θ-invariant.  Cobb-Douglas-isocline cost-min-uniqueness " ++
    "step from paper §4.3 Case 2."
}

/-- (Gini) κ_1 positivity for η < 1. -/
def gap_kappa1_pos : GapEntry := {
  name := "kappa1_pos"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
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
  inputCategory := InputCategory.cat2External
  paperSource :=
    "Acemoglu and Restrepo, *American Economic Review* " ++
    "108(6), 2018, Section IV (factor-share dynamics under " ++
    "CES); composed with Korinek-Vipra (2025) returns-to-" ++
    "scale apparatus."
  attackHistory := []
  scope :=
    "Existence of capital-channel contribution capContrib ≤ " ++
    "κ_1(0) · s_K(0) · (1 - μ_product).  η = 0 parameter " ++
    "slot for baseline elasticity."
}

/-- (Gini) Verification-rent channel contribution. -/
def gap_verification_rent_channel_contribution : GapEntry := {
  name := "verification_rent_channel_contribution"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  paperSource :=
    "Lizzeri (1999) Proposition 1 (per-output rent " ++
    "extraction characterization); composed with " ++
    "Lemma~\\ref{lem:bertrand} Bertrand saturation."
  attackHistory := []
  scope :=
    "Existence of verification-channel contribution " ++
    "verifContrib ≤ κ_2 · (1 - ν)."
}

/-- (Gini) Shorrocks 1982 additive decomposition. -/
def gap_shorrocks_additive_decomposition : GapEntry := {
  name := "shorrocks_additive_decomposition"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  paperSource :=
    "Shorrocks, A. F., \"Inequality Decomposition by " ++
    "Factor Components,\" *Econometrica* 50(1), 1982, " ++
    "pp. 193–211 (canonical factor-source decomposition " ++
    "theorem for inequality indices)."
  attackHistory := []
  scope :=
    "Atomic additive decomposition: GE_0(θ,a,R) - " ++
    "GE_0(θ,baseline,R) ≤ capContrib + verifContrib under " ++
    "the channel-non-anti-correlation working assumption " ++
    "(paper HA-7)."
}

/-- (Gini) Lerman-Yitzhaki comonotonicity translation. -/
def gap_lerman_yitzhaki_comonotonicity_translation : GapEntry := {
  name := "lerman_yitzhaki_comonotonicity_translation"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  paperSource :=
    "Lerman, Robert I., and Shlomo Yitzhaki, \"Income " ++
    "Inequality Effects by Income Source: A New Approach " ++
    "and Applications to the United States,\" *Review of " ++
    "Economics and Statistics* 67(1), 1985, pp. 151–156 " ++
    "(exact decomposition G = Σ s_k G_k R_k with R_k = " ++
    "Gini rank-correlation; comonotonicity = all R_k = 1)."
  attackHistory := []
  scope :=
    "Under comonotonicity, the Gini bound takes the same " ++
    "form as the GE_0 bound to first order in factor shares. " ++
    "Single-theorem atomic citation."
}

/-- (Binding) Lemma~\ref{lem:lizzeri} — bundled rent existence. -/
def gap_lemma_lizzeri_bundled_rent : GapEntry := {
  name := "lemma_lizzeri_bundled_rent"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  paperSource :=
    "Li 2026, `\\label{lem:lizzeri}` + Remark " ++
    "`\\label{rem:lizzeri_extension}`: integrated " ++
    "seller-certifier rent, extension of Lizzeri (1999) " ++
    "*RAND J. Econ.* 30(2):214–231 (which treats an " ++
    "INDEPENDENT monopoly certifier facing a SEPARATE " ++
    "seller) to the bundled-seller-certifier configuration " ++
    "via Lemma~\\ref{lem:independence}."
  attackHistory := [
    "v0.2 (audit R2): re-categorised Cat 2 → Cat 3 after " ++
      "verifying Lizzeri 1999 abstract treats SEPARATE " ++
      "intermediary, not integrated seller-certifier. " ++
      "The integrated-case rent claim is paper-novel " ++
      "(Remark `\\label{rem:lizzeri_extension}` confirms " ++
      "this explicitly)."
  ]
  scope := "∃ m_bundled : ℝ, 0 < m_bundled (integrated seller-certifier configuration)."
}

/-- (Binding) Lemma~\ref{lem:bertrand} — `mBertrand` carrier. -/
def gap_mBertrand_carrier : GapEntry := {
  name := "mBertrand"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
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
  -- Cat 3 paper-novel atomic structural equations
  gap_welfareFactorsThroughAllocation,
  gap_SC1_implements_Malpha,
  gap_SC3_implements_Mbeta,
  gap_lemma_independence_gap,
  gap_welfare_gap_at_reference,
  gap_long_run_step1_profit_zero,
  gap_long_run_step4_zero_lobbying,
  gap_long_run_step5_mStar_invariance,
  gap_long_run_step5_bmuStar_invariance,
  -- Cat 3 paper-novel typed primitives (carriers)
  gap_kappa1_carrier,
  gap_kappa2_carrier,
  gap_sK_carrier,
  gap_eta_attenuation_carrier,
  gap_eta_attenuation_at_zero,
  gap_eta_attenuation_unit_interval,
  -- Cat 2 atomic external textbook axioms
  gap_bestResponseUniqueAtThetaInvariantWelfare,
  gap_kappa1_pos,
  gap_kappa2_pos,
  gap_sK_nonneg,
  gap_capital_share_channel_contribution,
  gap_verification_rent_channel_contribution,
  gap_shorrocks_additive_decomposition,
  gap_lerman_yitzhaki_comonotonicity_translation,
  gap_lemma_lizzeri_bundled_rent,
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

/-- Status-keyed counts: `(open, partial, blocked, deadEnd, closed)`. -/
def gapCounts : Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : GapStatus) : Nat :=
    (allGaps.filter (fun g => g.status = s)).length
  ( countWhere GapStatus.gapOpen
  , countWhere GapStatus.gapPartial
  , countWhere GapStatus.gapBlocked
  , countWhere GapStatus.gapDeadEnd
  , countWhere GapStatus.gapClosed )

/-- InputCategory-keyed counts: `(cat1Mathlib, cat2External, cat3PaperNovel, notInput)`. -/
def inputCategoryCounts : Nat × Nat × Nat × Nat :=
  let countWhere (c : InputCategory) : Nat :=
    (allGaps.filter (fun g => g.inputCategory = c)).length
  ( countWhere InputCategory.cat1Mathlib
  , countWhere InputCategory.cat2External
  , countWhere InputCategory.cat3PaperNovel
  , countWhere InputCategory.notInput )

#eval s!"AccessOrthogonality gap-ledger inventory (status):  open={(gapCounts).1} partial={(gapCounts).2.1} blocked={(gapCounts).2.2.1} deadEnd={(gapCounts).2.2.2.1} closed={(gapCounts).2.2.2.2}"

#eval s!"AccessOrthogonality gap-ledger inventory (input):   cat1Mathlib={(inputCategoryCounts).1} cat2External={(inputCategoryCounts).2.1} cat3PaperNovel={(inputCategoryCounts).2.2.1} notInput={(inputCategoryCounts).2.2.2}"

#eval s!"Total entries: {allGaps.length}"

/-! ### Inventory summary

  The live status counts and input-category counts are
  printed by the `#eval` calls above (run
  `lake env lean AccessOrthogonality/Ledger.lean` to see
  them).  The axiom names by category:

    Cat 2 propositional (external published textbook):
      bestResponseUniqueAtThetaInvariantWelfare,
      kappa1_pos, kappa2_pos, sK_nonneg,
      capital_share_channel_contribution,
      verification_rent_channel_contribution,
      shorrocks_additive_decomposition,
      lerman_yitzhaki_comonotonicity_translation,
      lemma_lizzeri_bundled_rent,
      mBertrand_nonneg, mBertrand_monotone,
      mBertrand_one_le_bundled

    Cat 3 carrier axioms (Li 2026):
      kappa1, kappa2, sK, eta_attenuation, mBertrand

    Cat 3 propositional structural equations (paper-stated):
      welfareFactorsThroughAllocation,
      SC1_implements_Malpha, SC3_implements_Mbeta,
      lemma_independence_gap, welfare_gap_at_reference,
      long_run_step1_profit_zero,
      long_run_step4_zero_lobbying,
      long_run_step5_mStar_invariance,
      long_run_step5_bmuStar_invariance,
      eta_attenuation_at_zero,
      eta_attenuation_unit_interval

  Lean kernel (not declared here): propext, Classical.choice,
  Quot.sound.
-/

end AccessOrthogonality.Ledger
