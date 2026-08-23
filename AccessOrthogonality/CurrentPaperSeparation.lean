/- Constructive separation corollary from the exact SC3 object. -/

import AccessOrthogonality.CurrentPaperMechanisms
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace AccessOrthogonality.CurrentPaper

theorem thm_separation_from_sc3
    (br : BestResponseMap) (R : Regime) (wD : ℝ)
    (hSC3 : SC3FrontierFinancing br R wD) :
    GloballyOwnershipInvariant br R :=
  prop_four_mechanisms_Mbeta br R wD hSC3

theorem thm_separation_from_sc3_welfare_invariant
    (W : WelfareFunctional) (br : BestResponseMap)
    (R : Regime) (a : AccessVector) (wD : ℝ)
    (hSC3 : SC3FrontierFinancing br R wD) :
    WelfareThetaInvariant W br a R :=
  global_ownership_invariance_implies_welfare_invariance W br a R
    (thm_separation_from_sc3 br R wD hSC3)

def SeparationFromSC3Claim : Prop :=
  ∀ W br R a wD,
    SC3FrontierFinancing br R wD →
      GloballyOwnershipInvariant br R ∧
        WelfareThetaInvariant W br a R

theorem separationFromSC3Claim_proved :
    ∀ W br R a wD,
      SC3FrontierFinancing br R wD →
        GloballyOwnershipInvariant br R ∧
          WelfareThetaInvariant W br a R := by
  intro W br R a wD hSC3
  exact ⟨thm_separation_from_sc3 br R wD hSC3,
    thm_separation_from_sc3_welfare_invariant W br R a wD hSC3⟩

theorem thm_separation
    (inst : InstitutionalPredicates) (br : BestResponseMap)
    (R : Regime) (a : AccessVector) (wD : ℝ)
    (sc : ScopeConditions inst br R a wD) :
    GloballyOwnershipInvariant br R :=
  prop_four_mechanisms_Mbeta br R wD sc.sc3

theorem thm_separation_welfare_invariant
    (W : WelfareFunctional)
    (inst : InstitutionalPredicates) (br : BestResponseMap)
    (R : Regime) (a : AccessVector) (wD : ℝ)
    (sc : ScopeConditions inst br R a wD) :
    WelfareThetaInvariant W br a R :=
  global_ownership_invariance_implies_welfare_invariance W br a R
    (thm_separation inst br R a wD sc)

/-- Display F10: global allocation invariance makes the real-extension
    equilibrium-welfare derivative zero at fixed access. -/
theorem thm_separation_derivative_zero
    (W : WelfareFunctional) (allocation : ℝ → Investment)
    (a : AccessVector) (R : Regime) (xF : Investment) (theta : ℝ)
    (hAllocation : ∀ t, allocation t = xF) :
    deriv (fun t => W.W (allocation t) a R) theta = 0 := by
  have hfun : (fun t => W.W (allocation t) a R) =
      (fun _ : ℝ => W.W xF a R) := by
    funext t
    rw [hAllocation t]
  rw [hfun]
  simp

def SeparationClaim : Prop :=
  ∀ inst br R a wD,
    ScopeConditions inst br R a wD →
      GloballyOwnershipInvariant br R

theorem separationClaim_proved : SeparationClaim :=
  thm_separation

def FullSeparationClaim : Prop :=
  ∀ W inst br R a wD,
    ScopeConditions inst br R a wD →
      GloballyOwnershipInvariant br R ∧
        WelfareThetaInvariant W br a R

theorem fullSeparationClaim_proved :
    ∀ W inst br R a wD,
      ScopeConditions inst br R a wD →
        GloballyOwnershipInvariant br R ∧
          WelfareThetaInvariant W br a R := by
  intro W inst br R a wD sc
  exact ⟨thm_separation inst br R a wD sc,
    thm_separation_welfare_invariant W inst br R a wD sc⟩

end AccessOrthogonality.CurrentPaper
