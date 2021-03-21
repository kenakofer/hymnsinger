\book {
  \prescore_text
  \bookOutputSuffix "shapenote" \score {
    \layout { \context { \Voice {
      \set shapeNoteStyles = ##(doThin reThin miThin faThin sol laThin tiThin)
    } } }
    \fillTradScore \soprano \alto \tenor \bass {} \shapeStaffZoom
  }
  \postscore_text
  \extra_verses
}
