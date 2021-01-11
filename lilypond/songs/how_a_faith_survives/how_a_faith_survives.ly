\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"
\header {
  title = \titleText "How a faith survives"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: French folk melody"
  arranger = \smallText "Arranged by Kenan Schaefkofer, 2021"
  poet = \smallText "Text: Kenan Schaefkofer, 2021"
  meter = \smallText "JESOUS AHATONHIA (adapted) 86.86.76.86"
  copyright =\smallText "Public Domain. Free to distribute, modify, and perform. Typeset by Kenan Schaefkofer."
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key g \minor
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
  \relative g' { \partial 4 d4 | g a bf c | bf a g f | g g a f | \partial 2. g2. \bar " " } \break
  \relative g' { \partial 4 d4 | g a bf c | bf a g f | g bf a f | g2. r4 } \break
  \relative g' { d'4 d a bf | c4. bf8 a4 a | bf a g g | \partial 2. a2( g4) \bar " " | } \break
  \relative g' { \partial 4 ef4 | d g g g | f4 ef d d | g4. g8 f4 d | \partial 2. g2 r4 \bar " " } \break
  \relative g' { \partial 4 a4 | bf c d d, | \partial 2. g2. | }
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 | d d c ef | d c bf c | d c ef c | d2. |}
  \relative e' { d4 | d d c ef | d c bf c | d d c ef | d2. r4 |}
  \relative e' { d4 d f g | g a e c | g' g d d | f2. |}
  \relative e' { r4 | r1 | r | r | r2 r4 |}
  \relative e' { f4 | g f8 g fs4 d | d2. |}
}
tenor = {
  \globalParts
  \relative a { g4 | d'4. 8 4 c | bf c d c | bf c d c | g2. |}
  \relative a { g4 | g a bf a | g a bf a | g f a c | d2. d8 c |}
  \relative a { g4. 8 a4 bf | c c, e f | g g bf d | d2 c4 |}
  \relative a { c4 | g g g g | g g bf a | g g g a | bf2 8 a |}
  \relative a { f4 | g a2 g8 a | bf2. |}
}
bass = {
  \globalParts
  \relative d { g,4 | <d d'>1 | <d d'>2. <c c'>4 | <d d'>2 <c c'> | g'2. |}
  \relative d { g,4 | <d d'>1 | <d d'>2. <c c'>4 | <d d'>2 <c c'> | g'1 |}
  \relative d { g,2 c4 d | g,2 a4 f | g2 a4 bf | c2 ef4 |}
  \relative d { ef4 | g,1 | af4 af g2 | g4 bf d f | g8 f ef2 d4 | g,4 g g g | g2. }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  I've grown con -- cerned as I look on. I see you doubt the truth,
  the cove -- nant that your faith, your church, im -- part -- ed in your youth.
  Pro -- di -- gal, I'll work in you, en -- sure your faith still thrive.
  I'll bring you back with -- in the fold. With -- out you can't sur -- vive.
  With -- out you can't sur -- vive!
}

extra_verses = \markup {
       \fontsize #-1.5

  \fill-line {
    %\hspace #0.1 % moves the column off the left margin;
     % can be removed if space on the page is tight
     \vspace #1

     \column {
      \line { \bold "2."
        \column { % LYRICS-START
"\"You doubt your very family!\" your instincts diatribe."
"Decide: Be shunned to wilderness, or live a harmless lie"
"Choose against evolvéd traits? Your logic may agree,"
"but I, your gut, crave not the truth, I crave community."
"I crave community!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "3."
        \column { % LYRICS-START
"Is instinct unpersuasive? Try a sample of Pascal:"
"A slim chance of eternal bliss is worth more than your all."
"Take a page from Paul's Epistles, dodge eternal pain."
"Salvation's path is markéd well, with brimstone in the drain."
"With brimstone in the drain!"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line { \bold "4."
        \column { % LYRICS-START
"To start: believe, O wretch, your life is worthless, justly lost,"
"and second: faith's your only hope, at seemingly no cost!"
"Third: pay up in duties due (for faith is proved by work)."
"Redeem more souls tomorrow. Brother's watching if you shirk."
"God's watching if you shirk!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "5."
        \column { % LYRICS-START
"Mere reason of one mind can't win; the test of time is passed."
"Religions of today are the religions fit to last."
"Members true through power, fear, or friendly company"
"instill again in children's minds, \"Don't eat from yonder tree.\""
"\"Don't eat from yonder tree!\""
        }
      }
    }
  \hspace #0.1 % gives some extra space on the right margin;
  % can be removed if page space is tight
  }
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
>>

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into 
%% a lower staff.

%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } \extra_verses }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } }

%% MIDI output
\score {
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
    \new Staff \with { midiMaximumVolume = #0.7 } \alto
    \new Staff \with { midiMaximumVolume = #0.8 } \tenor
    \new Staff \with { midiMaximumVolume = #0.9 } \bass
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo  4 = 120
  }
}


