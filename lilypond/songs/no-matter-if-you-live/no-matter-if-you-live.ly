\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Old Indian song"
arranger = \smallText "arr. Frédéric Mathil, 1950"
meter = \smallText "INDIA 10.10.10.10"
hymnKey = \key e \minor
hymnTime = \time 2/2
quarternoteTempo = 160
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "No matter if you live now far or near"
poet = \smallText "Text: Metta Sutta, from Sutta Nipata, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english secular 4part"
dateAdded = "2021-03-23"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 fs4 | e2 4( fs) | g2. e4 | a a g fs | g2. fs4 | } \break
  \relative g' { e2 4( fs) | g2. e4 | g g e d | e2. c'4 | 2 b |} \break
  \relative g' { c2. a4 | b4. a8 g4 fs | g2. fs4 | 4 e fs g | e2. 4 } \break
  \relative g' { g2 a | e2. fs4 | 4 e fs g | e2. 4 | g( fs) g( fs) | \partial 2. e2. | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { b4 | 2 c | b2. e4 | 4 4 4 d | e2. fs4 }
  \relative e' { e4( b) c2 | b2. 4 | a c b b | 2. c4 | d2 2 | }
  \relative e' { e2. fs4 | d4. 8 b c d4 | 2. c4 | d c a d | b2. c4 }
  \relative e' { e2 2 | b2. d4 | c e d d | b2. e4 | e2 d4( b) | b2. }
}
tenor = {
  \globalParts
  \relative a { b4 | g2 a | g2. b4 | c a b b | 2. 4 | }
  \relative a { b4( g) a2 | g2. 4 | e e g fs | g2. 4 | a2 g | }
  \relative a { g2. fs4 | 4. g8 4 a | b2. c4 | b g fs b | g2. a4 | }
  \relative a { b( c) c( a) | g2. b4 | c a d b | g2. b4 | c( a) b4.( fs8) | g2. | }
}
bass = {
  \globalParts
  \relative d { b4 | e2 a, | e'2. 4 | a, c b b | e2. b'4 }
  \relative d { e2 a, | e'2. 4 | c a b b | e2. 4 | fs2 g | }
  \relative d { c2. d4 b4. e8 4 d | g,2. a4 | b c d b | e2. a4 }
  \relative d { e( c) a( c) | e2. b4 | a c b b | e2. g,4 | a( c) b2 | e2. }
}

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l No mat -- ter if you live now far or near,
  no \l mat -- ter what your weak -- ness or your strength,
  there is not \l one a -- live we count out -- side.
  May deep -- er joy for all now \l come at length,
  may deep -- er joy for all now come at length.
}
verseB = \tag #'verseB \lyricmode {
  Let none a -- mong us lie or self -- de -- ceive;
  nor cul -- ti -- vate a ha -- tred all or part,
  may nev -- er one of us live by our rage
  nor wish an -- oth -- er in -- ju -- ry of heart,
  nor wish an -- oth -- er in -- ju -- ry of heart.
}
verseC = \tag #'verseC \lyricmode {
  Just as the good -- ly moth -- er will pro -- tect
  her child -- ren, e'en at risk of her own life,
  so may we nur -- ture an old mind -- ful -- ness,
  a bound -- less heart be -- yond all fear and strife,
  a bound -- less heart be -- yond all fear and strife.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
