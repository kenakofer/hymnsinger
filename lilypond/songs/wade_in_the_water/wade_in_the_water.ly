\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: African American Spiritual"
meter = \smallText "WADE IN THE WATER irregular with refrain"
hymnKey = \key e \minor
hymnTime = \time 4/4
quarternoteTempo = 106
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Wade in the water"
poet = \smallText "Text: African American Spiritual"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-03-20"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { e2~ 8 g4 e8 | g4. e8~ 2 | b'2~ 8 ds4 8 | e4 d b8( a) g4 | } \break
  \relative g' { e2~ 8 g4 e8 | g4. e8~ 2 | e4 8 8 8 4 b8 | ds4. e8~ 2 \mark "Fine" \bar "|."  } \break
  \relative g' { g4^\markup { \italic Leader } e g e | b'8( a) g8 8( e2) | e4^\markup { \italic All } 8 8 8 4 b8 | \partial 2.. ds4. e8~ 4 r8 \bar "" }
  \relative g' { \partial 8 g8 | b4^\markup { \italic Leader } g b g8 g | b8( a) g8 8( e2) | e4^\markup { \italic All } 8 8 8 4 b8 | ds4. e8~ 2 \mark "D.C." |} \break
  \bar "||"
}
alto = {
  \globalParts
  \relative e' { b2~ 8 b4 c8 | b4. b8~ 2 | ds2~ 8 fs4 8 | g4 g ds ds | }
  \relative e' { b2~ 8 ds4 b8 | b4. c8~ 2 | b4 8 8 8 4 b8 | b4. b8~ 2 | }
  \relative e' { s1 s1 | b4 8 8 8 4 b8 | b4. b8~ 4 r8 s8 }
  \relative e' { s1 s1 | b4 8 8 8 4 b8 | b4. b8~ 2 | }
}
tenor = {
  \globalParts
  \relative a { g2~ 8 g4 g8 | b4. g8~ 2 | fs2~ 8 b4 8 | b4 b b b | }
  \relative a { g2~ 8 b4 g8 | g4. g8~ 2 | g4 8 8 8 4 g8 | fs4. g8~ 2 | }
  \relative a {r1 r1 | g4 8 8 8 4 g8 | fs4. g8~ 4 r8 r8 }
  \relative a {r1 r1 | g4 8 8 8 4 g8 | fs4. g8~ 2 | }
}
bass = {
  \globalParts
  \relative d { e2~ 8 e4 e8 | e4 e g,( a) | b2~ 8 b4 8 | e4 4 b4 4 | }
  \relative d { e2~ 8 b4 b8 | b4 a a( c) | e4 8 8 8 4 8 | b4. e8~ 2 | }
  \relative d { r1 r1 | e4 8 8 8 4 8 | b4. e8~ 4 r8 r8 }
  \relative d { r1 r1 | e4 8 8 8 4 8 | b4. e8~ 2 }
}
songChords = \chords {
  \set chordChanges = ##t
  e1:m e:m b e:m e:m e:m e:m b4.:7 e8:m e2:m
  e1:m e:m e:m b4.:7 e8:m e2:m
  e1:m e:m e:m b4.:7 e8:m e2:m
}

%% LYRICS
verseA = \lyricmode {
  Wade in the wa -- ter,
  wade in the wa -- ter, chil -- dren,
  wade in the wa -- ter.
  God's gon -- na trou -- ble the wa -- ter.

  \showVerseNumberAtLineStart "1" #4.5
  See that host all dressed in white,
  \hideVerseNumberAtLineStart
  God's gon -- na trou -- ble the wa -- ter.
  The lead -- er looks like the Is -- rael -- ite.
  God's gon -- na trou -- ble the wa -- ter.
}

bottomA = \lyricmode {
  _ _ _ _ _ oh, _ _ _ _ _ _ _
  _ _ _ _ _ oh,

}

spacingVerse = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  "\t" _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  "\t" _ _
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics \lyricsto soprano  { \globalLyrics "" "" \verseA }
  \new Lyrics \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

bottom_verses = <<
  \new NullVoice = "bass" \bass
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \bottomA }
>>

extra_verses = \markup {
  \fill-line {
    \hspace #-40.0 % moves the column off the left margin;
     % can be removed if space on the page is tight

     \column {
      \line { \bold "2."
        \column { % LYRICS-START
"See that band all dressed in red…"
"Looks like the band that Moses led…"
        }
      }
      \combine \null \vspace #0.4 % adds vertical spacing between verses
      \line { \bold "3."
        \column { % LYRICS-START
"If you don't believe I've been redeemed…"
"Just follow me down to Jordan's stream…"
        }
      }
    }
  }
}

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
