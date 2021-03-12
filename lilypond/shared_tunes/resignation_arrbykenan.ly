composer = \smallText "Music: North American Traditional"
arranger = \smallText "Arranged by Kenan Schaefkofer, 2021"
meter = \smallText "RESIGNATION CMD"
hymnKey = \key c \major
hymnTime = \time 3/4
quarternoteTempo = 100
\include "../lib/global_parts.ly"

%% NOTES
soprano = {
  \globalParts
  \relative f' { \partial 4 c8( e) | g2 e8( d) | e2 g4 | c2 a8( g) | e2 c8( e) | g2 c,4 | e2 d4 | c2.~ | c2 \bar "" } \break
  \relative f' { c8( e) | g2 e8( d) | e2 g4 | c2 a8( g) | e2 c8( e) | g2 c,4 | e2 d4 | c2.~ | c2 \bar "" } \break
  \relative f' { g4 | c2 e8( c) | a2 c4 | d2 c8( a) | g2 e8( g) | a2 g8( a) | c2 d4 | c2.~ | c2 \bar "" } \break
  \relative f' { c8( e) | g2 e8( d) | e2 g4 | c2 a8( g) | e2 c8( e) | g2 c,4 | e2 d4 | c2.~ | \partial 2 c2 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c4 | e2 c8( b) | c2 d4 | e2 f8( e) | c2 4 | c2 c4 | c2 g4 | g2.~ | g2 }
  \relative e' { c4 | e2 c8( b) | c2 d4 | e2 f8( e) | c2 4 | c2 c4 | c2 g4 | g2.~ | g2 }
  \relative e' { e4 | e2 g4 | f2 a8 g | f2 g4 | d2 e4 | e2 g8 f | g2 f4 | e2.~ | e2 }
  \relative e' { c4 | e2 c8( b) | c2 d4 | e2 f8( e) | c2 4 | c2 c4 | c2 g4 | g2.~ | g2 }
}
tenor = {
  \globalParts
  \relative a { g4 | c2 g4 | g2 g4 | g2 f8( g) | g2 4 | e2 f4 | g2 g4 | e2.~ | 2 }
  \relative a { g4 | c2 g4 | g2 g4 | g2 f8( g) | g2 4 | e2 f4 | g2 g4 | e2.~ | 2 }
  \relative a { c4 | 2 b8( c) | c2 a4 | a2 g8( c) | b2 c4 | 2 b8( d) | c2 a4 | a2.~ | 2 }
  \relative a { g4 | c2 g4 | g2 g4 | g2 f8( g) | g2 4 | e2 f4 | g2 g4 | e2.~ | 2 }
}
bass = {
  \globalParts
  \relative d { c4 | c2 c8( g) | c2 b4 | c2 c4 | c2 8( b) | a2 a4 | c2 b4 | c2.~ | 2 }
  \relative d { c4 | g2 c8( g) | c2 b4 | c2 c4 | c2 8( b) | a2 a4 | c2 b4 | c2.~ | 2 }
  \relative d { c'4 | a2 g8( e) | f2 8 e | d2 e4 | g2 c4 | a2 e8( d) | e2 f4 | a2.~ | 2 }
  \relative d { g4 | c,2 c8( g) | c2 b4 | c2 c4 | c2 8( b) | a2 a4 | c2 b4 | c2.~ | 2 }
}
songChords = \chords {
  \set chordChanges = ##t
}