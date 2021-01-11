\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/amazing_grace.ly"
%\include "color_by_pitch.ly"

%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 6verse musicbyother textbyother"
\header {
  title = \titleText "Amazing grace"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: American folk melody, 1831"
  %arranger = \smallText "Arranged by Edwin O. Excell, 1900"
  poet = \smallText "Text: John Newton, 1779 (Sts. 1-5), 1790 (St. 6)"
  meter = \smallText "NEW BRITAIN (AMAZING GRACE) CM"
  copyright =\smallText "Public Domain. Free to distribute, modify, and perform. Typeset by Kenan Schaefkofer."
  tagline = \tagline
}

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

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into 
%% a lower staff.

%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } }

%% MIDI output
\score {
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
    \new Staff \with { midiMaximumVolume = #0.7  } \alto
    \new Staff \with { midiMaximumVolume = #0.8  } \tenor
    \new Staff \with { midiMaximumVolume = #0.9 } \bass
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo  4 = 120
  }
}
