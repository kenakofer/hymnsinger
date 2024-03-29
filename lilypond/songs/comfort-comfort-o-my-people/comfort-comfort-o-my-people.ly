\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/geneva-42.ily"

%% SONG INFO
title = \titleText "Comfort, comfort, O my people"
poet = \twoLineSmallText "Text: Johannes Olearius, 1671" "tr. Catherine Winkworth, 1863"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-02-07"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Com -- fort, com -- fort, O my peo -- ple,
  speak of peace, now says our God.
  \l Com -- fort those who sit in dark -- ness,
  mourn -- ing 'neath their sor -- rows' load.

  \l Speak un -- to Je -- ru -- sa -- lem
  of the peace that waits for them.
  \l Tell of all the sins I cov -- er,
  and that war -- fare now is o -- ver.
}
verseB = \lyricmode {
  Hark, the voice of one who's cry -- ing
  in the des -- ert far and near,
  bid -- ding all to full re -- pen -- tance
  since the king -- dom now is here.

  O that warn -- ing cry o -- bey!
  Now pre -- pare for God a way.
  Let the val -- leys rise to meet God
  and the hills bow down to greet God.
}
verseC = \lyricmode {
  O make straight what long was crook -- ed,
  make the rough -- er plac -- es plain.
  Let your hearts be true and hum -- ble,
  as be -- fits God's ho -- ly reign.

  For the glo -- ry of the Lord
  now o'er earth is shed a -- broad.
  And all flesh shall see the to -- ken
  that God's word is nev -- er bro -- ken.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
