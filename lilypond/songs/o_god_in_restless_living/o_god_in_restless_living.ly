\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
\include "../../shared_tunes/rutherford.ily"

%% SONG INFO
title = \titleText "O God, in restless living"
poet = \smallText "Text: Harry Emerson Fosdick, 1931"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-04-25"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l O God in rest -- less liv -- ing
  we lose our spir -- it's peace.
  \l Calm our un -- wise con -- fu -- sion,
  bid thou our clam -- or cease.
  \l Let anx -- ious hearts grow qui -- et,
  like pools at eve -- ning still,
  \l till thy re -- flect -- ed heav -- ens
  all our spir -- its fill
}
verseB = \lyricmode {
  Teach us, be -- yond our striv -- ing,
  the rich re -- wards of rest
  Who does not live se -- rene -- ly
  is nev -- er deep -- ly bless'd.
  O tran -- quil, ra -- diant Sun -- light,
  bring thou our lives to flow'r,
  less wea -- ried with our ef -- fort,
  more a -- ware of pow'r.
}
verseC = \lyricmode {
  Re -- cep -- tive make our spir -- its,
  our need is to be still.
  As dawn fades flick -- 'ring can -- dle,
  so dim our anx -- ious will.
  Re -- veal thy ra -- diance through us,
  thine am -- ple strength re -- lease.
  Not ours, but thine the tri -- umph
  in the pow'r of peace.
}
verseD = \lyricmode {
  We grow not wise by strug -- gling,
  we gain but things by strain.
  We cease to wa -- ter gar -- dens
  when comes thy plen -- teous rain.
  O, beau -- ti -- fy our spir -- its
  in rest -- ful -- ness from strife,
  en -- rich our souls in se -- cret with a -- bun -- dant life.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides_book_4verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"