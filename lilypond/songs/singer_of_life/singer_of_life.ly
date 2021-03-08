\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/lacquiparle_melody.ly"

%% SONG INFO
title = \titleText "Singer of Life"
poet = \smallText "Text: From a Texcoco Nahuatl poem"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "theist 1part acapella 2verse musicbyother textbyother"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  Sing -- er of Life, all flow -- ers are songs, with pet -- als do you write.
  Sing -- er of Life, you col -- or the earth, daz -- zling the eye with birds red and bright.
  Joy is for us! The flow -- ers are spread! Sing -- ing is our de -- light!
}
verseB = \lyricmode {
  Mor -- tal are we, with all liv -- ing things, with ea -- gles in the sky.
  E -- ven all gold and jade will not last; sing -- ing a -- lone, I know, can -- not die.
  Here in this house of spring -- time be -- stow songs that like birds can fly.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
>>

%% Traditional notation
\book { \prescore_text \bookOutputSuffix "trad" \score { \fillTradScoreSingleStaff \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \prescore_text \bookOutputSuffix "shapenote" \score { \fillTradScoreSingleStaff {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \prescore_text \bookOutputSuffix "clairnote" \score { \fillClairScoreSingleStaff \soprano \alto \tenor \bass } }

%% MIDI output
\score {
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo  4 = 165
  }
}
