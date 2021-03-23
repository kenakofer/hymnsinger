\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Peter C. Lutkin, 1900"
%arranger = \smallText "arr. Name, year"
meter = \smallText "FAREWELL ANTHEM irregular"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 85
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "The Lord bless you and keep you"
poet = \smallText "Text: based on Numbers 6:24-26, Peter C. Lutkin, 1900"
copyright = \public_domain_notice "Kenan Schaefkofer"
postscore_text = \postscoreText "*Or, ''May God bless you and keep you; / may God lift her countenance upon you,''"
verseCount = 1
tags = "english theist 4part"
dateAdded = "2021-03-22"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 g4 | 2 e4 c8 8 | d4( f) e4. g8 | 4 e8 g c8. b16 a8 e | } \break
  \relative g' { g4( fs) g4 r4 | r8 e8 f e a4 r4 | } \break
  \relative g' {  r8 g8 a g c r8 r g | g( e) g c e8. c16 g8 e | g4( f) e e8 a | } \break
  \relative g' { a2~ 8 g e g | c4. 8 4 a | r r8 a g4. c,8 | a' g r4  g4 f | e2 d | } \break
  \relative g' { c,4 r4 r2 | r1 | r4 b'4( e d) | c e( g f | e d c b) | } \break
  \relative g' { a2. b8( a) | g2. a8( g | f4 d) g( a) | g1 | 1 |} \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { c4 | 2 4 8 8 | 4( b) c4. e8 | 4 c8 e e8. 16 8 8 | d2 d4 r4 | r8 cs cs cs d4 r |}
  \relative e' { r8 d d d c \pa g' g( f) | e( c) e4 \pt 8. 16 8 c | e4( d) c \pa r | r c8 d e e r4 | r4 f8 g \pt a4 f |}
  \relative e' { r4 r8 c8 4. 8 | 8 8 r4 cs4 d | c2 b | c4 r r2 | \pa r4 c( f e) | d2 e(~ | 4 fs) g2 | }
  \relative e' { g4( gs) a( e~ | e) f8( e) d2~ | 4 e8( d) cs2 | d4( b c2~ | 4 d8 c b2) | c1 }
}
tenor = {
  \globalParts
  \relative a { e4 | 2 g4 e8 8 | a4( g) g4. c8 | 4 g8 8 a8. gs16 a8 8 | b4( a) b \pa r | r8 \pt a8 8 8 4 r4 | }
  \relative a { r8 b8 c b c g a( b) | c4 4 \pt 8. 16 8 8 | 4( b) c \pt r | r a8 b c c r4 | r c8 bf a4 c | }
  \relative a { r4 r8 c8 bf4. 8 | 8 8 r4 a a | g2. f4 | e \pa g( c b) | a a( d c) \pt | b2 g4( a8 b) | }
  \relative a { c2 b4( c8 d) | e2.( b4) | c4( d8 c b2~ | 4 c8 b) a2 | a4( af g fs) | f2 f | e1 }
}
bass = {
  \globalParts
  \relative d { c4 | 2 4 8 8 | f,4( g) c4. 8 | 4 8 8 a8. b16 c8 8 | d2 g8 8 8 8 | 2( f8) 8 8 8 | }
  \relative d { f2( e8) 8 d4 | c8( c') g( e) c8. g'16 8 8 | g4( gs) a r | r f8 8 e e r4 | r d8 e f4 4 | }
  \relative d { r4 r8 f e4. 8 | f e r4 e d | g,2 2 | c4 r c( d8 e) | f2 d4( e8 f) | g2 e4( f8 g) | }
  \relative d { a'2 g4( a8 b | c4 b a g) | f2. g8( f) | e2. f8( e | d4 f e ef) | d2 g, | c1 | }
}

%% LYRICS
verseA = \lyricmode {
  "*The" Lord bless you and keep you;
  the Lord lift his coun -- te -- nance up -- on you,
  and give you peace, and give you peace;
  the Lord make his face to shine up -- on you,
  and be gra -- cious, and be gra -- cious,
  the Lord be gra -- cious, gra -- cious un -- to you.

  A -- men, a -- men, a -- men, a -- men, a -- men.
}
sopranoLyrics = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _
  the Lord make his _ _ _ _ _ _
  and be gra -- cious un -- to you, be gra -- cious _ _ _ _ _ _ _ _ _ _
  A -- men, a -- men, a -- men, a -- men, a -- men.
}
tenorLyrics = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  A -- men, a -- men, a -- men, a -- men, a -- men, a -- men, a -- men.
}
bassLyrics = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  and give you peace, and give you peace;
  _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  A -- men, a -- men, a -- men, a -- men, a -- men, a -- men, a -- men.
}
spacingLyrics = \lyricmode {
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t"
  "\t" "\t" "\t"
  "\t" "\t" "\t"
  "\t" "\t" "\t"
  "\t" "\t" "\t"
  "\t" "\t" "\t"
  "\t" "\t" "\t"
  "\t" "\t" "\t"
}

padding = {
  \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #1.5
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  \new NullVoice = "alto" \alto
  \new NullVoice = "tenor" \tenor
  \new NullVoice = "bass" \bass
  \new Lyrics \with \padding \lyricsto alto  { \globalLyrics "" "" \verseA }
  \new Lyrics \with \padding \lyricsto tenor  { \globalLyrics "" "" \tenorLyrics }
>>

top_verse = { \context Lyrics = "topVerse" \lyricsto soprano { \globalLyrics "" "" \sopranoLyrics } }

bottom_verses = <<
  \new NullVoice = "bass" \bass
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \bassLyrics }
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \spacingLyrics }
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \spacingLyrics }
  \new Lyrics  \lyricsto bass  { \globalLyrics "" "" \spacingLyrics }
>>

%% All sheet music outputs
clairStaffZoom = #1
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
