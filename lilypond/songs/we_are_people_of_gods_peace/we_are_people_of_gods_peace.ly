\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/ave_virgo_virginum.ly"
soprano = \transpose g f \soprano
alto = \transpose g f \alto
tenor = \transpose g f \tenor
bass = \transpose g f \bass
songChords = \transpose g f \songChords

%% SONG INFO
title = \titleText "We are people of God's peace"
subtitle = \smallText "For a higher key, see ''Come, ye faithful, raise the strain''"
poet = \smallText "Text: based on Menno Simons, alt. David Augsburger, 1978"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-03-24"
\include "../../lib/header.ly"


%% LYRICS
verseA = \lyricmode {
  We are peo -- ple of God's peace
  as a new cre -- a -- tion.
  \l Love u -- nites and strength -- ens us
  at this cel -- e -- bra -- tion.
  \l Sons and daugh -- ters of the Lord,
  ser -- ving one a -- noth -- er,
  \l a new cov -- e -- nant of peace
  binds us all to -- geth -- er.
}
verseB = \lyricmode {
  We are chil -- dren of God's peace
  in this new cre -- a -- tion,
  spread -- ing joy and hap -- pi -- ness
  through God's great sal -- va -- tion.
  Hope we bring in spir -- it meek,
  in our dai -- ly liv -- ing.
  Peace with ev -- 'ry -- one we seek,
  good for e -- vil giv -- ing.
}
verseC = \lyricmode {
  We are ser -- vants of God's peace,
  of the new cre -- a -- tion.
  Choos -- ing peace, we faith -- ful -- ly
  serve with heart's de -- vo -- tion.
  Je -- sus Christ, the Prince of Peace,
  con -- fi -- dence will give us.
  Christ the Lord is our de -- fense;
  Christ will nev -- er leave us.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ly"

%% All sheet music outputs
shapeStaffZoom = #1.1
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_3verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
