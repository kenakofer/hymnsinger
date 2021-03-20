\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Pierre de Corbeil, harmonized Richard Redhead, 1853"
meter = \smallText "ORIENTIS PARTIBUS 87.87"
hymnKey = \key ef \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
verseCount = 3
tags = "english secular 4part textbyother spring"
title = \titleText "Lovelist of trees"
poet = \smallText "Text: A. E. Housman, 1896"
copyright = \public_domain_notice "Kenan Schaefkofer"
dateAdded = "2021-02-07"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { ef4 4 f | g2 ef4 | f2 d4 | ef2. | } \break
  \relative g' { bf2 4 | c2 g8( af) | bf2 4 | \partial 2 g2 \bar " " } \break
  \relative g' { \partial 4 g4 | g2 f4 | af2 g4 | f4( ef) f | g2. | } \break
  \relative g' { bf2 af4 | g2 ef4 | f2 d4 | ef2. | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { bf4 4 4 | bf2 4 | c2 bf4 | bf2. | }
  \relative e' { ef2 4 | ef2 4 | ef2 d4 | ef2 | }
  \relative e' { ef4 | bf2 4 | ef2 4 | c2 4 | d2. | }
  \relative e' { ef2 4 | d2 c4 | c2 bf4 | bf2. | }
}
tenor = {
  \globalParts
  \relative a { g2 af4 | bf2 4 | af2 f4 | g2. | }
  \relative a { g2 4 | af2 ef4 | f2 4 | g2 | }
  \relative a { g4 | bf2 4 | af2 bf4 | c2 4 | b2. | }
  \relative a { bf2 c4 | bf2 g4 | af2 f4 | g2. | }
}
bass = {
  \globalParts
  \relative d { ef2 4 | 2 g,4 | af2 bf4 | ef2. | }
  \relative d { ef2 4 | af,2 c4 | bf2 4 | ef2 | }
  \relative d { ef4 | ef2 d4 | c2 bf4 | af2 4 | g2. | }
  \relative d { g,2 af4 | bf2 c4 | af2 bf4 | ef2. | }
}

%% LYRICS
verseA = \lyricmode {
  Love -- liest of trees, the cher -- ry now,
  hung with bloom a -- long the bough,
  it stands a -- bout the wood -- land ride
  wear -- ing white for Eas -- ter -- tide.
}
verseB = \lyricmode {
  Now of my three -- score years and ten,
  twen -- ty will not come a -- gain.
  And take from sev'n -- ty springs a score,
  leav -- ing me just fif -- ty more.
}
verseC = \lyricmode {
  And since to look at things in bloom
  fif -- ty springs are lit -- tle room,
  a -- bout the wood -- lands I will go,
  see the cher -- ry hung with snow.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
