\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
composer = \smallText "Music: George James Webb, 1837"
meter = \smallText "WEBB 76.76"
hymnKey = \key a \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ily"

%% SONG INFO
title = \titleText "Now is the time approaching"
poet = \smallText "Text: Jane Laurie Borthwick, 1859, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english secular 4part"
dateAdded = "2021-03-23"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 e4 | a4. 8 cs4 a | 2 fs4 a | e a b cs | b2. \bar "" } \break
  \relative g' { e4 | a4. 8 cs4 a | 2 fs4 a | e a cs b | a2. \bar "" } \break
  \relative g' { e4 | b'4. 8 a4 b | cs2 4 4 | d cs fs, b | a2( gs4) \bar "" } \break
  \relative g' { e4 | a4. 8 cs4 a | 2 fs4 a | e a cs b | \partial 2. a2. | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { cs4 | 4. 8 e4 4 | fs2 d4 fs | e e e e | e2. }
  \relative e' { e4 | cs4. 8 e4 e | fs2 d4 fs | e cs e d | cs2. }
  \relative e' { e4 | 4. 8 4 4 | 2 4 4 | d e fs fs | e2. }
  \relative e' { e4 | cs4. 8 e4 e | fs2 d4 fs | e cs e d | cs2. }
}
tenor = {
  \globalParts
  \relative a { a4 | 4. 8 4 4 | 2 4 4 | 4 4 gs a | gs2. }
  \relative a { gs4 | a4. 8 4 4 | 2 4 4 | 4 4 4 gs | a2. }
  \relative a { gs4 | 4. 8 a4 gs | a2 4 4 | 4 4 4 d | cs2( b4) }
  \relative a { gs4 | a4. 8 4 4 | 2 4 4 | 4 4 4 gs | a2. }
}
bass = {
  \globalParts
  \relative d { a4 | 4. 8 4 cs | d2 4 4 | cs4 4  b a | e'2. }
  \relative d { e4 | a,4. 8 4 cs | d2 4 4 | cs a e' e | a,2. }
  \relative d { e4 | 4. 8 cs4 e | a2 4 8 g | fs4 e d b | e2. }
  \relative d { e4 | a,4. 8 4 cs | d2 4 4 | cs a e' e | a,2. }
}

%% LYRICS
verseA = \lyricmode {
  \l Now is the time ap -- proach -- ing,
  by proph -- ets long fore -- told,
  \l when all shall dwell to -- geth -- er,
  se -- cure and man -- i -- fold.
  \l Let war be learned no long -- er,
  let strife and tu -- mult cease,
  \l all each a bless -- ed gard -- en,
  to please the god of peace.
}
verseB = \lyricmode {
  Let all that now di -- vides us re -- move and pass a -- way,
  like mists of ear -- ly morn -- ing
  be -- neath the blaze of day.
  Let all that now u -- nites us
  more sweet and last -- ing prove,
  a clos -- er bond of un -- ion, in bless -- ed lands of love.
}
verseC = \lyricmode {
  O long -- ex -- pect -- ed dawn -- ing,
  come with your cheer -- ing ray!
  Yet shall the prom -- ise beck -- on
  and lead us not a -- stray.
  O sweet an -- tic -- i -- pa -- tion!
  It cheers the watch -- ers on
  to pray, and hope, and la -- bor,
  till all our work is done.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output
\include "../../lib/slides_book_3verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"
