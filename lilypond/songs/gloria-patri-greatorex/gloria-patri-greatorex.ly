\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: H. W. Greatorex, 1851"
meter = \smallText "GLORIA PATRI (Greatorex) 7.10.8.7.8"
hymnKey = \key d \major
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Glory be to the Father"
poet = \smallText "Text: Anonymous, 2nd c."
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english spanish christian 4part"
dateAdded = "2021-05-10"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    d4. 8 4 8 8 | 4 cs2 d4 | e2 a | 4 4 4 b | \break
    cs2 b | a2. 8 8 | 4 fs b a | a g2 4 | 4 e a g | \break
    g\( fs2.\) | cs'2 4 4 | d2 d,4\( e\) | fs2 4( e) | d1 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    a,4. 8 4 8 8 | 4 2 4 | 2 cs | d4 fs e fs |
    e2 4( d) | cs2. 8 8 | d4 4 4 4 | cs4 2 4 | 4 4 4 e |
    e\( d2.\) | e2 fs4 e | d2 a4\( b\) | a2 cs | d1 |
  }
}
tenor = {
  \globalParts
  \relative a {
    fs4. 8 4 8 8 | g4 2 fs4 | e2 2 | fs4 a a a |
    a2 gs | a2. 8 g | fs4 d g fs | e4 2 4 | 4 a e a |
    a\( 2.\) | 2 4 4 | 2 d,4\( 4\) | d2 g | fs1 |
  }
}
bass = {
  \globalParts
  \relative d {
    d4. 8 4 8 8 | e4 2 d4 | cs2 a | d4 4 cs d |
    e2 2 | a,2. 8 8 | d4 4 4 4 | a4 2 4 | 4 4 4 4
    d4\( 2.\) | g2 4 4 | fs2 fs,4\( g\) | a2 2 | d1
  }
}

%% LYRICS
verseA = \lyricmode {
  \l Glo -- ry be to the Fa -- ther
  and to the Son and to the \l Ho -- ly Ghost,
  as it was in the be -- gin -- ning,
  is now and ev -- er \l shall be,
  world with -- out end. A -- _ men, a -- men.
}
verseB = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  Glo -- ria~al Pa -- dre y~al Hi -- jo
  y~al San -- to~Es -- pí -- ri -- tu, en u -- ni -- dad.
  Co -- mo e -- ra~en el prin -- ci -- pio,
  es hoy y~ha -- brá de ser, _
  e -- ter -- na -- men -- te. A -- mén, a -- mén.
}
spacingVerse = \lyricmode {
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
}

all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "Eng." "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "Span." "" \verseB } }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"