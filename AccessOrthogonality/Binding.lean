/-
  AccessOrthogonality/Binding.lean

  Structural formalization of the revised verification-binding result.

  The paper now separates three claims that an earlier encoding conflated:

  * the information gap on credence-good outputs is invariant to production
    openness, conditional on the credence-good partition;
  * after operative independent-certifier entry, the rent gap is
      m_bundled - m_Bertrand(ν) > 0
    under the displayed strict comparison;
  * a total-welfare gain follows only from an additional positive-incidence
    premise.

  Lean checks those implications.  It does not derive the vertically
  integrated disclosure equilibrium or the certifier-pricing carrier from
  first principles.
-/

import AccessOrthogonality.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace AccessOrthogonality

/-! ### Information-gap and welfare carriers -/

/-- Per-output credence-good information gap, indexed by `(ω, π, ν)`. -/
structure CredenceGapFunctional where
  gap : ℝ → ℝ → ℝ → ℝ

/-- Welfare on the credence-good market subset, indexed by `(ω, π, ν)`. -/
structure WelfareAccessFunctional where
  Wcred : ℝ → ℝ → ℝ → ℝ

/-! ### Credence-good gap independence -/

/-- *Cat 3 paper-novel structural equation.*

    Conditional on a fixed credence-good partition, production replicability
    does not itself reveal per-output ground truth.  The axiom is deliberately
    about an information-gap carrier, not a welfare difference. -/
axiom lemma_independence_gap :
    ∀ (G : CredenceGapFunctional) (ν : ℝ),
      0 ≤ ν → ν ≤ 1 →
      ∀ (ω₁ π₁ ω₂ π₂ : ℝ),
        0 ≤ ω₁ → ω₁ ≤ 1 → 0 ≤ π₁ → π₁ ≤ 1 →
        0 ≤ ω₂ → ω₂ ≤ 1 → 0 ≤ π₂ → π₂ ≤ 1 →
        G.gap ω₁ π₁ ν = G.gap ω₂ π₂ ν

/-! ### Bundled-certification rent carrier -/

/-- *Cat 2 external carrier.*  Lizzeri's separate-intermediary benchmark. -/
axiom lizzeri_1999_separate_certifier_rent :
    ∃ m_separate : ℝ, 0 < m_separate

/-- *Cat 3 maintained economic carrier.*

    Paper Assumption `\label{ass:bundled_rent}` exposes the extension from the
    separate-certifier benchmark to vertical integration.  It is not derived
    from `lemma_independence_gap` alone. -/
axiom bundled_certification_equilibrium :
    (∃ m_separate : ℝ, 0 < m_separate) →
    ∃ m_bundled : ℝ, 0 < m_bundled

/-- Paper Lemma `\label{lem:lizzeri}` under the maintained bundled carrier. -/
theorem lemma_lizzeri_bundled_rent :
    ∃ m_bundled : ℝ, 0 < m_bundled :=
  bundled_certification_equilibrium lizzeri_1999_separate_certifier_rent

/-! ### Independent-certifier residual payment carrier -/

/-- *Cat 3 typed primitive.*  Above-variable-cost residual payment under the
    normalized symmetric certifier specification. -/
axiom mBertrand : ℝ → ℝ

/-- *Cat 3 structural equation.*  Residual payments are non-negative. -/
axiom mBertrand_nonneg : ∀ ν : ℝ, 0 ≤ mBertrand ν

/-- *Cat 3 structural equation.*  Residual payment is non-increasing as
    operative unbundling raises the certifier count. -/
axiom mBertrand_monotone :
    ∀ ν₁ ν₂ : ℝ, 0 ≤ ν₁ → ν₁ ≤ ν₂ → ν₂ ≤ 1 →
      mBertrand ν₂ ≤ mBertrand ν₁

/-! ### Theorem T4: rent gap, not welfare by definition -/

/-- **Theorem `\label{thm:t4_binding}` (Verification-Binding).**

    The paper assumes an operative `ν`, a positive bundled rent, and the
    strict comparison `mBertrand ν < m_bundled`.  The positive rent reduction
    follows by real arithmetic.  Production-side openness does not occur in
    the statement because both rent carriers are typed independently of
    `(ω, π)` on the fixed credence-good partition. -/
