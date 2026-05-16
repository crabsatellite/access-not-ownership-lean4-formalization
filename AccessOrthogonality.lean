/-
  AccessOrthogonality.lean

  Root module. Machine-checked formalization of the six labelled
  paper-level results of:

    Li, Alex. "Access, Not Ownership: An Orthogonality Theorem
              for AI Governance Regimes." 2026.

  Submodules:
    AccessOrthogonality/Basic.lean
      Section "Setup" + Definition `def:regime` + Definition
      `def:owninv` + provider profit / welfare scaffolding.
    AccessOrthogonality/Characterization.lean
      Theorem~\ref{thm:characterization} + Proposition
      ~\ref{prop:four_mechanisms} (four mechanisms M_α, M_β,
      M_γ, M_δ for ownership-invariance).
    AccessOrthogonality/Separation.lean
      Corollary~\ref{thm:separation} (constructive form;
      (SC1)+(SC3) ⇒ ownership-invariant via (M_α)+(M_β)).
    AccessOrthogonality/Gini.lean
      Theorem~\ref{thm:gini} (GE_0 inequality bound) and
      Corollary~\ref{cor:gini} (Gini under monotone rank
      correlation, Lerman-Yitzhaki 1985 comonotonicity).
    AccessOrthogonality/AntiTipping.lean
      Theorem~\ref{thm:antitipping} (anti-tipping under structural
      decoupling) + closed-form Λ_eff(ω,π,ν) + single-lever bound.
    AccessOrthogonality/Binding.lean
      Theorem~\ref{thm:t4_binding} (verification-binding) +
      Lemma~\ref{lem:independence} (credence-good gap independence)
      + Lemma~\ref{lem:lizzeri} (integrated seller-certifier rent)
      + Lemma~\ref{lem:bertrand} (Bertrand among certifiers).
    AccessOrthogonality/LongRun.lean
      Theorem~\ref{thm:longrun} (long-run orthogonality under
      (M_α)+(M_β)) + Proposition~\ref{prop:multi_agency}
      (multi-agency robustness).

  Soundness audit:
    AccessOrthogonality/AxiomAudit.lean — prints axiom
    dependencies of every paper-level theorem.  Expected: only
    `propext`, `Classical.choice`, `Quot.sound`, plus the
    explicitly declared Cat 2 / Cat 3 atomic axioms whose
    citations live in their docstrings.

  Gap ledger:
    AccessOrthogonality/Ledger.lean — typed record of every
    atomic axiom, every Cat 3 carrier, every blocked route, and
    every closed top-level result.  Three orthogonal
    classifications per entry:
      * 7-tier status: gapOpen / gapPartial / gapBlocked /
                       gapDeadEnd / gapClosed /
                       gapClosedConditional / gapDefinitional
      * 4-input-category: cat1Mathlib / cat2External /
                          cat3PaperNovel / notInput
      * Cat 3 sub-type: carrier / hypothesisPredicate /
                        structuralEquation / workingAssumption /
                        conditionalHypothesis /
                        phenomenologicalConjecture / notCat3
-/

import AccessOrthogonality.Basic
import AccessOrthogonality.Characterization
import AccessOrthogonality.Separation
import AccessOrthogonality.Gini
import AccessOrthogonality.AntiTipping
import AccessOrthogonality.Binding
import AccessOrthogonality.LongRun
