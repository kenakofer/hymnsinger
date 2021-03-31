\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Anonymous"
arranger = \smallText "arr. Anja and Kenan Schaefkofer, 2021"
meter = \smallText "BE STILL AND KNOW 8.8.8"
hymnKey = \key c \major
hymnTime = \time 3/4
quarternoteTempo = 100
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Receive our thanks"
subtitle = \smallText "Table Grace"
poet = \smallText "Text: Refugee Blessing, anon."
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english theist 4part"
dateAdded = "2021-03-28"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 g4 | g( e) a | g2 4 | g( d) f | e2 4 | e( f) g | a2 4 | \break
    a( b) c | b2 4 | c( g) a | g( e) f | e( c) d | c2. \bar "||" f | e
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    e4 | e( c) c | e2 4 | d2 4 | c2 c4 | c2 4 | c2 f4
    fs4( g) a | g2 g4 | g4( e) f | e( c) c4 | c2 b4 | c2. | 2. | 2.
  }
}
tenor = {
  \globalParts
  \relative a {
    c4 | c2 a4 | c2 c4 | b2 a4 | g2 4 | bf2 4 | a2 4
    c4( d4) d | 2 4 | c2 4 | c4( g) a | g2 g4 | e2. | a | c
  }
}
bass = {
  \globalParts
  \relative d {
    c4 | c2 f4 | c2 4 | g2 g4 | c2 4 | c2 4 | f2 c4
    d2 4 | g2 f4 | e4( c) c | c2 f,4 | g2 4 | c2. | f | c
  }
}
songChords = \chords {
  \globalChordSymbols
  c4 | c c f c c c g g g c c c c:7 c:7 c:7 f f f
  d:7 d:7 d:7 g g g c c f c c f c c g:7 c c c f f f c c c
}

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l Re -- ceive our thanks
  for night and day,
  for food and shel -- ter,
  rest and play,
  be here our guest,
  and with us stay.

  A -- men.
}

spacingVerse = \lyricmode {
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_1verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
