\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/resignation_arrbykenan.ly"
%\include "color_by_pitch.ly"

%% See docs/all_tags.txt for the full list available
tags = "secular 4part acapella 4verse arrbykenan textbyother"
\header {
  title = \titleText "No number tallies up my score"
  composer = \composer
  arranger = \arranger
  poet = \smallText "Text: Ralph Waldo Emerson (1803-1882), rev."
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
  No num -- ber tal -- lies up my score,
  no tribe my house can fill;
  I sit be -- side the fount of life
  and pour the del -- uge still.
  And gath -- ered by most fra -- gile pow'rs
  a -- long the cen -- tur -- ies
  from race on race the rar -- est flow'rs
  my wreath shall noth -- ing miss.
}
verseB = \lyricmode {
  I wrote the past in char -- ac -- ters
  of rock and fire and scroll,
  the build -- ing in the cor -- al sea, the plant -- ing of the coal.
  And thefts from sat -- el -- lites and rings
  and bro -- ken stars I drew,
  and out of spent and ag -- ed things
  I formed the world a -- new.
}
verseC = \lyricmode {
  Must time and tide for -- ev -- er run,
  nor winds sleep in the west?
  Will ne'er my wheels which whirl the sun
  and sat -- el -- lites have rest?
  Yet whirl the glow -- ing wheels once more,
  and mix the bowl a -- gain;
  seethe, Fate, the an -- cient el -- e -- ments,
  heat, cold, and peace, and pain.
}
verseD = \lyricmode {
  Blend war and trade and creeds and song,
  as rip -- ens hu -- man race,
  the sun -- burnt world that they shall breed,
  of all my count -- less days.
  No ray is dimmed, no a -- tom worn,
  my old -- est force is new,
  and fresh the rose on yon -- der thorn
  gives back the heav'ns in dew.
 }
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
