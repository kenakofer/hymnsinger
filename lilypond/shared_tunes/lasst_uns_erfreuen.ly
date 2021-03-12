composer = \twoLineSmallTextRight "Music: Geistliche Kirchengesang, 1623" "Harmonized Ralph Vaughan Williams, 1906"
meter = \smallText "LASST UNS ERFREUEN LM"
hymnKey = \key d \major
hymnTime = \time 3/2
quarternoteTempo = 130
\include "../lib/global_parts.ly"

%% NOTES
soprano = {
  \globalParts
  \relative f' { \partial 2 d2 | d4 e fs d fs g | a1 d,2 | d4 e fs d fs g | \partial 1 a1 \bar "" } \break
  \relative f' { \partial 2 d'4 cs | b2 a d4 cs | \partial 1 b2 a2\fermata \bar ""} \break
  \relative f' { \partial 2 d'2 | d4 a a g fs g | a1 d2 | d4 a a g fs g | \partial 1 a1 \bar "" } \break
  \relative f' { \partial 2 g4( fs) | e2 d g4( fs) | e2 d d'4 cs | b2 a d4 cs | b2 a g4 fs | e1. | \partial 1 d1 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { a,2 | d4 d d d d d | d2( cs) d | a4 cs d d d d | d2( cs) | }
  \relative e' { a4 a | a( g) fs2 d4 e | fs( e) cs2 | }
  \relative e' { a4( g) | fs fs fs e d d | d2( cs) d4( e) | d4 g fs d d d | d( cs fs e) | }
  \relative e' { d2 | d4( cs) d2 d | d4( cs) b2 fs'4 e |  fs4( e) cs2 fs4 fs | fs( e) e( b) b d | d2( cs1) | a1 | }
}
tenor = {
  \globalParts
  \relative a { fs2 | fs4 g a fs b b | a1 a4( b) | a g a a b b | a1 | }
  \relative a { d4 d | d2 d fs,4 a | a( gs) a2 | }
  \relative a { d2 | d4 d d a a g | e2( a) a | a4 a a d cs b | a1 | }
  \relative a { b2 | b4( a) a2 b4( a) | b( g) fs2 4 a | a( gs) a2 4 4 | fs( g) e( fs) g a | b2( a g) | fs1 | }
}
bass = {
  \globalParts
  \relative d { d2 | d4 d d d8( cs) b4 e | a,2( a'4 g) fs( g) | fs e d cs b e | a,2( a'4 g) | }
  \relative d { fs4 fs | g2 d b4 cs | d( e) a,2_\fermata | }
  \relative d { fs4( e) | d cs b cs d b | a2( a'4 g) fs( g) | fs e d b' a g | fs( e d cs) }
  \relative d { b4( a) | g2 fs e4( fs) | g( a) b2 b4 cs | d( e) a,2 b4 cs | d( e) cs( ds) e fs | g2( a a,) | <d d,>1 | }
}
songChords = \chords {
  \set chordChanges = ##t
  d2 d d b:m a:sus a d d d b:m a:sus a
  d2 g d d e a
  d d d d a:sus a d d2. g d2 d
  g2 a d e:m a b:m b:m e a b:m e:m a e:m a:sus a:7 d
}