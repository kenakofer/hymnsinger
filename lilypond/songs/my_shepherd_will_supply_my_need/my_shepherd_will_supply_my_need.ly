\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/resignation_arrbykenan.ly"


%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 3verse arrbykenan textbyother"
\header {
  title = \titleText "My Shepherd will supply my need;"
  composer = \composer
  arranger = \arranger
  poet = \smallText "Text: Isaac Watts, 1719, alt."
  meter = \meter
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
globalParts = {
  \hymnKey
  \hymnTime
  \hymnBaseMoment
  \hymnBeatStructure
  \hymnBeamExceptions
  \numericTimeSignature
}

%% LYRICS
verseA = \lyricmode {
  My Shep -- herd will sup -- ply my need; most ho -- ly is your name.
  In pas -- tures fresh you make me feed, be -- side the liv -- ing stream.
  You bring my wan -- d'ring spir -- it back, when I far -- sake your ways,
  and lead me for your mer -- cy's sake, in paths of truth and grace.
}
verseB = \lyricmode {
  When I walk through the shades of death, your pres -- ence is my stay.
  One word of your sup -- port -- ing breath drives all my fears a -- way.
  Your hand, in sight of all my foes, does still my ta -- ble spread.
  My cup with bless -- ings o -- ver -- flows, your oil a -- noints my head.
}
verseC = \lyricmode {
  The sure pro -- vi -- sions of my God at -- tend me all my days.
  Oh, may your house be my a -- bode, and all my work be praise.
  There would I find a set -- tled rest, while oth -- ers go and come,
  no more a stran -- ger, nor a guest, but like a child at home.
}
verseD = \lyricmode { }
verseE = \lyricmode { }
verseF = \lyricmode { }

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
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
    \tempo  4 = 100
  }
}
