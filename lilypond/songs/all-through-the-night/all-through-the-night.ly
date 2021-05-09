\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Musical and Poetical Relics of the Welsh Bards, 1784"
meter = \smallText "AR HYD Y NOS 12.12.8.8.12"
hymnKey = \key g \major
hymnTime = \time 2/2
quarternoteTempo = 100
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "All through the night"
poet = \smallText "Text: Harold Boulton, 1884"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english secular evening 4part"
dateAdded = "2021-05-09"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    g4. fs8 e4 g | a4. g8 fs4 d | e2 fs4. 8 | g1 | \break
    g4. fs8 e4 g | a4. g8 fs4 d | e2 fs4. 8 | g1 | \break
    c4 b c d | e4. d8 c4 b | c b a g | b4. a8 g4 fs | \break
    g4. fs8 e4 g | a4. g8 fs4 d | e2 fs4. 8 | g1 |
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    b4. d8 c4 d | cs4. e8 d4 d | c2 a4 c | b1 |
    b4. d8 c4 d | cs4. e8 d4 d | c2 a4 c | b1 |
    g'4 4 4 4 | 4. 8 4 4 | e4 4 4 4 | d4. 8 4 4 |
    b4. d8 c4 d | cs4. e8 d4 d | c2 a4 c | b1 |
  }
}
tenor = {
  \globalParts
  \relative a {
    g4. 8 4 4 | a4. 8 4 fs | g2 fs4. a8 | g1 |
    g4. 8 4 4 | a4. 8 4 fs | g2 fs4. a8 | g1 |
    e'4 d c b | c4. d8 a4 g | a gs a a | g4. c8 b4 a |
    g4. 8 4 4 | a4. 8 4 fs | g2 fs4. a8 | g1 |
  }
}
bass = {
  \globalParts
  \relative d {
    g,4 b c b | a cs d d | c2 d4. 8 | <d g,>1 |
    g,4 b c b | a cs d d | c2 d4. 8 | <d g,>1 |
    \pa r1 | r1 \pt | a4 b c cs | d4. 8 4 4 |
    g,4 b c b | a cs d d | c2 d4. 8 | <d g,>1 |
  }
}
songChords = \chords {
  \globalChordSymbols
  g2 c a d c d:7 g g
  g2 c a d c d:7 g g
  c2 c c c a:m a:m g2./d d4
  g2 c a d c d:7 g g

}

%% LYRICS
verseA = \lyricmode {
  \l Sleep, my child, and peace at -- tend thee
  all through the night.
  \l Guard -- ian an -- gels God will send thee
  all through the night.
  \l Soft the drow -- sy hours are creep -- ing,
  hill and vale in slum -- ber sleep -- ing,
  I my lov -- ing vi -- gil keep -- ing,
  all through the night.
}
verseB = \lyricmode {
  While the moon her watch is keep -- ing
  all through the night.
  While the wear -- y world is sleep -- ing
  all through the night.
  O'er thy spir -- it gent -- ly steal -- ing,
  vi -- sions of de -- light re -- veal -- ing,
  breaths a pure and ho -- ly feel -- ing,
  all through the night.
}
verseC = \lyricmode {
  Deep the sil -- ence round us spread -- ing,
  all through the night.
  Dark the path that we are tread -- ing,
  all through the night.
  Still the com -- ing day dis -- cern -- ing,
  by the hope with -- in us burn -- ing,
  to the dawn our fott -- steps turn -- ing
  all through the night.
}
verseD = \lyricmode {
  Star of faith the dark a -- dorn -- ing,
  all through the night.
  Leads us fear -- less toward the morn -- ing,
  all through the night.
  Though our hearts be wrapped in sor -- row,
  from the home of dawn we bor -- row,
  prom -- ise of a new to -- mor -- row,
  all through the night.
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