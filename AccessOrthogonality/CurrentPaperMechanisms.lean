/- The four sufficient implementation families, with no conclusion-shaped axioms. -/

import AccessOrthogonality.CurrentPaperCharacterization

namespace AccessOrthogonality.CurrentPaper

/-! ## Optimization predicates -/

def IsMaxOn (f : Investment → ℝ) (feasible : Investment → Prop)
    (xStar : Investment) : Prop :=
  feasible xStar ∧ ∀ x, feasible x → f x ≤ f xStar

def IsStrictUniqueMaxOn (f : Investment → ℝ)
    (feasible : Investment → Prop) (xStar : Investment) : Prop :=
  feasible xStar ∧
    ∀ x, feasible x → x ≠ xStar → f x < f xStar

/-! ## Mechanisms -/

/-- M_alpha: profit is constant on the relevant feasible margin. -/
def MechanismMalpha (P : ProfitFunctional) (R : Regime)
    (feasible : Investment → Prop) : Prop :=
  ∃ k : ℝ, ∀ x, feasible x → P.Pi x R = k

/-- The non-circular selection qualification required by the rent-zero
    mechanism.  Welfare has a strict unique maximizer, every recorded
    allocation is a best response to the mixed objective, and the private
    endpoint selects that welfare maximizer.  Unlike global ownership
    invariance, this condition does not assume that every type selects the
    same allocation. -/
def CommonSelection (P : ProfitFunctional) (W : WelfareFunctional)
    (br : BestResponseMap) (a : AccessVector) (R : Regime)
    (feasible : Investment → Prop) : Prop :=
  ∃ xStar,
    IsStrictUniqueMaxOn (fun x => W.W x a R) feasible xStar ∧
    br.alloc OwnershipType.privateEndpoint R = xStar ∧
    ∀ theta,
      IsMaxOn (providerObjective P W a R theta) feasible (br.alloc theta R)

/-- M_beta is exactly the unique IC-financing content of SC3. -/
def MechanismMbeta (br : BestResponseMap) (R : Regime) (wD : ℝ) : Prop :=
  SC3FrontierFinancing br R wD

/-- M_gamma: profit and welfare share a strict unique maximizer and the
    recorded best response maximizes their mixed objective. -/
def MechanismMgamma (P : ProfitFunctional) (W : WelfareFunctional)
    (br : BestResponseMap) (a : AccessVector) (R : Regime)
    (feasible : Investment → Prop) : Prop :=
  ∃ xStar,
    IsStrictUniqueMaxOn (fun x => P.Pi x R) feasible xStar ∧
    IsStrictUniqueMaxOn (fun x => W.W x a R) feasible xStar ∧
    ∀ theta,
      IsMaxOn (providerObjective P W a R theta) feasible (br.alloc theta R)

/-- M_delta: the external feasible set is a singleton, and every best response
    is feasible. -/
def MechanismMdelta (br : BestResponseMap) (R : Regime) : Prop :=
  ∃ xC,
    (∀ x, R.externalConstraints x ↔ x = xC) ∧
    (∀ theta, R.externalConstraints (br.alloc theta R))

theorem prop_four_mechanisms_Malpha_with_selection
    (P : ProfitFunctional) (W : WelfareFunctional)
    (br : BestResponseMap) (a : AccessVector) (R : Regime)
    (feasible : Investment → Prop)
    (hMalpha : MechanismMalpha P R feasible)
    (hSelection : CommonSelection P W br a R feasible) :
    GloballyOwnershipInvariant br R := by
  obtain ⟨profitConstant, hProfitConstant⟩ := hMalpha
  obtain ⟨xStar, hWelfareUnique, hPrivateSelection, hBest⟩ := hSelection
  refine ⟨xStar, ?_⟩
  intro theta
  by_cases hThetaZero : theta.val = 0
  · have hThetaPrivate : theta = OwnershipType.privateEndpoint := by
      cases theta with
      | mk val hLo hHi =>
          simp only at hThetaZero
          subst val
          rfl
    simpa [hThetaPrivate] using hPrivateSelection
  · have hThetaPositive : 0 < theta.val :=
      lt_of_le_of_ne theta.hLo (Ne.symm hThetaZero)
    by_contra hDifferent
    have hChosenFeasible := (hBest theta).1
    have hStarFeasible := hWelfareUnique.1
    have hWelfareStrict :=
      hWelfareUnique.2 (br.alloc theta R) hChosenFeasible hDifferent
    have hProfitChosen := hProfitConstant (br.alloc theta R) hChosenFeasible
    have hProfitStar := hProfitConstant xStar hStarFeasible
    have hStrictObjective :
        providerObjective P W a R theta (br.alloc theta R) <
          providerObjective P W a R theta xStar := by
      unfold providerObjective
      rw [hProfitChosen, hProfitStar]
      nlinarith
    have hReverse := (hBest theta).2 xStar hStarFeasible
    linarith

