\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Samuel Webbe Sr., 1792"
meter = \smallText "CONSOLATOR 11.10.11.10"
hymnKey = \key c \major
hymnTime = \time 2/2
quarternoteTempo = 115
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Come, ye disconsolate"
poet = \smallText "Text: v.1-2 Thomas Moore, 1816, alt.; v.3 Thomas Hastings, 1831"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english theist 4part"
dateAdded = "2021-05-15"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    g2 e4 c | a'4. g8 2 | f4.( g8) a4 b | c4.( g8) g2 | \break
    e2 4 4 | f4. 8 a2 | g fs4 4 | g1 | \break
    c2 b4 a | g4. f8 e2 | c' d8( c) b( a) | g4.( f8) e2 | \break
    g4( e') e c | c a2 f4 | e2 d4. c8 | 1  | \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    c2 4 4 | 4. 8 2 | 2 4 f | e4.( d8) c2 |
    c2 4 4 | 4. 8 f2 | d2 4 4 | 1 |
    e2 f4 4 | e4. d8 c2 | e f4 4 |e4.( d8) c2 |
    e4( g) 4 e | f4 2 d4 | c2 b4. c8 | 1 |
  }
}
tenor = {
  \globalParts
  \relative a {
    e2 g4 e | f4. e8 2 | c'2 4 g | 4.( f8) e2 |
    g2 4 4 | c4. 8 2 | b2 a4 c | b1 |
    g2 a4 b | c4. g8 2 | 2 a4 b8( c) | 4.( g8) 2 |
    g4( c) 4 g | a4 c2 a4 | g2 f4. e8 | 1 |
  }
}
bass = {
  \globalParts
  \relative d {
    c2 4 4 | 4. 8 2 | a'4.( e8) f4 d | c2 2
    2 4 bf | a4. 8 f2 | d' d4 4 | g1 |
    c,2 4 4 | 4. 8 2 | 2 f4 4 | c2 2 |
    c2 4 4 | f4 2 4 | g2 g,4. c8 | 1 |
  }
}
songChords = \chords {
  \globalChordSymbols
  c1 f2/c c f2. g4:7 c1
  c f g2/d d:7 g g
  c f/c c c c f c c
  c c f f c/g g:7 c
}

%% LYRICS
verseA = \lyricmode {
  \l Come, ye dis -- con -- so -- late, wher -- e'er ye lan -- guish,
  \l come to the mer -- cy seat, fer -- vent -- ly kneel.
  \l Here bring your wound -- ed hearts, here tell your an -- guish.
  \l Earth has no sor -- rows that Heav'n can -- not heal.
}
verseB = \lyricmode {
  Joy of the des -- o -- late, light of the stray -- ing,
  hope of the pen -- i -- tent, fade -- less and pure!
  Here speaks the Com -- fort -- er, ten -- der -- ly say -- ing,
  ''Earth has no sor -- rows that Heav'n can -- not cure.''
}
verseC = \lyricmode {
  Here see the Bread of life; see wa -- ters flow -- ing
  forth from the throne of God, pure from a -- bove.
  Come to the feast of love, come, ev -- er know -- ing
  earth has no sor -- rows but Heav'n can re -- move.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"