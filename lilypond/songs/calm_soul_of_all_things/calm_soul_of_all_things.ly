\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/tallis_canon.ly"

%% SONG INFO
title = \titleText "Calm soul of all things"
poet = \smallText "Text: Matthew Arnold (1822-1888)"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "theist 4part acapella 2verse musicbyother textbyother"
prescore_text = \prescoreText "Unison when sung in canon"
dateAdded = "2021-03-09"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  Calm soul of all things, make it mine
  to feel a -- mid the cit -- y's jar,
  that there a -- bides a peace of thine
  I did not make, and can -- not mar.
}
verseB = \lyricmode {
  The will to nei -- ther strive nor cry,
  the pow'r to feel with oth -- er's, give.
  Calm, calm me more, nor let me die
  be -- fore I have be -- gun to live.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
>>

%% Traditional notation
\book { \prescore_text \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \prescore_text \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \prescore_text \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } }

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
    \tempo  4 = 100
  }
}
