\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared_tunes/be_still_and_know.ly"

%% SONG INFO
title = \titleText "Be still and know"
poet = \smallText "Text: Psalm 46:10"
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english theist 4part"
dateAdded = "2021-03-30"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  \l Be still and know that I am God.
  Be still and know that I am God.
  Be still and know that I am God.
}

spacingVerse = \lyricmode {
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"