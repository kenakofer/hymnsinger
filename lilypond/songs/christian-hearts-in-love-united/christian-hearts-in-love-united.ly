\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Johann Thommen, 1735"
meter = \smallText "O DU LIEBE MEINER LIEBE"
hymnKey = \key g \major
hymnTime = \time 2/2
quarternoteTempo = 110
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Christian hearts in love united"
poet = \twoLineSmallText "Text: Nicolaus Ludwig von Zinzendorf, 1723;" "tr. Frederick William Foster"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-04-23"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    g4 a b d | c b a a | b a g a | g fs g2 | \break
    g4 a b d | c b a a | b a g a | g fs g2 | \break
    fs4 g a a | a g8( fs) e4 4 | fs g a b | c b a2 | \break
    g4 a b d | c b a a | b a g a | g fs g2 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d4 fs g g | e8( fs) g4 fs fs | g fs e e | d d d2 |
    d4 fs g g | e8( fs) g4 fs fs | g fs e e | d d d2 |
    d4 d cs d | d d cs cs | d b d d | e d8( e) fs2 |
    d4 fs g g | e8( fs) g4 fs fs | g fs e e | d d d2 |
  }
}
tenor = {
  \globalParts
  \relative a {
    b4 d d b | c d d d | d d8( c) b4 c | b a b2 |
    b4 d d b | c d d d | d d8( c) b4 c | b a b2 |
    a4 g e fs | a b e, a | a g fs g | g8( a) b( cs) d2 |
    b4 d d b | c d d d | d d8( c) b4 c | b a b2 |
  }
}
bass = {
  \globalParts
  \relative d {
    g4 d g g, | a b8( c) d4 d | g d e c | d d g,2 |
    g'4 d g g, | a b8( c) d4 d | g d e c | d d g,2 |
    d'4 b a d | fs, g a a | d e d g | e8( fs) g4 d2 |
    g4 d g g, | a b8( c) d4 d | g d e c | d d g,2 |
  }
}
songChords = \chords {
  \globalChordSymbols
  g1 a2:m d g e:m d g
  g1 a2:m d g e:m d g
  d2 a d a d d c4 g d2
  g1 a2:m d g e:m d g
}

%% LYRICS
verseA = \lyricmode {
  \l Chris -- tian hearts in love u -- nit -- ed:
  search to know God's ho -- ly will.
  \l Let his love in us ig -- nit -- ed,
  more and more our spir -- its fill.
  \l Christ the head, and we his mem -- bers—
  we re -- flect the light he is.
  \l Christ the mas -- ter, we dis -- ci -- ples—
  he is ours, and we are his.
}

verseB = \lyricmode {
  Grant, lord, that with your di -- rec -- tion,
  ''Love each oth -- er'' we com -- ply.
  Help us live in true af -- fec -- tion,
  your love to ex -- em -- pli -- fy.
  Let our mu -- tual love be glow -- ing
  bright -- ly so that all may view
  that we, as on one stem grow -- ing,
  liv -- ing branch -- es are in you.
}
verseC = \lyricmode {
  Come, then, liv -- ing church of Je -- sus,
  cov -- e -- nant with him a -- new.
  Un -- to him who con -- quered for us
  may we pledge our ser -- vice true.
  May our lives re -- flect the bright -- ness
  of God's love in Je -- sus shown.
  To the world we then bear wit -- ness:
  we be -- long to God a -- lone.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"