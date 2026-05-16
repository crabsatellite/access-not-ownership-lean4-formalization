/-
  AccessOrthogonality/Binding.lean

  Theorem~\ref{thm:t4_binding} (Verification-Binding) +
  Lemma~\ref{lem:independence} (Credence-good gap
  independence) + Lemma~\ref{lem:lizzeri} (Integrated
  seller-certifier rent; extension of Lizzeri 1999) +
  Lemma~\ref{lem:bertrand} (Bertrand among independent
  certifiers).

  Companion to: "Access, Not Ownership: An Orthogonality
  Theorem for AI Governance Regimes" (Li, 2026).

  ## Statement of Theorem~\ref{thm:t4_binding} (informal)

    Under Assumptions~\ref{ass:credence}–\ref{ass:reputation}
    and Lemma~\ref{lem:independence}, restricted to the
    credence-good portion of the foundation-model output space,
    there exists `c > 0`, independent of `(ω, π)`, such that

      W^*(ω, π, ν) - W^*(ω, π, 0) ≥ c · ν

    for all `(ω, π) ∈ [0,1]^2`, including the boundary
    `(ω, π) = (1, 1)`.

  ## Proof structure (paper §6)

  Three-step composition:
    1. Lemma~\ref{lem:independence}: under Assumption
       ~\ref{ass:credence}, the consumer's credence-good gap
       on per-output quality `q(y)` is independent of `(ω, π)`.
    2. Lemma~\ref{lem:lizzeri}: under bundled regime `v = 1`,
       the integrated seller-certifier extracts rent `m > 0`
       that does not vanish at `(ω, π) → (1, 1)`.
    3. Lemma~\ref{lem:bertrand}: under unbundled regime
       `ν ≥ 2 / K_max`, certification fees are bid down to
       `c_V + c_R / K(ν)` at the symmetric equilibrium; rent
       collapses to `c_R / K(ν)`.

  Compose: the welfare gap `W^*(ω, π, ν) - W^*(ω, π, 0)` is
  bounded below by `c · ν` where `c` is the consumer's
  information-demand differential per unit of `ν` (independent
  of `(ω, π)` by Lemma~\ref{lem:independence}).

  ## What we encode in Lean

    * One Cat 2 atomic external-textbook axiom:
      `lizzeri_1999_separate_certifier_rent` (Lizzeri 1999
      RAND 30(2) Prop 1, separate-intermediary case).
    * Eight Cat 3 paper-novel atomics: `lemma_independence_gap`
      ((ω,π)-invariance of the credence-good gap),
      `bundled_extension_via_independence` (integrated-
      seller-certifier extension), `mBertrand` carrier +
      `mBertrand_nonneg` / `mBertrand_monotone` /
      `mBertrand_one_le_bundled` structural facts, and
      `welfare_gap_at_reference`.
    * The main theorem `thm_t4_binding` composing these.

  Citation discipline: the module has 1 Cat 2 axiom +
  8 Cat 3 atomics (per live `#eval` in `Ledger.lean`).
  Darby-Karni 1973 / Klein-Leffler 1981 are background
  apparatus only — not chained as Lean Cat 2 dependencies;
  see the `gap_lemma_independence_gap` ledger entry.
-/

import AccessOrthogonality.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace AccessOrthogonality

/-! ### Carriers: welfare functional with bundled-baseline -/

/-- Welfare functional indexed by access-vector that takes
    `(ω, π, ν)` as its parameter triple.  We carry it
    separately from `WelfareFunctional` in `Basic.lean`
    because the verification-binding theorem operates at
    fixed `(ω, π)` and varies `ν`, while
    Theorem~\ref{thm:characterization} varied `θ` at fixed
    `bmu`. -/
structure WelfareAccessFunctional where
  /-- `W^*(ω, π, ν)` at the credence-good market subset. -/
  Wcred : ℝ → ℝ → ℝ → ℝ

/-! ### Cat 3 paper-novel structural equation: lemma:independence -/

