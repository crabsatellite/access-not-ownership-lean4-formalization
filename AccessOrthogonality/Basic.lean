/-
  AccessOrthogonality/Basic.lean

  Primitives, definitions, and structural scaffolding for:

    Li, Alex. "Access, Not Ownership: An Orthogonality Theorem
              for AI Governance Regimes." 2026.

  This file builds the carriers used by every downstream
  theorem file:
    * `Provider`, `OwnershipType` — provider population
       indexed by ownership-type θ ∈ [0,1].
    * `AccessVector` — the access-structure vector
       bmu = (ω, π, ν) ∈ [0,1]^3 of Definition (paper §3.2).
    * `Regime` (`\label{def:regime}`) — the four-tuple
       R = (P_a, F, S, X) of access-pricing, financing,
       structural-separation, and external-constraint rules.
    * `OwnershipInvariant` (`\label{def:owninv}`) — predicate
       on regimes saying provider's best response is θ-blind.
    * Provider profit / welfare scaffolding used by
       `Characterization.lean`, `LongRun.lean`.

  *Naming convention.* We retain ASCII / paper-symbol mirror:

      paper     →  Lean
      ─────────────────
      bmu       →  AccessVector / `accVec`
      (ω,π,ν)   →  (.omega, .pi, .nu)
      θ_i       →  Provider.theta
      R         →  Regime
      W^*       →  welfare (a real-valued functional)
      Π_i       →  providerProfit
      C^Q_i     →  qualityCost
      F_i       →  financing
      ∂/∂θ_i    →  derivative wrt theta i

  *No genuine mathematics is asserted in this file.* All
  load-bearing content (theorems, propositions, lemmas) lives
  in the per-theorem files.  This file only houses the typed
  carriers + abstract Prop / functional fields that the
  theorems quantify over.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.NormNum

namespace AccessOrthogonality

/-! ### Ownership-type θ ∈ [0,1] -/

/-- Ownership-weight `θ ∈ [0,1]`.  Paper §3.1: `θ_i = 0` is a
    fully private (profit-maximising) provider; `θ_i = 1` is a
    fully public (welfare-maximising) provider.  Carried as a
    subtype of `ℝ` with `0 ≤ θ ≤ 1`. -/
structure OwnershipType where
  val : ℝ
  hLo : 0 ≤ val
  hHi : val ≤ 1

namespace OwnershipType

/-- The fully private endpoint `θ = 0`. -/
def zero : OwnershipType := ⟨0, le_refl 0, by norm_num⟩

/-- The fully public endpoint `θ = 1`. -/
def one : OwnershipType := ⟨1, by norm_num, le_refl 1⟩

/-- Coercion to `ℝ`. -/
instance : Coe OwnershipType ℝ := ⟨val⟩

end OwnershipType

/-! ### The access-structure vector `bmu = (ω,π,ν) ∈ [0,1]^3`
       — paper Definition `\label{def:access_structure}`
       (Definition "Access structure", §3.2). -/

/--
  `AccessVector`: three-dimensional access-structure vector.

  Components are:
  * `omega` (ω) — weight-openness; share of frontier deployments
                  under permissive open-weight licences.
  * `pi`    (π) — compute portability; HHI of compute spend
                  weighted by workload migrability.
  * `nu`    (ν) — verification unbundling; count of independent
                  eval-providers (weighted by throughput share).

  Each component ranges in `[0,1]` (paper §3.2 + §B operational
  coding).  The vector form is load-bearing whenever
  Theorem~\ref{thm:t4_binding} applies; the scalar reduction
  `μ = ω·π·ν` (product form) is the default; `μ = min(ω,π,ν)`
  is the alternative bottleneck form.
-/
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

namespace AccessVector

variable (a : AccessVector)

/-- Default scalar reduction `μ = ω·π·ν`.  Paper §3.2.  Any
    factor at zero kills `μ`; matches the verification-binding
    behaviour at the boundary `(ω,π) = (1,1), ν = 0` of
    Theorem~\ref{thm:t4_binding}. -/
def muProduct : ℝ := a.omega * a.pi * a.nu

/-- Alternative bottleneck reduction `μ = min(ω, π, ν)`.  Sharper
    than the product reduction; treated by the paper as a
    pessimistic baseline. -/
def muBottleneck : ℝ := min (min a.omega a.pi) a.nu

/-- `0 ≤ ω·π·ν`.  Multiplication of three non-negatives. -/
lemma muProduct_nonneg : 0 ≤ a.muProduct := by
  unfold muProduct
  exact mul_nonneg (mul_nonneg a.hOmegaLo a.hPiLo) a.hNuLo

