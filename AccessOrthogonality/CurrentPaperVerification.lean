/- Exact pointwise verification-binding algebra for the revised paper. -/

import AccessOrthogonality.CurrentPaperBasic
import Mathlib.Data.Set.Basic
import Mathlib.Tactic

namespace AccessOrthogonality.CurrentPaper

/-! ## Credence-good and reputation assumptions -/

structure CredenceGoodAssumption where
  Output : Type
  outputQuality : Output → ℝ
  verificationSignal : Output → ℝ
  verificationCost : ℝ
  hCostNonnegative : 0 ≤ verificationCost
  signalAcceptedAsCredible : Prop
  residualEntropy : ℝ → ℝ → ℝ
  residualPositive :
    ∀ omega pi : ℝ,
      0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
        0 < residualEntropy omega pi

/-- One integer-valued count object is consumed by reputation, Bertrand, the
    operative threshold, and the full-unbundling boundary. -/
structure EvaluatorCountRule where
  Kmax : Nat
  count : ℝ → Nat
  hKmaxAtLeastTwo : 2 ≤ Kmax
  hMonotone : Monotone count
  hAtZero : count 0 ≤ 1
  hAtOne : count 1 = Kmax

structure ReputationAggregationAssumption where
  reputationCost : ℝ
  hReputationCostPositive : 0 < reputationCost
  countRule : EvaluatorCountRule

/-! ## Residual information gap -/

def consumerInformation {Information : Type}
    (production base : Set Information) : Set Information :=
  production ∪ base

/-- The paper states persistence inside Assumption 12.  Production access may
    reduce entropy; only strict positivity on the frozen residual subset is
    assumed. -/
theorem lem_independence (credence : CredenceGoodAssumption)
    (omega pi : ℝ)
    (hOmegaLo : 0 ≤ omega) (hOmegaHi : omega ≤ 1)
    (hPiLo : 0 ≤ pi) (hPiHi : pi ≤ 1) :
    0 < credence.residualEntropy omega pi :=
  credence.residualPositive omega pi hOmegaLo hOmegaHi hPiLo hPiHi

