\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: traditional English melody"
meter = \smallText "GREENSLEEVES 87.87.68.67"
hymnKey = \key e \minor
hymnTime = \time 6/8
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/8)
hymnBeatStructure = \set Timing.beatStructure = 3,3
quarternoteTempo = 65
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "What Child is this"
poet = \smallText "Text: William C. Dix, ca. 1865"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 3
tags = "christian 4part musicbyother textbyother winter"
dateAdded = "2021-01-12"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 8 e8 | g4 a8 b8.( c16) b8 | a4 fs8 d8.( e16) fs8 | g4 e8 e8.( ds16) e8 | fs4( ds8) \partial 4 b4 \bar " "} \break
  \relative g' { \partial 8 e8 | g4 a8 b8.( c16) b8 | a4 fs8 d8.( e16) fs8 | g8.( fs16) e8 ds8.( cs16) ds8 | e4. e | } \break
  \relative g' { d'4. 8.( cs16) b8 a4 fs8 d8.( e16) fs8 | g4 e8 8.( ds16) e8 | fs4 ds8 b4. | } \break
  \relative g' { d'4. 8.( cs16) b8 a4 fs8 d8.( e16) fs8 | g8.( fs16) e8 ds8.( cs16) ds8 | e4. \partial 4 e4 |} \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { e8 | e4 d8 d4 g8 | fs4 d8 d4 d8 | b4 8 a4 e'8 | ds4( b8) 4 |}
  \relative e' { e8 | e4 d8 d4 g8 | fs4 d8 d4 d8 | b4 c8 b4 8 | b4. b | }
  \relative e' { fs4. b8.( a16) g8 | fs4 d8 4 8 | b4 8 a4 e'8 | ds4 b8 b4. | }
  \relative e' { fs4. b8.( a16) g8 | fs4 d8 4 8 | b4 c8 b4 8 | b4. b4 | }
}
tenor = {
  \globalParts
  \relative a { g8 | b4 a8 g4 b8 | d4 a8 fs4 a8 | g4 8 e4 8 | b4. b4 | }
  \relative a { g8 | b4 a8 g4 b8 | d4 a8 fs4 a8 | g4 a8 fs4 b8 | a4. g4. | }
  \relative a { d4. 4 8 | d4 a8 fs4 a8 | g4 8 e4 8 | b'4 8 4. |}
  \relative a { d4. 4 8 | d4 a8 fs4 a8 | g4 a8 fs4 b8 | a4. g4 |}
}
bass = {
  \globalParts
  \relative d { e8 | e4 fs8 g4 8 | d4 8 4 8 | e4 8 c4 8 | b4. 4 | }
  \relative d { e8 | e4 fs8 g4 8 | d4 8 4 8 | e4 a,8 b4 8 | e4. e | }
  \relative d { b'4. g4 8 | d4 8 d4 8 | e4 8 c4 8 | b4 8 4. |}
  \relative d { b'4. g4 8 | d4 8 d4 8 | e4 a,8 b4 8 | e4. 4 |}
}


%% LYRICS
verseA = \lyricmode {
  What Child is this, who, laid to rest, on Ma -- ry's lap is sleep -- ing,
  whom an -- gels greet with an -- thems sweet, while shep -- herds watch are keep -- ing?
  This, this is Christ the King, whom shep -- herds guard and an -- gels sing.
  Haste, haste to bring him laud, the babe, the son of Ma -- ry!
}
verseB = \lyricmode {
  Why lies he in such mean es -- tate where ox and ass are feed -- ing?
  Good Chris -- tian, fear, for sin -- ners here the si -- lent Word is plead -- ing.
  Nails, spear shall pierce him through, the cross be borne for me, for you.
  Hail, hail the Word -- made -- flesh, the babe, the son of Ma -- ry!
}
verseC = \lyricmode {
 So bring him in -- cense, gold, and myrrh, come, peas -- ant, king, to own him.
 The King of kings sal -- va -- tion brings, let lov -- ing hearts en -- throne him.
 Raise, raise the song on high; the vir -- gin sings her lul -- la -- by.
 Joy, joy for Christ is born, the babe, the son of Ma -- ry!
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