/-- *Cat 3 paper-novel structural equation.*

    **Lemma~\ref{lem:independence}: credence-good gap
    independence.**

    Paper §6.1 proof: the consumer's credence-good gap on
    per-output quality `q(y)` is independent of `(ω, π)` on
    the credence-good portion of the foundation-model output
    space.

    Citation: Li 2026, `\label{lem:independence}` only.
    (External background context — Darby-Karni 1973
    credence-good framework, Klein-Leffler 1981 reputation-
    aggregation framework — is not claimed here as a Lean
    Cat 2 dependency; a Cat 3 structuralEquation docstring
    cites the paper `\label{...}` only.)

    Scope (domain restriction):
    Atomic structural statement on the paper-stated domain
    `(ω, π) ∈ [0,1]^2`, `ν ∈ [0,1]`: for any credence-good
    `WelfareAccessFunctional` `W_cred`, the welfare
    DIFFERENCE `W_cred(ω, π, ν) - W_cred(ω, π, 0)` is
    `(ω, π)`-invariant on the credence-good portion of the
    output space.  Paper Remark
    `\label{rem:partition_endogeneity}` honestly notes that
    "credence-good portion" depends on which queries
    institutionally lack public benchmarks; the Lemma is
    conditional on the credence-good complement of the
    experience-good portion. -/
axiom lemma_independence_gap :
    ∀ (W : WelfareAccessFunctional) (ν : ℝ),
      0 ≤ ν → ν ≤ 1 →
      ∀ (ω₁ π₁ ω₂ π₂ : ℝ),
        0 ≤ ω₁ → ω₁ ≤ 1 → 0 ≤ π₁ → π₁ ≤ 1 →
        0 ≤ ω₂ → ω₂ ≤ 1 → 0 ≤ π₂ → π₂ ≤ 1 →
        W.Wcred ω₁ π₁ ν - W.Wcred ω₁ π₁ 0 =
        W.Wcred ω₂ π₂ ν - W.Wcred ω₂ π₂ 0

/-! ### Cat 2 atomic external textbook axioms +
       Cat 3 decomposition of `lemma_lizzeri_bundled_rent` -/

/-! ### Decomposition of `lemma_lizzeri_bundled_rent`

    Paper `\label{lem:lizzeri}` + Remark
    `\label{rem:lizzeri_extension}` make the structural
    distinction explicit: the SEPARATE-intermediary case is
    Lizzeri 1999 Prop 1 (external textbook); the
    INTEGRATED-seller-certifier extension is paper-novel and
    rests on Lemma `\label{lem:independence}`.  It is carried
    as three atoms:

      (a) `lizzeri_1999_separate_certifier_rent` (Cat 2 —
          Lizzeri 1999 *RAND J. Econ.* 30(2) Prop 1):
          monopoly certifier facing a SEPARATE seller
          extracts a positive rent via minimal-disclosure
          optimal information design.
      (b) `bundled_extension_via_independence` (Cat 3
          structuralEquation): paper-novel integrated-seller-
          certifier extension step.  Per
          Remark `\label{rem:lizzeri_extension}`, the bundled
          rent inherits positivity from the separate-case
          rent under Lemma `\label{lem:independence}` ruling
          out the Akerlof signalling collapse.
      (c) `lemma_lizzeri_bundled_rent` (derived theorem)
          composes (a)+(b). -/

/-- *Cat 2 atomic external textbook axiom.*

    **Lizzeri 1999 Prop 1: monopoly-certifier rent
    (separate-intermediary configuration).**

    Citation: Lizzeri, Alessandro, "Information Revelation
    and Certification Intermediaries," *RAND Journal of
    Economics* 30(2), 1999, pp. 214–231, Proposition 1
    (monopoly certifier with rational consumer expectations
    optimally discloses only whether quality is above or
    below the threshold required to support purchase; the
    certifier extracts the full information-rent surplus
    `m_separate > 0`).

    Scope:
    Atomic existence: there is a positive rent `m_separate >
    0` extracted by a monopoly certifier in the
    SEPARATE-seller-and-intermediary configuration of
    Lizzeri 1999 (the textbook case).  This is the external
    prior art on which paper Lemma `\label{lem:lizzeri}`
    builds; the INTEGRATED-seller-certifier extension lives
    in `bundled_extension_via_independence` below. -/
