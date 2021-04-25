\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Michael Praetorius, 1609"
meter = \smallText "ES IST EIN ROS' 76.76.676"
hymnKey = \key f \major
hymnTime = \time 10/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Lo, how a Rose e'er blooming"
poet = \twoLineSmallText "Text: v.1-2 anonymous, 1599; v.3 Friedrich Layritz, 1599" "tr. v.1-2 Theodore Baker, 1894; v.3 Harriet Spaeth, 1875; alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part winter"
dateAdded = "2021-01-12"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative g' { c2 4 4 d c c2 a | bf a4 g2 f e4 f2 | } \break
  \relative g' { c2 4 4 d c c2 a | bf a4 g2 f e4 f2 | } \break
  \relative g' { r4 a4 g e \partial 1 f4 d c2 | \partial 1 r4 c'4 c c \bar " " | } \break
  \relative g' { d'4 c \partial 1 c2 a | bf a4 g2 f e4 \partial 1 f1 | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { a2 a4 f f f e2 d | d2 c d4. a8 c2 c | }
  \relative e' { a2 a4 f f f e2 d | d2 c d4. a8 c2 c | }
  \relative e' { r4 f d c c b c8( d e4) | r4 e4 g f | }
  \relative e' { f4 f e2 d | d2 f4 d( e) f( g) c, c1 | }
}
tenor = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative a { c2 c4 a bf a g2 f | f2 a4 c bf( a2) g4 a2 | }
  \relative a { c2 c4 a bf a g2 f | f2 a4 c bf( a2) g4 a2 | }
  \relative a { r4 c4 bf a a g g2 | r4 g4 g a | }
  \relative a { bf4 a g2 fs | g2 c4 bf a2 g a1 | }
  \relative a {}
}
bass = {
  \globalParts
  \relative d { f2 4 f bf f c2 d | bf f'4 e d2 c f, | }
  \relative d { f2 4 f bf f c2 d | bf f'4 e d2 c f, | }
  \relative d { r4 f4 g a f g c,2 | r4 c e f |}
  \relative d { bf4 f' c2 d | g,2 a4 bf c2 c f,1 | }
}


%% LYRICS
verseA = \lyricmode {
  \l Lo, how a Rose e'er bloom -- ing from ten -- der stem has sprung!
  \l Of Jes -- se's lin -- eage com -- ing as saints of old have sung.
  It came a flow'r -- et bright, a -- mid the \l cold of win -- ter,
  when half -- spent was the night.
}
verseB = \lyricmode {
  I -- sa -- iah 'twas fore -- told it, the Rose I have in mind.
  With Ma -- ry we be -- hold it, the vir -- gin moth -- er kind.
  To show God's love a -- right, she bore to us a Sav -- ior,
  when half -- spent was the night.
}
verseC = \lyricmode {
  Flow -- er, whose fra -- grance ten -- der with sweet -- ness fills the air,
  dis -- pel in glo -- rious splen -- dor the dark -- ness ev -- 'ry -- where.
  Hu -- man, yet ver -- y God, from sin and death he saves us,
  and light -- ens ev -- 'ry load.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
