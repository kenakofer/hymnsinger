\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% Otherwise set up tune info here:
composer = \smallText ""
%arranger = \smallText "arr. Name, year"
%% Note: the meter variable requires a TUNE NAME, following by a meter, for page generation to work. See existing songs for examples
meter = \smallText ""
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Solfege: F major scale"
subtitle =
      \markup{
        
        %\override #'(font-name . "Linux Biolinum")
        \override #'(font-series . "regular")
        \fontsize #-2
        "(With British accent) When flats ("
        \override #'(font-series . "regular")
        \fontsize #-2
        \flat
        \override #'(font-series . "regular")
        \fontsize #-2
        ") there are, the last is Fa!" 
      }
poet = \smallText ""
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = ""
dateAdded = "2025-11-22"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    f4 g a bf | c d e f |
    g f e d | c bf a g | f1
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {

    f4 g a bf | c d e f |
    g f e d | c bf a g | f1
  }
}
tenor = {
  \globalParts
  \relative a {
    f4 g a bf | c d e f |
    g f e d | c bf a g | f1
  }
}
bass = {
  \globalParts
  \relative d {

    f,4 g a bf | c d e f |
    g f e d | c bf a g | f1
  }
}
songChords = \chords {
  \globalChordSymbols
}

%% LYRICS
verseA = \lyricmode {
  \l Do Re Mi Fa So La Ti Do Re Do Ti La So Fa Mi Re Do
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/1verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
clairStaffZoom = #1.0
shapeStaffZoom = #1.2

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-1verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"