composer = \smallText "Music: Pierre de Corbeil, harmonized Richard Redhead, 1853"
meter = \smallText "ORIENTIS PARTIBUS 87.87"
hymnKey = \key f \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../lib/global_parts.ly"

%% NOTES
soprano = {
  \globalParts
  \transpose ef f {
    \relative g' { ef2 f4 | g2 ef4 | f2 d4 | ef2. | } \break
    \relative g' { bf2 4 | c2 g8( af) | bf2 4 | g2. } \break
    \relative g' { g2 f4 | af2 g4 | f4( ef) f | g2. | } \break
    \relative g' { bf2 af4 | g2 ef4 | f2 d4 | ef2. | }\break
    \bar "|."
  }
}
alto = {
  \globalParts
  \transpose ef f {
    \relative e' { bf2 4 | bf2 4 | c2 bf4 | bf2. | }
    \relative e' { ef2 4 | ef2 4 | ef2 d4 | ef2. | }
    \relative e' { bf2 4 | ef2 4 | c2 4 | d2. | }
    \relative e' { ef2 4 | d2 c4 | c2 bf4 | bf2. | }
  }
}
tenor = {
  \globalParts
  \transpose ef f {
    \relative a { g2 af4 | bf2 4 | af2 f4 | g2. | }
    \relative a { g2 4 | af2 ef4 | f2 4 | g2. | }
    \relative a { bf2 4 | af2 bf4 | c2 4 | b2. | }
    \relative a { bf2 c4 | bf2 g4 | af2 f4 | g2. | }
  }
}
bass = {
  \globalParts
  \transpose ef f {
    \relative d { ef2 4 | 2 g,4 | af2 bf4 | ef2. | }
    \relative d { ef2 4 | af,2 c4 | bf2 4 | ef2. | }
    \relative d { ef2 d4 | c2 bf4 | af2 4 | g2. | }
    \relative d { g,2 af4 | bf2 c4 | af2 bf4 | ef2. | }
  }
}
songChords = \chords {
  \globalChordSymbols
  \transpose ef f {
    ef2. ef f2:m bf4 ef2.
    ef2. af bf2:sus bf4 ef2.
    ef2. af f:m g
    ef/g g:m f2:m bf4 ef2.
  }
}
