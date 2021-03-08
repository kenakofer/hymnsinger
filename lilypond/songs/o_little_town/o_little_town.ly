\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Lewis H. Redner, 1874"
meter = \smallText "ST. LOUIS 86.86.76.86"
hymnKey = \key f \major
hymnTime = \time 4/4
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "O little town of Bethlehem"
poet = \smallText "Text: Phillips Brooks, 1874"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "christian 4part acapella 4verse musicbyother textbyother winter evening"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 a4 | a a gs a | c bf d, g | f e8( f) g4 c, | \partial 2. a'2. \bar " " | } \break
  \relative g' { \partial 4 a4 | a a d c | c bf d, g | f e8( f) a4 g | \partial 2. f2. \bar " " |} \break
  \relative g' { \partial 4 a4 | a a g f | e2 4 e | d e f g | \partial 2. a2. \bar " " | } \break
  \relative g' { \partial 4 a4 | a a gs a | c bf d, d' | c f, a4. g8 | \partial 2. f2. | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c4 | c c b c | ef d bf d | c c c c | c2. | }
  \relative e' { c4 | c f fs fs | g d bf d | c c e e | f2. | }
  \relative e' { f4 | f f e d | cs2 4 4 | d e f d | e2. | }
  \relative e' { f4 | c c b c | d d bf d8 e | f4 b, c4. bf8 | a2. | }
}
tenor = {
  \globalParts
  \relative a { f4 | f f f f | fs g g bf | a g8 a bf4 bf | a2. | }
  \relative a { f4 | f a a d | d d d bf | a gs8( a) c4 bf | a2. | }
  \relative a { c4 | c a bf b | cs2 cs4 cs | d,4 e f d' | cs2. | }
  \relative a { c4 | c a f f | fs g g bf | a g8 f f4. e8 | f2. | }
}
bass = {
  \globalParts
  \relative d { f4 | f f f f | bf,4 4 4 4 | c c c c | f,2. | }
  \relative d { f4 | f ef d d | g g g, bf | c4. 8 4 4 | f2. | }
  \relative d { f4 | f f g gs | a2 4 a, | d e f bf | a2. | }
  \relative d { f4 | f f f f | bf,4 4 4 4 | c d c4. 8 | f,2. | }
}


%% LYRICS
verseA = \lyricmode {
  O lit -- tle town of Beth -- le -- hem, how still we see thee lie!
  A -- bove thy deep and dream -- less sleep the si -- lent stars go by.
  Yet in thy dark streets shin -- eth the ev -- er -- last -- ing light;
  the hopes and fears of all the years are met in thee to -- night.
}
verseB = \lyricmode {
  For Christ is born of Ma -- _ ry, and gath -- ered all a -- bove,
  while mor -- tals sleep, the an -- gels keep their watch of won -- d'ring love.
  O morn -- ing stars, to -- geth -- er pro -- claim the ho -- ly birth!
  and prais -- es sing to God the King, and peace to all the earth!
}
verseC = \lyricmode {
  How si -- lent -- ly, how si -- lent -- ly, the won -- drous gift is giv'n!
  So God im -- parts to hu -- man hearts the bless -- ings of the heav'ns.
  No ear may hear his com -- ing, but in this world of sin,
  where meek souls will re -- ceive him still the dear Christ en -- ters in.
}
verseD = \lyricmode {
  O ho -- ly Child of Beth -- le -- hem, de -- scend to us we pray,
  cast out our sin, and en -- ter in, be born in us to -- day!
  We hear the Christ -- mas an -- gels the great glad tid -- ings tell.
  O come to us, a -- bide with us, our Lord Im -- man -- u -- el!
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
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
    \tempo  4 = 110
  }
}
