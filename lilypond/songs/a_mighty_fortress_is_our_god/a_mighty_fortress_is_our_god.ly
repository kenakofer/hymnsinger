\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Martin Luther, 1529, 1531"
meter = \smallText "EIN FESTE BURG (rhythmic) 87.87.66.66.7"
hymnKey = \key c \major
hymnTime = \time 8/2
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "A mighty fortress is our God"
poet = \twoLineSmallText "Text: Martin Luther, 1529, 1531" "tr. Frederick H. Hedge, 1852"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-03-28"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative g' {
    \partial 2 r4 c | 2 2 g a4 c2( b4) a2 g r4 c | b2 a g a4 f2( e4 d2) c2 \bar "" \break
    \partial 2 r4 c' | 2 2 g a4 c2( b4) a2 g r4 c | b2 a g a4 f2( e4 d2) c2 \bar "" \break
    \partial 2 r4 c | e4.( f8) g4 a2( g) fs4 g2 \partial 2 r4 c,4 | g'2 g a b \partial 1 c2 r4 b4 | c2 b4 a2 a4 g2 \bar "" \break
    \partial 2 r4 a | a2 g4 a2 g4 \partial 1 e2 r4 c' | b2 a g a4 f2( e4 \partial 1 d2) c
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    r4 e | 2 2 2 f4 e2( g2) fs4 g2 r4 e | 2 c4.( d8) e2 c4 a2( c2 b4) c2
    r4 e | 2 2 2 f4 e2( g2) fs4 g2 r4 e | 2 c4.( d8) e2 c4 a2( c2 b4) c2
    r4 a | c2 b4 e2( d4) 2 2 r4 c4 b2 b f' d e2 r4 e4 c2 d4 d2 d4 b2
    r4 d | c2 e4 f2 d4 c2 r4 e4 2 c4.( d8) e2 4 d2( c b4) g2
  }
}
tenor = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative a {
    r4 c4 | g2 a b d4 c2( d4) d2 b r4 a g2 a c e,4 f2( g4~ 2) e2
    r4 c'4 | g2 a b d4 c2( d4) d2 b r4 a g2 a c e,4 f2( g4~ 2) e2
    r4 f4 | g2 4 c2( g4) a2 b r4 a4 g2 g f g g2 r4 g4 e2 g4 g2 fs4 g2
    r4 f4 a2 c4 2 b4 a2 r4 a g2 a c2 4 bf2( g2.) e2
  }
}
bass = {
  \globalParts
  \relative d {
    r4 c4 | 2 a e' d4 a'2( g4) d2 g r4 a4 e2 f c a4 d2( e4 g2) c,
    r4 c4 | 2 a e' d4 a'2( g4) d2 g r4 a4 e2 f c a4 d2( e4 g2) c,
    r4 f4 | c4.( d8) e4 a,2( b4) d2 g, r4 a4 e'2 e d g c,2 r4 e4 a,2 b4 d2 d4 g,2
    r4 d'4 f2 c4 f,2 g4 a2 r4 a4 e'2 f c a4 bf2( c4 g2) c
  }
}

%% LYRICS
verseA = \lyricmode {
  \l A might -- y for -- tress is our God,
  a bul -- wark nev -- er fail -- ing.
  Our help -- er he a -- mid the flood
  of mor -- tal ills pre -- vail -- ing,

  for still our an -- cient foe doth seek to work us woe.
  His craft and pow'r are great, and arm'd with cru -- el hate,
  on earth is not his e -- qual.
}
verseB = \lyricmode {
  Did we in our own strength con -- fide,
  our striv -- ing would be los -- ing,
  were not the right one on our side,
  the one of God's own choos -- ing.

  Dost ask who that may be? Christ Je -- sus, it is he!
  Lord Sab -- a -- oth, his name, from age to age the same,
  and he must win the bat -- tle.
}
verseC = \lyricmode {
  And though this world, with dev -- ils filled,
  should threat -- en to un -- do us,
  wo will not fear, for God hath willed
  his truth to tri -- umph through us.

  The prince of dark -- ness grim, we trem -- ble not for him.
  His rage we can en -- dure, for lo, his doom is sure.
  One lit -- tle word shall fell him.
}
verseD = \lyricmode {
  That word a -- bove all earth -- ly pow'rs,
  no thanks to them, a -- bid -- eth.
  The Spir -- it and the gifts are ours,
  through him who with us sid -- eth.

  Let goods and kin -- dred go, this mor -- tal life al -- so.
  The bod -- y they may kill, God's truth a -- bid -- eth still.
  His king -- dom is for -- ev -- er.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
>>

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
