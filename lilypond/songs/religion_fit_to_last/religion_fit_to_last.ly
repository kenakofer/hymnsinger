\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: French folk melody"
meter = \smallText "JESOUS AHATONHIA (adapted) 86.86.76.86"
hymnKey = \key g \minor
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Religion fit to last"
arranger = \smallText "Arranged by Kenan Schaefkofer, 2021"
poet = \smallText "Text: Kenan Schaefkofer, 2021"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "secular 1part accompanied 5verse arrbykenan textbykenan"
dateAdded = "2021-01-12"
\include "../../lib/header.ly"

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


%% LYRICS
verseA = \lyricmode {
  A voice with -- in be -- comes dis -- tressed to see you taste the fruit,
  for -- bid -- den by your God and creed, res -- pec -- ted since your youth:
  ''Pro -- di -- gal, I'll fight in you, re -- store your faith to thrive.
  I'll bring you back with -- in the fold. With -- out you can't sur -- vive.
  With -- out you can't sur -- vive!''
}

extra_verses = \markup {
       \fontsize #-1.5

  \fill-line {
    \hspace #-25.0 % moves the column off the left margin;
     % can be removed if space on the page is tight
     \vspace #0

     \column {
      \line {
        \raise #3
        \bold "2."
        \raise #3
        \column { % LYRICS-START
"\"You'd loose the bond of family!\" your instinct diatribes."
"Decide: Be shunned to wilderness, or rest in harmless lies."
"Act against evolvéd traits? Your logic might agree,"
"but in your gut, you crave not truth, you crave community."
"You crave community!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "3."
        \column { % LYRICS-START
"If earthly fears don't move you, try a sample of Pascal:"
"A slim chance of eternal bliss is worth more than your all."
"Walk along the Roman Road, avoid eternal pain."
"Salvation's path is markéd well, with brimstone in the drain,"
"With brimstone in the drain:"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \raise #3
        \bold "4."
        \raise #3
        \column { % LYRICS-START
"Step one: believe, O wretch, your life is worthless, justly lost,"
"and second: faith's your only hope, at seemingly no cost!"
"Third, since faith is proved by work, pay up in duties due:"
"Two hands on plow, and don't look back, for Brother's watching you."
"Your God is watching you!"
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "5."
        \column { % LYRICS-START
"Mere reason of one mind can't win; the test of time is passed."
"Religions of today are the religions fit to last."
"Members true through power, fear, or friendly company"
"instill again in children's minds, \"Eat not from yonder tree.\""
"\"Eat not from yonder tree!\""
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

%% All sheet music outputs
clairStaffZoom = #.8
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"