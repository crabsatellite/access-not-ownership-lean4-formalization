/- Paper-faithful local characterization and its exact branch algebra. -/

import AccessOrthogonality.CurrentPaperBasic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace AccessOrthogonality.CurrentPaper

/-- Assumption 5 represented at derivative level.  The inverse-branch identity
    is the differential content of the paper's differentiable inverse on the
    image of the unique cost-minimizing branch. -/
structure LocalIdentification where
  dW_dTheta : ℝ
  dW_dq : ℝ
  dq_dTheta : ℝ
  dc_dTheta : ℝ
  dd_dTheta : ℝ
  dc_dq : ℝ
  dd_dq : ℝ
  inverseC : ℝ
  inverseD : ℝ
  welfareChain : dW_dTheta = dW_dq * dq_dTheta
  computeChain : dc_dTheta = dc_dq * dq_dTheta
  dataChain : dd_dTheta = dd_dq * dq_dTheta
  inverseBranch : inverseC * dc_dq + inverseD * dd_dq = 1
  welfareMarginalNonzero : dW_dq ≠ 0

/-- Function-level carrier for Assumption 5.  The three chain identities are
    produced from actual `HasDerivAt` composition certificates rather than
    inserted as independent theorem-shaped premises. -/
structure FunctionalLocalIdentification where
  wBar : ℝ → ℝ
  qStar : ℝ → ℝ
  cBranch : ℝ → ℝ
  dBranch : ℝ → ℝ
  theta : ℝ
  dW_dTheta : ℝ
  dW_dq : ℝ
  dq_dTheta : ℝ
  dc_dTheta : ℝ
  dd_dTheta : ℝ
  dc_dq : ℝ
  dd_dq : ℝ
  inverseC : ℝ
  inverseD : ℝ
  welfareAt : HasDerivAt (fun t => wBar (qStar t)) dW_dTheta theta
  reducedWelfareAt : HasDerivAt wBar dW_dq (qStar theta)
  qualityAt : HasDerivAt qStar dq_dTheta theta
  computeAt : HasDerivAt (fun t => cBranch (qStar t)) dc_dTheta theta
  computeBranchAt : HasDerivAt cBranch dc_dq (qStar theta)
  dataAt : HasDerivAt (fun t => dBranch (qStar t)) dd_dTheta theta
  dataBranchAt : HasDerivAt dBranch dd_dq (qStar theta)
  inverseBranch : inverseC * dc_dq + inverseD * dd_dq = 1
  welfareMarginalNonzero : dW_dq ≠ 0

def FunctionalLocalIdentification.toDerivativeIdentification
    (F : FunctionalLocalIdentification) : LocalIdentification where
  dW_dTheta := F.dW_dTheta
  dW_dq := F.dW_dq
  dq_dTheta := F.dq_dTheta
  dc_dTheta := F.dc_dTheta
  dd_dTheta := F.dd_dTheta
  dc_dq := F.dc_dq
  dd_dq := F.dd_dq
  inverseC := F.inverseC
  inverseD := F.inverseD
  welfareChain := by
    exact (F.reducedWelfareAt.comp F.theta F.qualityAt).unique F.welfareAt |>.symm
  computeChain := by
    exact (F.computeBranchAt.comp F.theta F.qualityAt).unique F.computeAt |>.symm
  dataChain := by
    exact (F.dataBranchAt.comp F.theta F.qualityAt).unique F.dataAt |>.symm
  inverseBranch := F.inverseBranch
  welfareMarginalNonzero := F.welfareMarginalNonzero

/-- Display F05: reduced welfare after substituting the unique least-cost
    investment branch. -/
def reducedWelfare (welfare : Investment → ℝ)
    (costMinimizingBranch : ℝ → Investment) (q : ℝ) : ℝ :=
  welfare (costMinimizingBranch q)

/-- Display F07: equilibrium welfare factors through equilibrium quality. -/
def equilibriumReducedWelfare (wBar : ℝ → ℝ)
    (qStar : ℝ → ℝ) (theta : ℝ) : ℝ :=
  wBar (qStar theta)

/-- Display F08, as an explicit derivative-level chain-rule hypothesis. -/
def WelfareChainRule (dW_dTheta dW_dq dq_dTheta : ℝ) : Prop :=
  dW_dTheta = dW_dq * dq_dTheta

/-- Display F09: the selected investment lies on the cost-minimizing branch. -/
def OnCostMinimizingBranch (xStar : Investment) (xOfQ : ℝ → Investment)
    (qStar : ℝ) : Prop :=
  xStar = xOfQ qStar

