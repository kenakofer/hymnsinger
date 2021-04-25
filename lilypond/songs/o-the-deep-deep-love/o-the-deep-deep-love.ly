\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared_tunes/ebenezer_12_8.ily"

%% SONG INFO
title = \titleText "O the deep, deep love of Jesus"
poet = \smallText "Text: S. Trevor Francis, 1890"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-03-30"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l O the deep, deep love of Je -- sus!
  Vast, un -- mea -- sured, bound -- less, free!
  \l Roll -- ing as a might -- y o -- cean
  in its full -- ness ov -- er me!

  \l Un -- der -- neath me, all a -- round -- me,
  is the cur -- rent of thy love;
  \l lead -- ing on -- ward, lead -- ing home -- ward,
  to thy glo -- rious rest a -- bove.
}
verseB = \lyricmode {
  O the deep, deep love of Je -- sus!
  Spread his praise from shore to shore!
  How he loves us, ev -- er loves us,
  chang -- es nev -- er, nev -- er -- more!

  How he watch -- es o'er his loved ones,
  died to call them all his own;
  how for them he's in -- ter -- ced -- ing,
  watch -- ing o'er them from the throne!
}
verseC = \lyricmode {
  O the deep, deep love of Je -- sus,
  love of ev -- 'ry love the best!
  'Tis an o -- cean vast of bless -- ing,
  'tis a ha -- ven sweet of rest!

  Oh, the deep, deep love of Je -- sus,
  'tis a heav'n of heav'ns to me;
  and it lifts me up to glo -- ry,
  for it lifts me up to thee!
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output
\include "../../lib/slides_book_3verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"