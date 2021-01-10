\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"
\header {
  title = \titleText "'Tis a gift to be simple"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Joseph Bracket, 1848"
  arranger = \smallText "Arranged by Kenan Schaefkofer, 2021"
  poet = \smallText "Text: Joseph Bracket, 1848"
  meter = \smallText "SIMPLE GIFTS IRREGULAR"
  copyright =\smallText "Public Domain. Free to distribute, modify, and perform. Typeset by Kenan Schaefkofer."
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key f \major
hymnTime = \time 4/4
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
  \relative g' { \partial 4 c,8 c | f4 8 g a f a bf | c4 8 bf a4 g8 f | g4 g g f | \partial 2. g8 a g f c4 \bar " "} \break
  \relative g' { \partial 4 c,4 | f8 e f g a( f) a bf | c4 8( bf) a4 g8( f) | g4 8 8 a4 8 g | f4 8 8 f4 r } \break
  \relative g' { c2 a4. g8 | a bf a g f4. g8 | a4 8 bf c4 bf8 a | \partial 2. g4 g8 a g4 \bar " " } \break
  \relative g' {\partial 4 r8 c, | f2 a4. bf8 | c4 8 bf a4 g8 f | g4 g a4 8 g | \partial 2. f4 f f }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c8 8 | 4 d8 e f f f g | f4 8 8 f4 e8 d | c4 e e d4 | d8 d d d c4 }
  \relative e' { c | 8 c d e f4 8 g | a( g) f4 f4 f | f8 e d d d4 e8 e | f4 d8 d c4 r }
  \relative e' { f2 f4. c8 | f8 f f e d4. e8 | f4 f8 e e4 d8 d | e4 8 f e4 |  }
  \relative e' { r8 c | c2 4. 8 | c8( d) e g f4 e8 f | f( e) d4 d e8 e | f4 d c | }
}
tenor = { 
  \globalParts
  \relative a { c8 c | a4 8 c c a a g | a4 g8 g a4 bf8 bf | c4 c c8( bf) a4 | bf8 c bf g c( bf) |  }
  \relative a { a8( g) | f f a c c4 8 bf | a4 a4 a4 bf | g a8 g f4 a8 bf | bf8( a) g8 g a4 r | }
  \relative a { c2 4. 8 | a8 g a bf a4. bf8 | c4 8 bf a4 bf8 c | c4 8 8 4 |  }
  \relative a { r8 c | f,2 f8( g a) bf | c4 g8 g a4 bf | g4 a8 g f4 a8 bf | bf( a) g4 a4 | }
}
bass = {
  \globalParts
  \relative d { f8 f | f8( e) d c f f f c | f4 bf,8 8 c4 8 d | e4 c c c | g8 a bf b c4}
  \relative d { c4 | f8 f f c c4 c8 c | f4 e d c | bf d8 8 4 c8 c | bf4 8 8 f'4 r | }
  \relative d { f2 4. e8 | d8 d c c d4. c8 | f4 8 g a4 f8 f | c4 8 8 c4 | }
  \relative d { r8 c | bf8( c d e) f4. f8 | f4 c8 c d4 c | bf d8 d8 4 c8 c | bf4 4 f4}
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  'Tis a gift to be sim -- ple, 'tis a gift to be free, 'tis a gift to come down where we ought to be.
  And when we find our -- selves in the place just right 'twill be in the val -- ley of love and de -- light.
  
  When true sim -- pli -- ci -- ty is gained, to bow and to bend we will not be a -- shamed;
  to turn, turn, will be our de -- light, till by turn -- ing, turn -- ing we come round right.
}
verseB = \lyricmode { }
verseC = \lyricmode { }
verseD = \lyricmode { }
verseE = \lyricmode { }
verseF = \lyricmode { }

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
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
    \tempo  4 = 70
  }
}
