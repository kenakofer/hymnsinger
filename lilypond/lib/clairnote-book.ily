%% No \paper block here on purpose.
%%
%% This file used to open with a bare
%%
%%   system-system-spacing.padding = #16
%%
%% at top level, outside any block. A \paper property written there is not a
%% \paper setting -- it is an ordinary assignment to a variable nobody reads,
%% so it had no effect on any build, on any song, ever.
%%
%% It is deleted rather than wrapped in \paper because wrapping it makes it
%% real: 16 is far wider than these pages have to give, and every clairnote
%% score tested went from one page to two.
%%
%% A song that wants the between-system gap changed uses \systemSpacing in its
%% own \paper block. That is song-wide, not per-book -- \spacing_overrides and
%% \spacing_overrides_by_book carry \layout, and \paper cannot travel that way
%% ("\paper cannot be used in \score"). Per-book page spacing would need a
%% separate hook; nothing needs one yet.
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
