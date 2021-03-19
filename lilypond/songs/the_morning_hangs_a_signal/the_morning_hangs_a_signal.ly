\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: William Lloyd, 1840"
meter = \smallText "MEIRIONYDD 76.76 D"
hymnKey = \key d \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "The morning hangs a signal"
poet = \smallText "Text: William Channing Gannett (1768-1852), rev."
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 3
tags = "secular 4part musicbyother textbyother morning"
dateAdded = "2021-02-11"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 a8( g) | fs4 8( e) d4 e | fs2 4 a | g fs g8( fs) e4 | d2. \bar "" } \break
  \relative g' { a8( g) | fs4 8( e) d4 e | fs2 4 a | g fs g8( fs) e4 | d2. \bar "" } \break
  \relative g' { a4 | b4 a b cs | d2 a4 fs | a b a fs | e2. \bar "" } \break
  \relative g' { fs8( e) | d4 8( e) fs4 8( e) | fs4( gs) a d, | fs a g8( fs) e4 | \partial 2. d2. }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 | d d d cs | d2 4 4 | d d b cs | d2. }
  \relative e' { d4 | d d d cs | d2 4 fs | d d b cs | a2. }
  \relative e' { fs4 | g a g g | fs2 e4 d | cs4 b8 cs d4 d | cs2. }
  \relative e' { cs4 | d4 b8 cs d4 8 e | d2 cs4 d | d d d cs | a2. }
}
tenor = {
  \globalParts
  \relative a { fs8 g | a4 8 g fs4 a | a2 4 4 | b a g a | fs2. }
  \relative a { fs8 g | a4 8 g fs4 a | a2 b4 cs | b b g a | fs2. }
  \relative a { d4 | d d d e | d2 e4 a,4 | a4 g a a | a2. }
  \relative a { a8 g | fs4 8 a8 4 4 | a( d,) e fs | b a b a8 g | fs2. }
}
bass = {
  \globalParts
  \relative d { d4 | d d d a | d2 4 fs | g d e a, | d2. }
  \relative d { d4 | d d d a | d2 b4 fs | g b e, a | d2. }
  \relative d { d4 | g fs e a, | b2 cs4 d | fs4 g fs d | a2. }
  \relative d { a4 | b b8 a d4 8 cs | d4( b) a d | b fs g a | d2. }
}

%% LYRICS
verseA = \lyricmode {
  The morn -- ing hangs a sig -- nal up -- on the moun -- tain crest,
  while all the sleep -- ing val -- leys in si -- lent dark -- ness rest.
  From peak to peak it flash -- es, it laughs a -- long the sky,
  till glo -- ry of the sun -- light on all the land shall lie.
}
verseB = \lyricmode {
  A -- bove the gen -- er -- a -- tions the lone -- ly proph -- ets rise,
  while truth flares as the day -- star with -- in their glow -- ing eyes,
  and oth -- er eyes, be -- hold -- ing, are kin -- dled from that flame;
  and dawn be -- comes the morn -- ing, when proph -- ets love pro -- claim.
}
verseC = \lyricmode {
  The soul has lift -- ed mo -- ments, a -- bove the drift of days,
  when life's great mean -- ing break -- eth in sun -- rise on our ways.
  Be -- hold the ra -- diant to -- ken of truth a -- bove all fear;
  night shall re -- lease its splen -- dor that morn -- ing shall ap -- pear.
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
