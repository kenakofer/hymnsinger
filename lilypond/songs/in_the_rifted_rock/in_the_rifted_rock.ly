\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: W. Warren Bentley, 1879"
%arranger = \smallText "Arranged by (optional), year"
meter = \smallText "RIFTED ROCK 87.87 with refrain"
hymnKey = \key e \major
hymnTime = \time 3/2
quarternoteTempo = 140
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "In the Rifted Rock (Wehrlos und verlassen)"
%subtitle = \smallText "Optional"
poet = \smallText "Text: English; Mary Dagworthy James, 1878; German; Carl Röhl, 1895"
copyright = \public_domain_notice "Kenan Schaefkofer"
tags = "christian 4part acapella 4verse musicbyother textbyother"
dateAdded = "2021-03-12"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 2 e4 fs | gs2 gs fs4 e | gs2 b cs4 4 | b2 gs fs4 e | \partial 1 fs2. r4 \bar "" } \break
  \relative g' { \partial 2 e4 fs | gs2 gs fs4 e | gs2 b cs4 4 | b2 gs fs4 fs | \partial 1 e2. r4 \bar "" } \break
  \relative g' { \partial 2 b4 b | e2 b gs4 gs | b2 gs gs4 4 | fs2 gs a4 gs | \partial 1 fs2. r4 \bar "" } \break
  \relative g' { \partial 2 b4 b | e2 b gs4 gs | b2 gs cs4 4 | b2 gs fs4 4 | \partial 1 e2. r4 \bar "" } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { e4 ds | e2 2 ds4 e4 | 2 gs a4 a | gs2 e b4 e | ds2. r4 | }
  \relative e' { e4 ds | e2 2 ds4 e4 | 2 gs a4 a | gs2 e ds4 4 | e2. r4 | }
  \relative e' { gs4 4 | 2 2 e4 e | 2 2 4 4 | ds2 e fs4 e | ds2. r4 }
  \relative e' { gs4 4 | 2 2 e4 e | 2 2 4 4 | e2 e ds4 4 | e2. r4 }
}
tenor = {
  \globalParts
  \relative a { gs4 a | b2 2 a4 gs | b2 e e4 4 | 2 b b4 as | b2. r4 }
  \relative a { gs4 a | b2 2 a4 gs | b2 e e4 4 | 2 b b4 a | gs2. r4 }
  \relative a { e'4 e | b2 e b4 b | gs2 b b4 4 | 2 2 4 4 | 2. r4}
  \relative a { e'4 e | b2 e b4 b | gs2 b a4 4 | gs2 b2 4 a4 | gs2. r4}
}
bass = {
  \globalParts
  \relative d { e4 e | 2 2 4 4 | 2 2 a,4 a | e'2 2 ds4 cs | b2. r4 }
  \relative d { e4 e | 2 2 4 4 | 2 2 a,4 a | b2 2 4 4 | e2. r4 }
  \relative d { e4 e | 2 2 4 4 | 2 2 4 4 | b2 e ds4 e | b2. r4 }
  \relative d { e4 e | 2 2 4 4 | 2 2 a,4 a | b2 2 4 4 | e2. r4 }
}
songChords = \chords {
  \set chordChanges = ##t
  e2 e e e e e a e e e b b
  e e e e e e a e/b e/b b:7 e e
  e e e e e e e b e b b
  b b e e e e e a e/b e/b b:7 e
}

%% LYRICS
verseA = \lyricmode {
  In the rift -- ed Rock I'm rest -- ing, safe -- ly shel -- tered, I a -- bide.
  There no foes nor storms as -- sail me, while with -- in the cleft I hide.
  %% CHORUS
  Now I'm rest -- ing, sweet -- ly rest -- ing, in the cleft once made for me.
  Je -- sus, bless -- ed Rock of ag -- es, I will hide my -- self in thee.
}
verseB = \lyricmode {
  Long pur -- sued by sin and Sa -- tan, wea -- ry, sad, I longed for rest.
  Then I found this heav'n -- ly shel -- ter, o -- pened in my Sav -- ior's breast.

}
verseC = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  Wehr -- los und ver -- las -- sen sehnt sich oft mein Herz nach stil -- ler Ruh';
  doch du de -- ckest mit dem Fit -- tich dei -- ner Lie -- be sanft mich zu.
  %% CHORUS
  Un -- ter dei -- nem sanf -- ten Fit -- tich find' ich Frie -- den, Trost und Ruh';
  denn du schir -- mest mich so freund -- lich, schü -- tzest mich und deckst mich zu.
}
verseD = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  Drückt mich Kum -- mer, Müh' und Sor -- ge, mei -- ne Zu -- flucht bist nur du,
  ret -- test mich aus al -- len Äng -- sten, trö -- stest mich und deckst mich zu.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "1" "" \verseC }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "2" "" \verseD }
>>
extra_verses = \markup {
  \fontsize #-1.5
  \fill-line {
    \hspace #-25.0 % moves the column off the left margin;
     % can be removed if space on the page is tight
     \vspace #0
     \column {
      \line {
        \raise #3
        \bold "3."
        \raise #3
        \column { % LYRICS-START
"Peace which passeth understanding,"
"joy the world can never give,"
"now in Jesus, I am finding;"
"in his smiles of love I live."
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \line { \bold "4."
        \column { % LYRICS-START
"In the rifted Rock I'll hide me,"
"till the storms of life are past"
"all secure in this blest refuge,"
"heeding not the fiercest blast."
        }
      }
    }
    \hspace #5.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \raise #3
        \italic
        \bold "3."
        \italic
        \raise #3
        \column { % LYRICS-START
"Sicher bin ich und geborgen,"
"denn bei dir ist süße Ruh';"
"mag es auch im Leben stürmen,"
"Herr, dein Fittich deckt mich zu."
        }
      }
      \combine \null \vspace #0.1 % adds vertical spacing between verses
      \italic
      \line { \bold "4."
        \column { % LYRICS-START
"Kommt dann meine letzte Stunde,"
"geh' ich ein zur ew'gen Ruh';"
"und du deckst mit deinen Flügeln"
"ewiglich dein Kindlein zu."
        }
      }
    }
  %\hspace #0.1 % gives some extra space on the right margin;
  % can be removed if page space is tight
  }
}

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
