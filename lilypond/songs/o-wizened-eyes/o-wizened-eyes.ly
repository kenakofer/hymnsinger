\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Gustav Holst, 1921"
meter = \smallText "THAXTED 13.13.14.12.13.14"
hymnKey = \key bf \major
hymnTime = \time 3/4
quarternoteTempo = 89
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "O wizened eyes resplendent"
subtitle = \smallText "In memory of Robert Coon"
poet = \smallText "Text: Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "english theist 1part death accompanied"
dateAdded = "2021-07-29"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 d8( f) | g4. bf8 a8. f16 | bf8( c) bf4 a | g8 a g4 f | d2 \bar "" \break
    d8( f) | g4. bf8 a8. f16 | bf8( c) d4 d | d8 c bf4 c | bf2 \bar "" \break
    f8( d) | c4 4 bf8 d | c4 f f8 d | c4. 8 d f | g2 \bar "" \break
    g8( a) | bf4 a g | f bf d, | c8 bf c4 d | f2 \bar "" \break
    d8\( f\) | g4. bf8 a8. f16 | bf8( c) bf4 a | g8 a g4 f | d2 \bar "" \break
    d8\( f\) | g4. bf8 a8. f16 | bf8 c d4 d | d8 c bf4 c | bf2 \bar "" \break
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d4 | ef2 4 | f2 4 | ef2 c4 | bf2
    d4 | ef2 4 | f2 <f bf>4 | <ef g>2 4 | <d f>2
    bf4 | a2 bf4 | c2 bf4 | a2 bf4 | <bf ef>2
    ef4 | d d ef | f4 d bf | g2 bf4 | c( bf)
    a4 | <bf ef>2 ef4 | f2 4 | ef2 c4 | bf2
    a4 | <bf ef>2 ef4 | f2 <f bf>4 <ef g>2 4 | <d f>2
  }
}
tenor = {
  \globalParts
  \relative a {
    bf4 | 2 c4 | bf2 4 | 2 a4 | g2
    a4 | bf2 c4 | bf2 4 | g4 bf g | bf2
    f4 | 2 <g d>4 | f2 4 | 2 4 | g2
    c4 | bf4 4 4 | 2 f4 | ef2 g4 | f2
    f4 | <g ef>2 <ef a c>4 | <d f bf>2 <f bf>4 | <ef bf'>2
    <c a'>4 | g'2 f4 | <ef g>2 c'4 | bf2 4 | g2 4 | bf2
  }
}
bass = {
  \globalParts
  \relative d {
    bf4 | ef2 c4 | d2 4 | ef2 f4 | g2
    f4 | ef2 c4 | d2 bf8 d | ef2 4 | bf2
    d,4 | f2 g4 | a2 d,4 | f2 bf4 | ef4( d)
    c4 | g' f ef | d c bf | ef c bf | a( g)
    f4 | ef2 c4 | d2 4 | ef2 f4 | g2
    f4 | ef2 c'4 | d2 bf8 d | ef2 4 | bf2
  }
}

chordSymbols = \chordmode {
  \globalChordSymbols
  bf4 | ef2 f4:7/c | bf2. | ef2 f4 | g2.:m
      | ef2 f4:7/c | bf2. | ef2:maj7 c4:m | bf2.
      | f2 g4:m | f2 bf4 | f2 bf4 | ef2.
      | g2:m ef4 | bf2. | c2:m/ef g4:m | f2.
      | ef2 f4:7/c bf2./d | ef2 f4 | g2.:m
      | ef2 f4:7/c | bf2. | ef2:maj7 c4:m | bf2.
}
songChords =
<<
\new ChordNames {
  \set instrumentName = ""
  \override ChordNames.ChordName.color = #white
  \chordmode { a1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 }
}
\new ChordNames {
  \once \override InstrumentName.extra-offset = #'(10 . 0.7)
  \override ChordNames.ChordName.font-shape = #'italic
  \override ChordNames.ChordName.font-size = #-1
  \set instrumentName = \markup { \italic "Capo 3:" }
  \transpose bf g \chordSymbols
}
\new ChordNames {
  \set instrumentName = ""
  \chordSymbols
}
>>

%% LYRICS
verseA = \lyricmode {
  \l O wiz -- ened eyes re -- splen -- dent, we seek the things you saw,
  \l that urged you to such great -- ness, and hum -- bled you in awe.
  \l We strive now, as you once strove, toward the bea -- con, toward the Light.
  \l With fore -- bears in -- vit -- ing, it beck -- ons yet more bright.
  \l Though _ tear -- y eyes may hin -- der, and sor -- row shroud our way,
  \l what _ seems to us like eve -- _ ning may just be break of day.
}
verseB = \lyricmode {
  O ea -- ger lips of bless -- ing, speak grace for us to -- day,
  for -- give us and our mourn -- ing, our stub -- born, pet -- ty ways.
  We speak now, as you once spoke, prayers and stor -- ies, ho -- ly jest,
  to bol -- ster worn hearts and in -- spire us to our best.
  You _ ut -- tered bless'd ass -- ur -- ance, through strife, your words did calm,
  there _ is a -- far in Gi -- le -- ad, vouch -- safed for us a Balm.
}
verseC = \lyricmode {
  O trem -- b'ling hands of ser -- vice, wrap arms a -- round us all.
  Take res -- pite from your la -- bors, and joy in heav -- en's call.
  We fight now, as you once fought, not with sword, but plow -- share hewn.
  Through clang -- or -- ous war drums you hummed a dif -- f'rent tune:
  Ev -- 'ry note is one of jus -- tice, each tear can shat -- ter chains,
  ev -- 'ry sigh be -- comes a rush of wind, set free a -- cross the plains.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"