composer = \smallText "Music: Rowland H. Prichard ca. 1830"
arranger = \smallText "arr. Ralph Vaughn Williams, 1906"
meter = \smallText "HYFRYDOL 87.87 D"
hymnKey = \key f \major
hymnTime = \time 3/4
\include "../lib/global_parts.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { f2 g4 | f4.( g8) a4 | bf2 a4 | g( f) g | c2 bf4 | a2 a4 | g( f) g | f2. | } \break
  \relative g' { f2 g4 | f4.( g8) a4 | bf2 a4 | g( f) g | c2 bf4 | a2 a4 | g( f) g | f2. | } \break
  \relative g' { c2 c4 | c( bf) a | bf2 bf4 | bf( a) g | a2 a4 | a( bf) c | c( bf) a | g2. |} \break
  \relative g' { c4( a) c | bf( g) bf | a( f) a | g8( a bf a) g4 | c2 c4 | d( c) bf | a2 g4 | f2. |}\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c2 e4 | f2 4 | d( g) f | e( d) e | f( c) d8( e) | f4( e) d | d2 e4 | f2. | }
  \relative e' { c2 e4 | f2 4 | d( g) f | e( d) e | f( c) d8( e) | f4( e) d | d2 e4 | f2. | }
  \relative e' { e2 e4 | f2 4 | f( e) d | e2 e4 | f2 f4 | f( g) a | a( bf) f | f2 e4 | }
  \relative e' { f2  e4 | g2 g4 | f( c) c | c2 c4 | c( f) e | d( f) f | f2 e4 | f2. |}
}
tenor = {
  \globalParts
  \relative a { a2 g4 | a4.( bf8) c4 | g( c) c | c( a) c | c( a) bf | c2 a4 | bf( a) c | a2. |}
  \relative a { a2 g4 | a4.( bf8) c4 | g( c) c | c( a) c | c( a) bf | c2 a4 | bf( a) c | a2. |}
  \relative a { a2 a4 | f( g) a | g2 g4 | g2 bf4 | a( c) c | d2 c4 | d2 c4 | g2. |}
  \relative a { a4( c) c | d2 c4 | c( a) f | e8( f g f) e4 | f( a) c | bf( c) d | c2 bf4 | a2. |}
}
bass = {
  \globalParts
  \relative d { f2 c4 | f2 4 | f( e) f | c( d) c | a( a') g | f2 4 | d2 c4 | f2. }
  \relative d { f4( a,) c | f2 4 | f( e) f | c( d) c | a( a') g | f2 a,4 | bf( d) c | f2. }
  \relative d { a'2 4 | d,2 4 | g2 4 | c,4( d) e | f2 e4 | d( bf) f | g2 bf4 | c2. | }
  \relative d { a'4( f) a | g4.( f8) e4 | f2 a,4 | c2 8 bf | a2 4 | bf( a) bf | c2 4 | f2. |}
}
songChords = \chords {
  \globalChordSymbols
    f2. f g:m7 c f f g2:m c4 f2.
    f2. f g:m7 c f f g2:m c4 f2.
    a:m d:m g:m c2 c4:7 f2. f g:m c2:sus c4
    f2. c:7 f c a:m bf f2 c4 f2.
}