\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: African American Spiritual"
meter = \smallText "AS I WENT DOWN TO THE RIVER TO PRAY irregular"
hymnKey = \key f \major
hymnTime = \time 2/2
quarternoteTempo = 130
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "As I went down to the river to pray"
%subtitle = \smallText "Optional"
poet = \smallText "Text: African American Spiritual"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-03-20"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { r4 c, c d | \time 3/2 f4 8 8 8 8 4 f2 | \time 2/2 g8 8 8 a g4 f | a g8( f) f4 \bar "" } \break
  \relative g' { \partial 4 d8( c) | c4 a c4. d8 | f4 d f a | g2 f8 4 d8 | c2. r4 \mark "Fine" \bar "|." } \break
  \relative g' { g2 4 f | a c a16( g f4.) | a4 g8( f) f4.( d8) | f8 4. d8( c4.) | } \break
  \relative g' { g2 4 f | a c a16( g f4.) | a4 g8 f f f d( c) | c1 \mark "D.C." | } \break
  \bar "||"
}
alto = {
  \globalParts
  \relative g' { r4 c, c d | c4 8 8 8 8 4 c2 | e8 8 8 f e4 d | f d c4 }
  \relative g' { bf, | a4 a a4. bf8 | c4 c c f | e2 d8 d4 d8 | c2. r4 }
  \relative g' { e2 4 d | f a f2 | f4 f d2 | d8 4. d8( c4.) | }
  \relative g' { e2 4 d | f a f2 | f4 d8 d d d d( c) | c1 | }
}
tenor = {
  \globalParts
  \relative a { r4 c, c d | a'4 8 8 8 8 4 a2 | bf8 8 8 c bf4 a4 | c bf a }
  \relative a { g | f f f4. f8 | a4 4 4 c | c2 bf8 bf4 bf8 | a2. r4 }
  \relative a { c2 4 bf | c f c2 | c4 4 bf2 | bf8 4. 8( a4.) | }
  \relative a { c2 4 bf | c f c2 | c4 bf8 a bf bf bf4 | a1 | }
}
bass = {
  \globalParts
  \relative d { r4 c c d | f4 8 8 8 8 4 f2 | c8 8 8 c c4 4 | f f f }
  \relative d { bf | c4 4 4. d8 | f4 4 4 a, | c2 bf8 bf4 bf8 | f'2. r4 }
  \relative d { c2 4 c | f f f2 | f4 a,4 bf2 | bf8 4. f'2 | }
  \relative d { c2 4 c | f f f2 | f4 f8 f bf,8 8 4 | f'1 | }
}
songChords = \chords {
  \globalChordSymbols
  s1 f1. c1 f f f c2 bf f1
  c2 c f f f bf bf f c c f f f bf f
}

%% LYRICS
verseA = \lyricmode {
  As I went down to the riv -- er to pray,
  stud -- y -- in' a -- bout that good old way,
  and who shall wear the star -- ry crown,
  good Lord, show me the way.

  \showVerseNumberAtLineStart "1" #4.5
  Oh, sis -- ters, let's go down,
  \hideVerseNumberAtLineStart
  let's go down, come on down.
  Oh, sis -- ters, let's go down,
  down to the riv -- er to pray.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
>>

extra_verses = \markup {
  \fill-line {
    \hspace #-50.0 % moves the column off the left margin;
     % can be removed if space on the page is tight

     \column {
      \line { \bold "2."
        \column { % LYRICS-START
"Oh, brothers, …"
        }
      }
      \combine \null \vspace #0.4 % adds vertical spacing between verses
      \line { \bold "3."
        \column { % LYRICS-START
"Oh, children, …"
        }
      }
      \combine \null \vspace #0.4 % adds vertical spacing between verses
      \line { \bold "4."
        \column { % LYRICS-START
"Oh, sinners, …"
        }
      }
    }
  }
}

%% All sheet music outputs
clairStaffZoom = #.9
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