/-- `ω·π·ν ≤ 1`. -/
lemma muProduct_le_one : a.muProduct ≤ 1 := by
  unfold muProduct
  -- a.omega * a.pi ≤ 1 * 1 = 1.
  have h1 : a.omega * a.pi ≤ 1 := by
    have hOmegaPi : a.omega * a.pi ≤ 1 * 1 :=
      mul_le_mul a.hOmegaHi a.hPiHi a.hPiLo (by norm_num)
    simpa using hOmegaPi
  -- (a.omega * a.pi) * a.nu ≤ 1 * 1 = 1.
  have h2 : a.omega * a.pi * a.nu ≤ 1 * 1 :=
    mul_le_mul h1 a.hNuHi a.hNuLo (by norm_num)
  simpa using h2

/-- `0 ≤ min(ω, π, ν)`. -/
lemma muBottleneck_nonneg : 0 ≤ a.muBottleneck := by
  unfold muBottleneck
  exact le_min (le_min a.hOmegaLo a.hPiLo) a.hNuLo

end AccessVector

/-! ### Provider population & investment choice

    The provider chooses `(c_i, d_i)` (compute, data) for its
    quality dynamics; the resource cost is `C^Q_i = c_i + w_d d_i`
    (paper §3.1, with normalisation `r_c = 1`).  We carry
    investment as an abstract pair in `ℝ × ℝ` for now; the
    Cobb-Douglas quality dynamics `q̇ = α c^β d^γ q^δ` is
    referenced abstractly in the theorem files. -/

/-- Provider's investment choice `(c, d) ∈ ℝ_{≥0} × ℝ_{≥0}`.  We
    follow paper §3.1 in carrying both compute and data as
    non-negative reals; the resource-cost function is
    `C^Q_i = c + w_d · d` under the `r_c = 1` normalisation. -/
structure Investment where
  c : ℝ
  d : ℝ
  hC : 0 ≤ c
  hD : 0 ≤ d

namespace Investment

variable (x : Investment)

/-- Resource cost `C^Q = c + w_d · d` (paper §3.1).  Stated in
    `ℝ` (allowing $w_d \in \mathbb R$ as a model parameter,
    though the paper assumes `w_d > 0`). -/
def qualityCost (w_d : ℝ) : ℝ := x.c + w_d * x.d

end Investment

/-! ### Regulatory regime `R = (P_a, F, S, X)`
       — paper Definition `\label{def:regime}`. -/

