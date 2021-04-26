composer = \smallText "Music: Southern Harmony, 1854, alt."
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "INVITATION NEW 87.87.87.87"
hymnKey = \key e \major
hymnTime = \time 2/2
quarternoteTempo = 150
\include "../lib/global-parts.ily"

%% NOTES
soprano = {
  \globalParts
  \transpose g e
  \relative g' {
    \partial 2
    g4 g | b2 4.( a8) | g4 4 a8( g4.) | e2 g4 g | b2 d | g,4 8( e) g2~ | 2 \bar "" \break
    g4 g | b2 4.( a8) | g4 4 a8( g4.) | e2 g4 g | b2 d | g,4 8( e) g2~ | 2 \bar "" \break
    d'4 e8( fs) | g2 8( d4.) | e4 d d2 | b2 d4 e8( fs) | g2 8( d4.) | b4 d e2~ | 2 \bar "" \break
    g4 8( e) | d2 b4.( a8) | g4 4 a8( g4.) | e2 g4 4 | b2 d | g,4 8( e) g2~ | \partial 2 2 \bar "|."
  }
}
alto = {
  \globalParts
  \transpose g e
  \relative e' {
    g4 4 | g2 g4.( fs8) | d4 4 b2 | b2 e4 d | g2 g4.( e8) | d4 4 2~ | 2
    g4 4 | g2 g4.( fs8) | d4 4 b2 | b2 e4 d | g2 g4.( e8) | d4 4 2~ | 2
    g4 8( a) | b2 g | g4 a b2 | g2 g4 8( a) | b2 g | g4 g g2~ | 2
    d4 4 | g2 g4.( fs8) | d4 4 b2 | b2 e4 d | g2 g4.( e8) | d4 4 2~ | 2
  }
}
tenor = {
  \globalParts
  \relative a {
  }
}
bass = {
  \globalParts
  \transpose g e
  \relative d {
    g4 4 | g2 g2 | b,4 d e2 | g g4 g4 | e2 d4.( b8) | d4 4 g2~ | 2
    g4 4 | g2 g2 | b,4 d e2 | g g4 g4 | e2 d4.( b8) | d4 4 g2~ | 2
    g4 d | g4( b) d2 | g,4 d4 2 | e g4 4 | g4( b) d2 | d4 b c2~ | 2
    b4 4 | g2 d2 | b4 d e2 | g g4 g4 | e2 d4.( b8) | d4 4 g2~ | 2
  }
}
songChords = \chords {
  \globalChordSymbols
  \transpose g e {
    g2 | g1 | g2 e2:m | e1:m | e2:m g2 | g1 | g2
    g2 | g1 | g2 e2:m | e1:m | e2:m g2 | g1 | g2
    g2 | g1 | c4 d g2 | e2:m g2 | g1 | g2 c2 | c2
    g2 | g1 | g2 e2:m | e1:m | e2:m g2 | g1 | g2
  }
}