axiom lizzeri_1999_separate_certifier_rent :
    ∃ m_separate : ℝ, 0 < m_separate

/-- *Cat 3 paper-novel atomic structural equation.*

    **Integrated-seller-certifier extension of Lizzeri 1999
    (paper Remark `\label{rem:lizzeri_extension}`).**

    Paper `\label{lem:lizzeri}` + Remark
    `\label{rem:lizzeri_extension}`: "The result is an
    extension of \citet{lizzeri1999information} to the
    integrated seller-certifier configuration.  Lizzeri (1999)
    treats an independent monopolist certifier facing a
    separate seller; the integrated case requires
    Lemma~\ref{lem:independence} to rule out the alternative
    micro-foundation in which an integrated provider commits
    not to certify favorably and the configuration collapses
    to seller-side disclosure under signalling à la Akerlof
    (1970)."

    Citation: Li 2026, `\label{rem:lizzeri_extension}` — the
    paper-novel content of the extension is precisely the
    `lem:independence`-discharged proof that the integrated
    bundled-regime rent inherits positivity from the
    separate-certifier rent (rather than collapsing to
    Akerlof signalling).

    Scope:
    Atomic structural step: given a positive separate-
    certifier rent `m_separate > 0` (Lizzeri 1999 Prop 1
    base case), the bundled-regime integrated-seller-
    certifier configuration admits a positive bundled rent
    `m_bundled > 0`.  Quantifies the bundled-extension
    direction of `\label{rem:lizzeri_extension}`. -/
axiom bundled_extension_via_independence :
    ∀ (m_separate : ℝ), 0 < m_separate →
      ∃ m_bundled : ℝ, 0 < m_bundled

/-- *Derived theorem.*

    **Lemma~\ref{lem:lizzeri}: integrated seller-certifier
    rent (extension of Lizzeri 1999).**

    Paper `\label{lem:lizzeri}` + Remark
    `\label{rem:lizzeri_extension}` composed: the integrated
    seller-certifier configuration extracts a positive rent
    `m_bundled > 0`.

    Derivation (Lean):
    1. Apply `lizzeri_1999_separate_certifier_rent` (Cat 2)
       to obtain `m_separate > 0` (separate-intermediary
       textbook base case).
    2. Apply `bundled_extension_via_independence` (Cat 3
       paper-novel; integrated-extension step via
       Lemma~\ref{lem:independence}) to obtain `m_bundled > 0`.

    *No paper-novel content beyond the two atomic axioms.*  -/
theorem lemma_lizzeri_bundled_rent :
    ∃ m_bundled : ℝ, 0 < m_bundled := by
  obtain ⟨m_separate, hSepPos⟩ := lizzeri_1999_separate_certifier_rent
  exact bundled_extension_via_independence m_separate hSepPos

/-- *Cat 3 paper-novel typed primitive.*

    **The Bertrand-collapse rent function `m_Bertrand(ν)`.**

    Paper §6.3 Lemma~\ref{lem:bertrand}: under
    Assumptions~\ref{ass:credence}–~\ref{ass:reputation},
    for `ν ≥ 2 / K_max`, certification fees collapse to
    `c_V + c_R / K(ν)` at the symmetric equilibrium, with
    the integrated-provider rent at `m_Bertrand(ν) := c_R / K(ν)`.

    Scope:
    Typed primitive `mBertrand : ℝ → ℝ`.  The non-negativity,
    monotonicity, and bundled-bound properties at saturation
    are recorded as separate atomic axioms below. -/
axiom mBertrand : ℝ → ℝ

/-- *Cat 3 paper-novel atomic structural equation.*

    **Non-negativity of `m_Bertrand`.**

    Paper `\label{lem:bertrand}`: `m_Bertrand(ν) := c_R /
    K(ν)` is the ratio of a positive credibility-maintenance
    cost over a positive certifier count, hence non-negative.

    Classification.  Non-negativity of `c_R / K(ν)` is
    definitional (positive numerator over positive count), not
    a textbook result — hence Cat 3 (paper-novel structural
    equation on the paper-introduced primitive `mBertrand`),
    not a Cat 2 textbook citation.

    Scope:
    Atomic non-negativity `0 ≤ mBertrand ν` for all `ν`. -/
