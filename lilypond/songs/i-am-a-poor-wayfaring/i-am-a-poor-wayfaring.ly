\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/wayfaring-stranger.ily"

%% SONG INFO
title = \titleText "I am a poor wayfaring stranger"
poet = \smallText "Text: Christian Songster, 1858, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-05-11"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l I am a poor way -- far -- ing stran -- ger
  a -- trav -- lin' through this world of woe,
  \l yet there's no sick -- ness, toil or dan -- ger
  in that bright world to which I go.

  \l I'm go -- ing there to see my fa -- ther,
  I'm go -- ing there no more to roam;
  %% CHORUS
  \l I'm just a -- go -- in' o -- ver Jor -- dan,
  I'm just a -- go -- in' o -- ver home.
}
verseB = \lyricmode {
  I know dark clouds will gath -- er round me,
  I know my path -- way's rough and steep,
  but gold -- en fields lie out be -- fore me,
  where wear -- y eyes no more shall weep.

  I'm go -- ing there to see my moth -- er,
  She said she'd meet me when I come;
  %% CHORUS
  \SB {
    I'm just a -- go -- in' o -- ver Jor -- dan,
    I'm just a -- go -- in' o -- ver home.
  }
}
verseC = \lyricmode {
  I'll soon be free from ev -- 'ry tri -- al.
  This form will rest be -- neath the sod.
  I'll drop the cross of self -- den -- i -- al,
  and en -- ter in my home with God.

  I'm go -- ing there to see my sav -- ior,
  to sing his praise for -- ev -- er -- more;
  %% CHORUS
  \SC {
    I'm just a -- go -- in' o -- ver Jor -- dan,
    I'm just a -- go -- in' o -- ver home.
  }
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"