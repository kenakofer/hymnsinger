\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: John Wyeth, 1813"
meter = \smallText "CONSOLATION (MORNING SONG) CM"
hymnKey = \key f \minor
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "I walk the unfrequented road"
poet = \smallText "Text: Frederick Lucian Hosmer, 1913"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english secular 4part autumn"
dateAdded = "2021-01-31"
\include "../../lib/header.ly"

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


%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l I walk the un -- fre -- quent -- ed road
  \l with o -- pen eye and ear;
  \l I watch a -- field the farm -- er load
  \l the boun -- ty of the year.
}
verseB = \tag #'verseB \lyricmode {
  I filch the fruit of no one's toil—
  no tres -- pass -- er am I—
  and yet I reap from ev -- ery soil
  and from the bound -- less sky
}
verseC = \tag #'verseC \lyricmode {
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

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"