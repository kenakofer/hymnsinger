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
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Title of the song"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Author, year"
copyright = \public_domain_notice "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
tags = "theist 4part acapella 4verse musicbyother textbyother"
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

%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } \postscore_text }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } \postscore_text }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } \postscore_text }

%% MIDI output
\score {
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
    \new Staff \with { midiMaximumVolume = #0.7  } \alto
    \new Staff \with { midiMaximumVolume = #0.8  } \tenor
    \new Staff \with { midiMaximumVolume = #0.9 } \bass
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo  4 = 120
  }
}
