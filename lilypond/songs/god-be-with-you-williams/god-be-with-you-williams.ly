\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Ralph Vaughan Williams, 1906"
meter = \smallText "RANDOLPH 98.89"
hymnKey = \key d \major
hymnTime = \time 4/2
quarternoteTempo = 170
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "God be with you till we meet again"
poet = \smallText "Text: Jeremiah E. Rankin, 1880, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-05-15"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    fs2 a b4 a g fs | e2. d4 1 | fs2 gs a2. 4 | b2 cs4( d) 2 cs | \break
    d2. cs4 b2 a | g a4( b) a2 g | fs a b4 a g fs | e2. d4 1 | \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d2 2 4 4 4 4 | 2 cs d1 | d2 e e cs | fs e e e |
    d2. 4 2 2 e e e cs | d c b4 4 4 4 | d2 cs a1 |
  }
}
tenor = {
  \globalParts
  \relative a {
    a2 a b4 4 4 4 | e,2 g fs1 | a2 b a a | a gs a a |
    a2. 4 b2 2 | b g a a | a a g4 4 4 4 | a2 g fs1 |
  }
}
bass = {
  \globalParts
  \relative d {
    d2 fs g4 4 e e | a,2 2 d1 | 2 2 cs fs | d e a a4( g) |
    fs2. 4 g2 fs | e d cs a | d fs g4 4 e e | a,2 2 d1 |
  }
}

%% LYRICS
verseA = \lyricmode {
  \l God be with you till we meet a -- gain;
  lov -- ing coun -- sels guide, up -- hold you,
  \l may the Shep -- herd's care en -- fold you;
  God be with you till we meet a -- gain.
}
verseB = \lyricmode {
  God be with you till we meet a -- gain;
  un -- seen wings, pro -- tect -- ing, hide you,
  dai -- ly man -- na still pro -- vide you;
  God be with you till we meet a -- gain.
}
verseC = \lyricmode {
  God be with you till we meet a -- gain;
  when life's per -- ils thick con -- found you,
  put un -- fail -- ing arms a -- round you;
  God be with you till we meet a -- gain.
}
verseD = \lyricmode {
  God be with you till we meet a -- gain;
  keep love's ban -- ner float -- ing o'er you,
  smite death's threat -- 'ning wave be -- fore you;
  God be with you till we meet a -- gain.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"