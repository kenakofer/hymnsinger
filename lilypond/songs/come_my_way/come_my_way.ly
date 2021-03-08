\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "secular 5part acapella 3verse musicbyother textbyother"
\header {
  title = \titleText "Come, my Way, my Truth, my Light"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Ralph Vaughan Williams, 1911"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: George Herbert, 1633"
  meter = \smallText "THE CALL 77.77"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key ef \major
hymnTime = \time 6/4
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
  \relative g' { \partial 2. ef2 g4 | bf2 4 c4( bf) af | bf2. \bar "" } \break
  \relative g' { \partial 2. ef2 g4 | bf2 4 c4( bf) af | bf2. \bar "" } \break
  \relative g' { \partial 2. <df' bf>2 4 | <c af>2 4 <bf f>2 af4 | bf2. \bar "" } \break
  \relative g' { \partial 2. af2 4 | g2 4 f4( g af | g4 f ef f2) 4 | ef1. } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { ef2 g4 | df2 4  ef2 4 | ef2( df4) }
  \relative e' { ef2 g4 | df2 4  ef2 4 | ef2( df4) }
  \relative e' { gf2 f4 | f2 ef4 ef( df) c | ef2. }
  \relative e' { f2 4 | ef2 4 c2.~ | 2. df2 c4 | bf1.}
}
tenor = {
  \globalParts
  \relative a { ef2 g4 | f2 4 af2 4 | f2. }
  \relative a { ef2 g4 | f2 4 af2 4 | f2. }
  \relative a { bf2 4 | c2 4 f,2 4 | g2. }
  \relative a { df2 c4 | bf2 4 af2.~( | 2. bf2) 4 | af2.( g2.) }
}
bass = {
  \globalParts
  \relative d { ef2 g4 | bf,2 4 af2 4 | bf2. }
  \relative d { ef2 g4 | bf,2 4 af2 4 | bf2. }
  \relative d { gf,2 4 | af2 4 bf2 f'4 | ef2. }
  \relative d { df2 4 | ef2 4 f2.~( | 2. bf,2) 4 | ef1. }
  \relative d {}
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Come, my Way, my Truth, my Life:
  such a way as gives me breath;
  such a truth as ends all strife;
  such a life as kill -- eth death.
}
verseB = \lyricmode {
  Come, my Light, my Feast, my Strength:
  such a light as shows a feast;
  such a feast as mends in length;
  such a strength as makes __ his guest.
}
verseC = \lyricmode {
  Come my Joy, my Love, my Heart:
  such a joy as none can move;
  such a love as none can part;
  such a heart as joys __ in love.
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
    \tempo  4 = 130
  }
}
