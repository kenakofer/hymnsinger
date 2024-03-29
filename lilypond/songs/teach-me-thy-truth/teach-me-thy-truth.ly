\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Walter E. Yoder, 1938"
meter = \smallText "GOSHEN CM"
hymnKey = \key f \major
hymnTime = \time 2/2
quarternoteTempo = 130
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Teach me thy truth"
poet = \smallText "Text: Edith Witmer, 1937, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-03-23"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 2 f2 | 4 bf a g | f2 g | a1 | 2 bf4 d | c2 b | \m c1 c2\fermata \bar "" \break
    \partial 2 a2 | bf4 c d e | f2 c | 1 | bf2 a4 f | 2 e | \m f1 f2\fermata \break
  }
  \bar "|."
}
alto = {
  \globalParts
  \relative e' {
    c2 | d4 f f d | c2 e | f1 | 2 4 4 | a2 f | \m e1 e2
    a | g4 f f g | f2 bf | a1 | f2 4 d | 2 c | \m c1 c2
  }
}
tenor = {
  \globalParts
  \relative a {
    a2 | 4 d c bf | a2 c | 1 | 2 bf4 f' | 2 d | \m c1 c2
    c2 | e4 c bf c | 2 e | f1 | d2 c4 a | b2 bf | \m a1 a2
  }
}
bass = {
  \globalParts
  \relative d {
    f2 | d4 bf f bf | c2 2 | f1 | 2 d4 bf | f'2 g | \m c,1 c2_\fermata
    f2 | g4 a bf4 4 | a2 g | f1 | bf,2 c4 d | g,2 c | \m f1 f2_\fermata
  }
}
%% LYRICS
verseA = \lyricmode {
  \l Teach me thy truth, O might -- y One,
  from sin, O set me free.
  \l Pre -- pare my life to fill its place
  in ser -- vice, God, for thee.
}
verseB = \lyricmode {
  Ac -- cept my tal -- ents, great or small,
  choose thou the path for me,
  where I shall la -- bor joy -- ous -- ly
  in ser -- vice, God, for thee.
}
verseC = \lyricmode {
  Help me to show thy glo -- rious way
  that leads in hope to thee,
  till oth -- er souls their joy shall find
  in ser -- vice, God, for thee.
}
verseD = \lyricmode {
  Grant me thy grace for ev -- 'ry task
  un -- til thy face I see,
  then ev -- er new shall be that joy
  in ser -- vice, God, for thee.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
