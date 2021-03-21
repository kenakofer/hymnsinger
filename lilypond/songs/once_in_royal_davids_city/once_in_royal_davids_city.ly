\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Henry John Gauntlett, 1849"
arranger = \smallText "arr. Arthur Henry Mann, 1919"
meter = \smallText "IRBY 87.87.77"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 90
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Once in royal David's city"
poet = \smallText "Text: Cecil Frances Alexander, 1848, alt."
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 4
tags = "english christian winter 4part"
dateAdded = "2021-03-21"
\include "../../lib/header.ly"

m = \melisma
me = \melismaEnd

%% NOTES
soprano = {
  \globalParts
  \phrasingSlurSolid
  \relative g' { \partial 2 c,4 e | f4. 8 8\m e\me f\m g\me | g4 f f a | c4. a8 a\m g\me f\m e\me | f2 \bar "" } \break
  \relative g' { \partial 2 c,4 e | f4. 8 8\m e\me f\m g\me | g4 f f a | c4. a8 a\m g\me f\m e\me | f2 \bar "" } \break
  \relative g' { \partial 2 d'4 d | c4. f,8 bf4 4 | a\( a\) d d | c4. a8 a\m g\me f\m e\me | \partial 2 f4\( f\) | } \break
  \bar "|."
}
alto = {
  \globalParts
  \phrasingSlurSolid
  \relative e' { c4 e | c c b b | c8 bf a4 c f | c c d c | c2 }
  \relative e' { c4 e | c c b b | c8 bf a4 c f | c c d c | c2 }
  \relative e' { d8 e f g | c,4 c d e | f\( e\) d8 e f g | c,( e f) f d4 c | c\( c\) | }
}
tenor = {
  \globalParts
  \phrasingSlurSolid
  \relative a { a4 bf | c a g f | e f a c | g a8 c c bf a g | a2 }
  \relative a { a4 bf | c a g f | e f a c | g a8 c c bf a g | a2 }
  \relative a { f4 bf | a a bf c | c\( c\) bf bf | a8( bf c) c c bf a g | a4\( a\) | }
}
bass = {
  \globalParts
  \phrasingSlurSolid
  \relative d { a'4 g | a f d g, | c f, a' f | e f bf, c | f2 }
  \relative d { a'4 g | a f d g, | c f, a' f | e f bf, c | f2 }
  \relative d { bf8 c d e | f4 a g c, | f\( f\) bf,8 c d e | f( g a) f bf,4 c | <f f,>4\( 4\) }
}

%% LYRICS
verseA = \lyricmode {
  \l Once in roy -- al Da -- vid's cit -- y
  stood a low -- ly cat -- tle shed,
  \l where a moth -- er laid her ba -- by
  in a man -- ger for his bed:
  \l Ma -- ry was that moth -- er mild; _
  Je -- sus Christ, her lit -- tle child.
}
verseB = \lyricmode {
  He came down to earth from heav -- en
  who is God and Lord of all,
  and his shel -- ter was a sta -- ble,
  and his cra -- dle was a stall;
  with the poor and meek and low -- ly,
  lived on earth our Sa -- vior ho -- ly.
}
verseC = \lyricmode {
  And our eyes at last shall see him,
  through his own re -- deem -- ing love;
  for that child so dear and gen -- tle
  is our Lord in heav'n a -- bove;
  and he leads his chil -- dren on _
  to the place where he is gone.
}
verseD = \lyricmode {
  Not in that poor low -- ly sta -- ble
  with the ox -- en stand -- ing by,
  we shall see him, but in heav -- en
  set at God's right hand on high;
  when like stars, his chil -- dren crowned _
  all in white, shall wait a -- round.
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
shapeStaffZoom = #1.15
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
