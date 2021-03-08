\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/lacquiparle_melody.ly"


%% See docs/all_tags.txt for the full list available
tags = "theist 1part acapella 2verse musicbyother textbyother"
\header {
  title = \titleText "Singer of Life"
  %subtitle = \smallText "Optional"
  composer = \composer
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: From a Texcoco Nahuatl poem"
  meter = \meter
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

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

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

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
