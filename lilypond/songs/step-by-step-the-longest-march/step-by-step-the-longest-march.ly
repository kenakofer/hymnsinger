\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% Otherwise set up tune info here:
composer = \smallText "Music: Irish folk song"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "SOLIDARITY 76.76 D"
hymnKey = \key e \minor
hymnTime = \time 4/4
quarternoteTempo = 110
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Step by step the longest march"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Preamble to United Mine Workers of America Constitution"
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 1
tags = "english secular 3part"
dateAdded = "2021-03-09"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 2 e4 fs | g4. fs8 e4 d | e2 4 fs | e2 4 fs | \partial 2 e4 r \bar "" } \break
  \relative g' { \partial 2 e4 fs | g4. fs8 e4 d | e2 4 fs | e2 4 fs | \partial 2 e4 r \bar "" } \break
  \relative g' { \partial 2 e4 fs | g4. fs8 g4 a | b2 a2 | c4. b8 a4 g | \partial 2 fs4 r \bar "" } \break
  \relative g' { \partial 2 e4 fs | g4. fs8 e4 d | e2 4 fs | e2 4 fs | \partial 2 e2 \bar "" } \break
  \bar "|."
}
alto = { }
tenor = {
  \globalParts
  \relative a { e4 fs4 | g4. fs8 e4 d | e2 e4 b' | b2 c4 c | b r }
  \relative a { e4 fs4 | g4. fs8 e4 d | e2 e4 b' | b2 b4 b4 | b r }
  \relative a { e4 b' | b4. d8 b4 d | d2 d | c4. d8 c4 c | b r }
  \relative a { e4 fs4 | g4. fs8 e4 d | e2 e4 b' | b2 b4 b4 | b2 }
}
bass = {
  \globalParts
  \relative d { e4 fs4 | g4. fs8 e4 d | e2 b4 b | b2 a4 a | e' r }
  \relative d { e4 fs4 | g4. fs8 e4 d | e2 b4 b | b2 4 4 | e r }
  \relative d { e4 d | e4. d8 e4 fs4 | g2 a2 | a4. a8 a4 e | b r }
  \relative d { e4 fs4 | g4. fs8 e4 d | e2 b4 b | b2 4 4 | e2 }
}
songChords = \chords {
  \globalChordSymbols
  e2:m | 2 2 | 2 2 | 2 a:m | e1:m |
  2 2 | 2 2 | 2 b2:m | e1:m |
  | 2. d4 | g2 d2 | a1:m | b1:m
  | g2 a:m | e:m b:m | e:m b:m | e:m
}

%% LYRICS
verseA = \lyricmode {
  Step by step the long -- est march can be won, can be won,
  Man -- y stones can form an arch, sin -- gly none, sin -- gly none.
  And by un -- ion what we will can be ac -- com -- plished still,
  drops of wa -- ter turn a mill, sin -- gly none, sin -- gly none.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/1verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-1verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
