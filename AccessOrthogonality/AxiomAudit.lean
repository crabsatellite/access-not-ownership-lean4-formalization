/-
  AccessOrthogonality/AxiomAudit.lean

  Prints the axiom dependency list for every paper-level
  theorem.

  Trust policy.  Every `axiom` declaration in the project
  falls into exactly one of three paper-side categories
  (per `feedback_gap_ledger_in_lean4` v6 four-input-category
  ATOMIC MINIMAL UNITS interpretation):

    Cat 1 — Mathlib-derivable: claim closes via Mathlib +
            kernel.  Must be encoded as `theorem`, not
            `axiom`.  Project has no Cat 1 axioms because
            the Mathlib infrastructure for welfare economics,
            cost-minimisation theory, CES production, IO
            credence-good Bertrand analysis, and the menu-
            auction game-theoretic apparatus is absent; see
            the three `gapBlocked` entries in
            `AccessOrthogonality.Ledger`.

    Cat 2 — External published (textbook / peer-reviewed
            paper): opaque-carrier-bound atomic axiom +
            precise citation.

    Cat 3 — Paper-novel: typed primitive carrier (`axiom`) or
            paper-stated atomic structural equation
            (`axiom`) or paper-introduced hypothesis predicate
            (`def`).  Cited only to Li 2026 labelled
            statements.  v6 sub-classification (live counts;
            see `lake env lean AccessOrthogonality/Ledger.lean`):
            sub-type `carrier` (5 entries: paper-introduced
            typed primitives κ_1, κ_2, s_K, η, m_Bertrand);
            sub-type `hypothesisPredicate` (2 entries, added
            v0.3 §3.4.6: OnSameIsocline + HA7_channels_not_-
            anti_correlated); sub-type `structuralEquation`
            (17 entries: paper-stated atomic defining
            equations on the carriers).  Sub-types
            `workingAssumption` and `conditionalHypothesis`
            are not used (see ledger inventory summary).

  Plus the Lean kernel layer (Cat 0; `propext`,
  `Classical.choice`, `Quot.sound`) provided by Lean /
  Mathlib core.

  Constraints.  No (E) custom-scaffolding axioms (naked
  constants, abstract-type-inhabitation stipulations).  No
  composite axioms bundling multiple independent textbook
  results or hybrid Cat 2 + Cat 3 steps.

  Inventory by category (live counts: see `lake env lean
  AccessOrthogonality/Ledger.lean`):

    Cat 2 propositional axioms (Mas-Colell-Whinston-Green +
    Acemoglu-Restrepo + Lizzeri + Shorrocks + Tirole):
      welfareFactorsThroughAllocation,
      mwg_cost_min_uniqueness_isocline (MWG Prop 5.C.2(v);
        v0.3 §3.4.6 extracted),
      kappa1_pos, kappa2_pos, sK_nonneg,
      shorrocks_additive_decomposition_atomic,
      lizzeri_1999_separate_certifier_rent (Lizzeri 1999
        Prop 1; v0.3 §3.4.6 extracted),
      mBertrand_nonneg, mBertrand_monotone

    Cat 3 propositional structural equations (Li 2026):
      SC1_implements_Malpha, SC3_implements_Mbeta,
      lemma_independence_gap, welfare_gap_at_reference,
      case_1_different_isoclines_implies_BR_invariant
        (paper §4.3 Case 1 contradiction; v0.3 §3.4.6
        extracted from former
        `bestResponseUniqueAtThetaInvariantWelfare` atomic),
      bundled_extension_via_independence
        (integrated-seller-certifier extension via
        `lem:independence`; v0.3 §3.4.6 extracted from
        former `lemma_lizzeri_bundled_rent` atomic),
      channels_exhaust_under_HA7
        (channel-exhaustion under HA-7; v0.3 §3.4.6
        extracted from former `gini_two_channel_partition`
        atomic),
      mBertrand_one_le_bundled (saturated-Bertrand-vs-bundled
        rent comparison; paper-novel composition),
      capital_share_channel_contribution
        (Acemoglu-Restrepo × Korinek-Vipra composition),
      verification_rent_channel_contribution
        (Lizzeri-extension × Bertrand × κ_2 composition),
      lerman_yitzhaki_comonotonicity_translation
        (Lerman-Yitzhaki 1985 × GE_0-bound × first-order
        factor-share linearisation composition),
      long_run_step1_profit_zero,
      long_run_step4_zero_lobbying,
      long_run_step5_mStar_invariance,
      long_run_step5_bmuStar_invariance,
      eta_attenuation_at_zero,
      eta_attenuation_unit_interval

    Cat 3 hypothesis predicates (Li 2026; added v0.3 §3.4.6):
      OnSameIsocline (paper §4.3 Case 1/Case 2 case-split
        discriminator),
      HA7_channels_not_anti_correlated (paper Appendix A.2
        HA-7 working assumption)

    Cat 3 carrier axioms (Li 2026):
      kappa1, kappa2, sK, eta_attenuation, mBertrand

    Derived theorems closing v0.3 §3.4.6 decompositions:
      bestResponseUniqueAtThetaInvariantWelfare
        (composes OnSameIsocline + mwg_cost_min_uniqueness_-
        isocline + case_1_different_isoclines_implies_BR_-
        invariant),
      lemma_lizzeri_bundled_rent
        (composes lizzeri_1999_separate_certifier_rent +
        bundled_extension_via_independence),
      gini_two_channel_partition
        (composes HA7_channels_not_anti_correlated +
        channels_exhaust_under_HA7)

  Per-axiom citations live in the corresponding `axiom`
  docstring in the source file.  Round-history lives in
  `gap_*.attackHistory` fields inside
  `AccessOrthogonality.Ledger`.

  Per-theorem axiom dependency profile (verified by `#print
  axioms` below):

    * Lean kernel only (`propext`, `Classical.choice`,
      `Quot.sound`):
        prop_four_mechanisms_Mbeta,
        prop_four_mechanisms_Mgamma,
        prop_four_mechanisms_Mdelta,
        thm_gini_theta_invariance.

    * Lean kernel + Cat 3 (paper-novel) atomics:
        thm_characterization_suff (uses
          welfareFactorsThroughAllocation),
        thm_separation (uses SC3_implements_Mbeta),
        thm_separation_welfare_invariant (uses both above),
        thm_longrun (composes static + long-run Cat 3
          atomics),
        thm_longrun_policy_invariance (uses
          long_run_step5_policy_invariance),
        prop_multi_agency.

    * Lean kernel + Cat 2 (external textbook) + Cat 3
      (paper-novel) atomics (mixed; reflects v0.3 §3.4.6
      decomposition of the Cat 3 single-atomic Case 1+Case 2
      bridge into proper Cat 2 + Cat 3 chain):
        thm_characterization_nec (uses derived
          `bestResponseUniqueAtThetaInvariantWelfare`, which
          itself depends on Cat 3 hypothesisPredicate
          OnSameIsocline + Cat 2 mwg_cost_min_uniqueness_-
          isocline + Cat 3 structural case_1_different_-
          isoclines_implies_BR_invariant),
        thm_characterization (composes both directions),
        thm_gini (composes capital-share-channel,
          verification-rent-channel, Shorrocks via derived
          `gini_two_channel_partition` which itself depends
          on Cat 3 hypPred HA7_channels_not_anti_correlated
          + Cat 3 structural channels_exhaust_under_HA7),
        cor_gini (composes thm_gini with Lerman-Yitzhaki),
        thm_gini_bound_mono_mu / mono_nu (pure real-arith
          using kappa1, sK as carrier-typed primitives but
          no axiom-instantiation).

    * Lean kernel + Cat 2 + Cat 3 (mixed):
        thm_t4_binding (composes derived
          `lemma_lizzeri_bundled_rent` — which itself
          depends on Cat 2 lizzeri_1999_separate_certifier_-
          rent + Cat 3 bundled_extension_via_independence,
          lemma_bertrand_collapse, lemma_independence_gap,
          welfare_gap_at_reference),
        thm_t4_binding_at_boundary,
        lem_independence (restatement of Cat 3 atomic),
        lem_lizzeri (restatement of derived
          `lemma_lizzeri_bundled_rent`),
        lem_bertrand (restatement of Cat 2 atomic),
        single_lever_bound (uses eta_attenuation_unit_interval),
        lambdaEff_at_zero (uses eta_attenuation_at_zero),
        thm_antitipping (composes single_lever_bound).

  Any axiom outside the inventory above is a RED FLAG —
  investigate.

  Usage:
    lake exe cache get
    lake env lean AccessOrthogonality/AxiomAudit.lean
