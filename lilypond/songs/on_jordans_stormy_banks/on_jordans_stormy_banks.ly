\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
composer = \smallText "Music: "
%arranger = \smallText "arr. Name, year"
meter = \smallText "PROMISED LAND CM with refrain"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ily"

%% SONG INFO
title = \titleText "On Jordan's Stormy Banks"
subtitle = \smallText "For the minor tune, see BOUND FOR THE PROMISED LAND"
poet = \smallText "Text: Samuel Stennett, 1787"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-04-21"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 f8( g) | a4 a4 8( bf) c4 | bf bf4 8( a) g4 | a4 4 8( bf) c4 | g2. \bar "" \break
    a8( g) | f4 8( g) a4 bf | c f c4 8( bf) | a4 8( f) g4 g | f2. \bar "||" \break
    f8( g) | a4 8. 16 a8( bf) c4 | bf4.( c8 bf a) g4 | a4 8. 16 8( bf) c4 | g2. \bar "" \break
    a8( g) | f4 8( g) a4 bf | c4 f c c8( bf) | a4 a8( f) g4 4 | f2. \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    f4 | 4 4 8( g) a4 | g4 4 8( f) e4 | f4 4 4 4 | e2.
    e4 | f f f g | a a a f | f f e e | c2.
    f4 | 4 8. 16 8( g) a4 | g4.( a8 g f) e4 | f4 8. 16 4 4 | e2.
    e4 | f f f g | a a a f | f4 8 8 e4 4 | c2.
  }
}
tenor = {
  \globalParts
  \relative a {
    a8( bf) | c4 4 4 4 | 4 4 4 4 | 4 4 4 4 | 2.
    c8( bf) | a4 8( bf) c4 4 | 4 4 4 8( d) | c4 c8( a) c4 bf | a2.
    a8( bf) | c4 8. 16 4 4 | 2. 4 | 4 8. 16 4 4 | 2.
    c8( bf) | a4 8( bf) c4 4 | 4 4 4 f8( d) | c4 8( a) c4 bf | a2.
  }
}
bass = {
  \globalParts
  \relative d {
    f4 | 4 4 4 4 | c c c c | f f f a, | c2.
    c4 | f f f f | f f f a,8( bf) | c4 4 4 4 | f2.
    f4 | 4 8. 16 4 4 | c2. 4 | f4 8. 16 4 a, | c2.
    c4 | f4 4 4 4 | 4 4 4 a,8( bf) | c4 8 8 4 4 | f2.
  }
}

%% LYRICS
verseA = \lyricmode {
  \l On Jor -- dan's storm -- y banks I stand and cast a wish -- ful eye
  \l to Ca -- naan's fair and hap -- py land where my pos -- ses -- sions lie.
  %% CHORUS
  I'm bound for the prom -- ised land, I'm bound for the prom -- ised land;
  O who will come and go with me? I'm for the prom -- ised land.
}
verseB = \lyricmode {
  All o'er those wide ex -- tend -- ed plains shines one e -- ter -- nal day;
  there God the Son for -- ev -- er reigns and scat -- ters night a -- way.
  \SB {
    %% CHORUS
    I'm bound for the prom -- ised land, I'm bound for the prom -- ised land;
    O who will come and go with me? I'm for the prom -- ised land.
  }
}
verseC = \lyricmode {
  No chill -- ing winds nor pois -- onous breath can reach that health -- ful shore;
  sick -- ness and sor -- row, pain and death are felt and feared no more.
  \SC {
    %% CHORUS
    I'm bound for the prom -- ised land, I'm bound for the prom -- ised land;
    O who will come and go with me? I'm for the prom -- ised land.
  }
}
verseD = \lyricmode {
  When shall I reach that hap -- py place and be for -- ev -- er blest?
  When shall I see my Fa -- ther's face and in God's bo -- som rest?
  \SD {
    %% CHORUS
    I'm bound for the prom -- ised land, I'm bound for the prom -- ised land;
    O who will come and go with me? I'm for the prom -- ised land.
  }
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides_book_4verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"