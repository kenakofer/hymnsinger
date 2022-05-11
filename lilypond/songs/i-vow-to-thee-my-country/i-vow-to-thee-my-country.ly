\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Adapted from The Planets, Gustav Holst, 1925"
meter = \smallText "THAXTED 13.13.13 D"
hymnKey = \key bf \major
hymnTime = \time 3/4
quarternoteTempo = 90
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "I vow to thee, my country"
poet = \smallText "Text: Cecil Spring-Rice, 1922"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "english nationalist 1part accompanied"
dateAdded = "2021-05-09"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \phrasingSlurSolid
  \relative g' {
    \partial 4 d8( f) | g4. bf8 a8. f16 | bf8( c) bf4 a | g8 a g4 f | d2 \bar "" \break
    \partial 4 d8( f) | g4. bf8 a8. f16 | bf8( c) d4 d | 8 c bf4 c | bf2 \bar "" \break
    \partial 4 f8( d) | c4. 8 bf d | c4 f4 8( d) | c4. 8 d f | g2 \bar "" \break
    \partial 4 g8( a) | bf8. 16 a4 g | f bf d, | c8 bf c4 d | f2 \bar "" \break
    \partial 4 d8( f) | g4. bf8 a8. f16 | bf8\( c\) bf4 a | g8 a g4 f | d2 \bar "" \break
    \partial 4 d8\( f\) | g4. bf8 a8. f16 | bf8\( c\) d4 d | 8 c bf4 c | \partial 2 bf2 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d4 | ef2 4 | f2 4 | ef2 c4 | bf2
    d4 | ef2 4 | f2 <f bf>4 | <g ef>2 4 | <f d>2
    bf,4 | a2 bf4 | c2 bf4 | a2 bf4 | <bf ef>2
    ef4 | d d ef | f ef bf | g2 bf4 | c( bf)
    d4 | ef2 4 | f2 4 | ef2 c4 | bf2
    d4 | ef2 4 | f2 <f bf>4 | <g ef>2 4 | <f d>2
  }
}
tenor = {
  \globalParts
  \relative a {
    bf4 | 2 c4 | bf2 4 | 2 a4 | g2
    a4 | bf2 c4 | bf2 4 | g bf g | bf2
    f4 | 2 <g d>4 | f2 4 | 2 4 | g2
    c4 | bf4 4 4 | 2 f4 | ef2 g4 | f2
    bf4 | 2 c4 | bf2 4 | 2 a4 | g2
    a4 | bf2 c4 | bf2 4 | g bf g | bf2
  }
}
bass = {
  \globalParts
  \relative d {
    bf4 | ef2 c4 | d2 4 | ef2 f4 | g2
    f4 | ef2 c4 | d2 bf8 d | ef2 4 | bf2
    d8 bf |  f2 g4 | a2 d8 bf | f2 bf4 | ef4( d)
    c4 | g' f ef | d c bf | ef c bf | a( g)
    bf4 | ef2 c4 | d2 4 | ef2 f4 | g2
    f4 | ef2 c4 | d2 bf8 d | ef2 4 | bf2
  }
}
songChords = \chords {
  \globalChordSymbols
  bf4 ef2 f4:7/c | bf2. | ef2 f4 | g2.:m |
      ef2 f4:7/c | bf2. | ef2:maj7 c4:m | bf2. |
      f2 g4:m | f2 bf4 | f2 bf4 | ef2. |
      g2:m ef4 | bf2. | c2:m/ef g4:m | f2.
      ef2 f4:7/c | bf2. | ef2 f4 | g2.:m |
      ef2 f4:7/c | bf2. | ef2:maj7 c4:m | bf2 |
}

%% LYRICS
verseA = \lyricmode {
  \l I vow to thee, my coun -- try, all earth -- ly things a -- bove,
  \l en -- tire and whole and per -- fect, the ser -- vice of my love:
  \l the love that asks no ques -- tion, the love that stands the test,
  \l that lays up -- on the al -- tar the dear -- est and the best;
  \l the love that nev -- er fal -- _ ters, the love that pays the price,
  \l the _ love that makes un -- daunt -- _ ed the fin -- al sac -- ri -- fice.
}
verseB = \lyricmode {
  And there's an -- oth -- er coun -- try I've heard of long a -- go,
  most dear to them that love her, most great to them that know;
  we may not count her ar -- mies, we may not see her King;
  her for -- tress is a faithful heart, her pride is suf -- fer -- ing;
  and soul by soul and sil -- ent -- ly her shin -- ing bounds in -- crease,
  and her ways are ways of gen -- tle -- ness and all her paths are peace.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"