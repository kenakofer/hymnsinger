\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: George J. Elvey, 1858"
meter = \smallText "ST. GEORGE'S WINDSOR 77.77 D"
hymnKey = \key g \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Come, ye thankful people"
poet = \smallText "Text: Henry Alford, 1844"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english theist 4part autumn"
dateAdded = "2021-02-12"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { b4. 8 d4 b | g a b2 | b4. 8 d4 b | g a b2 | } \break
  \relative g' { b4. 8 c4 c | a4. 8 b2 | b4 cs d g, | fs e d2 | } \break
  \relative g' { fs4. 8 a4 fs | g a b2 | b4. 8 d4 b | c d e2 | } \break
  \relative g' { e'4. 8 c4 a | d4. 8 b2 | c4 e d g, | b a g2 | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4. 8 d4 d | e fs g2 | d4. 8 4 4 | e e ds2 | }
  \relative e' { e4. 8 4 4 | d d d2 | d4 e d e | d cs d2 | }
  \relative e' { d4. 8 4 4 | d c b2 | d4. 8 g4 g | g f e2 | }
  \relative e' { e4 gs a e | d fs g2 | g4 g g g | g fs g2 | }
}
tenor = {
  \globalParts
  \relative a { g4. 8 a4 b | b d d2 | g,4. 8 a4 g | b c fs,2 | }
  \relative a { g4. 8 a4 a | fs fs g2 | g4 g a b | a4. g8 fs2 | }
  \relative a { a4. 8 fs4 a | g4. fs8 g2 | g4. 8 b4 d | c4. b8 c2 | }
  \relative a { b4 e e c | a d d2 | c4 c d b | d4. c8 b2 |}
}
bass = {
  \globalParts
  \relative d { g4. 8 fs4 g | e d g2 | g4. 8 fs4 g | e c b2 | }
  \relative d { e4. 8 a,4 4 | d d g,2 | g'4 e fs g | a4 a, d2 | }
  \relative d { d4. 8 4 c4 | b a g2 | g4. 8 g'4 f | e d c2 | }
  \relative d { gs4 e a4. 8 | fs4 d g2 | e4 c b e | d d g,2 | }
}

%% LYRICS
verseA = \lyricmode {
  \l Come, ye thank -- ful peo -- ple, come, raise a song of har -- vest home:
  \l fruit and crops are gath -- ered in, safe be -- fore the storms be -- gin;
  \l God, our Mak -- er, will pro -- vide for our needs to be sup -- plied;
  \l come to God's own tem -- ple, come, raise a song of har -- vest home.
}
verseB = \lyricmode {
  All the world is but a field, giv -- en for a fruit -- ful yield;
  wheat and tares to -- geth -- er sown, here for joy or sor -- row grown:
  first the blade, and then the ear, then the full corn shall ap -- pear;
  God of har -- vest, grant that we whole -- some grain and pure may be.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
