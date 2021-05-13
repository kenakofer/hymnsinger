\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% Otherwise set up tune info here:
composer = \smallText "Music: English County Songs, 1893"
arranger = \smallText "Harm. Ralph Vaughan Williams, 1906, alt."
meter = \smallText "KINGSFOLD CMD"
hymnKey = \key e \minor
hymnTime = \time 4/4
quarternoteTempo = 110
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "I heard the voice of Jesus say"
poet = \smallText "Text: Horatius N. Bonar, 1846, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-05-12"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 g8( fs) | e4 4 4 d | g g a g8( a) | b4 4 a8( g) e4 | d2. \bar "" \break
    g8( fs) | e4 4 4 d | g g a g8( a) | b4 4 a8( g) e4 | 2. \bar "" \break
    b'8( c) | d4 b4 8( a) g4 | a a b g8( a) | b4 8( a) g4 e | d2. \bar "" \break
    g8( fs) | e4 4 8( d) e( fs) | g4 4 a g8( a) | b4 4 a8( g) e4 | \partial 2. e2. \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    e4 | b b c a | d b d4 8( fs) | g4 4 e c | a2.
    d4 | d c c8 b a4 | d cs d4 8( c) | b4 d c c | b2.
    e4 | fs fs g8( d) d4 | e d d4 8( fs) | g4 8( fs) d4 c8 b | a2.
    d4 | 4 4 c c | d4 8 cs d4 8( c) | b4 d e c | b2.
  }
}
tenor = {
  \globalParts
  \relative a {
    b8( a) | g4 4 4 fs | g g fs g8( c) | b4 d c g | 2( fs4)
    g4 | 4 4 4 fs | g g fs g8( fs) | g4 4 e4 8( fs) | g2.
    g4 b d d8( c) b4 | a8( g) fs4 g d'8( c) | d4 d8( c) b4 g | 2( fs4)
    g4 | 4 4 a c | b8( a) g4 fs g8( fs) | g4 fs e e8( fs) | g2.
  }
}
bass = {
  \globalParts
  \relative d {
    e4 | 4 8( d) c4 4 | b e d b8( a) | g4 4 a c | d2.
    b4 | c4 8( b) a4 d | b e d8( c) b( a) | g4 b c a | e'2.
    e4 | b b' e,8( fs) g4 | c,4 d g, b8( a) | g4 8( a) b4 c | d2.
    b4 | c c8( b) a4 a' | g8( fs) e4 d b8( a) | g4 b c a | e'2.
  }
}
songChords = \chords {
  \globalChordSymbols
  s4 | e2:m c g d g a:m d:sus d
  e:m a:m e:m d g a:m e:m e:m
  b:m e:m a:m g b:m e:m d:sus d
  c a:m e:m d g/b a:m e:m
}

%% LYRICS
verseA = \lyricmode {
  \l I heard the voice of Je -- sus say,
  ''Come un -- to me and rest.
  \l Lay down, O wea -- ry one, lay down
  your head up -- on my breast.''

  \l I came to Je -- sus as I was,
  so wea -- ry, worn, and sad.
  \l I found in him a rest -- ing place,
  and he has made me glad.
}
verseB = \lyricmode {
  I heard the voice of Je -- sus say,
  ''Be -- hold, I free -- ly give
  the liv -- ing wa -- ter, thirst -- y one;
  stoop down and drink and live.''

  I came to Je -- sus, and I drank
  of that life -- giv -- ing stream.
  My thirst was quenched, my soul re -- vived,
  and now I live in him.
}
verseC = \lyricmode {
  I heard the voice of Je -- sus say,
  ''I am this dark world's light.
  Look un -- to me, your morn shall rise,
  and all your day be bright.''

  I looked to Je -- sus, and I found
  in him my star, my sun,
  and in that light of life I'll walk
  till tra -- v'ling days are done.
}
spacingVerse = \lyricmode {
  "\t"
}

% Set up music-aligned verses. Change to the correct number
all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC } }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"