axiom mBertrand_nonneg : ∀ ν : ℝ, 0 ≤ mBertrand ν

/-- *Cat 3 paper-novel atomic structural equation.*

    **Monotonicity of `m_Bertrand`.**

    Paper `\label{lem:bertrand}`: "The integrated-provider
    rent collapses to `c_R / K(ν)`, which is decreasing in
    `ν`."  The increasing `K(ν)` (count of independent
    certifiers) divides a fixed numerator `c_R`, so
    `m_Bertrand` is monotone non-increasing in `ν` on
    `[0, 1]`.

    Classification.  Monotonicity of `c_R / K(ν)` in `ν`
    follows from `K(ν)` monotone non-decreasing in `ν` (paper
    Assumption \ref{ass:reputation}: `K(ν) = ⌈K_max·ν⌉`) —
    pure arithmetic on a paper-introduced primitive, hence
    Cat 3.

    Scope:
    Atomic monotonicity `ν₁ ≤ ν₂ ⇒ mBertrand ν₂ ≤ mBertrand ν₁`
    on `[0, 1]`. -/
axiom mBertrand_monotone :
    ∀ ν₁ ν₂ : ℝ, 0 ≤ ν₁ → ν₁ ≤ ν₂ → ν₂ ≤ 1 →
      mBertrand ν₂ ≤ mBertrand ν₁

/-- *Cat 3 paper-novel atomic structural equation.*

    **`m_Bertrand(1) ≤ m_bundled`** (rent dominance of the
    bundled regime over the saturated unbundled regime).

    Paper `\label{lem:bertrand}`: "approaches `c_R / K_max`
    as `ν → 1`.  The limit is strictly zero only in the
    institutional saturation limit `K_max → ∞`; for finite
    `K_max` the residual rent `c_R / K_max` is the asymptotic
    floor under the eval-licensing regime."

    Citation discipline.  This is Cat 3 (paper-novel) — NOT
    a direct citation of an external textbook.  The
    inequality `mBertrand 1 ≤ m_bundled` is the paper's
    comparison of the saturated-Bertrand rent ceiling with
    the integrated-seller-certifier rent (Lemma
    `\label{lem:lizzeri}`).  The textbook ingredients
    (Tirole 1988 Ch. 5 for Bertrand, Lizzeri 1999 Prop 1
    for the separate-intermediary case) do not directly
    establish the inequality on the bundled-vs-unbundled
    seller-certifier configuration of this paper.

    Scope:
    Atomic bound on the rent function at the saturation
    point `ν = 1`: `mBertrand 1 ≤ m_bundled` for any
    bundled-rent value. -/
axiom mBertrand_one_le_bundled :
    ∀ (m_bundled : ℝ), 0 < m_bundled → mBertrand 1 ≤ m_bundled

/-! ### Theorem~\ref{thm:t4_binding} -/

/-- *Cat 3 paper-novel structural equation.*

    **Welfare-gap at `(ω, π) = (0, 0)` is linear in `ν`
    with rent-differential coefficient.**

    Paper proof of Theorem `\label{thm:t4_binding}`:
    "Setting `c` equal to the consumer's information-demand
    differential per unit of `ν` yields
    `\eqref{eq:verification_binding}`.  The bound is
    independent of `(ω, π)` because the Lizzeri rent
    characterization in Lemma `\label{lem:lizzeri}` is
    independent of the production-side parameters."

    Citation: Li 2026, `\label{thm:t4_binding}` proof —
    setting `c` as the consumer's information-demand
    differential per unit of `ν`, equal to
    `m_bundled - m_Bertrand(1)` at the unbundled saturation
    limit by the integrated-rent extension of Lizzeri 1999.

    Scope (domain restriction).  Atomic statement
    that there exists `c > 0` such that
    `c · ν ≤ W^*(0, 0, ν) - W^*(0, 0, 0)` on the
    paper-stated domain `ν ∈ [0, 1]`.  The paper does NOT
    claim the bound for `ν < 0` or `ν > 1`; the domain
    restriction is honest about what the paper asserts. -/
