\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Ralph Vaughan Williams, 1911"
meter = \smallText "THE CALL 77.77"
hymnKey = \key ef \major
hymnTime = \time 6/4
quarternoteTempo = 130
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Come, my Way, my Truth, my Light"
poet = \smallText "Text: George Herbert, 1633"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english secular 5part"
dateAdded = "2021-01-16"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 2. ef2 g4 | bf2 4 c4( bf) af | bf2. \bar "" } \break
  \relative g' { \partial 2. ef2 g4 | bf2 4 c4( bf) af | bf2. \bar "" } \break
  \relative g' { \partial 2. <df' bf>2 4 | <c af>2 4 <bf f>2 af4 | bf2. \bar "" } \break
  \relative g' { \partial 2. af2 4 | g2 4 f4( g af | g4 f ef f2) 4 | ef1. } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { ef2 g4 | df2 4  ef2 4 | ef2( df4) }
  \relative e' { ef2 g4 | df2 4  ef2 4 | ef2( df4) }
  \relative e' { gf2 f4 | f2 ef4 ef( df) c | ef2. }
  \relative e' { f2 4 | ef2 4 c2.~ | 2. df2 c4 | bf1.}
}
tenor = {
  \globalParts
  \relative a { ef2 g4 | f2 4 af2 4 | f2. }
  \relative a { ef2 g4 | f2 4 af2 4 | f2. }
  \relative a { bf2 4 | c2 4 f,2 4 | g2. }
  \relative a { df2 c4 | bf2 4 af2.~( | 2. bf2) 4 | af2.( g2.) }
}
bass = {
  \globalParts
  \relative d { ef2 g4 | bf,2 4 af2 4 | bf2. }
  \relative d { ef2 g4 | bf,2 4 af2 4 | bf2. }
  \relative d { gf,2 4 | af2 4 bf2 f'4 | ef2. }
  \relative d { df2 4 | ef2 4 f2.~( | 2. bf,2) 4 | ef1. }
  \relative d {}
}


%% LYRICS
verseA = \lyricmode {
  Come, my Way, my Truth, my Life:
  such a way as gives me breath;
  such a truth as ends all strife;
  such a life as kill -- eth death.
}
verseB = \lyricmode {
  Come, my Light, my Feast, my Strength:
  such a light as shows a feast;
  such a feast as mends in length;
  such a strength as makes __ his guest.
}
verseC = \lyricmode {
  Come my Joy, my Love, my Heart:
  such a joy as none can move;
  such a love as none can part;
  such a heart as joys __ in love.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
