/-
  Current-paper primitives for the Regulation & Governance manuscript.

  This namespace is deliberately separate from the historical extended-paper
  formalization.  Every carrier below mirrors a live object in `paper/paper.tex`.
  In particular, ownership does not enter welfare or profit directly: it enters
  the provider objective only as the weight on those two allocation functionals.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Tactic

namespace AccessOrthogonality.CurrentPaper

open scoped BigOperators

/-! ## Ownership and access -/

/-- Paper ownership weight `theta in [0,1]`. -/
structure OwnershipType where
  val : ℝ
  hLo : 0 ≤ val
  hHi : val ≤ 1

namespace OwnershipType

def privateEndpoint : OwnershipType := ⟨0, by norm_num, by norm_num⟩
def publicEndpoint : OwnershipType := ⟨1, by norm_num, by norm_num⟩

instance : Coe OwnershipType ℝ := ⟨OwnershipType.val⟩

end OwnershipType

/-- The three paper components: weight openness, compute portability, and
    verification unbundling. -/
structure AccessVector where
  omega : ℝ
  pi : ℝ
  nu : ℝ
  hOmegaLo : 0 ≤ omega
  hOmegaHi : omega ≤ 1
  hPiLo : 0 ≤ pi
  hPiHi : pi ≤ 1
  hNuLo : 0 ≤ nu
  hNuHi : nu ≤ 1

/-- Definition 1 with its actor--layer--date indices retained literally. -/
abbrev AccessStructure (Actor Layer Date : Type) :=
  Actor → Layer → Date → AccessVector

def AccessVector.productSummary (a : AccessVector) : ℝ :=
  a.omega * a.pi * a.nu

def AccessVector.bottleneckSummary (a : AccessVector) : ℝ :=
  min (min a.omega a.pi) a.nu

theorem AccessVector.productSummary_nonneg (a : AccessVector) :
    0 ≤ a.productSummary := by
  exact mul_nonneg (mul_nonneg a.hOmegaLo a.hPiLo) a.hNuLo

theorem AccessVector.productSummary_le_one (a : AccessVector) :
    a.productSummary ≤ 1 := by
  unfold AccessVector.productSummary
  calc
    a.omega * a.pi * a.nu ≤ 1 * 1 * 1 := by
      gcongr
      · exact a.hNuLo
      · exact a.hPiLo
      · exact a.hOmegaHi
      · exact a.hPiHi
      · exact a.hNuHi
    _ = 1 := by norm_num

/-- Display F02.  Real exponents are represented by `Real.rpow`. -/
noncomputable def qualityGrowth (alpha beta gamma delta c d q : ℝ) : ℝ :=
  alpha * Real.rpow c beta * Real.rpow d gamma * Real.rpow q delta

/-! ## Investment and the exact four-component regulatory tuple -/

structure Investment where
  c : ℝ
  d : ℝ
  hC : 0 ≤ c
  hD : 0 ≤ d

def Investment.qualityCost (x : Investment) (wD : ℝ) : ℝ :=
  x.c + wD * x.d

/-- The financing component carries both payment and the participation
    admissibility constraint. -/
structure FinancingMechanism where
  payment : Investment → ℝ
  admissible : Investment → Prop

/-- Definition 3: `R = (P_a,F,S,X)`.  The separation rule is an
    institutional predicate on the access vector; it is not replaced by a
    scale exponent. -/
structure Regime where
  pricingRule : ℝ → ℝ → ℝ → ℝ
  financingMechanism : FinancingMechanism
  separationRule : AccessVector → Prop
  externalConstraints : Investment → Prop

structure BestResponseMap where
  alloc : OwnershipType → Regime → Investment

/-- Definition 4, global part. -/
def GloballyOwnershipInvariant (br : BestResponseMap) (R : Regime) : Prop :=
  ∃ xStar : Investment, ∀ theta : OwnershipType, br.alloc theta R = xStar

/-- Definition 4, local derivative part for an arbitrary provider index. -/
def LocallyOwnershipInvariant (Provider : Type)
    (dcDTheta ddDTheta : Provider → ℝ) : Prop :=
  ∀ i : Provider, dcDTheta i = 0 ∧ ddDTheta i = 0

/-! ## Welfare and provider objective -/

/-- Definition 2: `W = CS + sum_i Pi_i - T`. -/
structure WelfareComponents (Provider : Type) [Fintype Provider] where
  consumerSurplus : ℝ
  providerProfit : Provider → ℝ
  transferDeadweightLoss : ℝ

def totalWelfare {Provider : Type} [Fintype Provider]
    (w : WelfareComponents Provider) : ℝ :=
  w.consumerSurplus + ∑ i, w.providerProfit i - w.transferDeadweightLoss

/-- Allocation welfare has no direct ownership argument. -/
structure WelfareFunctional where
  W : Investment → AccessVector → Regime → ℝ

/-- Profit likewise has no direct ownership argument. -/
structure ProfitFunctional where
  Pi : Investment → Regime → ℝ

def equilibriumWelfare (W : WelfareFunctional) (br : BestResponseMap)
    (theta : OwnershipType) (a : AccessVector) (R : Regime) : ℝ :=
  W.W (br.alloc theta R) a R

def WelfareThetaInvariant (W : WelfareFunctional) (br : BestResponseMap)
    (a : AccessVector) (R : Regime) : Prop :=
  ∀ thetaOne thetaTwo : OwnershipType,
    equilibriumWelfare W br thetaOne a R =
      equilibriumWelfare W br thetaTwo a R

/-- Display F03: `U_i = (1-theta_i) Pi_i + theta_i W`. -/
def providerObjective (P : ProfitFunctional) (W : WelfareFunctional)
    (a : AccessVector) (R : Regime) (theta : OwnershipType)
    (x : Investment) : ℝ :=
  (1 - theta.val) * P.Pi x R + theta.val * W.W x a R

/-! ## The six constructive conditions -/

def SC1MarginalCostPricing (R : Regime) : Prop :=
  ∀ q marginalCost state : ℝ,
    R.pricingRule q marginalCost state = marginalCost

def SC2Interoperability (R : Regime) (a : AccessVector) : Prop :=
  R.separationRule a

/-- SC3 includes exactly the unique, incentive-compatible financed allocation
    stated in the journal manuscript. -/
def SC3FrontierFinancing (br : BestResponseMap) (R : Regime) (wD : ℝ) : Prop :=
  ∃ xF : Investment,
    (∀ x : Investment,
      R.financingMechanism.admissible x ↔ x = xF) ∧
    R.financingMechanism.payment xF = xF.qualityCost wD ∧
    (∀ theta : OwnershipType,
      R.financingMechanism.admissible (br.alloc theta R))

/-- The remaining institutional assumptions are supplied as named predicates,
    rather than as global axioms or trivial `True` definitions. -/
structure InstitutionalPredicates where
  exAnteOperational : AccessVector → Prop
  lumpSumTransfersAvailable : Prop
  downstreamHomogeneousDegreeOne : Prop

structure ScopeConditions (inst : InstitutionalPredicates)
    (br : BestResponseMap) (R : Regime) (a : AccessVector) (wD : ℝ) : Prop where
  sc1 : SC1MarginalCostPricing R
  sc2 : SC2Interoperability R a
  sc3 : SC3FrontierFinancing br R wD
  sc4 : inst.exAnteOperational a
  sc5 : inst.lumpSumTransfersAvailable
  sc6 : inst.downstreamHomogeneousDegreeOne

end AccessOrthogonality.CurrentPaper
