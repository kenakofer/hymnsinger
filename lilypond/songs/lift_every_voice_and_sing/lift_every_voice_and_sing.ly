\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: J. Rosamond Johnson, 1899"
meter = \smallText "ANTHEM 66 10.66 10.14 14 66 10"
hymnKey = \key g \major
hymnTime = \time 6/8
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/8)
hymnBeatStructure = \set Timing.beatStructure = 3,3
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Lift every voice and sing"
poet = \smallText "Text: J. Rosamond Johnson, 1899"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english theist 4part"
dateAdded = "2021-01-16"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4. fs8 g a | b4. b | b b8 c d | b4. a | g \bar "" } \break
  \relative g' { g8 a b | c4. b | g a | g4.~ 4 8 | fs4. \bar "" } \break
  \relative g' { fs8 g a | b4. b | e4. 8 d b | c4. b4( a8) | g4. \bar "" } \break
  \relative g' { g8 a as | b4. 8 a g | a4.~ 4 g8 | g4.~ g } \pageBreak

  \relative g' { g4. d | e e8 d b | e d b e d b | d4. d } \break
  \relative g' { g4. d | ef ef8 d c | ef d c ef d c | b'4.~ b | c4.~ c~ | c4. \bar "" } \break

  \relative g' { fs8 g a | b4. b | e4. 8 d b | c4. b4( a8) | g4. \bar "" } \break
  \relative g' { g8 a as | b4. 8 a g | a4.~ 4 g8 | g4.~ g }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d8 e fs | g4. ds | e e8 e e | g4. fs | e }
  \relative e' { e8 ds e | e4. ds | e e | d4.~ 4 e8 | fs4. }
  \relative e' { d8 e fs | g4. ds | e e8 f f | e4. ds | e }
  \relative e' { e8 e e | d4. g8 fs g | fs4.~ 4 g8 | g4.~ g }

  \relative e' { g4. d | e e8 d b | e d b e d b | d4. d }
  \relative e' { g4. d | ef ef8 d c | ef d c ef d c | d4.~ d | d4.~ d~ | d4. }

  \relative e' { d8 e fs | g4. ds | e e8 f f | e4. ds | e }
  \relative e' { e8 e e | d4. g8 fs g | fs4.~ 4 g8 | g4.~ g }
}
tenor = {
  \globalParts
  \relative a { fs8 g a | b4. a | g g8 g g | g4. c | b }
  \relative a { b8 c b | a4. b4( a8) |  g4. c | b4.~ 4 as8 | c4. }
  \relative a { fs8 g a | b4. a | gs gs8 b d | c4. b | c }
  \relative a { bf8 a g | g4. d'8 c b | c4.~ 4 b8 | b4.~ b }

  \relative a { g4. d | e e8 d b | e d b e d b | d4. d }
  \relative a { g4. d | ef ef8 d c | ef d c ef d c | b'4.( es) | fs4.~ fs~ | fs4. }

  \relative a { fs8 g a | b4. a | gs gs8 b d | c4. b | c }
  \relative a { bf8 a g | g4. d'8 c b | c4.~ 4 b8 | b4.~ b }
}
bass = {
  \globalParts
  \relative d { d8 e fs | g4. fs | e e8 8 8 | d4. ds | e }
  \relative d { e8 fs g | a4. b, | c4. c | d4.~ 4 cs8 | d4. }
  \relative d { d8 e fs | g4. fs | e e8 gs8 gs | a4. b4( b,8) | c4.}
  \relative d { cs8 8 8 | d4. d8 ds e16 ds | d4.~ 4 g,8 | g4.~ g }

  \relative d { g4. d | e e8 d b | e d b e d b | d4. d }
  \relative d { g4. d | ef ef8 d c | ef d c ef d c | g'4.( gs) | a8( d,4)~ d4.~ | d4. }

  \relative d { d8 e fs | g4. fs | e e8 gs8 gs | a4. b4( b,8) | c4.}
  \relative d { cs8 8 8 | d4. d8 ds e16 ds | d4.~ 4 g,8 | g4.~ g }
}

%% LYRICS
verseA = \lyricmode {
  \l Lift ev -- 'ry voice and sing, till earth and heav -- en ring,
  \l ring with the har -- mo -- nies of lib -- er -- ty.
  \l Let our re -- joic -- ing rise high as the lis -- t'ning skies,
  \l let it re -- sound loud as the roll -- ing sea.

  \l Sing a song full of the faith that the dark past has taught us.
  \l Sing a song full of the hope that the pres -- ent has brought us.

  \l Fac -- ing the ris -- ing sun of our new day be -- gun,
  \l let us march on till vic -- to -- ry is won.
}
verseB = \lyricmode {
  Ston -- y the road we trod, bit -- ter the chas -- t'ning rod,
  felt in the days when hope un -- born had died,
  yet with a stead -- y beat, have not our wea -- ry feet
  come to the place for which our peo -- ple sighed?

  We have come o -- ver a way that with tears has been wa -- tered.
  We have come, tread -- ing our path thro' the blood of the slaugh -- tered,

  out of the gloom -- y past till now we stand at last
  where the bright gleam of our bright star is cast.
}
verseC = \lyricmode {
  God of our wea -- ry years, God of our si -- lent tears,
  thou who hast brought us thus far on the way,
  thou who hast by thy might, led us in -- to the light,
  keep us for -- ev -- er in the path, we pray.

  Lest our feet stray from the plac -- es, our God, where we met thee,
  lest, our hearts drunk with the wine of the world, we for -- get thee,

  shad -- owed be -- neath thy hand, may we for -- ev -- er stand,
  true to our God, true to our na -- tive land.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

songChords = \chords {
  \globalChordSymbols
  d4. g b:7 e:m e:m g b:7 e:m e:m a:m b:7 c c g/d g/d d
  d g b:7 e e a:m b:7 c cs:dim7 g/d g/d d:7 d:7 g g g
  g e:m e:m e:m e:m d d g g c:m c:m c:m c:m g g d:7 d:7 d:7
  d:7 g b:7 e e a:m b:7 c cs:dim7 g/d g/d d:7 d:7 g
}

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"

