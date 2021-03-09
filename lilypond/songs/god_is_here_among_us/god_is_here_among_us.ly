\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/wunderbarer_konig.ly"

%% SONG INFO
title = \titleText "God is here among us"
subtitle = \smallText "See also in German: Gott ist gegenwärtig"
poet = \smallText "Text: Gerhard Tersteegen, 1729, trans. The Hymnal, 1940, alt."
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "christian 4part acapella 3verse musicbyother textbyother"
dateAdded = "2021-03-04"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  God is here a -- mong us: come with a -- do -- ra -- tion, fer -- vent praise and ex -- pec -- ta -- tion.
  God is here with -- in us: known be -- yond be -- liev -- ing, soul in si -- lent awe re -- ceiv -- ing.
  God will name and will claim those be -- held as low -- ly, mak -- ing all things ho -- ly.
}
verseB = \lyricmode {
  Come, a -- bide with -- in me; let my soul, like Ma -- ry, be thine earth -- ly sanc -- tu -- ar -- y.
  Come, in -- dwell -- ing Spir -- it, with trans -- fig -- ured splen -- dor; love and hon -- or will I ren -- der.
  Where I go here be -- low, let me bow be -- fore thee, know thee, and a -- dore thee.
}
verseC = \lyricmode {
  Glad -- ly we sur -- ren -- der earth's de -- ceit -- ful trea -- sures, pride of life, and sin -- ful plea -- sures.
  God, we glad -- ly of -- fer thine to be for -- ev -- er, soul and life and each en -- deav -- or.
  Thou a -- lone shalt be known Lord of all our be -- ing, life's true way de -- cree -- ing.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

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
