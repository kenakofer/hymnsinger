composer = \smallText "Music: Thomas Tallis, 1567"
meter = \smallText "TALLIS' CANON LM"
hymnKey = \key g \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../lib/global-parts.ily"

%% NOTES
soprano = {
  \globalParts
  \relative f' { \partial 4 g4^\markup { \smaller \circle 1 } | g fs g g^\markup { \smaller \circle 2 } | a a b g^\markup { \smaller \circle 3 } | c c b b^\markup { \smaller \circle 4 } | \partial 2. a a g \bar "" } \break
  \relative f' { \partial 4 d'4 | c a b b | a a g d | e fs g b | \partial 2. a a g | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 | d d b d | e d d g | e fs g d | e d d | }
  \relative e' { g | e d d d | e fs g g, | e' d b d | c a b | }
}
tenor = {
  \globalParts
  \relative a { b4 | a a g g | g fs g g | a a b g | c c b | }
  \relative a { b | a a g d' | c a b b | a a g d | e fs g | }
}
bass = {
  \globalParts
  \relative d { g4 | d d e b | c d g, b | a a g g' | g fs g | }
  \relative d { g | a fs g g, | c d e b | c d e b | c d g, | }
}