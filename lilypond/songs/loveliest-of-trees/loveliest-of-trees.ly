\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/orientis-partibus-87-87.ily"

%% SONG INFO
verseCount = 3
tags = "english secular 4part spring"
title = \titleText "Loveliest of trees"
poet = \smallText "Text: A. E. Housman, 1896"
typesetter = "Kenan Schaefkofer"
dateAdded = "2021-02-07"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Love -- liest of trees, the cher -- ry now,
  \l hung with bloom a -- long the bough,
  \l it stands a -- bout the wood -- land ride
  \l wear -- ing white for Eas -- ter -- tide.
}
verseB = \lyricmode {
  Now of my three -- score years and ten,
  twen -- ty will not come a -- gain.
  And take from sev'n -- ty springs a score,
  leav -- ing me just fif -- ty more.
}
verseC = \lyricmode {
  And since to look at things in bloom
  fif -- ty springs are lit -- tle room,
  a -- bout the wood -- lands I will go,
  see the cher -- ry hung with snow.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
