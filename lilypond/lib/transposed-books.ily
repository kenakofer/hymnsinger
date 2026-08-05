%% Traditional notation at four transpositions, for singers who need the tune
%% a semitone or two off the printed key. Each book is the trad book with
%% \transpose wrapped around it and the capo line removed.
%%
%% The pitch pair comes from \htTransposeFrom / \htTransposeTo, which read
%% \hymnKey and pick the target spelling with the fewest accidentals. See
%% transpose-common.ily for why the spelling cannot just be hard-coded.
\include "transpose-common.ily"

%% One book per shift. This is spelled out four times rather than generated in
%% a loop because \bookOutputSuffix is a parse-time setting on the enclosing
%% \book: a Scheme loop would need to build whole \book objects, which is a
%% lot of machinery to save twenty lines.

\book {
  \prescore_text
  \bookOutputSuffix "trad-up1" \score {
    \removeWithTag #'(midionly slidesOnly capoOnly)
    \transpose \htTransposeFrom \hymnKey \htTransposeTo \hymnKey #1
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
      \songChords
      \tradStaffZoom
  }
  \postscore_text
  \extra_verses
}

\book {
  \prescore_text
  \bookOutputSuffix "trad-up2" \score {
    \removeWithTag #'(midionly slidesOnly capoOnly)
    \transpose \htTransposeFrom \hymnKey \htTransposeTo \hymnKey #2
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
      \songChords
      \tradStaffZoom
  }
  \postscore_text
  \extra_verses
}

\book {
  \prescore_text
  \bookOutputSuffix "trad-dn1" \score {
    \removeWithTag #'(midionly slidesOnly capoOnly)
    \transpose \htTransposeFrom \hymnKey \htTransposeTo \hymnKey #-1
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
      \songChords
      \tradStaffZoom
  }
  \postscore_text
  \extra_verses
}

\book {
  \prescore_text
  \bookOutputSuffix "trad-dn2" \score {
    \removeWithTag #'(midionly slidesOnly capoOnly)
    \transpose \htTransposeFrom \hymnKey \htTransposeTo \hymnKey #-2
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) \soprano }
      { \removeWithTag #'(midionly slidesOnly) \alto }
      { \removeWithTag #'(midionly slidesOnly) \tenor }
      { \removeWithTag #'(midionly slidesOnly) \bass }
      \songChords
      \tradStaffZoom
  }
  \postscore_text
  \extra_verses
}
