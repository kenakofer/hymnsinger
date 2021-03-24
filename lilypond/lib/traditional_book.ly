\book {
  \prescore_text
  \bookOutputSuffix "trad" \score {
    \removeWithTag #'midionly
    \fillTradScore
      { \removeWithTag #'midionly \soprano }
      { \removeWithTag #'midionly \alto }
      { \removeWithTag #'midionly \tenor }
      { \removeWithTag #'midionly \bass }
      \songChords
      \tradStaffZoom
  }
  \postscore_text
  \extra_verses
}
