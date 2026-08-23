/- Proof-carrying ledger for every numbered formal object in the journal paper. -/

import AccessOrthogonality.CurrentPaperExactness

namespace AccessOrthogonality.CurrentPaper.Ledger

open AccessOrthogonality.CurrentPaper

inductive ObjectKind where
  | definition
  | assumption
  | theorem
  | proposition
  | corollary
  | lemma
  | remark
  deriving DecidableEq, BEq, Repr

inductive Evidence where
  | definitional
  | assumed
  | proved (statement : Prop) (proof : statement)
  | boundary
  | unformalized

def Evidence.isUnfinished : Evidence → Bool
  | .unformalized => true
  | _ => false

def Evidence.isDerived : Evidence → Bool
  | .proved _ _ => true
  | _ => false

structure Entry where
  number : Nat
  kind : ObjectKind
  label : String
  title : String
  binding : String
  evidence : Evidence

def FlatWelfareClaim : Prop :=
  ∃ dW_dTheta dW_dq dq_dTheta : ℝ,
    dW_dTheta = dW_dq * dq_dTheta ∧
      dW_dTheta = 0 ∧ dW_dq = 0 ∧ dq_dTheta ≠ 0

def entryAccess : Entry :=
  ⟨1, .definition, "def:access-structure", "Access structure",
    "AccessStructure; AccessVector", .definitional⟩

def entryWelfare : Entry :=
  ⟨2, .definition, "def:welfare", "Welfare",
    "WelfareComponents; totalWelfare", .definitional⟩

def entryRegime : Entry :=
  ⟨3, .definition, "def:regime", "Regulatory regime",
    "Regime", .definitional⟩

def entryOwnershipInvariant : Entry :=
  ⟨4, .definition, "def:owninv", "Ownership-invariant mechanism",
    "paper_global_ownership_invariance_exact; paper_local_ownership_invariance_exact",
    .definitional⟩

def entryLocalIdentification : Entry :=
  ⟨5, .assumption, "ass:local_identification", "Local welfare identification",
    "FunctionalLocalIdentification", .assumed⟩

def entryCharacterization : Entry :=
  ⟨6, .theorem, "thm:characterization", "Access-Structure Separation",
    "characterizationPaperClaim_proved",
    .proved CharacterizationPaperClaim characterizationPaperClaim_proved⟩

def entryFlatWelfare : Entry :=
  ⟨7, .remark, "rem:flat_welfare", "Flat welfare points",
    "flat_welfare_counterexample",
    .proved FlatWelfareClaim flat_welfare_counterexample⟩

def entryMechanisms : Entry :=
  ⟨8, .proposition, "prop:four_mechanisms", "Implementation families",
    "mechanismFamiliesClaim_proved",
    .proved MechanismFamiliesClaim mechanismFamiliesClaim_proved⟩

def entryTaxonomyScope : Entry :=
  ⟨9, .remark, "rem:exhaustiveness", "Scope of implementation taxonomy",
    "MechanismFamiliesClaim", .boundary⟩

def entrySeparation : Entry :=
  ⟨10, .corollary, "thm:separation", "Constructive separation",
    "separationFromSC3Claim_proved",
    .proved SeparationFromSC3Claim (by exact separationFromSC3Claim_proved)⟩

def entryConstructiveStrength : Entry :=
  ⟨11, .remark, "rem:constructive-strength", "Why constructive is stronger",
    "global_constant_allocation_has_zero_derivatives", .boundary⟩

def entryCredence : Entry :=
  ⟨12, .assumption, "ass:credence", "Credence-good property",
    "CredenceGoodAssumption", .assumed⟩

def entryReputation : Entry :=
  ⟨13, .assumption, "ass:reputation", "Reputation aggregation",
    "ReputationAggregationAssumption", .assumed⟩

def entryIndependence : Entry :=
  ⟨14, .lemma, "lem:independence", "Residual credence gap",
    "independenceClaim_proved",
    .proved IndependenceClaim independenceClaim_proved⟩

