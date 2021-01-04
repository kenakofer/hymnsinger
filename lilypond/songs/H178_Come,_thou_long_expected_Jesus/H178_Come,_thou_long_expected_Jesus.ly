\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/hyfrydol_public.ly"
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



%% NOTES
%% See included tune

%% LYRICS
verseA = \lyricmode {
  Come, thou long -- ex -- pect -- ed Je -- sus! born to set thy peo -- ple free,
  from our fears and sins re -- lease us, let us find our rest in thee.
  Is -- rael's strength and con -- so -- la -- tion, hope of all the earth thou art,
  dear de -- sire of ev -- ry na -- tion, joy of ev -- 'ry long -- ing heart.
}
verseB = \lyricmode {
  Born thy peo -- ple to de -- liv -- er, born a child, and yet a King,
  born to reign in us for -- ev -- er, now thy gra -- cious king -- dom bring.
  By thine own e -- ter -- nal Spir -- it, rule in all our hearts a -- lone.
  By thine all -- suf -- fi -- cient mer -- it, raise us to thy glo -- rious throne.
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
    \new Staff \with {
            midiMinimumVolume = #0.5  
            midiMaximumVolume = #0.9
    } \soprano
     \new Staff \with {
            midiMinimumVolume = #0.2
            midiMaximumVolume = #0.7  
    } \alto
     \new Staff \with {
            midiMinimumVolume = #0.4 
            midiMaximumVolume = #0.8  
    } \tenor
     \new Staff \with {
            midiMinimumVolume = #0.4
            midiMaximumVolume = #0.9
    } \bass
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
    \tempo  4 = 120
  }
}
