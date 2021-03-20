\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Joseph Bracket, 1848"
arranger = \smallText "Arranged by Kenan Schaefkofer, 2021"
meter = \smallText "SIMPLE GIFTS irregular"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 70
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "'Tis a gift to be simple"
poet = \smallText "Text: Joseph Bracket, 1848"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 1
tags = "english secular 4part arrbykenan textbyother"
dateAdded = "2021-01-10"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 c,8 c | f4 8 g a f a bf | c4 8 bf a4 g8 f | g4 g g f | \partial 2. g8 a g f c4 \bar " "} \break
  \relative g' { \partial 4 c,4 | f8 e f g a( f) a bf | c4 8( bf) a4 g8( f) | g4 8 8 a4 8 g | f4 8 8 f4 r } \break
  \relative g' { c2 a4. g8 | a bf a g f4. g8 | a4 8 bf c4 bf8 a | \partial 2. g4 g8 a g4 \bar " " } \break
  \relative g' {\partial 4 r8 c, | f2 a4. bf8 | c4 8 bf a4 g8 f | g4 g a4 8 g | \partial 2. f4 f f }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c8 8 | 4 d8 e f c f g | f4 8 8 f4 e8 d | c4 e e d4 | d8 d d d c4 }
  \relative e' { c | 8 c d e f4 8 g | a( g) f4 f4 f | f8( e) d d d4 e8 e | f4 d8 d c4 r }
  \relative e' { f2 f4. c8 | f8 f f e d4. e8 | f4 f8 g a4 f8 f | e4 8 f e4 |  }
  \relative e' { r8 c | c2 4. 8 | c8( d) e g f4 e8 f | f( e) d4 d e8 e | f4 d c | }
}
tenor = {
  \globalParts
  \relative a { c8 c | a4 8 c c a a g | a4 g8 g a4 bf8 bf | c4 c c8( bf) a4 | bf8 c bf g c( bf) |  }
  \relative a { a8( g) | f f a c c4 8 bf | a4 a4 a4 bf | g a8 g f4 a8 bf | bf8( a) g8 g a4 r | }
  \relative a { c2 4. 8 | a8 g a bf a4. bf8 | c4 8 bf a4 bf8 c | c4 8 8 4 |  }
  \relative a { r8 c | f,2 f8( g a) bf | c4 g8 g a4 bf8 a | g4 a8( g) f4 a8 bf | bf( a) g4 a4 | }
}
bass = {
  \globalParts
  \relative d { f8 f | f8( e) d c f f f c | f4 bf,8 8 c4 8 d | e4 c c c | g8 a bf b c4}
  \relative d { c4 | f8 f f c c4 c8 c | f4 e d c | bf d8 8 4 c8 c | bf4 8 8 f'4 r | }
  \relative d { f2 4. e8 | d8 d c c d4. c8 | f4 8 c f4 d8 d | c4 8 8 c4 | }
  \relative d { r8 c | bf8( c d e) f4. f8 | f4 c8 c d4 c8 8 | bf4 d4 4 c8 c | bf4 4 f4}
}

%% LYRICS
verseA = \lyricmode {
  'Tis a gift to be sim -- ple, 'tis a gift to be free,
  'tis a gift to come down where we ought to be.
  And when we find our -- selves in the place just right
  'twill be in the val -- ley of love and de -- light.

  When true sim -- pli -- ci -- ty is gained,
  to bow and to bend we will not be a -- shamed;
  to turn, turn, will be our de -- light,
  till by turn -- ing, turn -- ing we come round right.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