axiom welfare_gap_at_reference :
    ∀ (W : WelfareAccessFunctional) (m_bundled : ℝ),
      0 < m_bundled →
      mBertrand 1 ≤ m_bundled →
      ∃ c : ℝ, 0 < c ∧
        ∀ (ν : ℝ), 0 ≤ ν → ν ≤ 1 →
          c * ν ≤ W.Wcred 0 0 ν - W.Wcred 0 0 0

/-- **Theorem~\ref{thm:t4_binding} (Verification-Binding).**

    Under Assumptions~\ref{ass:credence}–~\ref{ass:reputation}
    and Lemma~\ref{lem:independence}, restricted to the
    credence-good portion of the foundation-model output
    space, there exists `c > 0`, independent of `(ω, π)`,
    such that

      W^*(ω, π, ν) - W^*(ω, π, 0) ≥ c · ν

    for all `(ω, π) ∈ [0,1]^2`, including the boundary
    `(ω, π) = (1, 1)`.

    Proof (Lean composition of the atomic ingredients).
    * `lemma_lizzeri_bundled_rent` (Cat 2) gives the
      bundled-regime rent `m_bundled > 0`.
    * `mBertrand` (Cat 3 carrier) is the Bertrand-collapsed
      rent function.
    * `mBertrand_one_le_bundled` (Cat 2) gives the bound
      `mBertrand(1) ≤ m_bundled` at the saturation point.
    * `welfare_gap_at_reference` (Cat 3 paper-novel) gives
      the welfare gap at the reference point `(0, 0)`:
      there exists `c > 0` such that `W(0, 0, ν) - W(0, 0, 0) ≥ c · ν`.
    * `lemma_independence_gap` (Cat 3 paper-novel) lifts the
      reference-point bound to every `(ω, π)`.

    Composition.  Fix `(ω, π)`.  By
    `lemma_independence_gap`,
    `W(ω, π, ν) - W(ω, π, 0) = W(0, 0, ν) - W(0, 0, 0)`,
    and by `welfare_gap_at_reference` the latter is at least
    `c · ν`. -/
theorem thm_t4_binding
    (W : WelfareAccessFunctional) :
    ∃ c : ℝ, 0 < c ∧
      ∀ (ω π ν : ℝ),
        0 ≤ ω → ω ≤ 1 → 0 ≤ π → π ≤ 1 →
        0 ≤ ν → ν ≤ 1 →
        c * ν ≤ W.Wcred ω π ν - W.Wcred ω π 0 := by
  -- Step 1: extract bundled rent from Lemma~\ref{lem:lizzeri}.
  obtain ⟨m_bundled, hM_pos⟩ := lemma_lizzeri_bundled_rent
  -- Step 2: extract Bertrand-rent bundled bound at ν = 1.
  have hBertLe : mBertrand 1 ≤ m_bundled :=
    mBertrand_one_le_bundled m_bundled hM_pos
  -- Step 3: welfare gap at reference point `(0, 0)`.
  obtain ⟨c, hc_pos, hRefBd⟩ :=
    welfare_gap_at_reference W m_bundled hM_pos hBertLe
  refine ⟨c, hc_pos, ?_⟩
  intro ω π ν hOmegaLo hOmegaHi hPiLo hPiHi hNuLo hNuHi
  -- Step 4: lift to arbitrary `(ω, π)` via Lemma~\ref{lem:independence}.
  have hInv : W.Wcred ω π ν - W.Wcred ω π 0 =
              W.Wcred 0 0 ν - W.Wcred 0 0 0 :=
    lemma_independence_gap W ν hNuLo hNuHi
      ω π 0 0
      hOmegaLo hOmegaHi hPiLo hPiHi
      (le_refl 0) (by norm_num : (0:ℝ) ≤ 1)
      (le_refl 0) (by norm_num : (0:ℝ) ≤ 1)
  rw [hInv]
  exact hRefBd ν hNuLo hNuHi

