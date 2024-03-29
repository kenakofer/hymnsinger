\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/tallis-canon.ily"
quarternoteTempo = 100

%% SONG INFO
title = \titleText "Calm soul of all things"
poet = \smallText "Text: Matthew Arnold (1822-1888)"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "english theist 4part"
prescore_text = \prescoreText "Unison when sung in canon"
dateAdded = "2021-03-09"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Calm soul of all things, make it mine
  to feel a -- mid the cit -- y's jar,
  \l that there a -- bides a peace of thine
  I did not make, and can -- not mar.
}
verseB = \lyricmode {
  The will to nei -- ther strive nor cry,
  the pow'r to feel with oth -- er's, give.
  Calm, calm me more, nor let me die
  be -- fore I have be -- gun to live.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