def entryPartition : Entry :=
  ⟨15, .remark, "rem:partition_endogeneity", "Partition endogeneity",
    "CredenceGoodAssumption", .boundary⟩

def entryBundledAssumption : Entry :=
  ⟨16, .assumption, "ass:bundled_rent", "Bundled-certification equilibrium",
    "BundledCertificationAssumption", .assumed⟩

def entryLizzeri : Entry :=
  ⟨17, .lemma, "lem:lizzeri", "Integrated seller-certifier rent",
    "bundledRentClaim_proved",
    .proved BundledRentClaim bundledRentClaim_proved⟩

def entryAttribution : Entry :=
  ⟨18, .remark, "rem:lizzeri_extension", "Attribution and extension",
    "BundledCertificationAssumption", .boundary⟩

def entryCompetition : Entry :=
  ⟨19, .assumption, "ass:certifier_competition", "Certifier competition",
    "CertifierCompetitionAssumption", .assumed⟩

def entryBertrand : Entry :=
  ⟨20, .lemma, "lem:bertrand", "Bertrand among certifiers",
    "bertrandClaim_proved",
    .proved BertrandClaim bertrandClaim_proved⟩

def entryThreshold : Entry :=
  ⟨21, .remark, "rem:below_threshold", "Below-threshold regime",
    "below_threshold_not_operative", .boundary⟩

def entryIncidence : Entry :=
  ⟨22, .assumption, "ass:welfare_incidence", "Certification-rent incidence",
    "PositiveWelfareIncidence", .assumed⟩

def entryBinding : Entry :=
  ⟨23, .theorem, "thm:t4_binding", "Verification-Binding",
    "verificationBindingClaim_proved",
    .proved VerificationBindingClaim verificationBindingClaim_proved⟩

def entryWelfareCorollary : Entry :=
  ⟨24, .corollary, "cor:t4_welfare", "Welfare effect",
    "welfareCorollaryClaim_proved",
    .proved WelfareCorollaryClaim welfareCorollaryClaim_proved⟩

def entryBundledDependence : Entry :=
  ⟨25, .proposition, "prop:bundled_dependence", "Bundled equilibrium dependence",
    "bundled_path_unique_witness",
    .proved BundledPathUniqueClaim bundled_path_unique_witness⟩

def entryLongRun : Entry :=
  ⟨26, .theorem, "thm:longrun", "Long-run orthogonality",
    "thm_longrun", .proved LongRunClaim thm_longrun⟩

def currentPaperEntries : List Entry := [
  entryAccess, entryWelfare, entryRegime, entryOwnershipInvariant,
  entryLocalIdentification, entryCharacterization, entryFlatWelfare,
  entryMechanisms, entryTaxonomyScope, entrySeparation,
  entryConstructiveStrength, entryCredence, entryReputation,
  entryIndependence, entryPartition, entryBundledAssumption, entryLizzeri,
  entryAttribution, entryCompetition, entryBertrand, entryThreshold,
  entryIncidence, entryBinding, entryWelfareCorollary,
  entryBundledDependence, entryLongRun
]

def currentPaperLabels : List String := currentPaperEntries.map Entry.label

def currentPaperUnfinished : List Entry :=
  currentPaperEntries.filter fun entry => entry.evidence.isUnfinished

def currentPaperDerived : List Entry :=
  currentPaperEntries.filter fun entry => entry.evidence.isDerived

theorem currentPaper_count : currentPaperEntries.length = 26 := by decide
theorem currentPaper_labels_nodup : currentPaperLabels.Nodup := by decide
theorem currentPaper_no_unfinished : currentPaperUnfinished.length = 0 := by decide
theorem currentPaper_derived_count : currentPaperDerived.length = 11 := by decide

#eval s!"Access current-paper objects={currentPaperEntries.length} derived={currentPaperDerived.length} unfinished={currentPaperUnfinished.length}"

end AccessOrthogonality.CurrentPaper.Ledger
