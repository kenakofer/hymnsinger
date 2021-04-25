composer = \smallText "Music: Edward F. Rimbault, 1867"
meter = \smallText "RUTHERFORD 76.76.76.75"
hymnKey = \key f \major
hymnTime = \time 2/2
quarternoteTempo = 96
\include "../lib/global_parts.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 a4 | a a g4. 8 | f2 4 4 | bf4. 8 a4 bf | g2. \bar "" \break
    g4 | c4. 8 bf4 4 | a2 g4 4 | f4 4 e8( f) g( e) | f2. \bar "" \break
    f4 | 4. 8 4 g | a2 4 f | 4. 8 4 g | a2. \bar "" \break
    a8( bf) | c4 4 d4. c8 | 2 bf | a4 4 g4. f8 | \partial 2. f2. \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    f4 | 4 4 e4. 8 | d2 4 f | f4. 8 4 4 | e2.
    4 | f4. 8 e4 4 | f2 d4 4 | c4 4 4 4 | 2.
    4 | d4. 8 f4 e | f2 4 c | d4. 8 f4 4 | 2.
    8( e) | f4 4 4. 8 | 2 e | f4 4 e4. c8 | 2.
  }
}
tenor = {
  \globalParts
  \relative a {
    c4 | c c bf4. 8 | a2 4 4 | d4. 8 c4 d | c2.
    4 | 4. 8 4 4 | 2 bf4 4 | a4 4 g8( a) bf( g) | a2.
    4 | d4. 8 df4 4 | c2 4 a | d4. 8 df4 4 | c2.
    4 | c c bf4. c8 | c2 2 | 4 4 bf4. a8 | 2.
  }
}
bass = {
  \globalParts
  \relative d {
    f4 | f f c4. 8 | d2 4 4 | bf4. 8 f'4 bf, | c2.
    bf'4 | a4. 8 g4 4 | f2 bf,4 4 | c c c c |  f2.
    f4 | bf4. 8 4 4 | f2 4 4 | bf4. 8 4 4 | f2.
    8( g) | a4 4 bf4. a8 | a2 g | f4 4 c4. f8 | 2.
  }
}
songChords = \chords {
  \globalChordSymbols
  f4 | f2 c | d1:m bf2 f4 bf c2.
  c4:7 | f2 c:7/g | f2 g:m/bf | f c | f2.
  f4 | bf2 bf:m | f1 | bf2 bf:m | f2.
  f4 | f2 bf | f c:7/g | f2 c:7 | f2.
}