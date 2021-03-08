\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 4verse musicbyother textbyother"
\header {
  title = \titleText "Joyful, joyful, we adore thee"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Ludwig van Beethoven, 1823"
  %arranger = \smallText "Arranged by Edward Hodges, 1864"
  poet = \smallText "Text: Henry van Dyke, 1907"
  meter = \smallText "HYMN TO JOY 87.87 D"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key g \major
hymnTime = \time 2/2
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
  \relative g' { b4 b c d | d c b a | g g a b | b4. a8 a2 | } \break
  \relative g' { b4 b c d | d c b a | g g a b | a4. g8 g2 | } \break
  \relative g' { a4 a b g | a b8( c) b4 g | a b8( c) b4 a | g a d2 | } \break
  \relative g' { b4 b c d | d c b a | g g a b | a4. g8 g2 }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 d d d | d d d d | d4 d d d | d4. d8 d2 | }
  \relative e' { d4 d e f | f e d c | d4 d fs g | fs4. d8 d2 | }
  \relative e' { d4 d d d | fs4 d d d | fs4 g8( fs8) fs4 ds | e4 cs d2 | }
  \relative e' { d4 d e f | f e e e | d d fs g | fs4. d8 d2 | }
}
tenor = {
  \globalParts
  \relative a { g4 g a b | b a g fs | g4 g fs g | g4. fs8 fs2 | }
  \relative a { g4 g g a8 b | b4 c d c | b b c d | c4. b8 b2 | }
  \relative a { fs4 fs g b | d4 g,8 a g4 b | c4 b8 a b4 b | b a fs2 | }
  \relative a { g4 g g a8 b | c4 c d c | b4 b c d | c4. b8 b2 }

}
bass = {
  \globalParts
  \relative d { g4 g g g | d d d c | b4 b a g | d4. d8 d2 | }
  \relative d { g4 g g g | c, c c c | d d d d | d4. g8 g,2 | }
  \relative d { d4 d d d | d d d d | d d ds b | e a, d2 | }
  \relative d { g,4 g' g g | c, c c c | d d d d | d4. g8 g,2 | }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Joy -- ful, joy -- ful, we a -- dore thee, God of glo -- ry, Lord of love.
  Hearts un -- fold like flow'rs be -- fore thee, prais -- ing thee their sun a -- bove.
  Melt the clouds of sin and sad -- ness; drive the dark of doubt a -- way.
  Giv -- er of im -- mor -- tal glad -- ness, fill us with the light of day!
}
verseB = \lyricmode {
  All thy works with joy sur -- round thee, earth and heav'n re -- flect thy rays,
  stars and an -- gels sing a -- round thee, cen -- ter of un -- bro -- ken praise.
  Field and for -- est, vale and moun -- tain, bloom -- ing mead -- ow, flash -- ing sea,
  chart -- ing bird and flow -- ing foun -- tain call us to re -- joice in thee.
}
verseC = \lyricmode {
  Thou art giv -- ing and for -- giv -- ing, ev -- er bless -- ing, ev -- er bless'd,
  well -- spring of the joy of liv -- ing, o -- cean -- depth of hap -- py rest!
  Thou our Ma -- ker, Christ our broth -- er, all who live in love are thine.
  Teach us how to love each oth -- er, lift us to the joy di -- vine.
}
verseD = \lyricmode {
  Mor -- tals join the might -- y cho -- rus which the morn -- ing stars be -- gan.
  Love di -- vine is reign -- ing o'er us, lead -- ing us with mer -- cy's hand.
  Ev -- er sing -- ing, march we on -- ward, vic -- tors in the midst of strife.
  Joy -- ful mu -- sic lifts us sun -- ward in the tri -- umph song of life!
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
