\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
composer = \smallText "Music: James Ellor, 1838"
meter = \smallText "DIADEM CM extended"
hymnKey = \key a \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global_parts.ily"

%% SONG INFO
title = \titleText "All hail the power of Jesus' name"
poet = \smallText "Text: Edward Perronet, 1780, revised by John Rippon, 1787"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-04-21"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \transpose bf a {
    \relative g' {
      \partial 4 f4 | bf2 c4 | d8.( ef16 f4) bf, | c( bf) a | bf2 a8( g) | f4. 8 g g | \break
      f4( bf) bf | g( ef') 4 | d2 c4 | bf2 8( c) | d2 4 | 4( c) bf | c( bf) a | bf8.( c16 d4) \bar "" \break
      f4 | ef4.( d8 c ef | d4. c8 bf d | c4. bf8 a c | bf4) 4 r4 | \break
      ef4 4 r4 | c4 4 r4 | d4 4 f | bf,8.( c16 d4) ef | d2 c4 | \partial 2 bf2 \bar "|."
    }
  }
}
alto = {
  \globalParts
  \transpose bf a {
    \relative e' {
      d4 | f2 4 | 2 g4 | 4( f) ef | d2 f8( ef) | d4. 8 ef ef |
      d2 f4 | ef4( g) g | f2 ef4 | d2 8( ef) | f2 4 | fs2 g4 | 4( f) ef |
      d8.( ef16 f4) af | g4.( f8 ef g | f4. ef8 d f | ef4. d8 c ef | d4) d r4 |
      g4 g r4 | f4 4 r4 | f f f f2 g4 | bf2 a8( f) | 2 |
    }
  }
}
tenor = {
  \globalParts
  \transpose bf a {
    \relative a {
      bf4 | d( bf) a | bf8.( c16 d4) d | ef( d) c | bf2 \pa c8( a) | bf4. 8 8 8 |
      2 \pt d4 | ef( bf) bf | 2 a4 | bf2 4 | 2 4 | d2 4 | ef( d) c |
      bf2 d4 | ef bf r4 | bf4 4 r4 | a4 4 r4 | \pa bf4 4 r4 |
      bf4 4 r4 | a4 4 r4 | bf4 4 d | 8.( c16 bf4) 4 | 8( d f4) \pt ef4 | d2 |
    }
  }
}
bass = {
  \globalParts
  \transpose bf a {
    \relative d {
      bf4 | 4( d) f | bf2 g4 | ef( f) f | bf,2 r4 | r2 r4 |
      r2 bf4 | ef2 c4 | f2 4 | bf,2 4 | bf'2 4 | a2 g4 | ef4( f) f |
      bf,2 bf'4 | ef,4 4 r4 | bf4 4 r4 | f'4 4 r4 | bf4.( a8 g f |
      ef4. d8 c bf | f'4. g8 a f | bf4) 4 r4 | r4 r8 bf8 ef, ef | f2 4 | bf,2 |
    }
  }
}
songChords = \chords {
  \globalChordSymbols
  \transpose bf a {
    bf4 | 2 f4 bf2 g4:m c:m bf f:7 | bf2 r4 | s2.
    s2 bf4 | ef2 c4:m7 bf2/f f4:7 | bf2. bf2. d2 g4:m | c:m bf f:7
    bf2 bf4:7 | ef2. bf f:7 bf ef
    f bf bf2 ef4 | bf2/f f4:7 | bf2 |
  }
}

%% LYRICS
verseA = \lyricmode {
  \l All hail the pow’r of Je -- sus’ name!
  Let an -- gels pros -- trate \l fall,
  let an -- gels pros -- trate \l fall.
  Bring forth the roy -- al di -- a -- \l dem,
  %% CHORUS
  and crown __ him, crown him, crown him,
  crown him, and crown him Lord of all
}
verseB = \lyricmode {
  Let ev -- 'ry kin -- dred, ev -- 'ry tribe,
  on this ter -- res -- trial ball,
  on this ter -- res -- trial ball,
  to him all maj -- es -- ty as -- cribe,
  \SB {
    %% CHORUS
    and crown him, crown him, crown him,
    crown him, and crown him Lord of all
  }
}
verseC = \lyricmode {
  Oh, that with yon -- der sa -- cred throng
  we at his feet may fall,
  we at his feet may fall!
  We'll join the ev -- er -- last -- ing song,
  \SC {
    %% CHORUS
    and crown him, crown him, crown him,
    crown him, and crown him Lord of all
  }
}
spacingVerse = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ "\t"
}

tenorWords = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _
  and crown him, crown him, crown him, crown him,
}
bassWords = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ crown __ him, and crown him Lord of all.
}
bassSpacingVerse = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ "\t" "\t"
}

all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \new NullVoice = "tenor" {\removeWithTag #'midionly \tenor}
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC } }
  \new Lyrics  \lyricsto tenor  { \globalLyrics "" "" \tenorWords }
>>

bottom_verses = <<
  \new NullVoice = "bass" \bass
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \bassSpacingVerse }
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \bassWords }
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \bassSpacingVerse }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides_book_3verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"