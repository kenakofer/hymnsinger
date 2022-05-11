\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: African-American Spiritual"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "WE SHALL OVERCOME irregular"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "We shall overcome"
poet = \smallText "Text: African-American Spiritual"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english secular 4part"
dateAdded = "2021-01-12"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { g4 g a a | g4.( f8 e2) | g4 g a a | g4.( f8 e2) | } \break
  \relative g' { g4 g a b | c2 d2 | b2( \tuplet 3/2 { a4 b a } | g2) a4( b) |  } \break
  \relative g' { c2 b4 a | g1 | a2 g4 f | e1 | g4 g c, f | e2 d | c1~ | 4 r4 r2 } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { e4 e f f | e4.( d8 c2) | e4 e f f | e4.( d8 c2) |}
  \relative e' { e4 e e gs | a4( g) fs2 | g4( d e2 | d2) f2 | }
  \relative e' { e2 e4 f | e1 | f2 d4 d | c1 |}
  \relative e' { c4 c c d | c2 b | c1~ | 4 r r2 | }
}
tenor = {
  \globalParts
  \relative a { c4 c c c | c4.( a8) g2 | c4 c c c | c4.( a8) g2 | }
  \relative a { c4 b a e | e4( a) a2 | b2( c | b) c4( b) | }
  \relative a { c2 b4 c | c4.( a8 g2) | c2 b4 b | a1 | g4 g a a | g2 g | g1~ | 4 }
  \relative a { }
}
bass = {
  \globalParts
  \relative d { c4 c f f | c1 | c4 c f, f | c'1 |}
  \relative d { c4 c c e | a,2 d | g1~ | g2 f4( g) }
  \relative d { c2 4 4 | c1 | f,2 g4 g | a1 | g'4 g f f | g2 g, | c1~ | 4 r r2 }
  \relative d {}
}
songChords = \chords {
  \globalChordSymbols
  c4 c f f c c c c | c c f f c c c c |
  c c a:m e | a:m a:m d d | g g f f | g2:7 f4 g:7 |
  c4 c e:m f | c c c c | f2 g:7 | a1:m | c4 c f f | c2 g2 | c1 |
}

%% LYRICS
verseA = \lyricmode {
  We shall o -- ver -- come,
  we shall o -- ver -- come,
  we shall o -- ver -- come some -- day!
  O deep in my heart
  I do be -- lieve
  we shall o -- ver -- come, some -- day!
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/1verse.ily"

extra_verses = \markup {
       \fontsize #-1.5

  \fill-line {
    \hspace #-40.0 % moves the column off the left margin;
     % can be removed if space on the page is tight
     \vspace #1

     \column {
      \line { \bold "2."
        \column { % LYRICS-START
"We'll walk hand in hand ... some day!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "3."
        \column { % LYRICS-START
"We shall live in peace … some day!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "4."
        \column { % LYRICS-START
"We are not afraid … today!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "5."
        \column { % LYRICS-START
"God will see us through ... some day!"
        }
      }
     }
  }
}

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-1verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
