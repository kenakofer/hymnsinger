\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% Otherwise set up tune info here:
composer = \smallText "Music: Johann A. P. Schulz, 1800"
meter = \smallText "WIR PFLÜGEN 76.76 D with refrain"
hymnKey = \key a \major
hymnTime = \time 4/4
quarternoteTempo = 140
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "We plow the fields and scatter"
poet = \twoLineSmallText "Text: Matthias Claudius, 1782" "tr. Jane M. Campbell, 1861, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english theist 4part"
dateAdded = "2021-05-07"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 e4 | a a e e | cs'2 a4 e | d cs b a | e'2. \bar "" \break
    a4 | gs fs e cs' | b( a) gs e | fs cs' b ds, | e2. \bar "" \break
    e4 | b' b cs cs | d2 b4 4 | e e d cs | b2. \bar "" \break
    e,4 | a a e e | fs2 cs4 4 | d4. b8 e4 gs | a1 \bar "||" \break

    a4 4 4 4 | b2 4 4 | cs4. e8 d4 cs | b2. \bar "" \break
    b4 | cs b cs4. b8 | a4 gs a4. e8 | fs4( b a) gs | \partial 2. a2.
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    e4 | a a e e | cs'2 a4 e | d cs b a | e'2.
    e4 | e ds e e | e( ds) e e | e e ds b | 2.
    e4 | e e e e | fs2 4 gs | a e gs a | gs2.
    e4 | a a e e | fs2 cs4 4 | d4. b8 e4 d | cs1

    cs4 4 e e | 2 4 gs | a4. 8 gs4 a | gs2.
    e4 | 4 4 4. gs8 | fs4 es fs4. e8 | d4( fs e) e | 2.
  }
}
tenor = {
  \globalParts
  \relative a {
    e4 | a a e e | cs'2 a4 e | d cs b a | e'2.
    a4 | b b b a | gs( fs) e b' | cs a a a | gs2.
    e4 | gs gs a a | a2 gs4 e' | e cs d e | 2.
    e,4 | a a e e | fs2 cs4 4 | d4. b8 e4 b' | a1

    e4 4 a cs | gs2 4 e' | 4. cs8 d4 e | 2.
    gs,4 | a gs a4. e'8 | cs4 4 4. a8 | a4( d cs) b | cs2.
  }
}
bass = {
  \globalParts
  \relative d {
    e4 | a a e e | cs'2 a4 e | d cs b a | e'2.
    cs4 | b a gs a | b2 cs4 gs | a a b b | e2.
    e4 | d d cs cs | b2 e4 d | cs cs' b a | e2.
    e4 | a a e e | fs2 cs4 4 | d4. b8 e4 e | a,1

    a4 e' cs a | e'2 4 4 | a4. cs8 b4 a | e2.
    4 | a e a4. e8 | fs4 cs fs4. cs8 | d4( b e) e | a,2.
  }
}

%% LYRICS
verseA = \lyricmode {
  \l We plow the fields and scat -- ter the good seed on the land,
  \l but it is fed and wa -- tered by God's al -- might -- y hand.
  \l God sends the snow in win -- ter, the warmth to swell the grain,
  \l the breez -- es, and the sun -- shine, and soft re -- fresh -- ing rain.
  %% CHORUS
  All good gifts a -- round us are sent from heav'n a -- bove.
  We thank you, God, we thank you, God, for all your love.
}
verseB = \lyricmode {
  You on -- ly are the Mak -- er of all things near and far.
  You paint the way -- side flow -- er, you light the eve -- ning star.
  The winds and waves o -- bey you, by you the birds are fed;
  much more to us, your chil -- dren, you give our da -- ly bread.
  %% CHORUS
  \SB {
    All good gifts a -- round us are sent from heav'n a -- bove.
    We thank you, God, we thank you, God, for all your love.
  }
}
verseC = \lyricmode {
  We thank you, then, Cre -- a -- tor, for all things bright and good,
  the seed -- time, and the har -- vest, our life, our health, our food.
  Ac -- cept the gifts we of -- fer for all your love im -- parts,
  and what you most would wel -- come: our hum -- ble thank -- ful hearts.
  %% CHORUS
  \SC {
    All good gifts a -- round us are sent from heav'n a -- bove.
    We thank you, God, we thank you, God, for all your love.
  }
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"