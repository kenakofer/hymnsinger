\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"

%% See docs/all_tags.txt for the full list available
tags = "secular 4part acapella 3verse musicbyother textbyother spring"
\header {
  title = \titleText "Lovelist of trees"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Pierre de Corbeil, harmonized Richard Redhead, 1853"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: A. E. Housman, 1896"
  meter = \smallText "ORIENTIS PARTIBUS 87.87"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key ef \major
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
  \relative g' { ef4 4 f | g2 ef4 | f2 d4 | ef2. | } \break
  \relative g' { bf2 4 | c2 g8( af) | bf2 4 | \partial 2 g2 \bar " " } \break
  \relative g' { \partial 4 g4 | g2 f4 | af2 g4 | f4( ef) f | g2. | } \break
  \relative g' { bf2 af4 | g2 ef4 | f2 d4 | ef2. | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { bf4 4 4 | bf2 4 | c2 bf4 | bf2. | }
  \relative e' { ef2 4 | ef2 4 | ef2 d4 | ef2 | }
  \relative e' { ef4 | bf2 4 | ef2 4 | c2 4 | d2. | }
  \relative e' { ef2 4 | d2 c4 | c2 bf4 | bf2. | }
}
tenor = {
  \globalParts
  \relative a { g2 af4 | bf2 4 | af2 f4 | g2. | }
  \relative a { g2 4 | af2 ef4 | f2 4 | g2 | }
  \relative a { g4 | bf2 4 | af2 bf4 | c2 4 | b2. | }
  \relative a { bf2 c4 | bf2 g4 | af2 f4 | g2. | }
}
bass = {
  \globalParts
  \relative d { ef2 4 | 2 g,4 | af2 bf4 | ef2. | }
  \relative d { ef2 4 | af,2 c4 | bf2 4 | ef2 | }
  \relative d { ef4 | ef2 d4 | c2 bf4 | af2 4 | g2. | }
  \relative d { g,2 af4 | bf2 c4 | af2 bf4 | ef2. | }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Love -- liest of trees, the cher -- ry now,
  hung with bloom a -- long the bough,
  it stands a -- bout the wood -- land ride
  wear -- ing white for Eas -- ter -- tide.
}
verseB = \lyricmode {
  Now of my three -- score years and ten,
  twen -- ty will not come a -- gain.
  And take from sev'n -- ty springs a score,
  leav -- ing me just fif -- ty more.
}
verseC = \lyricmode {
  And since to look at things in bloom
  fif -- ty springs are lit -- tle room,
  a -- bout the wood -- lands I will go,
  see the cher -- ry hung with snow.
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
    \tempo  4 = 120
  }
}
