\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Louis Bourgeois, Genevan Psalter, 1551"
meter = \smallText "OLD HUNDREDTH LM"
hymnKey = \key g \major
hymnTime = \time 4/4
quarternoteTempo = 100
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Praise God (Doxology)"
poet = \twoLineSmallText "Text: Thomas Ken, A Manual of Prayers, 1695, alt." "Spanish tr. anon.; French tr. anon.; German tr. anon."
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 1
tags = "english french spanish german christian 4part"
dateAdded = "2021-03-30"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 g4 | g fs e d | g a \m b2. b4\fermata \bar ""
    \partial 4 b4 | b b a g | c b \m a2. a4\fermata \bar "" \break
    \partial 4 g4 | a b a g | e fs \m g2. g4\fermata \bar ""
    \partial 4 d'4 | b g a c | \partial 2. b a \m g2. g4\fermata \bar "||" \m {g1 g } {g2 g}
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d4 | d d b b | b d \m d2. d4
    d4 | d g fs g | g g \m fs2. fs4
    g4 | fs g fs d | e d \m d2. d4
    d4 | d g fs e8( fs) | g4 fs \m g2. g4 | \m {e1 d} {e2 d}
  }
}
tenor = {
  \globalParts
  \relative a {
    b4 | b a g fs | g fs \m g2. g4
    g4 | b d d b | e d \m d2. d4
    b4 | d d d d | c8( b) a4 \m b2. b4
    b4 | g b d e | d d8( c) \m b2. b4 | \m {c1 b} {c2 b}
  }
}
bass = {
  \globalParts
  \relative d {
    g4 | g d e b | e d \m g,2. g4_\fermata
    g'4 | g g | d e | c g \m d'2. d4_\fermata
    e4 | d g d b | c d \m g,2. g4_\fermata
    g'4 | g e d a | b8( c) d4 \m g,2. g4_\fermata | \m {c1 g} {c2 g}
  }
}
songChords = \chords {
  \globalChordSymbols
  g4 | g d e:m b:m e:m d g
  g | g g d e:m c g d
  e:m | d g d g c d g
  g | g e:m d a:m g d g
  c c g g
}

%% LYRICS
verseA = \lyricmode {
  \l Praise God from whom all bless -- ings flow;
  praise God all crea -- tures here be -- low;
  \l praise God a -- bove, ye heav'n -- ly host;
  praise Fa -- ther, Son, and Ho -- ly Ghost.
  %% CHORUS
  %% A -- men
}
verseB = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  Gloire à Dieu, no -- tre Cré -- a -- teur;
  Gloire à Christ, no -- tre Ré -- demp -- teur;
  Gloire à l'Es -- prit, Con -- so -- la -- teur!
  Lou -- ange et gloire à Dieu Sau -- veur.
  %% CHORUS
  A -- men
}
verseC = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  A la Di -- vi -- na Tri -- ni -- dad,
  to -- do un -- i -- dos a -- la -- bad,
  con al -- e -- gri -- a,~y gra -- ti -- tud,
  su~a -- mor y gra -- cia cel -- e -- brad.
  %% CHORUS
  %% A -- men
}
verseD = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  Ehr sei dem Va -- ter und dem Sohn
  dem Heil -- 'gen Geist in ei -- nem Thron,
  der hei -- li -- gen Drei -- ei -- nig -- keit,
  sei Lob und Preis in E -- wig -- keit.
  %% CHORUS
  %% A -- men
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "  English:" "" \verseA }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "  French:" "" \verseB }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "  Spanish:" "" \verseC }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "  German:" "" \verseD }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"