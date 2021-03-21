\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Johann G. Nägeli, 1828; arr. Lowell Mason, 1845"
%arranger = \smallText "arr. (optional), year"
meter = \smallText "DENNIS SM"
hymnKey = \key f \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Blest be the tie that binds"
%subtitle = \smallText "Optional"
poet = \smallText "Text: John Fawcett, 1782, alt."
copyright = \public_domain_notice "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-03-09"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 a4 | a( f) a | g( e) g | f2 4 | f( d) f | f( c) f | \partial 2 e2 \bar "" } \break
  \relative g' { \partial 4 g4 | g( e) g | f( a) c | c( g) bf | a( c) d | c( a) bf | a( f) g | \partial 2 f2 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f( c) f | e( c) e | c2 ef4 | d( bf) d | c( a) c | c2 }
  \relative e' { e4 | e( c) e | f2 4 | e2 4 | f2 4 | 2 4 | 2 e4 | c2 }
}
tenor = {
  \globalParts
  \relative a { c4 | c4( a) c | c( g) bf | a2 4 | bf( f) bf | a( f) a | g2 }
  \relative a { c4 | c( g) bf | a( c) a | g( c) c | c( a) bf | a( c) d | c( a) bf | a2 | }
}
bass = {
  \globalParts
  \relative d { f4 | 2 4 | c2 4 | f2 4 | bf,2 4 | f'2 4 | c2}
  \relative d { c4 | 2 4 | f2 4 | c2 4 | f2 4 | 2 bf,4 | c2 4 | f,2 |}
}
songChords = \chords {
  \globalChordSymbols
  s4 f2. c:7 f4 4 f:7 bf2. f c
  c2 c4:7 f2. c2 c4:7 f2 bf4/f f2 bf4 f2/c c4:7 f2
}

%% LYRICS
verseA = \lyricmode {
  \l Blest be the tie that binds our hearts in Chris -- tian love.
  \l The fel -- low -- ship of kin -- dred minds is like to that a -- bove.
}
verseB = \lyricmode {
  We share each oth -- er's woes, each oth -- er's bur -- dens bear,
  and of -- ten for each oth -- er flows the sym -- pa -- thiz -- ing tear.
}
verseC = \lyricmode {
  When we a -- sun -- der part, it gives us in -- ward pain,
  but we shall still be joined in heart, and hope to meet a -- gain.
}
verseD = \lyricmode {
  From sor -- row, toil, and pain, and sin we shall be free,
  and per -- fect love and friend -- ship reign through all e -- ter -- ni -- ty.
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
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"