theorem welfare_orthogonal_iff_quality_invariant (L : LocalIdentification) :
    L.dW_dTheta = 0 ↔ L.dq_dTheta = 0 := by
  constructor
  · intro h
    rw [L.welfareChain] at h
    exact (mul_eq_zero.mp h).resolve_left L.welfareMarginalNonzero
  · intro h
    rw [L.welfareChain, h, mul_zero]

theorem quality_invariant_iff_inputs_invariant (L : LocalIdentification) :
    L.dq_dTheta = 0 ↔
      L.dc_dTheta = 0 ∧ L.dd_dTheta = 0 := by
  constructor
  · intro hq
    constructor
    · rw [L.computeChain, hq, mul_zero]
    · rw [L.dataChain, hq, mul_zero]
  · rintro ⟨hc, hd⟩
    have hc' : L.dc_dq * L.dq_dTheta = 0 := by
      rw [← L.computeChain, hc]
    have hd' : L.dd_dq * L.dq_dTheta = 0 := by
      rw [← L.dataChain, hd]
    calc
      L.dq_dTheta = 1 * L.dq_dTheta := by ring
      _ = (L.inverseC * L.dc_dq + L.inverseD * L.dd_dq) *
          L.dq_dTheta := by rw [L.inverseBranch]
      _ = L.inverseC * (L.dc_dq * L.dq_dTheta) +
          L.inverseD * (L.dd_dq * L.dq_dTheta) := by ring
      _ = 0 := by rw [hc', hd']; ring

/-- The exact three-way statement of Theorem 6. -/
def CharacterizationClaim (L : LocalIdentification) : Prop :=
  (L.dW_dTheta = 0 ↔ L.dq_dTheta = 0) ∧
    (L.dq_dTheta = 0 ↔
      L.dc_dTheta = 0 ∧ L.dd_dTheta = 0)

theorem thm_characterization (L : LocalIdentification) :
    CharacterizationClaim L :=
  ⟨welfare_orthogonal_iff_quality_invariant L,
    quality_invariant_iff_inputs_invariant L⟩

def CharacterizationPaperClaim : Prop :=
  ∀ F : FunctionalLocalIdentification,
    CharacterizationClaim F.toDerivativeIdentification

theorem characterizationPaperClaim_proved :
    ∀ F : FunctionalLocalIdentification,
      (F.toDerivativeIdentification.dW_dTheta = 0 ↔
        F.toDerivativeIdentification.dq_dTheta = 0) ∧
      (F.toDerivativeIdentification.dq_dTheta = 0 ↔
        F.toDerivativeIdentification.dc_dTheta = 0 ∧
          F.toDerivativeIdentification.dd_dTheta = 0) := by
  intro F
  exact thm_characterization F.toDerivativeIdentification

/-- Remark 7: without the nonzero welfare marginal, welfare orthogonality need
    not identify quality invariance. -/
theorem flat_welfare_counterexample :
    ∃ dW_dTheta dW_dq dq_dTheta : ℝ,
      dW_dTheta = dW_dq * dq_dTheta ∧
      dW_dTheta = 0 ∧ dW_dq = 0 ∧ dq_dTheta ≠ 0 := by
  exact ⟨0, 0, 1, by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- Global ownership invariance is sufficient because welfare is defined on
    allocations and has no direct ownership argument. -/
theorem global_ownership_invariance_implies_welfare_invariance
    (W : WelfareFunctional) (br : BestResponseMap)
    (a : AccessVector) (R : Regime)
    (hOI : GloballyOwnershipInvariant br R) :
    WelfareThetaInvariant W br a R := by
  obtain ⟨xStar, hx⟩ := hOI
  intro thetaOne thetaTwo
  simp only [equilibriumWelfare, hx thetaOne, hx thetaTwo]

/-- Remark 11's stronger global-to-local implication for any real extension
    of the two allocation coordinates. -/
theorem global_constant_allocation_has_zero_derivatives
    (c d : ℝ → ℝ) (cStar dStar theta : ℝ)
    (hc : ∀ t, c t = cStar) (hd : ∀ t, d t = dStar) :
    deriv c theta = 0 ∧ deriv d theta = 0 := by
  have hcf : c = fun _ => cStar := funext hc
  have hdf : d = fun _ => dStar := funext hd
  rw [hcf, hdf]
  simp

end AccessOrthogonality.CurrentPaper
