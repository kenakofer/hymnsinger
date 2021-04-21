\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
\include "../../shared_tunes/deo_gracias_arrbykenan.ily"

%% SONG INFO
title = \titleText "O love, how deep, how broad"
poet = \smallText "Text: Thomas a Kempis, 15th c. trans. Benjamin Webb 1851, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english christian 4part"
dateAdded = "2021-03-04"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l O love, how deep, how broad, how high! It fills the heart with ec -- sta -- sy,
  \l that God, the Son of God, should take our mor -- tal form for mor -- tals' sake.
}
verseB = \lyricmode {
  For us he was bap -- tized and bore his ho -- ly fast, and hun -- gered sore.
  For us temp -- ta -- tion sharp he knew, for us the temp -- ter o -- ver -- threw.
}
verseC = \lyricmode {
  For us he prayed, for us he taught. for us his dai -- ly works he wrought,
  by words and signs and ac -- tions thus still seek -- ing not him -- self but us.
}
verseD = \lyricmode {
  For us to wick -- ed hands be -- trayed, scourged, mocked, in pur -- ple robe ar -- rayed,
  he bore the shame -- ful cross and death, for us at length gave up his breath.
}
verseE = \lyricmode {
  E -- ter -- nal glo -- ry to our God for love so deep, so high, so broad;
  the Trin -- i -- ty whom we a -- dore for -- ev -- er and for -- ev -- er -- more.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/5verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output
\include "../../lib/slides_book_5verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"
