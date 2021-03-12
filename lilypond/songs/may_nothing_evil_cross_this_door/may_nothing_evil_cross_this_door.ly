\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Robert N. Quaile, b. 1867"
meter = \smallText "OLDBRIDGE 88.84"
hymnKey = \key f \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "May nothing evil cross this door"
poet = \smallText "Text: Louis Untermeyer, 1923"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "secular 4part acapella 4verse musicbyother textbyother"
dateAdded = "2021-01-31"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \stemUp
  \relative g' { a4 a a | a2 f4 | g2 a4 | f2. | } \break
  \relative g' { c4 c c | bf2 g4 | a2 f4 | \partial 2 g2 \bar "" } \break
  \relative g' { \partial 4 g4 | e4( f) g | a2 4 | a2 f4 | \partial 2 d2 \bar "" } \break
  \relative g' { \partial 4 c,4 | f2. | g2. | f2. | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f f | f2 c4 | e2 4 | d2. |}
  \relative e' { f4 f f | g2 e4 | f2 c4 | c2 | }
  \relative e' { c4 | c2 4 | 2 4 | c2 a4 | bf2 a4 | d2. | e2. | c2. |}
}
tenor = {
  \globalParts
  \stemDown
  \relative a { c4 c c | c2 a4 | c2 4 | a2. | }
  \relative a { c4 c c | d2 c4 | c2 f,4 | e2 | }
  \relative a { e4 | g4( f) e | f2 4 | e2 f4 | f2 4 | a2. | c2. | a2.}
}
bass = {
  \globalParts
  \relative d { f4 f f | f2 4 | c2 a4 | d2. | }
  \relative d { a'4 4 4 | g2 c,4 | f2 a,4 | c2 | }
  \relative d { c4 | bf( a) g | f2 4 | a2 d4 | bf2 f'4 | d2. | c2. | f,2. | }
}

%% LYRICS
verseA = \lyricmode {
  May noth -- ing e -- vil cross this door,
  and may ill for -- tune nev -- er pry
  a -- bout these win -- dows; may the roar
  and rain go by.
}
verseB = \lyricmode {
  By faith made strong, the raft -- ers will
  with -- stand the bat -- tering of the storm.
  This hearth, though all the world grow chill,
  will keep you warm.
}
verseC = \lyricmode {
  Peace shall walk soft -- ly through these rooms,
  touch -- ing our lips with ho -- ly wine,
  till ev -- 'ry cas -- ual cor -- ner blooms
  in -- to a shrine.
}
verseD = \lyricmode {
  With laugh -- ter drown the rau -- cous shout,
  and, though these shel -- tering walls are thin,
  may they be strong to keep hate out
  and hold love in.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
