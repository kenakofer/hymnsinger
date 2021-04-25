\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Kenyan traditional"
meter = \smallText "BWANA AWABARIKI irregular"
hymnKey = \key g \major
hymnTime = \time 4/4
quarternoteTempo = 80
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Bwana awabariki (May God grant you a blessing)"
poet = \smallText "Text: Swahili; Kenyan traditional; tr. anonymous"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "swahili english theist 4part"
dateAdded = "2021-04-23"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    d'4 b g16 8 16 8 8 | c8( b) a( g) a16 8 16 8 8 |
    d4 b g16 8 16 8 c | b4 a g r4 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    g8( a) g( fs) d16 8 16 e8 8 | g4 e fs16 8 16 8 8 |
    g8( a) g( fs) e16 8 16 8 g | g4 fs d r4 |
  }
}
tenor = {
  \globalParts
  \relative a {
    b8( c) d( c) b16 8 16 8 8 | e4 c d16 8 16 8 8 |
    b8( c) d( c) b16 8 16 8 e | d( e) d( c) b4 r4 |
  }
}
bass = {
  \globalParts
  \relative d {
    g4 d g16 8 16 8 8 | c,4 4 d16 8 16 8 8 |
    g4 d e16 8 16 8 c | d4 d g r4 |
  }
}
songChords = \chords {
  \globalChordSymbols
  g2. e4:m c2 d2
  g2 e4.:m c8 g4/d d:7 g
}

%% LYRICS
verseA = \lyricmode {
  \l Bwa -- na a -- wa -- ba -- ri -- ki, Bwa -- na a -- wa -- ba -- ri -- ki,
  \l Bwa -- na a -- wa -- ba -- ri -- ki, mi -- le -- le
}
verseB = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  May God grant you a bless -- ing, may God grant you a bless -- ing,
  may God grant you a bless -- ing, ev -- er -- more.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA } }
  \tag #'verseB { \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "" "" \verseB } }
>>

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"