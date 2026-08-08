%% La-based shape notes: the shapes are keyed to the relative major, so minor
%% tunes read la-do-re-mi rather than do-re-mi-fa. The rotation itself lives in
%% hymn-common.ily (\relativeMajorShapes, invoked from \globalParts right after
%% \hymnKey, which is the only point where the key is known).

%% \globalParts is shared with every other book, so gate the rotation to this
%% one. The books included after this one (slides, MIDI) must stay unrotated,
%% hence the reset at the end -- these run at parse time, in file order.
#(set! hs-active-shapes shapeNoteBaseStyles)

\book {
  \prescore_text
  \bookOutputSuffix "shapenote" \score {
    %% Staff, not Voice: \partCombine splits each staff into shared/one/two/solo
    %% voices, so a Voice-level default would shadow the rotated value that
    %% \relativeMajorShapes sets on the staff.
    \layout {
      \context { \Staff shapeNoteStyles = #shapeNoteBaseStyles }
    }
    \removeWithTag #'(midionly slidesOnly)
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
      {}
      \shapeStaffZoom
    #(let ((sp (ht-spacing-for "shapenote")))
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
