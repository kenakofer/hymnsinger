\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Richard Strutt, 1925"
%arranger = \smallText "arr. Name, year"
meter = \smallText "ST. CATHERINE'S COURT 13.12.13.11"
hymnKey = \key d \major
hymnTime = \time 3/4
quarternoteTempo = 100
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "In our day of thanksgiving"
poet = \smallText "Text: William H. Draper, 1916"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part death"
dateAdded = "2021-03-29"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 d8[ e] | fs4 d e | fs d e | fs g a | b a \bar "" \break
    \partial 4 b8 cs | d4 fs, b | a cs, d | e e fs | e2 \bar "" \break
    \partial 4 d8[ e] | fs4 d e | fs as b | cs d e | e d \bar "" \break
    \partial 4 cs8( b) | a4 b d | d d, a' | g8( fs) e4. d8 | d2
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d8 a | d4 a a | d d a | a d d | d d
    fs | fs fs d | d cs a | b b d | cs2
    d8 a | d4 d b | cs fs fs | fs fs g | g fs
    a8( g) | fs4 es es | fs d d | e8( d) 4( cs8) d | d2
  }
}
tenor = {
  \globalParts
  \relative a {
    fs8 g | a4 fs g | a b cs | d g, fs | g fs
    d' | d cs b | d a a | a gs gs | a2
    fs8 g | a4 b b | as cs d | as b cs | cs d
    d | d cs b | a fs a | b e,8( fs) g4 | fs2
  }
}
bass = {
  \globalParts
  \relative d {
    d4 | d d d | d b a | d8( cs) b4 a | g d'
    b' | b a g | fs g fs | e e e | a,2
    d4 | 8( cs) b4 g' | fs e d | cs b as | b b
    g' | a gs gs | a b, fs | g a a | d2
  }
}
songChords = \chords {
  \globalChordSymbols
  d4 | d2. d d g4 d d
  b2.:m d e a
  d fs fs b:m
  d/a d a d2
}

%% LYRICS
verseA = \lyricmode {
  \l In our day of thanks -- giv -- ing
  one psalm let us of -- fer
  \l for the saints who be -- fore us
  have found the re -- ward;
  \l when the sha -- dow of death
  fell up -- on them, we sor -- rowed,
  \l but now we re -- joice
  that they rest in the Lord
}
verseB = \lyricmode {
  In the morn -- ing of life,
  and at noon, and at eve -- ning,
  they were gath -- ered to heav'n
  from our wor -- ship be -- low;
  but not be -- fore God's love
  at the font and the al -- tar,
  had clothed them with grace
  for the way they should go.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ly"

extra_verses = \markup {
  \fontsize #-1.5
  \fill-line {
    \hspace #-10.0 % moves the column off the left margin;
     % can be removed if space on the page is tight
     \vspace #0

     \column {
      \line {
        \raise #3
        \bold "3."
        \raise #3
        \column { % LYRICS-START
"Common stones that have echoed"
"their praises are holy,"
"and the dust of the ground"
"where their feet have once trod;"
"yet in this place confessed"
"they were stargers and pilgrims,"
"and still they were seeking"
"the city of God."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \raise #3
        \bold "4."
        \raise #3
        \column { % LYRICS-START
"Sing praise, then, and thanks "
"that God's love here has found them"
"whose journey is ended,"
"whose perils are past;"
"they believed in the light; "
"and its glory is round them,"
"where the clouds of earth’s "
"sorrows are lifted at last."
        }
      }
    }
  \hspace #0.1 % gives some extra space on the right margin;
  % can be removed if page space is tight
  }
}

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_2verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"