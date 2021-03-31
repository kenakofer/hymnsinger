\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/resignation_arrbykenan.ly"

%% SONG INFO
title = \titleText "No number tallies up my score"
poet = \smallText "Text: Ralph Waldo Emerson (1803-1882), alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english secular 4part"
dateAdded = "2021-02-14"
\include "../../lib/header.ly"

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l No num -- ber tal -- lies up my score,
  no tribe my house can fill;
  \l I sit be -- side the fount of life
  and pour the del -- uge still.
  \l And gath -- ered by most fra -- gile pow'rs
  a -- long the cen -- tur -- ies
  \l from race on race the rar -- est flow'rs
  my wreath shall noth -- ing miss.
}
verseB = \tag #'verseB \lyricmode {
  I wrote the past in char -- ac -- ters
  of rock and fire and scroll,
  the build -- ing in the cor -- al sea, the plant -- ing of the coal.
  And thefts from sat -- el -- lites and rings
  and bro -- ken stars I drew,
  and out of spent and ag -- ed things
  I formed the world a -- new.
}
verseC = \tag #'verseC \lyricmode {
  Must time and tide for -- ev -- er run,
  nor winds sleep in the west?
  Will ne'er my wheels which whirl the sun
  and sat -- el -- lites have rest?
  Yet whirl the glow -- ing wheels once more,
  and mix the bowl a -- gain;
  seethe, Fate, the an -- cient el -- e -- ments,
  heat, cold, and peace, and pain.
}
verseD = \tag #'verseD \lyricmode {
  Blend war and trade and creeds and song,
  as rip -- ens hu -- man race,
  the sun -- burnt world that they shall breed,
  of all my count -- less days.
  No ray is dimmed, no a -- tom worn,
  my old -- est force is new,
  and fresh the rose on yon -- der thorn
  gives back the heav'ns in dew.
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
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
