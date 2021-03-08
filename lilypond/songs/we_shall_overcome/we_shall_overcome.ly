\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "secular 4part acapella 3verse arrbykenan textbyother"
\header {
  title = \titleText "We shall overcome"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: African-American Spiritual"
  arranger = \smallText "Arranged by Kenan Schaefkofer, 2021"
  poet = \smallText "Text: African-American Spiritual"
  meter = \smallText "WE SHALL OVERCOME (irregular)"
  copyright = \public_domain_notice "Kenan Schaefkofer"
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
  \numericTimeSignature
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { g4 g a a | g4.( f8 e2) | g4 g a a | g4.( f8 e2) | } \break
  \relative g' { g4 g a b | c2 d2 | b2( \tuplet 3/2 { a4 b a } | g2) a4( b) |  } \break
  \relative g' { c2 b4 a | g1 | a2 g4 f | e1 | g4 g c, f | e2 d | c1~ | 4 r4 r2 } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { e4 e f f | e4.( d8 c2) | e4 e f f | e4.( d8 c2) |}
  \relative e' { e4 e e gs | a4( g) fs2 | g4( d e2 | d2) f2 | }
  \relative e' { e2 g4 f | e1 | f2 d4 d | c1 |}
  \relative e' { c4 c c d | c2 b | c1~ | 4 r r2 | }
}
tenor = {
  \globalParts
  \relative a { c4 c c c | c4.( a8) g2 | c4 c c c | c4.( a8) g2 | }
  \relative a { c4 b a e | e4( a) a2 | b2( c | b) c4( b) | }
  \relative a { c2 b4 c | c4.( a8 g2) | c2 b4 b | a1 | g4 g a a | g2 g | g1~ | 4 }
  \relative a { }
}
bass = {
  \globalParts
  \relative d { c4 c f f | c1 | c4 c f, f | c'1 |}
  \relative d { c4 c c e | a,2 d | g1~ | g2 f4( g) }
  \relative d { c2 e4 c | c1 | f,2 g4 g | a1 | g'4 g f f | g2 g, | c1~ | 4 r r2 }
  \relative d {}
}
songChords = \chords {
  \set chordChanges = ##t
  c4 c f f c c c c | c c f f c c c c |
  c c a:m e | a:m a:m d d | g g f f | g2:7 f4 g:7 |
  c4 c e:m f | c c c c | f2 g:7 | a1:m | c4 c f f | c2 g2 | c1 |
}

%% LYRICS
verseA = \lyricmode {
  We shall o -- ver -- come,
  we shall o -- ver -- come,
  we shall o -- ver -- come some -- day!
  O deep in my heart
  I do be -- lieve
  we shall o -- ver -- come, some -- day!
}
verseB = \lyricmode {
}
verseC = \lyricmode {
}
verseD = \lyricmode {
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

extra_verses = \markup {
       \fontsize #-1.5

  \fill-line {
    \hspace #-40.0 % moves the column off the left margin;
     % can be removed if space on the page is tight
     \vspace #1

     \column {
      \line { \bold "2."
        \column { % LYRICS-START
"We'll walk hand in hand ... some day!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "3."
        \column { % LYRICS-START
"We shall live in peace … some day!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "4."
        \column { % LYRICS-START
"We are not afraid … today!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "5."
        \column { % LYRICS-START
"God will see us through ... some day!"
        }
      }
     }
  }
}


%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } \extra_verses }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } \extra_verses }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } \extra_verses }

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
    \tempo  4 = 100
  }
}
