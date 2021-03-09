\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/ebenezer_12_8.ly"

%% SONG INFO
title = \titleText "Once to every soul and nation"
poet = \smallText "Text: James Russell Lowell, 1845"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "secular 4part acapella 3verse musicbyother textbyother"
dateAdded = "2021-01-14"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  Once to ev -- ’ry soul and na -- tion
  comes the mo -- ment to de -- cide,
  in the strife of truth with false -- hood,
  for the good or e -- vil side;

  Then to side with truth is no -- ble,
  when we share her wretch -- ed crust,
  ere her cause bring fame and prof -- it,
  and ’tis prosp -- ’rous to be just;
}
verseB = \lyricmode {
  New oc -- ca -- sions teach new du -- ties,
  time makes an -- cient good un -- couth;
  they must up -- ward still and on -- ward
  who would keep a -- breast of truth.

  Lo, be -- fore us gleam her camp -- fires!
  We our -- selves must seek -- ers be,
  nor at -- tempt the fu -- ture's por -- tal
  with the past's blood -- rus -- ted key.
}
verseC = \lyricmode {
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


%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } }

%% MIDI output
\score {
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
    \new Staff \with { midiMaximumVolume = #0.7  } \alto
    \new Staff \with { midiMaximumVolume = #0.8  } \tenor
    \new Staff \with { midiMaximumVolume = #0.9 } \bass
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo  4 = 120
  }
}
