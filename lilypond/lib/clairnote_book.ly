system-system-spacing.padding = #16
\book {
  \prescore_text
  \bookOutputSuffix "clairnote" \score {
    \fillClairScore
      { \removeWithTag #'midionly \soprano }
      { \removeWithTag #'midionly \alto }
      { \removeWithTag #'midionly \tenor }
      { \removeWithTag #'midionly \bass }
  }
  \postscore_text
  \extra_verses
}
