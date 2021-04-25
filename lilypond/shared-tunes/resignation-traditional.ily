composer = \smallText "Music: North American Traditional"
meter = \smallText "RESIGNATION CMD"
hymnKey = \key c \major
hymnTime = \time 3/4
\include "../lib/global-parts.ily"

%% NOTES
soprano = {
  \globalParts
  \relative f' { \partial 4 c8 e | g2 e8 d | e2 g4 | c2 a8 g | e2 c8 e | g2 c,4 | e2 d4 | c2.~ | c2 \bar "" } \break
  \relative f' { c8 e | g2 e8 d | e2 g4 | c2 a8 g | e2 c8 e | g2 c,4 | e2 d4 | c2.~ | c2 \bar "" } \break
  \relative f' { g4 | c2 e8 c | a2 c4 | d2 c8 a | g2 e8 g | a2 g8 a | c2 d4 | c2.~ | c2 \bar "" } \break
  \relative f' { c8 e | g2 e8 d | e2 g4 | c2 a8 g | e2 c8 e | g2 c,4 | e2 d4 | c2.~ | \partial 2 c2 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c4 | b2 4 | b4( c) d | e2 f8 e | c2 4 | b2 c4 | c2 g4 | g2.~ | g2 }
  \relative e' { c4 | b2 4 | b4( c) d | e2 f8 e | c2 4 | b2 c4 | c2 b4 | c2.~ | c2 }
  \relative e' { e4 | e2 g4 | f2 a8 g | f2 g8 f | d2 e4 | e2 g8 f | g2 f4 | e2.~ | e2 }
  \relative e' { c4 | d2 b4 | c2 d4 | c2 4 | b2 c4 | d2 c4 | c2 b4 | g2.~ | g2 }
}
tenor = {
  \globalParts
  \relative a { e4 | d2 g4 | 2 4 | 2 f8 g | a2 4 | g2 e4 | 2 g4 | e2.~ | 2 }
  \relative a { e4 | d2 g4 | 2 4 | 2 f8 g | a2 4 | g2 e4 | g2 g4 | e2.~ | 2 }
  \relative a { c4 | 2 b8 c | c2 a4 | a2 g8 c | b2 c4 | 2 b8 d | c2 a4 | g2.~ | 2 }
  \relative a { e4 | d2 g4 | 2 4 | e2 4 | g2 e4 | d2 e4 | g2 g4 | e2.~ | 2 }
}
bass = {
  \globalParts
  \relative d { c4 | g2 g'4 | e2 b4 | c2 d8 e | a2 4 | e2 c4 | a2 b4 | c2.~ | 2 }
  \relative d { c4 | g2 g'4 | e2 b4 | c2 d8 e | a2 a,4 | b2 c4 | g2 4 | c2.~ | 2 }
  \relative d { c'4 | a2 g8 e | f2 8 e | d2 e8 f | g2 c4 | a2 e8 d | e2 f4 | c2.~ | 2 }
  \relative d { c4 | b2 g4 | c2 b4 | a2 c4 | e2 a,4 | b2 c4 | g2 4 | c2.~ | 2 }
}