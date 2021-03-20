\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared_tunes/lasst_uns_erfreuen.ly"

%% Otherwise set up tune info here:
composer = \smallText "Music: Composer, year"
%arranger = \smallText "Arranged by (optional), year"
meter = \smallText "TUNE NAME METER"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Title of the song"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Author, year"
copyright = \public_domain_notice "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 4
tags = "english theist 4part musicbyother textbyother"
dateAdded = %YYYY-MM-DD%
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { c4 d e f} \break
  \relative g' {} \break
  \relative g' {} \break
  \relative g' {} \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' {}
  \relative e' {}
  \relative e' {}
  \relative e' {}
}
tenor = {
  \globalParts
  \relative a { a4 b c d }
  \relative a {}
  \relative a {}
  \relative a {}
}
bass = {
  \globalParts
  \relative d {}
  \relative d {}
  \relative d {}
  \relative d {}
}
songChords = \chords {
  \set chordChanges = ##t
  c2:7 g4:sus g:m
}

%% LYRICS
verseA = \lyricmode {
  Ly -- rics
}
verseB = \lyricmode {
  for each
}
verseC = \lyricmode {
  verse
}
verseD = \lyricmode {
  go here.
}
verseE = \lyricmode { }
verseF = \lyricmode { }

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "5" \verseE }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "6" "6" \verseF }
>>

%% All sheet music outputs
clairStaffZoom = #.9
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"