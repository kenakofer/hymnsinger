\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Philip P. Bliss, 1876"
%arranger = \smallText "arr. (optional), year"
meter = \smallText "VILLE DU HAVRE 11.8.11.9 with refrain"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 110
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "When Peace like a River"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Horatio G. Spafford, 1876"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-03-12"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 g4 | g2 f4 e | e2 d4 e | f( a) g f | e2. \bar "" } \break
  \relative g' { \partial 4 g4 | c2 b4 a | a2 g4 fs | g2. \bar "" } \break
  \relative g' { \partial 4 g4 | c2 4 b | a2 4 4 | d2 4 c | b2 \bar "" } \break
  \relative g' { \partial 2 a4 g | c2 4 4 | c2 b4. c8 | c2 \bar "||" } \break
  \relative g' { \partial 2 g4 g | 1~ | 2 4 4 | 1~ | 2 e4 g | a2 4 c | c2 b4. c8 | \partial 2. c2. } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { e4 | e2 d4 c | c2 b4 c | b2 4 d | c2. e4 | 2 d4 e4 | 2 d4 4 | d2. }
  \relative e' { f4 | e2 4 g | f2 a4 g | f2 4 fs | g2 4 4 | 2 c,4 d | e2 d4. e8 | e2 }
  \relative e' { r2 | r2 e4 e | d2 r2 | r2 d4 f | e2 c4 e | f2 4 4 | e2 d4. e8 | e2. }
}
tenor = {
  \globalParts
  \relative a { g4 | 2 4 4 | 2 4 4 | 2 4 b | c2. g4 | a2 gs4 a | c2 b4 a | b2. }
  \relative a { b4 | c2 4 4 | 2 4 cs | d2 4 4 | 2 c4 b | c2 g4 a | g2 4. 8 | 2 }
  \relative a { r2 | r2 g4 c | b2 r2 | r2 b4 d | c2 g4 c | c2 4 a | g2 4. 8 | 2 }
}
bass = {
  \globalParts
  \relative d { c4 | c2 4 8( e) | g2 f4 e | d2 g,4 g | c2. 4 | a2 b4 c | 2 d4 4 | g,2. }
  \relative d { g4 | c,2 4 e | f2 4 e | d2 4 4 | g2 4 8( f) | e2 4 f | g2 g,4. 8 | c2 }
  \relative d { r2 | r2 c4 e | g2 r2 | r2 g,4 4 | c2 4 4 | f2 4 4 | g2 g,4. 8 | c2. }
}
songChords = \chords {
  \globalChordSymbols
  c4 | c2 c c c g:7 g:7 c c a:m a:m a:m d g
  g c c f f d:m d:m g g c c c g c
  c c c g g g g:7 c c f f c/g g c

}

%% LYRICS
verseA = \lyricmode {
  \l When peace like a riv -- er at -- tend -- eth my way,
  \l when sor -- rows like sea bil -- lows roll,
  \l what -- ev -- er my lot, thou hast taught me to say,
  \l ''It is well, it is well with my soul.''
  %% CHORUS
  It is well __ with my soul, __ it is well, it is well with my soul.
}
verseB = \lyricmode {
  Though Sa -- tan should buf -- fet, though tri -- als should come,
  let this blest as -- sur -- ance con -- trol,
  that Christ hath re -- gard -- ed my help -- less es -- tate,
  and hath shed his own blood for my soul.
}
verseC = \lyricmode {
  Re -- deemed! Oh, the bliss of this glo -- ri -- ous thought:
  My sin– not in part, but the whole–
  is nailed to his cross, and I bear it no more,
  praise the Lord, praise the Lord, O my soul!
}
verseD = \lyricmode {
  And, Lord, haste the day when my faith shall be sight,
  the clouds be rolled back as a scroll,
  the trum -- pet shall sound, and the Lord shall de -- scend,
  e -- ven so, it is well with my soul.
}
altoRefrain = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  It is well with my soul,
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  \new NullVoice = "alto" \alto
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  \new Lyrics  \lyricsto alto  { \globalLyrics "" "" \altoRefrain }
>>

%% All sheet music outputs
tradStaffZoom = #.9
shapeStaffZoom = #1
clairStaffZoom = #.85
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
