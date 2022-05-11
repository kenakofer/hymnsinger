\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/wunderbarer-konig.ily"

%% SONG INFO
title = \titleText "God is here among us"
subtitle = \smallText "See also in German: Gott ist gegenwärtig"
poet = \smallText "Text: Gerhard Tersteegen, 1729, trans. The Hymnal, 1940, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-03-04"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l God is here a -- mong us: come with a -- do -- ra -- tion, fer -- vent praise and ex -- pec -- ta -- tion.
  \l God is here with -- in us: known be -- yond be -- liev -- ing, soul in si -- lent awe re -- ceiv -- ing.
  \l God will name and will claim those be -- held as low -- ly, mak -- ing all things ho -- ly.
}
verseB = \lyricmode {
  Come, a -- bide with -- in me; let my soul, like Ma -- ry, be thine earth -- ly sanc -- tu -- ar -- y.
  Come, in -- dwell -- ing Spir -- it, with trans -- fig -- ured splen -- dor; love and hon -- or will I ren -- der.
  Where I go here be -- low, let me bow be -- fore thee, know thee, and a -- dore thee.
}
verseC = \lyricmode {
  Glad -- ly we sur -- ren -- der earth's de -- ceit -- ful trea -- sures, pride of life, and sin -- ful plea -- sures.
  God, we glad -- ly of -- fer thine to be for -- ev -- er, soul and life and each en -- deav -- or.
  Thou a -- lone shalt be known Lord of all our be -- ing, life's true way de -- cree -- ing.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
