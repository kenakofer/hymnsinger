\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/hyfrydol-public.ily"
quarternoteTempo = 120

%% SONG INFO
title = \titleText "Love Divine, All Loves Excelling"
poet = \smallText "Text: Charles Wesley, 1747"
typesetter = "Zachary Cline"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2022-05-12"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Love di -- vine, all loves ex -- cel -- ling, Joy of heaven to earth come down,
  \l Fix in us Thy hum -- ble dwell -- ing, All Thy faith -- ful mer -- cies crown!
  \l Je -- sus, Thou art all com -- pas -- sion, Pure, un -- bound -- ed love Thou art;
  \l Vis -- it us with Thy sal -- va -- tion, En -- ter ev -- ery trem -- bling heart.
}
verseB = \lyricmode {
  Breathe, O breathe Thy lov -- ing Spir -- it In -- to ev -- ery trou -- bled breast!
  Let us all in Thee in -- her -- it, Let us find the prom -- ised rest;
  Take a -- way the love of sin -- ning; Al -- pha and O -- me -- ga be;
  End of faith, as its be -- gin -- ning, Set our hearts at lib -- er -- ty.
}
verseC = \lyricmode {
  Come, Al -- might -- y to de -- liv -- er, Let us all Thy life re -- ceive;
  Sud -- den -- ly re -- turn, and nev -- er, Nev -- er -- more Thy tem -- ples leave.
  Thee we would be al -- ways bless -- ing, Serve Thee as Thy hosts a -- bove;
  Pray, and praise Thee with -- out ceas -- ing, Glo -- ry in Thy per -- fect love.
}
verseD = \lyricmode {
  Fin -- ish, then, Thy new cre -- a -- tion; Pure and spot -- less let us be;
  Let us see Thy great sal -- va -- tion Per -- fect -- ly re -- stored in Thee;
  Changed from glo -- ry in -- to glo -- ry, Till in heaven we take our place,
  Till we cast our crowns be -- fore Thee, Lost in won -- der, love, and praise.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"