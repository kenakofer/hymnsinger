\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Joseph Bracket, 1848"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "SIMPLE GIFTS irregular"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 70
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "'Tis a gift to be simple"
poet = \smallText "Text: Joseph Bracket, 1848"
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english secular 4part"
dateAdded = "2021-01-10"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 c,8 c | f4 8 g a f a bf | c4 8 bf a4 g8 f | g4 g g f | \partial 2. g8 a g f c4 \bar " "} \break
  \relative g' { \partial 4 c,4 | f8 e f g a( f) a bf | c4 8( bf) a4 g8( f) | g4 8 8 a4 8 g | f4 8 8 f4 r } \break
  \relative g' { c2 a4. g8 | a bf a g f4. g8 | a4 8 bf c4 bf8 a | \partial 2. g4 g8 a g4 \bar " " } \break
  \relative g' {\partial 4 r8 c, | f2 a4. bf8 | c4 8 bf a4 g8 f | g4 g a4 8 g | \partial 2. f4 f f }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c8 8 | 4 d8 e f c f g | f4 8 8 f4 e8 d | c4 e e d4 | d8 d d d c4 }
  \relative e' { c | 8 c d e f4 8 g | a( g) f4 f4 f | f8( e) d d d4 e8 e | f4 d8 d c4 r }
  \relative e' { f2 f4. c8 | f8 f f e d4. e8 | f4 f8 g a4 f8 f | e4 8 f e4 |  }
  \relative e' { r8 c | c2 4. 8 | c8( d) e g f4 e8 f | f( e) d4 d e8 e | f4 d c | }
}
tenor = {
  \globalParts
  \relative a { c8 c | a4 8 c c a a g | a4 g8 g a4 bf8 bf | c4 c c8( bf) a4 | bf8 c bf g c( bf) |  }
  \relative a { a8( g) | f f a c c4 8 bf | a4 a4 a4 bf | g a8 g f4 a8 bf | bf8( a) g8 g a4 r | }
  \relative a { c2 4. 8 | a8 g a bf a4. bf8 | c4 8 bf a4 bf8 c | c4 8 8 4 |  }
  \relative a { r8 c | f,2 f8( g a) bf | c4 g8 g a4 bf8 a | g4 a8( g) f4 a8 bf | bf( a) g4 a4 | }
}
bass = {
  \globalParts
  \relative d { f8 f | f8( e) d c f f f c | f4 bf,8 8 c4 8 d | e4 c c c | g8 a bf b c4}
  \relative d { c4 | f8 f f c c4 c8 c | f4 e d c | bf d8 8 4 c8 c | bf4 8 8 f'4 r | }
  \relative d { f2 4. e8 | d8 d c c d4. c8 | f4 8 c f4 d8 d | c4 8 8 c4 | }
  \relative d { r8 c | bf8( c d e) f4. f8 | f4 c8 c d4 c8 8 | bf4 d4 4 c8 c | bf4 4 f4}
}

%% LYRICS
verseA = \lyricmode {
  'Tis a gift to be sim -- ple, 'tis a gift to be free,
  'tis a gift to come down where we ought to be.
  And when we find our -- selves in the place just right
  'twill be in the val -- ley of love and de -- light.

  When true sim -- pli -- ci -- ty is gained,
  to bow and to bend we will not be a -- shamed;
  to turn, turn, will be our de -- light,
  till by turn -- ing, turn -- ing we come round right.
}

chordSymbols = \chordmode {
  \globalChordSymbols
  f4 | f1 | f1 | c1 | g2:m7 c4
  s4 | f1 | f2 d2:m | g2:m7 d4:m c4 | bf2 f4
  s4 | f1 | d4:m c4 d4.:m c8 | f1 | c2.
  s4 | f1 | f4 c4 d2:m | g2:m7 d4:m c4 | bf2 f4 |
}

songChords =
<<
\new ChordNames { % Hidden chord line for vertical separation (must mostly line up with the visible chords to work)
  \set instrumentName = ""
  \override ChordNames.ChordName.color = #white
  \chordmode { a4 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 }
}
\new ChordNames {
  \once \override InstrumentName.extra-offset = #'(10 . 0.7)
  \override ChordNames.ChordName.font-shape = #'italic
  \override ChordNames.ChordName.font-size = #-1
  \set instrumentName = \markup { \italic "Capo 1:" }
  \transpose f e \chordSymbols
}
\new ChordNames {
  \set instrumentName = ""
  \chordSymbols
}
>>

% Set up music-aligned verses. Change to the correct number
\include "../../lib/1verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-1verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
