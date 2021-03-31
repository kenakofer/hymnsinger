\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/orientis_partibus_87_87.ly"

%% SONG INFO
verseCount = 3
tags = "english secular 4part spring"
title = \titleText "Loveliest of trees"
poet = \smallText "Text: A. E. Housman, 1896"
typesetter = "Kenan Schaefkofer"
dateAdded = "2021-02-07"
\include "../../lib/header.ly"

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l Love -- liest of trees, the cher -- ry now,
  \l hung with bloom a -- long the bough,
  \l it stands a -- bout the wood -- land ride
  \l wear -- ing white for Eas -- ter -- tide.
}
verseB = \tag #'verseB \lyricmode {
  Now of my three -- score years and ten,
  twen -- ty will not come a -- gain.
  And take from sev'n -- ty springs a score,
  leav -- ing me just fif -- ty more.
}
verseC = \tag #'verseC \lyricmode {
  And since to look at things in bloom
  fif -- ty springs are lit -- tle room,
  a -- bout the wood -- lands I will go,
  see the cher -- ry hung with snow.
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
