\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/hyfrydol_public.ly"
quarternoteTempo = 120

%% SONG INFO
title = \titleText "Come, thou long-expected Jesus"
poet = \smallText "Text: Charles Wesley, 1744"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "english christian 4part"
dateAdded = "2021-01-07"
\include "../../lib/header.ly"

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
\include "../../lib/2verse.ly"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_2verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"