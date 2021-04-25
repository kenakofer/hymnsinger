\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: African American spiritual"
arranger = \smallText "arr. John W. Work (1871-1925)"
meter = \smallText "GO DOWN MOSES 85.85 with refrain"
hymnKey = \key g \minor
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "When Israel was in Egypt's land"
poet = \smallText "Text: African American spiritual"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english christian 4part"
dateAdded = "2021-02-07"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 d4^\markup { \italic Unison } | bf'4 4 a a | bf4 4 g2 | d4^\markup { \italic Harmony } d fs8 4. | g2. \bar " " } \break
  \relative g' { d4^\markup { \italic Unison } | bf'4 4 a a | bf4 4 g2 | d4^\markup { \italic Harmony } d fs8 4. | g1 \bar "||" } \break
  \relative g' { g4 2. | c4 2. | d2 4. c8 | d4 d c8( bf4.) | } \break
  \relative g' { bf8( g8) 2( bf4) | g8( f) d2. | d4 d fs8 4. | \partial 2. g2. | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 | bf2 c | bf bf | bf4 4 c8 4. | bf2. }
  \relative e' { d4 | bf2 c | bf d4( c) | bf4 4 c8 4. | bf1 | }
  \relative e' { g4 2. | c4 2. | d,4( g) fs4. 8 | g4 fs g2 | }
  \relative e' { c2 ef | d a | bf4 4 c8 4. | bf2. | }
}
tenor = {
  \globalParts
  \relative a { d,4 | 2 ef2 | d d | g4 g a8 4. | g2. }
  \relative a { d,4 | d2 ef | d g | g4 g a8 4. | g1 | }
  \relative a { g4 2. | c4 2. | g4( d') c4. d8 | d4 4 2 | }
  \relative a { g2 g | g fs | g4 g a8 4. | d,2. | }
}
bass = {
  \globalParts
  \relative d { d4 | g,2 g | g g | d'4 4 8 4. | g,2. }
  \relative d { d4 | g,2 g | g bf4( ef) | d4 4 8 4. | g,1 | }
  \relative a { g4 2. | c,4 2. | bf4( bf') a4. 8 | bf4 a g( f) | }
  \relative d { ef2 c | bf4.( c8) d2 | d4 4 8 4. | g,2. | }
}
songChords = \chords {
  \globalChordSymbols
  s4 g2:m c:m g:m g:m g:m d:7 g:m g:m
  g2:m c:m g:m g:m g:m d:7 g:m g:m
  g2:m g:m c:m c:m g:m d:7 g:m g:m
  c1:m7 g2:m d g:m d:7 g:m
}

%% LYRICS
verseA = \lyricmode {
  \l When Is -- rael was in E -- gypt's land,
  let my peo -- ple go,
  \l op -- pressed so hard they could not stand,
  let my peo -- ple go.
  %% CHORUS
  Go down, Mo -- ses, way down in E -- gypt's land,
  tell old Pha -- raoh: let my peo -- ple go.
}
verseB = \lyricmode {
  The Lord told Mo -- ses what to do,
  let my peo -- ple go,
  to lead the He -- brew chil -- dren through,
  let my peo -- ple go.
  %% CHORUS
  \SB {
    Go down, Mo -- ses, way down in E -- gypt's land,
    tell old Pha -- raoh: let my peo -- ple go.
  }
}
verseC = \lyricmode {
  As Is -- rael stood by wa -- ter's side,
  let my peo -- ple go,
  at God's com -- mand it did di -- vide,
  let my peo -- ple go.
  %% CHORUS
  \SC {
    Go down, Mo -- ses, way down in E -- gypt's land,
    tell old Pha -- raoh: let my peo -- ple go.
  }
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

extra_verses = \markup {
  \fill-line {
     \column {
      \line { \bold "4."
        \column { % LYRICS-START
"When they had reached the other shore,"
"let my people go,"
"they let the song of triumph soar,"
"let my people go."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line { \bold "5."
        \column { % LYRICS-START
"Lord, help us all from bondage flee,"
"let my people go,"
"and let us all in Christ be free,"
"let my people go."
        }
      }
    }
  \hspace #0.1 % gives some extra space on the right margin;
  % can be removed if page space is tight
  }
}

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