theorem thm_t4_binding
    (m_bundled ν : ℝ)
    (_hBundledPos : 0 < m_bundled)
    (_hNuLo : 0 ≤ ν) (_hNuHi : ν ≤ 1)
    (hStrict : mBertrand ν < m_bundled) :
    0 < m_bundled - mBertrand ν := by
  exact sub_pos.mpr hStrict

/-- Boundary specialization `(ω, π) = (1, 1)`.  Since `(ω, π)` do not enter
    either rent carrier on the maintained partition, the same strict rent gap
    holds at full production openness. -/
theorem thm_t4_binding_at_boundary
    (m_bundled ν : ℝ)
    (hBundledPos : 0 < m_bundled)
    (hNuLo : 0 ≤ ν) (hNuHi : ν ≤ 1)
    (hStrict : mBertrand ν < m_bundled) :
    0 < m_bundled - mBertrand ν :=
  thm_t4_binding m_bundled ν hBundledPos hNuLo hNuHi hStrict

/-- **Corollary `\label{cor:t4_welfare}`.**

    `hIncidence` is the explicit welfare-incidence premise.  Without it, T4
    yields a rent-incidence result only. -/
theorem cor_t4_welfare
    (W : WelfareAccessFunctional)
    (ω π ν m_bundled τ : ℝ)
    (hBundledPos : 0 < m_bundled)
    (hNuLo : 0 ≤ ν) (hNuHi : ν ≤ 1)
    (hTauPos : 0 < τ)
    (hStrict : mBertrand ν < m_bundled)
    (hIncidence :
      τ * (m_bundled - mBertrand ν) ≤
        W.Wcred ω π ν - W.Wcred ω π 0) :
    0 < W.Wcred ω π ν - W.Wcred ω π 0 := by
  have hRentGap : 0 < m_bundled - mBertrand ν :=
    thm_t4_binding m_bundled ν hBundledPos hNuLo hNuHi hStrict
  have hPositiveIncidence : 0 < τ * (m_bundled - mBertrand ν) :=
    mul_pos hTauPos hRentGap
  linarith

/-! ### Label-aligned supporting lemmas -/

/-- Paper Lemma `\label{lem:independence}`. -/
theorem lem_independence
    (G : CredenceGapFunctional) (ν : ℝ)
    (hNuLo : 0 ≤ ν) (hNuHi : ν ≤ 1)
    (ω₁ π₁ ω₂ π₂ : ℝ)
    (hOmega1Lo : 0 ≤ ω₁) (hOmega1Hi : ω₁ ≤ 1)
    (hPi1Lo : 0 ≤ π₁) (hPi1Hi : π₁ ≤ 1)
    (hOmega2Lo : 0 ≤ ω₂) (hOmega2Hi : ω₂ ≤ 1)
    (hPi2Lo : 0 ≤ π₂) (hPi2Hi : π₂ ≤ 1) :
    G.gap ω₁ π₁ ν = G.gap ω₂ π₂ ν :=
  lemma_independence_gap G ν hNuLo hNuHi ω₁ π₁ ω₂ π₂
    hOmega1Lo hOmega1Hi hPi1Lo hPi1Hi
    hOmega2Lo hOmega2Hi hPi2Lo hPi2Hi

/-- Paper Lemma `\label{lem:lizzeri}`. -/
theorem lem_lizzeri : ∃ m : ℝ, 0 < m := lemma_lizzeri_bundled_rent

/-- Paper Lemma `\label{lem:bertrand}`: the maintained residual-payment
    carrier is non-negative and non-increasing on `[0,1]`. -/
theorem lem_bertrand :
    (∀ ν : ℝ, 0 ≤ mBertrand ν) ∧
    (∀ ν₁ ν₂ : ℝ, 0 ≤ ν₁ → ν₁ ≤ ν₂ → ν₂ ≤ 1 →
      mBertrand ν₂ ≤ mBertrand ν₁) :=
  ⟨mBertrand_nonneg, mBertrand_monotone⟩

end AccessOrthogonality
