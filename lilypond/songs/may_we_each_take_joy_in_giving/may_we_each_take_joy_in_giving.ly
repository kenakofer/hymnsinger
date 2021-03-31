\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/stuttgart.ly"

%% SONG INFO
title = \titleText "May we each take joy in giving"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Robert Murray, 1880, alt. Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english secular 4part"
dateAdded = "2021-03-14"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  May we each take joy in giv -- ing with a spir -- it large and free
  to our neigh -- bors and the stran -- gers, fost -- er -- ing com -- mun -- i -- ty.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
