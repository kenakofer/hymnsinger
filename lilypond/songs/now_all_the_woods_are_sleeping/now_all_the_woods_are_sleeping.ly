\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Heinrich Isaac, 1539"
meter = \smallText "O WELT, ICH MUSS DICH LASSEN 776.778"
hymnKey = \key g \major
hymnTime = \time 6/2
quarternoteTempo = 140
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Now all the woods are sleeping"
poet = \twoLineSmallText "Text: Paul Gerhardt, 1648" "tr. and alt. Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english secular 4part evening"
dateAdded = "2021-01-16"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { g2 4 a b2 d c b | r4 b4 d c a2 b g fs | } \break
  \relative g' { r4 g4 a g fs g \partial 2 a2 | }
  \relative g' { r4 a4 g a b2 d c b | } \break
  \relative g' { r4 b d c a2 b g fs |}
  \relative g' { r4 d4 g a b2 c b \partial 1. a2 g1 | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d2 e4 fs g2 g g g | r4 d4 g e d2 d d4( cs) d2 | }
  \relative e' { r4 b4 e d d b d2 | }
  \relative e' { r4 fs4 e fs g2 d e4( fs) g2 | r4 g4 g g fs2 d d4( cs) d2 | }
  \relative e' { r4 d4 e e fs2 a g2. fs4 d1 }
}
tenor = {
  \globalParts
  \relative a { b2 4 d d2 d e d | r4 g,4 b c d2 b b4( g) a2 |}
  \relative a { r4 g4 e g a g fs2 | }
  \relative a { r4 d4 b c d2 b c d | r4 e4 d e d2 fs,2 g a | }
  \relative a { r4 a4 b c d2 e d d b1 | }
}
bass = {
  \globalParts
  \relative d { g2 e4 d g2 b c g | r4 g4 g a fs2 g e d |}
  \relative d { r4 e4 c b d e d2 | }
  \relative d { r4 d4 e a g2 b a g | r4 e4 b c d2 b e d |}
  \relative d { r4 fs4 e c b2 a b4( c) d2 g1 |}
}

%% LYRICS
verseA = \lyricmode {
  \l Now all the woods are sleep -- ing,
  the night and still -- ness creep -- ing
  \l o'er ci -- ty, field, and beast;
  but thou, my heart, a -- wake be,
  \l with pray'r -- ful thanks, at -- tend thee,
  to dear -- est Trea -- sures ere thou rest.
}
verseB = \lyricmode {
  Why Sun, are you re -- treat -- ing,
  and Moon, in dance, now lead -- ing
  the anc -- ient bal -- lad, Night?
  We set-tle down, we glist -- en,
  we laugh, and talk, and list -- en,
  re -- sound -- ing, gen -- tle notes of light.
}
verseC = \lyricmode {
  Now ob -- li -- ga -- tion ceas -- es,
  this Night the tired re -- leas -- es
  and bids you sleep be -- gin:
  My love, there comes a mor -- row
  shall set thee free from sor -- row,
  and all the anx -- ious toil with -- in.
}
verseD = \lyricmode {
  My loved ones, rest se -- cure -- ly,
  from ev -- 'ry per -- il sure -- ly
  pro -- tect -- ed be your heads;
  and hap -- py slum -- bers send you,
  and ev -- 'ry care at -- tend you,
  as trus -- ted souls watch o'er your beds.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ly"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_4verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
