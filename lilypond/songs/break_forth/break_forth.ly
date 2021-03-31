\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Johann Schop, 1641"
arranger = \smallText "arr. J. S. Bach, 1734"
meter = \smallText "ERMUNTRE DICH 87.87.88.77"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 70
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Break forth, O beauteous heavenly light"
poet = \smallText "Text: Johann Rist, 1641, tr. John Troutbeck ca. 1885"
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english christian 4part morning"
dateAdded = "2021-01-08"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 f4 | f g a8 b c4 | c b c a | bf a g a | \partial 2. g2 \m f2. f4\fermata | } \break
  \relative g' { \partial 4 f4 | f g a8 b c4 | c b c a | bf a g a | \partial 2. g2 \m f2. f4\fermata | } \break
  \relative g' { \partial 4 g4 | g a bf bf | a8 g a4 g a | a a bf8 c d4 | \partial 2. d cs d | } \break
  \relative g' { \partial 4 e'4 | f a, bf a | g2 g4 c | d c bf a8 bf | \partial 2. g2 \m f2. f4\fermata | }
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c4 | d e c8 d e4 | d8 e f4 e e | d c8 d e4 f~ | f e \m c2. c4 | }
  \relative e' { c4 | d e c8 d e4 | d8 e f4 e e | d c8 d e4 f~ | f e \m c2. c4 | }
  \relative e' { e8 f | g4. fs8 g fs g4 | g fs d d8 cs | d4 d d8 e f e | e f g4 f | }
  \relative e' { g4 | f8 g a4~ a8 g~ g f | f2 e4 f8 e | d4 e f8 g c,4 | d( c) \m c2. c4 | }
}
tenor = {
  \globalParts
  \relative a { a4 | a8 b~ b c a g g4 | g g g a8 g | f g a bf c4 c | c4. bf8 \m a2. a4_\fermata \bar " "| }
  \relative a { a4 | a8 b~ b c a g g4 | g g g a8 g | f g a bf c4 c | c4. bf8 \m a2. a4_\fermata \bar " "| }
  \relative a { c8 d | e d c4 d e | a, d8 c bf4 f8 g | a bf c d bf4 b | a a a \bar " " | }
  \relative a { c4 | c f f,8 g a4 | d8 c d b c4 c | c8 bf bf a a g f4 | f8( e16 d e4) \m a2. a4_\fermata |}
}
bass = {
  \globalParts
  \relative d { f8 e | d4 c f e8 f | g4 g, c cs | d8 e f bf, bf' a g f | c'4 c, \m f2. f4 }
  \relative d { f8 e | d4 c f e8 f | g4 g, c cs | d8 e f bf, bf' a g f | c'4 c, \m f2. f4 }
  \relative d { c4 | c'8 bf a4 g cs, | d d g, d'8 e | f4 fs g gs | a a, d | }
  \relative d { c'8 bf | a g f e d e f d | b a b g c4 a | bf c d8 e f4 | bf,( c) \m f,2. f4 | }
}

%% LYRICS
verseA = \tag #'verseA \lyricmode {
    Break forth, O beau -- _ teous heav'n -- ly light, and ush -- er in the morn -- ing.
    O shep -- herds, shrink _ not with af -- fright, but hear the an -- gel's warn -- ing.
    This child, now weak in in -- _ fan -- cy, our con -- fi -- dence _ and joy shall be,
    the power of Sa -- tan break -- ing, our peace e -- ter -- nal _ mak -- ing.
}

all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
