\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Lizzie S. Tourjee, 1878"
meter = \smallText "WELLESLEY 87.87"
hymnKey = \key bf \major
hymnTime = \time 2/2
quarternoteTempo = 100
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "There's a wideness in God's mercy"
poet = \smallText "Text: Frederick W. Faber, 1861"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english christian 4part"
dateAdded = "2021-05-13"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \transpose d c {
  \relative g' {
    g4 c8( d) c4 b | g d'8( e) d4 c | a g f e | d fs g2
    g4 a8( g) 4 e'8( c) | g4 a8( g) 4 c | 4 4 8( e) c( a) | g4 d' c2 | \bar "|."
  }
  }
}
alto = {
  \globalParts
  \transpose d c {
  \relative e' {
    e4 4 f f | f f e e | c c b8( d) c( cs) | d4 c b2 |
    f'4 4 e e | f f e e | e f e4 8( f) | d4 f e2 |
  }
  }
}
tenor = {
  \globalParts
  \transpose d c {
  \relative a {
    g4 4 4 4 | 4 4 4 4 | f g g g | fs a g2
    b4 4 c g | g b c g | c c c8( b) a( c) | c( b) a( b) c2 |
  }
  }
}
bass = {
  \globalParts
  \transpose d c {
  \relative d {
    c4 4 d g, | b g c c | f e d8( b) c( a) | d4 4 g,2 |
    g'4 4 c, c | b g c c | a' af g8( gs) a( f) | g4 g, c2 |
  }
  }
}
songChords = \chords {
  \globalChordSymbols
  \transpose d c {
    c2 g:7 g:7 c f4 c g c d2 g
    g:7 c g:7 c a4:m f:m c f g2:7 c
  }
}

%% LYRICS
verseA = \lyricmode {
  \l There's a wide -- ness in God's mer -- cy
  like the wide -- ness of the sea.
  \l There's a kind -- ness in God's jus -- tice,
  which is more than lib -- er -- ty.
}
verseB = \lyricmode {
  There is wel -- come for the sin -- ner,
  and more grac -- es for the good.
  There is mer -- cy with the Sav -- ior,
  there is heal -- ing in his blood.
}
verseC = \lyricmode {
  But we make God's love too nar -- row
  by false lim -- its of our own,
  and we mag -- ni -- fy its strict -- ness
  with a zeal God will not own.
}
verseD = \lyricmode {
  For the love of God is broad -- er
  than the mea -- sures of the mind,
  and the heart of the E -- ter -- nal
  is most won -- der -- ful -- ly kind.
}
verseE = \lyricmode {
  If our love were but more sim -- ple,
  we should rest up -- on God's word,
  and our lives would be il -- lu -- mined
  by the pres -- ence of our Lord.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/5verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-5verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"