\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared_tunes/orientis_partibus_77_77.ly"

%% SONG INFO
title = \titleText "Bright those jewels"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Hosea Ballou II, 1849"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english secular 4part"
dateAdded = "2021-03-22"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  Bright those jew -- els of the skies
  which in sa -- ble dark -- ness glow.
  Bright -- er in com -- pas -- sion's eyes
  are the si -- lent tears which flow.
}
verseB = \lyricmode {
  Sweet the fra -- grance from the fields where a -- bun -- dant spic -- es grow.
  Sweet -- er far is that which yields
  suc -- cor to the sick and low.
}
verseC = \lyricmode {
  Grate -- ful are those gen -- tle dews
  on the green -- ing grass which fall.
  Far more grate -- ful what re -- news
  com -- forts to the poor who call
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
