\book {
  \prescore_text
  \bookOutputSuffix "shapenote" \score {
    \layout { \context { \Voice {
      \set shapeNoteStyles = ##(doThin reThin miThin faThin sol laThin tiThin)
    } } }
    \fillTradScore
      { \removeWithTag #'midionly \soprano }
      { \removeWithTag #'midionly \alto }
      { \removeWithTag #'midionly \tenor }
      { \removeWithTag #'midionly \bass }
      {}
      \shapeStaffZoom
  }
  \postscore_text
  \extra_verses
}
