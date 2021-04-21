\book {
  \prescore_text
  \bookOutputSuffix "trad" \score {
    \removeWithTag #'(midionly slidesOnly)
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
      \songChords
      \tradStaffZoom
  }
  \postscore_text
  \extra_verses
}
