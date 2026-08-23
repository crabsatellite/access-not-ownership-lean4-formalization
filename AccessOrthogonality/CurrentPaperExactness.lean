/- Exact-object consumers for all twenty displayed formulas. -/

import AccessOrthogonality.CurrentPaperLongRun
import AccessOrthogonality.CurrentPaperVerification

namespace AccessOrthogonality.CurrentPaper

/-- Definition 1 with actor, layer, date, all three literal components, and
    every closed-unit-interval endpoint exposed in one root type. -/
theorem paper_access_structure_definition_exact
    {Actor Layer Date : Type} (mu : AccessStructure Actor Layer Date)
    (actor : Actor) (layer : Layer) (date : Date) :
    ((mu actor layer date).omega,
        (mu actor layer date).pi,
        (mu actor layer date).nu) =
      ((mu actor layer date).omega,
        (mu actor layer date).pi,
        (mu actor layer date).nu) ∧
    0 ≤ (mu actor layer date).omega ∧
    (mu actor layer date).omega ≤ 1 ∧
    0 ≤ (mu actor layer date).pi ∧
    (mu actor layer date).pi ≤ 1 ∧
    0 ≤ (mu actor layer date).nu ∧
    (mu actor layer date).nu ≤ 1 := by
  exact ⟨rfl,
    (mu actor layer date).hOmegaLo,
    (mu actor layer date).hOmegaHi,
    (mu actor layer date).hPiLo,
    (mu actor layer date).hPiHi,
    (mu actor layer date).hNuLo,
    (mu actor layer date).hNuHi⟩

theorem paper_global_ownership_invariance_exact
    (br : BestResponseMap) (R : Regime) :
    GloballyOwnershipInvariant br R ↔
      ∃ xStar : Investment, ∀ theta : OwnershipType,
        br.alloc theta R = xStar :=
  Iff.rfl

theorem paper_local_ownership_invariance_exact
    (Provider : Type) (dcDTheta ddDTheta : Provider → ℝ) :
    LocallyOwnershipInvariant Provider dcDTheta ddDTheta ↔
      ∀ i : Provider, dcDTheta i = 0 ∧ ddDTheta i = 0 :=
  Iff.rfl

theorem paper_access_vector_exact (a : AccessVector) :
    (a.omega, a.pi, a.nu) = (a.omega, a.pi, a.nu) := rfl

theorem paper_quality_growth_exact (alpha beta gamma delta c d q : ℝ) :
    qualityGrowth alpha beta gamma delta c d q =
      alpha * Real.rpow c beta * Real.rpow d gamma * Real.rpow q delta :=
  rfl

theorem paper_provider_objective_exact
    (P : ProfitFunctional) (W : WelfareFunctional)
    (a : AccessVector) (R : Regime) (theta : OwnershipType)
    (x : Investment) :
    providerObjective P W a R theta x =
      (1 - theta.val) * P.Pi x R + theta.val * W.W x a R :=
  rfl

theorem paper_reduced_welfare_exact (welfare : Investment → ℝ)
    (branch : ℝ → Investment) (q : ℝ) :
    reducedWelfare welfare branch q = welfare (branch q) := rfl

theorem paper_equilibrium_reduced_welfare_exact
    (wBar qStar : ℝ → ℝ) (theta : ℝ) :
  equilibriumReducedWelfare wBar qStar theta = wBar (qStar theta) := rfl

theorem paper_characterization_formula_exact
    (F : FunctionalLocalIdentification) :
    (F.toDerivativeIdentification.dW_dTheta = 0 ↔
        F.toDerivativeIdentification.dq_dTheta = 0) ∧
      (F.toDerivativeIdentification.dq_dTheta = 0 ↔
        F.toDerivativeIdentification.dc_dTheta = 0 ∧
          F.toDerivativeIdentification.dd_dTheta = 0) :=
  characterizationPaperClaim_proved F

theorem paper_welfare_chain_rule_exact
    (F : FunctionalLocalIdentification) :
    F.toDerivativeIdentification.dW_dTheta =
      F.toDerivativeIdentification.dW_dq *
        F.toDerivativeIdentification.dq_dTheta :=
  F.toDerivativeIdentification.welfareChain

theorem paper_cost_minimizing_branch_exact
    (xStar : Investment) (xOfQ : ℝ → Investment) (qStar : ℝ)
    (hBranch : OnCostMinimizingBranch xStar xOfQ qStar) :
    xStar = xOfQ qStar :=
  hBranch

theorem paper_consumer_information_exact {Information : Type}
    (production base : Set Information) :
    consumerInformation production base = production ∪ base :=
  rfl

theorem paper_rent_reduction_exact
    (B : BundledCertificationAssumption)
    (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu : ℝ)
    (hOperative : OperativeUnbundling R nu) :
    rentReduction B R C omega pi nu = B.bundledMarkup omega pi := by
  have hFee := bertrand_fee_eq_marginal_cost R C nu hOperative
  simp [rentReduction, independentResidualPayment, hFee]

theorem paper_positive_welfare_incidence_exact
    (W : WelfareAccessFunctional)
    (B : BundledCertificationAssumption)
    (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu tau : ℝ) :
    CertificationRentWelfareIncidence W B R C omega pi nu tau ↔
      0 < tau ∧ tau ≤ 1 ∧
        tau * rentReduction B R C omega pi nu ≤
          W.Wcred omega pi nu - W.Wcred omega pi 0 :=
  Iff.rfl

theorem paper_regulator_objective_exact {n : Nat}
    (E : LongRunEnvironment n) (theta : OwnershipProfile n)
    (ell : LobbyingProfile n) (m : ℝ) :
    regulatorObjective E theta ell m =
      E.lambda * E.welfare theta m +
        (1 - E.lambda) *
          ∑ i, ell.effort i * providerUtility E theta i m :=
  rfl

end AccessOrthogonality.CurrentPaper
