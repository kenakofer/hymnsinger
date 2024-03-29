\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: The Columbian Harmony, 1825"
meter = \smallText "HOLY MANNA 87.87 D"
hymnKey = \key a \major
hymnTime = \time 2/2
quarternoteTempo = 130
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Brethren, we have met to worship"
poet = \smallText "Text: The Columbian Harmony, 1825"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-01-07"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {e4 8 fs a4 a | b4 b8 a  cs b a fs | e4 8 fs a4 a | cs b a2 |} \break
  \relative g' {e4 8 fs a4 a | b4 b8 a  cs b a fs | e4 8 fs a4 a | cs b a2 |} \break
  \relative g' {cs4 e e e | cs4 8 a b4 a | cs4 e e e | cs4 8 a b2 |} \break
  \relative g' {e4 8 fs a4 a | b4 b8 a  cs b a fs | e4 8 fs a4 a | cs b a2 |} \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' {cs4 8 d cs4 e | d d8 cs e4 e8 d | cs4 cs8 d e4 cs | e d cs2 |}
  \relative e' {cs4 8 d cs4 e | d d8 cs e4 e8 d | cs4 cs8 d e4 cs | e d cs2 |}
  \relative e' {e4 a a a | e e d cs | e a a a | e e e2 |}
  \relative e' {cs4 8 d cs4 e | d d8 cs e4 e8 d | cs4 cs8 d e4 cs | e d cs2 |}
}
tenor = {
  \globalParts
  \relative a {a4 a a a | gs gs8 a \pa a gs \pt a4 | a a a a | a gs a2 |}
  \relative a {a4 a a a | gs gs8 a \pa a gs \pt a4 | a a a a | a gs a2 |}
  \relative a {a4 cs cs cs | a a gs a | a cs cs cs | a a gs2 |}
  \relative a {a4 a a a | gs gs8 a \pa a gs \pt a4 | a a a a | a gs a2 |}
}
bass = {
  \globalParts
  \relative d {a4 a a cs | e e a8 e cs d | a4 a8 d cs4 a | e' e a,2}
  \relative d {a4 a a cs | e e a8 e cs d | a4 a8 d cs4 a | e' e a,2}
  \relative d {a'4 a a a | a a8 cs, e4 a, | a' a a a | a a,8 cs e2 |}
  \relative d {a4 a a cs | e e a8 e cs d | a4 a8 d cs4 a | e' e a,2}
}

%% LYRICS
verseA = \lyricmode {
  \l Breth -- ren _  we have met to _ wor -- _ ship _ and a -- _ dore the Lord our God.
  \l Will you _ pray with all your _ pow -- _ er _ while we _ try to preach the word?
  \l All is vain un -- less the _ Spir -- it of the ho -- ly One comes _ down.
  \l Breth -- ren _ pray, and ho -- ly _ man -- _ na _ will be _ show -- ered all a -- round.
}
verseB = \lyricmode {
  Sis -- ters, _ will you come and _ help  _ us? _ Mo -- ses' _ sis -- ters aid -- ed him.
  Will you _ help the trem -- bling _ mourn -- _ ers _ who are _ strug -- gling hard with sin?
  Tell them all a -- bout the _ Sav -- ior. Tell them that he will be _ found.
  Sis -- ters _ pray, and ho -- ly _ man -- _ na _ will be _ show -- ered all a -- round.
}
verseC = \lyricmode {
  Is there _ here a trem -- bling _ jail -- _ er, _ seek -- ing _ grace and filled with fears?
  Is there _ here a weep -- ing _ Ma -- _ ry _ pour -- ing _ forth  a flood of tears?
  Breth -- ren join your cries to _ help them, sis -- ters, let your prayers a -- _ bound!
  Pray, oh _ pray, that ho -- ly _ man -- _ na _ will be _ show -- ered all a -- round.
}
verseD = \lyricmode {
  Let us _ love our God su -- _ preme -- _ ly, _ let us _ love each oth -- er too.
  Let us _ love and pray for _ sin -- _ ners _ till our _ God makes all things new.
  Christ will call us home to _ heav -- en. At his ta -- ble we'll sit _ down.
  Christ will _ gird him -- self and _ serve _ us _ with sweet _ man -- na all a -- round.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
