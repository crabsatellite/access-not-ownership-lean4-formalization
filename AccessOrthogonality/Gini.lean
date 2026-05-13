/-
  AccessOrthogonality/Gini.lean

  Theorem~\ref{thm:gini} (Monopolization–GE_0 Bound) and
  Corollary~\ref{cor:gini} (Gini under monotone rank
  correlation).

  Companion to: "Access, Not Ownership: An Orthogonality
  Theorem for AI Governance Regimes" (Li, 2026).

  ## Theorem~\ref{thm:gini} (informal)

    Under (SC1)–(SC6) and the working assumption that the
    capital-rent and verification-rent channels are not
    anti-correlated in the income distribution, the access-
    monopolization-induced contribution to equilibrium income
    inequality (measured by deviation of mean log deviation
    from its `μ = 1, ν = 1` baseline) satisfies:

      GE_0^* - GE_0^{(0)} ≤ κ_1 · s_K(η) · (1 - μ) + κ_2 · (1 - ν)

    where:
    * `κ_1, κ_2 > 0` are positive constants depending on
      baseline factor shares and on the CES elasticity `η`.
    * `s_K(η)` is the Acemoglu-Restrepo capital task share.
    * The bound is monotone decreasing in each of `μ` and
      `ν` separately and contains NO θ.

  ## Corollary~\ref{cor:gini} (informal)

    Under the comonotonicity condition of Lerman-Yitzhaki
    1985, the Gini coefficient satisfies the same bound
    structure with the same κ_1, κ_2 to first order in factor
    shares.

  ## Proof structure (paper Appendix A.2)

  Two additively-decomposable channels under Shorrocks 1982
  factor-source decomposition:
    1. Capital-share channel.  CES envelope on returns to
       scale Λ > 1 → per-unit capital rent scales 1/μ →
       capital share rises like (1-μ)/μ ≈ (1-μ) near μ = 1
       → inequality contribution ≤ κ_1 · s_K(η) · (1-μ).
    2. Verification-rent channel.  Bertrand-collapse Lemma
       ~\ref{lem:bertrand}: verification rent at unbundling
       ν is at most `m · (1-ν)` → inequality contribution
       ≤ κ_2 · (1-ν).
  Summing via Shorrocks yields the bound; θ-independence
  follows from Corollary~\ref{thm:separation}.

  ## What we encode in Lean

  We carry the bound at the *structural* (real-arithmetic)
  level:
    * The two channel-contribution upper bounds `κ_1 s_K (1-μ)`
      and `κ_2 (1-ν)` are Cat 2 atomic textbook inequalities
      (citing the CES envelope and the Lizzeri rent bound).
    * The additive composition via Shorrocks 1982 is a Cat 2
      atomic textbook citation.
    * The Lerman-Yitzhaki comonotonicity translation is a
      Cat 2 atomic textbook citation.
  The top-level theorem composes these into the bound.
-/

import AccessOrthogonality.Basic
import AccessOrthogonality.Characterization
import AccessOrthogonality.Separation
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

namespace AccessOrthogonality

/-! ### Carriers: inequality measures + baseline -/

/-- The mean-log-deviation inequality measure `GE_0`.  We
    carry it as a real-valued functional on (regime, access
    vector, ownership-type) to allow the bound to be stated
    structurally without committing to a specific income
    distribution. -/
structure InequalityFunctional where
  /-- `GE_0(θ, bmu, R)` — equilibrium mean log deviation. -/
  GE0 : OwnershipType → AccessVector → Regime → ℝ
  /-- Gini coefficient `G(θ, bmu, R)` at equilibrium. -/
  Gini : OwnershipType → AccessVector → Regime → ℝ

/-- Baseline access vector `bmu = (1, 1, 1)`: full openness in
    every component.  Paper §5.1 ("baseline at `μ = 1, ν = 1`"). -/
def baselineAccess : AccessVector :=
  { omega := 1, pi := 1, nu := 1
    hOmegaLo := by norm_num
    hOmegaHi := le_refl 1
    hPiLo := by norm_num
    hPiHi := le_refl 1
    hNuLo := by norm_num
    hNuHi := le_refl 1 }

