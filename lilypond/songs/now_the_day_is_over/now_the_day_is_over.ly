\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Friedrich Filitz, 1847"
meter = \smallText "WEM IN LEIDENSTAGEN 65.65"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Now the day is over"
poet = \twoLineSmallText "Text: v.1 Sabine Baring Gould, 1865" "v.2-5 Marye B. Bonney (1910-1992)"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 5
tags = "secular 4part musicbyother textbyother evening autumn"
dateAdded = "2021-02-11"
\include "../../lib/header.ly"

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

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% midi output
\include "../../lib/midi_output.ly"