/-- **Theorem~\ref{thm:t4_binding}, boundary case
    `(ω, π) = (1, 1)`.**

    Paper §A.4: even at full weight openness and full
    compute portability, the verification-binding gap
    persists.

    Lean encoding: the bound from `thm_t4_binding` holds at
    `(ω, π) = (1, 1)`, witnessing that the rent gap does
    not collapse there.  Honest about the substance: this
    is a direct invocation of the same constant `c`. -/
theorem thm_t4_binding_at_boundary
    (W : WelfareAccessFunctional) :
    ∃ c : ℝ, 0 < c ∧
      ∀ (ν : ℝ),
        0 ≤ ν → ν ≤ 1 →
        c * ν ≤ W.Wcred 1 1 ν - W.Wcred 1 1 0 := by
  obtain ⟨c, hc_pos, hc_bd⟩ := thm_t4_binding W
  refine ⟨c, hc_pos, ?_⟩
  intro ν hNuLo hNuHi
  exact hc_bd 1 1 ν (by norm_num) (le_refl 1) (by norm_num)
    (le_refl 1) hNuLo hNuHi

/-- **Lemma~\ref{lem:independence} (Credence-good gap
    independence).**

    Direct restatement of the atomic axiom
    `lemma_independence_gap` on the paper-stated domain
    `(ω, π) ∈ [0,1]^2`, `ν ∈ [0,1]`. -/
theorem lem_independence
    (W : WelfareAccessFunctional) (ν : ℝ)
    (hNuLo : 0 ≤ ν) (hNuHi : ν ≤ 1)
    (ω₁ π₁ ω₂ π₂ : ℝ)
    (hOmega1Lo : 0 ≤ ω₁) (hOmega1Hi : ω₁ ≤ 1)
    (hPi1Lo : 0 ≤ π₁) (hPi1Hi : π₁ ≤ 1)
    (hOmega2Lo : 0 ≤ ω₂) (hOmega2Hi : ω₂ ≤ 1)
    (hPi2Lo : 0 ≤ π₂) (hPi2Hi : π₂ ≤ 1) :
    W.Wcred ω₁ π₁ ν - W.Wcred ω₁ π₁ 0 =
    W.Wcred ω₂ π₂ ν - W.Wcred ω₂ π₂ 0 :=
  lemma_independence_gap W ν hNuLo hNuHi ω₁ π₁ ω₂ π₂
    hOmega1Lo hOmega1Hi hPi1Lo hPi1Hi
    hOmega2Lo hOmega2Hi hPi2Lo hPi2Hi

/-- **Lemma~\ref{lem:lizzeri} (Integrated seller-certifier
    rent; extension of Lizzeri 1999).**

    Restatement of the atomic axiom `lemma_lizzeri_bundled_rent`:
    there is a positive bundled-regime rent. -/
theorem lem_lizzeri : ∃ m : ℝ, 0 < m := lemma_lizzeri_bundled_rent

/-- **Lemma~\ref{lem:bertrand} (Bertrand among independent
    certifiers).**

    Composes the three atomic Bertrand-collapse axioms:
    non-negativity, monotonicity, and the bundled-bound at
    `ν = 1`.

    Under Bertrand competition, the rent function
    `m_Bertrand(ν) = mBertrand ν` is monotone non-increasing
    in `ν` and bounded above by the bundled value at `ν = 1`. -/
theorem lem_bertrand (m_bundled : ℝ) (hm : 0 < m_bundled) :
    (∀ ν : ℝ, 0 ≤ mBertrand ν) ∧
    (∀ ν₁ ν₂ : ℝ, 0 ≤ ν₁ → ν₁ ≤ ν₂ → ν₂ ≤ 1 →
      mBertrand ν₂ ≤ mBertrand ν₁) ∧
    mBertrand 1 ≤ m_bundled :=
  ⟨mBertrand_nonneg, mBertrand_monotone, mBertrand_one_le_bundled m_bundled hm⟩

end AccessOrthogonality
