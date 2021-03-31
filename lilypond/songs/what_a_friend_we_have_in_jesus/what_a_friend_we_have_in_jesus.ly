\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Charles C. Converse, 1868"
meter = \smallText "CONVERSE 87.87 D"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "What a friend we have in Jesus"
poet = \smallText "Text: Joseph M. Scriven, 1855, alt."
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-03-19"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { c4. 8 d c a f | f2 d4 r4 | c4. f8 a f c' a | g2. r4 | } \break
  \relative g' { c4. 8 d c a f | f2 d4 r4 | c4. f8 a g f e | f2. r4 | } \break
  \relative g' { g4. fs8 g a bf g | a2 c4 r | d4. 8 c a bf a | g2. r4 | } \break
  \relative g' { c4. 8 d c a f | f2 d4 r4 | c4. f8 a g f e | f2. r4 | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4. 8 8 8 8 c | d2 bf4 r | c4. 8 8 8 f f | e2. r4 | }
  \relative e' { f4. 8 8 8 8 c | d2 bf4 r | a4. c8 f c c c | c2. r4 | }
  \relative e' { e4. ds8 e f g e | f2 4 r | f4. 8 8 8 g f | e2. r4 | }
  \relative e' { f4. 8 8 8 8 c | d2 bf4 r | a4. c8 f c c c | c2. r4 | }
}
tenor = {
  \globalParts
  \relative a { a4. 8 bf a c a | bf2 f4 r | a4. 8 8 8 8 c | 2. r4 | }
  \relative a { a4. a8 bf a c a | bf2 f4 r | f4. a8 c bf a g | a2. r4 | }
  \relative a { c4. 8 8 8 8 8 | 2 a4 r | bf4. 8 c c c c | c2. r4 | }
  \relative a { a4. a8 bf a c a | bf2 f4 r | f4. a8 c bf a g | a2. r4 | }
}
bass = {
  \globalParts
  \relative d { f4. 8 8 8 8 8 | bf,2 4 r4 | f'4. 8 8 8 8 a | c2. r4 | }
  \relative d { f4. 8 8 8 8 8 | bf,2 4 r4 | c4. 8 8 8 8 8 | f2. r4 | }
  \relative d { c4. 8 8 8 8 8 | f2 4 r4 | bf4. 8 a f e f | c'2. r4 | }
  \relative d { f4. 8 8 8 8 8 | bf,2 4 r4 | c4. 8 8 8 8 8 | f2. r4 | }
}
songChords = \chords {
  \globalChordSymbols
  f2 f bf bf f f c c
  f f bf bf f c:7 f f
  c c f f bf f c c
  f f bf bf f c:7 f f
}

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l What a friend we have in Je -- sus, all our sins and griefs to bear!
  \l What a priv -- i -- lege to car -- ry ev -- 'ry -- thing to God in prayer!
  \l Oh, what peace we of -- ten for -- feit, oh, what need -- less pain we bear,
  \l all be -- cause we do not car -- ry ev -- 'ry -- thing to God in prayer!
}
verseB = \tag #'verseB \lyricmode {
  Have we tri -- als and temp -- ta -- tions? Is there trou -- ble an -- y -- where?
  We should nev -- er be dis -- cour -- aged– take it to the Lord in prayer!
  Can we find a friend so faith -- ful, who will all our sor -- rows share?
  Je -- sus knows our ev -- 'ry weak -- ness– take it to the Lord in prayer!
}
verseC = \tag #'verseC \lyricmode {
  Are we weak and heav -- y la -- den, 'cum -- bered with a load of care?
  Pre -- cious Sav -- ior, still our ref -- uge, take it to the Lord in prayer!
  Do thy friends de -- spise, for -- sake thee? Take it to the Lord in prayer!
  Je -- sus' arms will take and shield thee– thou wilt find a sol -- ace there.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_3verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
