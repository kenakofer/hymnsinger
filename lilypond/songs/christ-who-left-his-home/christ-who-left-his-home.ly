\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Abram B. Kolb, 1896"
meter = \smallText "CHRIST IS RISEN 87.87 with refrain"
hymnKey = \key ef \major
hymnTime = \time 2/2
quarternoteTempo = 110
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Christ who left his home in glory"
poet = \smallText "Text: Abram B. Kolb, 1896, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian easter 4part"
dateAdded = "2021-04-09"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    bf4 g ef'4. bf8 | d( c) bf( c) bf4 g | c bf4 8( af) g4 | f a bf2 | \break
    bf4 g ef'4. bf8 | d( c) bf( c) bf4 g | c d ef4. g,8 | 4 f ef2 \bar "||" \break
    bf'2. g4 | ef'2. bf4 | 2. c4 | bf2 g | \break
    bf2. g4 | \m {ef'2.~2} {ef2.\fermata} ef8. 16 | 4. g,8 4 f | ef2. r4
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    ef4 4 g4. 8 | af4 4 g ef | ef ef d ef | f ef d2 |
    ef4 ef g4. 8 | af4 4 g ef | ef af g4. ef8 | 4 bf bf2 |
    g'2. ef4 | g2. 4 | af2. 4 | g2 ef
    g2. ef4 | ef( f \m g2. g4)_\fermata fs8. 16 | g4. ef8 4 d | bf2. r4
  }
}
tenor = {
  \globalParts
  \relative a {
    g4 bf4 4. 8 | 4 d ef bf | af bf bf bf | bf f f2 |
    g4 bf4 4. 8 | 4 d ef bf | af bf bf4. 8 | 4 af g2 |
    ef'4 8. 16 4 bf | 4 8. 16 4 ef | d4 8. 16 d4 d | ef4 8. 16 bf2
    ef4 8. 16 4 bf | 4 4 \m {bf2.} {bf4} c8. 16 | bf4. 8 4 af | g2. r4 |
  }
}
bass = {
  \globalParts
  \relative d {
    ef4 4 4. 8 | f4 bf ef, ef | af g f ef | d c bf2
    ef4 4 4. 8 | f4 bf ef, ef | af f ef4. 8 | bf4 4 ef2 |
    ef4 8. 16 4 4 | 4 8. 16 4 4 | f4 8. 16 bf4 bf, | ef4 8. 16 2 |
    ef4 8. 16 ef4 4 | g4 f \m {ef2.} {ef4_\fermata} a8. 16 | bf4. 8 bf,4 4 | ef2. r4 |
  }
}

%% LYRICS
verseA = \lyricmode {
  \l Christ who left his home in glo -- ry,
  and up -- on the cross was slain,
  \l now is ris'n~ O tell the sto -- ry
  that the Sav -- ior lives a -- gain.
  %% CHORUS
  Hail him! Hail him! Tell the sto -- ry.
  Hail! all hail! Je -- sus lives for -- ev -- er -- more.
}
verseB = \lyricmode {
  While the world in peace was sleep -- ing,
  ear -- ly on that East -- er day,
  came the faith -- ful wom -- en, weep -- ing,
  but the stone was rolled a -- way.
  %% CHORUS
  \SB {
    Hail him! Hail him! Tell the sto -- ry.
    Hail! all hail! Je -- sus lives for -- ev -- er -- more.
  }
}
verseC = \lyricmode {
  Christ, our lov -- ing med -- i -- a -- tor,
  now with God for you and me
  in -- ter -- cedes, and our Cre -- a -- tor
  hears and an -- swers ev -- 'ry plea.
  %% CHORUS
  \SC {
    Hail him! Hail him! Tell the sto -- ry.
    Hail! all hail! Je -- sus lives for -- ev -- er -- more.
  }
}
tenorWords = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  Hail him, all hail the might -- y Re -- deem -- er!
  Hail him who robbed the grave of its pow'r!
  Tell ev -- 'ry na -- tion, all is well,
}

all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \new NullVoice = "tenor" {\removeWithTag #'midionly \tenor}
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC } }
  \new Lyrics  \lyricsto tenor  { \globalLyrics "" "" \tenorWords }
>>

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"