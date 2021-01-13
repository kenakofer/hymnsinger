\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"
tags = "theist 4part acapella 4verse musicbyother textbyother"
\header {
  title = \titleText "Breath on me, breath of God"
  composer = \smallText "Music: Edwin Hatch, 1878"
  poet = \smallText "Text: Robert Jackson, 1888"
  meter = \smallText "TRENTHAM SM"
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
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { a4 a a | bf2 f4 | a2. | c4 bf a | g2 a4 | g2. } \break
  \relative g' { a4 bf d | c2 a4 | a2 g4 | bf2 g4 | f4( e) f | a2 g4 | f2. | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f f | 2 4 | 2. | 4 4 4 | 2 4 | e2. }
  \relative e' { f4 4 e | f2 8 e | d2 4 | 2 4 | c2 4 | f2 e4 | f2. | }
}
tenor = {
  \globalParts
  \relative a { c4 f e | d2 df4 | c2. | 4 4 4 | d2 4 | e2. | }
  \relative a { c4 d bf | a2 c4 | c2 bf4 | 2 4 | a( g) a | c2 bf4 | a2. }
}
bass = {
  \globalParts
  \relative d { f4 4 4 | 2 4 | 2. | a4 g f | bf,2 b4 | c2. | }
  \relative d { f4 4 g | a2 f4 | bf,2 4 | g2 bf4 | c2 4 | 2 4 | f2. | }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Breathe on me, breath of God. Fill me with life a -- new
  that I may love what thou dost love, and do what thou wouldst do.
}
verseB = \lyricmode {
  Breath on me, breath of God, un-til my heart is pure,
  un -- til with thee I will one will, to do and to en -- dure.
}
verseC = \lyricmode {
  Breathe on me, breath of God, till I am whol -- ly thine,
  till all this earth -- ly part of me glows with thy fire di -- vine.
}
verseD = \lyricmode {
  Breath on me, breath of God, so shall I nev -- er die,
  but live with thee the per -- fect life of thine e -- ter -- ni -- ty.
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
    \tempo  4 = 120
  }
}
