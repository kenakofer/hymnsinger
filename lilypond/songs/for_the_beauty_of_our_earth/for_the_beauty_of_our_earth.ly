\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
quarternoteTempo = 120
\include "../../shared_tunes/dix.ly"

%% SONG INFO
title = \titleText "For the beauty of our earth"
poet = \twoLineSmallText "Text: Folliott S. Pierpoint, 1864, alt." "v.5 Kenan Schaefkofer, 2021"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 5
tags = "english secular 4part"
dateAdded = "2021-01-05"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  \l For the beau -- ty of our earth, for the glo -- ry of her skies,
  \l for the love which from our birth o -- ver and a -- round us lies:
  %% CHORUS
  Source of all, to thee we raise this our hymn of grate -- ful praise.
}
verseB = \lyricmode {
  For the beau -- ty of each hour of the day and of the night,
  hill and vale and tree and flow'r, sun and moon and stars of light:
}
verseC = \lyricmode {
  For the joy of ear and eye, for the heart and mind's de -- light,
  For the 'me', 'my -- self', and 'I', con -- scious links to sound and sight:
}
verseD = \lyricmode {
  For the joy of hu -- man care, sib -- ling, part -- ner, par -- ent, child,
  friends we've lost and friends still here, for all self -- less thoughts and mild:
}
verseE = \lyricmode {
  For thy Truth both harsh and kind, sha -- dowed set -- ter of our stage,
  pat -- terns sought by hu -- man mind, guid -- ing us from age to age,
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "" \verseE }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
