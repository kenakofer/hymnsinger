\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Johann G. Nägeli, 1828; arr. Lowell Mason, 1845"
%arranger = \smallText "arr. (optional), year"
meter = \smallText "DENNIS SM"
hymnKey = \key f \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Blest be the tie that binds"
%subtitle = \smallText "Optional"
poet = \smallText "Text: John Fawcett, 1782, alt."
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-03-09"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 a4 | a( f) a | g( e) g | f2 4 | f( d) f | f( c) f | \partial 2 e2 \bar "" } \break
  \relative g' { \partial 4 g4 | g( e) g | f( a) c | c( g) bf | a( c) d | c( a) bf | a( f) g | \partial 2 f2 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f( c) f | e( c) e | c2 ef4 | d( bf) d | c( a) c | c2 }
  \relative e' { e4 | e( c) e | f2 4 | e2 4 | f2 4 | 2 4 | 2 e4 | c2 }
}
tenor = {
  \globalParts
  \relative a { c4 | c4( a) c | c( g) bf | a2 4 | bf( f) bf | a( f) a | g2 }
  \relative a { c4 | c( g) bf | a( c) a | g( c) c | c( a) bf | a( c) d | c( a) bf | a2 | }
}
bass = {
  \globalParts
  \relative d { f4 | 2 4 | c2 4 | f2 4 | bf,2 4 | f'2 4 | c2}
  \relative d { c4 | 2 4 | f2 4 | c2 4 | f2 4 | 2 bf,4 | c2 4 | f,2 |}
}
songChords = \chords {
  \globalChordSymbols
  s4 f2. c:7 f4 4 f:7 bf2. f c
  c2 c4:7 f2. c2 c4:7 f2 bf4/f f2 bf4 f2/c c4:7 f2
}

%% LYRICS
verseA = \lyricmode {
  \l Blest be the tie that binds our hearts in Chris -- tian love.
  \l The fel -- low -- ship of kin -- dred minds is like to that a -- bove.
}
verseB = \lyricmode {
  We share each oth -- er's woes, each oth -- er's bur -- dens bear,
  and of -- ten for each oth -- er flows the sym -- pa -- thiz -- ing tear.
}
verseC = \lyricmode {
  When we a -- sun -- der part, it gives us in -- ward pain,
  but we shall still be joined in heart, and hope to meet a -- gain.
}
verseD = \lyricmode {
  From sor -- row, toil, and pain, and sin we shall be free,
  and per -- fect love and friend -- ship reign through all e -- ter -- ni -- ty.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
