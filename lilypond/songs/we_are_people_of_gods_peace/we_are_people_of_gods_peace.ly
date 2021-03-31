\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Johann Horn, 1544, alt. 1584"
meter = \smallText "AVE VIRGO VIRGINUM (GAUDEAMUS PARITER) 76.76 D"
hymnKey = \key g \major
hymnTime = \time 12/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "We are people of God's peace"
poet = \smallText "Text: based on Menno Simons, alt. David Augsburger, 1978"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-03-24"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative g' {
    g4 g d d g a \partial 2 b2 | e d c4 b a2 g1 | \break
    g4 g d d g a \partial 2 b2 | e d c4 b a2 g1 | \break
    d'2 e d4 c bf4 4 \partial 2 a2 | b a4 g2 fs4 e2 \partial 2 d | \break
    g4 g d d g a \partial 2 b2 | e d c4 b a2 g1 | \break
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    d4 d d d e fs g2 | g fs e4 d d2 b1 |
    d4 d d d e fs g2 | g fs e4 d d2 b1 |
    g'2 g fs4 e d d d2 | g e4 d2 4 cs2 d |
    b4 b d d e fs g2 | g2 2 4 4 e( d) b1 |
  }
}
tenor = {
  \globalParts
  \override Staff.TimeSignature #'stencil = ##f
  \relative a {
    b4 b a a b d d2 | c a g4 g g(fs) g1 |
    b4 b a a b d d2 | c a g4 g g(fs) g1 |
    b2 c a4 g g g fs2 | d'2 c4 b2 a4 2 fs |
    g4 g a a b d d2 | c d g,4 4 4( fs) g1 |
  }
}
bass = {
  \globalParts
  \relative d {
    g4 g fs4 4 e d g2 | c, d e4 g d2 g,1 |
    g'4 g fs4 4 e d g2 | c, d e4 g d2 g,1 |
    g'2 c, d4 e g g, d'2 | g, a4 b2 d4 a2 d |
    e4 e fs fs e d g2 | c, b e4 d c(d) g,1 |
  }
}
songChords = \chords {
  \globalChordSymbols
  g2  d e4:m d g2 c d c d g g
  g2  d e4:m d g2 c d c d g g
  g c d g d g g g a d
  e:m d e4:m d g2 c g c d g g
}

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  We are peo -- ple of God's peace
  as a new cre -- a -- tion.
  \l Love u -- nites and strength -- ens us
  at this cel -- e -- bra -- tion.
  \l Sons and daugh -- ters of the Lord,
  ser -- ving one a -- noth -- er,
  \l a new cov -- e -- nant of peace
  binds us all to -- geth -- er.
}
verseB = \tag #'verseB \lyricmode {
  We are chil -- dren of God's peace
  in this new cre -- a -- tion,
  spread -- ing joy and hap -- pi -- ness
  through God's great sal -- va -- tion.
  Hope we bring in spir -- it meek,
  in our dai -- ly liv -- ing.
  Peace with ev -- 'ry -- one we seek,
  good for e -- vil giv -- ing.
}
verseC = \tag #'verseC \lyricmode {
  We are ser -- vants of God's peace,
  of the new cre -- a -- tion.
  Choos -- ing peace, we faith -- ful -- ly
  serve with heart's de -- vo -- tion.
  Je -- sus Christ, the Prince of Peace,
  con -- fi -- dence will give us.
  Christ the Lord is our de -- fense;
  Christ will nev -- er leave us.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

%% All sheet music outputs
shapeStaffZoom = #1.1
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
