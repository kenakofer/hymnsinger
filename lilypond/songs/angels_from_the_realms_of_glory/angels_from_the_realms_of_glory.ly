\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
composer = \smallText "Music: Henry Smart, 1867"
meter = \smallText "REGENT SQUARE 87.87"
hymnKey = \key bf \major
hymnTime = \time 4/4
quarternoteTempo = 110
\include "../../lib/global_parts.ily"

%% SONG INFO
title = \titleText "Angels, from the realms of glory"
poet = \smallText "Text: James Montgomery, 1816"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian winter 4part"
dateAdded = "2021-04-03"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \transpose g f {
    \relative g' {
      g4 e c' g | e'4. d8 c4 g | a a g c | g f e2 | \break
      g4 e c' g | e'4. d8 c4 b | c b a b8( c) | b4 a g2 | \break
      d'4. 8 b4 g | e'4. d8 c4 a | f' e d c | c b c2 |
      \bar "|."
    }
  }
}

alto = {
  \globalParts
  \transpose g f {
    \relative e' {
      e4 c g' e | g4. 8 4 4 | c, c c c | d b c2 |
      e4 c g' g8( f) | e4. f8 e4 e | e e e e | g fs g2 |
      g4. 8 4 4 | g4. e8 f4 f | a g f e8( f) | g4. f8 e2 |
    }
  }
}
tenor = {
  \globalParts
  \transpose g f {
    \relative a {
      c4 g g c | 4. b8 c4 4 | a c g a | g g g2 |
      c4 c g g | c4. b8 a4 gs | a gs e' d8( c) | d4 c b2 |
      b4. 8 d4 b | c4. bf8 a4 c | d g, a8( b) c4 | d d c2 |
    }
  }
}
bass = {
  \globalParts
  \transpose g f {
    \relative d {
      c4 c e c | g'4. f8 e4 e | f f e a, | b g c2 |
      c'4 g e e8( d) | c4. d8 e4 e | a e c a | d d g,2 |
      g'4. 8 4 4 | c,4. 8 f4 f | d e f4 a4 | g g, c2 |
    }
  }
}
songChords = \chords {
  \globalChordSymbols
  \transpose g f {
    c2 c c c f c f:7 c
    c c c a4:m e a1:m g4/d d:7 g2
    g2 g c:7 f d1:m7 g4:sus g:7 c
  }
}

%% LYRICS
verseA = \lyricmode {
  \l An -- gels from the realms of glo -- ry,
  wing your flight o'er all the earth.
  \l As you sang cre -- a -- tion's sto -- ry,
  now pro -- claim Mes -- si -- ah's birth;
  %% CHORUS
  come and wor -- ship, come and wor -- ship,
  wor -- ship Christ the new -- born King.
}
verseB = \lyricmode {
  Shep -- herds, in the field a -- bid -- ing,
  watch -- ing o'er your flocks by night,
  God with us is now re -- sid -- ing,
  yon -- der shines the in -- fant light;
  %% CHORUS
  \SB {
    come and wor -- ship, come and wor -- ship,
    wor -- ship Christ the new -- born King.
  }
}
verseC = \lyricmode {
  Sag -- es, leave your con -- tem -- pla -- tions–
  bright -- er vi -- sions beam a -- far.
  Seek the great de -- sire of na -- tions,
  guid -- ed by his na -- tal star;
  %% CHORUS
  \SC {
    come and wor -- ship, come and wor -- ship,
    wor -- ship Christ the new -- born King.
  }
}
verseD = \lyricmode {
  Saints, be -- fore the al -- tar bend -- ing,
  watch -- ing long in hope and fear,
  shall be -- hold God's love un -- end -- ing:
  Christ will once a -- gain ap -- pear;
  %% CHORUS
  \SD {
    come and wor -- ship, come and wor -- ship,
    wor -- ship Christ the new -- born King.
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
