\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% Otherwise set up tune info here:
composer = \smallText ""
%arranger = \smallText "arr. Name, year"
%% Note: the meter variable requires a TUNE NAME, following by a meter, for page generation to work. See existing songs for examples
meter = \smallText ""
hymnKey = \key g \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Solfege: E natural minor scale"
subtitle =
      \markup{
        %\override #'(font-name . "Linux Biolinum")
        \override #'(font-series . "regular")
        \fontsize #-2
        "When sharps ("
        \override #'(font-series . "regular")
        \fontsize #-2
        \sharp
        \override #'(font-series . "regular")
        \fontsize #-2
        ") you see, the last is Ti! (    )" 
      }
poet = \smallText ""
typesetter = "Kenan Schaefkofer"
% prescore_text = \prescoreText "When flats there are, the last is fa!"
verseCount = 1
tags = ""
dateAdded = "2025-11-22"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    e4 fs g a | b c d e |
    fs e d c | b a g fs | e1
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {

    e4 fs g a | b c d e |
    fs e d c | b a g fs | e1
  }
}
tenor = {
  \globalParts
  \relative a {
    e4 fs g a | b c d e |
    fs e d c | b a g fs | e1
  }
}
bass = {
  \globalParts
  \relative d {

    e4 fs g a | b c d e |
    fs e d c | b a g fs | e1
  }
}
songChords = \chords {
  \globalChordSymbols
}

%% LYRICS
verseA = \lyricmode {
  \l La Ti Do Re Mi Fa So La Ti La So Fa Mi Re Do Ti La
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/1verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
clairStaffZoom = #1.5
shapeStaffZoom = #1.5

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-1verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"