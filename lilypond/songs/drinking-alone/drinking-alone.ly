\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Plum Blossom Melodies (梅花三弄)"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "PLUM BLOSSOM"
hymnKey = \key g \major
hymnTime = \time 4/4
quarternoteTempo = 90
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Drinking alone with the moon"
poet = \smallText \twoLineSmallText "Text: 李白 (Li Bai), 701-762" "tr. W.J.B. Fletcher, 1919"
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 2
tags = "english secular 3part"
dateAdded = "2021-06-02"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    b8 d4 e8 b4. a8 | g( a b) e, d4. 8 |
    e4. g8 a g d' e | b1 | \break
    b8 d4 e8 e4. b8 | d( b d) e g,4. 8 |
    e8 g a d b4 a8( b16 a) | g1 \break

    d'8 4 b8 d e g fs | e2. d8( e) |
    b4. d8 g, e g b16( d) | a1 | \break
    a8 4 g8 a b d b | a2. 8( d) |
    b4. a8 g e a b | b16( a g4.)~ 2 |

    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {

  }
}
tenor = {
  \globalParts
  \relative a {
  }
}
bass = {
  \globalParts
  \relative d {

  }
}

%% LYRICS
verseA = \lyricmode {
  \l One pot of wine a -- mid the flowers
  A -- lone I pour, and none with me.
  \l The cup I lift; the Moon in -- vite;
  Who with my sha -- dow makes us three.
  \l The moon then drinks with -- out a pause.
  The sha -- dow does what I be -- gin.
  \l The sha -- dow, Moon and I in fere
  Re -- joice un -- til the spring come in.
}
verseB = \lyricmode {
  I sing: and wa -- vers time the moon.
  I dance: the sha -- dow an -- tics too.
  Our joys we share while so -- ber still.
  When drunk, we part and bid a -- dieu.
  Of love -- less out -- ing this the pact,
  Which we all swear to keep for aye.
  The next time that we meet shall be
  Be -- side yon dis -- tant mil -- ky way.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"