\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/deo_gracias_arrbykenan.ly"


%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 5verse arrbykenan textbyother"
\header {
  title = \titleText "O love, how deep, how broad"
  %subtitle = \smallText "Optional"
  composer = \composer
  arranger = \arranger
  poet = \smallText "Text: Thomas a Kempis, 15th c. trans. Benjamin Webb 1851, alt."
  meter = \meter
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% LYRICS
verseA = \lyricmode {
  O love, how deep, how broad, how high! It fills the heart with ec -- sta -- sy,
  that God, the Son of God, should take our mor -- tal form for mor -- tals' sake.
}
verseB = \lyricmode {
  For us he was bap -- tized and bore his ho -- ly fast, and hun -- gered sore.
  For us temp -- ta -- tion sharp he knew, for us the temp -- ter o -- ver -- threw.
}
verseC = \lyricmode {
  For us he prayed, for us he taught. for us his dai -- ly works he wrought,
  by words and signs and ac -- tions thus still seek -- ing not him -- self but us.
}
verseD = \lyricmode {
  For us to wick -- ed hands be -- trayed, scourged, mocked, in pur -- ple robe ar -- rayed,
  he bore the shame -- ful cross and death, for us at length gave up his breath.
}
verseE = \lyricmode {
  E -- ter -- nal glo -- ry to our God for love so deep, so high, so broad;
  the Trin -- i -- ty whom we a -- dore for -- ev -- er and for -- ev -- er -- more.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "" \verseE }
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
