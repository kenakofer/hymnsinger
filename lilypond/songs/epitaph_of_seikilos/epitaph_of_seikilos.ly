\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Seikilos, ca. 1st-2nd c."
meter = \smallText "EPITAPH OF SEIKILOS irregular"
hymnKey = \key a \mixolydian
hymnTime = \time 6/8
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/8)
hymnBeatStructure = \set Timing.beatStructure = 3,3
quarternoteTempo = 70
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Epitaph of Seikilos"
subtitle = \smallText \markup { \italic "''I am a tombstone, an image. Seikilos placed me here as a long-lasting sign of deathless remembrance.''" }
poet = \twoLineSmallText "Text: Greek: Seikilos, ca. 1st-2nd c." "tr. Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english greek secular 1part death"
dateAdded = "2021-03-21"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { a8 e'4 e4. | cs8( d e) d4. | cs4 d8 e d( cs) | b a4 b8( g4) } \break
  \relative g' { a8 cs e d cs( d) | cs8 a4 b8( g4) | a8  cs b d e cs | a a4 a16[( fs] e4) } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' {}
  \relative e' {}
  \relative e' {}
  \relative e' {}
}
tenor = {
  \globalParts
  \relative a {}
  \relative a {}
  \relative a {}
  \relative a {}
}
bass = {
  \globalParts
  \relative d {}
  \relative d {}
  \relative d {}
  \relative d {}
}
songChords = \chords {
  \globalChordSymbols
}

%% LYRICS
verseA = \lyricmode {
  Hó -- son zêis, phaí -- nou
  mē -- dèn hó -- lōs sù lu -- poû
  pròs ol -- í -- gon és -- ti tò zên
  tò té -- los ho khró -- nos a -- pai -- teî.
}
verseB = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  While you live, shine bright.
  Don't let grief sour your guest, Life,
  stay -- ing with you, just for a while.
  Soon will come due all de -- mands of Time.
}
spacingVerse = \lyricmode {
  "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t"
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseB } }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_2verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