-/

import AccessOrthogonality

-- Theorem~\ref{thm:characterization} (and its directions).
#print axioms AccessOrthogonality.thm_characterization_suff
#print axioms AccessOrthogonality.thm_characterization_nec
#print axioms AccessOrthogonality.thm_characterization

-- Proposition~\ref{prop:four_mechanisms} (each clause).
#print axioms AccessOrthogonality.prop_four_mechanisms_Mbeta
#print axioms AccessOrthogonality.prop_four_mechanisms_Mgamma
#print axioms AccessOrthogonality.prop_four_mechanisms_Mdelta

-- Corollary~\ref{thm:separation}.
#print axioms AccessOrthogonality.thm_separation
#print axioms AccessOrthogonality.thm_separation_welfare_invariant

-- Theorem~\ref{thm:gini} and Corollary~\ref{cor:gini}.
#print axioms AccessOrthogonality.thm_gini
#print axioms AccessOrthogonality.thm_gini_theta_invariance
#print axioms AccessOrthogonality.cor_gini
#print axioms AccessOrthogonality.thm_gini_bound_mono_mu
#print axioms AccessOrthogonality.thm_gini_bound_mono_nu

-- Theorem~\ref{thm:antitipping}.
#print axioms AccessOrthogonality.single_lever_bound
#print axioms AccessOrthogonality.lambdaEff_at_zero
#print axioms AccessOrthogonality.thm_antitipping

-- Theorem~\ref{thm:t4_binding} and its lemmas.
#print axioms AccessOrthogonality.thm_t4_binding
#print axioms AccessOrthogonality.thm_t4_binding_at_boundary
#print axioms AccessOrthogonality.lem_independence
#print axioms AccessOrthogonality.lem_lizzeri
#print axioms AccessOrthogonality.lem_bertrand

-- Theorem~\ref{thm:longrun} and Proposition~\ref{prop:multi_agency}.
#print axioms AccessOrthogonality.thm_longrun
#print axioms AccessOrthogonality.thm_longrun_policy_invariance
#print axioms AccessOrthogonality.prop_multi_agency