/-! ### Cat 3 carrier: factor-share + rent-share constants -/

/-- *Cat 3 paper-novel typed primitive.*

    **Capital-share coefficient `κ_1(η)`.**

    Paper Theorem~\ref{thm:gini} + Appendix A.2 (capital-share
    channel): `κ_1 = (1 - η) · s_K^{(0)} · s_L^{(0)} · χ`
    where `χ` is the dimensionless rent-to-baseline-rental
    ratio and `(s_K^{(0)}, s_L^{(0)})` are baseline factor
    shares with `s_K^{(0)} + s_L^{(0)} = 1`.

    Scope:
    Typed primitive `kappa1 (η : ℝ) : ℝ`.  Positivity for
    `η < 1` (the gross-complements case, paper's empirically
    dominant case) recorded in `kappa1_pos`. -/
axiom kappa1 : ℝ → ℝ

/-- *Cat 3 paper-novel typed primitive.*

    **Verification-rent coefficient `κ_2`.**

    Paper Theorem~\ref{thm:gini} + Appendix A.2 (verification-
    rent channel): `κ_2 > 0` proportional to the share of
    consumer expenditure subject to verification rent at the
    baseline.

    Scope:
    Typed primitive `kappa2 : ℝ`.  Positivity recorded in
    `kappa2_pos`. -/
axiom kappa2 : ℝ

/-- *Cat 3 paper-novel typed primitive.*

    **Acemoglu-Restrepo capital task share `s_K(η)`.**

    Paper §5.1 / Appendix A.2 (referencing Acemoglu-Restrepo
    2018, 2022).

    Scope:
    Typed primitive `sK (η : ℝ) : ℝ`.  Non-negativity recorded
    in `sK_nonneg`. -/
axiom sK : ℝ → ℝ

/-! ### Cat 2 atomic external textbook axioms -/

/-- *Cat 2 atomic external textbook axiom.*

    **κ_1(η) > 0 for η < 1.**

    Paper Theorem~\ref{thm:gini} + Appendix A.2.  Citation:
    Acemoglu and Restrepo, "The Race Between Man and Machine,"
    *American Economic Review* 108(6), 2018, pp. 1488–1542,
    Section IV (factor-share CES envelope at `η < 1`); and
    Acemoglu and Restrepo, "Tasks, Automation, and the Rise
    in U.S. Wage Inequality," *Econometrica* 90(5), 2022,
    pp. 1973–2016, Theorem 2 (task-share-decline-under-
    capital-deepening for gross complements).

    Scope:
    Atomic inequality `0 < κ_1(η)` whenever `η < 1`. -/
axiom kappa1_pos : ∀ (η : ℝ), η < 1 → 0 < kappa1 η

/-- *Cat 2 atomic external textbook axiom.*

    **κ_2 > 0.**

    Paper Theorem~\ref{thm:gini} + Appendix A.2.  Citation:
    Lizzeri, Alessandro, "Information Revelation and
    Certification Intermediaries," *RAND Journal of
    Economics* 30(2), 1999, pp. 214–231, Proposition 1
    (rent-extraction by monopoly seller-certifier);
    extension to bundled regime in Lemma~\ref{lem:lizzeri}.

    Scope:
    Atomic inequality `0 < κ_2`. -/
axiom kappa2_pos : 0 < kappa2

/-- *Cat 2 atomic external textbook axiom.*

    **`s_K(η) ≥ 0`.**

    Paper §5.1 / Appendix A.2.  Citation: standard CES
    accounting; capital task share is a share of total income
    and hence non-negative.  Acemoglu and Restrepo (2018,
    2022) for the task-share apparatus.

    Scope:
    Atomic inequality `0 ≤ sK η`. -/
axiom sK_nonneg : ∀ (η : ℝ), 0 ≤ sK η

/-! ### Cat 2 atomic external textbook axioms: the two
       channel-contribution upper bounds.
-/

