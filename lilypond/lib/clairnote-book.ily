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
    #(let ((sp (ht-spacing-for "clairnote")))
       (if sp
           (begin
             (ly:parser-define! 'ht-this-book-spacing sp)
             (ly:parser-include-string
              "\\layout { $ht-this-book-spacing \\context { \\Score \\remove \"Bar_number_engraver\" } }"))))
  }
  \postscore_text
  \extra_verses
}
