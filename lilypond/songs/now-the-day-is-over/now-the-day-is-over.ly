\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Friedrich Filitz, 1847"
meter = \smallText "WEM IN LEIDENSTAGEN 65.65"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Now the day is over"
poet = \twoLineSmallText "Text: v.1 Sabine Baring Gould, 1865" "v.2-5 Marye B. Bonney (1910-1992)"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english secular 4part evening autumn"
dateAdded = "2021-02-11"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { a4 a g g | f2 e | f4 4 g g | a2. r4 | } \break
  \relative g' { c4 c bf4 4 | a2 g | a4 a g g | f1 } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f f e | e( d) cs2 | d4 f f e | f2. r4 | }
  \relative e' { e4 f d g | g( f) e2 | f4 f f e | c1 | }
}
tenor = {
  \globalParts
  \relative a { c4 c c c | a2 a | a4 a c c | c2. r4 | }
  \relative a { c4 a bf c | c2 c | c4 c d c | a1 }
}
bass = {
  \globalParts
  \relative d { f4 f c c | d2 a | d4 d c c | f2. r4 | }
  \relative d { a'4 f g e | f2 c | f4 a, bf c | f1 | }
}


%% LYRICS
verseA = \lyricmode {
  \l Now the day is o -- ver,
  night is draw -- ing nigh,
  \l shad -- ows of the eve -- ning
  steal a -- cross the sky.
}
verseB = \lyricmode {
  Now the leaf -- less land -- scape
  set -- tles in re -- pose,
  wait -- ing for the qui -- et
  of the win -- ter snows.
}
verseC = \lyricmode {
  Now as twi -- light gath -- ers
  let us pause and hear
  all the slow -- ing pulse -- beats
  of the wan -- ing year.
}
verseD = \lyricmode {
  May the sea -- son's rhy -- thms,
  slow and strong and deep
  soothe the mind and spi -- rit
  lull -- ing us to sleep.
}
verseE = \lyricmode {
  Sleep un -- til the ri -- sing
  of a -- noth -- er spring
  keeps the an -- cient pro -- mise
  fall and win -- ter bring.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/5verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-5verse.ily"
%% midi output
\include "../../lib/midi-output.ily"
