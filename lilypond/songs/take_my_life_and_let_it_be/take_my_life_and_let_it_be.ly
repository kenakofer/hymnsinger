\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Henri Abraham César Malan, 1827"
arranger = \smallText "arr. Lowell Mason, 1841"
meter = \smallText "HENDON 77.77 extended"
hymnKey = \key g \major
hymnTime = \time 4/4
quarternoteTempo = 110
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Take my life, and let it be"
poet = \smallText "Text: Frances R. Havergal, 1874"
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 5
tags = "english theist 4part"
dateAdded = "2021-03-09"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { g4 4 8( d) g( b) | d4 c b2 | 4 4 8( a) c( a) | } \break
  \relative g' { g4 fs8( a) g2 | b4 b a4 8( b) | c4 d c( b) | \partial 2 d d \bar "" } \break
  \relative g' { \partial 2 e' d | 8( c) c( b) 4( a) | g4 a b c8( a) | g4 fs g2 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d4 d d d | 4 4 2 | 4 e e e | }
  \relative e' { d4 4 2 | g4 g fs fs8( g) | a4 b a( g) | g g }
  \relative e' { g g | a g g( fs) | g fs g e d d d2 | }
}
tenor = {
  \globalParts
  \relative a { b4 b b b | b a g2 | g4 g c c | }
  \relative a { b a8( c) b2 | d4 d d d | d d d2 | b4 b }
  \relative a { c b | d d d2 | b4 d d c | b a b2 | }
}
bass = {
  \globalParts
  \relative d { g4 g g g | d d g2 | g4 e c a | }
  \relative d { d4 d g,2 | g'4 g d d | d d g2 | g4 g }
  \relative d { c g' | fs g d2 | e4 d g c,4 | d d g2 | }
}
songChords = \chords {
  \globalChordSymbols
  g4 g g g d d g g g e:m c a:m
  g d:7 g g g g d d d d g g g g
  c g d g d d e:m d g c g/d d g
}

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l Take my life, and let it be
  con -- se -- crat -- ed, \l Lord, to thee.
  Take my mo -- ments and my days;
  let them \l flow in cease -- less praise,
  let them flow in cease -- less praise.
}
verseB = \tag #'verseB \lyricmode {
  Take my hands, and let them move at the im -- pulse of thy love.
  Take my feet, and let them be swift and beau -- ti -- ful for thee,
  swift and beau -- ti -- ful for thee.
}
verseC = \tag #'verseC \lyricmode {
  Take my in -- tel -- lect and use ev -- 'ry pow'r as thou shalt choose.
  Take my lips, and let them be filled with mes -- sag -- es from thee,
  filled with mes -- sag -- es from thee,
}
verseD = \tag #'verseD \lyricmode {
  Take my sil -- ver and my gold; not a mite would I with -- hold.
  Take my will and make it thine; it shall be no lon -- ger mine,
  it shall be no lon -- ger mine.
}
verseE = \tag #'verseE \lyricmode {
  Take my love; my Lord, I pour at thy feet its trea -- sure store.
  Take my -- self, and I will be ev -- er, on -- ly, all for thee,
  ev -- er, on -- ly, all for thee.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "" \verseE }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_5verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
