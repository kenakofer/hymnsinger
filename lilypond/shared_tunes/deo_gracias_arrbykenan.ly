composer = \smallText "Music: English Traditional, 15th c."
arranger = \smallText "Arranged by Kenan Schaefkofer, 2017"
meter = \smallText "DEO GRACIAS LM"
hymnKey = \key d \minor
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../lib/global_parts.ly"

%% NOTES
soprano = {
  \globalParts
  \relative f' { \partial 4 d'4 | d2 c4 | d2 c4 | c b2 | a d4 | d( c) a | g( a) g8( d) | f4 e2 | \partial 2 d2 \bar " " | } \break
  \relative f' { \partial 4 a4 | c2 4 | d( c) bf | a g2 | f2 4 | a2 4 g2 f4 | f e2 | d2.~ | \partial 2 d2 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 | f4 g2 | a4 g2 | f4 g2 | a f4 | f2 e4 | d( e) d | d cs2 | d }
  \relative e' { f4 | a2 4 | g2 e4 | f d2 | d c4 | d2 f4 | d2 4 | c cs2 | d2.~ | 2 | }
}
tenor = {
  \globalParts
  \relative a { a4 | a2 4 | bf2 4 | a g( f) | e2 bf'4 | bf2 c4 | bf( a) bf | bf2 a4 | a2 | }
  \relative a { a4 | f( g) a | bf( a) g | f g( bf) | a2 c4 | a2 a4 | d( c) bf | c a2 | a2.~ | 2 |}
}
bass = {
  \globalParts
  \relative d { d4 | d2 4 | d2 4 | a g2 | a bf4 | bf a2 | bf4 a2 | bf4 a2 | d2 | }
  \relative d { d4 | c2 4 | bf2 4 | a4 g2 | d'2 a4 | d2 d4 | g,2 bf4 | a4 2 | d2.~ | 2 }
}