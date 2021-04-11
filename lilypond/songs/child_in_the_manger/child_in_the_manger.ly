\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
%% Otherwise set up tune info here:
composer = \smallText "Music: L. Macbean, 1888"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "BUNESSAN 55.53"
hymnKey = \key d \major
hymnTime = \time 9/8
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/8)
hymnBeatStructure = \set Timing.beatStructure = 3,3,3
quarternoteTempo = 70
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Child in the manger"
poet = \smallText "Text: Mary MacDonald; tr. L. Macbean, 1888"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian winter 4part"
dateAdded = "2021-04-11"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \transpose c d {
    \relative g' {
      \partial 4. c,8 e g | c4. d b8 a g | a4. g c,8 d e | g4. a g8[( e) c] | d2. \bar "" \break
      \partial 4. g8 e g | c4. a g8[ e c] | c4. d e8 d e | g4. a d,8([ e) d] | \partial 2. c2.
      \bar "|."
    }
  }
}
alto = {
  \globalParts
  \transpose c d {
    \relative e' {
      c8 e g | e4. f d8 d d | f4. e c8 d e | e4. c d8( c) c | b2.
      c8 c e | e4. e4( d8) c8 8 8 | a4. a c8 b c | b4. c d8( b) b | c2.
    }
  }
}
tenor = {
  \globalParts
  \transpose c d {
    \relative a {
      c,8 e g | c4. a b8 c b | c4. c c8 c c | c4( b8) a4. b8[( g) a] | g2.
      e8 g b | a4. a e8 g g | e4. fs4. g8 g g | b4. a a8[( g) g] | e2.
    }
  }
}
bass = {
  \globalParts
  \transpose c d {
    \relative d {
      c8 e g | g4. f g8 8 8 | f4. c4. g8 g g | e4. f g4 g8 | g2.
      c8 c e | a4( g8) f4. c8 e e | e4. d c8 g e | e4. a g4 g8 | c2.
    }
  }
}
songChords = \chords {
  \globalChordSymbols
  \transpose c d {
    c4. c d:m/f g f c c c/e f c/g g g
    c a:m7 d:m c a:m d c e:m a:m d8/g g4 c2.
  }
}

%% LYRICS
verseA = \lyricmode {
  \l Child in the man -- ger, in -- fant of Mar -- y,
  out -- cast and strang -- er, Lord of all!
  \l Child who in -- her -- its all our trans -- gres -- sions,
  all our de -- mer -- its on him fall.
}
verseB = \lyricmode {
  Mon -- archs have ten -- der, del -- i -- cate chil -- dren
  nour -- ished in splen -- dor, day by day;
  death soon shall ban -- ish hon -- or and beau -- ty;
  plea -- sure shall van -- ish, forms de -- cay.
}
verseC = \lyricmode {
  But the most ho -- ly Child of sal -- va -- tion
  gent -- ly and low -- ly lived be -- low;
  now as our glo -- rious might -- y Re -- deem -- er,
  see him vic -- to -- rious o'er each foe.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ly"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output. Change to the correct number
\include "../../lib/slides_book_3verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"