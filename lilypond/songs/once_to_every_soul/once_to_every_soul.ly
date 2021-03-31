\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/ebenezer_12_8.ly"

%% SONG INFO
title = \titleText "Once to every soul and nation"
poet = \smallText "Text: James Russell Lowell, 1845"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english secular 4part"
dateAdded = "2021-01-14"
\include "../../lib/header.ly"

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l Once to ev -- ’ry soul and na -- tion
  comes the mo -- ment to de -- cide,
  \l in the strife of truth with false -- hood,
  for the good or e -- vil side;

  \l Then to side with truth is no -- ble,
  when we share her wretch -- ed crust,
  \l ere her cause bring fame and prof -- it,
  and ’tis prosp -- ’rous to be just;
}
verseB = \tag #'verseB \lyricmode {
  New oc -- ca -- sions teach new du -- ties,
  time makes an -- cient good un -- couth;
  they must up -- ward still and on -- ward
  who would keep a -- breast of truth.

  Lo, be -- fore us gleam her camp -- fires!
  We our -- selves must seek -- ers be,
  nor at -- tempt the fu -- ture's por -- tal
  with the past's blood -- rus -- ted key.
}
verseC = \tag #'verseC \lyricmode {
  Though the cause of e -- vil pros -- per,
  yet ’tis truth a -- lone is strong;
  though her por -- tion be the scaf -- fold,
  and up -- on the throne be wrong.

  Then it is the brave one choos -- es,
  while the cow -- ard stands a -- side
  till the mul -- ti -- tude make vir -- tue
  of the faith they had de -- nied.
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
% Slides output
\include "../../lib/slides_book_3verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
