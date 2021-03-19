\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/tallis_canon.ly"
quarternoteTempo = 100

%% SONG INFO
title = \titleText "Calm soul of all things"
poet = \smallText "Text: Matthew Arnold (1822-1888)"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 2
tags = "theist 4part musicbyother textbyother"
prescore_text = \prescoreText "Unison when sung in canon"
dateAdded = "2021-03-09"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  Calm soul of all things, make it mine
  to feel a -- mid the cit -- y's jar,
  that there a -- bides a peace of thine
  I did not make, and can -- not mar.
}
verseB = \lyricmode {
  The will to nei -- ther strive nor cry,
  the pow'r to feel with oth -- er's, give.
  Calm, calm me more, nor let me die
  be -- fore I have be -- gun to live.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
