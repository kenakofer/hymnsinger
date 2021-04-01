\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Guatemalan traditional"
meter = \smallText "LA PAZ DE LA TIERRA 87.97.76"
hymnKey = \key c \major
hymnTime = \time 2/2
quarternoteTempo = 110
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "La paz de la tierra (The peace of the earth)"
poet = \smallText "Text: Spanish; Guatemalan traditional; trans. Kenan Schaefkofer, 2021"
typesetter = "Kenan Schaefkofer"
verseCount = 1
tags = "spanish english secular 4part"
dateAdded = "2021-03-09"
\include "../../lib/header.ly"

%% NOTES

%% With shorter note values, this aligns better with the spanish lyrics. This part is not displayed.
soprano_spanish = {
  \globalParts
  \phrasingSlurSolid
  \relative g' { \partial 4 e4 | a4 8 8 4 b4 | c4 b c a4 | g4 8 a e4 d4 | \partial 2. e2. \bar "" } \break
  \relative g' { \partial 4 e4 | a4 8 8 4 b4 | c4 b c a | g4 8 a e4 d4 | e2. r4 } \break
  \relative g' { c2. 4 | b2 4 4 | a4 g e g | a2. r4 } \break
  \relative g' { c2. 4 | b2 4 4 | a4( g) e g | \partial 2. a2. | } \break
  \bar "|."
}

soprano = {
  \globalParts
  \phrasingSlurSolid
  \relative g' { \partial 4 e4 | a4 8 8 4 b4 | c4 b c a4 | g4 8 a e4 d4 | \partial 2. e2. \bar "" } \break
  \relative g' { \partial 4 e4 | a4 8 8 4 b4 | c4 b c a | g4 8 a e4 d4 | e2. r4 } \break
  \relative g' { c1 | b1 | a4 g e g | a2. r4 | } \break
  \relative g' {  c1 | b1 | a4( g) e g | \partial 2. a2. | } \break
  \bar "|."
}
alto = {
  \globalParts
  \tieDashed
  \relative e' { s4 | s1 s s s s s s s }
  \relative e' { g1 | g1 | e4 e e d | e2. r4 } \break
  \relative e' { g1 | g1 | e2 e4 d | e2. | } \break
}
tenor = {
  \globalParts
  \relative a { s4 | s1 s s s s s s s }
  \relative a { e'1 | d1 | c4 c b b | c2. r4 } \break
  \relative a { e'1 | d1 | c2 b4 b | cs2. } \break
}
bass = {
  \globalParts
  \relative d { s4 | s1 s s s s s s s }
  \relative d { c1 | g'1 | a4 a e e | a2. r4 } \break
  \relative d { c1 | g'1 | a2 e4 e | a,2. } \break
}

songChords = \chords {
  \globalChordSymbols
  s4 | a1:m f g e2:sus e2 |
  a1:m f g e2:sus e2 |
  c1 g a2:m e2:m a1:m |
  c1 g a2:m e2:m a2.
}


%% LYRICS
verseA = \lyricmode {
  \l La paz de la tierra es -- té con -- ti -- go,~la paz de los cielos tam -- bién.
  \l La paz de los ríos es -- té con -- ti -- go,~la paz de los mares tam -- bién.
  \l Paz pro -- fun -- da ca -- yen -- do so -- bre ti.
  \l Paz pro -- fun -- da cre -- cien -- do en ti.
}
verseB = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  The peace of the earth _ be with you, the peace of the heav -- ens too;
  The peace of the riv -- ers be with you, the peace of the o -- ceans too.
  Deep peace fall -- ing o -- ver you.
  Deep peace grow -- ing in you.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  \new NullVoice = "soprano_spanish" \soprano_spanish
  \tag #'verseA { \new Lyrics \lyricsto soprano_spanish  { \globalLyrics "" "" \verseA } }
  \tag #'verseB { \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "" "" \verseB } }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_2verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
