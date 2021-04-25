\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Perry L. Huffaker, 1950"
meter = \smallText "PINE GLEN 9.9.9.9"
hymnKey = \key c \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Move in our midst"
poet = \smallText "Text: Kenneth I. Morse, 1942"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-04-24"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    e4 4 4 | 2 4 | f e d c2. | g'4 g g | 2 4 | a g f | e2. | \break
    c4 e g | c2 g4 | b c d | c2. | c4 b a | g2 4 | b a g | c2. \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    c4 4 d | c2 4 | 4 4 b | c2. | b4 c d | e2 4 | f e b | c2. |
    c4 e g | e2 4 | f4 e f | e2. | c4 d ds | e2 g4 | g f f | <g e>2. |
  }
}
tenor = {
  \globalParts
  \relative a {
    g4 a b | g2 4 | a g f | e2. | g4 a b c2 4 | 4 b a | g2. |
    c,4 e g | c2 4 | d c b | c2. | g4 a b | c2 4 | d c b | <c g>2.
  }
}
bass = {
  \globalParts
  \relative d {
    c4 a g | c2 4 | f, g g | a2. | e'4 4 d | c2 4 | f g g, | c2. |
    c4 e g | c,2 4 | g'4 g gs | a2. | e4 f fs | g2 e4 | f g g, | c2. |
  }
}
songChords = \chords {
  \globalChordSymbols
  c4 c g c c c f f g a2.:m | e2:m g4 c c c f f g:7 c c c |
  c c c c c c g g g a2.:m | c4 c b:7/fs c2./g g:7 c
}

%% LYRICS
verseA = \lyricmode {
  \l Move in our midst, thou Spir -- it of God.
  Go with us down from thy ho -- ly hill.
  \l Walk with us through the storm and the calm.
  Spir -- it of God, go thou with us still.
}
verseB = \lyricmode {
  Touch thou our hands to lead us a -- right.
  Guide us for -- ev -- er, show us thy way.
  Trans -- form our dark -- ness in -- to thy light.
  Spir -- it of God, lead thou us to -- day.
}
verseC = \lyricmode {
  Strike from our feet the fet -- ters that bind.
  Lift from our lives the weight of our wrong.
  Teach us to love with heart, soul, and mind.
  Spir -- it of God, thy love makes us strong.
}
verseD = \lyricmode {
  Kin -- dle our hearts to burn with thy flame.
  Raise up thy ban -- ners high in this hour.
  Stir us to build new worlds in thy name.
  Spir -- it of God, O send us thy pow'r!
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"