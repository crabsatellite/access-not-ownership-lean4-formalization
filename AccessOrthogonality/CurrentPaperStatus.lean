/- Publication root: only live journal-paper objects and their proof ledger. -/

import AccessOrthogonality.CurrentPaperTheoremMap

namespace AccessOrthogonality.CurrentPaper

theorem publication_object_count : Ledger.currentPaperEntries.length = 26 := by decide
theorem publication_no_unfinished : Ledger.currentPaperUnfinished.length = 0 := by decide
theorem publication_derived_count : Ledger.currentPaperDerived.length = 11 := by decide

end AccessOrthogonality.CurrentPaper
