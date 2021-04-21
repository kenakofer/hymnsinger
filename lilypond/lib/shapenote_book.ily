\book {
  \prescore_text
  \bookOutputSuffix "shapenote" \score {
    \layout { \context { \Voice {
      \set shapeNoteStyles = ##(doThin reThin miThin faThin sol laThin tiThin)
    } } }
    \removeWithTag #'(midionly slidesOnly)
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
      {}
      \shapeStaffZoom
  }
  \postscore_text
  \extra_verses
}
