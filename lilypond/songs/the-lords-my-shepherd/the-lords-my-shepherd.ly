\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Jessie S. Irvine, 1872"
arranger = \smallText "arr. David Grant, 1872"
meter = \smallText "CRIMOND CM"
hymnKey = \key f \major
hymnTime = \time 3/4
quarternoteTempo = 110
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "The Lord's my shepherd"
poet = \smallText "Text: The Psalms in Meeter, 1650"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english theist 4part"
dateAdded = "2021-03-19"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 c,4 | a'2 bf8.( g16) | c2 bf8( g) | f2 e4 | f2 \bar "" } \break
  \relative g' { a4 | a( g) g | b2 b4 | c2 \bar "" } \break
  \relative g' { a4 | a( bf) a | g2 a4 | bf( c) bf | a2 \bar "" } \break
  \relative g' { a4 | g( bf) d | f,2 e4 | \partial 2 f2 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c4 | f2 g8.( e16) | f2 d4 | c2 4 | 2 f4 | c2 4 | d( g) f | e2 }
  \relative e' { c4 | f( g) f | e2 f4 | g( e) g | f2 4 | d2 4 | c2 4 | c2 | }
}
tenor = {
  \globalParts
  \relative a { c,4 | c'2 bf4 | a2 bf4 | a2 g4 | a2 c4 | f,4( g) g | g2 4 | 2 }
  \relative a { f4 | c'2 4 | 2 4 | d( c) c | 2 4 | bf2 g4 | a2 g4 | a2 | }
}
bass = {
  \globalParts
  \relative d { c4 | f2 4 | 2 bf,4 | c2 4 | f2 4 | f( e) e | g2 g,4 | c2 }
  \relative d { f4 | f( e) f | c( bf') a | g( c,) d8( e) | f2 4 | bf,2 4 | c2 4 | f2 | }
}
songChords = \chords {
  \globalChordSymbols
  f4 | f f bf f f bf f/c f/c c f f f g:7 g:7 g:7 g:7 g:7 g:7 c c
  f4 | f f f c c c c:7 c:7 c:7 f f f g:m g:m g:m  f/c f/c c f f
}

%% LYRICS
verseA = \lyricmode {
  \l The Lord's my shep -- herd, I'll not want.
  \l He makes me down to lie
  \l in pas -- tures green; he lead -- eth me
  \l the qui -- et wa -- ters by.
}
verseB = \lyricmode {
  My soul he doth re -- store a -- gain,
  and me to walk doth make
  with -- in the paths of right -- eous -- ness,
  e'en for his own name's sake.
}
verseC = \lyricmode {
  Yea, though I walk in death's dark vale,
  yet will I fear none ill,
  for thou art with me and thy rod
  and staff me com -- fort still.
}
verseD = \lyricmode {
  My ta -- ble thou hast fur -- nish -- ed
  in pres -- ence of my foes.
  My head thou dost with oil a -- noint
  and my cup o -- ver -- flows.
}
verseE = \lyricmode {
  Good -- ness and mer -- cy all my life
  shall sure -- ly fol -- low me,
  and in God's house for -- ev -- er -- more
  my dwell -- ing place shall be.
}

\include "../../lib/5verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-5verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
