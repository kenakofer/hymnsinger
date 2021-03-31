\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: trope melody, 15th c."
%arranger = \smallText "arr. Name, year"
meter = \smallText "VENI EMMANUEL LM with refrain"
hymnKey = \key e \minor
hymnTime = \time 11/8
quarternoteTempo = 65
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "O come, O come, Immanuel"
poet = \twoLineSmallText "Text: anon., O Antiphons, 8th-9th c.; Veni, veni Emmanuel, 12th c." "tr. v.1-5 John M. Neale, 1851, alt.; v.6-7 Henry Sloane Coffin, 1916"
typesetter = "Kenan Schaefkofer"
verseCount = 7
tags = "english christian winter 4part"
dateAdded = "2021-03-21"
\include "../../lib/header.ly"

%% NOTES
halfBar = \override Staff.BarLine #'bar-extent = #'(0 . 2)
wholeBar = \override Staff.BarLine #'bar-extent = #'(-2 . 2)

soprano = {
  \globalParts
  \hide Stem
  \override Staff.TimeSignature #'stencil = ##f
  \relative g' { e8 g b b b a( c b) a \tweak duration-log #1 g4 \halfBar | a8 b g e g a( fs e) d \tweak duration-log #1 e4 | } \break
  \relative g' { a8 a e e fs g( fs) e \partial 4 \tweak duration-log #1 d4 | g8 a b b b a( c b) \partial 2 a \tweak duration-log #1 g4 s8 \wholeBar} \break
  \undo \hide Stem
  \bar "||"
  \relative g' { d'8 4. b8 4. 8 a[( \partial 2 c b]) a g \halfBar | a b[ g] e[ g] a[( fs e]) d \partial 2 e2 \wholeBar} \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { s8 s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s }
  \relative e' { g8 fs4. g8 fs4. g8 4. fs8 e d d[ d] c[ d] e[( c b]) b b2 }
}
tenor = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative a { s8 s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s }
  \relative a { b8 a4. e'8 d4. e8 4( d8) d b a g[ g] g[ b] a4( g8) fs g2 }
}
bass = {
  \globalParts
  \relative d { s8 s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s }
  \relative d { g8 d4. e8 b4. e8 c[( a b]) d e fs g[ b,] c[ b] c[( a b]) b e2 }
}

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  O come, O come, Im -- man -- u -- el,
  and ran -- som cap -- tive Is -- ra -- el,
  \l that mourns in lone -- ly ex -- ile here,
  un -- til the Son of God ap -- pear.
  %% CHORUS
  Re -- joice! Re -- joice!
  Im -- man -- u -- el shall come to thee, O Is -- ra -- el.
}
verseB = \tag #'verseB \lyricmode {
  O come, O come, thou God of law,
  in cloud and maj -- es -- ty and awe.
  Thy pre -- cepts, taught on Si -- nai's height,
  call us to lives both just and right.
}
verseC = \tag #'verseC \lyricmode {
  O come, thou Rod of Jes -- se, free
  thine own from Sa -- tan's tyr -- an -- ny.
  From depths of hell thy peo -- ple save,
  and give them vic -- t'ry o'er the grave.
}
verseD = \tag #'verseD \lyricmode {
  O come, thou Day -- spring, come and cheer
  our spir -- its by thine ad -- vent here.
  Dis -- perse the gloom -- y clouds of night,
  and death's dark shad -- ow put to flight.
}
verseE = \tag #'verseE \lyricmode {
  O come, thou Key of Da -- vid come
  and o -- pen wide our heav'n -- ly home.
  Make safe the way that leads to thee
  and close the path to mis -- er -- y.
}
verseF = \tag #'verseF \lyricmode {
  O come, thou Wis -- dom from on high,
  and or -- der all things far and nigh.
  To us the path of knowl -- edge show,
  and cause us in thy ways to go.
}
verseG = \tag #'verseG \lyricmode {
  O come, De -- sire of na -- tions, bind
  all peo -- ples in one heart and mind.
  Bid en -- vy, strife and quar -- rels cease,
  and fill the world with heav -- en's peace.
}
spacingVerse = \lyricmode {
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics \with \dropLyricsMedium \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics \with \dropLyricsMedium \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  \new Lyrics \with \dropLyricsMedium \lyricsto soprano  { \globalLyrics "5" "" \verseE }
  \new Lyrics \with \dropLyricsLarge \lyricsto soprano  { \globalLyrics "6" "" \verseF }
  \new Lyrics \with \dropLyricsLarge \lyricsto soprano  { \globalLyrics "7" "" \verseG }
  \new Lyrics \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
  \new Lyrics \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
