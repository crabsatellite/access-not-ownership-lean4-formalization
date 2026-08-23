/- A concrete capture game for Theorem 26, without conclusion-shaped axioms. -/

import AccessOrthogonality.CurrentPaperSeparation
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Tactic

namespace AccessOrthogonality.CurrentPaper

open scoped BigOperators

abbrev OwnershipProfile (n : Nat) := Fin n → OwnershipType

structure LobbyingProfile (n : Nat) where
  effort : Fin n → ℝ
  nonnegative : ∀ i, 0 ≤ effort i

def zeroLobbyingProfile (n : Nat) : LobbyingProfile n where
  effort := fun _ => 0
  nonnegative := fun _ => by norm_num

def MaximizersOn (policySet : Set ℝ) (objective : ℝ → ℝ) : Set ℝ :=
  {m | m ∈ policySet ∧ ∀ x ∈ policySet, objective x ≤ objective m}

/-- Assumption (iii): one fixed tie-breaking rule is applied to the maximizer
    set, independently of ownership. -/
structure FixedTieBreak where
  choose : Set ℝ → ℝ
  choose_mem : ∀ policySet : Set ℝ,
    policySet.Nonempty → choose policySet ∈ policySet

structure LongRunEnvironment (n : Nat) where
  policySet : Set ℝ
  welfare : OwnershipProfile n → ℝ → ℝ
  profit : OwnershipProfile n → Fin n → ℝ → ℝ
  accessAtPolicy : OwnershipProfile n → ℝ → AccessVector
  lambda : ℝ
  hLambdaPositive : 0 < lambda
  hLambdaLeOne : lambda ≤ 1
  hWelfareMaximizersNonempty : ∀ theta,
    (MaximizersOn policySet (welfare theta)).Nonempty

def providerUtility {n : Nat} (E : LongRunEnvironment n)
    (theta : OwnershipProfile n) (i : Fin n) (m : ℝ) : ℝ :=
  (1 - (theta i).val) * E.profit theta i m +
    (theta i).val * E.welfare theta m

/-- Display F15. -/
def regulatorObjective {n : Nat} (E : LongRunEnvironment n)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n) (m : ℝ) : ℝ :=
  E.lambda * E.welfare theta m +
    (1 - E.lambda) * ∑ i, ell.effort i * providerUtility E theta i m

def influenceScale {n : Nat} (E : LongRunEnvironment n)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n) : ℝ :=
  E.lambda + (1 - E.lambda) * ∑ i, ell.effort i * (theta i).val

def selectedPolicy {n : Nat} (E : LongRunEnvironment n)
    (tieBreak : FixedTieBreak) (theta : OwnershipProfile n)
    (ell : LobbyingProfile n) : ℝ :=
  tieBreak.choose (MaximizersOn E.policySet (regulatorObjective E theta ell))

/-- Display F17: selected policy as the fixed choice from the argmax set. -/
theorem selectedPolicy_definition {n : Nat} (E : LongRunEnvironment n)
    (tieBreak : FixedTieBreak) (theta : OwnershipProfile n)
    (ell : LobbyingProfile n) :
    selectedPolicy E tieBreak theta ell =
      tieBreak.choose
        (MaximizersOn E.policySet (regulatorObjective E theta ell)) :=
  rfl

/-- The uniform zero-profit implementation in assumption (ii). -/
def UniformZeroProfit {n : Nat} (E : LongRunEnvironment n) : Prop :=
  ∀ theta i m, E.profit theta i m = 0

/-- The committed OI domain keeps ownership in the carrier and supplies the
    pointwise transport that removes it from welfare and implemented access. -/
def CommittedOwnershipInvariant {n : Nat} (E : LongRunEnvironment n) : Prop :=
  ∀ thetaOne thetaTwo m,
    E.welfare thetaOne m = E.welfare thetaTwo m ∧
      E.accessAtPolicy thetaOne m = E.accessAtPolicy thetaTwo m

theorem regulatorObjective_eq_positiveScale {n : Nat}
    (E : LongRunEnvironment n) (theta : OwnershipProfile n)
    (ell : LobbyingProfile n) (hProfit : UniformZeroProfit E) :
    regulatorObjective E theta ell =
      fun m => influenceScale E theta ell * E.welfare theta m := by
  unfold UniformZeroProfit at hProfit
  funext m
  unfold regulatorObjective providerUtility influenceScale
  simp_rw [hProfit theta]
  simp only [mul_zero, zero_add]
  simp_rw [← mul_assoc]
  rw [← Finset.sum_mul]
  ring

theorem influenceScale_positive {n : Nat} (E : LongRunEnvironment n)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n) :
    0 < influenceScale E theta ell := by
  have hOneMinus : 0 ≤ 1 - E.lambda := by
    linarith [E.hLambdaLeOne]
  have hSum : 0 ≤ ∑ i, ell.effort i * (theta i).val := by
    exact Finset.sum_nonneg fun i _ => mul_nonneg (ell.nonnegative i) (theta i).hLo
  have hProduct : 0 ≤
      (1 - E.lambda) * ∑ i, ell.effort i * (theta i).val :=
    mul_nonneg hOneMinus hSum
  unfold influenceScale
  linarith [E.hLambdaPositive]

