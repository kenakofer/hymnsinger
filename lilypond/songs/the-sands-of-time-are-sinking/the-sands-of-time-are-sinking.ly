\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared_tunes/rutherford.ily"
hymnKey = \key e \major

%% SONG INFO
title = \titleText "The Sands of Time Are Sinking"
poet = \smallText "Text: A. R. Cousin, 1857"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-04-25"
\include "../../lib/header.ily"

%% NOTES
soprano = \transpose f e \soprano
alto = \transpose f e \alto
tenor = \transpose f e \tenor
bass = \transpose f e \bass
songChords = \transpose f e \songChords

%% LYRICS
verseA = \lyricmode {
  \l The sands of time are sink -- ing,
  the dawn of hea -- ven breaks.
  the sum -- mer morn I've sighed for,
  the fair sweet morn a -- wakes;
  dark, dark hath been the mid -- night,
  but day -- spring is at hand,
  and glo -- ry, glo -- ry dwell -- eth
  in Em -- man -- uel's land.
}
verseB = \lyricmode {
  The King there in his bea -- ty
  with -- out a veil is seen;
  it were a well -- spent jour -- ney,
  though sev'n deaths lay be -- tween:
  the Lamb with his fair ar -- my
  doth on Mount Zi -- on stand.
  and glo -- ry, glo -- ry dwell -- eth
  in Em -- man -- uel's land.
}
verseC = \lyricmode {
  O Christ, he is the foun -- tain,
  the deep sweet well of love!
  The streams on earth I've tast -- ed,
  more deep I'll drink a -- bove:
  there to an o -- cean full -- ness
  his mer -- cy doth ex -- pand,
  and glo -- ry, glo -- ry dwell -- eth
  in Em -- man -- uel's land.
}
verseD = \lyricmode {
  The bride eyes not her gar -- ment,
  but her dear bride -- groom's face;
  I will not gaze at glo -- ry,
  but on my King of grace;
  not at the crown he gift -- eth,
  but on his pier -- cèd hand:
  the Lamb is all the glo -- ry
  of Em -- man -- uel's land.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides_book_4verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"