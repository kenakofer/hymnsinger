\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Gesangbuch der Herzogl, 1784"
arranger = \smallText "arr. Willliam H. Monk, 1868"
meter = \smallText "ELLACOMBE CMD"
hymnKey = \key bf \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "I sing the mighty power of God"
poet = \smallText "Text: Isaac Watts, 1715, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english theist 4part"
dateAdded = "2021-03-29"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 f4 | bf a8( g) f4 bf | d, ef f f | g8( a) bf4 c c | d2. \bar "" \break
    \partial 4 f,4 | bf a8( g) f4 bf | d, ef f f | g8( a) bf4 4 a | bf2. \bar "" \break
    \partial 4 bf8( c) | d4 c d ef | c a8( bf) c4 bf8( c) | d4 c d ef | c2. \bar "" \break
    \partial 4 f,4 | bf a8( g) f4 bf | d, ef f f | g8( a) bf4 4 a | bf2. \bar "" \break
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    f4 | bf a8( g) f4 f | d4 c8( bf) c4 d | ef f g f | 2.
    f4 | bf a8( g) f4 f | d4 c8( bf) c4 d | ef d8( ef) f4 f | 2.
    d8( ef) | f4 4 4 g | f f f d8( ef) | f4 f f g | f2.
    f4 | bf a8( g) f4 f | d4 c8( bf) c4 d | ef d8( ef) f4 f | 2.
  }
}
tenor = {
  \globalParts
  \relative a {
    f4 | bf a8( g) f4 bf | 4 4 a bf | 4 4 4 a | bf2.
    f4 | bf a8( g) f4 bf | 4 4 a bf | 4 4 c c | d2.
    bf4 | bf c bf bf | a f8( g) a4 bf | 4 c bf bf | a2.
    f4 | bf a8( g) f4 bf | 4 4 a bf | 4 4 c c | d2.
  }
}
bass = {
  \globalParts
  \relative d {
    f4 | bf a8( g) f4 d | g g f bf, | ef d ef f | bf,2.
    f'4 | bf a8( g) f4 d | g g f bf, | ef g f f | bf,2.
    bf'4 | bf a bf ef, | f f f bf | bf a bf ef, | f2.
    f4 | bf a8( g) f4 d | g g f bf, | ef g f f | bf,2.
  }
}
songChords = \chords {
  \globalChordSymbols
  s4 | bf2 2 g:m bf ef f bf bf
       bf2 2 g:m bf ef f bf bf
  bf bf f f bf bf f f
       bf2 2 g:m bf ef f bf bf
}

%% LYRICS
verseA = \lyricmode {
  \l I sing the might -- y pow'r of God,
  that made the moun -- tains rise,
  \l that spread the flow -- ing seas a -- broad
  and built the loft -- y skies.
  \l I sing the wis -- dom that or -- dained
  the sun to rule the day.
  \l The moon shines full at God's com -- mand
  and all the stars o -- bey.
}
verseB = \lyricmode {
  I sing the good -- ness of the Lord,
  that filled the earth with food.
  God formed the crea -- tures with a word,
  and then pro -- nounced them good.
  Lord, how thy won -- ders are dis -- played,
  wher -- e'er I turn my eye,
  if I sur -- vey the ground I tread,
  or gaze up -- on the sky!
}
verseC = \lyricmode {
  There's not a plant or flow'r be -- low,
  but makes thy glo -- ries known,
  and clouds a -- rise, and tem -- pests blow,
  by or -- der from thy throne.
  While all that bor -- rows life from thee
  is ev -- er in thy care,
  there's not a place where we can flee
  but God is pres -- ent there.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"