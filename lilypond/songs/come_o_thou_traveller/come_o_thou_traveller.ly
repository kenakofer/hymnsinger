\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "theist 1part accompanied 11verse arrbykenan textbyother"
\header {
  title = \titleText "Come, O thou Traveler unknown"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: American folk melody, 1805"
  arranger = \smallText "Arranged by Kenan Schaefkofer, 2018"
  poet = \smallText "Text: Charles Wesley, 1742"
  meter = \smallText "VERNON 88.88.88"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key d \minor
hymnTime = \time 4/4
%% Adjust these to fix beaming
%hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/4)
hymnBeatStructure = \set Timing.beatStructure = 2,2
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
  \relative g' { \partial 4 f4 | a a a g8( f) | a4 g8( f) d4. e16( f) | g4. a8 g4 d | f4 \partial 1 f8.( g16) f2. \bar " " | } \break
  \relative g' { \partial 4 f4 | a a a g8( f) | a4 g8( f) d4. e16( f) | g4. a8 g4 d | f4 \partial 1 f8.( g16) f2. \bar " " | } \break
  \relative g' { \partial 4 c4 | f4. e8 d4. c8 | d8( c) a( g) f4. g8 | a4 c d a8( g) | \partial 2. f4 d d | } \break
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
  \relative a { d,4 | d8 f a f d f d a | d f a f d f d a | g c e c g' e d g, | a d g a d2. |}
  \relative a { c,8 bf | a d f a f d a d | f d e bf' a d, e a | g c g d e c d a | f g a cs d2. |}
  \relative a { c,8 bf | c f, a c bf f bf c | f4 a d8 a f bf | c a g e f e d e | d4 a4 d, |}
}
bass = {
  \globalParts
  \relative d { d4 | d,1 | d1 | c1 | d2~ d2. |}
  \relative d { r4 | d,1 | d1 | c1 | d2~ d2. |}
  \relative d { r4 | f,2 f2 | d1 | f1 | d'4 a4 d, | }
}
songChords = \chords {

  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Come, O thou Trav -- el -- er un -- known, whom still, I hold, but can -- not see!
  My com -- pa -- ny be -- fore is gone, and I am left a -- lone with thee.
  With thee all night I mean to stay, and wres -- tle till the break of day.
}
verseB = \lyricmode {
  I need not tell thee who I am, my mis -- er -- y and sin de -- clare.
  Thy -- self has called me by my name, look on thy hands and read it there.
  But who, I ask thee, who art thou? Tell me thy name and tell me now.
}
verseC = \lyricmode { }
verseD = \lyricmode { }
verseE = \lyricmode { }
verseF = \lyricmode { }

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
>>

extra_verses = \markup {
       \fontsize #-1.5

  \fill-line {
     \column {
      \line { \bold "3"
        \column { % LYRICS-START
"In vain thou strugglest to get free;"
"I never will unloose my hold."
"Art thou the Man that died for me?"
"The secret of thy love unfold."
"Wrestling, I will not let thee go,"
"till I thy name, thy nature know."
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "4"
        \column { % LYRICS-START
"Wilt thou not yet to me reveal"
"thy new, unuerable name?"
"Tell me, I still beseech thee, tell,"
"to know it now resolved I am."
"Wrestling, I will not let thee go,"
"till I thy name, thy nature know."
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "5"
        \column { % LYRICS-START
"'Tis all in vain to hold thy tongue"
"or touch the hollow of my thigh."
"Though every sinew is unstrung,"
"out of my arms thou shalt not fly."
"Wrestling, I will not let thee go,"
"till I thy name, thy nature know."
        }
      }
    }
    \column {
      \line { \bold "6"
        \column { % LYRICS-START
"What though my shrinking flesh complain"
"and murmur to contend so long,"
"I rise superior to my pain;"
"when I am weak then I am strong,"
"and when my all of strength shall fail"
"I shall with the God-man prevail."
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "7"
        \column { % LYRICS-START
"My strength is gone, my nature dies,"
"I sink beneath thy weighty hand,"
"faint to revive, and fall to rise."
"I fall, and yet by faith AI stand,"
"I stand and will not let thee go,"
"till I thy name, thy nature know."
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "8"
        \column { % LYRICS-START
"Yield to me now - for I am weak"
"but confident in self-despair!"
"Speak to my heart, in blessing speak,"
"be conquered by my instant prayer."
"Speak, or thou never hence shalt move,"
"and tell me if thy name is Love."
        }
      }
    }
    \column {
      \line { \bold "9"
        \column { % LYRICS-START
"'Tis Love! 'tis Love! thou diedst for me,"
"I hear thy whisper in my heart."
"The morning breaks, the shadows flee,"
"pure, universal Love thou art."
"To me, to all, thy mercies move -"
"thy nature, and thy name is Love."
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "10"
        \column { % LYRICS-START
"My prayer hath power with God;"
"the grace unspeakable I now receive!"
"Through faith I see thee face to face,"
"I see thee face to face, and live!"
"In vain I have not wept and strove -"
"thy nature, and thy name is Love."
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "11"
        \column { % LYRICS-START
"Contented now upon my thigh"
"I halt, till life's short journey end."
"All helplessness, all weakness I"
"on thee alone for strength depend,"
"nor have I power from thee to move."
"Thy nature, and thy name is Love!"
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
    \tempo  4 = 120
  }
}
