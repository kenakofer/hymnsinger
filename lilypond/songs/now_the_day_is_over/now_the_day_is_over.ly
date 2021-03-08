\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "secular 4part acapella 5verse musicbyother textbyother evening autumn"
\header {
  title = \titleText "Now the day is over"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Friedrich Filitz, 1847"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \twoLineSmallText "Text: v.1 Sabine Baring Gould, 1865" "v.2-5 Marye B. Bonney (1910-1992)"
  meter = \smallText "WEM IN LEIDENSTAGEN 65.65"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key f \major
hymnTime = \time 4/4
%% Adjust these to fix beaming
%hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/4)
%hymnBeatStructure = \set Timing.beatStructure = 1,1,1,1
%hymnBeatExceptions = \set Timing.beamExceptions = #'()
globalParts = {
  \hymnKey
  \hymnTime
  \hymnBaseMoment
  \hymnBeatStructure
  \hymnBeamExceptions
  \numericTimeSignature
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { a4 a g g | f2 e | f4 4 g g | a2. r4 | } \break
  \relative g' { c4 c bf4 4 | a2 g | a4 a g g | f1 } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f f e | e( d) cs2 | d4 f f e | f2. r4 | }
  \relative e' { e4 f d g | g( f) e2 | f4 f f e | c1 | }
}
tenor = {
  \globalParts
  \relative a { c4 c c c | a2 a | a4 a c c | c2. r4 | }
  \relative a { c4 a bf c | c2 c | c4 c d c | a1 }
}
bass = {
  \globalParts
  \relative d { f4 f c c | d2 a | d4 d c c | f2. r4 | }
  \relative d { a'4 f g e | f2 c | f4 a, bf c | f1 | }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Now the day is o -- ver,
  night is draw -- ing nigh,
  shad -- ows of the eve -- ning
  steal a -- cross the sky.
}
verseB = \lyricmode {
  Now the leaf -- less land -- scape
  set -- tles in re -- pose,
  wait -- ing for the qui -- et
  of the win -- ter snows.
}
verseC = \lyricmode {
  Now as twi -- light gath -- ers
  let us pause and hear
  all the slow -- ing pulse -- beats
  of the wan -- ing year.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

extra_verses = \markup {
  \fill-line {
  \hspace #0.01 % gives some extra space on the right margin;
     \column {
      \line { \bold "4."
        \column { % LYRICS-START
"May the season's rhythms,"
"slow and strong and deep"
"soothe the mind and spirit"
"lulling us to sleep."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line { \bold "5."
        \column { % LYRICS-START
"Sleep until the rising"
"of another spring"
"keeps the the ancient promise"
"fall and winter bring."
        }
      }
    }
  \hspace #0.1 % gives some extra space on the right margin;
  % can be removed if page space is tight
  }
}


%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } \extra_verses }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } \extra_verses }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } \extra_verses }

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
    \tempo  4 = 100
  }
}
