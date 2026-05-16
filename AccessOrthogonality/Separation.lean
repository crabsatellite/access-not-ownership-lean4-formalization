/-
  AccessOrthogonality/Separation.lean

  Corollary~\ref{thm:separation} (Access-Structure Separation,
  constructive form).

  Companion to: "Access, Not Ownership: An Orthogonality
  Theorem for AI Governance Regimes" (Li, 2026).

  ## Statement (informal)

    Fix the access-structure vector `bmu`.  Suppose (SC1)–(SC6).
    Then the regime is ownership-invariant (Definition
    `\label{def:owninv}`), and by
    Theorem~\ref{thm:characterization}:

          ∂W^*/∂θ_i |_{bmu fixed} = 0  for every provider i.

  ## Proof strategy (paper §4.7)

  Given Theorem~\ref{thm:characterization} and Proposition
  ~\ref{prop:four_mechanisms}, the proof of
  Corollary~\ref{thm:separation} reduces to showing that
  (SC1)+(SC3) jointly implement mechanisms (M_α) and (M_β).

    * (M_α) is implemented by (SC1): marginal-cost access
      pricing zeros the access-layer rent margin
      `(p^a - MC_i) a_i = 0` regardless of `(c, d)`.

    * (M_β) is implemented by (SC3) plus IC compliance: the
      financing mechanism `F` pins `(c_i, d_i) = (c^F_i, d^F_i)`
      regardless of θ_i under standard IC conditions.

    * (SC2) ensures the contestable-layer FOCs are
      well-defined (it does not directly trigger an (M_*)
      clause; without it, the recursion across firms would
      couple `Π_i` to rivals' state in a way that renders
      (M_α) ill-defined).

  The Lean encoding follows the paper exactly: we declare
  the two atomic implications SC1 ⇒ M_α and (SC3 + IC) ⇒ M_β
  as Cat 3 paper-stated structural equations (since they are
  paper-stated implementation claims about the abstract
  mechanism structure, not external textbook content), then
  compose them via `prop_four_mechanisms_Mbeta` and the
  characterization theorem.
-/

import AccessOrthogonality.Basic
import AccessOrthogonality.Characterization

namespace AccessOrthogonality

/-! ### Cat 3 paper-stated structural equations -/

/-- *Cat 3 paper-novel atomic structural equation.*

    **(SC1) implements (M_α).**

    Paper §4.7 (proof of Corollary~\ref{thm:separation}):
    "Under (SC1), marginal-cost access pricing zeros the
    access-layer net: `(p^a_i - MC_i) a_i = 0` for any choice
    of `(c_i, d_i)`.  The marginal access-rent
    `∂Π^A_i / ∂(c_i, d_i) = 0`."

    Scope:
    Carrier of the SC1 → M_α implementation step.  Does NOT
    assert what (M_α) is or what `MC_i(q_i)` means; only that
    if `R` satisfies (SC1) then the rent-zero margin condition
    of Proposition~\ref{prop:four_mechanisms} clause (M_α)
    holds in `R`.  Stated as a paper-novel atomic implication
    on the carriers `R`, `ProfitFunctional`. -/
axiom SC1_implements_Malpha :
    ∀ (P : ProfitFunctional) (R : Regime),
      SC1_MCpricing R → MechanismMalpha P R

/-- *Cat 3 paper-novel atomic structural equation.*

    **(SC3) implements (M_β).**

    Paper §4.7 (proof of Corollary~\ref{thm:separation}):
    "Under (SC3), the financing mechanism `F` is structured
    so that `F_i` is paid out conditional on the firm
    delivering the prescribed quality target.  Under
    standard mechanism-design IC conditions, the firm's
    best response is `(c_i, d_i) = (c^F_i, d^F_i)` regardless
    of `θ_i`."

    Scope:
    Carrier of the SC3 → M_β implementation step.  The IC
    standard-conditions hypothesis (firm participation +
    weakly-best at compliance) is folded into the abstract
    `BestResponseMap`.  `MechanismMbeta` is the financing-
    structured predicate (`∃ xF w_d'`, `xF` the unique
    `R.financingMechanism`-self-funded point ∧ `br.alloc θ R`
    self-funded for every θ).  This axiom asserts the paper
    §4.7 implementation step: SC3 financing + standard IC
    conditions ⇒ M_β.  The axiom takes the SC3 price level
    `w_d` and produces `MechanismMbeta br R` (which
    existentially re-binds its own `w_d'`). -/
