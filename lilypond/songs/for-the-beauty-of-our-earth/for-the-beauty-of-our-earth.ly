\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
quarternoteTempo = 120
\include "../../shared-tunes/dix.ily"

%% SONG INFO
title = \titleText "For the beauty of our earth"
poet = \twoLineSmallText "Text: Folliott S. Pierpoint, 1864, alt." "v.5 Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 5
tags = "english secular 4part"
dateAdded = "2021-01-05"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l For the beau -- ty of our earth, for the glo -- ry of her skies,
  \l for the love which from our birth o -- ver and a -- round us lies:
  %% CHORUS
  Source of all, to thee we raise this our hymn of grate -- ful praise.
}
verseB = \lyricmode {
  For the beau -- ty of each hour of the day and of the night,
  hill and vale and tree and flow'r, sun and moon and stars of light:
  %% CHORUS
  \SB {
    Source of all, to thee we raise this our hymn of grate -- ful praise.
  }
}
verseC = \lyricmode {
  For the joy of ear and eye, for the heart and mind's de -- light,
  For the 'me', 'my -- self', and 'I', con -- scious links to sound and sight:
  %% CHORUS
  \SC {
    Source of all, to thee we raise this our hymn of grate -- ful praise.
  }
}
verseD = \lyricmode {
  For the joy of hu -- man care, sib -- ling, part -- ner, par -- ent, child,
  friends we've lost and friends still here, for all self -- less thoughts and mild:
  %% CHORUS
  \SD {
    Source of all, to thee we raise this our hymn of grate -- ful praise.
  }
}
verseE = \lyricmode {
  For thy Truth both harsh and kind, sha -- dowed set -- ter of our stage,
  pat -- terns sought by hu -- man mind, guid -- ing us from age to age,
  %% CHORUS
  \SE {
    Source of all, to thee we raise this our hymn of grate -- ful praise.
  }
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/5verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-5verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
