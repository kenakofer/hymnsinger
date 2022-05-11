\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO

%% Otherwise set up tune info here:
composer = \smallText "Music: Kenan Schaefkofer, 2022"
meter = \smallText "TUNE NAME METER"
hymnKey = \key c \major
hymnTime = \time 6/8
quarternoteTempo = 90
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Fruit of the Whys"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Kenan Schaefkofer, 2022"
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 5
tags = "english secular 1part"
dateAdded = "2022-05-11"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    c4 d e f \break
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {

  }
}
tenor = {
  \globalParts
  \relative a {
    a4 b c d
  }
}
bass = {
  \globalParts
  \relative d {

  }
}
songChords = \chords {
  \globalChordSymbols
  c2:7 g4:sus g:m
}

%% LYRICS
verseA = \lyricmode {
  \l Ly -- rics
}
verseB = \lyricmode {
  for _ each
}
verseC = \lyricmode {
  verse
}
verseD = \lyricmode {
  go here.
}
verseE = \lyricmode { }
verseF = \lyricmode { }

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"