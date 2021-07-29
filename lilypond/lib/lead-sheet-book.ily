\book {
  \prescore_text
  \bookOutputSuffix "lead" \score {
    \removeWithTag #'(midionly slidesOnly)
    \fillTradLeadSheetScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      \songChords
      \tradLeadSheetStaffZoom
  }
  \postscore_text
  \extra_verses
}
