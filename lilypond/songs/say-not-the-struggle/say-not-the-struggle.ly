\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared-tunes/wayfaring-stranger.ily"
quarternoteTempo = 145

%% SONG INFO
title = \titleText "Say not the struggle naught availeth"
poet = \smallText "Text: Arthur Hugh Clough, 1849, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english secular 4part"
dateAdded = "2021-05-11"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Say not the strug -- gle naught a -- vail -- eth,
  the wounds and la -- bour are in vain,
  \l the fear -- some foe faints not, nor fail -- eth,
  and all un -- chang -- ing doth re -- main.
  %% CHORUS
  For not by east -- ern win -- dows on -- ly,
  when day -- light comes, comes in the light;
  in front the sun climbs slow, how slow -- ly,
  but west -- ward, look, the land is bright.
}
verseB = \lyricmode {
  If hopes were dupes, fears may be li -- ars.
  It may be, in yon smoke con -- cealed,
  our com -- rades chase e'en now the fli -- ers,
  and, but for us, pos -- sess the field.
  %% CHORUS
  \SB {
    For not by east -- ern win -- dows on -- ly,
    when day -- light comes, comes in the light;
    in front the sun climbs slow, how slow -- ly,
    but west -- ward, look, the land is bright.
  }
}
verseC = \lyricmode {
  For while the tired waves, vain -- ly break -- ing
  seem here no pain -- ful inch to gain,
  far back through creeks and in -- lets mak -- ing,
  comes sil -- ent, flood -- ing in, the main.

  %% CHORUS
  \SC {
    For not by east -- ern win -- dows on -- ly,
    when day -- light comes, comes in the light;
    in front the sun climbs slow, how slow -- ly,
    but west -- ward, look, the land is bright.
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