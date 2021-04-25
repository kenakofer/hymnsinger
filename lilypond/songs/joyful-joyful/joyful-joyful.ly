\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Ludwig van Beethoven, 1823"
meter = \smallText "HYMN TO JOY 87.87 D"
hymnKey = \key g \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Joyful, joyful, we adore thee"
poet = \smallText "Text: Henry van Dyke, 1907"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-01-13"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    b4 b c d | d c b a | g g a b | b4. a8 a2 | \break
    b4 b c d | d c b a | g g a b | a4. g8 g2 | \break
    a4 a b g | a b8( c) b4 g | a b8( c) b4 a | g a d,2 | \break
    b'4 b c d | d c b a | g g a b | a4. g8 g2 \break
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d4 d d d | d d d d | d4 d d d | d4. d8 d2 |
    d4 d e f | f e d c | d4 d fs g | fs4. d8 d2 |
    d4 d d d | fs4 d d d | fs4 g8( fs8) fs4 ds | e4 cs d2 |
    d4 d e f | f e e e | d d fs g | fs4. d8 d2 |
  }
}
tenor = {
  \globalParts
  \relative a {
    g4 g a b | b a g fs | g4 g fs g | g4. fs8 fs2 |
    g4 g g a8 b | b4 c d c | b b c d | c4. b8 b2 |
    fs4 fs g b | d4 g,8 a g4 b | c4 b8 a b4 b | b a fs2 |
    g4 g g a8 b | c4 c d c | b4 b c d | c4. b8 b2
  }
}
bass = {
  \globalParts
  \relative d {
    g4 g g g | d d d c | b4 b a g | d'4. d8 d2 |
    g4 g g g | c, c c c | d d d d | d4. g8 g,2 |
    d'4 d d d | d d d d | d d ds b | e a, d2 |
    g,4 g' g g | c, c c c | d d d d | d4. g8 g,2 |
  }
}


%% LYRICS
verseA = \lyricmode {
  \l Joy -- ful, joy -- ful, we a -- dore thee, God of glo -- ry, Lord of love.
  \l Hearts un -- fold like flow'rs be -- fore thee, prais -- ing thee their sun a -- bove.
  \l Melt the clouds of sin and sad -- ness; drive the dark of doubt a -- way.
  \l Giv -- er of im -- mor -- tal glad -- ness, fill us with the light of day!
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

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"