theorem residual_gap_at_full_production_access
    (credence : CredenceGoodAssumption) :
    0 < credence.residualEntropy 1 1 := by
  exact lem_independence credence 1 1
    (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-! ## Bundled rent -/

structure BundledCertificationAssumption where
  bundledMarkup : ℝ → ℝ → ℝ
  hMarkupPositive :
    ∀ omega pi,
      0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
        0 < bundledMarkup omega pi

theorem lem_lizzeri
    (B : BundledCertificationAssumption)
    (omega pi : ℝ)
    (hOmegaLo : 0 ≤ omega) (hOmegaHi : omega ≤ 1)
    (hPiLo : 0 ≤ pi) (hPiHi : pi ≤ 1) :
    0 < B.bundledMarkup omega pi :=
  B.hMarkupPositive omega pi hOmegaLo hOmegaHi hPiLo hPiHi

/-! ## Independent-certifier competition -/

def evaluatorCountReal (R : ReputationAggregationAssumption) (nu : ℝ) : ℝ :=
  (R.countRule.count nu : ℝ)

def OperativeUnbundling
    (R : ReputationAggregationAssumption) (nu : ℝ) : Prop :=
  2 ≤ R.countRule.count nu

theorem reputation_aggregation_paper_claim
    (R : ReputationAggregationAssumption) :
    0 < R.reputationCost ∧
      2 ≤ R.countRule.Kmax ∧
      Monotone R.countRule.count ∧
      R.countRule.count 0 ≤ 1 ∧
      R.countRule.count 1 = R.countRule.Kmax ∧
      (∀ nu, OperativeUnbundling R nu ↔ 2 ≤ R.countRule.count nu) := by
  exact ⟨R.hReputationCostPositive,
    R.countRule.hKmaxAtLeastTwo,
    R.countRule.hMonotone,
    R.countRule.hAtZero,
    R.countRule.hAtOne,
    fun _ => Iff.rfl⟩

/-- A symmetric homogeneous-price equilibrium is represented by its observed
    common fee together with the two deviation inequalities used in the paper.
    Reputation maintenance is a per-certification marginal resource cost, not
    a fixed cost divided by the number of firms. -/
structure CertifierCompetitionAssumption where
  cV : ℝ
  hVariableCostNonnegative : 0 ≤ cV
  marketFee : ℝ → ℝ
  hNoLoss :
    ∀ (R : ReputationAggregationAssumption) (nu : ℝ),
      OperativeUnbundling R nu →
        cV + R.reputationCost ≤ marketFee nu
  hNoProfitableUndercut :
    ∀ (R : ReputationAggregationAssumption) (nu pPrime : ℝ),
      OperativeUnbundling R nu →
      cV + R.reputationCost ≤ pPrime →
      pPrime < marketFee nu →
        pPrime - (cV + R.reputationCost) ≤
          (marketFee nu - (cV + R.reputationCost)) /
            evaluatorCountReal R nu

noncomputable def certificationFee
    (C : CertifierCompetitionAssumption) (nu : ℝ) : ℝ :=
  C.marketFee nu

noncomputable def independentResidualPayment
    (C : CertifierCompetitionAssumption) (nu : ℝ) : ℝ :=
  certificationFee C nu - C.cV

theorem operative_count_positive
    (R : ReputationAggregationAssumption) (nu : ℝ)
    (hOperative : OperativeUnbundling R nu) :
    0 < evaluatorCountReal R nu := by
  unfold OperativeUnbundling evaluatorCountReal at *
  exact_mod_cast (lt_of_lt_of_le (by norm_num : 0 < (2 : Nat)) hOperative)

theorem bertrand_fee_eq_marginal_cost
    (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption) (nu : ℝ)
    (hOperative : OperativeUnbundling R nu) :
    certificationFee C nu = C.cV + R.reputationCost := by
  have hLower : C.cV + R.reputationCost ≤ certificationFee C nu := by
    exact C.hNoLoss R nu hOperative
  apply le_antisymm ?_ hLower
  by_contra hNot
  have hFeeGt : C.cV + R.reputationCost < certificationFee C nu :=
    lt_of_not_ge hNot
  have hGap : 0 < certificationFee C nu - (C.cV + R.reputationCost) := by
    exact sub_pos.mpr hFeeGt
  let pPrime : ℝ :=
    C.cV + R.reputationCost +
      (3 / 4 : ℝ) * (certificationFee C nu - (C.cV + R.reputationCost))
  have hPrimeLower : C.cV + R.reputationCost ≤ pPrime := by
    dsimp [pPrime]
    nlinarith
  have hPrimeUpper : pPrime < certificationFee C nu := by
    dsimp [pPrime]
    linarith
  have hDeviation :=
    C.hNoProfitableUndercut R nu pPrime hOperative hPrimeLower hPrimeUpper
  have hCountTwo : (2 : ℝ) ≤ evaluatorCountReal R nu := by
    unfold evaluatorCountReal
    unfold OperativeUnbundling at hOperative
    exact_mod_cast hOperative
  have hShareBound :
      (certificationFee C nu - (C.cV + R.reputationCost)) /
          evaluatorCountReal R nu ≤
        (certificationFee C nu - (C.cV + R.reputationCost)) / 2 := by
    exact div_le_div_of_nonneg_left (le_of_lt hGap) (by norm_num) hCountTwo
  change pPrime - (C.cV + R.reputationCost) ≤
      (certificationFee C nu - (C.cV + R.reputationCost)) /
        evaluatorCountReal R nu at hDeviation
  dsimp [pPrime] at hDeviation
  nlinarith

theorem lem_bertrand
    (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption) (nu : ℝ)
    (hOperative : OperativeUnbundling R nu) :
    certificationFee C nu = C.cV + R.reputationCost ∧
      independentResidualPayment C nu = R.reputationCost ∧
      0 < independentResidualPayment C nu := by
  have hFee := bertrand_fee_eq_marginal_cost R C nu hOperative
  refine ⟨hFee, ?_, ?_⟩
  · simp [independentResidualPayment, hFee]
  · simpa [independentResidualPayment, hFee] using R.hReputationCostPositive

theorem below_threshold_not_operative
    (R : ReputationAggregationAssumption) (nu : ℝ)
    (hBelow : R.countRule.count nu ≤ 1) :
    ¬ OperativeUnbundling R nu := by
  intro hOperative
  have hlt : R.countRule.count nu < 2 :=
    lt_of_le_of_lt hBelow (by norm_num)
  exact (not_le_of_gt hlt) hOperative

/-! ## Pointwise verification theorem -/

noncomputable def rentReduction
    (B : BundledCertificationAssumption)
    (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu : ℝ) : ℝ :=
  (R.reputationCost + B.bundledMarkup omega pi) -
    independentResidualPayment C nu

structure VerificationBindingOutcome
    (credence : CredenceGoodAssumption)
    (R : ReputationAggregationAssumption)
    (B : BundledCertificationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu : ℝ) : Prop where
  residualGapPositive : 0 < credence.residualEntropy omega pi
  bundledMarkupPositive : 0 < B.bundledMarkup omega pi
  independentFeeAtCost : certificationFee C nu = C.cV + R.reputationCost
  rentReductionPositive : 0 < rentReduction B R C omega pi nu

theorem thm_t4_binding
    (credence : CredenceGoodAssumption)
    (R : ReputationAggregationAssumption)
    (B : BundledCertificationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu : ℝ)
    (hOmegaLo : 0 ≤ omega) (hOmegaHi : omega ≤ 1)
    (hPiLo : 0 ≤ pi) (hPiHi : pi ≤ 1)
    (hOperative : OperativeUnbundling R nu) :
    VerificationBindingOutcome credence R B C omega pi nu := by
  have hResidual :=
    lem_independence credence omega pi hOmegaLo hOmegaHi hPiLo hPiHi
  have hBundled :=
    lem_lizzeri B omega pi hOmegaLo hOmegaHi hPiLo hPiHi
  have hFee := bertrand_fee_eq_marginal_cost R C nu hOperative
  have hResidualPayment : independentResidualPayment C nu = R.reputationCost := by
    simp [independentResidualPayment, hFee]
  refine ⟨hResidual, hBundled, hFee, ?_⟩
  unfold rentReduction
  rw [hResidualPayment]
  simpa using hBundled

structure WelfareAccessFunctional where
  Wcred : ℝ → ℝ → ℝ → ℝ

def PositiveWelfareIncidence (W : WelfareAccessFunctional)
    (B : BundledCertificationAssumption)
    (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu tau : ℝ) : Prop :=
  tau * rentReduction B R C omega pi nu ≤
    W.Wcred omega pi nu - W.Wcred omega pi 0

def CertificationRentWelfareIncidence (W : WelfareAccessFunctional)
    (B : BundledCertificationAssumption)
    (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu tau : ℝ) : Prop :=
  0 < tau ∧ tau ≤ 1 ∧
    PositiveWelfareIncidence W B R C omega pi nu tau

theorem cor_t4_welfare
    (credence : CredenceGoodAssumption)
    (R : ReputationAggregationAssumption)
    (W : WelfareAccessFunctional)
    (B : BundledCertificationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu tau : ℝ)
    (hOmegaLo : 0 ≤ omega) (hOmegaHi : omega ≤ 1)
    (hPiLo : 0 ≤ pi) (hPiHi : pi ≤ 1)
    (hOperative : OperativeUnbundling R nu)
    (hTauPositive : 0 < tau)
    (hIncidence : PositiveWelfareIncidence W B R C omega pi nu tau) :
    tau * rentReduction B R C omega pi nu ≤
        W.Wcred omega pi nu - W.Wcred omega pi 0 ∧
      0 < W.Wcred omega pi nu - W.Wcred omega pi 0 := by
  have hOutcome := thm_t4_binding credence R B C omega pi nu
    hOmegaLo hOmegaHi hPiLo hPiHi hOperative
  have hRent : 0 < rentReduction B R C omega pi nu :=
    hOutcome.rentReductionPositive
  constructor
  · exact hIncidence
  · have hProduct : 0 < tau * rentReduction B R C omega pi nu :=
      mul_pos hTauPositive hRent
    unfold PositiveWelfareIncidence at hIncidence
    linarith

theorem cor_t4_welfare_paper
    (credence : CredenceGoodAssumption)
    (R : ReputationAggregationAssumption)
    (W : WelfareAccessFunctional)
    (B : BundledCertificationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu tau : ℝ)
    (hOmegaLo : 0 ≤ omega) (hOmegaHi : omega ≤ 1)
    (hPiLo : 0 ≤ pi) (hPiHi : pi ≤ 1)
    (hOperative : OperativeUnbundling R nu)
    (hIncidence : CertificationRentWelfareIncidence W B R C omega pi nu tau) :
    tau * rentReduction B R C omega pi nu ≤
        W.Wcred omega pi nu - W.Wcred omega pi 0 ∧
      0 < W.Wcred omega pi nu - W.Wcred omega pi 0 := by
  exact cor_t4_welfare credence R W B C omega pi nu tau
    hOmegaLo hOmegaHi hPiLo hPiHi hOperative hIncidence.1 hIncidence.2.2

/-! ## Proof-ledger endpoint claims -/

set_option linter.unusedVariables false in
def IndependenceClaim : Prop :=
  ∀ (credence : CredenceGoodAssumption)
    (omega pi : ℝ),
    0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
      0 < credence.residualEntropy omega pi

theorem independenceClaim_proved :
    ∀ (credence : CredenceGoodAssumption) (omega pi : ℝ),
      0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
        0 < credence.residualEntropy omega pi :=
  lem_independence

set_option linter.unusedVariables false in
def BundledRentClaim : Prop :=
  ∀ (B : BundledCertificationAssumption)
    (omega pi : ℝ),
    0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
      0 < B.bundledMarkup omega pi

theorem bundledRentClaim_proved :
    ∀ (B : BundledCertificationAssumption) (omega pi : ℝ),
      0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
        0 < B.bundledMarkup omega pi :=
  lem_lizzeri

set_option linter.unusedVariables false in
def BertrandClaim : Prop :=
  ∀ (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption) (nu : ℝ),
    OperativeUnbundling R nu →
      certificationFee C nu = C.cV + R.reputationCost ∧
        independentResidualPayment C nu = R.reputationCost ∧
        0 < independentResidualPayment C nu

theorem bertrandClaim_proved :
    ∀ (R : ReputationAggregationAssumption)
      (C : CertifierCompetitionAssumption) (nu : ℝ),
      OperativeUnbundling R nu →
        certificationFee C nu = C.cV + R.reputationCost ∧
          independentResidualPayment C nu = R.reputationCost ∧
          0 < independentResidualPayment C nu :=
  lem_bertrand

set_option linter.unusedVariables false in
def VerificationBindingClaim : Prop :=
  ∀ (credence : CredenceGoodAssumption)
    (R : ReputationAggregationAssumption)
    (B : BundledCertificationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu : ℝ),
    0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
    OperativeUnbundling R nu →
      0 < credence.residualEntropy omega pi ∧
      0 < B.bundledMarkup omega pi ∧
      certificationFee C nu = C.cV + R.reputationCost ∧
      rentReduction B R C omega pi nu = B.bundledMarkup omega pi ∧
      0 < rentReduction B R C omega pi nu

theorem verificationBindingClaim_proved :
    ∀ (credence : CredenceGoodAssumption)
      (R : ReputationAggregationAssumption)
      (B : BundledCertificationAssumption)
      (C : CertifierCompetitionAssumption)
      (omega pi nu : ℝ),
      0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
      OperativeUnbundling R nu →
        0 < credence.residualEntropy omega pi ∧
        0 < B.bundledMarkup omega pi ∧
        certificationFee C nu = C.cV + R.reputationCost ∧
        rentReduction B R C omega pi nu = B.bundledMarkup omega pi ∧
        0 < rentReduction B R C omega pi nu := by
  intro credence R B C omega pi nu hOmegaLo hOmegaHi hPiLo hPiHi hOperative
  have hOutcome := thm_t4_binding credence R B C omega pi nu
    hOmegaLo hOmegaHi hPiLo hPiHi hOperative
  have hResidualPayment : independentResidualPayment C nu = R.reputationCost := by
    simp [independentResidualPayment, hOutcome.independentFeeAtCost]
  have hExact : rentReduction B R C omega pi nu = B.bundledMarkup omega pi := by
    simp [rentReduction, hResidualPayment]
  exact ⟨hOutcome.residualGapPositive, hOutcome.bundledMarkupPositive,
    hOutcome.independentFeeAtCost, hExact, hOutcome.rentReductionPositive⟩

set_option linter.unusedVariables false in
def WelfareCorollaryClaim : Prop :=
  ∀ (credence : CredenceGoodAssumption)
    (R : ReputationAggregationAssumption)
    (W : WelfareAccessFunctional)
    (B : BundledCertificationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu tau : ℝ),
    0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
    OperativeUnbundling R nu →
    CertificationRentWelfareIncidence W B R C omega pi nu tau →
      tau * rentReduction B R C omega pi nu ≤
          W.Wcred omega pi nu - W.Wcred omega pi 0 ∧
        0 < W.Wcred omega pi nu - W.Wcred omega pi 0

theorem welfareCorollaryClaim_proved :
    ∀ (credence : CredenceGoodAssumption)
      (R : ReputationAggregationAssumption)
      (W : WelfareAccessFunctional)
      (B : BundledCertificationAssumption)
      (C : CertifierCompetitionAssumption)
      (omega pi nu tau : ℝ),
      0 ≤ omega → omega ≤ 1 → 0 ≤ pi → pi ≤ 1 →
      OperativeUnbundling R nu →
      CertificationRentWelfareIncidence W B R C omega pi nu tau →
        tau * rentReduction B R C omega pi nu ≤
            W.Wcred omega pi nu - W.Wcred omega pi 0 ∧
          0 < W.Wcred omega pi nu - W.Wcred omega pi 0 :=
  cor_t4_welfare_paper

end AccessOrthogonality.CurrentPaper
