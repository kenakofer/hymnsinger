\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
composer = \smallText "Music: Charles H. C. Zeuner, 1832"
meter = \smallText "MISSIONARY CHANT LM"
hymnKey = \key af \major
hymnTime = \time 3/4
quarternoteTempo = 80
\include "../../lib/global_parts.ily"

%% SONG INFO
title = \titleText "Let there be light"
poet = \smallText "Text: William M. Vories, 1909, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-04-03"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 2 r8 c8 8 8 | 4 af bf8 8 | g2 4 | af8 8 4 4 | c2 bf4 | c \bar "" \break
    \partial 2 r8 c8 c c | af4. 8 f f | ef4 r8 ef8 8 8 | af af g4 bf | \partial 4 af |
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    r8 ef8 8 8 | 4 4 f8 8 | ef2 4 | f8 8 4 4 | af2 g4 | af4
    r8 ef8 8 8 | f4. 8 df df | c4 r8 ef8 8 8 | 8 8 4 4 | 4

  }
}
tenor = {
  \globalParts
  \relative a {
    r8 c8 8 8 | 4 4 df8 8 | bf2 c4 | c8 8 4 4 | ef2 df4 | ef
    r8 af,8 8 8 | 4. 8 8 8 | 4 r8 c8 c c | c c bf4 df | c
  }
}
bass = {
  \globalParts
  \relative d {
    r8 af'8 8 8 | 4 4 df,8 8 | ef2 c4 | f8 8 4 4 | ef2 4 | af,
    r8 af8 8 8 | df4. 8 8 8 | af4 r8 af'8 8 8 | ef8 8 4 4 | af,
  }
}
songChords = \chords {
  \globalChordSymbols
  af4 af | af af bf:m ef ef ef f2.:m af4 af ef af
  af af df df df af af af af ef:7 ef:7 af
}

%% LYRICS
verseA = \lyricmode {
  \l Let there be light, O God of hosts!
  Let there be wis -- dom on the earth!
  \l Let broad hu -- man -- i -- ty have birth!
  Let there be deeds in -- stead of boasts.
}
verseB = \lyricmode {
  With -- in our pas -- sioned hearts in -- still
  the calm that end -- eth strain and strife.
  Make us your min -- is -- ters of life.
  Drive out the urge to curse and kill.
}
verseC = \lyricmode {
  Give us the peace of vi -- sion clear
  to see each oth -- er's good, our own,
  to joy and suf -- fer not a -- lone:
  the love that casts a -- side all fear.
}
verseD = \lyricmode {
  Let woe and waste of war -- fare cease,
  that use -- ful la -- bor yet may build
  its homes with love and laugh -- ter filled!
  God, give your way -- ward chil -- dren peace!
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides_book_4verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"
