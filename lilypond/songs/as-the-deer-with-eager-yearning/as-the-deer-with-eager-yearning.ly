\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared-tunes/geneva-42.ily"

%% SONG INFO
title = \titleText "As the deer with eager yearning"
poet = \smallText "Text: Based on Psalm 42, Christine T. Curtis, 1939, alt."
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 2
tags = "english theist 4part"
dateAdded = "2021-03-09"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l As the deer with ea -- ger yearn -- ing
  seeks the cool -- ing wa -- ter -- course,
  \l so my soul with ar -- dor burn -- ing
  longs for God, its heav'n -- ly source.
  \l When shall I be -- hold God's face?
  When shall I re -- ceive God's grace?
  \l When shall I, God's prais -- es voic -- ing,
  come be -- fore our God re -- joic -- ing?
}
verseB = \lyricmode {
  Day and night in grief and an -- guish
  bit -- ter tears have been my meat,
  while my long -- ing soul may lan -- guish
  to par -- take of man -- na sweet.
  O my soul, be not dis -- mayed.
  Trust in God, who is our aid.
  Hope and joy God's love pro -- vides you,
  'tis God's hand a -- lone that guides you.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"