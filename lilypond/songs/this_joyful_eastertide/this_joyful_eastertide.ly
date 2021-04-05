\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Dutch traditional, David's Psalmen, 1685"
arranger = \smallText "arr. Charles Wood, 1902"
meter = \smallText "VRUECHTEN 67.67 with refrain"
hymnKey = \key f \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "This joyful Eastertide"
poet = \smallText "Text: George R. Woodward, 1894"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian easter 4part"
dateAdded = "2021-04-04"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 c,4 | f g a bf | c2. 4 | d4. c8 bf4 d | c4.( bf8 a4 g8 f | g2) \m f2. f4\fermata \bar "" \break
    \partial 4 c4 | f g a bf | c2. 4 | d4. c8 bf4 d | c4.( bf8 a4 g8 f | g2) \m f2. f4\fermata \bar "||" \break
    \partial 4 f4 | g a bf a | g4. a8 bf4 c | d c c( b) | c2. \bar "" \break
    \partial 4 c4 | bf bf a a | g2. f4 | e f g a | bf2 g4 g | \break
    c2 a4 a | d2 c4 c | f4.( e8 d4 c8 bf | a4 g8 f g2) | f2. \bar "" \break
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    c4 | c d8( e) f4 f | f( e8 d e4) f | f f d d | g2( f4 c | d e) \m c2. c4
    c4 | c d8( e) f4 f | f( e8 d e4) f | f f d d | g2( f4 c | d e) \m c2. c4
    c4 | c c d c8( d) | e4. f8 f4 ef | d f d2 | e2.
    c4 | d4. e8 f( e) f4 | d2. c4 | 4. b8 c4 c | d2 c4 c
    e2 d4 d | f2 g8( f) e4 | f2.( g4 | c,2 d4 e) | c2.
  }
}
tenor = {
  \globalParts
  \relative a {
    a4 | c bf a f | g2. a4 | bf a bf4 8( a) | g4( c2 a4 | bf8 a g4) \m a2. a4
    a4 | c bf a f | g2. a4 | bf a bf4 8( a) | g4( c2 a4 | bf8 a g4) \m a2. a4
    a4 | g f f8( g) a( bf) | c4. 8 bf( f) g( a) | bf4 a g2 | g2.
    a4 | g g d'4. c8 | bf2. a4 | g f e f | f4( g8 f) e4 g |
    g4( a8 g) f4 a | a4( bf8 a) g4 c | c4( a bf g | a c bf8 a g4) | a2.
  }
}
bass = {
  \globalParts
  \relative d {
    f4 | a g f8( e) d4 | c2. f4 | bf f g g8( f) | e2( f | bf,4 c) \m f2. f4_\fermata
    f4 | a g f8( e) d4 | c2. f4 | bf f g g8( f) | e2( f | bf,4 c) \m f2. f4_\fermata
    f4 | e f d8( e) f4 | c4. f8 d4 c | bf f' g2 c,2.
    a4 | bf4. c8 d4 d | g,2. a8( b) | c4 d c f | bf,2 c8( d) e( d)
    c2 d8( e) f( e) | d2 e4 c'8( bf) | a( g f4 bf8 a e4 | f a, bf c) | f,2.
  }
}

%% LYRICS
verseA = \lyricmode {
  \l This joy -- ful Eas -- ter -- tide, a -- way with sin and sor -- row!
  \l My love, the cru -- ci -- fied, hath sprung to life this mor -- row.
  %% CHORUS
  Had Christ, who once was slain, ne'er burst his three -- day pris -- on,
  our faith had been in vain. But now hath Christ a -- ris -- en,
  a -- ris -- en, a -- ris -- en, a -- ris -- en.
}
verseB = \lyricmode {
  My flesh in hope shall rest and for a sea -- son slum -- ber
  till trum -- pets east to west shall wake the dead in num -- ber.
  %% CHORUS
  \SB {
    Had Christ, who once was slain, ne'er burst his three -- day pris -- on,
    our faith had been in vain. But now hath Christ a -- ris -- en,
    a -- ris -- en, a -- ris -- en, a -- ris -- en.
  }
}
verseC = \lyricmode {
  Death's flood hath lost its chill since Je -- sus crossed the riv -- er.
  Lov -- er of souls, from ill my pass -- ing soul de -- liv -- er.
  %% CHORUS
  \SC {
    Had Christ, who once was slain, ne'er burst his three -- day pris -- on,
    our faith had been in vain. But now hath Christ a -- ris -- en,
    a -- ris -- en, a -- ris -- en, a -- ris -- en.
  }
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ly"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output. Change to the correct number
\include "../../lib/slides_book_3verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"