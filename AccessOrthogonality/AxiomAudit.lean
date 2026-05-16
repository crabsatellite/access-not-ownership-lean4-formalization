/-
  AccessOrthogonality/AxiomAudit.lean

  Prints the axiom dependency list for every paper-level
  theorem.

  Trust policy.  Every `axiom` declaration in the project
  falls into exactly one of three paper-side categories:

    Cat 1 — Mathlib-derivable: claim closes via Mathlib +
            kernel.  Must be encoded as `theorem`, not
            `axiom`.  Project has no Cat 1 axioms because
            the Mathlib infrastructure for welfare economics,
            cost-minimisation theory, CES production, IO
            credence-good Bertrand analysis, and the menu-
            auction game-theoretic apparatus is absent; see
            the `gapBlocked` entries in
            `AccessOrthogonality.Ledger`.

    Cat 2 — External published (textbook / peer-reviewed
            paper): opaque-carrier-bound atomic axiom +
            precise citation.

    Cat 3 — Paper-novel: typed primitive carrier (`axiom`),
            paper-stated atomic structural equation
            (`axiom`), or paper-introduced hypothesis
            predicate (opaque `axiom`).  Cited only to
            Li 2026 labelled statements.  Sub-classification —
            live counts via `#eval cat3SubTypeCounts` in
            `AccessOrthogonality.Ledger`: sub-type `carrier`
            (paper-introduced typed primitives κ_1, κ_2, s_K,
            η, m_Bertrand, ProfitWelfareGradientAlign);
            sub-type `hypothesisPredicate` (OnSameIsocline,
            HA7_channels_not_anti_correlated,
            IsLongRunEquilibriumOf, SC4_ExAnte, SC5_LumpSum,
            SC6_HD1); sub-type `structuralEquation` (the
            paper-stated atomic implications, including
            kappa1_pos, kappa2_pos, sK_nonneg,
            mBertrand_nonneg, mBertrand_monotone).  Sub-type
            `phenomenologicalConjecture` has live count 0 —
            this is a derivational-economics paper.  Sub-types
            `workingAssumption` and `conditionalHypothesis`
            are not used (live count 0).  See `#eval` for the
            authoritative numbers — this narrative names
            entries, not counts, to avoid count-drift.

  Plus the Lean kernel layer (Cat 0; `propext`,
  `Classical.choice`, `Quot.sound`) provided by Lean /
  Mathlib core.

  Constraints.  No (E) custom-scaffolding axioms (naked
  constants, abstract-type-inhabitation stipulations).  No
  composite axioms bundling multiple independent textbook
  results or hybrid Cat 2 + Cat 3 steps.

  Inventory by category (live counts: see `lake env lean
  AccessOrthogonality/Ledger.lean`).

    Cat 2 propositional axioms (genuinely external published):
      welfareFactorsThroughAllocation
        (definitional accounting identity; MWG 1995 §10.D /
        §16.F supplied as background reference for primitives),
      mwg_cost_min_uniqueness_isocline (MWG 1995 §5.D
        + elementary convex analysis),
      lizzeri_1999_separate_certifier_rent (Lizzeri 1999
        RAND 30(2) Prop 1)

    Cat 3 propositional structural equations (Li 2026):
      SC1_implements_Malpha, SC3_implements_Mbeta,
      gradientAlign_implies_ownership_invariant
        (paper §3.3 (M_γ) FOC argument),
      lemma_independence_gap, welfare_gap_at_reference,
      case_1_different_isoclines_implies_BR_invariant
        (paper §4.3 Case 1 contradiction),
      bundled_extension_via_independence
        (integrated-seller-certifier extension via
        `lem:independence`),
      channels_exhaust_under_HA7
        (channel-exhaustion under HA-7),
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
      eta_attenuation_unit_interval,
      kappa1_pos, kappa2_pos, sK_nonneg
        (closed-form parametrizations / definitional
        non-negativity on paper-introduced primitives),
      mBertrand_nonneg, mBertrand_monotone
        (definitional / pure-arithmetic facts on the
        paper-introduced primitive `mBertrand`)

    Cat 3 hypothesis predicates (Li 2026):
      OnSameIsocline (paper §4.3 Case 1/Case 2 case-split
        discriminator),
      HA7_channels_not_anti_correlated (paper Appendix A.2
        HA-7 working assumption; downstream theorems
        propagate HA-7 as explicit hypothesis),
      IsLongRunEquilibriumOf (paper §7.3 Step 5 long-run
        equilibrium-of-regime predicate),
      SC4_ExAnte, SC5_LumpSum, SC6_HD1 (paper-stated
        scope-condition predicates)

    Cat 3 carrier axioms (Li 2026):
      kappa1, kappa2, sK, eta_attenuation, mBertrand,
      ProfitWelfareGradientAlign

    Derived theorems closing the Cat 3 decompositions:
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
  docstring in the source file.

  Per-theorem axiom dependency profile (verified by `#print
  axioms` below):

    * Lean kernel only (`propext`, `Classical.choice`,
      `Quot.sound`):
        prop_four_mechanisms_Mbeta (FOC-free derivation on
          the financing-structured M_β predicate — depends
          on no project axioms),
        prop_four_mechanisms_Mdelta (FOC-free derivation on
          the external-constraint-structured M_δ predicate —
          depends on no project axioms),
        thm_gini_theta_invariance.

    * Lean kernel + Cat 3 (paper-novel) atomics:
        prop_four_mechanisms_Mgamma (M_γ is the opaque Cat 3
          carrier `ProfitWelfareGradientAlign P W br R`;
          depends on that carrier + the Cat 3
          structuralEquation axiom
          `gradientAlign_implies_ownership_invariant` — the
          paper M_γ FOC argument, parallel to
          SC1_implements_Malpha / SC3_implements_Mbeta),
        thm_characterization_suff (uses
          welfareFactorsThroughAllocation),
        thm_separation (uses SC3_implements_Mbeta + Cat 3
          opaque-axiom predicates SC4_ExAnte / SC5_LumpSum /
          SC6_HD1 via ScopeConditions struct),
        thm_separation_welfare_invariant (composes
          thm_separation with thm_characterization_suff),
        thm_longrun (composes static + long-run Cat 3
          atomics: long_run_step1_profit_zero +
          long_run_step4_zero_lobbying +
          welfareFactorsThroughAllocation),
        thm_longrun_policy_invariance (composes the two
          split atomics long_run_step5_mStar_invariance +
          long_run_step5_bmuStar_invariance under
          IsLongRunEquilibriumOf hypothesis),
        prop_multi_agency.

    * Lean kernel + Cat 2 (external textbook) + Cat 3
      (paper-novel) atomics:
        thm_characterization_nec (uses derived
          `bestResponseUniqueAtThetaInvariantWelfare`, which
          itself depends on Cat 3 hypothesisPredicate
          OnSameIsocline + Cat 2 mwg_cost_min_uniqueness_-
          isocline + Cat 3 structural case_1_different_-
          isoclines_implies_BR_invariant),
        thm_characterization (composes both directions),
        thm_gini (composes capital_share_channel_-
          contribution + verification_rent_channel_-
          contribution via derived `gini_two_channel_-
          partition` which itself depends on Cat 3 hypPred
          HA7_channels_not_anti_correlated + Cat 3 structural
          channels_exhaust_under_HA7),
        cor_gini (composes thm_gini with Lerman-Yitzhaki),
        thm_gini_bound_mono_mu / mono_nu (pure real-arith
          using kappa1, sK as carrier-typed primitives but
          no axiom-instantiation).

    * Lean kernel + Cat 2 + Cat 3 (mixed):
        thm_t4_binding (composes Cat 2 lizzeri_1999_separate_-
          certifier_rent + Cat 3 atomics
          {bundled_extension_via_independence, mBertrand,
          mBertrand_one_le_bundled, lemma_independence_gap,
          welfare_gap_at_reference}),
        thm_t4_binding_at_boundary (same dep set as
          thm_t4_binding),
        lem_independence (restatement of Cat 3 atomic),
        lem_lizzeri (restatement of derived
          `lemma_lizzeri_bundled_rent`),
        lem_bertrand (composes Cat 3 atomics
          {mBertrand, mBertrand_nonneg, mBertrand_monotone,
          mBertrand_one_le_bundled}),
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
