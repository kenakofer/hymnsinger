\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/stuttgart.ily"

%% SONG INFO
title = \titleText "May we each take joy in giving"
%subtitle = \smallText "Optional"
poet = \twoLineSmallText "Text: Robert Murray, 1880" "alt. Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english secular 4part"
dateAdded = "2021-03-14"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  May we each take joy in giv -- ing with a spir -- it large and free
  to our neigh -- bors and the stran -- gers, fost -- er -- ing com -- mun -- i -- ty.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/1verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-1verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
