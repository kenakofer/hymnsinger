\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared-tunes/lasst-uns-erfreuen.ily"

%% Otherwise set up tune info here:
composer = \smallText "Music: Composer, year"
%arranger = \smallText "arr. Name, year"
meter = \smallText "TUNE NAME METER"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Title of the song"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Author, year"
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 4
tags = "english theist 4part"
dateAdded = %YYYY-MM-DD%
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