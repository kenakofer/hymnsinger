\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: American traditional, Southern Harmony, 1835"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "BOUND FOR THE PROMISED LAND CM with refrain"
hymnKey = \key e \minor
hymnTime = \time 2/2
quarternoteTempo = 110
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "On Jordan's Stormy Banks"
subtitle = \smallText "For the major tune, see PROMISED LAND"
poet = \smallText "Text: Samuel Stennett, 1787"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-04-23"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 2 e2 | g4 4 8( a) b4 | a a a fs | g4 4 8( a) b4 | fs2 \bar "" \break
    g4.( fs8) | e4 8( fs) g4 a | b e b4 8( a) | g4 8( e) fs4 4 | e2 \bar "||" \break
    e4.( fs8) | g4 8 fs g( a) b4 | a4.( b8 a g ) fs4 | g4 8 fs g( a) b4 | fs2 \bar "" \break
    g4.( fs8) | e4 8( fs) g4 a | b e b4 8( a) | g4 8 e fs4 4 | e2 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    e2 | e4 4 4 4 | 4 c d ds | e4 4 4 4 | ds2
    e4.( ds!8) | e4 b4 c d | e e e c | e4 4 ds ds | b2
    e4.( ds8) | e4 4 4 g | e4.( g8 fs e) ds4 | e4 8[ 8] 4 4 | ds2
    e4.( ds!8) | e4 b e fs | e e8( fs) g4 e | e4 8[ 8] ds4 ds | e2
  }
}
tenor = {
  \globalParts
  \relative a {
    b2 | b4 4 8( a) g4 | c4 e d b | b4 4 4 g8( a) | b2
    b2 | b4 g4 4 fs | e g c8( b) a4 | b g8( a) b4 b | g2
    b2 | b4 8 8 4 4 | c4.( b8 c b) a4 | b4 8 8 4 g8( a) | b2
    b2 | b4 g4 4 fs | g c c8( b) a4 | b4 g8 a b4 b | b2
  }
}
bass = {
  \globalParts
  \relative d {
    e2 | e4 e e e | a, a a b | e e e e | b2
    b2 | e4 e e d | c c c a | b4 4 4 4 | e2
    b2 | e4 8 8 4 4 | a,4( c e4) b4 | e4 8 8 4 e | b2
    b2 | e4 e e d | c c c a | b4 8 8 4 4 | e2
  }
}
songChords = \chords {
  \globalChordSymbols
  e2:m | e1:m a2.:m b4 e1:m | b2
  e4.:m b8 | e2.:m d4 | c1:maj7 | e2:m b | e2:m
  e4.:m b8 | e1:m a2.:m b4:7 e1:m | b2
  e4.:m b8 | e2.:m d4 | c1:maj7 | e2:m b | e2:m
}

%% LYRICS
verseA = \lyricmode {
  \l On Jor -- dan's storm -- y banks I stand and cast a wish -- ful eye
  \l to Ca -- naan's fair and hap -- py land where my pos -- ses -- sions lie.
  %% CHORUS
  I'm bound for the prom -- ised land, I'm bound for the prom -- ised land;
  O who will come and go with me? I'm bound for the prom -- ised land.
}
verseB = \lyricmode {
  There gen -- 'rous fruits that nev -- er fail on trees im -- mor -- tal grow.
  There rocks and hills and brooks and vales with milk and hon -- ey flow.
  \SB {
    %% CHORUS
    I'm bound for the prom -- ised land, I'm bound for the prom -- ised land;
    O who will come and go with me? I'm bound for the prom -- ised land.
  }
}
verseC = \lyricmode {
  All o'er those wide ex -- tend -- ed plains shines one e -- tern -- nal day.
  There God the sun for -- ev -- er reigns, and scat -- ters night a -- way.
  \SC {
    %% CHORUS
    I'm bound for the prom -- ised land, I'm bound for the prom -- ised land;
    O who will come and go with me? I'm bound for the prom -- ised land.
  }
}
verseD = \lyricmode {
  Filled with de -- light, my rap -- tured soul can here no long -- er stay.
  Though Jor -- dan's waves a -- round me roll, fear -- less I'd launch a -- way.
  \SD {
    %% CHORUS
    I'm bound for the prom -- ised land, I'm bound for the prom -- ised land;
    O who will come and go with me? I'm bound for the prom -- ised land.
  }
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