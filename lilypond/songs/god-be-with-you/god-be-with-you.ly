\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: William G. Tomer, 1880"
meter = \smallText "GOD BE WITH YOU 98.89 with refrain"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 100
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
    e4. 8 8 8 8 8 | g4 d e2 | a4. 8 8 8 8 8 | 2 g | \break
    g4. 8 8 8 8 8 | 2 e | 4. 8 a g c, d e4 d \m c2. c4\fermata \bar "||" \break
    \partial 4 e8. f16 | g4( c e) d8. c16 | a4( c2) b8. a16 | g4. a8 g( e) c( e) | d2. \bar "" \break
    \partial 4 e8. f16 | g4( c e) d8. c16 | a4( \m { c2.) \partial 2 4. a8 } { c2)\fermata c8.\fermata a16 } | g8 e c d e4 d | c1 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    c4. 8 8 8 8 8 | 4 b c2 | 4. f8 8 8 8 8 | 2 e |
    d4. 8 8 8 f f | e2 c | 4. 8 f e c c | 4 b \m c2. c4
    c8. d16 | e2( g4) 8. 16 | f4( a2) g8. f16 | e4. f8 e( c) c4 | b2.
    c8. d16 | e2( g4) 8. 16 | f4( \m { a2.) f4. 8 } { a2) f8. 16 } | e8 c c c c4 b | c1 |
  }
}
tenor = {
  \globalParts
  \relative a {
    g4. 8 8 8 8 8 | 4 4 2 | f4. c'8 8 8 8 8 | 2 2 |
    b4. 8 8 8 d d | c2 g | 4. 8 c c g a | g4 f \m e2. e4
    r4 | r4 g8 8 c4 8. 16 | 4 4 4 8. 16 | 4. 8 8( g) e( g) | g4 8 8 4
    r4 | r4 g8 8 c4 8. 16 | 4 4 \m { c2 a4. c8 } { c4 a8. c16 } | c8 g g a g4 f | e1 |
  }
}
bass = {
  \globalParts
  \relative d {
    c4. 8 8 8 8 8 | e4 g c,2 | f4. 8 8 8 8 8 | c2 2 |
    g'4. 8 8 8 g, g | c2 2 | 4. 8 8 8 e f | g4 g, \m c2. c4_\fermata
    r4 | r4 c8 8 4 e8. 16 | f4 4 4 8. 16 | c4. 8 4 4 | g4 8 8 4
    r4 | r4 c8 8 4 e8. 16 | f4 4 \m { f2 4. 8 } { f4_\fermata 8._\fermata 16 } | c8 8 e f g4 g, | c1 |
  }
}
songChords = \chords {
  \globalChordSymbols
  c1 c4 g c c | f1 f2/c c g2. g4:7 c1 c c4/g g:7 c
  c4 | c1 f c g c f c2 c4/g g:7 c1
}

%% LYRICS
verseA = \lyricmode {
  \l God be with you till we meet a -- gain;
  lov -- ing coun -- sels guide, up -- hold you,
  \l may the Shep -- herd's care en -- fold you;
  God be with you till we meet a -- gain.

  %% CHORUS
  Till we meet, till we meet,
  till we meet at Je -- sus' feet.
  Till we meet, till we meet,
  God be with you till we meet a -- gain.
}
verseB = \lyricmode {
  God be with you till we meet a -- gain;
  un -- seen wings, pro -- tect -- ing, hide you,
  dai -- ly man -- na still pro -- vide you;
  God be with you till we meet a -- gain.

  %% CHORUS
  \SB {
    Till we meet, till we meet,
    till we meet at Je -- sus' feet.
    Till we meet, till we meet,
    God be with you till we meet a -- gain.
  }
}
verseC = \lyricmode {
  God be with you till we meet a -- gain;
  when life's per -- ils thick con -- found you,
  put un -- fail -- ing arms a -- round you;
  God be with you till we meet a -- gain.

  %% CHORUS
  \SC {
    Till we meet, till we meet,
    till we meet at Je -- sus' feet.
    Till we meet, till we meet,
    God be with you till we meet a -- gain.
  }
}
verseD = \lyricmode {
  God be with you till we meet a -- gain;
  keep love's ban -- ner float -- ing o'er you,
  smite death's threat -- 'ning wave be -- fore you;
  God be with you till we meet a -- gain.

  %% CHORUS
  \SD {
    Till we meet, till we meet,
    till we meet at Je -- sus' feet.
    Till we meet, till we meet,
    God be with you till we meet a -- gain.
  }
}
bottomLyrics = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  Till we meet, _ _ _ a -- gain, _ _ _ _ _ _ _  _till we meet.
  Till we meet, _ _ _ a -- gain,
}

all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \new NullVoice = "tenor" {\removeWithTag #'midionly \tenor}
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC } }
  \tag #'verseD { \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD } }
  \new Lyrics  \lyricsto tenor  { \globalLyrics "" "" \bottomLyrics }
>>

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"