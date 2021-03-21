\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: John H. Hopkins Jr., 1857"
%arranger = \smallText "arr. Name, year"
meter = \smallText "KINGS OF ORIENT 88.446 with refrain"
hymnKey = \key g \major
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/8)
hymnBeatStructure = \set Timing.beatStructure = 3,3
hymnTime = \time 6/8
quarternoteTempo = 90
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "We three kings"
%subtitle = \smallText "Optional"
poet = \smallText "Text: John H. Hopkins Jr., 1857"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 5
tags = "english christian winter 4part"
dateAdded = "2021-03-20"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { b4 a8 g4 e8 | fs g fs e4. | b'4 a8 g4 e8 | fs g fs e4. | } \break
  \relative g' { g4 8 a4 8 | b4 8 d( c) b | a b a g4 fs8 | e2. | } \break
  \relative g' { fs4.( a) | g4 8 4 d8 | g4 e8 g4. | g4 8 4 d8 | g4 e8 g4. | } \break
  \relative g' { g4 8 a4 b8 | c4 b8 a4 b8 | g4 8 4 d8 | g4 e8 g4. | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { g4 fs8 e4 8 | ds ds ds e4. | g4 fs8 e4 8 | ds ds ds e4. | }
  \relative e' { e4 8 fs4 8 | g4 8 8( fs) g | e8 8 8 4 ds8 | e2. | }
  \relative e' { d2. | d4 8 4 b8 | e4 c8 d4. | d4 8 4 b8 | b4 c8 d4. | }
  \relative e' { e4 8 fs4 g8 | g4 8 g4 fs8 | d4 8 4 b8 | e4 c8 d4. | }
}
tenor = {
  \globalParts
  \relative a { b4 8 4 g8 | a b a g4. | b4 8 4 g8 | a b a g4. | }
  \relative a { b4 8 d4 8 | d4 8 b([ c) d] | c8 8 8 b4 a8 | g2. | }
  \relative a { a4.( c) | b4 8 4 g8 | g4 g8 b4. | b4 8 4 g8 | g4 g8 b4. | }
  \relative a { b4 8 d4 8 | e4 d8 d4 8 | b4 8 4 g8 | g4 g8 b4. | }
}
bass = {
  \globalParts
  \relative d { e4 8 4 8 | b8 8 8  e4. | e4 8 4 8 | b8 8 8  e4. | }
  \relative d { e4 8 d4 8 | g4 8 b( a) g | a8 8 8  b4 b,8 | e2. | }
  \relative d { d2. | g4 8 4 8 | c,4 c8 g4. | g'4 8 4 8 | e4 c8 g'4. | }
  \relative d { e4 8 d4 g8 | c,4 g'8 d4 d8 | g4 8 4 8 | c,4 c8 g4. | }
}
songChords = \chords {
  \set chordChanges = ##t
  e4.:m e:m b:7 e:m e:m e:m b:7 e:m
  e:m d g g a:m e4:m b8 e4.:m e:m
  d d g g c g g g e4:m c8 g4.
  e:m d4 g8 c4 g8 d4:sus d8 g4. g c g
}

%% LYRICS
verseA = \lyricmode {
  We three kings of O -- ri -- ent are;
  bear -- ing gifts we tra -- verse a -- far,
  field and foun -- tain, moor and moun -- tain,
  fol -- low -- ing yon -- der star.
  %% CHORUS
  \hideVerseNumberAtLineStart
  O star of won -- der, star of light,
  star with roy -- al beau -- ty bright,
  west -- ward lead -- ing still pro -- ceed -- ing,
  guide us to thy per -- fect light.
}
verseB = \lyricmode {
  Born a King on Beth -- le -- hem's plain,
  gold I bring to crown him a -- gain,
  King for -- ev -- er, ceas -- ing nev -- er,
  o -- ver us all to reign.
}
verseC = \lyricmode {
  Frank -- in -- cense to of -- fer have I;
  in -- cense owns a de -- i -- ty nigh;
  prayer and prais -- ing, voic -- es rais -- ing,
  wor -- ship -- ing God on high.
}
verseD = \lyricmode {
  Myrrh is mine; its bit -- ter per -- fume
  breathes a life of gath -- er -- ing gloom;
  sor -- rowing, sigh -- ing, bleed -- ing, dy -- ing,
  sealed in the stone -- cold tomb.
}
verseE = \lyricmode {
  Glo -- rious now be -- hold him a -- rise;
  King and God and sac -- _ ri -- fice:
  Al -- le -- lu -- ia, Al -- le -- lu -- ia,
  sounds through the earth and skies.
}
spacingVerse = \lyricmode {
  "\t"
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "1" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "2" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "3" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "4" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "5" \verseE }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

%% All sheet music outputs
shapeStaffZoom = #1.1
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
