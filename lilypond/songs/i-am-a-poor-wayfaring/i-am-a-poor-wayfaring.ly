\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: American traditional"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "WAYFARING STRANGER 98.98 D"
hymnKey = \key d \minor
hymnTime = \time 4/4
quarternoteTempo = 70
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "I am a poor wayfaring stranger"
poet = \smallText "Text: Christian Songster, 1858"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-05-11"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4. d8 d a' | 2~ 8 f g a | f d4. r8 d8 d a' | g2~ 8 d f g | a2 r8 \bar "" \break
    d,8 d a' | 2~ 8 f g a | f d4. r8 d8 d a' | g2~ 8 f d c | d2 r8 \bar "" \break
    a'8 a c | d2~ 8 c d c | a8 f4. r8 a8 a c | d2~ 8 c d16( c) a( g) | a2 r8 \bar "" \break
    d,8 d a' | 2~ 8 f g a | f d4. r8 d8 d a' | g2~ 8 f d c | d2 \partial 8 r8 | \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d8 d a' | 2~ 8 f g a | f d4. r8 d8 d a' | g2~ 8 d f g | a2 r8
    d,8 d[ f] | 2~ 8 d d d | 8 4. r8 8 8[ c] | d2~ 8 d bf a | 2 r8
    f'8 8 8 | 2~ 8 e f e | e4 d4 r8 f8 f a | bf4( g4 f8) e8 e e | e2 r8
    d8 d[ d] | f2~ 8 d d d | 8 4. r8 8 8[ c] | d2~ 8 d d c | d2 r8
  }
}
tenor = {
  \globalParts
  \relative a {
    d,8 d a' | 2~ 8 f g a | f d4. r8 d8 d a' | bf2~ 8 8 8 8 | a2 r8
    a8 a a | 2~ 8 8 bf8 8 | a f4. r8 d8 f a | bf2~ 8 a g g | f2 r8
    a8 8 a8 | bf2( a8) a8 bf a | f8 f4. r8 a8 8 8 | g4( bf a8) c8 c8 8 | d4( cs4) r8
    d8 d d | a2~ 8 8 bf8 8 | a f4. r8 d8 f a | bf2~ 8 a a a | a2 r8
  }
}
bass = {
  \globalParts
  \relative d {
    d8 d a' | 2~ 8 f g a | f d4. r8 d8 d a' | g2~ 8 d f g | a2 r8
    d,8 8 8 | 2~ 8 8 8 8 | 8 4. r8 8 bf a | g2~ 8 a bf c | d2 r8
    d8 8 c | bf4( d4.) d8 d e | d8 d4. r8 8 d c | bf2( a8) a8 a a | a2 r8
    d8 8 8 | 2~ 8 8 8 8 | 8 4. r8 8 bf a | g2~ 8 a a a | d2 r8
  }
}
songChords = \chords {
  \globalChordSymbols
  c2:7 g4:sus g:m
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

%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"