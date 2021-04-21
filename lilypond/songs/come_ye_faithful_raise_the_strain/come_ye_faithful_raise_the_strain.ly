\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared_tunes/ave_virgo_virginum.ily"

%% SONG INFO
title = \titleText "Come, ye faithful, raise the strain"
subtitle = \smallText "For a lower key, see ''We are people of God's peace''"
poet = \twoLineSmallText "Text: John of Damascus, 8th c." "tr. John M. Neale, 1859, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian easter 4part"
dateAdded = "2021-04-04"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Come, ye faith -- ful, raise the strain of tri -- um -- phant glad -- ness!
  \l God hath brought forth Is -- ra -- el in -- to joy from sad -- ness,
  \l loosed from Pha -- raeh's bit -- ter yoke Ja -- cob's sons and daugh -- ters,
  \l led them with un -- moist -- ened foot through the Red Sea wa -- ters.
}
verseB = \lyricmode {
  'Tis the spring of souls to -- day: Christ hath burst his pris -- on,
  and from three days' sleep in death as a sun hath ris -- en.
  Now re -- joice, Je -- ru -- sa -- lem, and with true af -- fec -- tion
  wel -- come in un -- wea -- ried strains Je -- sus' res -- ur -- rec -- tion.
}
verseC = \lyricmode {
  Nei -- ther shall the gates of death, nor the tomb's dark por -- tal,
  nor the watch -- ers, nor the seal hold thee as a mor -- tal.
  But a -- ris -- en 'midst thy friends thou didst stand, be -- stow -- ing
  thy true peace, which ev -- er -- more pass -- es hu -- man know -- ing.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides_book_3verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"