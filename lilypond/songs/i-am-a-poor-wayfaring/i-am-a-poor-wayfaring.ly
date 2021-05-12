\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: American traditional"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "WAYFARING STRANGER 98.98 D"
hymnKey = \key d \minor
hymnTime = \time 2/2
quarternoteTempo = 130
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "I am a poor wayfaring stranger"
poet = \smallText "Text: Christian Songster, 1858, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-05-11"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    r4 d4 d a' | 1~ 4 f g a | f d2. r4 d4 d a' | g1~ 4 d f g | a1 \break
    r4 d,4 d a' | 1~ 4 f g a | f d2. r4 d4 d a' | g1~ 4 f d c | d1 \break
    r4 a'4 a c | d1~ 4 c d c | a4 f2. r4 a4 a c | d1~ 4 c d8( c) a( g) | a1 \break
    r4 d,4 d a' | 1~ 4 f g a | f d2. r4 d4 d a' | g1~ 4 f d c | d1 | \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    r4 d4 d a' | 1~ 4 f g a | f d2. r4 d4 d a' | g1~ 4 d f g | a1 r4
    d,4 d f | 1~ 4 d d d | 4 2. r4 4 4 c | d1~ 4 d bf a | 1 r4
    f'4 4 4 | 1~ 4 e f e | e2 d2 r4 f4 f a | bf2( g2 f4) e4 e e | e1 r4
    d4 d d | f1~ 4 d d d | 4 2. r4 4 4 c | d1~ 4 d d c | d1
  }
}
tenor = {
  \globalParts
  \relative a {
    r4 d,4 d a' | 1~ 4 f g a | f d2. r4 d4 d a' | bf1~ 4 4 4 4 | a1 r4
    a4 a a | 1~ 4 4 bf4 4 | a f2. r4 d4 f a | bf1~ 4 a g g | f1 r4
    a4 4 a4 | bf1( a4) a4 bf a | f4 f2. r4 a4 4 4 | g2( bf a4) c4 c4 4 | d2( cs2) r4
    d4 d d | a1~ 4 4 bf4 4 | a f2. r4 d4 f a | bf1~ 4 a a a | a1
  }
}
bass = {
  \globalParts
  \relative d {
    r4 d4 d a' | 1~ 4 f g a | f d2. r4 d4 d a' | g1~ 4 d f g | a1 r4
    d,4 4 4 | 1~ 4 4 4 4 | 4 2. r4 4 bf a | g1~ 4 a bf c | d1 r4
    d4 4 c | bf2( d2~ 4) d4 d e | d4 d2. r4 4 d c | bf1( a4) a4 a a | a1 r4
    d4 4 4 | 1~ 4 4 4 4 | 4 2. r4 4 bf a | g1~ 4 a a a | d1
  }
}

%% LYRICS
verseA = \lyricmode {
  \l I am a poor way -- far -- ing stran -- ger
  a -- trav -- lin' through this world of woe,
  \l yet there's no sick -- ness, toil or dan -- ger
  in that bright world to which I go.

  \l I'm go -- ing there to see my fa -- ther,
  I'm go -- ing there no more to roam;
  %% CHORUS
  \l I'm just a -- go -- in' o -- ver Jor -- dan,
  I'm just a -- go -- in' o -- ver home.
}
verseB = \lyricmode {
  I know dark clouds will gath -- er round me,
  I know my path -- way's rough and steep,
  but gold -- en fields lie out be -- fore me,
  where wear -- y eyes no more shall weep.

  I'm go -- ing there to see my moth -- er,
  She said she'd meet me when I come;
  %% CHORUS
  \SB {
    I'm just a -- go -- in' o -- ver Jor -- dan,
    I'm just a -- go -- in' o -- ver home.
  }
}
verseC = \lyricmode {
  I'll soon be free from ev -- 'ry tri -- al.
  This form will rest be -- neath the sod.
  I'll drop the cross of self -- den -- i -- al,
  and en -- ter in my home with God.

  I'm go -- ing there to see my sav -- ior,
  to sing his praise for -- ev -- er -- more;
  %% CHORUS
  \SC {
    I'm just a -- go -- in' o -- ver Jor -- dan,
    I'm just a -- go -- in' o -- ver home.
  }
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"