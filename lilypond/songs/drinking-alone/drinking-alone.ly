\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: 梅花三弄 (Plum Blossom Melodies)"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "PLUM BLOSSOM 88.88.88.88"
hymnKey = \key g \major
hymnTime = \time 4/4
quarternoteTempo = 76
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Drinking alone in the moonlight"
subtitle = \markup{
        \override #'(baseline-skip . 2)
        \fontsize #-0
        \italic
        \medium
        \center-column {
          "花間一壺酒"
          "獨酌無相親"
          "舉杯邀明月"
          "對影成三人"
          "月既不解飲"
          "影徒隨我身"
          "暫伴月將影"
          "行樂須及春"
          "我歌月徘徊"
          "我舞影零亂"
          "醒時同交歡"
          "醉後各分散"
          "永結無情遊"
          "相期邈雲漢"
        }
      }
poet = \twoLineSmallText "Text: 李白 (Li Bai), 701-762" "tr. W.J.B. Fletcher, 1919, alt. Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "chinese english secular evening 3part"
dateAdded = "2021-06-05"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    b8 d4 e8 b4. a8 | g( a b) e, d4. 8 |
    e4. g8 a g d' e | b1 | \break
    b8 d4 e8 e4. b8 | d( b d) e g,4. 8 |
    e8 g a d b4 a8( b16 a) | g1 \break

    d'8 4 b8 d e b a | b2. d8( e) |
    b4. d8 g, e g[ b16( d)] | a1 | \break
    a8 4 g8 a b d b | a2. 8( d) |
    b4. a8 g e a b | b16( a g4.)~ 2 |
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    g8 a4 g8 g4. fs8 | e4. 8 b4. 8 |
    4. 8 fs'[ g] g g | g1
    g8 a4 g8 g4. g8 | a8( g b) g g4. b,8 |
    b8 b fs' fs g4 g4 | d1

    d8 b'4 b8 a g g fs | g2. g4
    g4. b8 e, b e e | e8( fs2..)
    d8 4 8 fs g b g | g2. fs4
    g4. e8 e[ e] d d | d1
  }
}
tenor = {}
bass = {
  \globalParts
  \relative d {
    g4 g8 e d4. 8 | d8( e4) 8 e8( g4) 8 |
    g4. e8 d d g g | g1 |
    d8 d4 d8 b'4. 8 | a4( g8) b, e4. 8 |
    e8 d d b d4 4 | g1

    g4 8 e d b b d | e8( g~ 2) g4 |
    d4. g8 g g e b | d1
    d8 d4 d8 d d b b | d2. d4 |
    g4( d8) e e b a a | g1
  }
}

%% LYRICS
verseA = \lyricmode {
  \l One pot of wine a -- mid the flowers
  a -- lone I pour, and none with me.
  \l The cup I lift; the Moon in -- vite;
  who with my Sha -- dow makes us three.
  \l Though Moon dis -- miss my off -- ered drink,
  the Sha -- dow does what I be -- gin.
  \l As one, the Sha -- dow, Moon and I
  re -- joice, and watch the spring come in.
}
verseB = \lyricmode {
  I sing: and wa -- vers time the Moon.
  I dance: the Sha -- dow an -- tics too.
  Our joys we share while so -- ber still.
  When drunk, we part and bid a -- dieu.
  Of love -- less out -- ing this the pact,
  sus -- tain -- ing us through clou -- dy day.
  The next time that we meet shall be
  be -- side yon dis -- tant mil -- ky way.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"