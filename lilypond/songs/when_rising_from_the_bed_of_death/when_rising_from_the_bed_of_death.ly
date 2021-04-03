\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Thomas Tallis, 1568"
meter = \smallText "THIRD MODE MELODY CMD"
hymnKey = \key e \phrygian
hymnTime = \time 3/2
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "When rising from the bed of death"
poet = \smallText "Text: Joseph Addison, 1672-1719"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-04-03"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 2 r4 e4 | g4 4 2. 4 | a a b2. 4 | 2. 4 4 c | b1 \bar "" \break
    \partial 2 r4 e,4 | b' b b2. g4 | a a b2. 4 | 2. 4 c a | b1 \bar "" \break
    \partial 2 r4 b4 | b4. c8( d4) e2 d4 | c c b2. g4 | a2. e4 f f | e1 \bar "" \break
    \partial 2 r4 a4 | c4. b8( a4) g2 e4 | a4. g8( f4) e2 g4 | f2 d e4 4 | \partial 1 1
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    r4 e4 | 4 4 2. 4 | c d b2. e4 | 2. ds4 e e | 1
    r4 e4 | 4 4 2. 4 | 4 d b2. e4 | 2. 4 4 c | e1
    r4 e4 | e( g) f e2 g4 | e e e2. 4 | 2. 4 4 d | e1
    r4 c4 | 2 4 2 4 | 2 4 2 4 | 2 d c4 4 | b1
  }
}
tenor = {
  \globalParts
  \relative a {
    r4 b4 | 4 4 2. 4 | a a gs2. 4 | 2. fs4 gs a | gs1
    r4 g4 | 4 4 2. b4 | a a gs2. 4 | 2. 4 a a | gs1
    r4 g4 | 4. a8( b4) c2 b4 | a a g2. b4 | c2. a4 4 4 | 1
    r4 e4 | a4. g8( f4) e2 g4 | c4. b8( a4) g2 e4 | a2 2 4 e8( fs) | gs1
  }
}
bass = {
  \globalParts
  \relative d {
    r4 e4 | 4 4 2. g4 | f f e2. 4 | 2. b4 e a, | e'1
    r4 e4 | 4 4 2. g4 | f f e2. 4 | 2. 4 a, a | e'1
    r4 e4 | 2 d4 c2 g4 | a a e2. 4 | a2. c4 d d | a1
    r4 a4 | 2 4 c2 4 | a f2 c'2 4 | f,2 2 a4 4 | <e e'>1
  }
}
songChords = \chords {
  \globalChordSymbols
  s4 e4:m | e1.:m | f2 e e e2. b4 e2 e e
  s4 e4:m | e1.:m | d2:m e e e1 a2:m e2 e
  s4 e4:m | e2.:m c | a2:m e1:m a:m d2:m a1.:m |
  a2.:m c f c f2 d:m a:m e

}

%% LYRICS
verseA = \lyricmode {
  \l When, ris -- ing from the bed of death,
  o’er -- whelmed with guilt and fear,
  I view my Ma -- ker face to face,
  O how shall I ap -- pear?
  If yet, while par -- don may be found,
  and mer -- cy may be sought,
  my heart with in -- ward hor -- ror shrinks,
  and trem -- bles at the thought.
}
verseB = \lyricmode {
  When thou, O Lord, shalt stand dis -- closed
  in ma -- jest -- y se -- vere,
  and sit in judge -- ment on my soul,
  O how shall I ap -- pear?
  But thou hast told the trou -- bled mind
  who does her sins la -- ment,
  the time -- ly tri -- bute of her tears,
  shall end -- less woe pre -- vent.
}
verseC = \lyricmode {
  Then see the sor -- row of my heart,
  Ere yet it be too late;
  And hear my Sav -- iour’s dy -- ing groans,
  To give those sor -- rows weight.
  For ne -- ver shall my soul des -- pair
  Her par -- don to pro -- cure,
  Who knows thine on -- ly Son has died
  To make her par -- don sure.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ly"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output. Change to the correct number
\include "../../lib/slides_book_3verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