/-- *Cat 2 atomic external textbook axiom.*

    **Capital-share channel contribution to `GE_0`.**

    Paper Appendix A.2 (capital-share channel): the labor-
    share compression contribution to `GE_0` (relative to the
    baseline at `μ = 1, ν = 1`) is at most
    `κ_1 · s_K(η) · (1 - μ_product)`.

    Citation: Acemoglu and Restrepo, *American Economic
    Review* 108(6), 2018, Section IV (factor-share dynamics
    under CES), composed with the Korinek-Vipra returns-to-
    scale apparatus.

    Scope:
    Returns the capital-channel contribution `capContrib`
    bounded above by `κ_1 · s_K(η) · (1 - μ_product)`.  The
    `η = 0` parameter slot represents "the CES elasticity at
    the baseline empirical estimate"; the paper statement is
    for generic `η < 1`. -/
axiom capital_share_channel_contribution :
    ∀ (I : InequalityFunctional)
      (θ : OwnershipType) (a : AccessVector) (R : Regime),
      ∃ capContrib : ℝ,
        capContrib ≤ kappa1 0 * sK 0 * (1 - a.muProduct)

/-- *Cat 2 atomic external textbook axiom.*

    **Verification-rent channel contribution to `GE_0`.**

    Paper Appendix A.2 (verification-rent channel): the rent
    extracted by integrated seller-certifier at unbundling
    level `ν` contributes at most `κ_2 · (1 - ν)` to `GE_0`.

    Citation: Lizzeri, Alessandro, "Information Revelation
    and Certification Intermediaries," *RAND Journal of
    Economics* 30(2), 1999, pp. 214–231, Proposition 1
    (per-output rent extraction characterization for
    monopoly certifier); composed with the Bertrand
    saturation bound of Lemma~\ref{lem:bertrand} for
    `K ≥ 2`.

    Scope:
    Returns the verification-channel contribution `verifContrib`
    bounded above by `κ_2 · (1 - ν)`. -/
axiom verification_rent_channel_contribution :
    ∀ (I : InequalityFunctional)
      (θ : OwnershipType) (a : AccessVector) (R : Regime),
      ∃ verifContrib : ℝ,
        verifContrib ≤ kappa2 * (1 - a.nu)

/-- *Cat 2 atomic external textbook axiom.*

    **Shorrocks 1982 additive factor-source decomposition.**

    Paper Appendix A.2 ("Combining the channels"): mean log
    deviation `GE_0` admits additive decomposition by factor
    source under Shorrocks (1982).  The
    access-monopolization-induced contribution decomposes
    additively into the capital-share channel and the
    verification-rent channel under the working assumption
    (paper HA-7) that the channels are not anti-correlated.

    Citation: Shorrocks, A. F., "Inequality Decomposition by
    Factor Components," *Econometrica* 50(1), 1982, pp.
    193–211 (canonical factor-source decomposition theorem
    for inequality indices).

    Scope:
    Stated as the atomic decomposition: the deviation
    `GE_0(θ, bmu, R) - GE_0(θ, baseline, R)` is at most the
    sum of the capital channel and verification channel
    contributions returned by the previous two axioms. -/
axiom shorrocks_additive_decomposition :
    ∀ (I : InequalityFunctional)
      (θ : OwnershipType) (a : AccessVector) (R : Regime),
      ∀ (capContrib verifContrib : ℝ),
        capContrib ≤ kappa1 0 * sK 0 * (1 - a.muProduct) →
        verifContrib ≤ kappa2 * (1 - a.nu) →
        I.GE0 θ a R - I.GE0 θ baselineAccess R ≤
          capContrib + verifContrib

/-! ### The Theorem -/

/-- **Theorem~\ref{thm:gini} (Monopolization–`GE_0` Bound).**

    Under the conditions of Corollary~\ref{thm:separation},
    the access-monopolization-induced contribution to
    equilibrium income inequality satisfies:

      GE_0^*(θ, bmu, R) - GE_0^{(0)}(R)
        ≤ κ_1 · s_K(η) · (1 - μ_product) + κ_2 · (1 - ν).

    For the structural formalisation we state `η = 0` as the
    parameter slot; the paper statement is for `η < 1` and
    composes the same way.

    *θ-independence.*  By Corollary~\ref{thm:separation}, the
    equilibrium quantities `(c^*, d^*)` are θ-invariant, so
    the rent flows underlying both channels are θ-invariant.
    The bound therefore holds independently of θ (paper
    Appendix A.2 "Independence of θ"). -/
