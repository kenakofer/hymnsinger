\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/lacquiparle_melody.ly"

%% SONG INFO
title = \titleText "Singer of Life"
poet = \smallText "Text: From a Texcoco Nahuatl poem"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "english theist 1part"
dateAdded = "2021-03-08"
\include "../../lib/header.ly"

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l Sing -- er of Life, all flow -- ers are songs, with pet -- als do you write.
  \l Sing -- er of Life, you col -- or the earth, daz -- zling the eye with birds red and bright.
  \l Joy is for us! The flow -- ers are spread! Sing -- ing is our de -- light!
}
verseB = \tag #'verseB \lyricmode {
  Mor -- tal are we, with all liv -- ing things, with ea -- gles in the sky.
  E -- ven all gold and jade will not last; sing -- ing a -- lone, I know, can -- not die.
  Here in this house of spring -- time be -- stow songs that like birds can fly.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_2verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
