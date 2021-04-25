\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Hans L. Hassler, 1601"
arranger = \smallText "arr. J. S. Bach, 1729"
meter = \smallText "HERZLICH TUT MICH VERLANGEN 76.76 D"
hymnKey = \key d \major
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "O sacred Head, now wounded"
poet = \smallText "Text: Paul Gerhardt, 1656; tr. James W. Alexander, 1861"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part death"
dateAdded = "2021-03-22"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 fs4 | b a g fs | e2 fs4 cs' | d d cs8( b) cs4 | b2. \bar "" } \break
  \relative g' { \partial 4 fs4 | b a g fs | e2 fs4 cs' | d d cs8( b) cs4 | b2. \bar "" } \break
  \relative g' { \partial 4 d'4 | cs8( b) a4 b cs | d2 4 a | b a g g | \partial 2. fs2. \bar "" } \break
  \relative g' { \partial 4 d'4 | cs8( d) e4 d cs | b2 cs4 fs, | g fs e a | fs2. } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 | 4 4 8( e) e( d) | 4( cs) d e | d8( e) fs4 4 8( e) | d2. }
  \relative e' { d4 | 4 4 8( e) e( d) | 4( cs) d e | d8( e) fs4 4 8( e) | d2. }
  \relative e' { b'8( a) | g4 fs8( e) d4 g | g( fs8 e) fs4 4 | g fs fs e | ds2. }
  \relative e' { e4 | 4 4 fs e | fs( e) e d | 8( cs) d4 4 cs | d2. }
}
tenor = {
  \globalParts
  \relative a { a4 | g a b8( a) 4 | b( a) a as | fs b b as | b2. }
  \relative a { a4 | g a b8( a) 4 | b( a) a as | fs b b as | b2. }
  \relative a { fs'4 | e8( d) cs4 b8( a) g( a) | b4( a8 g) a4 d | 4 8( cs) b4 4 | 2. }
  \relative a { b4 | a4 8( gs) a( b) cs( a) | fs( b gs4) a a | g a b e,8( a) | 2. }
}
bass = {
  \globalParts
  \relative d { d4 | g fs b,8( cs) d4 | g,( a) d cs | b8( cs) d( e) fs4 fs, | b2. }
  \relative d { d4 | g fs b,8( cs) d4 | g,( a) d cs | b8( cs) d( e) fs4 fs, | b2. }
  \relative d { b'4 | e, fs g8( fs) e4 | d2 4 4 | g d e8( fs) g( a) | b2. }
  \relative d { gs4 | a cs, fs8( gs) a4 | d,( e) a, d8( cs) | b4 a g a | d2. }
}

%% LYRICS
verseA = \lyricmode {
  O sa -- cred Head, now wound -- ed,
  with grief and shame weighed down,
  now scorn -- ful -- ly sur -- round -- ed
  with thorns, thine on -- ly crown!
  O sa -- cred Head, what glo -- ry,
  what bliss till now was thine!
  Yet, though de -- spised and gor -- y,
  I joy to call thee mine.
}
verseB = \lyricmode {
  What thou, my Lord, hast suf -- fered
  was all for sin -- ners' gain.
  Mine, mine was the trans -- gres -- sion,
  but thine the dead -- ly pain.
  Lo, here I fall, my Sav -- ior!
  'Tis I de -- serve thy place.
  Look on me with thy fa -- vor,
  and grant to me thy grace.
}
verseC = \lyricmode {
  What lan -- guage shall I bor -- row
  to thank thee, dear -- est Friend,
  for this, thy dy -- ing sor -- row,
  thy pit -- y with -- out end?
  Oh, make me thine for -- ev -- er,
  and should I faint -- ing be,
  Lord, let me nev -- er, nev -- er
  out -- live my love to thee.
}
verseD = \lyricmode {
  Be near when I am dy -- ing,
  oh, show thy cross to me,
  and for my res -- cue, fly -- ing,
  come, Lord, and set me free!
  These eyes, new faith re -- ceiv -- ing,
  from Je -- sus shall not move,
  for one who dies be -- liev -- ing
  dies safe -- ly, through thy love.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
clairStaffZoom = #.9
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