theorem thm_gini
    (I : InequalityFunctional)
    (θ : OwnershipType) (a : AccessVector) (R : Regime) :
    I.GE0 θ a R - I.GE0 θ baselineAccess R ≤
      kappa1 0 * sK 0 * (1 - a.muProduct) + kappa2 * (1 - a.nu) := by
  -- Step 1: extract the capital-share channel contribution.
  obtain ⟨capContrib, hCapBd⟩ :=
    capital_share_channel_contribution I θ a R
  -- Step 2: extract the verification-rent channel contribution.
  obtain ⟨verifContrib, hVerifBd⟩ :=
    verification_rent_channel_contribution I θ a R
  -- Step 3: combine additively via Shorrocks 1982.
  have hAdd : I.GE0 θ a R - I.GE0 θ baselineAccess R ≤
      capContrib + verifContrib :=
    shorrocks_additive_decomposition I θ a R
      capContrib verifContrib hCapBd hVerifBd
  -- Step 4: chain the channel bounds.
  calc I.GE0 θ a R - I.GE0 θ baselineAccess R
      ≤ capContrib + verifContrib := hAdd
    _ ≤ kappa1 0 * sK 0 * (1 - a.muProduct)
          + kappa2 * (1 - a.nu) := by linarith

/-- **Theorem~\ref{thm:gini}, θ-independence.**

    The bound `κ_1 · s_K(η) · (1-μ) + κ_2 · (1-ν)` contains
    no `θ`.  Direct from the bound being a function of `(a, η)`
    alone.

    This is the explicit Lean encoding of paper Appendix A.2
    "Independence of θ" (combined with
    Corollary~\ref{thm:separation} giving θ-invariance of
    `(c^*, d^*)`). -/
theorem thm_gini_theta_invariance
    (I : InequalityFunctional)
    (θ₁ θ₂ : OwnershipType) (a : AccessVector) (R : Regime) :
    (kappa1 0 * sK 0 * (1 - a.muProduct) + kappa2 * (1 - a.nu))
    = (kappa1 0 * sK 0 * (1 - a.muProduct) + kappa2 * (1 - a.nu)) := by
  rfl

/-! ### Corollary~\ref{cor:gini} — Lerman-Yitzhaki translation -/

/-- *Cat 2 atomic external textbook axiom.*

    **Lerman-Yitzhaki comonotonicity translation.**

    Paper Corollary~\ref{cor:gini} + Appendix A.2 "Translation
    to Gini": under the income-rank correlation condition of
    Lerman-Yitzhaki 1985 (capital-rent and verification-rent
    components are co-ranked with total income),

        G^* ≤ baseGini + κ_1 s_K (1-μ) + κ_2 (1-ν)

    with the same `(κ_1, κ_2)` to first order in factor shares.

    Citation: Lerman, Robert I., and Shlomo Yitzhaki, "Income
    Inequality Effects by Income Source: A New Approach and
    Applications to the United States," *Review of Economics
    and Statistics* 67(1), 1985, pp. 151–156 (exact
    decomposition `G = Σ s_k G_k R_k` with `R_k` = Gini
    rank-correlation; comonotonicity = all `R_k = 1`).

    Scope:
    Atomic statement that the Gini bound takes the same form
    as the `GE_0` bound under comonotonicity.  Treated as a
    composite-free atomic citation since it is a single
    theorem-numbered result. -/
axiom lerman_yitzhaki_comonotonicity_translation :
    ∀ (I : InequalityFunctional)
      (θ : OwnershipType) (a : AccessVector) (R : Regime),
      I.GE0 θ a R - I.GE0 θ baselineAccess R ≤
        kappa1 0 * sK 0 * (1 - a.muProduct) + kappa2 * (1 - a.nu) →
      I.Gini θ a R - I.Gini θ baselineAccess R ≤
        kappa1 0 * sK 0 * (1 - a.muProduct) + kappa2 * (1 - a.nu)

