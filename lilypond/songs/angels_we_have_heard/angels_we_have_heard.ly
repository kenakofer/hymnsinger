\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Traditional French carol, 1855"
meter = \smallText "GLORIA 77.77 with refrain"
hymnKey = \key f \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Angels we have heard on high"
poet = \twoLineSmallText "Text: Nouveau Recueil de Cantiques, 1855" "tr. anonymous, alt. Earl Marlatt, 1937"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part winter"
dateAdded = "2021-01-11"
\include "../../lib/header.ly"

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

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l An -- gels we have heard on high, sing -- ing sweet -- ly through the night,
  \l and the moun -- tains in re -- ply ech -- o -- ing their brave de -- light.
  %% CHORUS
  Glo -- ri -- a in ex -- cel -- sis De -- o, glo -- ri -- a in ex -- cel -- sis De -- o.
}
verseB = \tag #'verseB \lyricmode {
  Shep -- herds, why this ju -- bi -- lee? Why these songs of hap -- py cheer?
  What great bright -- ness did you see? What glad tid -- ings did you hear?
}
verseC = \tag #'verseC \lyricmode {
  Come to Beth -- le -- hem and see him whose birth the an -- gels sing.
  Come, a -- dore on bend -- ed knee Christ, the Lord, the new -- born King.
}
verseD = \tag #'verseD \lyricmode {
  See him in a man -- ger laid whom the an -- gels praise a -- bove.
  Ma -- ry, Jo -- seph, lend your aid, while we raise our hearts in love.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
>>

%% All sheet music outputs
clairStaffZoom = #.9
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_4verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"


