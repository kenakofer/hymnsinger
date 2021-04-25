composer = \smallText "Music: Henry J. Gauntlett, 1861"
meter = \smallText "STUTTGART 87.87"
hymnKey = \key g \major
hymnTime = \time 2/2
quarternoteTempo = 100
\include "../lib/global-parts.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { d4 d g g | a a b g | d' d e c | a d b2 | } \break
  \relative g' { b4 b a b | g a g fs | g e d g | g fs g2 } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 d b b | e d d d | g g g g | g fs g2 }
  \relative e' { g4 g fs fs | b, e d d | d c b d | d d d2 }
}
tenor = {
  \globalParts
  \relative a { b4 a g g | g fs g b | g b c e | d d d2 }
  \relative a { e'4 b c b | b a a a | g g d' b | a8( b) c4 b2 | }
}
bass = {
  \globalParts
  \relative d { g4 fs e d | c d g g | b, g c a | d d g2 | }
  \relative d { e4 e e ds | e cs d c | b c g b8( c) | d4 d g,2 | }
}
songChords = \chords {
  \globalChordSymbols
  g2 e:m d g g c d g
  e:m b e:m d g g d:7 g
}
