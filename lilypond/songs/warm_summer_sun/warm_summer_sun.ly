\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Kenan Schaefkofer, 2021"
meter = \smallText "LIE LIGHT 88.88"
hymnKey = \key e \major
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Warm summer sun"
poet = \smallText "Text: Robert Richardson, alt. Mark Twain, 1896"
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "english secular 4part summer death"
dateAdded = "2021-01-30"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \stemUp
  \relative g' { b2 a4 gs | e1 | fs2 a4 gs | fs1 | } \break
  \relative g' {  b2 gs4 e | a2. cs4 | cs2. b4 | b1 | } \break
  \relative g' { b2 a4 gs | e2. 4 | a2. gs4 | \partial 2. fs2. \bar "" } \break
  \relative g' { \partial 4 b4 | b4 gs4 2~ | 4 r gs2 | a1 | gs1 | e1 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { e2 fs4 e | e1 | cs2 fs4 e | ds1 | }
  \relative e' { e2 4 4 | fs2. a4 | gs4( a) gs2 | fs1 | }
  \relative e' { e4( ds) cs bs | cs2. b4 | cs2. 4 | ds2. b'4 | }
  \relative e' { b'4 gs gs2~ | 4 r4 gs2 | fs1 | e2( ds) | e1 | }
}
tenor = {
  \globalParts
  \stemDown
  \relative a { r1 | b2 cs4 b | cs1 | b2 cs4 ds | }
  \relative a { b1 | a2 b4 cs | e2. cs4 | b cs ds2 | }
  \relative a { r1 | cs2 4 b | b4( a2) cs4 | b2. 4 | }
  \relative a { b4 b4 2~ | 4 r4 b2 | cs2( b4 a) | b1 | b1 | }
}
bass = {
  \globalParts
  \relative d { r1 | b'2 a4 gs4 | fs1 | fs4( gs) a b | }
  \relative d { gs1 | a2 gs4 e | cs2. cs4 | b4 b b2 | }
  \relative d { r1 | gs2 a4 gs | e2. e4 | b2. 4 | }
  \relative d { e4 e e2~ | 4 r4 e2 | cs1 | b1 | e1 | }
}


%% LYRICS
verseA = \tag #'verseA \lyricmode {
  Warm sum -- mer sun, shine kind -- ly here,
  Warm south -- ern wind, blow soft -- ly here,
  Green sod a -- bove, lie light, lie light.
  Good night, dear heart, good night, good night.
}
bottomA = \lyricmode {
  Warm sum -- mer sun, shine kind -- ly here,
  Warm south -- ern wind, blow soft -- ly here,
  Green sod a -- bove, lie light.
  Good night, dear heart, good night, good night.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
>>

bottom_verses = <<
  \new NullVoice = "bass" \bass
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \bottomA }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