theorem prop_four_mechanisms_Mbeta
    (br : BestResponseMap) (R : Regime) (wD : ℝ)
  (hMbeta : MechanismMbeta br R wD) :
    GloballyOwnershipInvariant br R := by
  obtain ⟨xF, hUnique, _hPayment, hFeasible⟩ := hMbeta
  exact ⟨xF, fun theta => (hUnique (br.alloc theta R)).mp (hFeasible theta)⟩

theorem shared_strict_maximizer_is_mixed_strict_maximizer
    (P : ProfitFunctional) (W : WelfareFunctional)
    (a : AccessVector) (R : Regime)
    (feasible : Investment → Prop) (xStar : Investment)
    (hProfit : IsStrictUniqueMaxOn (fun x => P.Pi x R) feasible xStar)
    (hWelfare : IsStrictUniqueMaxOn (fun x => W.W x a R) feasible xStar)
    (theta : OwnershipType) :
    IsStrictUniqueMaxOn
      (providerObjective P W a R theta) feasible xStar := by
  refine ⟨hProfit.1, ?_⟩
  intro x hx hne
  have hp := hProfit.2 x hx hne
  have hw := hWelfare.2 x hx hne
  by_cases hThetaZero : theta.val = 0
  · simpa [providerObjective, hThetaZero] using hp
  · have hThetaPositive : 0 < theta.val :=
      lt_of_le_of_ne theta.hLo (Ne.symm hThetaZero)
    have hOneMinusNonnegative : 0 ≤ 1 - theta.val := by
      linarith [theta.hHi]
    have hpWeighted :
        (1 - theta.val) * P.Pi x R ≤
          (1 - theta.val) * P.Pi xStar R :=
      mul_le_mul_of_nonneg_left (le_of_lt hp) hOneMinusNonnegative
    have hwWeighted :
        theta.val * W.W x a R < theta.val * W.W xStar a R :=
      mul_lt_mul_of_pos_left hw hThetaPositive
    exact add_lt_add_of_le_of_lt hpWeighted hwWeighted

theorem prop_four_mechanisms_Mgamma
    (P : ProfitFunctional) (W : WelfareFunctional)
    (br : BestResponseMap) (a : AccessVector) (R : Regime)
    (feasible : Investment → Prop)
    (hMgamma : MechanismMgamma P W br a R feasible) :
    GloballyOwnershipInvariant br R := by
  obtain ⟨xStar, hProfit, hWelfare, hBest⟩ := hMgamma
  refine ⟨xStar, ?_⟩
  intro theta
  by_contra hne
  have hStrict :=
    (shared_strict_maximizer_is_mixed_strict_maximizer
      P W a R feasible xStar hProfit hWelfare theta).2
      (br.alloc theta R) (hBest theta).1 hne
  have hReverse := (hBest theta).2 xStar hProfit.1
  linarith

theorem prop_four_mechanisms_Mdelta
    (br : BestResponseMap) (R : Regime)
    (hMdelta : MechanismMdelta br R) :
    GloballyOwnershipInvariant br R := by
  obtain ⟨xC, hSingleton, hFeasible⟩ := hMdelta
  exact ⟨xC, fun theta => (hSingleton (br.alloc theta R)).mp (hFeasible theta)⟩

/-- The complete mathematical content of Proposition 8. -/
def MechanismFamiliesClaim : Prop :=
  (∀ P W br a R feasible,
      MechanismMalpha P R feasible → CommonSelection P W br a R feasible →
        GloballyOwnershipInvariant br R) ∧
  (∀ br R wD,
      MechanismMbeta br R wD → GloballyOwnershipInvariant br R) ∧
  (∀ P W br a R feasible,
      MechanismMgamma P W br a R feasible →
        GloballyOwnershipInvariant br R) ∧
  (∀ br R,
      MechanismMdelta br R → GloballyOwnershipInvariant br R)

theorem mechanismFamiliesClaim_proved :
    (∀ P W br a R feasible,
      MechanismMalpha P R feasible → CommonSelection P W br a R feasible →
        GloballyOwnershipInvariant br R) ∧
    (∀ br R wD,
      MechanismMbeta br R wD → GloballyOwnershipInvariant br R) ∧
    (∀ P W br a R feasible,
      MechanismMgamma P W br a R feasible →
        GloballyOwnershipInvariant br R) ∧
    (∀ br R,
      MechanismMdelta br R → GloballyOwnershipInvariant br R) := by
  exact ⟨prop_four_mechanisms_Malpha_with_selection,
    prop_four_mechanisms_Mbeta,
    prop_four_mechanisms_Mgamma,
    prop_four_mechanisms_Mdelta⟩

end AccessOrthogonality.CurrentPaper
