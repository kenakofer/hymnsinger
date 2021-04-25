\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/lacquiparle-melody.ily"

%% SONG INFO
title = \titleText "Singer of Life"
poet = \smallText "Text: From a Texcoco Nahuatl poem"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "english theist 1part"
dateAdded = "2021-03-08"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Sing -- er of Life, all flow -- ers are songs, with pet -- als do you write.
  \l Sing -- er of Life, you col -- or the earth, daz -- zling the eye with birds red and bright.
  \l Joy is for us! The flow -- ers are spread! Sing -- ing is our de -- light!
}
verseB = \lyricmode {
  Mor -- tal are we, with all liv -- ing things, with ea -- gles in the sky.
  E -- ven all gold and jade will not last; sing -- ing a -- lone, I know, can -- not die.
  Here in this house of spring -- time be -- stow songs that like birds can fly.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
