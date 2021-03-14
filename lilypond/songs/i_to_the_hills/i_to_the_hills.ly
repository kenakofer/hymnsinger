\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: The CL. Psalmes of David, 1615"
%arranger = \smallText "Arranged by (optional), year"
meter = \smallText "DUNDEE CM"
hymnKey = \key d \major
hymnTime = \time 4/4
quarternoteTempo = 80
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "I to the hills will lift my eyes"
%subtitle = \smallText "Optional"
poet = \smallText "Text: The New Metrical Version of the Psalms, 1912, alt."
copyright = \public_domain_notice "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
tags = "christian 4part acapella 4verse musicbyother textbyother"
dateAdded = "2021-03-13"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 d4 | fs g a d, | e fs g fs | e d d cs | d2. \bar "" } \break
  \relative g' { \partial 4 a4 | d cs b a | a gs a fs | e d d cs | d2. } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { a,4 | d d d b | cs d d d | cs b b a | a2. }
  \relative e' { d4 | fs e d cs | b b cs a | b b a4 a | a2. }
}
tenor = {
  \globalParts
  \relative a { fs4 | a b a fs | a a b a | a fs g e | fs2. }
  \relative a { fs4 | a a fs e | fs e e fs | g d e e | fs2. }
}
bass = {
  \globalParts
  \relative d { d4 | d g, fs b | a d g, d' | a b g a | d2. }
  \relative d { d4 | d a b cs | d e a, d | g, fs8( g) a4 a | d2. }
}
songChords = \chords {
  \set chordChanges = ##t
  d4 | d2 d a g b:m g4 a d2
  d2 d d e a g a d
}

%% LYRICS
verseA = \lyricmode {
  I to the hills will lift my eyes. From whence shall come my aid?
  My help is from the Lord a -- lone, who heav'n and earth has made.
}
verseB = \lyricmode {
  God will not let your foot be moved, your guar -- dian nev -- er sleeps.
  God's watch -- ful and un -- slum -- b'ring care pro -- tects and safe -- ly keeps.
}
verseC = \lyricmode {
  Your faith -- ful keep -- er is the Lord, your shelt -- er and your shade.
  'Neath sun or moon, by day or night, you shall not be a -- fraid.
}
verseD = \lyricmode {
  From e -- vil God will keep you safe, pro -- vide for all you need.
  Your go -- ing out, your com -- ing in, God will for -- ev -- er lead.
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
clairStaffZoom = #.9
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
