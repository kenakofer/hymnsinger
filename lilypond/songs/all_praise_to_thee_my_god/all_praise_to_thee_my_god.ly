\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/tallis_canon.ly"

%% SONG INFO
title = \titleText "All praise to thee, my God"
poet = \smallText "Text: Thomas Ken, 1695"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part textbyother evening"
prescore_text = \prescoreText "Unison when sung in canon"
dateAdded = "2021-03-05"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  All praise to thee, my God, this night, for all the bless -- ings of the light.
  Keep me, O keep me, King of kings, be -- neath thine own al -- might -- y wings.
}
verseB = \lyricmode {
  O let my soul, on thee, re -- pose, and with sweet sleep my eye -- lids close,
  sleep that will me more vig -- 'rous make to serve my God when I a -- wake.
}
verseC = \lyricmode {
  Praise God from whom all bless -- ings flow, praise God all crea -- tures here be -- low,
  praise God a -- bove ye heav -- 'nly host, praise Fa -- ther, Son, and Ho -- ly Ghost.
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
