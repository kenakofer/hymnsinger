\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
%\include "color_by_pitch.ly"

%% See docs/all_tags.txt for the full list available
tags = "theist 4part acapella 3verse musicbyother textbyother"
\header {
  title = \titleText "Great is thy faithfulness"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: William M. Runyan, 1923"
  poet = \smallText "Text: Thomas O. Chisholm, 1923"
  meter = \smallText "TUNE NAME AND METER E.G 87.87 D"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key ef \major
hymnTime = \time 3/4
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
  \relative g' { g4 g g | g4. f8 f4 | af af af | af g2 | } \break
  \relative g' { c4 d c | bf4. af8 g4 | f g a | bf2. | } \break
  \relative g' { bf4 c d | ef4. d8 c4 | bf af g | g f2 | } \break
  \relative g' { c4 d ef | ef4. bf8 4 | g g f | ef2. \bar "||" }\break

  \relative g' { bf4 4 f | af8. g16 2 | c4 c g | bf8. af16 2 | }\break
  \relative g' { bf4 c d  | ef bf c | d ef c | bf2. | }\break
  \relative g' { bf4 c d | ef4. d8 c4 | bf af g | g f2 | } \break
  \relative g' { c4 d ef | ef4. bf8 4 | g af d, | ef2. }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { ef4 4 4 | 4. 8 4 | d ef f | ef4 2 | }
  \relative e' { ef4 4 4 | 4. d8 ef4 | f e ef | d2. | }
  \relative e' { af4 4 4 | g4. bf8 af4 | g f ef | 4 2 | }
  \relative e' { fs4 4 4 | g4. 8 4 | ef d bf | 2. |}

  \relative e' { d4 d d | ef8. 16 2 | e4 e e | f8. 16 2 | }
  \relative e' { af4 4 4 | g g gf | f g ef | d2. | }
  \relative e' { af4 4 4 | g4. bf8 af4 | g f ef | 4 2 | }
  \relative e' { fs4 4 4 | g4. 8 4 | ef d bf | 2. |}
}
tenor = {
  \globalParts
  \relative a { bf4 4 b | c4. 8 4 | bf c d | c bf2 |}
  \relative a { af4 bf af | bf4. 8 4 | a bf c | bf2. | }
  \relative a { d4 d bf | 4. c8 d4 | ef c bf | c4 2 |}
  \relative a { ef'4 d c | bf4. ef8 4 | bf bf af | g2. | }

  \relative a { f4 f bf | c8. bf16 2 | bf4 g c | df8. c16 2 |}
  \relative a { d4 d bf | 4 4 4 | bf bf a | bf2. | }
  \relative a { d4 d bf | 4. c8 d4 | ef c bf | c4 2 |}
  \relative a { ef'4 d c | bf4. ef8 4 | bf f af | g2. | }
}
bass = {
  \globalParts
  \relative d { ef4 4 4 | af,4. 8 4 | bf4 4 4 | ef4 2 | }
  \relative d { af'4 4 4 | g4. f8 ef4 | c c f | bf,2. |}
  \relative d { bf'4 4 4 | ef,4. 8 4 | ef f g | af4 2 |}
  \relative d { a'4 a a | bf4. 8 4 | bf bf, bf | ef2. |}

  \relative d { bf4 4 4 | ef8. 16 2 | c4 4 4 | f8. 16 2 |}
  \relative d { bf'4 4 4 | ef, ef ef | f f f | bf,2. | }
  \relative d { bf'4 4 4 | ef,4. 8 4 | ef f g | af4 2 |}
  \relative d { a'4 a a | bf4. 8 4 | bf, bf bf | ef2. |}
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Great is thy faith -- ful -- ness, O God my Ma -- ker.
  There is no shad -- ow of turn -- ing with thee.
  Thou chang -- est not, they comp -- pas -- sions, they fail not.
  As thou hast been thou for -- ev -- er wilt be.
  %% CHORUS
  Great is thy faith -- ful -- ness! Great is thy faith -- ful -- ness!
  Morn -- ing by morn -- ing new mer -- cies I see.
  All I have need -- ed thy hand hath pro -- vid -- ed.
  Great is thy faith -- ful -- ness! Lord un -- to me!
}
verseB = \lyricmode {
  Sum -- mer and win -- ter, and spring -- time and har -- vest,
  sun, moon, and stars in their cours -- es a -- bove,
  join with all na -- ture in man -- i -- fold wit -- ness
  to thy great faith -- ful -- ness, mer -- cy, and love.
}
verseC = \lyricmode {
  Par -- don for sin and a peace that en -- dur -- eth,
  thine own dear pres -- ence to cheer and to guide,
  strength for to -- day and bright hope for to -- mor -- row;
  bless -- ings all mine, with ten thou -- sand be -- side!
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } }

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
