composer = \smallText "Music: Joachim Neander, 1680"
meter = \smallText "WUNDERBARER KÖNIG 66.86.66.86.666"
hymnKey = \key g \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../lib/global_parts.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { b4 b b b | a2 a | g4 g g g | fs2 2 | e4 e d g | a b a2 | g1 | } \break
  \relative g' { b4 b b b | a2 a | g4 g g g | fs2 2 | e4 e d g | a b a2 | g1 | } \break
  \relative g' { b4 b c2 | a4 a b2 | d4 d c b | a2 b | d4 d c b | a2 g | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 d d d | d2 d | b4 e e e | e2 ds2 | e4 c b e | fs g g( fs) | g1 | }
  \relative e' { d4 d d d | d2 d | b4 e e e | e2 ds2 | e4 c b e | fs g g( fs) | g1 | }
  \relative e' { d4 d e2 | d4 4 2 | g4 a g g | g( fs) g2 | d4 g e8( fs) g4 | g( fs) g2 | }
}
tenor = {
  \globalParts
  \relative a { g4 g g g | g2 fs | g4 b b b | b2 b | g4 g g b | d d d2 | b1 | }
  \relative a { g4 g g g | g2 fs | g4 b b b | b2 b | g4 g g b | d d d2 | b1 | }
  \relative a { g4 4 2 | fs4 fs g2 | b4 a e' d | d2 d | g,4 b c d | e( d) b2 | }
}
bass = {
  \globalParts
  \relative d { g,4 g b g | d'2 d | e4 e g e | b2 b | c4 e g e | d g d2 | g,1 }
  \relative d { g,4 g b g | d'2 d | e4 e g e | b2 b | c4 e g e | d g d2 | g,1 }
  \relative d { g4 g c,2 | d4 d g,2 | g'4 fs e8( fs) g4 | d2 g | b,4 g a b | c( d) g,2 | }
}
songChords = \chords {
  \set chordChanges = ##t
    g1 d e:m b:7 c2 g d1 g
    g1 d e:m b:7 c2 g d1 g
    g2 c d g g c4 g d2 g g a:m d g
}