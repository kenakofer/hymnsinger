composer = \smallText "Music: Conrad Kocher, 1838"
meter = \smallText "DIX 77.77.77"
hymnKey = \key a \major
hymnTime = \time 2/2
\include "../lib/global_parts.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { a4 gs8( a) b4 a | d d cs2 | fs,4 gs a fs | e e e2 | } \break
  \relative g' { a4 gs8( a) b4 a | d d cs2 | fs,4 gs a fs | e e e2 | } \break
  \relative g' { cs4 b a cs | e4. d8 cs2 | fs,4 gs a d | cs b a2 |} \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { e4 e e e | d e e2 | fs4 e e d cs b cs2 | }
  \relative e' { e4 e e e | d e e2 | fs4 e e d cs b cs2 | }
  \relative e' { e4 e e e | e e e2 | d4 e e d | e4. d8 cs2 | }
}
tenor = {
  \globalParts
  \relative a { cs4 d8( cs) b4 cs | a b a2 | a4 b a a | a gs a2 | }
  \relative a { cs4 d8( cs) b4 cs | a b a2 | a4 b a a | a gs a2 | }
  \relative a { a4 e'8( d) cs4 a | b gs a2 | a4 b a a | a gs a2 | }
}
bass = {
  \globalParts
  \relative d { a'4 b8( a) gs4 a | fs gs a2 | d,4 d cs d | e e a,2 | }
  \relative d { a'4 b8( a) gs4 a | fs gs a2 | d,4 d cs d | e e a,2 | }
  \relative d { a'4 gs a a | gs e a2 | d,4 d cs fs | e e a,2 | }
}
songChords = \chords {
  \globalChordSymbols
    a4 a a a | d e a a | d d d d | a e a a |
    a4 a a a | d e a a | d d d d | a e a a |
    a4 e a a | e e a a | d d a d | a e a a |
}