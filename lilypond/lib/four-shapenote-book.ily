%% 4-shape (Southern Harmony / Sacred Harp) output: fa sol la fa sol la mi.
%% Same la-based treatment as the 7-shape book -- \relativeMajorShapes keys the
%% shapes to the relative major, so a minor tune starts on la, not fa. That
%% matters more here than in 7-shape, since the 4-shape system repeats fa-sol-la
%% and a do-based rotation puts the tetrachords in the wrong place entirely.
#(set! hs-active-shapes fourShapeNoteBaseStyles)

\book {
  \prescore_text
  \bookOutputSuffix "4shapenote" \score {
    %% Staff, not Voice: \partCombine splits each staff into shared/one/two/solo
    %% voices, so a Voice-level default would shadow the rotated value that
    %% \relativeMajorShapes sets on the staff.
    \layout {
      \context { \Staff shapeNoteStyles = #fourShapeNoteBaseStyles }
    }
    \removeWithTag #'(midionly slidesOnly)
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
      {}
      \shapeStaffZoom
    #(let ((sp (ht-spacing-for "4shapenote")))
       (if sp
           (begin
             (ly:parser-define! 'ht-this-book-spacing sp)
             (ly:parser-include-string
              "\\layout { $ht-this-book-spacing \\context { \\Score \\remove \"Bar_number_engraver\" } }"))))
  }
  \postscore_text
  \extra_verses
}

#(set! hs-active-shapes #f)
