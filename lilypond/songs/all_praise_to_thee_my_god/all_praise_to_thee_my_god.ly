\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/tallis_canon.ly"

%% SONG INFO
title = \titleText "All praise to thee, my God"
poet = \smallText "Text: Thomas Ken, 1695"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "christian 4part acapella 3verse musicbyother textbyother evening"
prescore_text = \prescoreText "Unison when sung in canon"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  All praise to thee, my God, this night, for all the bless -- ings of the light.
  Keep me, O keep me, King of kings, be -- neath thine own al -- might -- y wings.
}
verseB = \lyricmode {
  O let my soul, on thee, re -- pose, and with sweet sleep my eye -- lids close,
  sleep that will me more vig -- 'rous make to serve my God when I a -- wake.
}
verseC = \lyricmode {
  Praise God from whom all bless -- ings flow, praise God all crea -- tures here be -- low,
  praise God a -- bove ye heav -- 'nly host, praise Fa -- ther, Son, and Ho -- ly Ghost.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
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
    \tempo  4 = 120
  }
}
