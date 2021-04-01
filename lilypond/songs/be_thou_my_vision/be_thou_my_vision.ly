\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Irish melody, 1909"
arranger = \smallText "arr. Martin Shaw, 1931"
meter = \smallText "SLANE 10.10.9.10"
hymnKey = \key ef \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Be thou my vision"
poet = \smallText "Text: Ancient Irish, tr. Mary Elizabeth Byrne, 1905"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english theist 4part"
dateAdded = "2021-01-13"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { ef4 ef f8( ef) | c4 bf bf8( c) | ef4 ef f | g2. | } \break
  \relative g' { f4 4 4 | f g bf | c bf g | bf2. | } \break
  \relative g' { c4 8( d) ef( d) | c4( bf) g | bf4 ef, d | c2( bf4) | } \break
  \relative g' { ef4 g bf | c8( bf) g4 ef8( g) | f4 ef ef | ef2. | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { bf4 4 c | c bf bf8 c8 | g4 c d | ef2. | }
  \relative e' { d4 d c | d ef f | ef f g | f2. |}
  \relative e' { af4 4 4 | af4( g) ef | bf g g | af2( bf4) | }
  \relative e' { bf4 ef f | g ef ef | c c af | bf2. | }
}
tenor = {
  \globalParts
  \relative a { g4 g af | g g f | g g bf | bf2. | }
  \relative a { bf4 bf af | bf bf bf | g bf4. c8 | d2. | }
  \relative a { ef'4 8 d c d | ef2 bf4 | ef,4 4 4 | 2( bf'4) | }
  \relative a { g4 c d | ef4 bf g8 ef | af4 4 4 | g2. | }
}
bass = {
  \globalParts
  \relative d { ef4 4 af, | ef'4 4 d | c4 c bf | ef2. |}
  \relative d { bf4 4 f' | bf, ef d | c d ef | bf2. |}
  \relative d { af'4 4 4 | ef2 4 | g,4 c bf | af2( bf4) | }
  \relative d { ef4 c bf | g g c | af af c | ef2. }
}

%% LYRICS
verseA = \lyricmode {
  \l Be thou my vi -- sion, O Lord of my heart;
  \l naught be all else to me save that thou art.
  \l Thou my best thought, by day or by night,
  \l wak -- ing or sleep -- ing thy pres -- ence my light.
}
verseB = \lyricmode {
  Be thou my wis -- dom, be thou my true word;
  I ev -- er with thee, and thou with me, Lord.
  Thou my great Ma-ker, thy child may I be,
  thou in me dwell -- ing, and I one with thee.
}
verseC = \lyricmode {
  Be thou my buck -- ler, my sword for the fight.
  Be thou my dig -- ni -- ty, thou my de -- light,
  thou my soul's shel -- ter, thou my high tower.
  Raise thou me heav'n -- ward, O Pow'r of my pow'r.
}
verseD = \lyricmode {
  Rich -- es I heed not, nor vain, emp -- ty praise;
  thou mine in -- her -- i -- tance, now and al -- ways.
  Thou and thou on -- ly, first in my heart,
  high King of heav -- en, my trea -- sure thou art.
}
verseE = \lyricmode {
  High King of heav -- en, when vic -- t'ry is won
  may I reach heav -- en's joys, O bright heav'n's Sun!
  Heart of my heart, what -- ev -- er be -- fall,
  still be my vi -- sion, O Rul -- er of all.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "1" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "2" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "3" \verseC } }
  \tag #'verseD { \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "4" \verseD } }
  \tag #'verseE { \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "5" \verseE } }
>>

%% All sheet music outputs
clairStaffZoom = #.9
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_5verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"