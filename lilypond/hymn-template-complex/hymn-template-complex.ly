\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared-tunes/lasst-uns-erfreuen.ily"

%% Otherwise set up tune info here:
composer = \smallText "Music: Composer, year"
%arranger = \smallText "arr. Name, year"
%% Note: the meter variable requires a TUNE NAME, following by a meter, for page generation to work. See existing songs for examples
meter = \smallText "TUNE NAME meter"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Title of the song"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Author, year"
typesetter = "Kenan Schaefkofer"
prescore_text = \prescoreText "Uncomment to add text up and left of the score"
postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2024-12-31"
\include "../../lib/header.ily"

%% NOTES
sopA = {
  \relative g' {
    c4 d e f |
  }
}
sopB = {
  \relative g' {
    g'4 f e2 \bar ".|"
  }
}
sopC = {
  \relative g' {
    e'4 d c2 |
  }
}
% don't use '() for list, use (list ) instead'
#(define sop_list (list sopA sopB sopC))
#(define soprano (make-sequential-music (list 
  (list-ref sop_list 0) (list-ref sop_list 1) (list-ref sop_list 2))))
% \displayMusic { \soprano }

alto = {
  \relative e' {

  }
}
tenor = {
  \relative a {
    a4 b c d
  }
}
bass = {
  \relative d {

  }
}
songChords = \chords {
  \globalChordSymbols
  c2:7 g4:sus g:m
}




%% LYRICS
verseA = \lyricmode {
  \l Ly -- rics for each verse go here
}
verseB = \lyricmode {
  sing them loud and sing them clear
}
verseC = \lyricmode {
  its so cold this time of year
}
verseD = \lyricmode {
  Let us all sing, A _ -- men
}
verseE = \lyricmode { }
verseF = \lyricmode { }

% Set up music-aligned verses. Change to the correct number
% all verses is not used by slides, so I don't think it needs alterations
% \include "../../lib/4verse.ily"
all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC } }
  \tag #'verseD { \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD } }
>>
%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
% \include "../../lib/all-notation-outputs.ily"
% expands to
% \include "../../lib/traditional-book.ily"
% expands to
\book {
  \prescore_text
  \bookOutputSuffix "trad" \score {
    
    \removeWithTag #'(midionly slidesOnly)
    \fillTradScore
      { \removeWithTag #'(midionly slidesOnly) {\soprano} }
      { \removeWithTag #'(midionly slidesOnly) {\alto} }
      { \removeWithTag #'(midionly slidesOnly) {\tenor} }
      { \removeWithTag #'(midionly slidesOnly) {\bass} }
      \songChords
      \tradStaffZoom
  }
  \postscore_text
  \extra_verses
}
% Slides output. Change to the correct number
% \include "../../lib/slides-book-4verse.ily"
%% MIDI output
% \include "../../lib/midi-output.ily"
\score {
  \removeWithTag #'(slidesOnly printonly)
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
    \new Staff \with { midiMaximumVolume = #0.7  } \alto
    \new Staff \with { midiMaximumVolume = #0.8  } \tenor
    \new Staff \with { midiMaximumVolume = #0.9 } \bass
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo 4 = \quarternoteTempo
  }
}

\book {
  \bookOutputSuffix "A" \score {
  \removeWithTag #'(slidesOnly printonly)
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \sopA
    \new Staff \with { midiMaximumVolume = #0.7  } \alto
    \new Staff \with { midiMaximumVolume = #0.8  } \tenor
    \new Staff \with { midiMaximumVolume = #0.9 } \bass
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo 4 = \quarternoteTempo
  }
  }
}