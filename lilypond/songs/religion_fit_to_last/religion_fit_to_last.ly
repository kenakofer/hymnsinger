\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
composer = \smallText "Music: French folk melody"
meter = \smallText "JESOUS AHATONHIA (adapted) 86.86.76.86"
hymnKey = \key g \minor
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ily"

%% SONG INFO
title = \titleText "Religion fit to last"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
poet = \smallText "Text: Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english secular 1part accompanied"
dateAdded = "2021-01-12"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 d4 | g a bf c | bf a g f | g g a f | \partial 2. g2. \bar " " } \break
  \relative g' { \partial 4 d4 | g a bf c | bf a g f | g bf a f | g2. r4 } \break
  \relative g' { d'4 d a bf | c4. bf8 a4 a | bf a g g | \partial 2. a2( g4) \bar " " | } \break
  \relative g' { \partial 4 ef4 | d g g g | f4 ef d d | g4. g8 f4 d | \partial 2. g2 r4 \bar " " } \break
  \relative g' { \partial 4 a4 | bf c d d, | \partial 2. g2. | }
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 | d d c ef | d c bf c | d c ef c | d2. |}
  \relative e' { d4 | d d c ef | d c bf c | d d c ef | d2. r4 |}
  \relative e' { d4 d f g | g a e c | g' g d d | f2. |}
  \relative e' { r4 | r1 | r | r | r2 r4 |}
  \relative e' { f4 | g f8 g fs4 d | d2. |}
}
tenor = {
  \globalParts
  \relative a { g4 | d'4. 8 4 c | bf c d c | bf c d c | g2. |}
  \relative a { g4 | g a bf a | g a bf a | g f a c | d2. d8 c |}
  \relative a { g4. 8 a4 bf | c c, e f | g g bf d | d2 c4 |}
  \relative a { c4 | g g g g | g g bf a | g g g a | bf2 8 a |}
  \relative a { f4 | g a2 g8 a | bf2. |}
}
bass = {
  \globalParts
  \relative d { g,4 | <d d'>1 | <d d'>2. <c c'>4 | <d d'>2 <c c'> | g'2. |}
  \relative d { g,4 | <d d'>1 | <d d'>2. <c c'>4 | <d d'>2 <c c'> | g'1 |}
  \relative d { g,2 c4 d | g,2 a4 f | g2 a4 bf | c2 ef4 |}
  \relative d { ef4 | g,1 | af4 af g2 | g4 bf d f | g8 f ef2 d4 | g,4 g g g | g2. }
}


%% LYRICS
verseA = \lyricmode {
  A voice with -- in cries out, dis -- tressed, to see you taste the fruit,
  for -- bid -- den by your God and creed, res -- pec -- ted since your youth:
  ''Pro -- di -- gal, I'll fight in you, re -- store your faith to thrive.
  I'll bring you back with -- in the fold. With -- out you can't sur -- vive.
  With -- out you can't sur -- vive!''
}
verseB = \lyricmode {
  ''You'd loose the bond of fam -- i -- ly!'' your in -- stinct di -- a -- tribes.
  De -- cide: Be shunned to wil -- der -- ness, or rest in harm -- less lies.
  Act a -- gainst e -- vol -- véd traits? Your lo -- gic might a -- gree,
  but in your gut, you crave not truth, you crave com -- mun -- i -- ty.
  You crave com -- mun -- i -- ty!
}
verseC = \lyricmode {
  If earth -- ly fears don't faze you, try a sam -- ple of Pas -- cal:
  A slim chance of e -- ter -- nal bliss is worth more than your all.
  Walk a -- long the Ro -- man Road, a -- void e -- ter -- nal pain.
  Sal -- va -- tion's path is mark -- éd well, with brim -- stone in the drain,
  with brim -- stone in the drain:
}

verseD = \lyricmode {
  Step one: be -- lieve, O wretch, your life is worth -- less, just -- ly lost,
  and se -- cond: faith's your on -- ly hope, at seem -- ing -- ly no cost!
  Third, since faith is proved by work, pay up in du -- ties due:
  Two hands on plow, and don't look back, for Bro -- ther's watch -- ing you.
  Your God is watch -- ing you!
}
verseE = \lyricmode {
  Mere rea -- son of one mind can't win; the test of time is passed.
  Re -- li -- gions of to -- day are the re -- li -- gions fit to last.
  Mem -- bers true through pow -- er, fear, or friend -- ly com -- pa -- ny
  re -- buke a -- gain their way -- ward young, ''Eat not from yon -- der tree.''
  ''Eat not from yon -- der tree!''
}

\include "../../lib/5verse.ily"

%% All sheet music outputs
clairStaffZoom = #.9
\include "../../lib/all_notation_outputs.ily"
% Slides output
\include "../../lib/slides_book_5verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"