\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: The CL. Psalmes of David, 1615"
%arranger = \smallText "arr. (optional), year"
meter = \smallText "DUNDEE CM"
hymnKey = \key d \major
hymnTime = \time 4/4
quarternoteTempo = 80
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "I to the hills will lift my eyes"
%subtitle = \smallText "Optional"
poet = \smallText "Text: The New Metrical Version of the Psalms, 1912, alt."
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-03-13"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 d4 | fs g a d, | e fs g fs | e d d cs | d2. \bar "" } \break
  \relative g' { \partial 4 a4 | d cs b a | a gs a fs | e d d cs | d2. } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { a,4 | d d d b | cs d d d | cs b b a | a2. }
  \relative e' { d4 | fs e d cs | b b cs a | b b a4 a | a2. }
}
tenor = {
  \globalParts
  \relative a { fs4 | a b a fs | a a b a | a fs g e | fs2. }
  \relative a { fs4 | a a fs e | fs e e fs | g d e e | fs2. }
}
bass = {
  \globalParts
  \relative d { d4 | d g, fs b | a d g, d' | a b g a | d2. }
  \relative d { d4 | d a b cs | d e a, d | g, fs8( g) a4 a | d2. }
}
songChords = \chords {
  \globalChordSymbols
  d4 | d2 d a g b:m g4 a d2
  d2 d d e a g a d
}

%% LYRICS
verseA = \lyricmode {
  \l I to the hills will lift my eyes. From whence shall come my aid?
  \l My help is from the Lord a -- lone, who heav'n and earth has made.
}
verseB = \lyricmode {
  God will not let your foot be moved, your guar -- dian nev -- er sleeps.
  God's watch -- ful and un -- slum -- b'ring care pro -- tects and safe -- ly keeps.
}
verseC = \lyricmode {
  Your faith -- ful keep -- er is the Lord, your shelt -- er and your shade.
  'Neath sun or moon, by day or night, you shall not be a -- fraid.
}
verseD = \lyricmode {
  From e -- vil God will keep you safe, pro -- vide for all you need.
  Your go -- ing out, your com -- ing in, God will for -- ev -- er lead.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
