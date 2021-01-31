\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"

%% See docs/all_tags.txt for the full list available
tags = "secular 4part acapella 4verse musicbyother textbyother"
\header {
  title = \titleText "May nothing evil cross this door"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Robert N. Quaile, b. 1867"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: Louis Untermeyer, 1923"
  meter = \smallText "OLDBRIDGE 88.84"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key f \major
hymnTime = \time 3/4
%% Adjust these to fix beaming
%hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/4)
%hymnBeatStructure = \set Timing.beatStructure = 1,1,1,1
%hymnBeatExceptions = \set Timing.beamExceptions = #'()
globalParts = {
  \hymnKey
  \hymnTime
  \hymnBaseMoment
  \hymnBeatStructure
  \hymnBeamExceptions
  \numericTimeSignature
}

%% NOTES
soprano = {
  \globalParts
  \stemUp
  \relative g' { a4 a a | a2 f4 | g2 a4 | f2. | } \break
  \relative g' { c4 c c | bf2 g4 | a2 f4 | \partial 2 g2 \bar "" } \break
  \relative g' { \partial 4 g4 | e4( f) g | a2 4 | a2 f4 | \partial 2 d2 \bar "" } \break
  \relative g' { \partial 4 c,4 | f2. | g2. | f2. | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f f | f2 c4 | e2 4 | d2. |}
  \relative e' { f4 f f | g2 e4 | f2 c4 | c2 | }
  \relative e' { c4 | c2 4 | 2 4 | c2 a4 | bf2 a4 | d2. | e2. | c2. |}
}
tenor = {
  \globalParts
  \stemDown
  \relative a { c4 c c | c2 a4 | c2 4 | a2. | }
  \relative a { c4 c c | d2 c4 | c2 f,4 | e2 | }
  \relative a { e4 | g4( f) e | f2 4 | e2 f4 | f2 4 | a2. | c2. | a2.}
}
bass = {
  \globalParts
  \relative d { f4 f f | f2 4 | c2 a4 | d2. | }
  \relative d { a'4 4 4 | g2 c,4 | f2 a,4 | c2 | }
  \relative d { c4 | bf( a) g | f2 4 | a2 d4 | bf2 f'4 | d2. | c2. | f,2. | }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  May noth -- ing e -- vil cross this door,
  and may ill for -- tune nev -- er pry
  a -- bout these win -- dows; may the roar
  and rain go by.
}
verseB = \lyricmode {
  By faith made strong, the raft -- ers will
  with -- stand the bat -- tering of the storm.
  This hearth, though all the world grow chill,
  will keep you warm.
}
verseC = \lyricmode {
  Peace shall walk soft -- ly through these rooms,
  touch -- ing our lips with ho -- ly wine,
  till ev -- 'ry cas -- ual cor -- ner blooms
  in -- to a shrine.
}
verseD = \lyricmode {
  With laugh -- ter drown the rau -- cous shout,
  and, though these shel -- tering walls are thin,
  may they be strong to keep hate out
  and hold love in.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
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
