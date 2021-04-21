\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
\include "../../shared_tunes/tallis_canon.ily"

%% SONG INFO
title = \titleText "All praise to thee, my God"
poet = \smallText "Text: Thomas Ken, 1695"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part evening"
prescore_text = \prescoreText "Unison when sung in canon"
dateAdded = "2021-03-05"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l All praise to thee, my God, this night, for all the bless -- ings of the light.
  \l Keep me, O keep me, King of kings, be -- neath thine own al -- might -- y wings.
}
verseB = \lyricmode {
  For -- give me, Lord, for thy dear Son, the ill that I this day have done,
  that with the world, my -- self, and thee, I, ere I sleep, at peace may be.
}
verseC = \lyricmode {
  O let my soul, on thee, re -- pose, and with sweet sleep my eye -- lids close,
  sleep that will me more vig -- 'rous make to serve my God when I a -- wake.
}
verseD = \lyricmode {
  Praise God from whom all bless -- ings flow, praise God all crea -- tures here be -- low,
  praise God a -- bove ye heav -- 'nly host, praise Fa -- ther, Son, and Ho -- ly Ghost.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output
\include "../../lib/slides_book_4verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"
