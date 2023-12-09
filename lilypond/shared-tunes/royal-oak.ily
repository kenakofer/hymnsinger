
%% TUNE INFO
composer = \smallText "Music: 17th cent. English Traditional; adapt. Martin Shaw, 1915"
meter = \smallText "ROYAL OAK 76.76 with refrain"
hymnKey = \key g \major
hymnTime = \time 4/4
quarternoteTempo = 110
\include "../lib/global-parts.ily"

%% NOTES
soprano = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative g' {
    d'4 b c b | a8( g) fs( e) d4 b' | c e, fs e8( fs) | g1 \break
    d'4 b c b | a8( g) fs( e) d4 b' | c e, fs e8( fs) | g2. \bar "|." \break
    \partial 4 d4 | b d d c8( b) | c4 e2 4 |  fs8( g) a4 fs8( g) a4 | d,2. \bar "" \break
    \partial 4 g8( a) | b4 a g a8( b) | c4.( b8) a4 b8( c) | d4 e, fs e8( fs) | g1 \bar "||"
  }
}
alto = {
  \globalParts
  \relative e' {
    d4 d c fs | e c d d | c c c c | b( c d2)
    d4 d c fs | e c d d | c c c c | b2.
    b4 | g b b c8( b) | c4 2 4 | c c d d | d( c b) b8( d) |
    d4 ds e e | e2 fs8( e) d4 | d c a c | b1
  }
}
tenor = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative a {
    b4 g g fs | g a g g | e a a a | g( a b2) |
    b4 g g fs | g a g g | e a a a | g2.
    g4 | d g g g | 4 2 a4 | a fs a8( g) fs4 | g4( fs g)
    g8( fs) | g4 fs e a8( gs) | a4( g) fs fs | g g fs a | g1
  }
}
bass = {
  \globalParts
  \relative d {
    g4 fs e d | c a b g | a a d d | g,1 |
    g'4 fs e d | c a b g | a a d d | g,2.
    g4 | g g fs' e8( d) | e4 c( b) a | d d c c | b( a g) e'8( d) |
    g,4 b e c8( b) | a2 d4 c | b c d d | g,1
  }
}
songChords = \chords {
  \globalChordSymbols
  g2 c2 d2. g4 a2:m d:7 g1 |
  g2 c2 d2. g4 a2:m d:7 g1 |
  g1 c d g |
  g2 e:m a:m d g4 c d2 | g1
}