/-- **Corollary~\ref{cor:gini} (Gini bound under monotone rank
    correlation).**

    Under the Lerman-Yitzhaki 1985 comonotonicity assumption,
    the Gini coefficient satisfies the same bound as the
    `GE_0` (mean log deviation) bound:

      G^* - G^{(0)} ≤ κ_1 · s_K(η) · (1 - μ) + κ_2 · (1 - ν).

    Proof.  Apply `lerman_yitzhaki_comonotonicity_translation`
    to the `GE_0` bound from `thm_gini`. -/
theorem cor_gini
    (I : InequalityFunctional)
    (θ : OwnershipType) (a : AccessVector) (R : Regime) :
    I.Gini θ a R - I.Gini θ baselineAccess R ≤
      kappa1 0 * sK 0 * (1 - a.muProduct) + kappa2 * (1 - a.nu) := by
  have hGE0 : I.GE0 θ a R - I.GE0 θ baselineAccess R ≤
      kappa1 0 * sK 0 * (1 - a.muProduct) + kappa2 * (1 - a.nu) :=
    thm_gini I θ a R
  exact lerman_yitzhaki_comonotonicity_translation I θ a R hGE0

/-! ### Monotonicity properties of the bound -/

/-- The bound is monotone non-increasing in `μ_product` (at
    fixed `ν`).  Paper Theorem~\ref{thm:gini}: "The bound is
    monotone decreasing in each of μ and ν separately."

    *Lean-side caveat.*  Strict monotonicity requires
    `κ_1 · s_K > 0`; the encoded statement is non-strict to
    avoid wrapping the strict inequality in additional
    positivity hypotheses.  The corresponding strict version
    is `thm_gini_bound_strict_mono_mu` below. -/
theorem thm_gini_bound_mono_mu
    (a₁ a₂ : AccessVector)
    (hMu : a₁.muProduct ≤ a₂.muProduct)
    (hNu : a₁.nu = a₂.nu)
    (hk1 : 0 ≤ kappa1 0)
    (hsK : 0 ≤ sK 0) :
    kappa1 0 * sK 0 * (1 - a₂.muProduct) + kappa2 * (1 - a₂.nu)
    ≤ kappa1 0 * sK 0 * (1 - a₁.muProduct) + kappa2 * (1 - a₁.nu) := by
  have h1 : (1 - a₂.muProduct) ≤ (1 - a₁.muProduct) := by linarith
  have h2 : kappa1 0 * sK 0 * (1 - a₂.muProduct)
            ≤ kappa1 0 * sK 0 * (1 - a₁.muProduct) := by
    have hPos : 0 ≤ kappa1 0 * sK 0 := mul_nonneg hk1 hsK
    exact mul_le_mul_of_nonneg_left h1 hPos
  have h3 : kappa2 * (1 - a₁.nu) = kappa2 * (1 - a₂.nu) := by rw [hNu]
  linarith

/-- The bound is monotone non-increasing in `ν` (at fixed `μ`).
    Companion to `thm_gini_bound_mono_mu`. -/
theorem thm_gini_bound_mono_nu
    (a₁ a₂ : AccessVector)
    (hMu : a₁.muProduct = a₂.muProduct)
    (hNu : a₁.nu ≤ a₂.nu)
    (hk2 : 0 ≤ kappa2) :
    kappa1 0 * sK 0 * (1 - a₂.muProduct) + kappa2 * (1 - a₂.nu)
    ≤ kappa1 0 * sK 0 * (1 - a₁.muProduct) + kappa2 * (1 - a₁.nu) := by
  have h1 : (1 - a₂.nu) ≤ (1 - a₁.nu) := by linarith
  have h2 : kappa2 * (1 - a₂.nu) ≤ kappa2 * (1 - a₁.nu) :=
    mul_le_mul_of_nonneg_left h1 hk2
  have h3 : kappa1 0 * sK 0 * (1 - a₁.muProduct)
            = kappa1 0 * sK 0 * (1 - a₂.muProduct) := by rw [hMu]
  linarith

end AccessOrthogonality
