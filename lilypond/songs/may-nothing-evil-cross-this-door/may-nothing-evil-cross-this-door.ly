\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Robert N. Quaile, b. 1867"
meter = \smallText "OLDBRIDGE 88.84"
hymnKey = \key f \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "May nothing evil cross this door"
poet = \smallText "Text: Louis Untermeyer, 1923"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english secular 4part"
dateAdded = "2021-01-31"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \stemUp
  \relative g' { a4 a a | a2 f4 | g2 a4 | f2. | } \break
  \relative g' { c4 c c | bf2 g4 | a2 f4 | \partial 2 g2 \bar "" } \break
  \relative g' { \partial 4 g4 | e4( f) g | a2 4 | a2 f4 | \partial 2 d2 \bar "" } \break
  \relative g' { \partial 4 c,4 | f2. | g2. | f2. | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f f | f2 c4 | e2 4 | d2. |}
  \relative e' { f4 f f | g2 e4 | f2 c4 | c2 | }
  \relative e' { c4 | c2 4 | 2 4 | c2 a4 | bf2 a4 | d2. | e2. | c2. |}
}
tenor = {
  \globalParts
  \stemDown
  \relative a { c4 c c | c2 a4 | c2 4 | a2. | }
  \relative a { c4 c c | d2 c4 | c2 f,4 | e2 | }
  \relative a { e4 | g4( f) e | f2 4 | e2 f4 | f2 4 | a2. | c2. | a2.}
}
bass = {
  \globalParts
  \relative d { f4 f f | f2 4 | c2 a4 | d2. | }
  \relative d { a'4 4 4 | g2 c,4 | f2 a,4 | c2 | }
  \relative d { c4 | bf( a) g | f2 4 | a2 d4 | bf2 f'4 | d2. | c2. | f,2. | }
}

%% LYRICS
verseA = \lyricmode {
  \l May noth -- ing e -- vil cross this door,
  \l and may ill for -- tune nev -- er pry
  \l a -- bout these win -- dows; may the roar
  \l and rain go by.
}
verseB = \lyricmode {
  By faith made strong, the raft -- ers will
  with -- stand the bat -- tering of the storm.
  This hearth, though all the world grow chill,
  will keep you warm.
}
verseC = \lyricmode {
  Peace shall walk soft -- ly through these rooms,
  touch -- ing our lips with ho -- ly wine,
  till ev -- 'ry cas -- ual cor -- ner blooms
  in -- to a shrine.
}
verseD = \lyricmode {
  With laugh -- ter drown the rau -- cous shout,
  and, though these shel -- tering walls are thin,
  may they be strong to keep hate out
  and hold love in.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
