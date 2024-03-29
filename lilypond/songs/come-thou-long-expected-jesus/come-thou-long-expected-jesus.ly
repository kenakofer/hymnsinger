\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/hyfrydol-public.ily"
quarternoteTempo = 120

%% SONG INFO
title = \titleText "Come, thou long-expected Jesus"
poet = \smallText "Text: Charles Wesley, 1744"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "english christian 4part"
dateAdded = "2021-01-07"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Come, thou long -- ex -- pect -- ed Je -- sus! born to set thy peo -- ple free,
  \l from our fears and sins re -- lease us, let us find our rest in thee.
  \l Is -- rael's strength and con -- so -- la -- tion, hope of all the earth thou art,
  \l dear de -- sire of ev -- 'ry na -- tion, joy of ev -- 'ry long -- ing heart.
}
verseB = \lyricmode {
  Born thy peo -- ple to de -- liv -- er, born a child, and yet a King,
  born to reign in us for -- ev -- er, now thy gra -- cious king -- dom bring.
  By thine own e -- ter -- nal Spir -- it, rule in all our hearts a -- lone.
  By thine all -- suf -- fi -- cient mer -- it, raise us to thy glo -- rious throne.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"