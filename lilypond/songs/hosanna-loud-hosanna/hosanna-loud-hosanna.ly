\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Gesangbuch der Herzogl, 1784"
arranger = \smallText "arr. Willliam H. Monk, 1868"
meter = \smallText "ELLACOMBE CMD"
hymnKey = \key a \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Hosanna, loud hosanna"
subtitle = \smallText "For a higher key, see ''I sing the mighty power of God''"
poet = \smallText "Text: Jeannette Threlfall, 1873, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-05-10"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \transpose bf a {
  \relative g' {
    \partial 4 f4 | bf a8( g) f4 bf | d,( ef) f f | g8( a) bf4 c c | d2. \bar "" \break
    \partial 4 f,4 | bf a8( g) f4 bf | d,( ef) f f | g8( a) bf4 4 a | bf2. \bar "" \break
    \partial 4 bf8( c) | d4 c d ef | c( a8 bf) c4 bf8( c) | d4 c d ef | c2. \bar "" \break
    \partial 4 f,4 | bf a8( g) f4 bf | d,( ef) f f | g8( a) bf4 4 a | bf2. \bar "" \break
    \bar "|."
  }
  }
}
alto = {
  \globalParts
  \transpose bf a {
  \relative e' {
    f4 | bf a8( g) f4 f | d4( c8 bf) c4 d | ef f g f | 2.
    f4 | bf a8( g) f4 f | d4( c8 bf) c4 d | ef d8( ef) f4 f | 2.
    d8( ef) | f4 4 4 g | f2 4 d8( ef) | f4 f f g | f2.
    f4 | bf a8( g) f4 f | d4( c8 bf) c4 d | ef d8( ef) f4 f | 2.
  }
  }
}
tenor = {
  \globalParts
  \transpose bf a {
  \relative a {
    f4 | bf a8( g) f4 bf | 2 a4 bf | 4 4 4 a | bf2.
    f4 | bf a8( g) f4 bf | 2 a4 bf | 4 4 c c | d2.
    bf4 | bf c bf bf | a( f8 g) a4 bf | 4 c bf bf | a2.
    f4 | bf a8( g) f4 bf | 2 a4 bf | 4 4 c c | d2.
  }
  }
}
bass = {
  \globalParts
  \transpose bf a {
  \relative d {
    f4 | bf a8( g) f4 d | g2 f4 bf, | ef d ef f | bf,2.
    f'4 | bf a8( g) f4 d | g2 f4 bf, | ef g f f | bf,2.
    bf'4 | bf a bf ef, | f2 f4 bf | bf a bf ef, | f2.
    f4 | bf a8( g) f4 d | g2 f4 bf, | ef g f f | bf,2.
  }
  }
}
songChords = \chords {
  \globalChordSymbols
  \transpose bf a {
  s4 | bf2 2 g:m bf ef f bf bf
       bf2 2 g:m bf ef f bf bf
  bf bf f f bf bf f f
       bf2 2 g:m bf ef f bf bf
  }
}

%% LYRICS
verseA = \lyricmode {
  \l Ho -- san -- na, loud ho -- san -- na, the lit -- tle --  chil -- dren sang.
  \l Through pil -- lared court and tem -- ple the love -- ly an -- them rang.
  \l To Je -- sus, who had blessed them, close fold -- ed to his breast,
  \l the chil -- dren sang their prais -- es, the sim -- plest and the best.

}
verseB = \lyricmode {
  From Ol -- i -- vet they fol -- lowed 'mid an ex -- ult -- ant crowd,
  the vic -- tor palm branch wav -- ing, and chant -- ing clear and loud.
  The Lord of earth and heav -- en rode on in low -- ly state,
  nor scorned that lit -- tle chil -- dren should on his bid -- ding wait.
}
verseC = \lyricmode {
  ''Ho -- san -- na in the high -- est!'' That an -- cient song we sing,
  for Christ is our Re -- deem -- er, the Lord of heav'n, our King.
  Oh, may we ev -- er praise him with heart and life and voice,
  and in his bliss -- ful pres -- ence e -- ter -- nal -- ly re -- joice!
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"