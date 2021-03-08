\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 4verse musicbyother textbyother winter"
\header {
  title = \titleText "Angels we have heard on high"
  composer = \smallText "Music: Traditional French carol, 1855"
  poet = \smallText "Text: tr. anonymous, altered by Earl Marlatt, 1937"
  meter = \smallText "GLORIA 77.77 with refrain"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key f \major
hymnTime = \time 2/2
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
  \relative g' { a4 a a c | c4. bf8 a2 | a4 g a c | a4. g8 f2 | } \break
  \relative g' { a4 a a c | c4. bf8 a2 | a4 g a c | a4. g8 f2 | } \break
  \relative g' { c2( d8 c bf a | bf2 c8 bf a g | a2 bf8 a g f | g4.) c,8 c2 | }
  \relative g' { f4 g a bf | a2 g4 r4 | } \break
  \relative g' { c2( d8 c bf a | bf2 c8 bf a g | a2 bf8 a g f | g4.) c,8 c2 | } \break
  \relative g' { f4 g a bf | a2( g) | f1 }
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f e e | g e f2 | f4 e f f | f e f2 | }
  \relative e' { f4 f e e | g e f2 | f4 e f f | f e f2 | }
  \relative e' { f4( a8 g f2~ | f4 g8 f e2~ | e4 f8 e d2 | c4.) c8 c2 | }
  \relative e' { c4 e f g | f2 e4 r4 | }
  \relative e' { f4( a8 g f2~ | f4 g8 f e2~ | e4 f8 e d2 | c4.) c8 c2 | }
  \relative e' { c4 e f f | f2( e) | c1 | }
}
tenor = {
  \globalParts
  \relative a { c4 c c c | d c c2 | c4 c c c | c4. bf8 a2 | }
  \relative a { c4 c c c | d c c2 | c4 c c c | c4. bf8 a2 | }
  \relative a { a2( d2~ | d c~ | c bf | g4) f e2 |}
  \relative a { f4 c'4 c d | c2 4 r4 |}
  \relative a { a2( d2~ | d c~ | c bf | g4) f e2 |}
  \relative a { f4 c'4 c d | c2.( bf4) | a1 | }
}
bass = {
  \globalParts
  \relative d { f4 f a a | g c, f2 | f4 c f a | c c, f2 | }
  \relative d { f4 f a a | d, e f2 | f4 c f a,8 bf | c4 c f2 | }
  \relative d { f2( d4 f | g2 c,4 e | f2 bf,4 d | e) d c( bf) |}
  \relative d { a4 c f bf, | c2 4 r | }
  \relative d { f2( d4 f | g2 c,4 e | f2 bf,4 d | e) d c( bf) |}
  \relative d { a4 c f bf, | c1 | f1 | }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  An -- gels we have heard on high, sing -- ing sweet -- ly through the night,
  and the moun -- tains in re -- ply ech -- o -- ing their brave de -- light.
  %% CHORUS
  Glo -- ri -- a in ex -- cel -- sis De -- o, glo -- ri -- a in ex -- cel -- sis De -- o.
}
verseB = \lyricmode {
  Shep -- herds, why this je -- bi -- lee? Why these songs of hap -- py cheer?
  What great bright -- ness did you see? What glad tid -- ings did you hear?
}
verseC = \lyricmode {
  Come to Beth -- le -- hem and see him whose birth the an -- gels sing.
  Come, a -- dore on bend -- ed knee Christ, the Lord, the new -- born King.
}
verseD = \lyricmode {
  See him in a man -- ger laid whom the an -- gels praise a -- bove.
  Ma -- ry, Jo -- seph, lend your aid, while we rais our hearts in love.
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

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score {
  \layout {
    #(layout-set-staff-size 18)
  } \fillClairScore \soprano \alto \tenor \bass
} }

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
