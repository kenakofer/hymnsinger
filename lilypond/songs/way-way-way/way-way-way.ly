\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: traditional Ojibwe lullaby; transcr. Frences Densmore, 1913"
meter = \smallText "WAY WAY WAY irregular"
hymnKey = \key e \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Way way way"
poet = \twoLineSmallText "Text: Ojibwe traditional, 1913;" "Additional phrases suggested by Mark MacDonald"
typesetter = "Kenan Schaefkofer"
postscore_text = \postscoreText "Other lyrics from traditional prayers may be used: ''Alleluia,'' ''Christ have mercy,'' ''Kyrie eleison,'' ''Holy Spirit, Come''"
verseCount = 4
tags = "ojibwe secular 1part"
dateAdded = "2021-03-28"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    r4 e8 e fs4 gs | fs1 | r4 gs8 fs e4 cs | \break
    b1 | r4 b8 b cs4 e | e1 \bar "|."
  }
}
alto = { r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 }
tenor = {}
bass = {}

%% LYRICS
verseA = \lyricmode {
  \l Way way way way way.
  Way way way way way.
  Way way way way way.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/1verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-1verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
