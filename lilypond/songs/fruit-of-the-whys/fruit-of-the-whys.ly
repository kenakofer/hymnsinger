\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Kenan Schaefkofer, 2022"
meter = \smallText "EXCELLENT QUESTION 11.11.11.11 with refrain"
hymnKey = \key f \major
hymnTime = \time 6/8
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/8)
hymnBeatStructure = \set Timing.beatStructure = 3,3
quarternoteTempo = 80
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Fruit of the Whys"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Kenan Schaefkofer, 2022"
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 5
tags = "english secular 3part"
dateAdded = "2022-05-12"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \transpose g f {
  \relative g' {
    \partial 8
    g8 | g8 8 8 b a g | e d c d4 \bar "" \break
    fs8 | g8 8 8 b a g | c8 8 8 fs,4 \bar "" \break
    fs8 | g8 8 8 b a g | c b c cs4 \bar "" \break
    cs8 | d8 8 8 c b a | fs8 g a g4. \bar "||" \break

    r4. r4 g8 | b a g fs e fs | g fs e b'4 \bar "" \break
    b8 | d8. 16 8 c b a | fs g a g4 \bar "||" \break

    g8 | fs8 d fs f f f |  e8 c e fs4 \bar "" \break
    fs8 | f d f e e e | e8 c e fs4 \bar "" \break

    fs8 | g8. 16 8 b a g | g8 8 8 4 \bar "" \break
    g8 | fs8 8 g a a fs | g g a bf( b) \bar "" \break

    g8 | fs8 d fs f f f |  e8 c e fs4 \bar "" \break
    fs8 | f8 d f e e e | e8 c e fs4 \bar "" \break

    fs16 16 | g8. 16 8 b a g | g8 8 8 4.~ | 4.~ 4 \bar "" \break

    g8 | d'8 8 8 c b a | fs g a g4 \bar "||" \break
  }
  }
}
alto = {
  \globalParts
  \transpose g f {
  \relative e' {

  }
  }
}
tenor = {
  \globalParts
  \transpose g f {
  \relative a {
    g8 | b8 8 8 8 8 8 | c8 8 8 a4
    a8 | b8 8 8 8 8 8 | c8 8 8 a4
    a8 | b8 8 8 8 8 8 | c c c a4
    g8 | fs8 8 8 8 8 8 | a8 8 8 b4.

    r4. r4 b8 | g8 a8 b8 b8 8 8 | e e e ds4
    ds!8 | d!8. 16 8 8 8 8 | a8 8 8 b4

    b8 | a8 8 8 bf8 8 8 | g8 8 8 a4
    a8 | bf8 8 8 g8 8 8 | g8 8 8 a4
    a8 | b8. 16 8 d8 8 8 | c8 d8 ef8 ef4
    ef8 | d8 a8 8 8 8 8 | g8 8 8 4

    g8 | a8 8 8 bf8 8 8 | g8 8 8 a4
    a8 | bf8 8 8 g8 8 8 | g8 8 8 a4
    a16 16 | b8. 16 8 8 8 8 | bf8 8 8 bf4.( | c4.~ 4)
    c8 | b8 8 8 a8 8 8 | a8 8 8 b4

  }
  }
}
bass = {
  \globalParts
  \transpose g f {
  \relative d {
    g8 | 8 8 8 8 8 8 | c,8 8 e8 d4
    d8 | g8 8 8 8 8 8 | e8 8 8 d4
    d8 | g8 8 8 8 8 8 | 8 8 8 e4
    e8 | d8 8 8 8 8 8 | 8 8 8 g4. |

    r4. r4 g8 | e8 8 8 d8 8 8 | c8 8 8 b4
    b'8 | a8. 16 8 8 8 8 | d,8 8 8 g4

    g8 | d8 8 8 8 8 8 | c c c d4
    d8 | d8 8 8 c c c | c c c d4
    d8 | g8. 16 8 g g g | c,8 8 8 4
    c8 | d8 8 8 8 8 8 | g8 8 8 g4

    g8 | d8 8 8 8 8 8 | c c c d4
    d8 | d8 8 8 c c c | c c c d4
    d16 16 | g8. 16 8 d8 8 8 | ef8 8 8 4.~ | 4.~ 4
    c8 | d8 8 8 8 8 8 | 8 8 8 g4


  }
  }
}

chordSymbols = \chordmode {
  \globalChordSymbols
  \transpose g f {
  s8 | g2. | c4. d4. |
     | g2. | c4. d4. |
     | g2. | c4. a4. |
     | d2. | d4. g4. |

     | e2.:m | 2. | a4.:m7 b4. |
     | d2. | d4. g4. |

     | d4. bf4. | c4. d4. |
     | bf4. c4. | c4. d4. |
     | g2. | c2.:m7 |
     | d2. | g2. |

     | d4. bf4. | c4. d4. |
     | bf4. c4. | c4. d4. |

     | g2. | ef2. | c2.:m |
     | g4.:/d d4. | d4. g4. |

  }
}

songChords =
<<
% \new ChordNames {
%   \set instrumentName = ""
%   \override ChordNames.ChordName.color = #white
%   \chordmode { a1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 }
% }
\new ChordNames {
  \once \override InstrumentName.extra-offset = #'(10 . 0.7)
  \override ChordNames.ChordName.font-shape = #'italic
  \override ChordNames.ChordName.font-size = #-1
  \set instrumentName = \markup { \italic "Capo 1:" }
  \transpose f e \chordSymbols
}
\new ChordNames {
  \set instrumentName = ""
  \chordSymbols
}
>>

%% LYRICS
verseA = \lyricmode {
  \l The Whys as a fam -- 'ly seem odd at first glance,
  \l They're farm -- ers at -- temp -- ting to kill all their plants.
  \l When har -- vest day comes, af -- ter all that ab -- use,
  \l the veg -- gies sur -- vi -- ving can real -- ly pro -- duce!
  \hideVerseNumberAtLineStart

  %% CHORUS
  Oh, how do the Whys grow what -- ev -- er they do?
  An ex -- cel -- lent ques -- tion! Here's what they'll tell you:

  We flood in the night and we burn in the day.
  In eve -- ning and morn -- ing we're hack -- ing a -- way.
  We suf -- fer no beet leaf to stay past its prime,
  or give ten -- der stems just a lit -- tle more time.
  Yes, some will sur -- vive, but we know not yet which!
  The ones that do, thrive, and have made us quite rich.
  With re -- spect to all farm -- ers, re -- gard -- ing their crops,
  too man -- y col -- lapse when the pam -- per -- ing stops!

}
verseB = \lyricmode {
  The Whys sow with each seed a ker -- nel of doubt.
  They trust a few neigh -- bors, but nev -- er a sprout,
  cause folk round these parts grow the darn -- dest of things,
  but Whys plant a seed just to test what it brings!
}
verseC = \lyricmode {
  An oak tree, un -- yield -- ing two -- hun -- dred years back,
  was fin -- al -- ly felled af -- ter man -- y a whack.
  You might think it cold, but they shed not a tear.
  The stump made a bed for new growth to ap -- pear!
}
verseD = \lyricmode {
  A guy once came by sell -- ing Mag -- ic -- al Stalk™.
  The Whys took one look and said, ''That's just a rock!
  Un -- liv -- ing, un -- kill -- a -- ble, won't give a yield.
  It's not worth the space it would take in our field!''
}
verseE = \lyricmode {
  To be like the Whys, you must take things a -- part.
  To chal -- lenge my stor -- y's a great place to start!
  "If this" her -- bal an -- al -- o -- gy with -- ers and dies,
  I still think it's true you'll find truth in the Whys!
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/5verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"