\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
composer = \smallText "Music: John Wyeth, 1813"
meter = \smallText "CONSOLATION (MORNING SONG) CM"
hymnKey = \key f \minor
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global_parts.ily"

%% SONG INFO
title = \titleText "I walk the unfrequented road"
poet = \smallText "Text: Frederick Lucian Hosmer, 1913"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english secular 4part autumn"
dateAdded = "2021-01-31"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \stemUp
  \relative g' { \partial 4 c,4 | f g af bf8( af) | \partial 2. g4 f8( ef) c4 }
  \relative g' { \partial 4 c,4 | f g af bf | \partial 2. c2. \bar "" } \break
  \relative g' { \partial 4 af8( bf) | c4 df8( c) bf4 af | \partial 2. g4 f8( ef) c4 }
  \relative g' { \partial 4 c,4 | f g af8( f) g4 | \partial 2. f2. } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c4 | c c c df | ef c af c | bf ef c ef | ef2. }
  \relative e' { ef4 | ef df f df | bf c c c | c ef c c | af2. }
}
tenor = {
  \globalParts
  \relative a { c,4 | c'4 bf af f | ef g af g | f c' af g | af2. | }
  \relative a { af4 | af f f f | ef8( f) g4 af af8( bf) | c4 bf af ef | f2. }
}
bass = {
  \globalParts
  \relative d { c4 | af'4 g f bf, | c c f ef | df c f ef | af,2. | }
  \relative d { c8( bf) | af4 bf8( c) df4 bf | ef c f f8( g) af4 ef af, c | f,2. |}
}


%% LYRICS
verseA = \lyricmode {
  \l I walk the un -- fre -- quent -- ed road
  \l with o -- pen eye and ear;
  \l I watch a -- field the farm -- er load
  \l the boun -- ty of the year.
}
verseB = \lyricmode {
  I filch the fruit of no one's toil—
  no tres -- pass -- er am I—
  and yet I reap from ev -- ery soil
  and from the bound -- less sky
}
verseC = \lyricmode {
  I gath -- er where I did not sow,
  and bind the mys -- tic sheaf,
  the am -- ber air, the riv -- er's flow,
  the rus -- tle of the leaf.
}
verseD = \lyricmode {
  A beau -- ty spring -- time nev -- er knew
  haunts all the qui -- et ways,
  and sweet -- er shines the land -- scape through
  its veil of aut -- umn haze.
}
verseE = \lyricmode {
  I face the hills, the streams, the wood,
  and feel with all a -- kin;
  my heart ex -- pands; their for -- ti -- tude
  and peace and joy flow in.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/5verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output
\include "../../lib/slides_book_5verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"