\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"
\header {
  title = \titleText "Come, thou long-expected Jesus"
  subtitle = \smallText "From Hymnal: A Worship Book #178"
  composer = \smallText "Music: Arranged by Ralph Vaughn Williams"
  poet = \smallText "Charles Wesley"
  meter = \smallText "87.87 D"
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
  \relative g' {} \break
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
  \relative a {}
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
  Breth -- ren _  we have met to _ wor -- _ ship _ and a -- _ dore the Lord our God.
  Will you _ pray with all your _ pow -- _ er _ while we _ try to preach the word?
}
verseB = \lyricmode {

}
verseC = \lyricmode {

}
verseD = \lyricmode {

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
  \score {
    \fillTradScore \soprano \alto \tenor \bass
  }
}

% %Traditional with shaped noteheads (broken on non-combined chords)
\book {
  \score {
    \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass}
  }
}

%% Clairnotes Notation
\book {
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

