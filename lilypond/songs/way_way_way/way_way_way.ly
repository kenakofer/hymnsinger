\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: traditional Ojibwe lullaby; transcr. Frences Densmore, 1913"
meter = \smallText "WAY WAY WAY irregular"
hymnKey = \key e \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Way way way"
poet = \twoLineSmallText "Text: Ojibwe traditional, 1913;" "Additional phrases suggested by Mark MacDonald"
copyright = \public_domain_notice "Kenan Schaefkofer"
postscore_text = \postscoreText "Other lyrics from traditional prayers may be used: ''Alleluia,'' ''Christ have mercy,'' ''Kyrie eleison,'' ''Holy Spirit, Come''"
verseCount = 4
tags = "ojibwe secular 4part"
dateAdded = "2021-03-28"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    r4 e8 e fs4 gs | fs1 | r4 gs8 fs e4 cs | \break
    b1 | r4 b8 b cs4 e | e1 \bar "|."
  }
}
alto = { r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 r4 }
tenor = {}
bass = {}

%% LYRICS
verseA = \lyricmode {
  \l Way way way way way.
  Way way way way way.
  Way way way way way.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
