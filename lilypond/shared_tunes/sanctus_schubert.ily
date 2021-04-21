composer = \smallText "Music: Franz Schubert, 1826"
meter = \smallText "SANCTUS (Schubert) 65.65 D"
hymnKey = \key ef \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../lib/global_parts.ly"

%% NOTES
soprano = {
  \globalParts
  \relative f' { g2 4 | f2 g4 | af2. | g | f2 4 | 2 g4 | ef2.( | f2) r4 | } \break
  \relative f' { g2 4 | f2 g4 | af2. | g | f2 4 | 2 g4 | ef2.~ | 4 r r | } \break
  \relative f' { bf2 4 | 2 4 | c2. | af | 2 bf4 | g2 ef4 | f2.~ | 4 r r | } \break
  \relative f' { g2 4 | f2 ef4 | af2. | g | c2 f,4 | 2 g4 | ef2.~ | 4 r r | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { ef2 4 | d2 ef4 | 2. | 2. | 2 4 | d2 4 | bf2.( | d2) r4 | }
  \relative e' { ef2 4 | d2 ef4 | 2. | 2. | 2 4 | d2 4 | bf2.~ | 4 r r | }
  \relative e' { ef2 4 | f2 4 | e2. | f | 2 4 | ef2 4 | d2.~ | 4 r r | }
  \relative e' { df2 4 | 2 4 | c4( ef2) | ef2. | 2 4 | d2 4 | bf2.~ | 4 r r | }
}
tenor = {
  \globalParts
  \relative a { bf2 4 | 2 4 | c2. | bf | c2 4 | af2 bf4 | g2.( | bf2) r4 | }
  \relative a { bf2 4 | 2 df4 | c2. | bf | af2 4 | 2 bf4 | g2.~ | 4 r r | }
  \relative a { g2 4 | 2 4 | 2( c4) | 2. | bf2 4 | 2 4 | 2.~ | 4 r r | }
  \relative a { bf2 4 | af2 g4 | af4( c2) | bf2. | c2 4 | af2 bf4 | g2.~ | 4 r r | }
}
bass = {
  \globalParts
  \relative d { ef2 4 | bf2 ef4 | af,2. | ef' | af,2 4 | bf2 4 | ef2.( | bf2) r4 | }
  \relative d { ef2 4 | bf2 4 | af2. | ef' | bf2 4 | 2 4 | ef2.~ | 4 r r | }
  \relative d { ef2 4 | df2 4 | c2. | f | d2 4 | ef2 g,4 | bf2.~ | 4 r r | }
  \relative d { ef2 4 | 2 4 | af,2. | ef'2. | af,2 4 | bf2 4 | ef2.~ | 4 r r |}
}