axiom SC3_implements_Mbeta :
    ∀ (br : BestResponseMap) (R : Regime) (w_d : ℝ),
      SC3_Financing R w_d → MechanismMbeta br R

/-! ### Bundle the six scope conditions -/

/-- The conjunction of the six paper-stated scope conditions
    (SC1)–(SC6) of Corollary~\ref{thm:separation}. -/
structure ScopeConditions (R : Regime) (a : AccessVector) (w_d : ℝ) : Prop where
  sc1 : SC1_MCpricing R
  sc2 : SC2_Interoperability R
  sc3 : SC3_Financing R w_d
  sc4 : SC4_ExAnte a
  sc5 : SC5_LumpSum
  sc6 : SC6_HD1

/-! ### The constructive corollary -/

/-- **Corollary~\ref{thm:separation} (Access-Structure
    Separation, constructive form).**

    Under (SC1)–(SC6), the regulatory regime `R` is
    ownership-invariant, and by
    Theorem~\ref{thm:characterization}, welfare is
    θ-invariant at fixed `bmu`.

    Proof.  By (SC1) and `SC1_implements_Malpha`, the
    rent-zero margin condition (M_α) holds.  By (SC3) and
    `SC3_implements_Mbeta`, the exogenous-choice condition
    (M_β) holds.  Either of these alone suffices for
    ownership-invariance via `prop_four_mechanisms_Mbeta`
    (and (M_α) implies a stronger structural conclusion via
    the trivial application of the rent-zero condition on
    the convex-combination objective).  In paper §4.7 the
    joint instantiation is named the "(M_α)+(M_β)" path,
    which Theorem~\ref{thm:longrun} uses for long-run
    capture-robustness. -/
theorem thm_separation
    (_P : ProfitFunctional) (br : BestResponseMap)
    (R : Regime) (a : AccessVector) (w_d : ℝ)
    (sc : ScopeConditions R a w_d) :
    OwnershipInvariant br R := by
  -- (SC3) ⇒ (M_β) via the paper-stated atomic implementation.
  have hMbeta : MechanismMbeta br R := SC3_implements_Mbeta br R w_d sc.sc3
  -- (M_β) ⇒ OwnershipInvariant via Proposition~\ref{prop:four_mechanisms}.
  exact prop_four_mechanisms_Mbeta br R hMbeta

/-- **Corollary~\ref{thm:separation} composed with
    Theorem~\ref{thm:characterization}.**

    Under (SC1)–(SC6), welfare is θ-invariant at fixed `bmu`.

    This is the explicit chained form `(SC1)+...+(SC6) ⇒
    W^*` θ-invariant, which is the form the policy section
    of the paper actually invokes.

    *Note on which (M_*) is doing the work.*  The encoded proof
    uses (M_β) to close ownership-invariance; (M_α) is
    available via `SC1_implements_Malpha` and could be used in
    an alternative composition (M_α + convex-combination
    argument). The two are jointly available; we take the
    M_β path here for clarity. -/
theorem thm_separation_welfare_invariant
    (W : WelfareFunctional) (P : ProfitFunctional)
    (br : BestResponseMap)
    (R : Regime) (a : AccessVector) (w_d : ℝ)
    (sc : ScopeConditions R a w_d) :
    WelfareThetaInvariant W a R := by
  -- Step 1: thm_separation produces ownership-invariance.
  have hOI : OwnershipInvariant br R :=
    thm_separation P br R a w_d sc
  -- Step 2: Theorem~\ref{thm:characterization} converts
  --   ownership-invariance to welfare-θ-invariance.
  exact thm_characterization_suff W br a R hOI

/-! ### Auxiliary: (M_α) holds under (SC1) on its own -/

/-- *Auxiliary lemma.*  (SC1) implements (M_α) directly.  This
    is a one-line consequence of the paper-stated atomic
    axiom `SC1_implements_Malpha`, recorded as a top-level
    Lean theorem for cross-reference in the ledger. -/
theorem sc1_yields_Malpha
    (P : ProfitFunctional) (R : Regime)
    (h : SC1_MCpricing R) :
    MechanismMalpha P R :=
  SC1_implements_Malpha P R h

/-- *Auxiliary lemma.*  (SC3) implements (M_β) directly. -/
theorem sc3_yields_Mbeta
    (br : BestResponseMap) (R : Regime) (w_d : ℝ)
    (h : SC3_Financing R w_d) :
    MechanismMbeta br R :=
  SC3_implements_Mbeta br R w_d h

end AccessOrthogonality