/--
  `Regime`: regulatory tuple `R = (P_a, F, S, X)` per
  Definition `\label{def:regime}`.

  * `pricingRule` (`P_a`): determines provider `i`'s access
    price `p^a_i` as a function of `(bmu, q_i, MC_i)` and
    rivals' state.  Modelled abstractly as a function from
    a (state-vector, access-vector) pair to the access price.
  * `financingMechanism` (`F`): determines the financing
    allowance `F_i` and any conditionality on quality outputs.
  * `separationRule` (`S`): determines the effective
    returns-to-scale exponent on the contestable layer
    (paper §3.4 — SC2 implementation via interoperability
    mandate).
  * `externalConstraints` (`X`): capacity caps, export
    controls, etc.  Default `X = ∅`.

  All four are kept as abstract function-typed fields; the
  theorem files only quantify over their existence and
  abstract properties (e.g., "MC-pricing rule", "exogenous
  financing mechanism").
-/
structure Regime where
  /-- Access price as function of provider state.  Opaque
      function; specific rules (SC1: `p^a = MC`) instantiate
      it via abstract predicates in `Separation.lean`. -/
  pricingRule : ℝ → ℝ → ℝ → ℝ
  /-- Financing mechanism: financing allowance `F_i` as a
      function of the provider's investment choice. -/
  financingMechanism : Investment → ℝ
  /-- Effective returns-to-scale exponent on the contestable
      layer.  Paper §3.4 (SC2): structural-separation rule
      pins this to `Λ^eff ≤ 1`.  Carried as a real-valued
      parameter (paper-level meaning: the eigenvalue of the
      asymmetric-mode growth dynamics in
      Theorem~\ref{thm:antitipping}). -/
  effectiveScaleExponent : ℝ
  /-- External constraint set, modeled as a predicate on
      investment.  Empty constraint = constant `True`. -/
  externalConstraints : Investment → Prop

/-! ### Provider primitive + objective

    Each provider has:
    * an ownership-type `θ` ∈ `OwnershipType`;
    * a profit functional `Π_i(c, d, θ, R)`;
    * a welfare contribution `W_i(c, d, R)` (θ-independent
      by paper §3.1 welfare-functional definition).

    The objective is `U_i = (1-θ)Π + θW`.  We carry profit
    and welfare as opaque functionals; the theorems quantify
    over their gradient / invariance properties. -/

/-- Best-response allocation map of a single provider given
    ownership-type `θ` and regime `R`.  Models the optimal
    investment choice `(c^*, d^*) ∈ Investment` solving the
    provider's optimisation problem.

    The `Characterization.lean` theorem statement quantifies
    over the existence of this map; the constructive corollary
    (`Separation.lean`) provides the explicit best-response
    under (SC1)+(SC3) as the financing-mechanism's pinned
    allocation. -/
structure BestResponseMap where
  /-- Allocation as a function of (θ, R). -/
  alloc : OwnershipType → Regime → Investment

/-- *Ownership-invariance predicate* (paper Definition
    `\label{def:owninv}`).

    A regulatory regime `R` is *ownership-invariant* if the
    firm's best-response allocation `(c^*(θ, R), d^*(θ, R))`
    does NOT depend on `θ` at the equilibrium of `R`.

    Stated as: there exists a single allocation `inv` such
    that for every `θ`, the best-response equals `inv`. -/
def OwnershipInvariant (br : BestResponseMap) (R : Regime) : Prop :=
  ∃ inv : Investment, ∀ θ : OwnershipType, br.alloc θ R = inv

/-! ### The welfare functional `W^*(θ, bmu, R)`

    Paper §3.3 defines `W = CS + Σ Π_i - T` with lump-sum
    transfers (SC5) making `T = 0` welfare-neutral.  At the
    equilibrium of `(θ, bmu, R)`, the welfare functional is
    written `W^*(θ, bmu, R) ∈ ℝ`.

    For the structural theorems we carry `W^*` as an opaque
    `ℝ`-valued functional and quantify over its θ-derivative
    via `WelfareIsOwnershipBlind` below. -/

/-- Equilibrium welfare `W^*(θ, bmu, R)`. -/
structure WelfareFunctional where
  /-- Welfare at equilibrium.  All structural results
      Theorem~\ref{thm:characterization}, ~\ref{thm:gini},
      ~\ref{thm:longrun} are stated in terms of this
      functional. -/
  W : OwnershipType → AccessVector → Regime → ℝ

/-- *Welfare is θ-blind at fixed `(bmu, R)`* — the conclusion
    of Theorem~\ref{thm:characterization}.

    Stated as: for every fixed access-vector `bmu` and regime
    `R`, the function `θ ↦ W^*(θ, bmu, R)` is constant in
    `θ`. -/
def WelfareThetaInvariant (W : WelfareFunctional) (a : AccessVector)
    (R : Regime) : Prop :=
  ∀ θ₁ θ₂ : OwnershipType, W.W θ₁ a R = W.W θ₂ a R

/-! ### Provider profit & utility

    `Π_i = (p^a - MC_i) a_i + F_i - C^Q_i`
    `U_i = (1 - θ_i) Π_i + θ_i W^*`. -/

/-- Provider equilibrium profit `Π_i^*(c, d, θ, R)`. -/
structure ProfitFunctional where
  /-- Profit at the equilibrium of regime `R` given investment
      `(c, d)`, ownership-type `θ`.  Note that under (SC1)+(SC3)
      this collapses to zero (paper §4.7 "Why ∇Π_i = 0 under
      (SC1)+(SC3)"), which is the rent-zero margin condition
      `(M_α)` of Proposition~\ref{prop:four_mechanisms}. -/
  Pi : Investment → OwnershipType → Regime → ℝ

/-- *Rent-zero margin* `(M_α)` (Proposition
    `\label{prop:four_mechanisms}` clause (M_α)).

    Paper §3.3 form: `∇_{(c_i,d_i)} Π_i = 0` (marginal-rent
    sense; profit gradient on the access-rent margin is
    zero).  Long-run Step 1 strengthens this to uniform-rent
    sense `Π_i^*(m) = 0` (paper Step 1: "Hence provider
    profit `Π_i^*(m) = ... = 0` uniformly in `m`").

    Lean encoding choice (audit R6 honesty).  We encode the
    *uniform-rent* form `P.Pi x θ R = 0` for all `(x, θ)`,
    matching the long-run Step 1 strengthening.  This is
    stronger than the static-only Prop `\label{prop:four_mechanisms}`
    clause (M_α) marginal form.  The static-only marginal
    form is `prop_four_mechanisms_Mbeta` via the
    operational consequence path used in `thm_separation`. -/
def MechanismMalpha (P : ProfitFunctional) (R : Regime) : Prop :=
  ∀ (x : Investment) (θ : OwnershipType), P.Pi x θ R = 0

/-- *Exogenous choice* `(M_β)` (Proposition
    `\label{prop:four_mechanisms}` clause (M_β)).

    Paper §3.3: the regulator's financing mechanism pins
    `(c_i, d_i)` regardless of `θ_i`.  Lean encoding is the
    direct operational form `∃ x, ∀ θ, alloc θ R = x`. -/
def MechanismMbeta (br : BestResponseMap) (R : Regime) : Prop :=
  ∃ x : Investment, ∀ θ : OwnershipType, br.alloc θ R = x

/-- *Gradient alignment* `(M_γ)` (Proposition
    `\label{prop:four_mechanisms}` clause (M_γ)).

    Paper §3.3: at the equilibrium, `∇_{(c_i,d_i)} Π_i =
    ∇_{(c_i,d_i)} W` on the investment variables.  Lean
    encoding is the OPERATIONAL CONSEQUENCE form: "the
    convex-combination objective `(1-θ)Π + θW` has
    θ-invariant best-response", which by paper FOC analysis
    follows from `∇Π = ∇W`.

    Honest scope note (audit R6).  The Lean type of (M_γ)
    coincides with (M_β) — both say `∃ x, ∀ θ, alloc θ R =
    x`.  The paper-level distinction is in the MECHANISM
    that produces the operational form: (M_β) by mechanism
    (regulator pins choice), (M_γ) by FOC (gradients align,
    so the convex-combination's optimum is θ-invariant).
    Lean cannot distinguish the mechanisms at the
    propositional level without a richer carrier; the
    Lean-level coincidence is honest about this. -/
def MechanismMgamma (br : BestResponseMap) (R : Regime) : Prop :=
  ∃ x : Investment, ∀ θ : OwnershipType, br.alloc θ R = x

/-- *Constraint-set invariance* `(M_δ)` (Proposition
    `\label{prop:four_mechanisms}` clause (M_δ)).

    Paper §3.3: the firm's feasible action set is restricted
    by an external constraint that binds for all
    `θ_i ∈ [0,1]` at the same allocation (e.g., hardware-
    export controls, data-residency rules, capacity caps).

    Honest scope note (audit R6).  As with (M_γ), the Lean
    type coincides with (M_β).  Paper-level distinction is
    in the MECHANISM (external constraint set, not regulator
    financing), which Lean cannot carry without a richer
    representation of "feasibility set". -/
def MechanismMdelta (br : BestResponseMap) (R : Regime) : Prop :=
  ∃ x : Investment, ∀ θ : OwnershipType, br.alloc θ R = x

/-! ### The six paper-stated scope conditions (SC1)–(SC6)

    From Corollary~\ref{thm:separation}.  Each is carried as a
    Prop-valued field on `(Regime, AccessVector)`.  Specific
    consequences (e.g., SC1 ⇒ M_α) are formalised via the
    Cat 2 / Cat 3 atomic axioms in the per-theorem files. -/

/-- **(SC1)** Marginal-cost access pricing: `p^a_i = MC_i` for
    all providers.  Paper §4 (Corollary `\label{thm:separation}`). -/
def SC1_MCpricing (R : Regime) : Prop := ∀ q mc : ℝ, R.pricingRule q mc 0 = mc

/-- **(SC2)** Interoperability mandate: `Λ^eff ≤ 1` on the
    contestable layer.  Paper §4 (Corollary
    `\label{thm:separation}`). -/
def SC2_Interoperability (R : Regime) : Prop := R.effectiveScaleExponent ≤ 1

/-- **(SC3)** Frontier financing: exogenous mechanism `F` funds
    frontier fixed costs.  Stated abstractly as existence of
    an investment `x_F` such that `F(x_F) = C^Q(x_F)` (the
    canonical regulated-utility-with-sunset instance).  The
    "exogenous to provider's decision" content is captured by
    the (M_β) implementation in `Separation.lean`. -/
def SC3_Financing (R : Regime) (w_d : ℝ) : Prop :=
  ∃ xF : Investment, R.financingMechanism xF = xF.qualityCost w_d

/-- **(SC4)** Ex-ante operational `bmu`: the access-structure
    components are operationally defined before any welfare
    claim is made (paper §3.2).  Carried as a placeholder Prop
    `True` because Lean cannot verify "before any welfare
    claim is made" — this is a methodological side-condition. -/
def SC4_ExAnte (_ : AccessVector) : Prop := True

/-- **(SC5)** Lump-sum transferability.  Carried as a
    placeholder Prop `True` because this is a standard
    Mathlib-orthogonal welfare-economics assumption (second
    welfare theorem applies). -/
def SC5_LumpSum : Prop := True

/-- **(SC6)** Downstream homogeneity-of-degree-one: production
    is HD-1 in access `a_j` conditional on `k_j`.  Carried as
    a placeholder Prop `True`; the operational content is
    captured by the abstract welfare functional being
    well-defined. -/
def SC6_HD1 : Prop := True

end AccessOrthogonality
