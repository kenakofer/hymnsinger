\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: John Goss, 1869"
meter = \smallText "LAUDA ANIMA 87.87.87"
hymnKey = \key d \major
hymnTime = \time 2/4
quarternoteTempo = 106
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Praise, my soul, the King of heaven"
poet = \smallText "Text: Henry Francis Lyte (1834)"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-05-10"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    a4 a a a | d cs b2 | a | g4 fs | b a | \break
    fs g e2 | fs4 4 4 4 | b a a gs | \break
    a b cs d | fs, gs | a2 | d4 cs | b a | \break
    d4 cs b a | b a g e | d cs d2 | \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d4 4 cs cs | d a' a( g) | fs2 | d4 4 4 cs |
    d e cs2 | cs4 e d cs | b b d d |
    cs e e d | d d cs2 | d4. 8 4 cs |
    d4 e8( fs) | g4 4 | fs e d b | a a a2
  }
}
tenor = {
  \globalParts
  \relative a {
    fs4 4 g g | a a b( cs) | d2 | 4 a g e |
    d b' | a( g) | fs cs d e | fs b b b |
    a gs a a | b b a2 | a4. 8 g4 4 |
    fs4 e8( d) e4 a | d cs b g | fs e8( g) fs2 |
  }
}
bass = {
  \globalParts
  \relative d {
    d4 4 e e | fs4 4 g2 | d2 | b4 d g, a |
    b <e e,> a,2 | as4 4 b cs | d ds e es |
    fs e a fs | d e a,2 | fs4. 8 g4 a |
    b4. 8 cs4 4 | d4 e8( fs) | g4 g, | a a d2 |
  }
}
songChords = \chords {
  \globalChordSymbols
  d2 a d4 a g2 d g4 d g a
  b:m e:m a2 fs b2.:m b4:7 e4:sus7 f:dim7
  fs:m e a d b:m e a2 d g4 a
  b2:m a:7 b4:m a g e:m d a d2
}

%% LYRICS
verseA = \lyricmode {
  \l Praise, my soul, the King of heav -- en:
  to his feet your \l tri -- bute bring.
  Ran -- somed, healed, re -- stored, for -- giv -- en,
  \l ev -- er -- more his prais -- es sing.
  Al -- le -- lu -- ia, \l al -- le -- lu -- ia!
  Praise the ev -- er -- last -- ing King!
}
verseB = \lyricmode {
  Praise him for his grace and fa -- vor
  to his peo -- ple in dis -- tress.
  Praise him, still the same as ev -- er,
  slow to chide, and swift to bless.
  Al -- le -- lu -- ia, al -- le -- lu -- ia!
  Glo -- rious in his faith -- ful -- ness!
}
verseC = \lyricmode {
  Fath -- er -- like he tends and spares us;
  well our fee -- ble frame he knows.
  In his hand he gent -- ly bears us,
  res -- cues us from all our foes.
  Al -- le -- lu -- ia, al -- le -- lu -- ia!
  Wide -- ly yet his mer -- cy flows!
}
verseD = \lyricmode {
  An -- gels, help us to a -- dore him;
  you be -- hold him face to face.
  Sun and moon, bow down be -- fore him,
  dwell -- ers all in time and space.
  Al -- le -- lu -- ia, al -- le -- lu -- ia!
  Praise with us the God of grace!
}
verseE = \lyricmode { }
verseF = \lyricmode { }

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