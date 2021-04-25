\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/resignation-arrbykenan.ily"

%% SONG INFO
title = \titleText "My Shepherd will supply my need"
poet = \smallText "Text: Isaac Watts, 1719, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-03-04"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l My Shep -- herd will sup -- ply my need; most ho -- ly is your name.
  \l In pas -- tures fresh you make me feed, be -- side the liv -- ing stream.
  \l You bring my wan -- d'ring spir -- it back, when I for -- sake your ways,
  \l and lead me for your mer -- cy's sake, in paths of truth and grace.
}
verseB = \lyricmode {
  When I walk through the shades of death, your pres -- ence is my stay.
  One word of your sup -- port -- ing breath drives all my fears a -- way.
  Your hand, in sight of all my foes, does still my ta -- ble spread.
  My cup with bless -- ings o -- ver -- flows, your oil a -- noints my head.
}
verseC = \lyricmode {
  The sure pro -- vi -- sions of my God at -- tend me all my days.
  Oh, may your house be my a -- bode, and all my work be praise.
  There would I find a set -- tled rest, while oth -- ers go and come,
  no more a stran -- ger, nor a guest, but like a child at home.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
