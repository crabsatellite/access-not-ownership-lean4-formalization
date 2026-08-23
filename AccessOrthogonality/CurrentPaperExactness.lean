/- Exact-object consumers for all twenty displayed formulas. -/

import AccessOrthogonality.CurrentPaperLongRun
import AccessOrthogonality.CurrentPaperVerification

namespace AccessOrthogonality.CurrentPaper

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

theorem paper_rent_reduction_exact
    (B : BundledCertificationAssumption)
    (R : ReputationAggregationAssumption)
    (C : CertifierCompetitionAssumption)
    (omega pi nu : ℝ)
    (hOperative : OperativeUnbundling R nu) :
    rentReduction B R C omega pi nu = B.bundledMarkup omega pi := by
  have hFee := bertrand_fee_eq_marginal_cost R C nu hOperative
  simp [rentReduction, independentResidualPayment, hFee]

theorem paper_regulator_objective_exact {n : Nat}
    (E : LongRunEnvironment n) (theta : OwnershipProfile n)
    (ell : LobbyingProfile n) (m : ℝ) :
    regulatorObjective E theta ell m =
      E.lambda * E.welfare theta m +
        (1 - E.lambda) *
          ∑ i, ell.effort i * providerUtility E theta i m :=
  rfl

end AccessOrthogonality.CurrentPaper