theorem maximizers_positive_scale (policySet : Set ℝ)
    (welfare : ℝ → ℝ) (scale : ℝ) (hScale : 0 < scale) :
    MaximizersOn policySet (fun m => scale * welfare m) =
      MaximizersOn policySet welfare := by
  ext m
  constructor
  · rintro ⟨hm, hmax⟩
    refine ⟨hm, ?_⟩
    intro x hx
    have h := hmax x hx
    exact le_of_mul_le_mul_left h hScale
  · rintro ⟨hm, hmax⟩
    refine ⟨hm, ?_⟩
    intro x hx
    exact mul_le_mul_of_nonneg_left (hmax x hx) (le_of_lt hScale)

theorem selectedPolicy_eq_welfareSelection {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n)
    (hProfit : UniformZeroProfit E) :
    selectedPolicy E tieBreak theta ell =
      tieBreak.choose (MaximizersOn E.policySet (E.welfare theta)) := by
  unfold selectedPolicy
  rw [regulatorObjective_eq_positiveScale E theta ell hProfit]
  rw [maximizers_positive_scale E.policySet (E.welfare theta)
    (influenceScale E theta ell) (influenceScale_positive E theta ell)]

theorem selectedPolicy_invariant_under_commitment {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (thetaOne thetaTwo : OwnershipProfile n)
    (ellOne ellTwo : LobbyingProfile n)
    (hCommittedOI : CommittedOwnershipInvariant E)
    (hProfit : UniformZeroProfit E) :
    selectedPolicy E tieBreak thetaOne ellOne =
      selectedPolicy E tieBreak thetaTwo ellTwo := by
  rw [selectedPolicy_eq_welfareSelection E tieBreak thetaOne ellOne hProfit,
    selectedPolicy_eq_welfareSelection E tieBreak thetaTwo ellTwo hProfit]
  have hWelfare : E.welfare thetaOne = E.welfare thetaTwo := by
    funext m
    exact (hCommittedOI thetaOne thetaTwo m).1
  rw [hWelfare]

theorem selectedPolicy_mem_argmax {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n)
    (hProfit : UniformZeroProfit E) :
    selectedPolicy E tieBreak theta ell ∈
      MaximizersOn E.policySet (regulatorObjective E theta ell) := by
  have hSets :
      MaximizersOn E.policySet (regulatorObjective E theta ell) =
        MaximizersOn E.policySet (E.welfare theta) := by
    rw [regulatorObjective_eq_positiveScale E theta ell hProfit]
    exact maximizers_positive_scale E.policySet (E.welfare theta)
      (influenceScale E theta ell) (influenceScale_positive E theta ell)
  unfold selectedPolicy
  apply tieBreak.choose_mem
  rw [hSets]
  exact E.hWelfareMaximizersNonempty theta

noncomputable def providerPayoff {n : Nat} (E : LongRunEnvironment n)
    (tieBreak : FixedTieBreak) (theta : OwnershipProfile n)
    (ell : LobbyingProfile n) (i : Fin n) : ℝ :=
  providerUtility E theta i (selectedPolicy E tieBreak theta ell) -
    (ell.effort i) ^ 2 / 2

theorem zeroLobbying_weakly_dominates {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n)
    (i : Fin n) (hProfit : UniformZeroProfit E) :
    providerPayoff E tieBreak theta ell i ≤
      providerPayoff E tieBreak theta (zeroLobbyingProfile n) i := by
  unfold UniformZeroProfit at hProfit
  have hPolicy : selectedPolicy E tieBreak theta ell =
      selectedPolicy E tieBreak theta (zeroLobbyingProfile n) := by
    rw [selectedPolicy_eq_welfareSelection E tieBreak theta ell hProfit,
      selectedPolicy_eq_welfareSelection E tieBreak theta
        (zeroLobbyingProfile n) hProfit]
  unfold providerPayoff
  rw [hPolicy]
  unfold providerUtility
  simp_rw [hProfit theta]
  simp [zeroLobbyingProfile]
  nlinarith [sq_nonneg (ell.effort i)]

theorem zeroLobbying_strictly_dominates_positive_effort {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n)
    (i : Fin n) (hProfit : UniformZeroProfit E)
    (hEffortPositive : 0 < ell.effort i) :
    providerPayoff E tieBreak theta ell i <
      providerPayoff E tieBreak theta (zeroLobbyingProfile n) i := by
  unfold UniformZeroProfit at hProfit
  have hPolicy : selectedPolicy E tieBreak theta ell =
      selectedPolicy E tieBreak theta (zeroLobbyingProfile n) := by
    rw [selectedPolicy_eq_welfareSelection E tieBreak theta ell hProfit,
      selectedPolicy_eq_welfareSelection E tieBreak theta
        (zeroLobbyingProfile n) hProfit]
  unfold providerPayoff
  rw [hPolicy]
  unfold providerUtility
  simp_rw [hProfit theta]
  simp [zeroLobbyingProfile]
  nlinarith [sq_pos_of_pos hEffortPositive]

def LobbyingProfile.withEffort {n : Nat} (ell : LobbyingProfile n)
    (i : Fin n) (effort : ℝ) (hEffort : 0 ≤ effort) : LobbyingProfile n where
  effort := fun j => if j = i then effort else ell.effort j
  nonnegative := fun j => by
    by_cases hji : j = i
    · simpa [hji] using hEffort
    · simpa [hji] using ell.nonnegative j

def IsLobbyingNash {n : Nat} (E : LongRunEnvironment n)
    (tieBreak : FixedTieBreak) (theta : OwnershipProfile n)
    (ell : LobbyingProfile n) : Prop :=
  ∀ i effort (hEffort : 0 ≤ effort),
    providerPayoff E tieBreak theta (ell.withEffort i effort hEffort) i ≤
      providerPayoff E tieBreak theta ell i

theorem zeroLobbying_is_nash {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (theta : OwnershipProfile n) (hProfit : UniformZeroProfit E) :
    IsLobbyingNash E tieBreak theta (zeroLobbyingProfile n) := by
  intro i effort hEffort
  have hPolicy :
      selectedPolicy E tieBreak theta
          ((zeroLobbyingProfile n).withEffort i effort hEffort) =
        selectedPolicy E tieBreak theta (zeroLobbyingProfile n) := by
    rw [selectedPolicy_eq_welfareSelection E tieBreak theta
        ((zeroLobbyingProfile n).withEffort i effort hEffort) hProfit,
      selectedPolicy_eq_welfareSelection E tieBreak theta
        (zeroLobbyingProfile n) hProfit]
  unfold providerPayoff
  rw [hPolicy]
  simp [LobbyingProfile.withEffort, zeroLobbyingProfile]
  nlinarith [sq_nonneg effort]

theorem positive_effort_has_profitable_zero_deviation {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n)
    (i : Fin n) (hProfit : UniformZeroProfit E)
    (hPositive : 0 < ell.effort i) :
    providerPayoff E tieBreak theta ell i <
      providerPayoff E tieBreak theta
        (ell.withEffort i 0 (by norm_num)) i := by
  have hPolicy : selectedPolicy E tieBreak theta ell =
      selectedPolicy E tieBreak theta (ell.withEffort i 0 (by norm_num)) := by
    rw [selectedPolicy_eq_welfareSelection E tieBreak theta ell hProfit,
      selectedPolicy_eq_welfareSelection E tieBreak theta
        (ell.withEffort i 0 (by norm_num)) hProfit]
  unfold providerPayoff
  rw [hPolicy]
  simp [LobbyingProfile.withEffort]
  nlinarith [sq_pos_of_pos hPositive]

theorem lobbying_nash_eq_zero {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (theta : OwnershipProfile n) (ell : LobbyingProfile n)
    (hProfit : UniformZeroProfit E)
    (hNash : IsLobbyingNash E tieBreak theta ell) :
    ell = zeroLobbyingProfile n := by
  have hEffort : ell.effort = fun _ => 0 := by
    funext i
    have hNonnegative := ell.nonnegative i
    by_contra hNonzero
    have hPositive : 0 < ell.effort i :=
      lt_of_le_of_ne hNonnegative (Ne.symm hNonzero)
    have hStrict := positive_effort_has_profitable_zero_deviation
      E tieBreak theta ell i hProfit hPositive
    have hNoDeviation := hNash i 0 (by norm_num)
    linarith
  cases ell with
  | mk effort nonnegative =>
      simp only at hEffort
      subst effort
      rfl

def IsUniqueZeroLobbyingNash {n : Nat} (E : LongRunEnvironment n)
    (tieBreak : FixedTieBreak) (theta : OwnershipProfile n) : Prop :=
  IsLobbyingNash E tieBreak theta (zeroLobbyingProfile n) ∧
    ∀ ell, IsLobbyingNash E tieBreak theta ell → ell = zeroLobbyingProfile n

theorem zeroLobbying_unique_nash {n : Nat}
    (E : LongRunEnvironment n) (tieBreak : FixedTieBreak)
    (theta : OwnershipProfile n) (hProfit : UniformZeroProfit E) :
    IsUniqueZeroLobbyingNash E tieBreak theta :=
  ⟨zeroLobbying_is_nash E tieBreak theta hProfit,
    fun ell hNash => lobbying_nash_eq_zero E tieBreak theta ell hProfit hNash⟩

/-- Display F19. -/
theorem profit_derivative_zero {n : Nat} (E : LongRunEnvironment n)
    (hProfit : UniformZeroProfit E) (theta : OwnershipProfile n)
    (i : Fin n) (m : ℝ) :
    deriv (E.profit theta i) m = 0 := by
  have hfun : E.profit theta i = fun _ => 0 := funext (hProfit theta i)
  rw [hfun]
  simp

/-- Displays F16/F20: the scalar chain rule behind the marginal lobbying
    benefit formula. -/
def LobbyingFirstOrderCondition
    (ellStar duDm dmDell : ℝ) : Prop :=
  ellStar = duDm * dmDell

theorem lobbying_foc_of_stationary
    (utility policy : ℝ → ℝ) (ell m duDm dmDell : ℝ)
    (hUtility : HasDerivAt utility duDm m)
    (hPolicy : HasDerivAt policy dmDell ell)
    (hValue : policy ell = m)
    (hStationary :
      HasDerivAt
        (fun effort => utility (policy effort) - effort ^ 2 / 2) 0 ell) :
    LobbyingFirstOrderCondition ell duDm dmDell := by
  subst m
  have hBenefit :
      HasDerivAt (fun effort => utility (policy effort))
        (duDm * dmDell) ell :=
    hUtility.comp ell hPolicy
  have hCost : HasDerivAt (fun effort : ℝ => effort ^ 2 / 2) ell ell := by
    convert ((hasDerivAt_id ell).pow 2).div_const 2 using 1
    all_goals simp
  have hPayoff :
      HasDerivAt
        (fun effort => utility (policy effort) - effort ^ 2 / 2)
        (duDm * dmDell - ell) ell :=
    hBenefit.sub hCost
  have hDerivative := hPayoff.unique hStationary
  unfold LobbyingFirstOrderCondition
  linarith

theorem marginal_lobbying_chain_rule
    (utility policy : ℝ → ℝ) (ell m duDm dmDell : ℝ)
    (hUtility : HasDerivAt utility duDm m)
    (hPolicy : HasDerivAt policy dmDell ell)
    (hValue : policy ell = m) :
    HasDerivAt (fun effort => utility (policy effort))
      (duDm * dmDell) ell := by
  subst m
  exact hUtility.comp ell hPolicy

/-! ## Display F18: an actual one-provider two-stage bundled-game witness -/

def bundledExampleWelfare (m : ℝ) : ℝ := 1 - m
def bundledExampleProfit (m : ℝ) : ℝ := m

def bundledExampleProviderUtility (theta m : ℝ) : ℝ :=
  (1 - theta) * bundledExampleProfit m + theta * bundledExampleWelfare m

/-- `lambda=1/4`, endogenous lobbying effort, binary policy domain. -/
noncomputable def bundledExampleObjective (theta ell m : ℝ) : ℝ :=
  (1 / 4 : ℝ) * bundledExampleWelfare m +
    (3 / 4 : ℝ) * ell * bundledExampleProviderUtility theta m

def binaryPolicySet : Set ℝ := {0, 1}

/-- A single ownership-blind selector that prefers policy `1` when it belongs
    to the argmax set and otherwise selects an arbitrary certified member. -/
noncomputable def bundledExampleTieBreak : FixedTieBreak := by
  classical
  refine
    { choose := fun policySet =>
        if hOne : (1 : ℝ) ∈ policySet then 1
        else if hNonempty : policySet.Nonempty then Classical.choose hNonempty
        else 0
      choose_mem := ?_ }
  intro policySet hNonempty
  by_cases hOne : (1 : ℝ) ∈ policySet
  · simp [hOne]
  · simp [hOne, hNonempty, Classical.choose_spec hNonempty]

def IsStrictPolicyMaximizer (objective : ℝ → ℝ) (mStar : ℝ) : Prop :=
  mStar ∈ binaryPolicySet ∧
    ∀ m ∈ binaryPolicySet, m ≠ mStar → objective m < objective mStar

def IsPolicyMaximizer (objective : ℝ → ℝ) (mStar : ℝ) : Prop :=
  mStar ∈ binaryPolicySet ∧
    ∀ m ∈ binaryPolicySet, objective m ≤ objective mStar

/-- The fixed ownership-blind tie-break chooses policy `1` at the private
    provider's threshold indifference. -/
noncomputable def bundledPrivatePolicy (ell : ℝ) : ℝ :=
  if (1 / 3 : ℝ) ≤ ell then 1 else 0

noncomputable def bundledPublicPolicy (_ell : ℝ) : ℝ := 0

theorem bundled_private_policy_is_regulator_best (ell : ℝ) :
    IsPolicyMaximizer (bundledExampleObjective 0 ell) (bundledPrivatePolicy ell) := by
  by_cases hThreshold : (3 : ℝ)⁻¹ ≤ ell
  · constructor
    · simp [bundledPrivatePolicy, hThreshold, binaryPolicySet]
    · intro m hm
      simp only [binaryPolicySet, Set.mem_insert_iff, Set.mem_singleton_iff] at hm
      rcases hm with rfl | rfl <;>
        simp [bundledPrivatePolicy, hThreshold, bundledExampleObjective,
          bundledExampleProviderUtility, bundledExampleProfit,
          bundledExampleWelfare] <;> nlinarith
  · have hBelow : ell < (3 : ℝ)⁻¹ := lt_of_not_ge hThreshold
    constructor
    · simp [bundledPrivatePolicy, hThreshold, binaryPolicySet]
    · intro m hm
      simp only [binaryPolicySet, Set.mem_insert_iff, Set.mem_singleton_iff] at hm
      rcases hm with rfl | rfl <;>
        simp [bundledPrivatePolicy, hThreshold, bundledExampleObjective,
          bundledExampleProviderUtility, bundledExampleProfit,
          bundledExampleWelfare] <;> nlinarith

theorem bundled_public_policy_is_regulator_best (ell : ℝ)
    (hEll : 0 ≤ ell) :
    IsPolicyMaximizer (bundledExampleObjective 1 ell) (bundledPublicPolicy ell) := by
  constructor
  · simp [bundledPublicPolicy, binaryPolicySet]
  · intro m hm
    simp only [binaryPolicySet, Set.mem_insert_iff, Set.mem_singleton_iff] at hm
    rcases hm with rfl | rfl <;>
      simp [bundledPublicPolicy, bundledExampleObjective,
        bundledExampleProviderUtility, bundledExampleProfit,
        bundledExampleWelfare] <;> nlinarith

noncomputable def bundledProviderPayoff
    (theta : ℝ) (policy : ℝ → ℝ) (ell : ℝ) : ℝ :=
  bundledExampleProviderUtility theta (policy ell) - ell ^ 2 / 2

def IsProviderBestResponse
    (theta : ℝ) (policy : ℝ → ℝ) (ellStar : ℝ) : Prop :=
  0 ≤ ellStar ∧
    ∀ ell, 0 ≤ ell →
      bundledProviderPayoff theta policy ell ≤
        bundledProviderPayoff theta policy ellStar

theorem bundled_private_lobbying_best_response :
    IsProviderBestResponse 0 bundledPrivatePolicy (1 / 3 : ℝ) := by
  constructor
  · norm_num
  · intro ell hEll
    by_cases hThreshold : (3 : ℝ)⁻¹ ≤ ell
    · simp [bundledProviderPayoff, bundledPrivatePolicy, hThreshold,
        bundledExampleProviderUtility, bundledExampleProfit,
        bundledExampleWelfare]
      nlinarith [sq_nonneg (ell - (3 : ℝ)⁻¹)]
    · have hBelow : ell < (3 : ℝ)⁻¹ := lt_of_not_ge hThreshold
      simp [bundledProviderPayoff, bundledPrivatePolicy, hThreshold,
        bundledExampleProviderUtility, bundledExampleProfit,
        bundledExampleWelfare]
      nlinarith [sq_nonneg ell]

theorem bundled_public_lobbying_best_response :
    IsProviderBestResponse 1 bundledPublicPolicy 0 := by
  constructor
  · norm_num
  · intro ell hEll
    simp [bundledProviderPayoff, bundledPublicPolicy,
      bundledExampleProviderUtility, bundledExampleProfit,
      bundledExampleWelfare]
    nlinarith [sq_nonneg ell]

def bundledExampleAccess : AccessVector where
  omega := 0
  pi := 0
  nu := 0
  hOmegaLo := by norm_num
  hOmegaHi := by norm_num
  hPiLo := by norm_num
  hPiHi := by norm_num
  hNuLo := by norm_num
  hNuHi := by norm_num

noncomputable def bundledExampleEnvironment : LongRunEnvironment 1 where
  policySet := binaryPolicySet
  welfare := fun _ => bundledExampleWelfare
  profit := fun _ _ => bundledExampleProfit
  accessAtPolicy := fun _ _ => bundledExampleAccess
  lambda := 1 / 4
  hLambdaPositive := by norm_num
  hLambdaLeOne := by norm_num
  hWelfareMaximizersNonempty := fun _ => by
    refine ⟨0, ?_⟩
    constructor
    · simp [binaryPolicySet]
    · intro m hm
      simp only [binaryPolicySet, Set.mem_insert_iff, Set.mem_singleton_iff] at hm
      rcases hm with rfl | rfl <;> norm_num [bundledExampleWelfare]

def bundledExampleLobbying (ell : ℝ) (hEll : 0 ≤ ell) : LobbyingProfile 1 where
  effort := fun _ => ell
  nonnegative := fun _ => hEll

def bundledPrivateProfile : OwnershipProfile 1 :=
  fun _ => OwnershipType.privateEndpoint

def bundledPublicProfile : OwnershipProfile 1 :=
  fun _ => OwnershipType.publicEndpoint

theorem bundledExampleObjective_matches_regulator
    (ell m : ℝ) (hEll : 0 ≤ ell) :
    regulatorObjective bundledExampleEnvironment bundledPrivateProfile
        (bundledExampleLobbying ell hEll) m = bundledExampleObjective 0 ell m ∧
      regulatorObjective bundledExampleEnvironment bundledPublicProfile
        (bundledExampleLobbying ell hEll) m = bundledExampleObjective 1 ell m := by
  constructor <;>
    simp [regulatorObjective, bundledExampleEnvironment,
      bundledPrivateProfile, bundledPublicProfile, bundledExampleLobbying,
      providerUtility, bundledExampleObjective, bundledExampleProviderUtility,
      bundledExampleWelfare, bundledExampleProfit,
      OwnershipType.privateEndpoint, OwnershipType.publicEndpoint] <;>
    ring_nf

theorem bundled_private_policy_matches_selectedPolicy
    (ell : ℝ) (hEll : 0 ≤ ell) :
    selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
        bundledPrivateProfile (bundledExampleLobbying ell hEll) =
      bundledPrivatePolicy ell := by
  classical
  have hObjective :
      regulatorObjective bundledExampleEnvironment bundledPrivateProfile
          (bundledExampleLobbying ell hEll) =
        bundledExampleObjective 0 ell := by
    funext m
    exact (bundledExampleObjective_matches_regulator ell m hEll).1
  unfold selectedPolicy
  rw [hObjective]
  change bundledExampleTieBreak.choose
      (MaximizersOn binaryPolicySet (bundledExampleObjective 0 ell)) =
        bundledPrivatePolicy ell
  by_cases hThreshold : (3 : ℝ)⁻¹ ≤ ell
  · have hOneMax :
        (1 : ℝ) ∈ MaximizersOn binaryPolicySet
          (bundledExampleObjective 0 ell) := by
      have hBest := bundled_private_policy_is_regulator_best ell
      simpa [IsPolicyMaximizer, bundledPrivatePolicy, hThreshold] using hBest
    have hPolicy : bundledPrivatePolicy ell = 1 := by
      simp [bundledPrivatePolicy, hThreshold]
    rw [hPolicy]
    simp only [bundledExampleTieBreak]
    rw [dif_pos hOneMax]
  · have hBelow : ell < (3 : ℝ)⁻¹ := lt_of_not_ge hThreshold
    have hSet :
        MaximizersOn binaryPolicySet (bundledExampleObjective 0 ell) =
          ({0} : Set ℝ) := by
      ext m
      constructor
      · rintro ⟨hm, hMax⟩
        simp only [binaryPolicySet, Set.mem_insert_iff,
          Set.mem_singleton_iff] at hm
        rcases hm with rfl | rfl
        · simp
        · have hAtZero := hMax 0 (by simp [binaryPolicySet])
          norm_num [bundledExampleObjective, bundledExampleProviderUtility,
            bundledExampleProfit, bundledExampleWelfare] at hAtZero
          nlinarith
      · intro hm
        have hmZero : m = 0 := by simpa using hm
        subst m
        refine ⟨by simp [binaryPolicySet], ?_⟩
        intro x hx
        simp only [binaryPolicySet, Set.mem_insert_iff,
          Set.mem_singleton_iff] at hx
        rcases hx with rfl | rfl
        · rfl
        · norm_num [bundledExampleObjective, bundledExampleProviderUtility,
            bundledExampleProfit, bundledExampleWelfare]
          nlinarith
    rw [hSet]
    have hChosen := bundledExampleTieBreak.choose_mem ({0} : Set ℝ) (by simp)
    have hPolicy : bundledPrivatePolicy ell = 0 := by
      simp [bundledPrivatePolicy, hThreshold]
    rw [hPolicy]
    simpa using hChosen

theorem bundled_public_policy_matches_selectedPolicy
    (ell : ℝ) (hEll : 0 ≤ ell) :
    selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
        bundledPublicProfile (bundledExampleLobbying ell hEll) =
      bundledPublicPolicy ell := by
  have hObjective :
      regulatorObjective bundledExampleEnvironment bundledPublicProfile
          (bundledExampleLobbying ell hEll) =
        bundledExampleObjective 1 ell := by
    funext m
    exact (bundledExampleObjective_matches_regulator ell m hEll).2
  have hSet :
      MaximizersOn binaryPolicySet (bundledExampleObjective 1 ell) =
        ({0} : Set ℝ) := by
    ext m
    constructor
    · rintro ⟨hm, hMax⟩
      simp only [binaryPolicySet, Set.mem_insert_iff,
        Set.mem_singleton_iff] at hm
      rcases hm with rfl | rfl
      · simp
      · have hAtZero := hMax 0 (by simp [binaryPolicySet])
        norm_num [bundledExampleObjective, bundledExampleProviderUtility,
          bundledExampleProfit, bundledExampleWelfare] at hAtZero
        nlinarith
    · intro hm
      have hmZero : m = 0 := by simpa using hm
      subst m
      refine ⟨by simp [binaryPolicySet], ?_⟩
      intro x hx
      simp only [binaryPolicySet, Set.mem_insert_iff,
        Set.mem_singleton_iff] at hx
      rcases hx with rfl | rfl
      · rfl
      · norm_num [bundledExampleObjective, bundledExampleProviderUtility,
          bundledExampleProfit, bundledExampleWelfare]
        nlinarith
  unfold selectedPolicy
  rw [hObjective]
  change bundledExampleTieBreak.choose
      (MaximizersOn binaryPolicySet (bundledExampleObjective 1 ell)) =
        bundledPublicPolicy ell
  rw [hSet]
  have hChosen := bundledExampleTieBreak.choose_mem ({0} : Set ℝ) (by simp)
  simpa [bundledPublicPolicy] using hChosen

theorem bundled_private_equilibrium_selected_policy :
    selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
        bundledPrivateProfile (bundledExampleLobbying (1 / 3 : ℝ) (by norm_num)) = 1 := by
  rw [bundled_private_policy_matches_selectedPolicy (1 / 3 : ℝ) (by norm_num)]
  simp [bundledPrivatePolicy]

theorem bundled_public_equilibrium_selected_policy :
    selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
        bundledPublicProfile (bundledExampleLobbying 0 (by norm_num)) = 0 := by
  rw [bundled_public_policy_matches_selectedPolicy 0 (by norm_num)]
  simp [bundledPublicPolicy]

/-- Provider payoff in the actual two-stage game, with the regulator response
    generated by the same fixed tie-break used by `selectedPolicy`. -/
noncomputable def bundledActualProviderPayoff
    (theta : ℝ) (profile : OwnershipProfile 1)
    (ell : ℝ) (hEll : 0 ≤ ell) : ℝ :=
  bundledExampleProviderUtility theta
      (selectedPolicy bundledExampleEnvironment bundledExampleTieBreak profile
        (bundledExampleLobbying ell hEll)) -
    ell ^ 2 / 2

def IsActualProviderBestResponse
    (theta : ℝ) (profile : OwnershipProfile 1) (ellStar : ℝ) : Prop :=
  ∃ hStar : 0 ≤ ellStar,
    ∀ ell (hEll : 0 ≤ ell),
      bundledActualProviderPayoff theta profile ell hEll ≤
        bundledActualProviderPayoff theta profile ellStar hStar

theorem bundled_private_actual_lobbying_best_response :
    IsActualProviderBestResponse 0 bundledPrivateProfile (1 / 3 : ℝ) := by
  refine ⟨by norm_num, ?_⟩
  intro ell hEll
  unfold bundledActualProviderPayoff
  rw [bundled_private_policy_matches_selectedPolicy ell hEll,
    bundled_private_policy_matches_selectedPolicy (1 / 3 : ℝ) (by norm_num)]
  exact bundled_private_lobbying_best_response.2 ell hEll

theorem bundled_public_actual_lobbying_best_response :
    IsActualProviderBestResponse 1 bundledPublicProfile 0 := by
  refine ⟨by norm_num, ?_⟩
  intro ell hEll
  unfold bundledActualProviderPayoff
  rw [bundled_public_policy_matches_selectedPolicy ell hEll,
    bundled_public_policy_matches_selectedPolicy 0 (by norm_num)]
  exact bundled_public_lobbying_best_response.2 ell hEll

def BundledPolicyDependenceClaim : Prop :=
    IsActualProviderBestResponse 0 bundledPrivateProfile (1 / 3 : ℝ) ∧
      IsActualProviderBestResponse 1 bundledPublicProfile 0 ∧
      (∀ ell (hEll : 0 ≤ ell),
        selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
            bundledPrivateProfile (bundledExampleLobbying ell hEll) =
          bundledPrivatePolicy ell) ∧
      (∀ ell (hEll : 0 ≤ ell),
        selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
            bundledPublicProfile (bundledExampleLobbying ell hEll) =
          bundledPublicPolicy ell) ∧
      IsPolicyMaximizer (bundledExampleObjective 0 (1 / 3 : ℝ))
        (bundledPrivatePolicy (1 / 3 : ℝ)) ∧
      IsPolicyMaximizer (bundledExampleObjective 1 0)
        (bundledPublicPolicy 0) ∧
      bundledPrivatePolicy (1 / 3 : ℝ) = 1 ∧
      bundledPublicPolicy 0 = 0 ∧
      selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
          bundledPrivateProfile (bundledExampleLobbying (1 / 3 : ℝ) (by norm_num)) = 1 ∧
      selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
          bundledPublicProfile (bundledExampleLobbying 0 (by norm_num)) = 0 ∧
      bundledPrivatePolicy (1 / 3 : ℝ) ≠ bundledPublicPolicy 0

theorem bundled_policy_dependence_witness :
    IsActualProviderBestResponse 0 bundledPrivateProfile (1 / 3 : ℝ) ∧
      IsActualProviderBestResponse 1 bundledPublicProfile 0 ∧
      (∀ ell (hEll : 0 ≤ ell),
        selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
            bundledPrivateProfile (bundledExampleLobbying ell hEll) =
          bundledPrivatePolicy ell) ∧
      (∀ ell (hEll : 0 ≤ ell),
        selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
            bundledPublicProfile (bundledExampleLobbying ell hEll) =
          bundledPublicPolicy ell) ∧
      IsPolicyMaximizer (bundledExampleObjective 0 (1 / 3 : ℝ))
        (bundledPrivatePolicy (1 / 3 : ℝ)) ∧
      IsPolicyMaximizer (bundledExampleObjective 1 0)
        (bundledPublicPolicy 0) ∧
      bundledPrivatePolicy (1 / 3 : ℝ) = 1 ∧
      bundledPublicPolicy 0 = 0 ∧
      selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
          bundledPrivateProfile (bundledExampleLobbying (1 / 3 : ℝ) (by norm_num)) = 1 ∧
      selectedPolicy bundledExampleEnvironment bundledExampleTieBreak
          bundledPublicProfile (bundledExampleLobbying 0 (by norm_num)) = 0 ∧
      bundledPrivatePolicy (1 / 3 : ℝ) ≠ bundledPublicPolicy 0 := by
  refine ⟨bundled_private_actual_lobbying_best_response,
    bundled_public_actual_lobbying_best_response,
    bundled_private_policy_matches_selectedPolicy,
    bundled_public_policy_matches_selectedPolicy, ?_, ?_, ?_, ?_,
    bundled_private_equilibrium_selected_policy,
    bundled_public_equilibrium_selected_policy, ?_⟩
  · exact bundled_private_policy_is_regulator_best (1 / 3 : ℝ)
  · exact bundled_public_policy_is_regulator_best 0 (by norm_num)
  · simp [bundledPrivatePolicy]
  · simp [bundledPublicPolicy]
  · norm_num [bundledPrivatePolicy, bundledPublicPolicy]

/-- The full mathematical conclusion of Theorem 26. -/
def LongRunClaim : Prop :=
  ∀ (n : Nat) (E : LongRunEnvironment n) (tieBreak : FixedTieBreak),
    CommittedOwnershipInvariant E → UniformZeroProfit E →
      (∀ theta, IsUniqueZeroLobbyingNash E tieBreak theta) ∧
      (∀ thetaOne thetaTwo ellOne ellTwo,
        selectedPolicy E tieBreak thetaOne ellOne =
          selectedPolicy E tieBreak thetaTwo ellTwo) ∧
      (∀ theta ell,
        selectedPolicy E tieBreak theta ell ∈
          MaximizersOn E.policySet (regulatorObjective E theta ell)) ∧
      (∀ thetaOne thetaTwo ellOne ellTwo,
        E.accessAtPolicy thetaOne (selectedPolicy E tieBreak thetaOne ellOne) =
          E.accessAtPolicy thetaTwo (selectedPolicy E tieBreak thetaTwo ellTwo)) ∧
      (∀ thetaOne thetaTwo ellOne ellTwo,
        E.welfare thetaOne (selectedPolicy E tieBreak thetaOne ellOne) =
          E.welfare thetaTwo (selectedPolicy E tieBreak thetaTwo ellTwo))

theorem thm_longrun :
    ∀ (n : Nat) (E : LongRunEnvironment n) (tieBreak : FixedTieBreak),
      CommittedOwnershipInvariant E → UniformZeroProfit E →
        (∀ theta, IsUniqueZeroLobbyingNash E tieBreak theta) ∧
        (∀ thetaOne thetaTwo ellOne ellTwo,
          selectedPolicy E tieBreak thetaOne ellOne =
            selectedPolicy E tieBreak thetaTwo ellTwo) ∧
        (∀ theta ell,
          selectedPolicy E tieBreak theta ell ∈
            MaximizersOn E.policySet (regulatorObjective E theta ell)) ∧
        (∀ thetaOne thetaTwo ellOne ellTwo,
          E.accessAtPolicy thetaOne (selectedPolicy E tieBreak thetaOne ellOne) =
            E.accessAtPolicy thetaTwo (selectedPolicy E tieBreak thetaTwo ellTwo)) ∧
        (∀ thetaOne thetaTwo ellOne ellTwo,
          E.welfare thetaOne (selectedPolicy E tieBreak thetaOne ellOne) =
            E.welfare thetaTwo (selectedPolicy E tieBreak thetaTwo ellTwo)) := by
  intro n E tieBreak hCommittedOI hProfit
  have hPolicy : ∀ thetaOne thetaTwo ellOne ellTwo,
      selectedPolicy E tieBreak thetaOne ellOne =
        selectedPolicy E tieBreak thetaTwo ellTwo := by
    intro thetaOne thetaTwo ellOne ellTwo
    exact selectedPolicy_invariant_under_commitment E tieBreak
      thetaOne thetaTwo ellOne ellTwo hCommittedOI hProfit
  refine ⟨fun theta => zeroLobbying_unique_nash E tieBreak theta hProfit,
    hPolicy, ?_, ?_, ?_⟩
  · intro theta ell
    exact selectedPolicy_mem_argmax E tieBreak theta ell hProfit
  · intro thetaOne thetaTwo ellOne ellTwo
    rw [hPolicy thetaOne thetaTwo ellOne ellTwo]
    exact (hCommittedOI thetaOne thetaTwo
      (selectedPolicy E tieBreak thetaTwo ellTwo)).2
  · intro thetaOne thetaTwo ellOne ellTwo
    rw [hPolicy thetaOne thetaTwo ellOne ellTwo]
    exact (hCommittedOI thetaOne thetaTwo
      (selectedPolicy E tieBreak thetaTwo ellTwo)).1

end AccessOrthogonality.CurrentPaper
