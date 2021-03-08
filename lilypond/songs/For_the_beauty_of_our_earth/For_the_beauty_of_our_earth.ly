\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/dix.ly"

tags = "secular 4part acapella 5verse musicbyother textadaptedbykenan"
\header {
  title = \titleText "For the beauty of our earth"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Conrad Kocher, 1838"
  %arranger = \smallText "Arranged by William H. Monk, 1861"
  poet = \twoLineSmallText "Text: Folliott S. Pierpoint, 1864" "Adapted by Kenan Schaefkofer, 2021"
  meter = \smallText "DIX 77.77.77"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% LYRICS
verseA = \lyricmode {
  For the beau -- ty of our earth, for the glo -- ry of her skies,
  for the love which from our birth o -- ver and a -- round us lies:
  %% CHORUS
  Source of all, to thee we raise this our hymn of grate -- ful praise.
}
verseB = \lyricmode {
  For the beau -- ty of each hour of the day and of the night,
  hill and vale and tree and flow'r, sun and moon and stars of light:
}
verseC = \lyricmode {
  For the joy of ear and eye, for the heart and mind's de -- light,
  For the 'me', 'my -- self', and 'I', con -- scious links to sound and sight:
}
verseD = \lyricmode {
  For the joy of hu -- man care, sib -- ling, part -- ner, par -- ent, child,
  friends we've lost and friends still here, for all self -- less thoughts and mild:
}
verseE = \lyricmode {
  For thy Truth both harsh and kind, sha -- dowed set -- ter of our stage,
  pat -- terns sought by hu -- man mind, guid -- ing us from age to age,
}
verseF = \lyricmode { }

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "" \verseE }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "6" "" \verseF }
>>

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

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
