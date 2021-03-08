\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "secular 4part acapella 5verse musicbyother textbyother autumn"
\header {
  title = \titleText "I walk the unfrequented road"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: John Wyeth, 1813"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: Frederick Lucian Hosmer, 1913"
  meter = \smallText "CONSOLATION CM"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key f \minor
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
  \stemUp
  \relative g' { \partial 4 c,4 | f g af bf8( af) | \partial 2. g4 f8( ef) c4 \bar "" } \break
  \relative g' { \partial 4 c,4 | f g af bf | \partial 2. c2. \bar "" } \break
  \relative g' { \partial 4 af8( bf) | c4 df8( c) bf4 af | \partial 2. g4 f8( ef) c4 \bar "" } \break
  \relative g' { \partial 4 c,4 | f g af8( f) g4 | \partial 2. f2. } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c4 | c c c df | ef c af c | bf ef c ef | ef2. }
  \relative e' { ef4 | ef df f df | bf c c c | c ef c c | af2. }
}
tenor = {
  \globalParts
  \relative a { c,4 | c'4 bf af f | ef g af g | f c' af g | af2. | }
  \relative a { af4 | af f f f | ef8( f) g4 af af8( bf) | c4 bf af ef | f2. }
}
bass = {
  \globalParts
  \relative d { c4 | af'4 g f bf, | c c f ef | df c f ef | af,2. | }
  \relative d { c8( bf) | af4 bf8( c) df4 bf | ef c f f8( g) af4 ef af, c | f,2. |}
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  I walk the un -- fre -- quent -- ed road
  with o -- pen eye and ear;
  I watch a -- field the farm -- er load
  the boun -- ty of the year.
}
verseB = \lyricmode {
  I filch the fruit of no one's toil—
  no tres -- pass -- er am I—
  and yet I reap from ev -- ery soil
  and from the bound -- less sky
}
verseC = \lyricmode {
  I gath -- er where I did not sow,
  and bind the mys -- tic sheaf,
  the am -- ber air, the riv -- er's flow,
  the rus -- tle of the leaf.
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
     \column {
      \line { \bold "4."
        \column { % LYRICS-START
"A beauty springtime never knew"
"haunts all the quiet ways,"
"and sweeter shines the landscape through"
"its veil of autumn haze."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line { \bold "5."
        \column { % LYRICS-START
"I face the hills, the streams, the wood,"
"and feel with all akin;"
"my heart expands; their fortitude"
"and peace and joy flow in."
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
    \tempo  4 = 100
  }
}
