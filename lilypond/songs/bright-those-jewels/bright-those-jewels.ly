\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared-tunes/orientis-partibus-77-77.ily"

%% SONG INFO
title = \titleText "Bright those jewels"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Hosea Ballou II, 1849"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english secular 4part"
dateAdded = "2021-03-22"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  Bright those jew -- els of the skies
  which in sa -- ble dark -- ness glow.
  Bright -- er in com -- pas -- sion's eyes
  are the si -- lent tears which flow.
}
verseB = \lyricmode {
  Sweet the fra -- grance from the fields
  where a -- bun -- dant spic -- es grow.
  Sweet -- er far is that which yields
  suc -- cor to the sick and low.
}
verseC = \lyricmode {
  Grate -- ful are those gen -- tle dews
  on the green -- ing grass which fall.
  Far more grate -- ful what re -- news
  com -- forts to the poor who call
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
