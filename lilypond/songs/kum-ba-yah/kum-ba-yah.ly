\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: African American spiritual"
meter = \smallText "KUM BA YAH 88.85"
hymnKey = \key c \major
hymnTime = \time 3/4
quarternoteTempo = 80
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Kum ba yah"
poet = \smallText "Text: African American spiritual"
typesetter = "Kenan Schaefkofer"
postscore_text = \postscoreText "*Come by here"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-07-27"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 c,8 e | g8. 16 4 a8 a | g2 c,8 e | g8. 16 4 f8 e | d2 \bar "" \break
    c8 e | g8. 16 4 a8 a | g2 f4 | e8( c4.) d8 8 | c2
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    c8 e | e8. 16 4 f8 8 | e2 c8 e | e8. 16 4 c8 c | b2
    c8 e | e8. 16 4 f8 8 | e2 d4 | c2 c8[ b] | g2
  }
}
tenor = {
  \globalParts
  \relative a {
    e8 g | c8. 16 4 8 8 | 2 e,8 g | c8. 16 4 a8 8 | g2
    e8 g | c8. 16 4 8 8 | 2 a4 | g8( e4.) f8 8 | e2
  }
}
bass = {
  \globalParts
  \relative d {
    c8 c | 8. 16 4 f8 8 | c2 c8 c | 8. 16 4 8 8 | g2
    c8 c | 8. 16 4 f8 8 | c2 f,4 | g2 8 8 | c2
  }
}
songChords = \chords {
  \globalChordSymbols
  s4 | c2 f4 | c2. | c2 f4 | g2
  c4 | c2 f4 | c2 d4:m | c2 g4:7 | c2
}

%% LYRICS
verseA = \lyricmode {
  "*Kum" ba yah, my Lord, kum ba yah.
  Kum ba yah, my Lord, kum ba yah.
  Kum ba yah, my Lord, kum ba yah.
  Oh, Lord, kum ba yah!
}
verseB = \lyricmode {
  Some -- one's sing -- ing, Lord, kum ba yah.
  Some -- one's sing -- ing, Lord, kum ba yah.
  Some -- one's sing -- ing, Lord, kum ba yah.
  Oh, Lord, kum ba yah!
}
verseC = \lyricmode {
  Some -- one's laugh -- ing, Lord, kum ba yah.
  Some -- one's laugh -- ing, Lord, kum ba yah.
  Some -- one's laugh -- ing, Lord, kum ba yah.
  Oh, Lord, kum ba yah!
}
verseD = \lyricmode {
  Some -- one's weep -- ing, Lord, kum ba yah.
  Some -- one's weep -- ing, Lord, kum ba yah.
  Some -- one's weep -- ing, Lord, kum ba yah.
  Oh, Lord, kum ba yah!
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"