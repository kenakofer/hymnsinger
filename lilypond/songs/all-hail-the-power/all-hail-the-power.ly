\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Oliver Holden, 1792"
meter = \smallText "CORONATION CM extended"
hymnKey = \key g \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "All hail the power of Jesus' name"
poet = \smallText "Text: Edward Perronet, 1780, revised by John Rippon, 1787"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-01-14"
\include "../../lib/header.ily"

%% SETTINGS
globalParts = {
  \hymnKey
  \hymnTime
  \hymnBaseMoment
  \hymnBeatStructure
  \hymnBeamExceptions
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 d4 | g4 g b b | a g a  b | a g b a | g2. \bar"" } \break
  \relative g' { a4 | b a g b | d8( c) b( a) b4 \bar"" }
  \relative g' { d'4 | d2 d | e d4( cs) | d2. \bar"" } \break
  \relative g' { b4 | d b g b | a8( g) a( b) a4 \bar"" }
  \relative g' { g4 | d'2 c | b4.( c8 a4) a | g2 \bar"|." }
}
alto = {
  \globalParts
  \relative e' { b4 | d4 d g g | fs e fs g | fs g d c | b2. }
  \relative e' { d4 | g d b g' | b8( a) g( fs) g4 fs4 | g2 a | g fs4( e) | fs2. }
  \relative e' { g4 | g g g d | d d fs g | g2 e | d2. c4 | b2 }
}
tenor = {
  \globalParts
  \relative a { g4 | b4 b d d | c b c d | c b g fs | g2. }
  \relative a { a4 | b a g b | d8[ c] b[ a] b4 a | b2 a | b a | a2. }
  \relative a { g4 | b d d d | c8[ b] c[ d] c4 b4 | g2 g | g2. fs4 | g2 }
}
bass = {
  \globalParts
  \relative d { g,4 | g4 g g' g | d e d g | d e d d | g,2. }
  \relative d { d4 | g d b g' | b8[ a] g[ fs] g4 d | g2 fs | e a | d,2. }
  \relative d { g4 | g g b g | d d d e | b2 c | d2. d4 | g,2 }
}


%% LYRICS
verseA = \lyricmode {
  \l All hail the pow’r of Je -- sus’ name! Let an -- gels pros -- trate fall.
  \l Bring forth the roy -- al di -- a -- dem, and crown him Lord of all.
  \l Bring forth the roy -- al di -- a -- dem, and crown him Lord of all!
}
verseB = \lyricmode {
  O cho -- sen seed of Is -- rael’s race now ran -- somed from the fall,
  hail him who saves you by his grace, and crown him Lord of all.
  Hail him who saves you by his grace, and crown him Lord of all!
}
verseC = \lyricmode {
  Let ev -- ’ry tongue and ev -- ’ry tribe re -- spon -- sive to his call,
  to him all maj -- es -- ty a -- scribe, and crown him Lord of all.
  To him all maj -- es -- ty a -- scribe, and crown him Lord of all!
}
verseD = \lyricmode {
  Oh, that with all the sa -- cred throng we at his feet may fall!
  We’ll join the ev -- er -- last -- ing song and crown him Lord of all.
  We’ll join the ev -- er -- last -- ing song and crown him Lord of all!
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
