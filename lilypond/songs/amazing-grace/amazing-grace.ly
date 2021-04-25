\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
\include "../../shared_tunes/amazing_grace.ily"

%% SONG INFO
title = \titleText "Amazing grace"
poet = \smallText "Text: John Newton, 1779 (Sts. 1-5), 1790 (St. 6)"
typesetter = "Kenan Schaefkofer"
verseCount = 6
tags = "english christian 4part"
dateAdded = "2021-01-11"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l A -- maz -- ing grace! how sweet the sound, that saved a wretch like me!
  \l I once was lost, but now am found, was blind, but now I see.
}
verseB = \lyricmode {
  'Twas grace that taught my heart to fear, and grace my fears re -- lieved.
  How pre -- cious did that grace ap -- pear the hour I first be -- lieved.
}
verseC = \lyricmode {
  Through man -- y dan -- gers, toils, and snares, I have al -- read -- y come.
  'Tis grace has brought me safe thus far, and grace will lead me home.
}
verseD = \lyricmode {
  Yes, when this flesh and heart shall fail, and mor -- tal life shall cease,
  I shall pos -- sess, with -- in the vail, a life of joy and peace.
}
verseE = \lyricmode {
  The earth shall soon dis -- solve like snow, the sun for -- bear to shine;
  but God, who called me here be -- low, will be for -- ev -- er mine.
}
verseF = \lyricmode {
  When we've been there ten thou -- sand years, bright shin -- ing as the sun,
  we've no less days to sing God's praise than when we'd first be -- gun.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/6verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output
\include "../../lib/slides_book_6verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"