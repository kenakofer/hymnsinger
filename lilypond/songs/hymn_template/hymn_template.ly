\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"
\header {
  title = \titleText "Title goes here"
  subtitle = \smallText "Optionally where this is pulled from"
  composer = \smallText "Music: Where music from"
  poet = \smallText "Text: Where text from"
  meter = \smallText "Meter goes here, e.g. 87.87 D"
  copyright =\smallText "Public Domain. Free to distribute, modify, and perform. Typeset by Kenan Schaefkofer."
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key c \major
hymnTime = \time 4/4
%% Adjust these to fix beaming
%hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/4)
%hymnBeatStructure = \set Timing.beatStructure = 1,1,1,1
%hymnBeatExceptions = \set Timing.beamExceptions = #'()
globalParts = {
  \hymnKey
  \hymnTime
  \hymnBaseMoment
  \hymnBeatStructure
  \hymnBeamExceptions
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { c4 d e f} \break
  \relative g' {} \break
  \relative g' {} \break
  \relative g' {}\break
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
%verseE = \lyricmode { }
%verseF = \lyricmode { }

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Uncomment what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  %\new Lyrics  \lyricsto soprano  { \globalLyrics "5" "5" \verseE }
  %\new Lyrics  \lyricsto soprano  { \globalLyrics "6" "6" \verseF }
>>

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into 
%% a lower staff.

%% Traditional notation
\book {
  \bookOutputSuffix "trad"
  \score {
    \fillTradScore \soprano \alto \tenor \bass
  }
}

% %Traditional with shaped noteheads (broken on non-combined chords)
\book {
  \bookOutputSuffix "shapenote"
  \score {
    \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass}
  }
}

%% Clairnotes Notation
\book {
  \bookOutputSuffix "clairnote"
  \score {
    \fillClairScore \soprano \alto \tenor \bass
  }
}

%% MIDI output
\score {
  <<
    \soprano
    \alto
    \tenor
    \bass
  >>
  \midi {
    \context {
      \Staff
      \remove "Staff_performer"
    }
    \context {
      \Voice
      \consists "Staff_performer"
    }
    \tempo  4 = 130
  }
}

