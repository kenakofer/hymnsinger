\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/invitation-new.ily"

%% SONG INFO
title = \titleText "Come, ye sinners, poor and wretched"
poet = \smallText "Text: Joseph Hart, 1759, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 3part"
dateAdded = "2021-04-25"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Come, ye sin -- ners, poor and wretch -- ed,
  weak and wound -- ed, sick and sore.
  \l Je -- sus read -- y stands to save you,
  full of pi -- ty joined with pow'r:

  \l He is a -- ble, he is a -- ble,
  he is will -- ing; doubt no more.
  \l He is a -- ble, he is a -- ble,
  he is will -- ing; doubt no more.

}
verseB = \lyricmode {
  Come, ye need -- y, come and wel -- come,
  God's free boun -- ty glo -- ri -- fy.
  True be -- lief and true re -- pen -- tance,
  ev -- 'ry grace that brings you nigh.

  With -- out mo -- ney, with -- out mo -- ney,
  come to Je -- sus Christ and buy!
  With -- out mo -- ney, with -- out mo -- ney,
  come to Je -- sus Christ and buy!
}
verseC = \lyricmode {
  Come ye wea -- ry, hea -- vy la -- den,
  bruised and bro -- ken by the fall.
  If you tar -- ry till you're bet -- ter,
  you will nev -- er come at all:

  Not the right -- eous, not the right -- eous,
  Sin -- ners Je -- sus came to call.
  Not the right -- eous, not the right -- eous,
  Sin -- ners Je -- sus came to call.
}
verseD = \lyricmode {
  Let not con -- science make you ling -- er,
  nor of fit -- ness fond -- ly dream;
  all the fit -- ness he re -- quir -- eth
  is to feel your need of him.

  This he gives you, this he gives you,
  'Tis the Spir -- it's ris -- ing beam.
  This he gives you, this he gives you,
  'Tis the Spir -- it's ris -- ing beam.
}
verseE = \lyricmode {
  Lo! th'~in -- car -- nate God, a -- scend -- ed,
  pleads the mer -- it of his blood.
  Ven -- ture on him, ven -- ture whol -- ly,
  let no oth -- er trust in -- trude:
  None but Je -- sus, none but Je -- sus
  Can do help -- less sin -- ners good.
  None but Je -- sus, none but Je -- sus
  Can do help -- less sin -- ners good.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/5verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-5verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"