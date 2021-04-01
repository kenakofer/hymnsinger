system-system-spacing.padding = #16
\book {
  \prescore_text
  \bookOutputSuffix "clairnote" \score {
    \removeWithTag #'(midionly slidesOnly)
    \fillClairScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
  }
  \postscore_text
  \extra_verses
}
