\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/amazing_grace.ly"

%% SONG INFO
title = \titleText "Amazing grace"
poet = \smallText "Text: John Newton, 1779 (Sts. 1-5), 1790 (St. 6)"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "christian 4part acapella 6verse musicbyother textbyother"
dateAdded = "2021-01-11"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  A -- maz -- ing grace! how sweet the sound, that saved a wretch like me!
  I once was lost, but now am found, was blind, but now I see.
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

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "1" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "2" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "3" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "4" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "5" \verseE }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "6" "6" \verseF }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"