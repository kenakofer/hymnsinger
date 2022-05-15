\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Franz Gruber, 1818"
meter = \smallText "STILLE NACHT Irregular"
hymnKey = \key bf \major
hymnTime = \time 6/8
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/8)
hymnBeatStructure = \set Timing.beatStructure = 3,3
quarternoteTempo = 50
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Silent Night, Holy Night"
poet = \twoLineSmallText "Text: Joseph Mohr, 1818;" "tr. John Freeman Young, 1863"
typesetter = "Zachary Cline"
verseCount = 4
tags = "english christian christmas 4part"
dateAdded = "2022-05-13"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    f8.( g16) f8 d4. | f8.( g16) f8 d4. | c'4 c8 a4. | bf4 bf8 f4. |
    g4 g8 bf8.( a16) g8 | f8.\( g16\) f8 d4. | g4 g8 bf8.\( a16\) g8 | f8.\( g16\) f8 d4. |
    c'4 c8 ef8. c16 a8 | bf4.( d) | bf8( f8) d8 f8. ef16 c8 | bf2. \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d8.( ef16) d8 bf4. | d8.( ef16) d8 bf4. | ef4 ef8 c4. | d4 d8 d4. |
    ef4 ef8 g8.( f16) ef8 | d8.\( ef16\) d8 bf4. | ef4 ef8 g8.\( f16\) ef8 | d8.\( ef16\) d8 bf4. |
    ef4 ef8 c8. ef16 c8 | d4.( f) | d4 bf8 d8. c16 a8 | bf2. \bar "|."
  }
}
tenor = {
  \globalParts
  \relative a {
    bf4 bf8 f4. | bf4 bf8 f4. | a4 a8 f4. | f4 f8 bf4. |
    bf4 bf8 g4 bf8 | bf8.\( bf16\) bf8 f4. | bf4 bf8 g8.\( a16\) bf8 | bf8.\( bf16\) bf8 f4. |
    a4 a8 a8. a16 f8 | f4.( bf) | bf4 f8 f8. f16 ef8 | d2. \bar "|."
  }
}
bass = {
  \globalParts
  \relative d {
    bf4 bf8 bf4. | bf4 bf8 bf4. | f'4 f8 f4. | bf,4 bf8 bf4. |
    ef4 ef8 ef4 ef8 | bf8.\( bf16\) bf8 bf4. | ef4 ef8 ef8.\( ef16\) ef8 | bf8.\( bf16\) bf8 bf4. |
    f'4 f8 f8. f16 f8 | bf,4.( bf) | f'4 f8 f,8. f16 f8 | bf2. \bar "|."
  }
}
songChords = \chords {
  \globalChordSymbols
  bf2. bf f bf 
  ef bf ef bf
  f bf bf4. f bf2.
}

%% LYRICS
verseA = \lyricmode {
  \l Si -- lent night, ho -- ly night! All is calm, all is bright, 
  \l Round yon vir -- gin moth -- er and child, Ho -- ly In -- fant, so ten -- der and mild,
  \l sleep in heav -- en -- ly peace, sleep in heav -- en -- ly peace.
}
verseB = \lyricmode {
  Si -- lent night, ho -- ly night! Shep -- herds quake at the sight, 
  glo -- ries stream from heav -- en a -- far, heav'n -- ly hosts _ sing: "\"Al" -- le -- lu -- ia,
  Christ the Sav -- ior is born, Christ the Sav -- ior is "born.\""
}
verseC = \lyricmode {
  Si -- lent night, ho -- ly night! Son of God, love's pure light,
  ra -- diant beams from Thy ho -- ly face, with the dawn of re deem -- _ ing grace,
  Je -- sus, Lord, at Thy birth, Je -- sus, Lord, at Thy birth.
}
verseD = \lyricmode {
  Si -- lent night, ho -- ly night! Won -- drous star, lend they light, 
  with the an -- gels let _ us sing, Al -- le -- lu -- _ ia to _ our King,
  Christ the Sav -- ior is born, Christ the Sav -- ior is born.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"