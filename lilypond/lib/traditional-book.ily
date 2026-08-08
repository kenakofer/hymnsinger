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
    #(let ((sp (ht-spacing-for "trad")))
       (if sp
           (begin
             (ly:parser-define! 'ht-this-book-spacing sp)
             (ly:parser-include-string
              "\\layout { $ht-this-book-spacing \\context { \\Score \\remove \"Bar_number_engraver\" } }"))))
  }
  \postscore_text
  \extra_verses
}
