composer = \smallText "Music: Louis Bourgeois, 1551"
arranger = \smallText "arr. Claude Goudimel, 1565"
meter = \smallText "GENEVA 42 (FREU DICH SEHR) 87.87.77.88"
hymnKey = \key f \major
hymnTime = \time 12/4
quarternoteTempo = 170
\include "../lib/global_parts.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { f2 g4 a2 g4 f e d2 c | f2 g4 a2 bf4 a2 g \partial 1 f1 | } \break
  \relative g' { f2 g4 a2 g4 f e d2 c | f2 g4 a2 bf4 a2 g \partial 1 f1 | } \break
  \relative g' { a2 4 c2 bf4 a g a1 | c2 4 d2 c4 bf a g1 | } \break
  \relative g' { a2 c4 bf2 a4 f g a2 f | a2 4 bf2 a4 g f f( e) \partial 1 f1 | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f2 e4 f2 e4 d c bf2 a | c2 e4 f2 4 2 e2 f1 | }
  \relative e' { f2 e4 f2 e4 d c bf2 a | c2 e4 f2 4 2 e2 f1 | }
  \relative e' { f2 4 2 4 4 e4 f1 | f2 4 2 4 4 4 e1 | }
  \relative e' { f2 g4 2 f4 d e f2 d | c2 4 d2 c4 c a c2 1 | }
}
tenor = {
  \globalParts
  \relative a { c2 4 2 4 a4 a f2 2 | a2 c4 2 d4 c2 c c1 | }
  \relative a { c2 4 2 4 a4 a f2 2 | a2 c4 2 d4 c2 c c1 | }
  \relative a { c2 4 a2 d4 c c c1 | a2 4 bf2 a4 d c c1 | }
  \relative a { c2 ef4 d2 d4 a4 c c2 bf2 | c2 f,4 2 4 e4 f g2 a1 | }
}
bass = {
  \globalParts
  \stemDown
  \relative d { f2 c4 f2 c4 d a bf2 f | f'2 c4 f2 bf,4 f'2 c2 f1 | }
  \relative d { f2 c4 f2 c4 d a bf2 f | f'2 c4 f2 bf,4 f'2 c2 f1 | }
  \relative d { f2 4 2 bf,4 f'4 c f1 | f2 4 bf,2 f'4 bf, f' c1 | }
  \relative d { f2 c4 g'2 d4 d c f2 bf, | f'2 4 bf,2 f4 c' d c2 f,1 | }
}