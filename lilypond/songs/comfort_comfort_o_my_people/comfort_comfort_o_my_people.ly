\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"

%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 3verse musicbyother textbyother"
\header {
  title = \titleText "Comfort, comfort, O my people"
  %subtitle = \smallText "Optional"
  composer = \twoLineSmallText "Music: Louis Bourgeois, 1551" "Harmonized Claude Goudimel, 1565"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \twoLineSmallText "Text: Johannes Olearius, 1671" "Translated Catherine Winkworth, 1863"
  meter = \smallText "GENEVA 42 (FREU DICH SEHR) 87.87.77.88"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key f \major
hymnTime = \time 12/4
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
  \override Staff.TimeSignature.transparent = ##t
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { f2 g4 a2 g4 f e d2 c | f2 g4 a2 bf4 a2 g \partial 1 f1 | } \break
  \relative g' { f2 g4 a2 g4 f e d2 c | f2 g4 a2 bf4 a2 g \partial 1 f1 | } \break
  \relative g' { a2 4 c2 bf4 a g a1 | c2 4 d2 c4 bf a g1 | } \break
  \relative g' { a2 c4 bf2 a4 f g a2 f | a2 4 bf2 a4 g f f( e) \partial 1 f1 | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f2 e4 f2 e4 d c bf2 a | c2 e4 f2 4 2 e2 f1 | }
  \relative e' { f2 e4 f2 e4 d c bf2 a | c2 e4 f2 4 2 e2 f1 | }
  \relative e' { f2 4 2 4 4 e4 f1 | f2 4 2 4 4 4 e1 | }
  \relative e' { f2 g4 2 f4 d e f2 d | c2 4 d2 c4 c a c2 1 | }
}
tenor = {
  \globalParts
  \relative a { c2 4 2 4 a4 a f2 2 | a2 c4 2 d4 c2 c c1 | }
  \relative a { c2 4 2 4 a4 a f2 2 | a2 c4 2 d4 c2 c c1 | }
  \relative a { c2 4 a2 d4 c c c1 | a2 4 bf2 a4 d c c1 | }
  \relative a { c2 ef4 d2 d4 a4 c c2 bf2 | c2 f,4 2 4 e4 f g2 a1 | }
}
bass = {
  \globalParts
  \stemDown
  \relative d { f2 c4 f2 c4 d a bf2 f | f'2 c4 f2 bf,4 f'2 c2 f1 | }
  \relative d { f2 c4 f2 c4 d a bf2 f | f'2 c4 f2 bf,4 f'2 c2 f1 | }
  \relative d { f2 4 2 bf,4 f'4 c f1 | f2 4 bf,2 f'4 bf, f' c1 | }
  \relative d { f2 c4 g'2 d4 d c f2 bf, | f'2 4 bf,2 f4 c' d c2 f,1 | }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Com -- fort, com -- fort, O my peo -- ple,
  speak of peace, now says our God.
  Com -- fort those who sit in dark -- ness,
  mourn -- ing 'neath their sor -- rows' load.

  Speak un -- to Je -- ru -- sa -- lem
  of the peace that waits for them.
  Tell of all the sins I cov -- er,
  and that war -- fare now is o -- ver.
}
verseB = \lyricmode {
  Hark, the voice of one who's cry -- ing
  in the des -- ert far and near,
  bid -- ding all to full re -- pen -- tance
  since the king -- dom now is here.

  O that warn -- ing cry o -- bey!
  Now pre -- pare for God a way.
  Let the val -- leys rise to meet God
  and the hills bow down to greet God.
}
verseC = \lyricmode {
  O make straight what long was crook -- ed,
  make the rough -- er plac -- es plain.
  Let your hearts be true and hum -- ble,
  as be -- fits God's ho -- ly reign.

  For the glo -- ry of the Lord
  now o'er earth is shed a -- broad.
  And all flesh shall see the to -- ken
  that God's word is nev -- er bro -- ken.
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
    \tempo  2 = 90
  }
}
