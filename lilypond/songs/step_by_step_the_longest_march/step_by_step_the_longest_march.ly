\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
%% Otherwise set up tune info here:
composer = \smallText "Music: Irish folk song"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "SOLIDARITY 76.76 D"
hymnKey = \key e \minor
hymnTime = \time 4/4
quarternoteTempo = 110
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Step by step the longest march"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Preamble to United Mine Workers of America Constitution"
copyright = \public_domain_notice "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 1
tags = "english secular 3part"
dateAdded = "2021-03-09"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 2 e4 fs | g4. fs8 e4 d | e2 4 fs | e2 4 fs | \partial 2 e4 r \bar "" } \break
  \relative g' { \partial 2 e4 fs | g4. fs8 e4 d | e2 4 fs | e2 4 fs | \partial 2 e4 r \bar "" } \break
  \relative g' { \partial 2 e4 fs | g4. fs8 g4 a | b2 a2 | c4. b8 a4 g | \partial 2 fs4 r \bar "" } \break
  \relative g' { \partial 2 e4 fs | g4. fs8 e4 d | e2 4 fs | e2 4 fs | \partial 2 e2 \bar "" } \break
  \bar "|."
}
alto = { }
tenor = {
  \globalParts
  \relative a { e4 fs4 | g4. fs8 e4 d | e2 e4 b' | b2 c4 c | b r }
  \relative a { e4 fs4 | g4. fs8 e4 d | e2 e4 b' | b2 b4 b4 | b r }
  \relative a { e4 b' | b4. d8 b4 d | d2 d | c4. d8 c4 c | b r }
  \relative a { e4 fs4 | g4. fs8 e4 d | e2 e4 b' | b2 b4 b4 | b2 }
}
bass = {
  \globalParts
  \relative d { e4 fs4 | g4. fs8 e4 d | e2 b4 b | b2 a4 a | e' r }
  \relative d { e4 fs4 | g4. fs8 e4 d | e2 b4 b | b2 4 4 | e r }
  \relative d { e4 d | e4. d8 e4 fs4 | g2 a2 | a4. a8 a4 e | b r }
  \relative d { e4 fs4 | g4. fs8 e4 d | e2 b4 b | b2 4 4 | e2 }
}
songChords = \chords {
  \set chordChanges = ##t
  e2:m | 2 2 | 2 2 | 2 a:m | e1:m |
  2 2 | 2 2 | 2 b2:m | e1:m |
  | 2. d4 | g2 d2 | a1:m | b1:m
  | g2 a:m | e:m b:m | e:m b:m | e:m
}

%% LYRICS
verseA = \lyricmode {
  Step by step the long -- est march can be won, can be won,
  Man -- y stones can form an arch, sin -- gly none, sin -- gly none.
  And by un -- ion what we will can be ac -- com -- plished still,
  drops of wa -- ter turn a mill, sin -- gly none, sin -- gly none.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "" "" \verseA }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
